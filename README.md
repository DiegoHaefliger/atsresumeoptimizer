<div align="center">

# ATS Resume Optimizer

**Analise e adapte seu currículo a cada vaga para passar nos filtros de ATS.**

[![Última versão](https://img.shields.io/github/v/release/DiegoHaefliger/atsresumeoptimizer?label=vers%C3%A3o&color=2563eb)](https://github.com/DiegoHaefliger/atsresumeoptimizer/releases/latest)
[![Licença](https://img.shields.io/badge/licen%C3%A7a-PolyForm%20Noncommercial-6b7280)](LICENSE)
![Plataformas](https://img.shields.io/badge/Windows%20%C2%B7%20macOS%20%C2%B7%20Linux-4b5563)

[Baixar](https://github.com/DiegoHaefliger/atsresumeoptimizer/releases/latest) ·
[Instalação](#instalação) ·
[Primeiro uso](#primeiro-uso) ·
[Desenvolvedores](#para-desenvolvedores)

</div>

---

ATS (Applicant Tracking System) é o software que muitos recrutadores usam para filtrar candidatos antes de qualquer
pessoa ler o currículo. O ATS Resume Optimizer mostra como o seu currículo se sai contra uma vaga específica,
adapta o texto com ajuda de IA sem inventar experiência e acompanha o processo seletivo até o fim.

É gratuito e roda no seu computador. Os dados ficam nele; só o texto necessário vai para o provedor de IA que você escolher.

- [Para quem vai usar o app](#para-quem-vai-usar-o-app)
- [Para desenvolvedores](#para-desenvolvedores)

---

# Para quem vai usar o app

## O que o app faz

| Área | O que você consegue |
|------|---------------------|
| **Currículos** | Cadastrar, importar (PDF ou DOCX, até 2 MB), editar e guardar várias versões. |
| **Vagas** | Guardar a descrição colada da vaga, com palavras-chave e código para localizar depois. |
| **Análise ATS** | Nota de aderência à vaga, com achados por severidade, ortografia e semântica. |
| **Adaptação** | A IA ajusta o currículo à vaga, destaca as alterações e confere que nada foi inventado. Baixe em **PDF** ou **DOCX**. |
| **Assistente da vaga** | Perguntas técnicas prováveis de cair na entrevista, texto de apresentação e perguntas para fazer ao recrutador no fim da conversa. |
| **Processo seletivo** | Etapas, histórico, contato e agendamento, com agenda, aviso de conflito de horário e notificações. |
| **Google Agenda** | Opcional: os agendamentos viram eventos na sua agenda. |
| **Preferências** | Formato, remuneração, benefícios, local e empresas entram como critério na nota da vaga. |

Os currículos são analisados apenas em português do Brasil.

## Instalação

Não precisa instalar Java, banco de dados nem mais nada: o instalador já traz tudo.

Baixe o arquivo do seu sistema na [última versão](https://github.com/DiegoHaefliger/atsresumeoptimizer/releases/latest):

| Sistema                         | Arquivo                                     |
|---------------------------------|---------------------------------------------|
| Windows 10 ou 11                | `ats-resume-optimizer-<versão>-x64.msi`     |
| Mac com chip Apple (M1, M2...)  | `ats-resume-optimizer-<versão>-arm64.dmg`   |
| Mac com processador Intel       | `ats-resume-optimizer-<versão>-x64.dmg`     |
| Ubuntu, Debian, Mint            | `ats-resume-optimizer-<versão>-x64.deb`     |

Não sabe qual é o seu Mac? Menu Apple → **Sobre Este Mac**: se aparecer "Chip Apple M...", é o de chip Apple.

### Por que aparece um aviso de segurança

O app é gratuito e de código aberto, e não tem o certificado pago que Windows e macOS usam para reconhecer o
autor. Por isso o sistema avisa que não conhece o programa. Isso é esperado; siga os passos abaixo uma vez só.

Para conferir que o arquivo é o original, compare o SHA-256 com o `SHA256SUMS.txt` da mesma página de download.

### Windows

1. Abra o `.msi` baixado. Se o navegador avisar que o arquivo "não é baixado com frequência", escolha **Manter**.
2. Na tela azul "O Windows protegeu o computador", clique em **Mais informações** e depois em
   **Executar assim mesmo**.
3. Siga o instalador. Não pede senha de administrador.
4. Abra pelo atalho **ATS Resume Optimizer** na área de trabalho ou no menu Iniciar.

Se o Windows não mostrar o botão **Executar assim mesmo**, o **Controle Inteligente de Aplicativos** está
ligado e bloqueia programas sem certificado. Nesse caso não dá para instalar nesse computador.

### macOS

1. Abra o `.dmg` e arraste **ATS Resume Optimizer** para a pasta **Aplicativos**.
2. Abra o app pela pasta Aplicativos. Vai aparecer um aviso dizendo que a Apple não pôde verificá-lo: clique em
   **OK** (ou **Concluído**).
3. Abra **Ajustes do Sistema → Privacidade e Segurança**, role até o fim e clique em **Abrir Mesmo Assim** ao lado
   do nome do app. Confirme com a sua senha.
4. Das próximas vezes ele abre direto.

### Linux

Dê dois cliques no `.deb` para instalar pela central de programas, ou pelo terminal:

```bash
sudo apt install ./ats-resume-optimizer-<versão>-x64.deb
```

O app aparece no menu, na categoria Escritório.

## Primeiro uso

1. Ao abrir, aparece uma janela "está abrindo". Na primeira vez pode levar um minuto: é quando o banco de dados é
   criado.
2. O navegador abre sozinho com o app. Se não abrir, acesse <http://localhost:8080>.
3. Vá em **Configurações → Inteligência artificial**, escolha um provedor (OpenAI, Anthropic, Gemini ou
   compatível), cole a chave de API e clique em **Testar**. A chave fica guardada só no seu computador,
   criptografada.
4. Siga o fluxo: **Currículos** → cadastrar ou importar → **Vagas** (opcional) → **Preferências** (opcional) →
   **Nova análise** → **Adaptar currículo** na tela de resultado.

O app fica rodando até você fechá-lo. Para fechar, clique no ícone dele na área de notificação, perto do relógio
(Windows), ou na barra de menus (Mac), e escolha **Sair**. No Linux, algumas áreas de trabalho, como a padrão do
Ubuntu, não têm esse ícone: o app fecha ao desligar ou reiniciar o computador. Abrir o app de novo só traz o
navegador de volta.

Quando sair uma versão nova, aparece um aviso no topo do app com o botão **Baixar**.

## Seus dados

Tudo fica numa pasta do seu usuário, fora da pasta onde o programa é instalado:

| Sistema | Pasta                                         |
|---------|-----------------------------------------------|
| Windows | `C:\Users\<seu usuário>\.ats-resume-optimizer` |
| macOS   | `/Users/<seu usuário>/.ats-resume-optimizer`   |
| Linux   | `/home/<seu usuário>/.ats-resume-optimizer`    |

Nada é enviado para servidor nosso. Só o texto necessário vai para o provedor de IA que você escolher.

| O que tem lá           | Para que serve                                                           |
|------------------------|--------------------------------------------------------------------------|
| `pgdata/`              | o banco de dados, com todos os cadastros                                 |
| `postgres-password`    | a senha desse banco; sem ela o banco não abre                             |
| `ai-settings-secret`   | a chave que protege as chaves de IA; sem ela é preciso cadastrá-las de novo |
| `logs/app.log`         | registro do que o app fez, útil para relatar um problema                 |

**Backup**: feche o app (**Sair**) e copie a pasta inteira para um lugar seguro. Para restaurar, feche o app e
coloque a pasta de volta.

**Atualizar**: baixe e instale a versão nova por cima da atual. O instalador troca só o programa; a pasta de dados
continua igual e, ao abrir, o app atualiza a estrutura do banco sozinho, sem perder cadastros. Ainda assim, faça
um backup antes de atualizar.

**Desinstalar**: pelo próprio sistema (Configurações → Aplicativos no Windows, arrastar para o Lixo no Mac,
`sudo apt remove ats-resume-optimizer` no Linux). A pasta de dados não é apagada; apague à mão se quiser remover
tudo.

## Banco de dados externo (opcional)

Por padrão o banco fica dentro do computador. Quem tem um PostgreSQL num servidor (uma VPS, por exemplo) pode usar
ele no lugar, para ter os dados fora do computador:

1. Crie um banco **vazio** no servidor e um usuário com permissão de criar tabelas nele.
2. No app, vá em **Configurações → Banco de dados**, preencha servidor, porta, banco, usuário e senha.
3. Clique em **Testar conexão**. Com a opção **Copiar meus dados atuais** marcada, o banco precisa estar vazio.
4. Clique em **Salvar e reiniciar**. O app copia os dados, reinicia e passa a usar o servidor.

- A conexão é criptografada por padrão. "Sem criptografia" só deve ser usado em rede local.
- O banco local não é apagado. **Voltar para o banco local** retorna aos dados de antes da troca; o que foi feito
  só no servidor não aparece nele.
- Se o servidor estiver fora do ar quando o app abrir, aparece uma janela para tentar de novo ou usar o banco
  local.
- Um computador por banco: as chaves de IA são protegidas pelo `ai-settings-secret` de cada computador. Para usar o
  mesmo banco em outro computador, cadastre as chaves de IA de novo nele.

## Problemas comuns

| Sintoma                                              | O que fazer                                                                        |
|------------------------------------------------------|------------------------------------------------------------------------------------|
| O app não abre e mostra uma mensagem de erro         | Anote a mensagem e envie junto com o `logs/app.log` da pasta de dados.             |
| Abri o app e nada aconteceu                          | Ele já estava aberto: acesse <http://localhost:8080> ou use **Abrir** no ícone.    |
| O navegador abriu num endereço com outra porta       | Algum programa já usava a porta 8080; o app escolheu outra. Funciona igual.        |
| Mac diz que o app "está danificado"                  | Baixe de novo pela página de releases; não use cópias de outros lugares.           |
| Análise falha logo no começo                         | Nenhum provedor de IA configurado. Veja o passo 3 do primeiro uso.                 |

---

# Para desenvolvedores

Este é o repositório agregador: ele guarda os instaladores, o workflow de release e aponta para os dois projetos,
que são submódulos.

| Caminho   | Repositório | Conteúdo |
|-----------|-------------|----------|
| `backend` | [atsresumeoptimizer-backend](https://github.com/DiegoHaefliger/atsresumeoptimizer-backend) | API em Java 25 e Spring Boot, Liquibase e PostgreSQL |
| `front`   | [atsresumeoptimizer-front](https://github.com/DiegoHaefliger/atsresumeoptimizer-front) | Interface em React, TypeScript e Vite |
| `packaging` | neste repositório | Scripts do jpackage e ícones dos instaladores |

Cada submódulo tem o seu README, com os detalhes do projeto: profiles, variáveis de ambiente, API de integração e
integração com o Google Agenda no backend, scripts e geração de tipos no front.

## Pré-requisitos

| Ferramenta | Versão           | Para quê                |
|------------|------------------|-------------------------|
| Java (JDK) | 25               | backend                 |
| Docker     | com Compose      | PostgreSQL, sobe sozinho |
| Node.js    | 20.19+ ou 22.12+ | front                   |

Maven não precisa estar instalado: o backend usa o `./mvnw` do próprio projeto.

## Clonar com os submódulos

```bash
git clone --recurse-submodules https://github.com/DiegoHaefliger/atsresumeoptimizer.git
cd atsresumeoptimizer
```

Já clonou sem a flag? Rode `git submodule update --init --recursive`.

<a id="como-rodar"></a>

## Subir o ambiente

**Backend**

```bash
cd backend
cp .env.example .env      # opcional
./mvnw spring-boot:run
```

Ao iniciar, o backend sobe sozinho o `compose.yaml` com o **PostgreSQL** (porta 5432) e cria as tabelas. Basta o
Docker estar aberto. Está pronto quando aparecer `Started AtsResumeOptimizerBackendApplication`. A API fica em
<http://localhost:8080> e o Swagger em <http://localhost:8080/swagger-ui.html>.

O `.env` é opcional e guarda o `AI_SETTINGS_SECRET`, que criptografa as chaves de API. Sem ele, o segredo é gerado
na primeira chave salva, em `~/.ats-resume-optimizer/ai-settings-secret` (faça backup desse arquivo). O upload de
currículo não guarda o arquivo: o texto e os sinais de layout vão para o banco e o arquivo é descartado.

**Front**, em outro terminal:

```bash
cd front
npm install
cp .env.example .env.local
npm run dev
```

Abra <http://localhost:5173>.

## Rodar como o app instalado

O profile `desktop` usa o PostgreSQL embutido, serve o front de dentro do jar e abre o navegador. Detalhes no
[README do backend](backend/README.md#profile-desktop-sem-docker).

```bash
packaging/package.sh 1.0.0 app-image       # gera packaging/build/out/ATS Resume Optimizer/
```

Os ícones saem de [`packaging/icons/generate.py`](packaging/icons/generate.py) (precisa de Pillow).

## Testes

```bash
cd backend && ./mvnw test    # precisa do Docker (Testcontainers)
cd front && npm run build    # checagem de tipos e build
```

## Submódulos

Uma alteração em um submódulo exige **dois commits**: um no próprio submódulo e outro neste repositório,
atualizando o ponteiro. O instalador é construído a partir do commit apontado, então esquecer o segundo é o erro
mais comum, e ele é silencioso.

```bash
cd backend
git add . && git commit -m "feat: ..." && git push

cd ..
git add backend && git commit -m "chore: bump backend" && git push
```

Duas configurações que evitam boa parte dos tropeços:

```bash
git config --global submodule.recurse true
git config --global status.submoduleSummary true
```

Na release esse passo é automático (veja abaixo).

## Gerar uma release

Um passo só, pelo GitHub: **Actions → Release → Run workflow**, preenchendo `version` (ex.: `1.1.0`). O workflow
[`release.yml`](.github/workflows/release.yml):

1. valida a versão e confere que a tag ainda não existe;
2. atualiza `backend` e `front` para o `main` de cada um e grava isso num commit numa branch temporária (o `main`
   deste repositório é protegido);
3. gera os instaladores nos quatro sistemas, uma única vez, já com a versão real;
4. calcula o SHA-256, registra a origem do build (attestation), cria a tag `v<versão>` e publica a release;
5. apaga a branch temporária.

Versão com sufixo (`1.1.0-rc1`) vira pre-release e não dispara o aviso de atualização no app. Com o campo `version`
vazio, o workflow só empacota, sem publicar, como ensaio. Pull request que mexe em `packaging/` ou no próprio
workflow também roda o empacotamento para conferir.

A tag aponta para um commit com os submódulos atualizados que não está no `main` deste repositório. Isso não afeta
o instalador.

## Problemas comuns no desenvolvimento

| Sintoma                                  | Causa provável e solução                                                                     |
|------------------------------------------|----------------------------------------------------------------------------------------------|
| Backend falha ao subir falando de Docker | Docker fechado. Abra o Docker e rode de novo.                                                 |
| `Port 5432 is already in use`            | Outro PostgreSQL na máquina. Pare ele ou mude a porta em `backend/compose.yaml`.              |
| Front abre, mas toda tela dá erro        | Backend fora de `localhost:8080`. Ajuste `VITE_API_BASE_URL` no `.env.local`.                 |
| Erro de CORS no navegador                | Front fora de `localhost:5173`. Ajuste `CORS_ALLOWED_ORIGINS` no `backend/.env`.              |
| Análise falha logo no começo             | Nenhum provedor de IA configurado ou na fila. Veja o [primeiro uso](#primeiro-uso).           |

---

## Licença

[PolyForm Noncommercial 1.0.0](LICENSE). Uso, estudo e modificação livres para fins não comerciais. Vender,
revender ou embutir em produto ou serviço pago não é permitido.
