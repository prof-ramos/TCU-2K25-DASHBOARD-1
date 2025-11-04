# 🏗️ Arquitetura do Sistema

> Documentação técnica da arquitetura, decisões de design e estrutura do TCU TI 2025 Study Dashboard

---

## 📋 Índice

- [Visão Geral](#visão-geral)
- [Arquitetura de Alto Nível](#arquitetura-de-alto-nível)
- [Frontend](#frontend)
- [Backend](#backend)
- [Banco de Dados](#banco-de-dados)
- [Integrações](#integrações)
- [Fluxo de Dados](#fluxo-de-dados)
- [Decisões Técnicas](#decisões-técnicas)
- [Padrões de Código](#padrões-de-código)
- [Segurança](#segurança)
- [Performance](#performance)

---

## Visão Geral

O TCU TI 2025 Study Dashboard é uma aplicação web full-stack construída com arquitetura **client-server** com foco em:

- ✅ **Simplicidade**: Fácil de entender e manter
- ⚡ **Performance**: Carregamento rápido e UX fluida
- 🔒 **Segurança**: Proteção de dados e API keys
- 📱 **Responsividade**: Funciona em todos os dispositivos
- 🧪 **Testabilidade**: Alto grau de cobertura de testes

### Princípios Arquiteturais

1. **Separation of Concerns**: Divisão clara entre UI, lógica de negócio e dados
2. **Component-Based**: Componentes reutilizáveis e modulares
3. **Type Safety**: TypeScript em todo o codebase
4. **Progressive Enhancement**: Funciona sem backend (localStorage fallback)
5. **API-First**: Backend desacoplado do frontend

---

## Arquitetura de Alto Nível

```
┌─────────────────────────────────────────────────────────────┐
│                        USUÁRIO                              │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                    FRONTEND (React)                         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Pages      │  │  Components  │  │   Contexts   │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Services   │  │    Hooks     │  │    Types     │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└────────────┬────────────────────┬────────────────────────────┘
             │                    │
             │ localStorage       │ HTTP/REST
             │ (fallback)         │
             │                    ▼
             │         ┌─────────────────────────┐
             │         │   BACKEND (Express)     │
             │         │  ┌──────────────────┐   │
             │         │  │   API Routes     │   │
             │         │  └──────────────────┘   │
             │         └───────────┬─────────────┘
             │                     │
             │                     ▼
             │         ┌─────────────────────────┐
             │         │   SUPABASE (PostgreSQL) │
             │         │  ┌──────────────────┐   │
             │         │  │   materias       │   │
             │         │  │   topics         │   │
             │         │  │   subtopics      │   │
             │         │  │   user_progress  │   │
             │         │  └──────────────────┘   │
             │         └─────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────────────────────────┐
│              INTEGRAÇÕES EXTERNAS                           │
│  ┌──────────────────┐           ┌──────────────────┐        │
│  │  Google Gemini   │           │   Supabase Auth  │        │
│  │      API         │           │   (futuro)       │        │
│  └──────────────────┘           └──────────────────┘        │
└─────────────────────────────────────────────────────────────┘
```

---

## Frontend

### Tecnologias

- **React 19**: Biblioteca UI com hooks modernos
- **TypeScript 5.8**: Type safety e melhor DX
- **Vite 6**: Build tool ultrarrápida
- **Tailwind CSS**: Utility-first CSS
- **Radix UI**: Componentes acessíveis headless

### Estrutura de Diretórios

```
src/
├── components/          # Componentes React
│   ├── ui/              # Componentes primitivos (shadcn/ui)
│   │   ├── accordion.tsx
│   │   ├── button.tsx
│   │   ├── card.tsx
│   │   ├── checkbox.tsx
│   │   ├── dialog.tsx
│   │   └── progress.tsx
│   ├── common/          # Layout e componentes compartilhados
│   │   ├── Header.tsx
│   │   ├── Layout.tsx
│   │   └── ThemeToggle.tsx
│   └── features/        # Componentes de funcionalidades
│       ├── Countdown.tsx
│       ├── GeminiInfoModal.tsx
│       ├── MateriaCard.tsx
│       ├── ProgressBar.tsx
│       └── TopicItem.tsx
├── contexts/            # Estado global (React Context)
│   ├── ProgressoContext.tsx
│   └── ThemeContext.tsx
├── hooks/               # Hooks customizados
│   ├── useLocalStorage.ts
│   ├── useProgresso.ts
│   └── useTheme.ts
├── pages/               # Páginas/rotas
│   ├── Dashboard.tsx
│   └── MateriaPage.tsx
├── services/            # Lógica de API
│   ├── databaseService.ts
│   └── geminiService.ts
├── types/               # Definições TypeScript
│   └── types.ts
├── data/                # Dados estáticos
│   └── edital.ts
├── lib/                 # Utilitários
│   └── utils.ts
├── __tests__/           # Testes
│   ├── contexts/
│   ├── hooks/
│   ├── services/
│   ├── components/
│   └── utils/
├── App.tsx              # Configuração de rotas
└── main.tsx             # Entry point
```

### Camadas da Aplicação

#### 1. **Presentation Layer** (Components + Pages)
- Componentes puramente visuais
- Não contêm lógica de negócio
- Recebem dados via props ou contexts

#### 2. **Business Logic Layer** (Contexts + Hooks)
- Gerenciamento de estado global
- Lógica de negócio reutilizável
- Regras de validação

#### 3. **Data Access Layer** (Services)
- Comunicação com APIs
- Transformação de dados
- Cache e persistência

#### 4. **Type Layer** (Types)
- Interfaces e tipos compartilhados
- Garantia de type safety

### Padrões de Componentes

#### Componente Apresentacional (Dumb Component)

```typescript
// components/ui/button.tsx
interface ButtonProps {
  children: React.ReactNode;
  variant?: 'primary' | 'secondary';
  onClick?: () => void;
}

export const Button: React.FC<ButtonProps> = ({ 
  children, 
  variant = 'primary',
  onClick 
}) => {
  return (
    <button 
      className={cn('btn', `btn-${variant}`)}
      onClick={onClick}
    >
      {children}
    </button>
  );
};
```

#### Componente Inteligente (Smart Component)

```typescript
// components/features/MateriaCard.tsx
export const MateriaCard: React.FC<{ materia: Materia }> = ({ materia }) => {
  const { progresso } = useProgresso();
  const navigate = useNavigate();
  
  const completedTopics = calculateProgress(materia, progresso);
  
  return (
    <Card onClick={() => navigate(`/materia/${materia.slug}`)}>
      <CardTitle>{materia.name}</CardTitle>
      <ProgressBar value={completedTopics.percentage} />
      <CardFooter>{completedTopics.count} / {completedTopics.total}</CardFooter>
    </Card>
  );
};
```

### Estado Global (Contexts)

#### ProgressoContext

Gerencia o progresso de estudos do usuário:

```typescript
interface ProgressoContextType {
  completedIds: Set<string>;
  toggleTopic: (id: string) => void;
  getTotalProgress: () => number;
}
```

**Responsabilidades:**
- Manter lista de IDs completados
- Sincronizar com localStorage e API
- Calcular estatísticas de progresso

#### ThemeContext

Gerencia o tema da aplicação:

```typescript
interface ThemeContextType {
  theme: 'light' | 'dark';
  toggleTheme: () => void;
}
```

**Responsabilidades:**
- Alternar entre temas
- Persistir preferência
- Aplicar classes CSS

---

## Backend

### Tecnologias

- **Node.js 20**: Runtime JavaScript
- **Express.js 4**: Framework web minimalista
- **Supabase**: Backend-as-a-Service (PostgreSQL)

### Estrutura

```
server/
├── index.js                 # Entry point
├── config/
│   └── supabase.js          # Cliente Supabase
├── routes/
│   └── progress.js          # Rotas de progresso
├── middleware/
│   ├── cors.js              # Configuração CORS
│   └── errorHandler.js      # Tratamento de erros
├── utils/
│   └── logger.js            # Logging
└── package.json
```

### API Endpoints

#### GET /api/progress
Retorna o progresso do usuário

**Response:**
```json
{
  "completedIds": ["CON-0-1", "CON-0-2", ...]
}
```

#### POST /api/progress
Atualiza o progresso do usuário

**Request:**
```json
{
  "completedIds": ["CON-0-1", "CON-0-2", ...]
}
```

**Response:**
```json
{
  "success": true,
  "count": 42
}
```

### Middleware Stack

```
Request
  ↓
CORS Middleware
  ↓
JSON Parser
  ↓
Helmet (Security)
  ↓
Rate Limiter
  ↓
Route Handler
  ↓
Error Handler
  ↓
Response
```

---

## Banco de Dados

### Schema (Supabase/PostgreSQL)

```sql
-- Matérias (16 registros)
CREATE TABLE materias (
  id VARCHAR(50) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  slug VARCHAR(255) UNIQUE NOT NULL,
  type VARCHAR(50) NOT NULL CHECK (type IN ('CONHECIMENTOS GERAIS', 'CONHECIMENTOS ESPECÍFICOS')),
  created_at TIMESTAMP DEFAULT NOW()
);

-- Tópicos principais (122 registros)
CREATE TABLE topics (
  id VARCHAR(100) PRIMARY KEY,
  materia_id VARCHAR(50) REFERENCES materias(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  order_index INTEGER,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Subtópicos (380 registros)
CREATE TABLE subtopics (
  id VARCHAR(150) PRIMARY KEY,
  topic_id VARCHAR(100) REFERENCES topics(id) ON DELETE CASCADE,
  parent_id VARCHAR(150) REFERENCES subtopics(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  level INTEGER DEFAULT 1,
  order_index INTEGER,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Progresso do usuário
CREATE TABLE user_progress (
  id SERIAL PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id),
  completed_ids JSONB DEFAULT '[]'::jsonb,
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Índices para performance
CREATE INDEX idx_topics_materia ON topics(materia_id);
CREATE INDEX idx_subtopics_topic ON subtopics(topic_id);
CREATE INDEX idx_subtopics_parent ON subtopics(parent_id);
CREATE INDEX idx_user_progress_user ON user_progress(user_id);
```

### Relacionamentos

```
materias (1) ──< (N) topics
topics (1) ──< (N) subtopics
subtopics (1) ──< (N) subtopics (hierarquia)
```

---

## Integrações

### Google Gemini API

**Propósito**: Gerar explicações inteligentes sobre tópicos do edital

**Configuração**:
```typescript
const genAI = new GoogleGenerativeAI(import.meta.env.VITE_GEMINI_API_KEY);
const model = genAI.getGenerativeModel({ 
  model: 'gemini-2.0-flash-exp',
  generationConfig: {
    temperature: 0.7,
    topP: 0.95,
    topK: 40,
    maxOutputTokens: 2048,
  }
});
```

**Grounding** (Busca fundamentada):
- Retorna fontes verificáveis
- Links para documentação oficial
- Contexto atualizado

### Supabase

**Serviços utilizados**:
- ✅ **Database**: PostgreSQL gerenciado
- ✅ **Storage**: (planejado para futuro)
- 🚧 **Auth**: (planejado para v1.1)
- 🚧 **Realtime**: (planejado para v2.0)

---

## Fluxo de Dados

### Marcação de Tópico como Completo

```
Usuário clica no checkbox
         ↓
TopicItem.tsx dispara evento
         ↓
ProgressoContext.toggleTopic(id)
         ↓
Atualiza Set<string> local
         ↓
┌────────┴────────┐
│                 │
Salva no          Envia para API
localStorage      (POST /api/progress)
│                 │
└────────┬────────┘
         ↓
UI atualiza instantaneamente
         ↓
Backend confirma (ou fallback)
```

### Carregamento Inicial

```
Usuário acessa aplicação
         ↓
App.tsx renderiza
         ↓
ProgressoContext.useEffect()
         ↓
┌────────┴────────┐
│                 │
Tenta buscar      Carrega de
da API            localStorage
│                 │
└────────┬────────┘
         ↓
Merge dos dados (API priority)
         ↓
Set<string> populado
         ↓
Componentes renderizam com progresso
```

---

## Decisões Técnicas

### Por que React 19?

- ✅ Hooks modernos e performance otimizada
- ✅ Suspense e Concurrent Rendering
- ✅ Ecossistema maduro
- ✅ Server Components (futuro)

### Por que Vite em vez de Create React App?

- ⚡ Build 10-100x mais rápida
- 🔥 Hot Module Replacement instantâneo
- 📦 Tree-shaking otimizado
- 🎯 Configuração simples

### Por que Tailwind CSS?

- 🚀 Desenvolvimento rápido
- 📦 Bundle size pequeno (purge CSS)
- 🎨 Design system consistente
- 🔧 Customização fácil

### Por que Supabase em vez de Firebase?

- 🐘 PostgreSQL (SQL relacional)
- 🔓 Open-source
- 💰 Preço melhor
- 🛠️ Maior controle

### Por que localStorage + API?

- ⚡ UX instantânea (otimistic UI)
- 📴 Funciona offline
- 🔄 Sincronização em background
- 🛡️ Fallback robusto

---

## Padrões de Código

### Nomenclatura

```typescript
// Componentes: PascalCase
export const MateriaCard: React.FC<Props> = () => {};

// Hooks: camelCase com prefixo "use"
export const useProgresso = () => {};

// Contexts: PascalCase com sufixo "Context"
export const ProgressoContext = createContext();

// Tipos: PascalCase
export interface Materia { }

// Constantes: UPPER_SNAKE_CASE
export const API_BASE_URL = 'http://localhost:3001';

// Funções utilitárias: camelCase
export const calculateProgress = () => {};
```

### Estrutura de Arquivo

```typescript
// 1. Imports externos
import React from 'react';
import { useNavigate } from 'react-router-dom';

// 2. Imports internos
import { Button } from '@/components/ui/button';
import { useProgresso } from '@/hooks/useProgresso';

// 3. Types
interface Props {
  materia: Materia;
}

// 4. Constantes
const DEFAULT_COLOR = '#000';

// 5. Componente
export const Component: React.FC<Props> = ({ materia }) => {
  // Hooks
  const navigate = useNavigate();
  const { progresso } = useProgresso();
  
  // Estado local
  const [isOpen, setIsOpen] = useState(false);
  
  // Efeitos
  useEffect(() => {}, []);
  
  // Handlers
  const handleClick = () => {};
  
  // Render
  return <div />;
};
```

### TypeScript

```typescript
// ✅ BOM: Tipos explícitos
interface MateriaCardProps {
  materia: Materia;
  onNavigate?: () => void;
}

// ❌ RUIM: any
const Component = (props: any) => {};

// ✅ BOM: Union types
type Theme = 'light' | 'dark';

// ✅ BOM: Generics
function wrapper<T>(value: T): T {
  return value;
}
```

---

## Segurança

### API Keys

```typescript
// ✅ BOM: Variável de ambiente
const apiKey = import.meta.env.VITE_GEMINI_API_KEY;

// ❌ RUIM: Hardcoded
const apiKey = 'AIzaSy...';
```

### CORS

```javascript
// Backend: Apenas origens permitidas
app.use(cors({
  origin: process.env.NODE_ENV === 'production' 
    ? 'https://seu-dominio.com'
    : 'http://localhost:5000',
  credentials: true
}));
```

### Sanitização

```typescript
// Escape de HTML user-generated
import DOMPurify from 'dompurify';

const sanitized = DOMPurify.sanitize(userInput);
```

---

## Performance

### Code Splitting

```typescript
// Lazy loading de rotas
const MateriaPage = lazy(() => import('./pages/MateriaPage'));

<Suspense fallback={<Loading />}>
  <Route path="/materia/:slug" element={<MateriaPage />} />
</Suspense>
```

### Memoização

```typescript
// useMemo para cálculos pesados
const totalProgress = useMemo(() => {
  return calculateProgress(materias, completedIds);
}, [materias, completedIds]);

// useCallback para funções
const handleToggle = useCallback((id: string) => {
  toggleTopic(id);
}, [toggleTopic]);
```

### Bundle Size

```bash
# Análise do bundle
npm run build
npx vite-bundle-visualizer

# Resultados esperados:
# - Main bundle: ~200KB
# - Vendor chunks: ~300KB
# - Total (gzip): ~150KB
```

---

## Escalabilidade

### Limitações Atuais

- **Usuários**: Suporta ~10k usuários simultâneos
- **Dados**: 380 subtópicos * 10k usuários = 3.8M registros OK
- **API Rate Limit**: Gemini API 60 req/min (free tier)

### Plano de Escalabilidade

1. **v1.1**: Implementar cache Redis
2. **v1.5**: Mover para CDN (Cloudflare)
3. **v2.0**: Migrar para arquitetura serverless
4. **v3.0**: Implementar GraphQL + Apollo

---

## Diagramas

### Fluxo de Autenticação (Futuro - v1.1)

```
┌─────────┐
│  User   │
└────┬────┘
     │ 1. Login
     ▼
┌─────────────┐
│  Frontend   │
└──────┬──────┘
       │ 2. POST /auth/login
       ▼
┌──────────────┐
│   Backend    │
└──────┬───────┘
       │ 3. Validate
       ▼
┌──────────────┐
│  Supabase    │
│    Auth      │
└──────┬───────┘
       │ 4. JWT Token
       ▼
┌──────────────┐
│  Frontend    │
│  (stores in  │
│  localStorage)│
└──────────────┘
```

---

## Referências

- [React Best Practices](https://react.dev/learn)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [Tailwind CSS Docs](https://tailwindcss.com/docs)
- [Supabase Documentation](https://supabase.com/docs)
- [Vite Guide](https://vitejs.dev/guide/)

---

[⬅ Voltar](../README.md) | [📘 Instalação](./INSTALLATION.md) | [💻 Desenvolvimento](./DEVELOPMENT.md)
