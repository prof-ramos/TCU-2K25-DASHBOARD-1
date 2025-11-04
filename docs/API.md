# 🔌 API Reference

> Documentação completa das APIs REST do TCU TI 2025 Study Dashboard

---

## 📋 Índice

- [Visão Geral](#visão-geral)
- [Autenticação](#autenticação)
- [Base URL](#base-url)
- [Endpoints](#endpoints)
- [Modelos de Dados](#modelos-de-dados)
- [Códigos de Status](#códigos-de-status)
- [Tratamento de Erros](#tratamento-de-erros)
- [Rate Limiting](#rate-limiting)
- [Exemplos](#exemplos)

---

## Visão Geral

A API do TCU TI 2025 Dashboard é uma API REST que usa JSON para serialização e autenticação baseada em tokens (planejado para v1.1).

### Características

- ✅ **RESTful**: Seguir convenções REST
- 📦 **JSON**: Request e response em JSON
- 🔒 **HTTPS**: Comunicação segura (produção)
- 🚀 **CORS**: Configurado para cross-origin requests
- ⚡ **Cache**: Headers apropriados de cache
- 🛡️ **Validação**: Input validation em todos os endpoints

---

## Autenticação

### v1.0 (Atual) - Sem Autenticação

A versão atual não requer autenticação. Todos os dados são salvos no localStorage do navegador e, opcionalmente, sincronizados com o backend.

### v1.1 (Planejado) - JWT Authentication

```http
Authorization: Bearer <token>
```

**Obter Token:**
```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "usuario@exemplo.com",
  "password": "senha_segura"
}
```

**Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "uuid",
    "email": "usuario@exemplo.com",
    "name": "Nome do Usuário"
  }
}
```

---

## Base URL

### Development
```
http://localhost:3001
```

### Production (Replit)
```
https://seu-projeto.replit.app
```

### Production (Custom Domain)
```
https://api.seu-dominio.com
```

---

## Endpoints

### Progress API

#### GET /api/progress

Retorna o progresso do usuário (IDs dos tópicos completados).

**Request:**
```http
GET /api/progress HTTP/1.1
Host: localhost:3001
```

**Response 200 OK:**
```json
{
  "completedIds": [
    "CON-0-1",
    "CON-0-2",
    "CON-0-3"
  ],
  "lastUpdated": "2025-10-29T12:34:56.789Z"
}
```

**Response 404 Not Found:**
```json
{
  "completedIds": [],
  "message": "No progress found for user"
}
```

**Exemplo de Uso:**
```typescript
const response = await fetch('http://localhost:3001/api/progress');
const data = await response.json();
console.log('Completed IDs:', data.completedIds);
```

---

#### POST /api/progress

Salva ou atualiza o progresso do usuário.

**Request:**
```http
POST /api/progress HTTP/1.1
Host: localhost:3001
Content-Type: application/json

{
  "completedIds": [
    "CON-0-1",
    "CON-0-2",
    "CON-0-3",
    "CON-0-4"
  ]
}
```

**Response 200 OK:**
```json
{
  "success": true,
  "count": 4,
  "message": "Progress saved successfully"
}
```

**Response 400 Bad Request:**
```json
{
  "error": "Invalid request body",
  "message": "completedIds must be an array of strings"
}
```

**Exemplo de Uso:**
```typescript
const saveProgress = async (completedIds: string[]) => {
  const response = await fetch('http://localhost:3001/api/progress', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ completedIds }),
  });
  
  if (!response.ok) {
    throw new Error('Failed to save progress');
  }
  
  return response.json();
};

await saveProgress(['CON-0-1', 'CON-0-2']);
```

---

### Materias API (Planejado v1.1)

#### GET /api/materias

Retorna todas as matérias do edital.

**Request:**
```http
GET /api/materias HTTP/1.1
Host: localhost:3001
```

**Response 200 OK:**
```json
{
  "materias": [
    {
      "id": "CON-0",
      "name": "LÍNGUA PORTUGUESA",
      "slug": "lingua-portuguesa",
      "type": "CONHECIMENTOS GERAIS",
      "topicCount": 17
    },
    {
      "id": "CON-1",
      "name": "LÍNGUA INGLESA",
      "slug": "lingua-inglesa",
      "type": "CONHECIMENTOS GERAIS",
      "topicCount": 3
    }
  ],
  "total": 16
}
```

---

#### GET /api/materias/:slug

Retorna uma matéria específica com todos os tópicos.

**Request:**
```http
GET /api/materias/lingua-portuguesa HTTP/1.1
Host: localhost:3001
```

**Response 200 OK:**
```json
{
  "id": "CON-0",
  "name": "LÍNGUA PORTUGUESA",
  "slug": "lingua-portuguesa",
  "type": "CONHECIMENTOS GERAIS",
  "topics": [
    {
      "id": "CON-0-1",
      "title": "Compreensão e interpretação de textos de gêneros variados",
      "subtopics": []
    },
    {
      "id": "CON-0-2",
      "title": "Reconhecimento de tipos e gêneros textuais",
      "subtopics": []
    }
  ]
}
```

**Response 404 Not Found:**
```json
{
  "error": "Materia not found",
  "slug": "materia-inexistente"
}
```

---

### AI API (Google Gemini Integration)

#### POST /api/ai/explain

Gera explicação sobre um tópico usando Google Gemini AI.

**Request:**
```http
POST /api/ai/explain HTTP/1.1
Host: localhost:3001
Content-Type: application/json

{
  "topic": "Padrões de projeto GoF",
  "context": "Engenharia de Software - TCU TI 2025"
}
```

**Response 200 OK:**
```json
{
  "explanation": "Os padrões de projeto GoF (Gang of Four) são 23 padrões...",
  "sources": [
    {
      "title": "Design Patterns: Elements of Reusable Object-Oriented Software",
      "url": "https://example.com/gof-patterns"
    }
  ],
  "generatedAt": "2025-10-29T12:34:56.789Z"
}
```

**Response 429 Too Many Requests:**
```json
{
  "error": "Rate limit exceeded",
  "message": "Maximum 60 requests per minute",
  "retryAfter": 45
}
```

**Exemplo de Uso:**
```typescript
const explainTopic = async (topic: string, context: string) => {
  const response = await fetch('http://localhost:3001/api/ai/explain', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ topic, context }),
  });
  
  if (!response.ok) {
    throw new Error('Failed to get explanation');
  }
  
  return response.json();
};

const result = await explainTopic(
  'Padrões de projeto GoF',
  'Engenharia de Software'
);
console.log(result.explanation);
```

---

## Modelos de Dados

### Materia

```typescript
interface Materia {
  id: string;                    // Ex: "CON-0"
  name: string;                  // Ex: "LÍNGUA PORTUGUESA"
  slug: string;                  // Ex: "lingua-portuguesa"
  type: 'CONHECIMENTOS GERAIS' | 'CONHECIMENTOS ESPECÍFICOS';
  topics: Topic[];
}
```

### Topic

```typescript
interface Topic {
  id: string;                    // Ex: "CON-0-1"
  title: string;                 // Ex: "Compreensão de textos"
  subtopics: Subtopic[];
}
```

### Subtopic

```typescript
interface Subtopic {
  id: string;                    // Ex: "CON-0-1.1"
  title: string;                 // Ex: "Análise sintática"
  subtopics?: Subtopic[];        // Hierarquia recursiva
}
```

### UserProgress

```typescript
interface UserProgress {
  userId?: string;               // (v1.1) UUID do usuário
  completedIds: string[];        // Array de IDs completados
  lastUpdated: string;           // ISO 8601 timestamp
}
```

### AIExplanation

```typescript
interface AIExplanation {
  explanation: string;           // Texto da explicação
  sources: Source[];             // Fontes de referência
  generatedAt: string;           // ISO 8601 timestamp
}

interface Source {
  title: string;                 // Título da fonte
  url: string;                   // URL completa
}
```

---

## Códigos de Status

### Sucesso (2xx)

| Código | Status | Descrição |
|--------|--------|-----------|
| 200 | OK | Requisição bem-sucedida |
| 201 | Created | Recurso criado com sucesso |
| 204 | No Content | Sucesso sem corpo de resposta |

### Erro do Cliente (4xx)

| Código | Status | Descrição |
|--------|--------|-----------|
| 400 | Bad Request | Requisição inválida |
| 401 | Unauthorized | Autenticação requerida |
| 403 | Forbidden | Sem permissão |
| 404 | Not Found | Recurso não encontrado |
| 422 | Unprocessable Entity | Validação falhou |
| 429 | Too Many Requests | Rate limit excedido |

### Erro do Servidor (5xx)

| Código | Status | Descrição |
|--------|--------|-----------|
| 500 | Internal Server Error | Erro interno do servidor |
| 502 | Bad Gateway | Gateway inválido |
| 503 | Service Unavailable | Serviço temporariamente indisponível |

---

## Tratamento de Erros

### Formato de Erro Padrão

```typescript
interface ErrorResponse {
  error: string;                 // Tipo do erro
  message: string;               // Mensagem descritiva
  details?: any;                 // Detalhes adicionais (opcional)
  timestamp?: string;            // Timestamp do erro
}
```

### Exemplos de Erros

**400 Bad Request:**
```json
{
  "error": "Validation Error",
  "message": "Invalid request body",
  "details": {
    "completedIds": "Must be an array of strings"
  },
  "timestamp": "2025-10-29T12:34:56.789Z"
}
```

**404 Not Found:**
```json
{
  "error": "Not Found",
  "message": "Materia not found",
  "details": {
    "slug": "materia-inexistente"
  }
}
```

**500 Internal Server Error:**
```json
{
  "error": "Internal Server Error",
  "message": "An unexpected error occurred",
  "timestamp": "2025-10-29T12:34:56.789Z"
}
```

### Tratamento no Cliente

```typescript
const apiRequest = async (url: string, options?: RequestInit) => {
  try {
    const response = await fetch(url, options);
    
    if (!response.ok) {
      const error = await response.json();
      throw new ApiError(response.status, error.message, error);
    }
    
    return response.json();
  } catch (error) {
    if (error instanceof ApiError) {
      // Trate erros da API
      console.error(`API Error ${error.status}:`, error.message);
      throw error;
    }
    
    // Erros de rede
    console.error('Network Error:', error);
    throw new Error('Network request failed');
  }
};

class ApiError extends Error {
  constructor(
    public status: number,
    message: string,
    public data?: any
  ) {
    super(message);
    this.name = 'ApiError';
  }
}
```

---

## Rate Limiting

### Limites Atuais (v1.0)

| Endpoint | Limite | Janela |
|----------|--------|--------|
| **GET /api/progress** | 100 | 1 minuto |
| **POST /api/progress** | 30 | 1 minuto |
| **POST /api/ai/explain** | 60 | 1 minuto |

### Headers de Rate Limit

```http
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1698580800
```

### Response Quando Limite Excedido

```http
HTTP/1.1 429 Too Many Requests
Content-Type: application/json
Retry-After: 45

{
  "error": "Rate Limit Exceeded",
  "message": "Too many requests. Please try again in 45 seconds.",
  "retryAfter": 45
}
```

---

## Exemplos

### Exemplo Completo: Salvar Progresso

```typescript
// service/progressService.ts
export class ProgressService {
  private baseURL = 'http://localhost:3001';
  
  async getProgress(): Promise<string[]> {
    try {
      const response = await fetch(`${this.baseURL}/api/progress`);
      
      if (response.status === 404) {
        return []; // Nenhum progresso salvo ainda
      }
      
      if (!response.ok) {
        throw new Error('Failed to fetch progress');
      }
      
      const data = await response.json();
      return data.completedIds;
    } catch (error) {
      console.error('Error fetching progress:', error);
      // Fallback para localStorage
      const local = localStorage.getItem('progress');
      return local ? JSON.parse(local) : [];
    }
  }
  
  async saveProgress(completedIds: string[]): Promise<void> {
    try {
      // Otimistic update
      localStorage.setItem('progress', JSON.stringify(completedIds));
      
      const response = await fetch(`${this.baseURL}/api/progress`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ completedIds }),
      });
      
      if (!response.ok) {
        throw new Error('Failed to save progress');
      }
      
      console.log('Progress synced with backend');
    } catch (error) {
      console.error('Error saving progress:', error);
      // localStorage já foi atualizado (otimistic)
    }
  }
}

