# 🚀 Roadmap de Evolução do Backend - TCU Dashboard

> **Contexto:** Dashboard pessoal de estudos - Planejamento simplificado focado em uso individual

---

## 📊 Estado Atual

**Stack Atual:**
- Node.js + Express (JavaScript)
- SQLite3 (arquivo local)
- Endpoints: `/api/progress` (GET/POST/DELETE), `/api/gemini-proxy`, `/health`
- Arquivo monolítico: `server/index.js` (~143 linhas)

**Funcionalidades Implementadas:**
- ✅ Persistência de progresso (IDs de tópicos concluídos)
- ✅ Proxy seguro para Gemini API (chave protegida no backend)
- ✅ CORS configurado
- ✅ Health check básico

---

## 🎯 Evolução Proposta (Dashboard Pessoal)

### FASE 1: Organização e Profissionalização (Prioridade Alta)
**Duração:** 1-2 dias | **Complexidade:** Média

#### 1.1 Migração para TypeScript
**Por quê?** Type safety, melhor manutenibilidade, alinhamento com frontend

**Ações:**
```bash
# Nova estrutura
server/
├── src/
│   ├── index.ts              # Entry point
│   ├── app.ts                # Express app config
│   ├── routes/
│   │   ├── progress.routes.ts
│   │   ├── gemini.routes.ts
│   │   └── health.routes.ts
│   ├── controllers/          # Request handlers
│   ├── services/             # Business logic
│   ├── config/
│   │   ├── database.ts
│   │   └── env.ts            # Validação com Zod
│   └── middlewares/
│       ├── errorHandler.ts
│       └── validation.ts
├── tsconfig.json
└── package.json
```

**Dependências a adicionar:**
```json
{
  "dependencies": {
    "zod": "^3.22",           // Validação de schemas
    "helmet": "^7.1",         // Security headers
    "express-rate-limit": "^7.1"
  },
  "devDependencies": {
    "typescript": "^5.3",
    "ts-node-dev": "^2.0",
    "@types/express": "^4.17",
    "@types/cors": "^2.8",
    "@types/node": "^20.0"
  }
}
```

**Scripts:**
```json
{
  "scripts": {
    "dev": "ts-node-dev --respawn src/index.ts",
    "build": "tsc",
    "start": "node dist/index.js"
  }
}
```

#### 1.2 Melhorias de Segurança
- ✅ Helmet.js (security headers)
- ✅ Rate limiting (100 req/15min por IP)
- ✅ Validação de inputs com Zod
- ✅ CORS restritivo (apenas origem do frontend)

---

### FASE 2: Migração Supabase PostgreSQL (Prioridade Alta)
**Duração:** 1 dia | **Complexidade:** Baixa (você já tem Supabase configurado!)

#### 2.1 Por quê migrar para Supabase?
- ✅ Você já tem o projeto configurado (`imwohmhgzamdahfiahdk.supabase.co`)
- ✅ PostgreSQL robusto (melhor que SQLite para produção)
- ✅ Backups automáticos
- ✅ Dashboard visual para gerenciar dados
- ✅ Escalabilidade futura (caso queira compartilhar com amigos)

#### 2.2 Schema Supabase (Simplificado)
```sql
-- Tabela única de progresso (sem multi-usuário por enquanto)
CREATE TABLE progress (
  id SERIAL PRIMARY KEY,
  item_id TEXT UNIQUE NOT NULL,
  completed_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_progress_item_id ON progress(item_id);
```

**Opcional (Futuro):** Estatísticas de estudo
```sql
CREATE TABLE study_sessions (
  id SERIAL PRIMARY KEY,
  date DATE NOT NULL,
  hours_studied DECIMAL(4,2),
  topics_completed INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW()
);
```

#### 2.3 Conexão Supabase (usando SDK oficial)
```bash
npm install @supabase/supabase-js
```

```typescript
// src/config/supabase.ts
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = 'https://imwohmhgzamdahfiahdk.supabase.co'
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE // Apenas no backend!

export const supabase = createClient(supabaseUrl, supabaseServiceKey)
```

#### 2.4 Endpoints Atualizados
```typescript
// GET /api/progress
const { data, error } = await supabase
  .from('progress')
  .select('item_id')

// POST /api/progress
const { data, error } = await supabase
  .from('progress')
  .upsert(ids.map(id => ({ item_id: id })))

// DELETE /api/progress
const { data, error } = await supabase
  .from('progress')
  .delete()
  .in('item_id', ids)
```

