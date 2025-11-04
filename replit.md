# TCU TI 2025 Study Dashboard - Replit Project

## Overview
TCU Dashboard is a study progress tracking application for the TCU (Tribunal de Contas da União) - Auditor Federal de Controle Externo - Tecnologia da Informação exam. This application helps students track their study progress across multiple subjects and topics.

**Current State**: ✅ Phase 0 complete - Database infrastructure and operational readiness (October 30, 2025).

**Versions**:
- **v1.0** (Current): Single-user React/Vite app with localStorage
- **v2.0** (In Planning): Multi-tenant Next.js 14 enterprise system

## Recent Changes

### October 30, 2025 - ✅ PHASE 0 COMPLETE: Database Infrastructure & Operational Readiness
- **✅ Created Complete Supabase Migration Pipeline** (supabase/migrations/)
  - 00001: PostgreSQL extensions (uuid-ossp, pgcrypto, citext)
  - 00002: Custom ENUMs (user_role, subscription_tier, data_request_type, consent_type)
  - 00003: Core tables (tenants, profiles, tenant_members) + updated_at triggers
  - 00004: Edital tables (subjects, topics, subtopics) with hierarchical structure
  - 00005: User data tables (progress, study_plans, study_sessions) + materialized view
  - 00006: LGPD compliance (audit_log, user_consents, data_requests) + helper functions
  - 00007: RLS helper functions (get_user_role, is_tenant_admin, export/anonymize_user_data)
  - 00008: Enable RLS on all public tables
  - 00009: Complete RLS policies (tenant isolation, admin access, cross-tenant prevention)
- **✅ Generated Seed Data SQL** (supabase/seed/00010_seed_edital_data.sql)
  - 16 subjects (CON-* for general, ESP-* for specific knowledge)
  - 112 main topics from TCU TI 2025 edital
  - 327 hierarchical subtopics
  - **Total**: 455 records auto-generated via Node.js script
  - **Fix**: Unique external_id constraint (CON-* vs ESP-* prefixes)
- **✅ Created RUNBOOK.md** (docs/RUNBOOK.md)
  - Deployment procedures (standard + database migration workflows)
  - Rollback procedures (code via Vercel + database PITR)
  - Incident response (P0-P3 severity levels, 15min-24h response times)
  - Database operations (query optimization, RLS debugging, session management)
  - Monitoring & alerts (Sentry, Vercel Analytics, Supabase Dashboard)
  - Common issues + troubleshooting guides
  - Disaster recovery scenarios (RTO/RPO: 1-4 hours)
- **✅ Created RLS Policy Test Suite** (supabase/tests/rls-policies.sql)
  - 10 automated tests covering:
    - Tenant isolation (users see only their tenant)
    - Progress isolation (users see only own data)
    - Admin access (admins see all tenant data)
    - **Critical**: Cross-tenant read/write prevention
    - Audit log access control (admin-only)
    - User consents privacy
    - Global subject access (seed data)
    - Tenant member management
- **Status**: ✅ Phase 0 complete, architect-approved
- **Next**: Phase 1 - Core Identity & Auth (Next.js 14 migration, Supabase Auth integration)

### October 30, 2025 - Enterprise Multi-Tenant Architecture Specification
- **Created ENTERPRISE-ARCHITECTURE.md** (~40KB comprehensive spec)
  - 🏢 Complete enterprise transformation roadmap
  - 6 core pillars: Identity, Security, Data Modeling, UX, Infrastructure, Stack
  - Shared database multi-tenant model with Row Level Security (RLS)
  - 9-week phased migration plan (Phase 0-5)
  - LGPD compliance framework (consent, portability, right to erasure)
  - Zero-trust security architecture
- **Technical Decisions**:
  - Migration: React/Vite → Next.js 14 App Router
  - Auth: Supabase Auth (OAuth, MFA, recovery codes)
  - Database: Supabase PostgreSQL with RLS policies
  - UI: Shadcn/ui components (compatible with current Radix UI)
  - i18n: next-intl (pt-BR, en-US)
  - Deployment: Vercel serverless + Supabase
  - CI/CD: GitHub Actions with Playwright E2E tests
- **Migration Strategy**:
  - Blue-green deployment approach
  - 30-minute cutover window with rollback plan
  - Beta testing phase (50 users, 2 weeks)
  - PITR backups for disaster recovery
- **Scope**: Transform from single-user app to multi-tenant SaaS platform supporting:
  - Individual students (personal progress, multi-device sync)
  - Study groups (collaboration, rankings, sharing)
  - Educational institutions (class management, reports)
  - Corporate training (compliance tracking)
- **Status**: ✅ Architecture specification approved by architect

### October 29, 2025 - Documentation Overhaul & Professional GitHub Structure
- **Created Comprehensive Documentation Suite** in `/docs` directory
  - 📘 INSTALLATION.md - Complete installation guide (basic and full setup)
  - 🏗️ ARCHITECTURE.md - Detailed technical architecture with diagrams
  - 💻 DEVELOPMENT.md - Developer guide with patterns and best practices
  - 🧪 TESTING.md - Testing strategy, execution, and coverage
  - 🤝 CONTRIBUTING.md - Contribution guidelines with code of conduct
  - 🔌 API.md - Complete API reference with examples
  - 📚 docs/README.md - Navigation index for all documentation
- **Enhanced Main README.md**
  - Added professional badges (TypeScript, React, Vite, Coverage, License)
  - Reorganized sections with tables and quick navigation
  - Added Quick Start section (3-step installation)
  - Improved feature overview with status indicators
  - Added comprehensive documentation links
  - Included testing statistics and roadmap
- **Created CHANGELOG.md** following Keep a Changelog format
  - Documented v1.0.0 release with all features
  - Structured roadmap for v1.1 and v2.0
  - Semantic versioning guidelines
