# 🚀 Guia de Migração e Configuração - Supabase + Helmet + Rate Limiting

Este guia detalha o processo completo de migração do backend SQLite para Supabase PostgreSQL, incluindo as melhorias de segurança implementadas.

---

## 📋 O Que Foi Implementado

### ✅ 1. Migração para Supabase
- Substituição do SQLite local por PostgreSQL na nuvem (Supabase)
- Cliente oficial `@supabase/supabase-js` configurado
- Script de migração automática de dados

### ✅ 2. Validação com Zod
- Validação rigorosa de todos os endpoints
- Schemas definidos para `/api/progress` e `/api/gemini-proxy`
- Mensagens de erro detalhadas

### ✅ 3. Segurança (Helmet.js)
- Headers de segurança automáticos
- Proteção contra XSS, clickjacking, MIME sniffing

### ✅ 4. Rate Limiting
- 100 requisições/15min por IP (geral)
- 20 requisições/15min para Gemini AI (específico)
- Headers padrão para informar limites ao cliente

---

## 🛠️ Passo a Passo: Configuração Completa

### **PASSO 1:** Criar Tabela no Supabase

1. Acesse o dashboard do Supabase: https://supabase.com/dashboard/project/imwohmhgzamdahfiahdk

2. Vá em **SQL Editor** (menu lateral)

3. Cole o conteúdo do arquivo `supabase-schema.sql`:

```bash
cat supabase-schema.sql
```

4. Clique em **Run** (ou Ctrl+Enter)

5. Verifique se a tabela foi criada:
   - Vá em **Table Editor**
   - Você deve ver a tabela `progress` com colunas: `id`, `item_id`, `completed_at`, `created_at`

---

### **PASSO 2:** Instalar Novas Dependências

No diretório raiz do projeto, execute:

```bash
# Instalar dependências do backend
cd /caminho/para/TCU-2K25-DASHBOARD
npm install --prefix . @supabase/supabase-js@^2.39.3 zod@^3.22.4 helmet@^7.1.0 express-rate-limit@^7.1.5 dotenv@^16.4.1

# Ou instalar diretamente do package-server.json atualizado:
cd /caminho/para/TCU-2K25-DASHBOARD
npm install --prefix server
```

**Verificar instalação:**
```bash
node -e "console.log(require('@supabase/supabase-js').createClient ? '✅ Supabase OK' : '❌ Erro')"
node -e "console.log(require('zod').z ? '✅ Zod OK' : '❌ Erro')"
node -e "console.log(require('helmet') ? '✅ Helmet OK' : '❌ Erro')"
```

---

### **PASSO 3:** Configurar Variáveis de Ambiente

1. **Copiar o template:**

```bash
cp .env.example .env
```

2. **Obter as chaves do Supabase:**

   - Acesse: https://supabase.com/dashboard/project/imwohmhgzamdahfiahdk/settings/api
   - Copie:
     - **Project URL** → `SUPABASE_URL`
     - **anon/public key** → `SUPABASE_ANON_PUBLIC` (opcional por enquanto)
     - **service_role key** → `SUPABASE_SERVICE_ROLE` (CRÍTICO!)

3. **Editar o arquivo `.env`:**

```bash
# .env
GEMINI_API_KEY=NOVA_CHAVE_GEMINI_AQUI  # Revogar a anterior!
SUPABASE_URL=https://imwohmhgzamdahfiahdk.supabase.co
SUPABASE_SERVICE_ROLE=SUA_CHAVE_SERVICE_ROLE_AQUI
CORS_ORIGIN=http://localhost:3000
NODE_ENV=development
PORT=3001
```

4. **Validar:**

```bash
node -e "require('dotenv').config(); console.log(process.env.SUPABASE_URL ? '✅ .env carregado' : '❌ Erro')"
```

---

### **PASSO 4:** Migrar Dados Existentes (Opcional)

⚠️ **Apenas necessário se você tem dados no SQLite local (`data/study_progress.db`)**

1. **Verificar se há dados para migrar:**

```bash
# Se o arquivo existir e tiver dados:
sqlite3 data/study_progress.db "SELECT COUNT(*) FROM progress;"
```

2. **Executar migração:**

```bash
cd /caminho/para/TCU-2K25-DASHBOARD

# Dry-run (sem confirmação)
node server/migrate-to-supabase.js

# Migração real (com confirmação)
CONFIRM_MIGRATION=yes node server/migrate-to-supabase.js
```

3. **Verificar dados no Supabase:**
   - Dashboard → Table Editor → `progress`
   - Deve mostrar os registros migrados

---

### **PASSO 5:** Testar o Servidor Localmente

1. **Iniciar o servidor:**

```bash
cd /caminho/para/TCU-2K25-DASHBOARD
npm run dev --prefix server

# Ou diretamente:
node server/index.js
```

2. **Saída esperada:**

```
==================================================
🚀 TCU Dashboard API Server
==================================================
📡 Servidor rodando na porta: 3001
🌍 Ambiente: development
🗄️  Banco de dados: Supabase ✅
🤖 Gemini AI: ✅
🔒 Segurança: Helmet + Rate Limiting habilitados
==================================================
```

3. **Testar endpoints:**

