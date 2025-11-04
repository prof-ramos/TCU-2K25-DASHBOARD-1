# 📘 Guia de Instalação Completo

> Instruções detalhadas para configurar o TCU TI 2025 Study Dashboard em diferentes ambientes

---

## 📋 Índice

- [Pré-requisitos](#pré-requisitos)
- [Instalação Básica (Frontend Only)](#instalação-básica-frontend-only)
- [Instalação Completa (Frontend + Backend)](#instalação-completa-frontend--backend)
- [Configuração de Variáveis de Ambiente](#configuração-de-variáveis-de-ambiente)
- [Instalação com Docker](#instalação-com-docker)
- [Deploy em Produção](#deploy-em-produção)
- [Solução de Problemas](#solução-de-problemas)

---

## Pré-requisitos

### Obrigatórios

- **Node.js** 20.x ou superior
  ```bash
  node --version  # Deve retornar v20.x.x ou superior
  ```

- **npm** 10.x ou superior
  ```bash
  npm --version  # Deve retornar 10.x.x ou superior
  ```

- **Git** para clonar o repositório
  ```bash
  git --version
  ```

### Opcionais (para funcionalidades avançadas)

- **Docker** e **Docker Compose** (para deploy containerizado)
- **Conta Supabase** (para backend em nuvem)
- **Google Gemini API Key** (para funcionalidade de IA)

---

## Instalação Básica (Frontend Only)

Esta é a instalação mais rápida. A aplicação funcionará completamente usando localStorage para persistência.

### 1. Clone o Repositório

```bash
git clone https://github.com/seu-usuario/tcu-ti-2025-study-dashboard.git
cd tcu-ti-2025-study-dashboard
```

### 2. Instale as Dependências

```bash
npm install
```

Este comando instalará todas as dependências necessárias listadas em `package.json`.

### 3. Inicie o Servidor de Desenvolvimento

```bash
npm run dev
```

### 4. Acesse a Aplicação

Abra seu navegador em:
```
http://localhost:5000
```

✅ **Pronto!** Você já pode usar o dashboard para acompanhar seus estudos.

**Funcionalidades disponíveis neste modo:**
- ✅ Visualização de todas as matérias e tópicos
- ✅ Marcação de progresso (salvo no localStorage)
- ✅ Tema claro/escuro
- ✅ Contagem regressiva
- ❌ IA (requer API key do Gemini)
- ❌ Sincronização multi-dispositivo (requer backend)

---

## Instalação Completa (Frontend + Backend)

Para ter todas as funcionalidades, incluindo sincronização em nuvem e IA, siga estes passos:

### 1. Clone e Instale (se ainda não fez)

```bash
git clone https://github.com/seu-usuario/tcu-ti-2025-study-dashboard.git
cd tcu-ti-2025-study-dashboard
npm install
```

### 2. Crie uma Conta Supabase

1. Acesse [supabase.com](https://supabase.com)
2. Crie uma conta gratuita
3. Crie um novo projeto
4. Anote as credenciais:
   - `Project URL` (será seu `SUPABASE_URL`)
   - `anon public` key (será seu `SUPABASE_ANON_PUBLIC`)
   - `service_role` key (será seu `SUPABASE_SERVICE_ROLE`)

### 3. Configure o Banco de Dados Supabase

No painel do Supabase, vá até **SQL Editor** e execute o script:

```sql
-- Copie todo o conteúdo do arquivo supabase-edital-schema.sql
-- e execute no SQL Editor
```

Ou use o arquivo fornecido:
```bash
# Execute o script de criação do schema
cat supabase-edital-schema.sql
```

### 4. Obtenha API Key do Google Gemini

1. Acesse [Google AI Studio](https://ai.google.dev/)
2. Faça login com sua conta Google
3. Clique em "Get API key"
4. Copie a chave gerada (será seu `GEMINI_API_KEY`)

### 5. Configure Variáveis de Ambiente

Crie um arquivo `.env` na raiz do projeto:

```bash
cp .env.example .env
```

Edite o arquivo `.env` com suas credenciais:

```env
# Frontend
VITE_GEMINI_API_KEY=sua_api_key_do_gemini

# Backend
SUPABASE_URL=https://seu-projeto.supabase.co
SUPABASE_ANON_PUBLIC=sua_chave_publica
SUPABASE_SERVICE_ROLE=sua_chave_service_role

# Configurações opcionais
NODE_ENV=development
PORT=3001
```

⚠️ **Importante**: Nunca commite o arquivo `.env` para o repositório!

### 6. Instale Dependências do Backend

```bash
npm install --prefix server
```

### 7. Inicie Frontend e Backend

**Opção 1: Terminais separados**

Terminal 1 (Frontend):
```bash
npm run dev
```

Terminal 2 (Backend):
```bash
cd server && node index.js
```

**Opção 2: Com Docker Compose**
```bash
docker-compose up
```

### 8. Acesse a Aplicação

```
http://localhost:5000
```

✅ **Agora você tem acesso a todas as funcionalidades!**

---

## Configuração de Variáveis de Ambiente

### Variáveis Frontend (prefixo `VITE_`)

| Variável | Obrigatória | Descrição | Exemplo |
|----------|-------------|-----------|---------|
| `VITE_GEMINI_API_KEY` | Não* | API key do Google Gemini | `AIza...` |

*Opcional, mas necessária para funcionalidade de IA

### Variáveis Backend

| Variável | Obrigatória | Descrição | Exemplo |
|----------|-------------|-----------|---------|
| `SUPABASE_URL` | Sim | URL do projeto Supabase | `https://abc.supabase.co` |
| `SUPABASE_ANON_PUBLIC` | Sim | Chave pública do Supabase | `eyJh...` |
| `SUPABASE_SERVICE_ROLE` | Sim | Chave de serviço do Supabase | `eyJh...` |
| `NODE_ENV` | Não | Ambiente de execução | `development` ou `production` |
| `PORT` | Não | Porta do servidor backend | `3001` |

### Exemplo Completo de `.env`

```env
# ============================================
# FRONTEND ENVIRONMENT VARIABLES
# ============================================
VITE_GEMINI_API_KEY=AIzaSyC...exemplo...xyz

# ============================================
# BACKEND ENVIRONMENT VARIABLES
# ============================================

# Supabase Configuration
SUPABASE_URL=https://xyzproject.supabase.co
SUPABASE_ANON_PUBLIC=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SUPABASE_SERVICE_ROLE=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# Server Configuration
NODE_ENV=development
PORT=3001

# ============================================
# OPTIONAL: DEVELOPMENT TOOLS
# ============================================
VITE_DEV_SERVER_PORT=5000
```

---

## Instalação com Docker

### Pré-requisitos Docker

- Docker Engine 20.x ou superior
- Docker Compose 2.x ou superior

```bash
docker --version
docker-compose --version
```

### 1. Configure Variáveis de Ambiente

Crie o arquivo `.env` conforme descrito acima.

### 2. Build e Start

```bash
# Build das imagens e start dos containers
docker-compose up --build

# Ou em modo background
docker-compose up -d
```

### 3. Acesse a Aplicação

```
http://localhost:5000
```

### Comandos Úteis Docker

```bash
# Ver logs
docker-compose logs -f

# Parar containers
docker-compose down

# Rebuild após mudanças
docker-compose up --build

# Acessar shell do container
docker-compose exec frontend sh
docker-compose exec backend sh
```

---

## Deploy em Produção

### Deploy no Replit

1. Faça fork deste repositório
2. Importe no Replit
3. Configure os Secrets no painel do Replit:
   - `GEMINI_API_KEY`
   - `SUPABASE_URL`
   - `SUPABASE_ANON_PUBLIC`
   - `SUPABASE_SERVICE_ROLE`
4. Clique em "Run"

### Deploy na Vercel (Frontend)

```bash
# Instale Vercel CLI
npm install -g vercel

# Deploy
vercel

# Configure as variáveis de ambiente na dashboard da Vercel
```

### Deploy na Netlify (Frontend)

```bash
# Build
npm run build

# Deploy manual
# Arraste a pasta dist/ para netlify.com/drop

# Ou com CLI
npm install -g netlify-cli
netlify deploy --prod
```

### Deploy do Backend (Railway/Render)

1. Crie uma conta em [Railway](https://railway.app) ou [Render](https://render.com)
2. Conecte seu repositório GitHub
3. Configure as variáveis de ambiente
4. Deploy automático

---

## Solução de Problemas

### Frontend não inicia

**Erro**: `Cannot find module 'vite'`
```bash
# Solução: Reinstale as dependências
rm -rf node_modules package-lock.json
npm install
```

**Erro**: `Port 5000 already in use`
```bash
# Solução 1: Mate o processo na porta 5000
lsof -ti:5000 | xargs kill -9

# Solução 2: Use outra porta
VITE_DEV_SERVER_PORT=3000 npm run dev
```

### Backend não conecta ao Supabase

**Erro**: `Invalid Supabase credentials`

✅ **Solução**:
1. Verifique se as variáveis de ambiente estão corretas
2. Confirme que copiou as chaves completas (sem espaços)
3. Teste a conexão no Supabase Dashboard

### IA não funciona

**Erro**: `Gemini API key not found`

✅ **Solução**:
1. Verifique se `VITE_GEMINI_API_KEY` está no `.env`
2. Reinicie o servidor de desenvolvimento
3. Limpe o cache do navegador

### Dados não são salvos

✅ **Solução**:
1. Verifique o localStorage do navegador (F12 > Application > Local Storage)
2. Se estiver usando backend, verifique se está rodando
3. Teste a conexão com o Supabase

### Erro de CORS

**Erro**: `CORS policy: No 'Access-Control-Allow-Origin'`

✅ **Solução**:
1. Verifique se o backend está configurado corretamente
2. Adicione a URL do frontend no CORS do backend
3. Em desenvolvimento, use proxy no `vite.config.ts`

---

## Próximos Passos

- 📖 Leia o [Guia de Desenvolvimento](./DEVELOPMENT.md)
- 🏗️ Entenda a [Arquitetura](./ARCHITECTURE.md)
- 🧪 Configure os [Testes](./TESTING.md)
- 🤝 Veja como [Contribuir](./CONTRIBUTING.md)

---

## Suporte

Se encontrar problemas:
1. Verifique a seção de [Troubleshooting](#solução-de-problemas)
2. Busque em [Issues existentes](https://github.com/seu-usuario/tcu-ti-2025-study-dashboard/issues)
3. Abra uma [nova issue](https://github.com/seu-usuario/tcu-ti-2025-study-dashboard/issues/new) com detalhes

---

[⬅ Voltar para o README principal](../README.md)
