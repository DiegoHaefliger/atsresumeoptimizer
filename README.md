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

Este é o repositório agregador. O código vive nos submódulos:

| Caminho   | Repositório                                                                                 | Conteúdo                              |
|-----------|---------------------------------------------------------------------------------------------|---------------------------------------|
| `backend` | [atsresumeoptimizer-backend](https://github.com/DiegoHaefliger/atsresumeoptimizer-backend) | API em Java 25 / Spring Boot          |
| `front`   | [atsresumeoptimizer-front](https://github.com/DiegoHaefliger/atsresumeoptimizer-front)     | Interface em React + TypeScript + Vite |

## Como rodar

### 1. Pré-requisitos

| Ferramenta | Versão           | Pra quê                                   |
|------------|------------------|-------------------------------------------|
| Java (JDK) | 25               | backend                                   |
| Docker     | com Compose      | Postgres e MinIO, sobem sozinhos          |
| Node.js    | 20.19+ ou 22.12+ | front                                     |

Maven não precisa estar instalado: o backend usa o `./mvnw` do próprio projeto.

### 2. Clonar com os submódulos

```bash
git clone --recurse-submodules https://github.com/DiegoHaefliger/atsresumeoptimizer.git
cd atsresumeoptimizer
```

Já clonou sem a flag? Rode `git submodule update --init --recursive`.

### 3. Subir o backend

```bash
cd backend
cp .env.example .env      # opcional, veja abaixo
./mvnw spring-boot:run
```

Ao iniciar, o backend sobe sozinho o `compose.yaml` com **Postgres** (porta 5432) e **MinIO** (9000, console em
9001), cria as tabelas e o bucket. Não precisa rodar `docker compose up` na mão, só ter o Docker aberto.

Pronto quando aparecer `Started AtsResumeOptimizerBackendApplication`. A API fica em
<http://localhost:8080> e a documentação em <http://localhost:8080/swagger-ui.html>.

O `.env` é opcional. Ele guarda o `AI_SETTINGS_SECRET`, que criptografa as chaves de API. Sem ele, o segredo é
gerado na primeira chave salva em `~/.ats-resume-optimizer/ai-settings-secret` (faça backup desse arquivo).

### 4. Subir o front

Em outro terminal, a partir da raiz:

```bash
cd front
npm install
cp .env.example .env.local
npm run dev
```

Abra <http://localhost:5173>.

### 5. Configurar a IA (primeira vez)

Na tela **Configurações**, escolha um provedor (OpenAI, Anthropic, Gemini ou Ollama), cole a chave de API e clique em **Testar**. Sem chave, dá pra
usar o **Ollama** rodando local (`http://localhost:11434`).

Depois é só seguir o fluxo: **Currículos** → cadastrar ou importar → **Vagas** (opcional) → **Preferências**
(opcional) → **Nova análise** → **Adaptar currículo** na tela de resultado.

### Problemas comuns

| Sintoma                                     | Causa provável e solução                                                         |
|---------------------------------------------|----------------------------------------------------------------------------------|
| Backend falha ao subir falando de Docker    | Docker fechado. Abra o Docker e rode de novo.                                     |
| `Port 5432 is already in use`               | Outro Postgres na máquina. Pare ele ou mude a porta em `backend/compose.yaml`.   |
| Front abre, mas toda tela dá erro           | Backend não está rodando em `localhost:8080`, ou ajuste `VITE_API_BASE_URL` no `.env.local`. |
| Erro de CORS no navegador                   | Front fora de `localhost:5173`. Ajuste `CORS_ALLOWED_ORIGINS` no `backend/.env`. |
| Análise falha logo no começo                | Nenhum provedor de IA configurado ou na fila. Veja o passo 5.                    |

### Testes

```bash
cd backend && ./mvnw test    # precisa do Docker (Testcontainers)
cd front && npm run build    # checagem de tipos + build
```

## Trabalhando com os submódulos

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