```bash
# Health check (deve mostrar status: OK e database: connected)
curl http://localhost:3001/health

# Buscar progresso (deve retornar array vazio ou com IDs)
curl http://localhost:3001/api/progress

# Adicionar progresso
curl -X POST http://localhost:3001/api/progress \
  -H "Content-Type: application/json" \
  -d '{"ids": ["test-1", "test-2"]}'

# Verificar no Supabase se foi inserido
# Dashboard → Table Editor → progress

# Deletar progresso
curl -X DELETE http://localhost:3001/api/progress \
  -H "Content-Type: application/json" \
  -d '{"ids": ["test-1"]}'
```

---

### **PASSO 6:** Testar Validação e Rate Limiting

**Teste 1: Validação Zod (deve falhar)**

```bash
# Sem o campo "ids"
curl -X POST http://localhost:3001/api/progress \
  -H "Content-Type: application/json" \
  -d '{}'

# Esperado: {"error": "Dados inválidos", "details": [...]}
```

**Teste 2: Rate Limiting (deve bloquear após 100 reqs)**

```bash
# Fazer várias requisições rapidamente
for i in {1..105}; do
  curl -s http://localhost:3001/health > /dev/null
  echo "Request $i"
done

# Após a 100ª, deve retornar:
# {"error": "Muitas requisições deste IP, tente novamente em 15 minutos"}
```

---

## 🐳 Deploy com Docker

### Atualizar Dockerfile.api

O Dockerfile precisa ser atualizado para copiar as novas pastas `config/` e `middlewares/`:

```dockerfile
# Dockerfile.api
FROM node:18-alpine

WORKDIR /app

# Copiar package files
COPY package-server.json ./package.json

# Instalar dependências
RUN npm ci --only=production

# Copiar código-fonte
COPY server/ ./server/

# Expose port
EXPOSE 3001

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3001/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

# Start the server
CMD ["node", "server/index.js"]
```

### Build e Deploy

```bash
# Build das imagens
docker-compose build

# Iniciar containers (com .env)
docker-compose up -d

# Ver logs
docker-compose logs -f api

# Verificar health
docker-compose ps
```

---

## 🚨 Troubleshooting

### Erro: "SUPABASE_URL não está definida"

**Causa:** Variáveis de ambiente não carregadas

**Solução:**
```bash
# Verificar se .env existe
ls -la .env

# Verificar conteúdo
cat .env | grep SUPABASE_URL

# Forçar reload
export $(cat .env | xargs)
node server/index.js
```

---

### Erro: "Cannot find module '@supabase/supabase-js'"

**Causa:** Dependências não instaladas

**Solução:**
```bash
cd /caminho/para/TCU-2K25-DASHBOARD
npm install --prefix server
```

---

### Erro: "Could not connect to Supabase"

**Causa:** Chave inválida ou projeto pausado

**Solução:**
1. Verificar se o projeto está ativo: https://supabase.com/dashboard
2. Regenerar service_role key se necessário
3. Testar conexão manual:

```bash
node -e "
const { createClient } = require('@supabase/supabase-js');
const supabase = createClient('SUA_URL', 'SUA_CHAVE');
supabase.from('progress').select('count').then(console.log);
"
```

---

### Erro: "table progress does not exist"

**Causa:** Schema não foi executado no Supabase

**Solução:**
1. Executar `supabase-schema.sql` no SQL Editor
2. Verificar em Table Editor

---

### Rate Limit atingido em desenvolvimento

**Causa:** Muitas requisições durante testes

**Solução:**
```bash
# Esperar 15 minutos OU

# Reiniciar servidor (reseta contador)
# OU

# Comentar temporariamente o rate limiter em server/index.js:
# app.use(limiter) → // app.use(limiter)
```

---

## ✅ Checklist Final

Antes de fazer commit/deploy, verifique:

- [ ] Tabela `progress` criada no Supabase
- [ ] `.env` configurado com chaves válidas
- [ ] Dependências instaladas (`npm install`)
- [ ] Servidor local inicia sem erros
- [ ] Endpoint `/health` retorna `database: connected`
- [ ] Endpoints `/api/progress` funcionam (GET/POST/DELETE)
- [ ] Validação Zod funciona (testar requisição inválida)
- [ ] Rate limiting funciona (testar 105+ requisições)
- [ ] Dados migrados do SQLite (se aplicável)
- [ ] `.env` **NÃO** está no git (`git status`)
- [ ] Docker build funciona (`docker-compose build`)

---

## 📚 Próximos Passos

1. **Atualizar frontend para usar nova API** (se houver mudanças de formato)
2. **Adicionar testes automatizados** (Vitest/Jest)
3. **Configurar CI/CD** (GitHub Actions)
4. **Implementar logs estruturados** (Winston/Pino)
5. **Adicionar monitoramento** (Sentry, Datadog)

---

## 🆘 Suporte

Se encontrar problemas:

1. Verificar logs: `docker-compose logs -f api` ou console do terminal
2. Verificar Supabase Dashboard → Logs
3. Consultar documentação:
   - Supabase JS: https://supabase.com/docs/reference/javascript
   - Zod: https://zod.dev
   - Helmet: https://helmetjs.github.io

---

**Data:** 2025-01-15
**Versão:** 2.0.0 (Supabase + Security Improvements)
