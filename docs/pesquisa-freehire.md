# Pesquisa: freehire (busca de vagas e LinkedIn)

Análise do projeto open source `freehire` (`/home/fabio/Dev/freehire`, Go + SvelteKit, MIT) feita em 2026-11-19. Objetivo: ver como ele busca vagas e se analisa ou recomenda ajustes no perfil do LinkedIn. Nada foi alterado no freehire.

## Resumo

- O freehire agrega cerca de 4,9M de vagas direto dos ATS das empresas, sem recrutadores nem reposts.
- Ele não coleta vagas do LinkedIn. Usa o LinkedIn só para descobrir empresas que estão contratando.
- Ele não tem auditoria nem recomendação de ajustes do perfil do LinkedIn.

## Formas de buscar vagas

1. **Adapters de ATS (fonte principal).**
   - Um adapter por ATS em `internal/ingest/sources` (Workday, Greenhouse, Lever, Ashby, iCIMS e outros). São 160 plataformas e cerca de 3,8M de vagas.
   - Fluxo do ingest: fetch, normalize, dedup, upsert (`internal/pipeline`).
   - O catálogo `boards` tem uma linha por empresa (`company + provider + board`).
   - `cmd/ingest <provider>` roda como worker one-shot via cron.
2. **Agregadores e APIs de terceiros.** Adzuna, himalayas, trudvsem, Arc, Getro, Cutshort e outros. São 179 fontes e cerca de 938 mil vagas.
3. **Páginas de carreira de empresa.** 58 feeds diretos (Amazon, Apple, Google, Yandex, Sber). Cerca de 25 mil vagas.
4. **Telegram.** 97 canais. `cmd/tg-ingest` coleta os posts, `cmd/tg-extract` extrai a vaga com LLM e `internal/ingest/linksource` resolve os links de aplicação.
5. **Harvest de boards (descoberta de empresas).** `cmd/harvest-ats`, `harvest-boards`, `harvest-role`, `harvest-linkedin` e similares. Descobrem empresas novas e provam qual é o board ATS delas.
6. **Extensão de browser, MCP, CLI e API pública sem chave.** A extensão lê a vaga da página aberta. O MCP, a CLI e a API deixam agentes consultarem o catálogo.
7. **Busca no catálogo.**
   - Meilisearch com facetas vindas de dicionários curados (`internal/dict/classify`, `skilltag`, `location`). Valor desconhecido não gera tag, nunca chute.
   - Busca semântica com pgvector, busca com IA e alertas (email, Telegram, push).
   - Sinal de "ghost job" (`internal/job/ghost`): repost, idade e movimento da vaga, com a evidência junto.

## Uso do LinkedIn

### Descoberta de empresas (`cmd/harvest-linkedin`)

- Usa os endpoints públicos `jobs-guest`, sem login, com User-Agent próprio do projeto (sem fingir ser browser) e rate limit conservador.
- Worklist em `harvest/linkedin-queries.yml`. Campos: `keywords`, `location` (obrigatório, query sem mercado é recusada), `jobage` (padrão 7 dias) e `pages` (padrão 1).
- De cada resultado tira o nome da empresa, o site (JSON-LD `hiringOrganization.sameAs`, depois `Organization.sameAs` do perfil da empresa) e o id da vaga no ATS da empresa (`identifier.value`, presente em cerca de metade das vagas).
- Cada empresa vira um candidato único, e empresas já presentes no catálogo são descartadas antes de qualquer request.
- Query que retorna vazio gera warning. Se todas retornam vazio, o comando sai com erro, porque bloqueio ou mudança de markup parece um mercado vazio.
- `harvest-ats` segue o site até o board. Há detecção de ATS self-hosted (`atsdetect.DetectSelfHosted`) para Radancy, Phenom, Jibe e Teamtailor.
- `harvest-boards` confirma o board: o slug derivado só é aceito se a API do ATS listar uma vaga viva com exatamente aquele id. Isso só vale para greenhouse, lever, ashby e recruitee, onde um request devolve a lista completa.
- O formato do id estreita o ATS: `teamtailor-<dígitos>` é teamtailor, 10 dígitos é greenhouse, UUID é lever ou ashby.
- Só o que foi validado na API do ATS entra em `sources/*.yml`. Nenhum dado do LinkedIn é persistido.
- O LinkedIn não entrega a URL de apply externa, o `applyUrl` legado nem links de ATS na descrição. Por isso o board é derivado e provado, não lido.
- Decisão de design: não ingerir vagas do LinkedIn como fonte do catálogo. Motivos: padrão de request denso, duplica o que já vem dos ATS e poria conteúdo do LinkedIn no banco.