#### 2.5 Docker Compose Simplificado
```yaml
services:
  app:
    build: .
    ports:
      - "3000:80"
    environment:
      - NODE_ENV=production

  api:
    build:
      context: .
      dockerfile: .docker/api.Dockerfile
    ports:
      - "3001:3001"
    environment:
      - NODE_ENV=production
      - SUPABASE_URL=https://imwohmhgzamdahfiahdk.supabase.co
      - SUPABASE_SERVICE_ROLE=${SUPABASE_SERVICE_ROLE}
      - GEMINI_API_KEY=${GEMINI_API_KEY}

# Não precisa mais do serviço "db" (Supabase é externo)
```

---

### FASE 3: Funcionalidades Avançadas (Opcional)
**Duração:** 2-3 dias | **Complexidade:** Média

#### 3.1 Estatísticas de Estudo
```typescript
// GET /api/stats/summary
{
  totalTopics: 120,
  completedTopics: 45,
  progressPercentage: 37.5,
  materiaStats: [
    { materiaId: "1", name: "Redes", completed: 10, total: 25, percentage: 40 }
  ],
  recentActivity: [
    { itemId: "1.2.3", completedAt: "2025-01-15T10:30:00Z" }
  ],
  studyStreak: 7  // dias consecutivos estudando
}
```

#### 3.2 Exportação de Progresso
```bash
npm install pdfkit exceljs
```

```typescript
// GET /api/export/pdf
// Gera PDF com progresso, gráficos, data da prova

// GET /api/export/csv
// CSV: materia,topico,subtopico,concluido,data_conclusao
```

#### 3.3 Sessões de Estudo (Tracking de Horas)
```typescript
// POST /api/study-sessions
// Body: { date: "2025-01-15", hoursStudied: 3.5, topicsCompleted: 5 }

// GET /api/study-sessions?month=2025-01
// Retorna histórico do mês
```

---

## 🐳 Docker Multi-Stage Build (Produção)

```dockerfile
# .docker/api.Dockerfile
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build

FROM node:18-alpine AS production
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY package.json ./

EXPOSE 3001
HEALTHCHECK --interval=30s --timeout=3s \
  CMD node -e "require('http').get('http://localhost:3001/health',(r)=>{process.exit(r.statusCode===200?0:1)})"

CMD ["node", "dist/index.js"]
```

---

## 🔒 Segurança - Checklist

### Variáveis de Ambiente (.env)
```env
# API Configuration
GEMINI_API_KEY=sua_nova_chave_aqui
SUPABASE_URL=https://imwohmhgzamdahfiahdk.supabase.co
SUPABASE_SERVICE_ROLE=sua_nova_chave_service_role

# Security
NODE_ENV=production
CORS_ORIGIN=https://seu-dominio.com

# Rate Limiting
RATE_LIMIT_WINDOW_MS=900000  # 15 minutos
RATE_LIMIT_MAX_REQUESTS=100
```

### Validação com Zod
```typescript
// src/config/env.ts
import { z } from 'zod'

const envSchema = z.object({
  NODE_ENV: z.enum(['development', 'production', 'test']),
  PORT: z.string().transform(Number).default('3001'),
  GEMINI_API_KEY: z.string().min(1, "Gemini API key é obrigatória"),
  SUPABASE_URL: z.string().url(),
  SUPABASE_SERVICE_ROLE: z.string().min(1),
  CORS_ORIGIN: z.string().url().optional(),
})

export const env = envSchema.parse(process.env)
```

### Proteções Implementadas
- ✅ **Helmet.js** - Headers de segurança (XSS, clickjacking, etc.)
- ✅ **Rate Limiting** - Prevenir abuso de API
- ✅ **CORS Restritivo** - Apenas frontend autorizado
- ✅ **Input Validation** - Zod em todos os endpoints
- ✅ **Error Handling** - Nunca expor stack traces em produção
- ✅ **Environment Variables** - Nunca hardcode secrets

---

## 📊 Priorização de Tarefas

