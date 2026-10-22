# ATSResumeOptimizer

Sistema para analisar e adaptar currículos e aumentar a chance de passar nos filtros de ATS
(Applicant Tracking System) usados por recrutadores.

## O que faz

- **Currículos**: cadastra, importa (PDF ou DOCX, até 2 MB) e edita.
- **Vagas**: guarda a descrição colada (sem scraping de URL).
- **Análise**: nota de aderência ao ATS, com achados agrupados por severidade, ortografia e semântica.
- **Preferências**: formato, remuneração, benefícios, local e empresas. Entram como critérios na nota da vaga.
- **Reescrita**: a IA adapta o currículo à vaga, com diff de bullets, destaque dos pontos da vaga e checagem
  para nada ser inventado. Edita antes de baixar em **PDF** ou **DOCX**.
- Currículos apenas em PT-BR.

## Baixar e instalar

Não precisa instalar Java, banco de dados nem mais nada: o instalador já traz tudo.

Baixe o arquivo do seu sistema na [última versão](https://github.com/DiegoHaefliger/atsresumeoptimizer/releases/latest):

| Sistema                         | Download                                                                                                                              |
|---------------------------------|---------------------------------------------------------------------------------------------------------------------------------------|
| Windows 10 ou 11                | [Baixar `.msi`](https://github.com/DiegoHaefliger/atsresumeoptimizer/releases/latest/download/ats-resume-optimizer-windows-x64.msi)    |
| Mac com chip Apple (M1, M2...)  | [Baixar `.dmg`](https://github.com/DiegoHaefliger/atsresumeoptimizer/releases/latest/download/ats-resume-optimizer-macos-arm64.dmg)    |
| Mac com processador Intel       | [Baixar `.dmg`](https://github.com/DiegoHaefliger/atsresumeoptimizer/releases/latest/download/ats-resume-optimizer-macos-x64.dmg)      |
| Ubuntu, Debian, Mint            | [Baixar `.deb`](https://github.com/DiegoHaefliger/atsresumeoptimizer/releases/latest/download/ats-resume-optimizer-linux-x64.deb)      |

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

## Para desenvolvedores

Este é o repositório agregador. O código vive nos submódulos:

| Caminho   | Repositório                                                                                 | Conteúdo                               |
|-----------|---------------------------------------------------------------------------------------------|----------------------------------------|
| `backend` | [atsresumeoptimizer-backend](https://github.com/DiegoHaefliger/atsresumeoptimizer-backend) | API em Java 25 / Spring Boot           |
| `front`   | [atsresumeoptimizer-front](https://github.com/DiegoHaefliger/atsresumeoptimizer-front)     | Interface em React + TypeScript + Vite |

### Pré-requisitos

| Ferramenta | Versão           | Pra quê                    |
|------------|------------------|----------------------------|
| Java (JDK) | 25               | backend                    |
| Docker     | com Compose      | Postgres, sobe sozinho     |
| Node.js    | 20.19+ ou 22.12+ | front                      |

Maven não precisa estar instalado: o backend usa o `./mvnw` do próprio projeto.

### Clonar com os submódulos

```bash
git clone --recurse-submodules https://github.com/DiegoHaefliger/atsresumeoptimizer.git
cd atsresumeoptimizer
```

Já clonou sem a flag? Rode `git submodule update --init --recursive`.

### Subir o backend

```bash
cd backend
cp .env.example .env      # opcional, veja abaixo
./mvnw spring-boot:run
```

Ao iniciar, o backend sobe sozinho o `compose.yaml` com **Postgres** (porta 5432) e cria as tabelas. Não precisa
rodar `docker compose up` na mão, só ter o Docker aberto. O arquivo do currículo não é guardado: no upload o texto
e os sinais de layout vão para o banco, e o arquivo é descartado.

Pronto quando aparecer `Started AtsResumeOptimizerBackendApplication`. A API fica em
<http://localhost:8080> e a documentação em <http://localhost:8080/swagger-ui.html>.

O `.env` é opcional. Ele guarda o `AI_SETTINGS_SECRET`, que criptografa as chaves de API. Sem ele, o segredo é
gerado na primeira chave salva em `~/.ats-resume-optimizer/ai-settings-secret` (faça backup desse arquivo).

### Subir o front

Em outro terminal, a partir da raiz:

```bash
cd front
npm install
cp .env.example .env.local
npm run dev
```

Abra <http://localhost:5173>.

### Rodar como o app instalado (sem Docker)

O profile `desktop` usa o Postgres embutido, serve o front de dentro do jar e abre o navegador. Detalhes no
[README do backend](backend/README.md#profile-desktop-sem-docker).

```bash
packaging/package.sh 1.0.0 app-image       # gera packaging/build/out/ATS Resume Optimizer/
```

### Gerar uma release

Crie e envie uma tag `v<versão>`. O workflow [`release.yml`](.github/workflows/release.yml) gera os instaladores
nos quatro sistemas, calcula o SHA-256, registra a origem do build (attestation) e publica a release:

```bash
git tag v1.0.0 && git push origin v1.0.0
```

Tag com sufixo (`v1.1.0-rc1`) vira pre-release e não dispara o aviso de atualização no app. O mesmo workflow roda
em PR que mexe em `packaging/`, no workflow ou nos submódulos, só gerando os instaladores para conferir.

Os ícones saem de [`packaging/icons/generate.py`](packaging/icons/generate.py) (precisa de Pillow).

### Problemas comuns no desenvolvimento

| Sintoma                                     | Causa provável e solução                                                         |
|---------------------------------------------|----------------------------------------------------------------------------------|
| Backend falha ao subir falando de Docker    | Docker fechado. Abra o Docker e rode de novo.                                     |
| `Port 5432 is already in use`               | Outro Postgres na máquina. Pare ele ou mude a porta em `backend/compose.yaml`.   |
| Front abre, mas toda tela dá erro           | Backend não está rodando em `localhost:8080`, ou ajuste `VITE_API_BASE_URL` no `.env.local`. |
| Erro de CORS no navegador                   | Front fora de `localhost:5173`. Ajuste `CORS_ALLOWED_ORIGINS` no `backend/.env`. |
| Análise falha logo no começo                | Nenhum provedor de IA configurado ou na fila. Veja o primeiro uso.               |

### Testes

```bash
cd backend && ./mvnw test    # precisa do Docker (Testcontainers)
cd front && npm run build    # checagem de tipos + build
```

### Trabalhando com os submódulos

Atualizar todos pro último commit:

```bash
git submodule update --remote --merge
```

Uma alteração em um submódulo exige **dois commits**: um no próprio submódulo e outro no pai, atualizando o
ponteiro. Esquecer o segundo é o erro mais comum, e ele é silencioso: quem clonar recebe a versão antiga.

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

## Licença

[PolyForm Noncommercial 1.0.0](LICENSE). Uso, estudo e modificação livres para fins não comerciais. Vender,
revender ou embutir em produto ou serviço pago não é permitido.