// Uso:
const progressService = new ProgressService();

// Carregar progresso
const completed = await progressService.getProgress();
console.log('Completed topics:', completed);

// Salvar progresso
await progressService.saveProgress(['CON-0-1', 'CON-0-2', 'CON-0-3']);
```

### Exemplo: Integração com React

```typescript
// hooks/useProgress.ts
import { useState, useEffect } from 'react';
import { ProgressService } from '@/services/progressService';

const progressService = new ProgressService();

export function useProgress() {
  const [completedIds, setCompletedIds] = useState<Set<string>>(new Set());
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadProgress();
  }, []);

  const loadProgress = async () => {
    try {
      const ids = await progressService.getProgress();
      setCompletedIds(new Set(ids));
    } catch (error) {
      console.error('Failed to load progress:', error);
    } finally {
      setLoading(false);
    }
  };

  const toggleTopic = async (id: string) => {
    const newSet = new Set(completedIds);
    
    if (newSet.has(id)) {
      newSet.delete(id);
    } else {
      newSet.add(id);
    }
    
    setCompletedIds(newSet);
    await progressService.saveProgress(Array.from(newSet));
  };

  return {
    completedIds,
    toggleTopic,
    loading,
  };
}
```

---

## Versionamento da API

A API segue versionamento semântico. Mudanças breaking serão anunciadas com antecedência.

**Versão Atual**: v1.0

**Próxima Versão**: v1.1 (planejada)
- Autenticação de usuários
- Endpoints de matérias
- Suporte a múltiplos usuários

---

## Recursos Adicionais

- [Código-fonte da API](../server/)
- [Tests da API](../src/__tests__/services/)
- [Postman Collection](./postman-collection.json) (planejado)

---

[⬅ Voltar](../README.md) | [🏗️ Arquitetura](./ARCHITECTURE.md) | [💻 Desenvolvimento](./DEVELOPMENT.md)