### 🔥 AGORA (Semana 1)
1. ✅ **Criar .coderabbit.yaml** (CONCLUÍDO)
2. 🔄 **Revogar API keys expostas** (URGENTE!)
3. 🔄 **Migrar para Supabase** (você já tem configurado)
4. 🔄 **Adicionar validação Zod**

### 📅 PRÓXIMA SEMANA
5. Migrar backend para TypeScript
6. Implementar rate limiting
7. Adicionar Helmet.js

### 🎯 FUTURO (Quando Necessário)
8. Estatísticas de estudo
9. Exportação PDF/CSV
10. Tracking de sessões de estudo

---

## 🤔 Decisões Arquiteturais

### Por que NÃO implementar autenticação agora?
- ✅ Dashboard é pessoal (uso individual)
- ✅ Adiciona complexidade desnecessária
- ✅ Pode ser implementado no futuro se necessário (Supabase Auth é trivial)

### Por que usar Supabase em vez de SQLite local?
- ✅ Você já tem configurado
- ✅ Backups automáticos
- ✅ Dashboard visual para debug
- ✅ Melhor para produção (Docker + Supabase é mais confiável)
- ✅ Fácil escalabilidade (se quiser compartilhar com amigos futuramente)

### Por que manter Gemini no backend?
- ✅ Protege API key (não exposta no frontend)
- ✅ Permite rate limiting centralizado
- ✅ Facilita logging e monitoramento de uso

---

## 📚 Recursos Úteis

**Supabase:**
- Dashboard: https://supabase.com/dashboard/project/imwohmhgzamdahfiahdk
- Docs: https://supabase.com/docs/reference/javascript/introduction
- JS Client: https://supabase.com/docs/reference/javascript/select

**TypeScript + Express:**
- Express com TS: https://blog.logrocket.com/how-to-set-up-node-typescript-express/
- Zod Validation: https://zod.dev/

**Docker:**
- Multi-stage builds: https://docs.docker.com/build/building/multi-stage/
- Healthchecks: https://docs.docker.com/engine/reference/builder/#healthcheck

---

## 🚧 FASE 5: Próximas Melhorias (Futuro - Pós TCU)

> ⚠️ **IMPORTANTE:** Estas melhorias são para **DEPOIS DO CONCURSO TCU**!
> **AGORA:** Foco total nos estudos! 📚 O dashboard já está funcional e seguro.

### 5.1 TypeScript Migration (Complexidade: Alta)
**Duração:** 2-3 dias | **Prioridade:** Média

**Por quê?** Melhor manutenibilidade, type safety, alinhamento com frontend

**Ações:**
```bash
# Nova estrutura TypeScript
server/
├── src/
│   ├── index.ts
│   ├── app.ts
│   ├── config/
│   │   ├── supabase.ts
│   │   └── env.ts          # Validação com Zod
│   ├── routes/
│   ├── controllers/
│   ├── services/
│   ├── middlewares/
│   └── types/              # Interfaces e tipos
├── tsconfig.json
└── package.json
```

**Dependências:**
```json
{
  "devDependencies": {
    "typescript": "^5.3",
    "ts-node-dev": "^2.0",
    "@types/express": "^4.17",
    "@types/cors": "^2.8",
    "@types/node": "^20.0"
  }
}
```

**Benefícios:**
- Type safety em toda a codebase
- Melhor IntelliSense no IDE
- Detecção de erros em tempo de compilação
- Padrão de mercado para APIs Node.js

---

### 5.2 Testing (Vitest/Jest) (Complexidade: Média)
**Duração:** 2-3 dias | **Prioridade:** Alta (para produção)

**Por quê?** Garantir que mudanças futuras não quebrem funcionalidades existentes

**Stack de Testes:**
```json
{
  "devDependencies": {
    "vitest": "^1.0",           // Framework de testes (mais rápido que Jest)
    "supertest": "^6.3",        // Testes de API
    "@vitest/ui": "^1.0",       // Interface visual
    "c8": "^9.0"                // Code coverage
  }
}
```

**Estrutura:**
```bash
server/
├── __tests__/
│   ├── integration/
│   │   ├── progress.test.ts      # Testes de endpoints
│   │   ├── gemini-proxy.test.ts
│   │   └── health.test.ts
│   ├── unit/
│   │   ├── validation.test.ts    # Testes de middlewares
│   │   └── supabase.test.ts
│   └── setup.ts                   # Configuração global
└── vitest.config.ts
```

