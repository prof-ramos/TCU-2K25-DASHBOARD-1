# 💻 Guia de Desenvolvimento

> Guia completo para desenvolvedores que desejam contribuir ou modificar o TCU TI 2025 Study Dashboard

---

## 📋 Índice

- [Configuração do Ambiente](#configuração-do-ambiente)
- [Estrutura do Código](#estrutura-do-código)
- [Padrões de Desenvolvimento](#padrões-de-desenvolvimento)
- [Criando Novos Componentes](#criando-novos-componentes)
- [Trabalhando com Estado](#trabalhando-com-estado)
- [Integrações com APIs](#integrações-com-apis)
- [Estilização](#estilização)
- [Debugging](#debugging)
- [Boas Práticas](#boas-práticas)

---

## Configuração do Ambiente

### 1. Ferramentas Recomendadas

#### Editor
- **Visual Studio Code** (recomendado)
  - Extensões essenciais:
    - ESLint
    - Prettier
    - TypeScript and JavaScript Language Features
    - Tailwind CSS IntelliSense
    - Error Lens

#### Terminal
- **iTerm2** (Mac) ou **Windows Terminal** (Windows)
- **Oh My Zsh** para melhor experiência

### 2. Configuração do VSCode

Crie `.vscode/settings.json`:

```json
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  },
  "typescript.tsdk": "node_modules/typescript/lib",
  "typescript.enablePromptUseWorkspaceTsdk": true,
  "tailwindCSS.experimental.classRegex": [
    ["cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]"],
    ["cn\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)"]
  ]
}
```

### 3. Clone e Setup

```bash
# Clone o repositório
git clone https://github.com/seu-usuario/tcu-ti-2025-study-dashboard.git
cd tcu-ti-2025-study-dashboard

# Instale dependências
npm install

# Configure variáveis de ambiente
cp .env.example .env
# Edite .env com suas credenciais

# Inicie o desenvolvimento
npm run dev
```

---

## Estrutura do Código

### Organização de Arquivos

```
src/
├── components/       # Componentes React
│   ├── ui/           # Primitivos reutilizáveis
│   ├── common/       # Layout e navegação
│   └── features/     # Componentes de negócio
├── contexts/         # Estado global
├── hooks/            # Lógica reutilizável
├── pages/            # Rotas/páginas
├── services/         # APIs e integrações
├── types/            # TypeScript types
├── data/             # Dados estáticos
└── __tests__/        # Testes
```

### Convenções de Nomenclatura

| Tipo | Convenção | Exemplo |
|------|-----------|---------|
| **Componentes** | PascalCase | `MateriaCard.tsx` |
| **Hooks** | camelCase + use | `useProgresso.ts` |
| **Contexts** | PascalCase + Context | `ThemeContext.tsx` |
| **Services** | camelCase + Service | `databaseService.ts` |
| **Types** | PascalCase | `Materia`, `Topic` |
| **Utilitários** | camelCase | `calculateProgress` |

---

## Padrões de Desenvolvimento

### TypeScript Strict Mode

Todos os arquivos devem usar TypeScript strict:

```typescript
// ✅ BOM: Tipos explícitos
interface Props {
  materia: Materia;
  onSelect?: (id: string) => void;
}

const Component: React.FC<Props> = ({ materia, onSelect }) => {
  // ...
};

// ❌ RUIM: any
const Component = (props: any) => {
  // ...
};
```

### Imports Organizados

```typescript
// 1. React e bibliotecas externas
import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';

// 2. Componentes UI
import { Button } from '@/components/ui/button';
import { Card } from '@/components/ui/card';

// 3. Hooks e contextos
import { useProgresso } from '@/hooks/useProgresso';
import { useTheme } from '@/contexts/ThemeContext';

// 4. Services e utils
import { calculateProgress } from '@/lib/utils';

// 5. Types
import type { Materia } from '@/types/types';
```

### Componentes Funcionais

Use sempre componentes funcionais com hooks:

```typescript
// ✅ BOM: Componente funcional moderno
export const MateriaCard: React.FC<Props> = ({ materia }) => {
  const [isHovered, setIsHovered] = useState(false);
  
  useEffect(() => {
    // Side effects
  }, []);
  
  return <div />;
};

// ❌ RUIM: Class components (legado)
class MateriaCard extends React.Component {
  // ...
}
```

---

## Criando Novos Componentes

### 1. Componente UI (Primitivo)

Localização: `src/components/ui/`

```typescript
// src/components/ui/badge.tsx
import * as React from 'react';
import { cva, type VariantProps } from 'class-variance-authority';
import { cn } from '@/lib/utils';

const badgeVariants = cva(
  'inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-semibold',
  {
    variants: {
      variant: {
        default: 'bg-blue-100 text-blue-800',
        success: 'bg-green-100 text-green-800',
        warning: 'bg-yellow-100 text-yellow-800',
        danger: 'bg-red-100 text-red-800',
      },
    },
    defaultVariants: {
      variant: 'default',
    },
  }
);

export interface BadgeProps
  extends React.HTMLAttributes<HTMLDivElement>,
    VariantProps<typeof badgeVariants> {}

export const Badge: React.FC<BadgeProps> = ({ 
  className, 
  variant, 
  ...props 
}) => {
  return (
    <div 
      className={cn(badgeVariants({ variant }), className)} 
      {...props} 
    />
  );
};
```

### 2. Componente de Feature

Localização: `src/components/features/`

```typescript
// src/components/features/StatisticsCard.tsx
import React from 'react';
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card';
import { ProgressBar } from '@/components/ui/progress-bar';
import { useProgresso } from '@/hooks/useProgresso';
import type { Materia } from '@/types/types';

interface StatisticsCardProps {
  materia: Materia;
}

export const StatisticsCard: React.FC<StatisticsCardProps> = ({ materia }) => {
  const { getTotalProgress } = useProgresso();
  const progress = getTotalProgress(materia.id);

  return (
    <Card>
      <CardHeader>
        <CardTitle>{materia.name}</CardTitle>
      </CardHeader>
      <CardContent>
        <ProgressBar value={progress} />
        <p className="text-sm text-muted-foreground mt-2">
          {progress}% concluído
        </p>
      </CardContent>
    </Card>
  );
};
```

### 3. Página

Localização: `src/pages/`

```typescript
// src/pages/StatisticsPage.tsx
import React from 'react';
import { Layout } from '@/components/common/Layout';
import { StatisticsCard } from '@/components/features/StatisticsCard';
import { getEdital } from '@/data/edital';

export const StatisticsPage: React.FC = () => {
  const edital = getEdital();

  return (
    <Layout>
      <h1 className="text-3xl font-bold mb-6">Estatísticas</h1>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        {edital.materias.map((materia) => (
          <StatisticsCard key={materia.id} materia={materia} />
        ))}
      </div>
    </Layout>
  );
};
```

---

## Trabalhando com Estado

### useState

Para estado local:

```typescript
const [count, setCount] = useState<number>(0);
const [isOpen, setIsOpen] = useState(false);
const [items, setItems] = useState<string[]>([]);
```

### useEffect

Para efeitos colaterais:

```typescript
// Executa uma vez ao montar
useEffect(() => {
  fetchData();
}, []);

// Executa quando dependências mudam
useEffect(() => {
  updateProgress(completedIds);
}, [completedIds]);

// Cleanup
useEffect(() => {
  const timer = setInterval(() => {}, 1000);
  return () => clearInterval(timer);
}, []);
```

### Context API

Criando um novo contexto:

```typescript
// src/contexts/NotificationContext.tsx
import React, { createContext, useContext, useState, ReactNode } from 'react';

interface Notification {
  id: string;
  message: string;
  type: 'success' | 'error' | 'info';
}

interface NotificationContextType {
  notifications: Notification[];
  addNotification: (message: string, type: Notification['type']) => void;
  removeNotification: (id: string) => void;
}

const NotificationContext = createContext<NotificationContextType | undefined>(undefined);

export const NotificationProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
  const [notifications, setNotifications] = useState<Notification[]>([]);

  const addNotification = (message: string, type: Notification['type']) => {
    const id = Math.random().toString(36);
    setNotifications((prev) => [...prev, { id, message, type }]);
    
    // Auto-remove após 5s
    setTimeout(() => removeNotification(id), 5000);
  };

  const removeNotification = (id: string) => {
    setNotifications((prev) => prev.filter((n) => n.id !== id));
  };

  return (
    <NotificationContext.Provider value={{ notifications, addNotification, removeNotification }}>
      {children}
    </NotificationContext.Provider>
  );
};

export const useNotification = () => {
  const context = useContext(NotificationContext);
  if (!context) {
    throw new Error('useNotification must be used within NotificationProvider');
  }
  return context;
};
```

### Custom Hooks

```typescript
// src/hooks/useDebounce.ts
import { useState, useEffect } from 'react';

export function useDebounce<T>(value: T, delay: number): T {
  const [debouncedValue, setDebouncedValue] = useState<T>(value);

  useEffect(() => {
    const handler = setTimeout(() => {
      setDebouncedValue(value);
    }, delay);

    return () => {
      clearTimeout(handler);
    };
  }, [value, delay]);

  return debouncedValue;
}

// Uso:
const SearchComponent = () => {
  const [searchTerm, setSearchTerm] = useState('');
  const debouncedSearch = useDebounce(searchTerm, 500);
  
  useEffect(() => {
    // Só executa após 500ms sem digitação
    if (debouncedSearch) {
      performSearch(debouncedSearch);
    }
  }, [debouncedSearch]);
};
```

---

## Integrações com APIs

### Service Pattern

```typescript
// src/services/materiaService.ts
import type { Materia } from '@/types/types';

const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:3001';

export const materiaService = {
  async getAll(): Promise<Materia[]> {
    const response = await fetch(`${API_BASE_URL}/api/materias`);
    if (!response.ok) {
      throw new Error('Failed to fetch materias');
    }
    return response.json();
  },

  async getById(id: string): Promise<Materia> {
    const response = await fetch(`${API_BASE_URL}/api/materias/${id}`);
    if (!response.ok) {
      throw new Error(`Failed to fetch materia ${id}`);
    }
    return response.json();
  },

  async update(id: string, data: Partial<Materia>): Promise<Materia> {
    const response = await fetch(`${API_BASE_URL}/api/materias/${id}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data),
    });
    if (!response.ok) {
      throw new Error(`Failed to update materia ${id}`);
    }
    return response.json();
  },
};
```

### Error Handling

```typescript
// src/services/apiClient.ts
export class ApiError extends Error {
  constructor(
    public status: number,
    message: string,
    public data?: any
  ) {
    super(message);
    this.name = 'ApiError';
  }
}

export async function apiRequest<T>(
  url: string,
  options?: RequestInit
): Promise<T> {
  try {
    const response = await fetch(url, options);
    
    if (!response.ok) {
      const error = await response.json().catch(() => ({}));
      throw new ApiError(
        response.status,
        error.message || 'API request failed',
        error
      );
    }
    
    return response.json();
  } catch (error) {
    if (error instanceof ApiError) throw error;
    throw new ApiError(0, 'Network error');
  }
}

// Uso:
try {
  const data = await apiRequest<Materia[]>('/api/materias');
} catch (error) {
  if (error instanceof ApiError) {
    if (error.status === 404) {
      console.error('Not found');
    } else {
      console.error('API error:', error.message);
    }
  }
}
```

---

## Estilização

### Tailwind CSS

```typescript
// Classes básicas
<div className="flex items-center justify-between p-4 bg-white rounded-lg shadow">
  <h2 className="text-xl font-bold text-gray-900">Título</h2>
  <button className="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600">
    Ação
  </button>
</div>

// Responsividade
<div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
  {/* Mobile: 1 coluna, Tablet: 2 colunas, Desktop: 3 colunas */}
</div>

// Dark mode
<div className="bg-white dark:bg-gray-800 text-gray-900 dark:text-white">
  Conteúdo
</div>
```

### Componentes com Variantes (CVA)

```typescript
import { cva } from 'class-variance-authority';

const buttonVariants = cva(
  'inline-flex items-center justify-center rounded-md font-medium transition-colors',
  {
    variants: {
      variant: {
        default: 'bg-blue-500 text-white hover:bg-blue-600',
        outline: 'border border-gray-300 hover:bg-gray-100',
        ghost: 'hover:bg-gray-100',
      },
      size: {
        default: 'h-10 px-4 py-2',
        sm: 'h-8 px-3 text-sm',
        lg: 'h-12 px-8',
      },
    },
    defaultVariants: {
      variant: 'default',
      size: 'default',
    },
  }
);

// Uso:
<button className={buttonVariants({ variant: 'outline', size: 'sm' })}>
  Botão
</button>
```

### Utility Function (cn)

```typescript
import { cn } from '@/lib/utils';

<div className={cn(
  'base-classes',
  isActive && 'active-classes',
  isPrimary ? 'primary-classes' : 'secondary-classes',
  className // Props override
)}>
  Conteúdo
</div>
```

---

## Debugging

### React DevTools

1. Instale a extensão React DevTools
2. Inspecione componentes e props
3. Analise performance com Profiler

### Console Debugging

```typescript
// Development only
if (import.meta.env.DEV) {
  console.log('Debug info:', data);
}

// Structured logging
console.group('User Progress');
console.log('Completed IDs:', completedIds);
console.log('Total:', completedIds.size);
console.groupEnd();
```

### Error Boundaries

```typescript
// src/components/common/ErrorBoundary.tsx
import React, { Component, ReactNode } from 'react';

interface Props {
  children: ReactNode;
  fallback?: ReactNode;
}

interface State {
  hasError: boolean;
  error?: Error;
}

export class ErrorBoundary extends Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = { hasError: false };
  }

  static getDerivedStateFromError(error: Error): State {
    return { hasError: true, error };
  }

  componentDidCatch(error: Error, errorInfo: React.ErrorInfo) {
    console.error('ErrorBoundary caught:', error, errorInfo);
  }

  render() {
    if (this.state.hasError) {
      return this.props.fallback || (
        <div className="p-8 text-center">
          <h2 className="text-2xl font-bold text-red-600">Algo deu errado</h2>
          <p className="mt-2 text-gray-600">{this.state.error?.message}</p>
        </div>
      );
    }

    return this.props.children;
  }
}
```

---

## Boas Práticas

### 1. Performance

```typescript
// ✅ BOM: Memoização
const ExpensiveComponent = React.memo(({ data }) => {
  return <div>{/* ... */}</div>;
});

const MemoizedValue = useMemo(() => {
  return computeExpensiveValue(a, b);
}, [a, b]);

const MemoizedCallback = useCallback(() => {
  doSomething(a, b);
}, [a, b]);

// ❌ RUIM: Re-renders desnecessários
const Component = ({ data }) => {
  const value = computeExpensiveValue(data); // Executa sempre
  return <div />;
};
```

### 2. Acessibilidade

```typescript
// ✅ BOM: ARIA labels e roles
<button
  aria-label="Fechar modal"
  onClick={onClose}
>
  <X className="h-4 w-4" />
</button>

<nav aria-label="Navegação principal">
  {/* ... */}
</nav>

// ✅ BOM: Navegação por teclado
<div
  role="button"
  tabIndex={0}
  onClick={handleClick}
  onKeyDown={(e) => e.key === 'Enter' && handleClick()}
>
  Clicável
</div>
```

### 3. Code Splitting

```typescript
// ✅ BOM: Lazy loading
const MateriaPage = lazy(() => import('./pages/MateriaPage'));

<Suspense fallback={<LoadingSpinner />}>
  <Route path="/materia/:slug" element={<MateriaPage />} />
</Suspense>
```

### 4. Env Variables

```typescript
// ✅ BOM: Variáveis de ambiente
const apiKey = import.meta.env.VITE_GEMINI_API_KEY;

if (!apiKey) {
  console.warn('VITE_GEMINI_API_KEY not configured');
}

// ❌ RUIM: Hardcoded
const apiKey = 'AIzaSyC...';
```

---

## Scripts Úteis

```bash
# Desenvolvimento
npm run dev              # Inicia dev server

# Build
npm run build            # Build para produção
npm run preview          # Preview do build

# Qualidade de código
npm run lint             # Verifica erros ESLint
npm run lint:fix         # Corrige erros automaticamente
npm run format           # Formata código com Prettier

# Testes
npm test                 # Roda testes em watch mode
npm run test:run         # Roda testes uma vez
npm run test:coverage    # Gera relatório de cobertura
npm run test:ui          # Interface visual de testes

# Docker
npm run docker:up        # Sobe containers
npm run docker:down      # Para containers
npm run docker:logs      # Ver logs
```

---

## Recursos Adicionais

- [React Docs](https://react.dev)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [Tailwind CSS](https://tailwindcss.com/docs)
- [Vite Guide](https://vitejs.dev/guide/)
- [Vitest](https://vitest.dev/)

---

[⬅ Voltar](../README.md) | [🏗️ Arquitetura](./ARCHITECTURE.md) | [🧪 Testes](./TESTING.md)
