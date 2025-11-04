# Agent Guidelines for TCU-2K25-DASHBOARD

## Commands
- **Build**: `npm run build`
- **Dev server**: `npm run dev`
- **Preview**: `npm run preview`
- **Type check**: `npx tsc --noEmit`
- **Single test**: No test framework configured
- **Lint**: No linter configured

## Docker Commands
- **Start all services**: `docker-compose up --build`
- **Stop all services**: `docker-compose down`
- **View logs**: `docker-compose logs -f`
- **Rebuild**: `docker-compose up --build --force-recreate`

## Code Style
- **Language**: TypeScript with React (ES modules, target ES2022)
- **JSX**: Use `react-jsx` transform (no semicolons, single quotes)
- **Imports**: React first, then third-party, then local (use type imports for types)
- **Naming**: PascalCase for components, camelCase for functions/variables
- **Types**: Define interfaces in `types/types.ts`, use explicit typing
- **Formatting**: 2-space indentation, no semicolons, single quotes
- **Styling**: Tailwind CSS utility classes, responsive design
- **Error handling**: Try-catch with console.error logging
- **Async**: Use async/await with proper error handling
- **Path aliases**: Use `@/` for root imports (configured in vite.config.ts)
- **Components**: Functional components with React.FC type
- **File structure**: All source files in root (not src/), flat structure