### Login com LinkedIn (OIDC)

`internal/identity/auth/oauth/oidc.go`. Escopos `openid, email`, só identidade. Perfil completo exige o Partner Program do LinkedIn.

## Análise e ajustes do perfil do LinkedIn: não existe

Há três pontos relacionados, nenhum é auditoria de perfil:

- **`onboarding-linkedin-import`.** Só proposta em `openspec/changes/`. O pacote `internal/candidate/linkedinprofile` não existe no código.
  - O plano era ler o perfil público por URL (via `safehttp`, proxy `SOURCES_PROXY_URL`, allowlist de host, limite de bytes e `POST /api/v1/me/linkedin/import`).
  - O LinkedIn mascara cargos e descrições com asteriscos que preservam o tamanho da string. Foram 479 strings mascaradas no perfil testado. Só vêm legíveis o headline, o endereço, os idiomas, a foto, a primeira empresa e a primeira escola.
  - User-Agent de Googlebot, subdomínio de país, locale e o path `/details/experience/` retornam as mesmas máscaras.
  - O plano deriva cargo, nível, skills e localização do headline com os mesmos dicionários do CV. Exemplo medido: `Senior Backend Engineer working in TypeScript/Node.js, Go, and Python` virou `{senior, backend}` e skills `[nodejs, python, typescript]`.
  - Valores mascarados são descartados na fronteira do parser.
  - Sem proxy, a produção recebe 999 do LinkedIn. Com proxy, 200.
  - O doc manda o usuário exportar o PDF pelo "More → Save to PDF" para trazer o histórico completo.
  - Ler o perfil pela extensão com a sessão do usuário renderizaria o histórico completo, mas foi deixado como mudança futura.
  - Fornecedores pagos de enriquecimento (US$ 0,03 a 0,15 por perfil) foram rejeitados.
- **`internal/candidate/atscheck`.** Só verifica se o CV contém URL de LinkedIn (item de peso 2, "Add your LinkedIn profile URL near the top"). Não avalia o perfil.
- **`internal/candidate/coverletter/referral.go`.** Usa o LinkedIn só como ponto de contato para indicação.

As ferramentas de CV do freehire (match determinístico CV↔vaga, fit analysis com LLM, tailoring que não inventa nada, score de ATS) trabalham com o CV, não com o perfil do LinkedIn.

## Ideias para o ATSResumeOptimizer

- **Descoberta de empresas via `jobs-guest`.** Funciona sem login e dá empresa, site e id ATS. Seguir a mesma postura: User-Agent próprio, rate limit, falhar alto quando vier vazio e não persistir dados do LinkedIn.
- **Auditoria de perfil por headline** (ideia nossa, o freehire não faz isso). Rodar o headline por dicionários de cargo, nível e skills e checar se resolve. Se não resolve, o perfil está fraco para busca de recrutador.
- **Limite de leitura do perfil.** Fetch anônimo não traz cargos nem descrições. Para auditar o perfil inteiro, as opções são o PDF exportado, o texto colado pelo usuário ou a leitura pela extensão com a sessão dele.
- **Check do `atscheck`.** Hoje só confere presença da URL. Dá para estender para validar formato (`/in/<id>`) e consistência com o CV.
- **Match determinístico.** Comparar CV com vaga por dicionários curados, sem LLM, e recusar creditar o que o CV não prova. Útil como base de score.

## Referências no freehire

- `README.md`, `docs/features.md`, `docs/architecture.md`
- `cmd/harvest-linkedin/`, `harvest/linkedin-queries.yml`
- `openspec/specs/linkedin-board-discovery/spec.md`
- `openspec/changes/archive/2026-08-02-mine-ats-boards-from-linkedin/design.md`
- `openspec/changes/onboarding-linkedin-import/` (`proposal.md` e `design.md`)
- `internal/candidate/atscheck/atscheck.go`
- `internal/ingest/sources/`
