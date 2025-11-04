<div align="center">

# 🎓 TCU TI 2025 - Study Dashboard

**Sistema de Acompanhamento de Estudos para o Concurso TCU - Auditor Federal de Controle Externo - Tecnologia da Informação**

[![TypeScript](https://img.shields.io/badge/TypeScript-5.8-blue?logo=typescript&logoColor=white)](https://www.typescriptlang.org/)
[![React](https://img.shields.io/badge/React-19.2-61DAFB?logo=react&logoColor=white)](https://react.dev/)
[![Vite](https://img.shields.io/badge/Vite-6.x-646CFF?logo=vite&logoColor=white)](https://vitejs.dev/)
[![Test Coverage](https://img.shields.io/badge/coverage-92.7%25-brightgreen)](./src/__tests__)
[![License](https://img.shields.io/badge/license-MIT-green)](./LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](./docs/CONTRIBUTING.md)

[📖 Documentação](./docs) • [🚀 Quick Start](#-quick-start) • [🎯 Features](#-principais-funcionalidades) • [🤝 Contribuir](./docs/CONTRIBUTING.md)

</div>

---

## 📋 Índice

- [Sobre o Projeto](#-sobre-o-projeto)
- [Quick Start](#-quick-start)
- [Principais Funcionalidades](#-principais-funcionalidades)
- [Documentação](#-documentação)
- [Stack Tecnológica](#-stack-tecnológica)
- [Instalação Detalhada](#-instalação-detalhada)
- [Estrutura do Projeto](#-estrutura-do-projeto)
- [Testes](#-testes)
- [Roadmap](#-roadmap)
- [Contribuindo](#-contribuindo)
- [Licença](#-licença)

---

## 🎯 Sobre o Projeto

O **TCU TI 2025 Study Dashboard** é uma aplicação web moderna e intuitiva projetada para auxiliar candidatos na preparação para o concurso do Tribunal de Contas da União (TCU) para o cargo de Auditor Federal de Controle Externo - Área de Tecnologia da Informação.

### 🎯 Objetivos

- ✅ **Organizar** o extenso conteúdo do edital (16 matérias, 122 tópicos, 380 subtópicos)
- 📊 **Visualizar** o progresso de estudos em tempo real
- ⏱️ **Acompanhar** contagem regressiva até a prova (22/02/2026)
- 🤖 **Explicar** tópicos complexos com IA (Google Gemini)
- 📱 **Acessar** de qualquer dispositivo (responsivo)
- 🌓 **Personalizar** experiência (modo claro/escuro)

---

## 🚀 Quick Start

### Instalação Rápida (3 passos)

```bash
# 1. Clone o repositório
git clone https://github.com/seu-usuario/tcu-ti-2025-study-dashboard.git
cd tcu-ti-2025-study-dashboard

# 2. Instale as dependências
npm install

# 3. Inicie o servidor de desenvolvimento
npm run dev

# 4. Acesse http://localhost:5000
```

✅ **Pronto!** A aplicação funciona com localStorage (sem necessidade de backend).

💡 Para funcionalidades completas (backend + IA), veja o [Guia de Instalação Completo](./docs/INSTALLATION.md).

---

## ✨ Principais Funcionalidades

| Categoria | Features | Status |
|-----------|----------|--------|
| **📚 Gestão de Estudos** | Dashboard com 16 matérias, 122 tópicos, 380 subtópicos<br>Progresso hierárquico com checkboxes<br>Persistência dual (localStorage + Supabase) | ✅ Completo |
| **🤖 IA Integrada** | Explicações com Google Gemini API<br>Fontes verificáveis e links de referência<br>Busca contextual por tópico | ✅ Completo |
| **🎨 Interface** | Design moderno com Radix UI + Tailwind<br>Tema escuro/claro<br>100% responsivo (mobile-first)<br>Acessibilidade ARIA | ✅ Completo |
| **⏱️ Utilitários** | Countdown timer até a prova<br>Estatísticas e métricas<br>Navegação rápida | ✅ Completo |

---

## 📖 Documentação

| Documento | Descrição | Link |
|-----------|-----------|------|
| **📘 Guia de Instalação** | Instruções detalhadas de instalação e configuração | [INSTALLATION.md](./docs/INSTALLATION.md) |
| **🏗️ Arquitetura** | Visão técnica do sistema e decisões de design | [ARCHITECTURE.md](./docs/ARCHITECTURE.md) |
| **💻 Desenvolvimento** | Guia para desenvolvedores e contribuidores | [DEVELOPMENT.md](./docs/DEVELOPMENT.md) |
| **🧪 Testes** | Estratégia de testes e como executá-los | [TESTING.md](./docs/TESTING.md) |
| **🤝 Contribuindo** | Como contribuir com o projeto | [CONTRIBUTING.md](./docs/CONTRIBUTING.md) |
| **🔌 API Reference** | Documentação das APIs do backend | [API.md](./docs/API.md) |
| **📝 Changelog** | Histórico de versões e mudanças | [CHANGELOG.md](./CHANGELOG.md) |
| **📚 Índice Completo** | Navegação por toda documentação | [docs/README.md](./docs/README.md) |

---

## 🛠️ Stack Tecnológica

### Frontend
- **Framework**: React 19 + TypeScript 5.8
- **Build Tool**: Vite 6
- **Roteamento**: React Router 6
- **Estilização**: Tailwind CSS + Radix UI
- **Estado**: React Context API
- **Testes**: Vitest + React Testing Library + MSW
- **Lint/Format**: ESLint + Prettier

### Backend (Opcional)
- **Runtime**: Node.js 20
- **Framework**: Express.js
- **Database**: Supabase (PostgreSQL)
- **IA**: Google Gemini API

### DevOps
- **Hosting**: Replit / Vercel / Netlify
- **CI/CD**: GitHub Actions (planejado)
- **Containers**: Docker + Docker Compose

---

## 📦 Instalação Detalhada

### Pré-requisitos

- **Node.js** 20.x ou superior
- **npm** 10.x ou superior
- Conta no [Supabase](https://supabase.com) (opcional, para backend)
- API Key do [Google Gemini](https://ai.google.dev/) (opcional, para IA)

### Instalação Básica (Frontend Only)

```bash
# 1. Clone o repositório
git clone https://github.com/seu-usuario/tcu-ti-2025-study-dashboard.git
cd tcu-ti-2025-study-dashboard

# 2. Instale as dependências
npm install

# 3. Inicie o desenvolvimento
npm run dev

# 4. Acesse http://localhost:5000
```

✅ **Funciona completamente com localStorage!**

### Instalação Completa (Frontend + Backend + IA)

Para habilitar todas as funcionalidades (sincronização em nuvem e IA):

1. **Configure Supabase**
   - Crie conta em [supabase.com](https://supabase.com)
   - Execute o schema: `supabase-edital-schema.sql`
   - Copie as credenciais

2. **Configure Google Gemini**
   - Obtenha API key em [Google AI Studio](https://ai.google.dev/)

3. **Configure Variáveis de Ambiente**
   ```bash
   cp .env.example .env
   # Edite .env com suas credenciais
   ```

4. **Inicie Frontend e Backend**
   ```bash
   # Terminal 1: Frontend
   npm run dev

   # Terminal 2: Backend
   cd server && node index.js
   ```

📖 **Guia Completo**: [docs/INSTALLATION.md](./docs/INSTALLATION.md)

---

## 📊 Estrutura do Projeto

```
tcu-ti-2025-study-dashboard/
├── src/                    # Código-fonte do frontend
│   ├── components/         # Componentes React
│   │   ├── ui/             # Componentes primitivos
│   │   ├── common/         # Layout e navegação
│   │   └── features/       # Componentes de funcionalidades
│   ├── contexts/           # Estado global (React Context)
│   ├── hooks/              # Hooks customizados
│   ├── pages/              # Páginas/rotas
│   ├── services/           # Integrações (API, Gemini)
│   ├── types/              # Definições TypeScript
│   └── __tests__/          # Testes (82 testes, 92.7% passing)
├── server/                 # Backend API (opcional)
│   ├── index.js            # Servidor Express
│   └── config/             # Configurações
├── docs/                   # Documentação
│   ├── INSTALLATION.md
│   ├── ARCHITECTURE.md
│   ├── DEVELOPMENT.md
│   ├── TESTING.md
│   ├── CONTRIBUTING.md
│   └── API.md
└── ...                     # Configurações e metadados
```

📖 **Arquitetura Detalhada**: [docs/ARCHITECTURE.md](./docs/ARCHITECTURE.md)

---

## 🧪 Testes

O projeto possui uma suite completa de testes:

```bash
# Rodar todos os testes
npm test

# Testes com cobertura
npm run test:coverage

# Testes em modo UI
npm run test:ui
```

### Cobertura Atual

| Categoria | Testes | % Passing |
|-----------|--------|-----------|
| **Contexts** | 27 | 100% ✅ |
| **Services** | 17 | 100% ✅ |
| **Hooks** | 8 | 100% ✅ |
| **Components** | 24 | 75% ⚠️ |
| **Utils** | 6 | 100% ✅ |
| **TOTAL** | **82** | **92.7%** |

📖 **Guia de Testes**: [docs/TESTING.md](./docs/TESTING.md)

---

## 🎯 Roadmap

### ✅ v1.0 (Atual)
- [x] Interface completa com 380 subtópicos
- [x] Sistema de progresso com persistência
- [x] Integração com Google Gemini AI
- [x] Tema escuro/claro
- [x] 82 testes (92.7% passing)
- [x] Documentação completa

### 🚧 v1.1 (Próxima)
- [ ] Autenticação de usuários (Supabase Auth)
- [ ] Sincronização multi-dispositivo em tempo real
- [ ] Estatísticas avançadas com gráficos
- [ ] Sistema de metas e lembretes
- [ ] PWA (Progressive Web App)
- [ ] CI/CD completo

### 🔮 v2.0 (Futuro)
- [ ] Questões de concursos anteriores
- [ ] Sistema de simulados
- [ ] Estudo colaborativo
- [ ] Gamificação
- [ ] App mobile nativo

---

## 🎮 Scripts Disponíveis

```bash
# Desenvolvimento
npm run dev              # Inicia dev server
npm run build            # Build para produção
npm run preview          # Preview do build

# Qualidade de Código
npm run lint             # Verifica erros ESLint
npm run lint:fix         # Corrige erros automaticamente
npm run format           # Formata código com Prettier

# Testes
npm test                 # Testes em watch mode
npm run test:run         # Testa uma vez
npm run test:coverage    # Com cobertura
npm run test:ui          # Interface visual

# Docker
npm run docker:up        # Sobe containers
npm run docker:down      # Para containers
npm run docker:logs      # Ver logs
```

---

## 📁 Estrutura do Projeto

Projeto organizado seguindo as **melhores práticas do React** e princípios de separação de responsabilidades:

```
/ (Raiz do Projeto)
|
├── .docker/                # Configurações Docker (frontend, api, nginx)
|   ├── api.Dockerfile      # Container da API
|   ├── app.Dockerfile      # Container do frontend
|   └── nginx.conf          # Configuração do servidor web
|
├── .github/                # (FUTURO) CI/CD com GitHub Actions
|   └── workflows/
|
├── data/                   # Dados persistentes do backend
|   └── study_progress.db   # Banco SQLite (ignorado pelo .gitignore)
|
├── public/                 # Ativos estáticos (ícones, imagens)
|
├── src/                    # Código-fonte do Frontend (React/Vite)
|   |
|   ├── assets/             # Imagens, fontes, SVGs
|   |
|   ├── components/         # Componentes React
|   |   ├── ui/             # Componentes primitivos (shadcn/ui)
|   |   │   ├── accordion.tsx
|   |   │   ├── button.tsx
|   |   │   ├── card.tsx
|   |   │   ├── checkbox.tsx
|   |   │   ├── dialog.tsx
|   |   │   └── progress.tsx
|   |   ├── common/         # Componentes de layout compartilhados
|   |   │   ├── Header.tsx
|   |   │   ├── Layout.tsx
|   |   │   └── ThemeToggle.tsx
|   |   └── features/       # Componentes complexos específicos
|   |       ├── Countdown.tsx
|   |       ├── GeminiInfoModal.tsx
|   |       ├── MateriaCard.tsx
|   |       └── TopicItem.tsx
|   |
|   ├── contexts/           # Contextos React (estado global)
|   |   ├── ProgressoContext.tsx
|   |   └── ThemeContext.tsx
|   |
|   ├── data/               # Dados estáticos do frontend
|   |   └── edital.ts       # Estrutura do edital parseada
|   |
|   ├── hooks/              # Hooks customizados
|   |   ├── useLocalStorage.ts
|   |   ├── useProgresso.ts
|   |   └── useTheme.ts
|   |
|   ├── lib/                # Utilitários
|   |   └── utils.ts        # Funções auxiliares (cn, etc.)
|   |
|   ├── pages/              # Componentes de página (rotas)
|   |   ├── Dashboard.tsx
|   |   └── MateriaPage.tsx
|   |
|   ├── services/           # Lógica de APIs
|   |   ├── databaseService.ts
|   |   └── geminiService.ts
|   |
|   ├── styles/             # (FUTURO) CSS global adicional
|   |
|   ├── types/              # Definições TypeScript
|   |   └── types.ts        # Interfaces e tipos globais
|   |
|   ├── __tests__/          # (FUTURO) Testes (Vitest, Playwright)
|   |
|   ├── App.tsx             # Componente raiz com configuração de rotas
|   └── index.tsx           # Ponto de entrada do React
|
├── server/                 # Código-fonte do Backend (API)
|   ├── index.js            # Ponto de entrada (Express + SQLite)
|   └── ...                 # (FUTURO: routes/, controllers/, services/)
|
├── .env.example            # Exemplo de variáveis de ambiente
├── .gitignore
├── docker-compose.yml      # Orquestração de containers
├── edital.md               # Documento base do edital
├── index.html              # HTML principal
├── package.json            # Dependências do frontend
├── package-server.json     # Dependências do backend
├── README.md               # Este arquivo
├── tsconfig.json           # Configuração TypeScript
└── vite.config.ts          # Configuração Vite
```

### 📂 Principais Diretórios

| Diretório | Descrição |
|-----------|-----------|
| `src/components/ui/` | Componentes primitivos (shadcn/ui - Radix UI) |
| `src/components/common/` | Componentes de layout compartilhados |
| `src/components/features/` | Componentes complexos específicos de features |
| `src/contexts/` | Gerenciamento de estado global (React Context) |
| `src/hooks/` | Hooks customizados para lógica reutilizável |
| `src/pages/` | Componentes de página (rotas da aplicação) |
| `src/services/` | Integração com APIs externas |
| `src/types/` | Definições de tipos TypeScript |
| `server/` | Backend Node.js (API REST com Express + SQLite) |
| `.docker/` | Configurações Docker para cada serviço |

---

## 📜 Scripts Disponíveis

### Desenvolvimento Local

```bash
npm run dev          # Inicia servidor de desenvolvimento (porta 3000)
npm run build        # Cria build de produção otimizada
npm run preview      # Pré-visualiza build de produção localmente
npx tsc --noEmit     # Verifica tipos TypeScript sem gerar arquivos
```

### Docker

```bash
npm run docker:up       # Inicia todos os containers (build + start)
npm run docker:down     # Para todos os containers
npm run docker:logs     # Exibe logs em tempo real
npm run docker:restart  # Reinicia todos os containers
```

---

## 🐳 Deploy com Docker

O projeto inclui uma configuração completa de Docker com três serviços:

### Arquitetura Docker

```
┌─────────────────────┐
│   Frontend (Nginx)  │  ← Porta 3000
│   React Build       │
└─────────┬───────────┘
          │
          ▼
┌─────────────────────┐
│   API (Node.js)     │  ← Porta 3001
│   Express + SQLite  │
└─────────┬───────────┘
          │
          ▼
┌─────────────────────┐
│   Database Volume   │  ← Volume persistente
│   SQLite DB         │
└─────────────────────┘
```

### Iniciar Containers

```bash
# Build e inicia todos os serviços
docker-compose up --build

# Modo detached (background)
docker-compose up -d

# Ver logs em tempo real
docker-compose logs -f

# Parar containers
docker-compose down

# Limpar tudo (containers, volumes, imagens)
docker-compose down -v --rmi all
```

### Serviços Docker

| Serviço | Descrição | Porta |
|---------|-----------|-------|
| **app** | Frontend React (Nginx) | 3000 |
| **api** | Backend Express API | 3001 |
| **db** | SQLite Database (volume) | - |

---

## 🏗️ Arquitetura e Decisões Técnicas

### Gerenciamento de Estado

**ProgressoContext.tsx**
- Utiliza React Context API para estado global
- Implementa **updates otimistas** (UI atualiza antes da API responder)
- Fallback automático para localStorage se API falhar
- Calcula estatísticas de progresso em tempo real

```typescript
const { completedItems, toggleCompleted, getMateriaStats } = useProgresso()
```

### Persistência de Dados

**Estratégia Híbrida:**
1. **Primário**: API REST com SQLite (dados permanentes)
2. **Fallback**: localStorage (se API indisponível)
3. **Update Otimista**: UI atualiza instantaneamente, sincronização em background

**Fluxo de Persistência:**
```
User Click → Update UI → API Call (async) → localStorage Fallback
```

### Roteamento

Utiliza **HashRouter** para compatibilidade com hospedagem estática:

```typescript
// src/App.tsx
<HashRouter>
  <Routes>
    <Route path="/" element={<Dashboard />} />
    <Route path="/materia/:slug" element={<MateriaPage />} />
  </Routes>
</HashRouter>
```

### Integração com IA

**Gemini Service** com Google Search Grounding:

```typescript
// src/services/geminiService.ts
const result = await model.generateContent({
  contents: [{ role: 'user', parts: [{ text: prompt }] }],
  tools: [{ googleSearch: {} }]  // Busca fundamentada
})
```

Retorna:
- **summary**: Resumo contextualizado para TCU
- **sources**: Links relevantes com títulos e URIs

---

## 🎨 Temas e Estilização

### Sistema de Temas

O projeto suporta **tema claro e escuro** via Context API:

```typescript
// src/contexts/ThemeContext.tsx
const { theme, toggleTheme } = useTheme()  // 'light' | 'dark'
```

### Cores Customizadas (CSS Variables)

Todas as cores são definidas via variáveis CSS no `index.html`:

```css
:root {
  --background: 0 0% 100%;
  --foreground: 222.2 84% 4.9%;
  --primary: 222.2 47.4% 11.2%;
  /* ... */
}

.dark {
  --background: 222.2 84% 4.9%;
  --foreground: 210 40% 98%;
  /* ... */
}
```

---

## 🔒 Segurança

### Boas Práticas Implementadas

1. **Variáveis de Ambiente**
   - Chaves de API nunca são commitadas
   - Arquivo `.env` listado no `.gitignore`
   - `.env.example` fornece template sem dados sensíveis

2. **Validação de Dados**
   - TypeScript garante type safety
   - Validação de IDs antes de operações no banco

3. **CORS (API)**
   - Backend Express configurado para aceitar apenas origens confiáveis

### ⚠️ Aviso Importante

> **A chave do Gemini está exposta no bundle do cliente** (frontend). Isso é adequado apenas para **desenvolvimento e prototipagem**.
>
> Para **produção**, mova a lógica do Gemini para o backend (API Express) para proteger a chave.

**Solução para Produção:**
```
Frontend → API Express → Gemini API
          (chave segura)
```

---

## 🤝 Contribuindo

Contribuições são muito bem-vindas! Siga estas etapas:

### 1. Fork o Projeto

```bash
# Clique em "Fork" no GitHub
# Clone seu fork
git clone https://github.com/seu-usuario/TCU-2K25-DASHBOARD.git
```

### 2. Crie uma Branch

```bash
git checkout -b feature/minha-nova-feature
# ou
git checkout -b fix/correcao-de-bug
```

### 3. Faça suas Alterações

- Siga as convenções de código existentes
- Adicione comentários quando necessário
- Teste suas mudanças localmente

### 4. Commit suas Mudanças

```bash
git add .
git commit -m "feat: adiciona nova funcionalidade X"
```

**Convenção de Commits (Conventional Commits):**
- `feat:` - Nova funcionalidade
- `fix:` - Correção de bug
- `docs:` - Mudanças na documentação
- `style:` - Formatação, falta de ponto e vírgula, etc.
- `refactor:` - Refatoração de código
- `test:` - Adição ou correção de testes
- `chore:` - Atualizações de build, pacotes, etc.

### 5. Push para o GitHub

```bash
git push origin feature/minha-nova-feature
```

### 6. Abra um Pull Request

- Vá para o repositório original no GitHub
- Clique em "New Pull Request"
- Descreva suas mudanças detalhadamente

---

## 📝 Licença

Este projeto está sob a licença **MIT**. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

## 🙏 Agradecimentos

- [React Team](https://reactjs.org/) - Framework fantástico
- [shadcn](https://ui.shadcn.com/) - Componentes UI de alta qualidade
- [Radix UI](https://www.radix-ui.com/) - Primitivos acessíveis
- [Google Gemini](https://ai.google.dev/) - IA generativa poderosa
- [Lucide](https://lucide.dev/) - Ícones lindos e open source
- Comunidade TCU - Motivação para criar este projeto

---

## 📊 Status do Projeto

- ✅ **MVP Completo** - Todas as funcionalidades básicas implementadas
- ✅ **Deploy com Docker** - Containerização funcional
- ✅ **Estrutura Organizada** - Código seguindo melhores práticas
- ⏳ **Testes** - A implementar
- ⏳ **CI/CD** - A implementar

---

## 🗺️ Roadmap

### Versão 1.1 (Próxima Release)
- [ ] Implementar testes unitários (Vitest)
- [ ] Adicionar testes E2E (Playwright)
- [ ] CI/CD com GitHub Actions
- [ ] Melhorar acessibilidade (WCAG AA)

### Versão 1.2
- [ ] PWA com Service Workers
- [ ] Modo offline completo
- [ ] Exportar progresso (PDF/Excel)
- [ ] Sistema de metas e lembretes

### Versão 2.0
- [ ] Suporte a múltiplos usuários (autenticação)
- [ ] Backend com PostgreSQL
- [ ] Dashboard de estatísticas avançadas
- [ ] Integração com plataformas de questões

---

<div align="center">

**Desenvolvido com ❤️ para concurseiros de TI**

[⬆ Voltar ao topo](#-dashboard-de-estudos-tcu-ti-2025)

</div>