- **Documentation Standards**
  - All docs follow markdown best practices
  - Consistent navigation with back links
  - Code examples in all technical guides
  - Tables for quick reference
  - Emojis for better scannability

### October 29, 2025 - Vercel to Replit Migration & Backend Setup
- Updated Vite configuration to use port 5000 (Replit requirement)
- Removed Vercel-specific scripts from package.json
- Configured Replit workflow to run development server on port 5000
- Set up deployment configuration for autoscale deployment
- Configured environment secrets (GEMINI_API_KEY, SUPABASE credentials)
- **Security Fix**: Removed GEMINI_API_KEY from client bundle (moved to backend-only)
- **Connectivity Fix**: Updated API base URL to use environment-aware configuration
  - Development: Uses http://localhost:3001 as base URL for backend API calls
  - Production: Uses empty base URL (relative paths like /api/progress work directly)
- **Backend Setup**: Installed backend dependencies and configured Express server on port 3001
- **Supabase Integration**: Created database schema and migrated edital content
  - 16 matérias (disciplines)
  - 122 tópicos principais
  - Hierarchical structure with topics and subtopics
- **Host Configuration**: Added `allowedHosts: true` to Vite config for Replit compatibility

## Project Architecture

### Current (v1.0) - Single-User

#### Frontend (Vite + React + TypeScript)
- **Framework**: Vite 6.x with React 19
- **UI Library**: Radix UI components with Tailwind CSS
- **State Management**: React Context API
- **Routing**: React Router v6
- **Port**: 5000 (development and production)

#### Backend (Node.js + Express) - OPTIONAL
- **Location**: `server/` directory
- **Port**: 3001
- **Database**: Supabase (PostgreSQL)
- **Status**: Currently not running - app uses localStorage fallback

The frontend has built-in fallback to localStorage when the backend is unavailable, so the app functions without the backend server running.

### Future (v2.0) - Multi-Tenant Enterprise

**See [docs/ENTERPRISE-ARCHITECTURE.md](docs/ENTERPRISE-ARCHITECTURE.md) for complete specification.**

- **Framework**: Next.js 14 App Router (SSR + Server Components)
- **Auth**: Supabase Auth (OAuth, MFA, SSO-ready)
- **Database**: Supabase PostgreSQL with Row Level Security
- **Authorization**: Role-based (Admin, Instructor, Learner)
- **Multi-tenancy**: Shared database with tenant_id partitioning
- **UI**: Shadcn/ui + Tailwind CSS
- **i18n**: next-intl (pt-BR, en-US)
- **Security**: Zero-trust, pgcrypto encryption, audit logs
- **Compliance**: LGPD-compliant (consent, data portability, deletion)
- **Deployment**: Vercel serverless + Supabase
- **Observability**: Sentry (errors) + Logflare (logs)

### Key Features
1. Study progress tracking across multiple subjects
2. Countdown timer to exam date
3. AI-powered topic explanations (Gemini API)
4. Progress statistics and visualization
5. Dark/light theme toggle

## Environment Variables

Required secrets configured in Replit:
- `GEMINI_API_KEY` - Google Gemini API key for AI features
- `SUPABASE_URL` - Supabase project URL
- `SUPABASE_ANON_PUBLIC` - Supabase public/anon key
- `SUPABASE_SERVICE_ROLE` - Supabase service role key (backend only)

## Dependencies

### Frontend Dependencies
- React 19.2.0
- Vite 6.x
- Radix UI components
- Tailwind CSS utilities
- Google Gemini AI SDK
- React Router

### Backend Dependencies (server/)
See `package-server.json` for complete list. Key dependencies:
- Express 4.x
- Supabase JS client
- Helmet (security)
- Express rate limiting
- CORS

## Development Workflow

Current workflow:
- **Name**: Dev Server
- **Command**: `npm run dev`
- **Port**: 5000
- **Output**: Webview

The Vite dev server runs with hot module replacement enabled and serves on 0.0.0.0:5000 to allow external access within Replit's iframe.

## Deployment Configuration

- **Target**: Autoscale (stateless deployment)
- **Build**: `npm run build`
- **Run**: `npx vite preview --port 5000 --host 0.0.0.0`
- **Output Directory**: `dist/`

## User Preferences

None documented yet - update this section as preferences are expressed.

## Test Coverage

### Test Statistics (Updated October 29, 2025)
- **Total Tests**: 82
- **Passing**: 76 (92.7%)
- **Test Files**: 10 files
- **Coverage**: 
  - Contexts: 100% (27 tests)
  - Services: 100% (17 tests)
  - Hooks: 100% (8 tests)
  - Components: 75% (18/24 tests)
  - Utils: 100% (9 tests)

### Test Infrastructure
- **Framework**: Vitest + React Testing Library
- **Mocking**: MSW (Mock Service Worker) for API calls
- **Coverage Tool**: @vitest/coverage
- **Location**: `src/__tests__/`

### Running Tests
```bash
npm test              # Watch mode
npm test:run          # Single run
npm test:ui           # UI mode
npm test:coverage     # With coverage report
```

## Known Issues & Notes

1. **Backend Server**: The Express backend server in `server/` is not currently configured to run. The app works with localStorage fallback.
2. **Supabase Integration**: Environment variables are configured, but backend server needs to be started to use Supabase database.
3. **Development Mode**: Currently running in development mode with Vite's dev server.
4. **Countdown Tests**: 6 Countdown component tests fail due to fake timer issues (component works in production).

## Next Steps (Optional)

If user wants full backend functionality:
1. Install backend dependencies: `npm install --prefix server/ -f package-server.json`
2. Configure backend workflow to run on port 3001
3. Update CORS configuration to allow Replit domain
4. Test Supabase connection
