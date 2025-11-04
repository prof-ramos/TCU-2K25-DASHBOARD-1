# 🧪 Documentação de Testes

> Guia completo sobre estratégia de testes, execução e boas práticas do TCU TI 2025 Study Dashboard

---

## 📋 Índice

- [Visão Geral](#visão-geral)
- [Estrutura de Testes](#estrutura-de-testes)
- [Tipos de Testes](#tipos-de-testes)
- [Executando Testes](#executando-testes)
- [Escrevendo Testes](#escrevendo-testes)
- [Mocking](#mocking)
- [Cobertura de Código](#cobertura-de-código)
- [CI/CD](#cicd)
- [Troubleshooting](#troubleshooting)

---

## Visão Geral

### Stack de Testes

- **Vitest** - Framework de testes (Jest-compatible, mais rápido)
- **React Testing Library** - Testes de componentes React
- **jsdom** - Ambiente DOM para testes
- **MSW (Mock Service Worker)** - Mocking de APIs
- **Playwright** - Testes E2E (planejado)

### Estatísticas Atuais

| Categoria | Total | Passing | % Success |
|-----------|-------|---------|-----------|
| **Contexts** | 27 | 27 | 100% ✅ |
| **Services** | 17 | 17 | 100% ✅ |
| **Hooks** | 8 | 8 | 100% ✅ |
| **Components** | 24 | 18 | 75% ⚠️ |
| **Utils** | 6 | 6 | 100% ✅ |
| **TOTAL** | **82** | **76** | **92.7%** |

---

## Estrutura de Testes

```
src/__tests__/
├── contexts/              # Testes de React Contexts
│   ├── ProgressoContext.test.tsx
│   └── ThemeContext.test.tsx
├── hooks/                 # Testes de hooks customizados
│   ├── useLocalStorage.test.ts
│   ├── useProgresso.test.ts
│   └── useTheme.test.ts
├── services/              # Testes de services
│   ├── databaseService.test.ts
│   └── geminiService.test.ts
├── components/            # Testes de componentes
│   ├── ui/
│   │   ├── Button.test.tsx
│   │   ├── Card.test.tsx
│   │   └── Progress.test.tsx
│   ├── common/
│   │   ├── Header.test.tsx
│   │   └── ThemeToggle.test.tsx
│   └── features/
│       ├── Countdown.test.tsx
│       ├── MateriaCard.test.tsx
│       └── TopicItem.test.tsx
├── utils/                 # Testes de utilitários
│   └── utils.test.ts
├── mocks/                 # Configuração de mocks
│   ├── handlers.ts        # MSW handlers
│   └── server.ts          # MSW server
└── utils/                 # Utilitários de teste
    └── test-utils.tsx     # Render helpers
```

---

## Tipos de Testes

### 1. Testes Unitários

Testam funções isoladas e lógica de negócio.

**Exemplo - Utilitário**:
```typescript
// src/lib/utils.test.ts
import { describe, it, expect } from 'vitest';
import { cn, calculateProgress } from './utils';

describe('cn utility', () => {
  it('should merge class names', () => {
    expect(cn('foo', 'bar')).toBe('foo bar');
  });

  it('should handle conditional classes', () => {
    expect(cn('foo', false && 'bar', 'baz')).toBe('foo baz');
  });
});

describe('calculateProgress', () => {
  it('should return 0 for empty completed set', () => {
    const result = calculateProgress([], new Set());
    expect(result).toBe(0);
  });

  it('should calculate percentage correctly', () => {
    const topics = ['t1', 't2', 't3', 't4'];
    const completed = new Set(['t1', 't2']);
    const result = calculateProgress(topics, completed);
    expect(result).toBe(50);
  });
});
```

### 2. Testes de Hooks

Testam hooks customizados.

**Exemplo - useLocalStorage**:
```typescript
// src/hooks/useLocalStorage.test.ts
import { describe, it, expect, beforeEach } from 'vitest';
import { renderHook, act } from '@testing-library/react';
import { useLocalStorage } from './useLocalStorage';

describe('useLocalStorage', () => {
  beforeEach(() => {
    localStorage.clear();
  });

  it('should initialize with default value', () => {
    const { result } = renderHook(() => 
      useLocalStorage('test-key', 'default')
    );
    
    expect(result.current[0]).toBe('default');
  });

  it('should update localStorage when value changes', () => {
    const { result } = renderHook(() => 
      useLocalStorage('test-key', 'initial')
    );
    
    act(() => {
      result.current[1]('updated');
    });
    
    expect(result.current[0]).toBe('updated');
    expect(localStorage.getItem('test-key')).toBe(JSON.stringify('updated'));
  });

  it('should sync across multiple instances', () => {
    const { result: result1 } = renderHook(() => 
      useLocalStorage('test-key', 'initial')
    );
    const { result: result2 } = renderHook(() => 
      useLocalStorage('test-key', 'initial')
    );
    
    act(() => {
      result1.current[1]('synced');
    });
    
    expect(result2.current[0]).toBe('synced');
  });
});
```

### 3. Testes de Context

Testam React Contexts e providers.

**Exemplo - ProgressoContext**:
```typescript
// src/__tests__/contexts/ProgressoContext.test.tsx
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { renderHook, act } from '@testing-library/react';
import { ProgressoProvider, useProgresso } from '@/contexts/ProgressoContext';

const wrapper = ({ children }: { children: React.ReactNode }) => (
  <ProgressoProvider>{children}</ProgressoProvider>
);

describe('ProgressoContext', () => {
  beforeEach(() => {
    localStorage.clear();
    vi.clearAllMocks();
  });

  it('should initialize with empty completed set', () => {
    const { result } = renderHook(() => useProgresso(), { wrapper });
    
    expect(result.current.completedIds.size).toBe(0);
  });

  it('should toggle topic completion', () => {
    const { result } = renderHook(() => useProgresso(), { wrapper });
    
    act(() => {
      result.current.toggleTopic('topic-1');
    });
    
    expect(result.current.completedIds.has('topic-1')).toBe(true);
    
    act(() => {
      result.current.toggleTopic('topic-1');
    });
    
    expect(result.current.completedIds.has('topic-1')).toBe(false);
  });

  it('should calculate total progress', () => {
    const { result } = renderHook(() => useProgresso(), { wrapper });
    
    act(() => {
      result.current.toggleTopic('topic-1');
      result.current.toggleTopic('topic-2');
    });
    
    const progress = result.current.getTotalProgress();
    expect(progress).toBeGreaterThan(0);
  });
});
```

### 4. Testes de Componentes

Testam renderização e interação de componentes.

**Exemplo - Button**:
```typescript
// src/__tests__/components/ui/Button.test.tsx
import { describe, it, expect, vi } from 'vitest';
import { render, screen, fireEvent } from '@testing-library/react';
import { Button } from '@/components/ui/button';

describe('Button', () => {
  it('should render children', () => {
    render(<Button>Click me</Button>);
    expect(screen.getByText('Click me')).toBeInTheDocument();
  });

  it('should call onClick when clicked', () => {
    const handleClick = vi.fn();
    render(<Button onClick={handleClick}>Click me</Button>);
    
    fireEvent.click(screen.getByText('Click me'));
    expect(handleClick).toHaveBeenCalledTimes(1);
  });

  it('should apply variant classes', () => {
    const { rerender } = render(<Button variant="primary">Button</Button>);
    let button = screen.getByRole('button');
    expect(button).toHaveClass('btn-primary');
    
    rerender(<Button variant="secondary">Button</Button>);
    button = screen.getByRole('button');
    expect(button).toHaveClass('btn-secondary');
  });

  it('should be disabled when disabled prop is true', () => {
    render(<Button disabled>Click me</Button>);
    expect(screen.getByRole('button')).toBeDisabled();
  });
});
```

**Exemplo - MateriaCard**:
```typescript
// src/__tests__/components/features/MateriaCard.test.tsx
import { describe, it, expect } from 'vitest';
import { render, screen } from '@testing-library/react';
import { BrowserRouter } from 'react-router-dom';
import { MateriaCard } from '@/components/features/MateriaCard';
import { ProgressoProvider } from '@/contexts/ProgressoContext';

const mockMateria = {
  id: 'CON-0',
  name: 'LÍNGUA PORTUGUESA',
  slug: 'lingua-portuguesa',
  type: 'CONHECIMENTOS GERAIS' as const,
  topics: [
    { id: 'CON-0-1', title: 'Topic 1', subtopics: [] },
    { id: 'CON-0-2', title: 'Topic 2', subtopics: [] },
  ],
};

const renderWithProviders = (component: React.ReactElement) => {
  return render(
    <BrowserRouter>
      <ProgressoProvider>
        {component}
      </ProgressoProvider>
    </BrowserRouter>
  );
};

describe('MateriaCard', () => {
  it('should render materia name', () => {
    renderWithProviders(<MateriaCard materia={mockMateria} />);
    expect(screen.getByText('LÍNGUA PORTUGUESA')).toBeInTheDocument();
  });

  it('should display progress bar', () => {
    renderWithProviders(<MateriaCard materia={mockMateria} />);
    expect(screen.getByRole('progressbar')).toBeInTheDocument();
  });

  it('should show topic count', () => {
    renderWithProviders(<MateriaCard materia={mockMateria} />);
    expect(screen.getByText(/0\/2/)).toBeInTheDocument();
  });
});
```

### 5. Testes de Services

Testam integração com APIs.

**Exemplo - databaseService com MSW**:
```typescript
// src/__tests__/services/databaseService.test.ts
import { describe, it, expect, beforeAll, afterAll, afterEach } from 'vitest';
import { server } from '../mocks/server';
import { http, HttpResponse } from 'msw';
import * as dbService from '@/services/databaseService';

beforeAll(() => server.listen());
afterEach(() => server.resetHandlers());
afterAll(() => server.close());

describe('databaseService', () => {
  it('should fetch completed IDs', async () => {
    const completedIds = await dbService.getCompletedIds();
    expect(Array.isArray(completedIds)).toBe(true);
  });

  it('should save progress', async () => {
    const ids = ['topic-1', 'topic-2'];
    const result = await dbService.saveProgress(ids);
    expect(result.success).toBe(true);
  });

  it('should handle API errors gracefully', async () => {
    server.use(
      http.get('/api/progress', () => {
        return HttpResponse.error();
      })
    );

    await expect(dbService.getCompletedIds()).rejects.toThrow();
  });

  it('should fallback to localStorage on network error', async () => {
    server.use(
      http.get('/api/progress', () => {
        return HttpResponse.error();
      })
    );

    localStorage.setItem('progress', JSON.stringify(['topic-1']));
    
    const ids = await dbService.getCompletedIds();
    expect(ids).toEqual(['topic-1']);
  });
});
```

---

## Executando Testes

### Comandos Básicos

```bash
# Executar todos os testes (watch mode)
npm test

# Executar uma vez
npm run test:run

# Com cobertura
npm run test:coverage

# Interface visual
npm run test:ui

# Testes E2E (Playwright)
npm run test:e2e
```

### Modo Watch Específico

```bash
# Apenas testes de hooks
npm test -- hooks

# Apenas testes de componentes
npm test -- components

# Arquivo específico
npm test -- MateriaCard

# Executar testes relacionados a arquivos mudados
npm test -- --changed
```

### Opções Úteis

```bash
# Executar em modo verbose
npm test -- --reporter=verbose

# Parar no primeiro erro
npm test -- --bail

# Limitar concorrência
npm test -- --maxConcurrency=1

# Atualizar snapshots
npm test -- --update
```

---

## Escrevendo Testes

### Estrutura de um Teste

```typescript
import { describe, it, expect, beforeEach, afterEach } from 'vitest';

describe('Feature Name', () => {
  // Setup antes de cada teste
  beforeEach(() => {
    // Limpar mocks, localStorage, etc.
  });

  // Cleanup após cada teste
  afterEach(() => {
    // Restaurar estado
  });

  it('should do something specific', () => {
    // Arrange - Preparar
    const input = 'test';
    
    // Act - Agir
    const result = functionUnderTest(input);
    
    // Assert - Verificar
    expect(result).toBe('expected');
  });

  it('should handle edge case', () => {
    expect(() => functionUnderTest(null)).toThrow();
  });
});
```

### Boas Práticas

#### ✅ BOM

```typescript
// Descrições claras
describe('User authentication', () => {
  it('should log in user with valid credentials', () => {});
  it('should reject invalid credentials', () => {});
  it('should handle network errors gracefully', () => {});
});

// Arrange-Act-Assert
it('should calculate discount correctly', () => {
  const price = 100;
  const discount = 0.2;
  
  const result = applyDiscount(price, discount);
  
  expect(result).toBe(80);
});

// Testar comportamento, não implementação
it('should display error message when form is invalid', () => {
  render(<Form />);
  fireEvent.click(screen.getByRole('button', { name: /submit/i }));
  expect(screen.getByText(/invalid/i)).toBeInTheDocument();
});
```

#### ❌ RUIM

```typescript
// Descrições vagas
it('works', () => {});
it('test1', () => {});

// Testa implementação interna
it('should set state.loading to true', () => {
  // Detalhes de implementação podem mudar
});

// Múltiplas asserções não relacionadas
it('should do everything', () => {
  expect(a).toBe(1);
  expect(b).toBe(2);
  expect(c).toBe(3);
  // Divida em testes separados
});
```

---

## Mocking

### Mock Service Worker (MSW)

Configuração de handlers:

```typescript
// src/__tests__/mocks/handlers.ts
import { http, HttpResponse } from 'msw';

export const handlers = [
  // GET /api/progress
  http.get('/api/progress', () => {
    return HttpResponse.json({
      completedIds: ['topic-1', 'topic-2'],
    });
  }),

  // POST /api/progress
  http.post('/api/progress', async ({ request }) => {
    const body = await request.json();
    return HttpResponse.json({
      success: true,
      count: body.completedIds.length,
    });
  }),

  // Simular erro
  http.get('/api/error', () => {
    return HttpResponse.error();
  }),
];
```

Setup do servidor:

```typescript
// src/__tests__/mocks/server.ts
import { setupServer } from 'msw/node';
import { handlers } from './handlers';

export const server = setupServer(...handlers);
```

Uso nos testes:

```typescript
import { server } from './mocks/server';
import { http, HttpResponse } from 'msw';

beforeAll(() => server.listen());
afterEach(() => server.resetHandlers());
afterAll(() => server.close());

it('should handle custom response', async () => {
  server.use(
    http.get('/api/custom', () => {
      return HttpResponse.json({ custom: 'data' });
    })
  );

  const result = await fetchCustomData();
  expect(result.custom).toBe('data');
});
```

### Vitest Mocks

```typescript
import { vi } from 'vitest';

// Mock de função
const mockFn = vi.fn();
mockFn.mockReturnValue('mocked value');
mockFn.mockResolvedValue('async value');

expect(mockFn).toHaveBeenCalledWith('arg');
expect(mockFn).toHaveBeenCalledTimes(2);

// Mock de módulo
vi.mock('@/services/api', () => ({
  fetchData: vi.fn().mockResolvedValue({ data: 'mocked' }),
}));

// Spy em objeto
const spy = vi.spyOn(console, 'log');
expect(spy).toHaveBeenCalled();
spy.mockRestore();

// Mock de timer
vi.useFakeTimers();
vi.advanceTimersByTime(1000);
vi.runAllTimers();
vi.useRealTimers();
```

---

## Cobertura de Código

### Visualizar Cobertura

```bash
npm run test:coverage
```

Abre relatório HTML em `coverage/index.html`.

### Configuração de Cobertura

```typescript
// vitest.config.ts
export default defineConfig({
  test: {
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
      include: ['src/**/*.{ts,tsx}'],
      exclude: [
        'src/**/*.test.{ts,tsx}',
        'src/**/__tests__/**',
        'src/main.tsx',
        'src/vite-env.d.ts',
      ],
      thresholds: {
        lines: 80,
        functions: 80,
        branches: 75,
        statements: 80,
      },
    },
  },
});
```

### Metas de Cobertura

| Categoria | Meta | Atual |
|-----------|------|-------|
| **Statements** | 80% | 85% ✅ |
| **Branches** | 75% | 78% ✅ |
| **Functions** | 80% | 82% ✅ |
| **Lines** | 80% | 84% ✅ |

---

## CI/CD

### GitHub Actions

```yaml
# .github/workflows/test.yml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '20'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Run tests
        run: npm run test:run
        
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage/coverage-final.json
```

---

## Troubleshooting

### Testes não executam

```bash
# Limpar cache
rm -rf node_modules/.vite
npm run test -- --clearCache

# Reinstalar dependências
rm -rf node_modules package-lock.json
npm install
```

### Erros de importação

```typescript
// vitest.config.ts - Configure aliases
resolve: {
  alias: {
    '@': path.resolve(__dirname, './src'),
  },
}
```

### Testes flaky (instáveis)

```typescript
// Use waitFor para elementos assíncronos
import { waitFor } from '@testing-library/react';

await waitFor(() => {
  expect(screen.getByText('Loaded')).toBeInTheDocument();
}, { timeout: 3000 });

// Use act() para updates de estado
import { act } from '@testing-library/react';

await act(async () => {
  await someAsyncFunction();
});
```

---

## Recursos

- [Vitest Docs](https://vitest.dev/)
- [React Testing Library](https://testing-library.com/react)
- [MSW Documentation](https://mswjs.io/)
- [Testing Best Practices](https://kentcdodds.com/blog/common-mistakes-with-react-testing-library)

---

[⬅ Voltar](../README.md) | [💻 Desenvolvimento](./DEVELOPMENT.md) | [🤝 Contribuir](./CONTRIBUTING.md)