**Exemplos de Testes:**
```typescript
// __tests__/integration/progress.test.ts
describe('POST /api/progress', () => {
  it('deve adicionar IDs válidos', async () => {
    const res = await request(app)
      .post('/api/progress')
      .send({ ids: ['1.1.1', '1.1.2'] })
      .expect(200)

    expect(res.body.added).toBe(2)
  })

  it('deve rejeitar IDs inválidos', async () => {
    const res = await request(app)
      .post('/api/progress')
      .send({ ids: [] })
      .expect(400)

    expect(res.body.error).toBe('Dados inválidos')
  })
})
```

**Cobertura Mínima:** 70% (ideal: 80%+)

**Scripts:**
```json
{
  "scripts": {
    "test": "vitest",
    "test:ui": "vitest --ui",
    "test:coverage": "vitest run --coverage"
  }
}
```

---

### 5.3 CI/CD com GitHub Actions (Complexidade: Média)
**Duração:** 1-2 dias | **Prioridade:** Alta (para produção)

**Por quê?** Automatizar testes, builds e deploys

**Pipeline:**
```yaml
# .github/workflows/backend-ci.yml
name: Backend CI/CD

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '18'
      - run: npm ci
      - run: npm run test:coverage
      - uses: codecov/codecov-action@v3  # Upload coverage

  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
      - run: npm ci
      - run: npm run lint

  build:
    runs-on: ubuntu-latest
    needs: [test, lint]
    steps:
      - uses: actions/checkout@v4
      - run: docker build -f Dockerfile.api -t tcu-api .

  deploy:
    runs-on: ubuntu-latest
    needs: [build]
    if: github.ref == 'refs/heads/main'
    steps:
      # Deploy para Railway, Render, Fly.io, etc.
      - run: echo "Deploy to production"
```

**Benefícios:**
- Testes automáticos em cada PR
- Deploy automático em main
- Code coverage tracking
- Detecção precoce de bugs

---

### 5.4 Monitoring e Logs Estruturados (Complexidade: Média)
**Duração:** 1-2 dias | **Prioridade:** Média (importante para produção)

**Sentry (Error Tracking):**
```bash
npm install @sentry/node @sentry/profiling-node
```

```typescript
// server/src/config/sentry.ts
import * as Sentry from "@sentry/node"

Sentry.init({
  dsn: process.env.SENTRY_DSN,
  environment: process.env.NODE_ENV,
  tracesSampleRate: 1.0,
  profilesSampleRate: 1.0,
})

// No app.ts:
app.use(Sentry.Handlers.requestHandler())
app.use(Sentry.Handlers.errorHandler())
```

**Winston (Logs Estruturados):**
```bash
npm install winston
```

```typescript
// server/src/config/logger.ts
import winston from 'winston'

export const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json()
  ),
  transports: [
    new winston.transports.File({ filename: 'error.log', level: 'error' }),
    new winston.transports.File({ filename: 'combined.log' }),
  ]
})

// Desenvolvimento: também logar no console
if (process.env.NODE_ENV !== 'production') {
  logger.add(new winston.transports.Console({
    format: winston.format.simple(),
  }))
}
```

**Uso:**
```typescript
import { logger } from './config/logger'

logger.info('Usuário acessou endpoint', {
  userId: req.user?.id,
  endpoint: req.path,
  method: req.method
})

logger.error('Erro ao buscar progresso', {
  error: err.message,
  stack: err.stack
})
```

**Benefícios:**
- Rastreamento de erros em produção (Sentry)
- Logs estruturados para análise (Winston)
- Alertas automáticos quando erros ocorrem
- Debugging facilitado em produção

---

### 5.5 Features Avançadas (Complexidade: Variável)

#### 5.5.1 Estatísticas de Estudo Detalhadas
**Duração:** 1-2 dias | **Prioridade:** Média

**Endpoints:**
```typescript
// GET /api/stats/summary
{
  totalTopics: 120,
  completedTopics: 45,
  progressPercentage: 37.5,
  materiaStats: [
    { materiaId: "1", name: "Redes", completed: 10, total: 25, percentage: 40 }
  ],
  recentActivity: [
    { itemId: "1.2.3", completedAt: "2025-01-15T10:30:00Z" }
  ],
  studyStreak: 7  // dias consecutivos estudando
}

// GET /api/stats/heatmap?year=2025
// Retorna dados para gráfico de heatmap (estilo GitHub contributions)
{
  "2025-01-15": 5,  // 5 tópicos concluídos neste dia
  "2025-01-16": 3
}
```

