# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Dashboard de Estudos TCU TI 2025 - An interactive study dashboard for tracking progress on the TCU (Tribunal de Contas da União) Federal IT Auditor exam, with AI-powered study assistance.

**Tech Stack:**
- Frontend: React 19.2 + TypeScript + Vite
- UI: Tailwind CSS + shadcn/ui (Radix UI primitives)
- Routing: React Router 6 (HashRouter)
- AI: Google Gemini API (grounded search)
- Backend API: Node.js + Express + SQLite3
- Deployment: Docker (multi-container: frontend, API, database)

## Development Commands

**Local Development (without Docker):**
```bash
npm install                 # Install dependencies
npm run dev                 # Start Vite dev server (port 3000)
npm run build               # Build for production
npm run preview             # Preview production build
npx tsc --noEmit           # Type check (no test framework configured)
```

**Docker Development:**
```bash
docker-compose up --build   # Build and start all services (frontend, API, DB)
docker-compose down         # Stop all services
docker-compose logs -f      # Follow logs
docker-compose restart      # Restart services
```

**Environment Variables:**
- Create `.env` file in root (see `.env.example`)
- Required: `GEMINI_API_KEY` - Get from [Google AI Studio](https://aistudio.google.com/app/apikey)
- Vite exposes it as `process.env.API_KEY` and `process.env.GEMINI_API_KEY` (see [vite.config.ts:14-15](vite.config.ts#L14-L15))

## Architecture

### File Structure (Flat Root)
All source files are in the **project root** (not in `src/`):
- **Pages:** `./pages/` - Dashboard.tsx, MateriaPage.tsx
- **Components:** `./components/` - Reusable React components
  - `./components/ui/` - shadcn/ui primitives (button, card, accordion, etc.)
- **Contexts:** `./contexts/` - React Context providers (Theme, Progress)
- **Data:** `./data/edital.ts` - Parsed exam syllabus (matérias, topics, subtopics)
- **Services:** `./services/` - API integrations (Gemini, database)
- **Types:** `./types.ts` - TypeScript interfaces (Edital, Materia, Topic, Subtopic, ProgressItem)
- **Lib:** `./lib/utils.ts` - Utility functions (cn for className merging)
- **Entry Points:** `./index.tsx`, `./App.tsx`
- **Server:** `./server/index.js` - Express API for SQLite progress persistence

### Key Architecture Patterns

**1. Data Model (types.ts)**
```typescript
Edital → Materia[] → Topic[] → Subtopic[] (recursive)
```
- Each item has a unique `id` (e.g., `"1.2.3"`)
- Progress tracking uses leaf node IDs
- Matérias have `slug` for routing (`/materia/:slug`)

**2. Progress Management (ProgressoContext.tsx)**
- **State:** `completedItems: Set<string>` (IDs of completed leaf nodes)
- **Persistence:** SQLite API with localStorage fallback
- **Methods:**
  - `toggleCompleted(item)` - Optimistic UI update, async DB sync
  - `getMateriaStats(materia)` - Calculate completion percentage
  - `getGlobalStats(edital)` - Calculate overall progress
  - `getItemStatus(item)` - Returns 'completed' | 'partial' | 'incomplete'
- **Important:** Uses optimistic updates (UI changes immediately, DB syncs in background)

**3. Database Service (databaseService.ts + server/index.js)**
- **Frontend Service:** HTTP client for progress API (`/api/progress`)
- **Fallback:** Uses localStorage if API unavailable
- **Backend API (Express):**
  - `GET /api/progress` - Retrieve completed IDs
  - `POST /api/progress` - Add completed IDs (body: `{ids: string[]}`)
  - `DELETE /api/progress` - Remove completed IDs (body: `{ids: string[]}`)
  - `GET /health` - Health check
- **Database:** SQLite table `progress(id TEXT PRIMARY KEY, completed_at DATETIME)`

**4. Gemini Integration (geminiService.ts)**
- Uses `@google/genai` SDK (model: `gemini-2.5-flash`)
- **Function:** `fetchTopicInfo(topicTitle)` returns `{summary, sources: GroundingChunk[]}`
- Uses Google Search grounding for up-to-date information
- Prompt optimized for TCU exam context (Brazilian federal IT audit)

**5. Routing (App.tsx)**
- Uses `HashRouter` for static hosting compatibility
- Routes:
  - `/` - Dashboard (all matérias)
  - `/materia/:slug` - Individual matéria details
- Matérias fetched via `getMateriaBySlug(slug)` from `data/edital.ts`

### Docker Architecture
Three services in `docker-compose.yml`:
1. **app** (frontend) - Nginx serving static build (port 3000)
2. **api** - Node.js Express API (port 3001)
3. **db** - Alpine Linux + SQLite (persistent volume `sqlite_data`)

## Coding Conventions

- **Language:** TypeScript with strict JSX runtime (`react-jsx`)
- **Components:** Functional components with `React.FC` type
- **Styling:** Tailwind CSS utility classes, responsive design
- **Imports:** Standard React first, then third-party, then local
- **Naming:** PascalCase for components, camelCase for functions/variables
- **Path Alias:** `@/` resolves to project root (see [vite.config.ts:19](vite.config.ts#L19))
- **Error Handling:** Try-catch with `console.error` logging
- **Async:** Use async/await, handle errors gracefully
- **No semicolons:** Project uses no-semicolon style
- **Indentation:** 2 spaces

## Important Notes

1. **No src/ directory** - All source files are in root (legacy structure)
2. **Edital Data:** Parsed from nested JSON in `data/edital.ts` - complex recursive structure
3. **Progress IDs:** Only leaf nodes (items without subtopics) are tracked
4. **Theme:** Light/dark mode via ThemeContext (localStorage: `theme`)
5. **Exam Date:** Countdown timer uses `edital.examDate` from `data/edital.ts`
6. **API Key Security:** Gemini key exposed in client bundle (development only - not for production with sensitive keys)
7. **Offline Support:** localStorage fallback ensures progress persistence without API

## Common Tasks

**Add New Matéria:**
1. Edit `data/edital.ts` rawData structure
2. Ensure unique IDs and slug
3. Types will auto-infer from parsing functions

**Modify Progress Logic:**
- Update `contexts/ProgressoContext.tsx` (state management)
- Update `services/databaseService.ts` (API client)
- Update `server/index.js` (API endpoints)

**Add UI Components:**
- Use shadcn/ui components from `components/ui/`
- Follow Radix UI patterns for accessibility
- Style with Tailwind classes

**Database Changes:**
- Update `init-db.sql` for schema
- Rebuild Docker: `docker-compose up --build --force-recreate`