**Schema Supabase (adicional):**
```sql
CREATE TABLE study_sessions (
  id SERIAL PRIMARY KEY,
  study_date DATE NOT NULL,
  hours_studied DECIMAL(4,2),
  topics_completed INTEGER DEFAULT 0,
  notes TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_study_sessions_date ON study_sessions(study_date);
```

---

#### 5.5.2 Exportação de Progresso (PDF/CSV)
**Duração:** 2 dias | **Prioridade:** Baixa

**Dependências:**
```bash
npm install pdfkit exceljs
```

**Endpoints:**
```typescript
// GET /api/export/pdf
// Gera PDF com:
// - Progresso geral (gráficos)
// - Progresso por matéria
// - Lista de tópicos concluídos
// - Data da prova e tempo restante

// GET /api/export/csv
// Gera CSV com:
// materia,topico,subtopico,concluido,data_conclusao
// "Redes","TCP/IP","Camadas",true,"2025-01-15T10:30:00Z"
```

**Exemplo de Uso (PDF):**
```typescript
import PDFDocument from 'pdfkit'

app.get('/api/export/pdf', async (req, res) => {
  const doc = new PDFDocument()
  res.setHeader('Content-Type', 'application/pdf')
  res.setHeader('Content-Disposition', 'attachment; filename=progresso-tcu.pdf')

  doc.pipe(res)

  // Header
  doc.fontSize(20).text('Relatório de Progresso - TCU TI 2025', 100, 50)

  // Estatísticas
  const stats = await getGlobalStats()
  doc.fontSize(12).text(`Progresso Geral: ${stats.percentage}%`, 100, 100)

  // ... adicionar gráficos, tabelas, etc.

  doc.end()
})
```

---

#### 5.5.3 Sessões de Estudo com Pomodoro
**Duração:** 2 dias | **Prioridade:** Baixa

**Endpoints:**
```typescript
// POST /api/study-sessions
// Body: { date: "2025-01-15", hoursStudied: 3.5, topicsCompleted: 5, notes: "Estudei redes" }

// GET /api/study-sessions?month=2025-01
// Retorna histórico do mês

// GET /api/study-sessions/streak
// Retorna dias consecutivos de estudo
```

---

## 📅 Timeline Sugerido (Pós-TCU)

```
Fase Atual: ✅ Backend v2.0 (Supabase + Segurança)
│
├─ AGORA: 📚 FOCO TOTAL NO TCU!
│
└─ Após aprovação no concurso:
    │
    ├─ Semana 1-2: TypeScript Migration
    ├─ Semana 3: Testing (Vitest + 70% coverage)
    ├─ Semana 4: CI/CD (GitHub Actions)
    ├─ Semana 5: Monitoring (Sentry + Winston)
    └─ Semana 6+: Features Avançadas (opcional)
```

---

## 🎯 Priorização Clara

### 🔥 **AGORA (Pré-TCU):**
- ✅ Supabase funcionando
- ✅ Segurança implementada
- ✅ API estável
- **🚫 NÃO MEXER MAIS NO BACKEND**
- **📚 ESTUDAR PARA O CONCURSO**

### 📅 **Pós-TCU (Opcional):**
1. **Alta Prioridade:** Testing + CI/CD (produção robusta)
2. **Média Prioridade:** TypeScript + Monitoring (qualidade de código)
3. **Baixa Prioridade:** Features Avançadas (nice to have)

---

## 🎓 Observações Finais

Este é um **roadmap vivo**. Ajuste conforme necessário baseado em:
- Tempo disponível para estudar para o TCU (prioridade!)
- Complexidade real encontrada durante implementação
- Necessidades reais de funcionalidades

**Lembre-se:** O objetivo principal é estudar para o concurso. O dashboard é uma ferramenta de apoio, não o foco principal! 📚✨

---

**Última atualização:** 2025-01-15
**Versão:** 2.0 (Supabase + Segurança + Roadmap Futuro)
