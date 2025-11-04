# 🏢 Enterprise Multi-Tenant Architecture Specification

> Especificação completa da transformação do TCU TI 2025 Dashboard para sistema multi-usuário empresarial

**Versão**: 1.0.0  
**Data**: 29 de outubro de 2025  
**Status**: 📋 Em Planejamento

---

## 📋 Índice

- [Visão Geral](#visão-geral)
- [Decisões Arquiteturais](#decisões-arquiteturais)
- [Governança de Identidade](#governança-de-identidade)
- [Modelagem de Dados Multi-Tenant](#modelagem-de-dados-multi-tenant)
- [Segurança e Compliance](#segurança-e-compliance)
- [Migração e Rollout](#migração-e-rollout)
- [Tecnologias e Stack](#tecnologias-e-stack)
- [Fases de Implementação](#fases-de-implementação)

---

## Visão Geral

### Contexto Atual

**Sistema Atual (v1.0)**:
- **Arquitetura**: Single-user React SPA
- **Persistência**: localStorage (browser)
- **Backend**: Opcional (Express + Supabase)
- **Usuários**: Individual, sem autenticação
- **Dados**: 16 matérias, 122 tópicos, 380 subtópicos

**Limitações**:
- ❌ Sem multi-usuário
- ❌ Sem sincronização entre dispositivos
- ❌ Sem compartilhamento de progresso
- ❌ Sem gestão de permissões
- ❌ Sem compliance LGPD
- ❌ Sem auditoria

### Objetivo da Transformação

**Sistema Enterprise (v2.0)**:
- **Arquitetura**: Multi-tenant SaaS platform
- **Autenticação**: Supabase Auth (OAuth, MFA)
- **Autorização**: RBAC granular com RLS
- **Compliance**: LGPD compliant
- **Escalabilidade**: Serverless, global
- **Segurança**: Zero-trust architecture

**Casos de Uso**:
1. **Estudantes Individuais**: Progresso pessoal, sincronização multi-device
2. **Grupos de Estudo**: Compartilhamento, rankings, colaboração
3. **Instituições de Ensino**: Gestão de turmas, acompanhamento, relatórios
4. **Empresas**: Treinamento corporativo, compliance tracking

---

## Decisões Arquiteturais

### 1. Modelo Multi-Tenancy

**Decisão**: **Shared Database, Logical Partitioning** ✅

**Justificativa**:

| Critério | Shared DB | DB-per-Tenant | Decisão |
|----------|-----------|---------------|---------|
| **Custo** | ✅ Baixo (1 DB) | ❌ Alto (N DBs) | Shared DB |
| **Complexidade** | ✅ Simples | ❌ Alta (migrations x N) | Shared DB |
| **Isolamento** | ⚠️ RLS necessário | ✅ Total | Shared DB + RLS |
| **Escalabilidade** | ✅ Vertical + sharding futuro | ⚠️ Horizontal complexo | Shared DB |
| **Manutenção** | ✅ 1 schema = 1 migration | ❌ N migrations | Shared DB |

**Implementação**:
```sql
-- Todas as tabelas incluem tenant_id
CREATE TABLE progress (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  -- ... outros campos
  UNIQUE(tenant_id, user_id, subtopic_id)
);

-- RLS Policy
CREATE POLICY "Users see only their tenant's data"
  ON progress
  FOR ALL
  USING (tenant_id = current_setting('app.current_tenant')::uuid);
```

### 2. Framework Migration

**Decisão**: **Next.js 14 App Router** ✅

**Comparação**:

| Feature | React/Vite (atual) | Next.js 14 App Router |
|---------|-------------------|----------------------|
| **SSR/SSG** | ❌ Client-only | ✅ Server Components |
| **Auth Middleware** | ❌ Client-side only | ✅ Edge middleware |
| **API Routes** | ❌ Separate backend | ✅ Built-in |
| **File-based Routing** | ⚠️ React Router | ✅ Nativo |
| **Optimizations** | ⚠️ Manual | ✅ Automático |
| **SEO** | ❌ Limitado | ✅ Excelente |

**Estratégia de Migração**:
1. ✅ Manter estrutura de componentes (Radix UI → Shadcn compatible)
2. ✅ Converter contexts → Server/Client Components
3. ✅ Migrar routes → App Router (pages/, layout.tsx)
4. ✅ API routes → Route Handlers + Server Actions
5. ✅ Preservar Tailwind CSS e TypeScript

### 3. Identity Provider

**Decisão**: **Supabase Auth** ✅

**Features**:
- ✅ OAuth providers (Google, GitHub, etc.)
- ✅ Magic links (passwordless)
- ✅ MFA (TOTP, SMS)
- ✅ Session management
- ✅ PKCE flow (mobile-ready)
- ✅ Row Level Security integration
- ✅ LGPD compliant (data portability, deletion)

**Providers Habilitados**:
```typescript
// supabase/config.toml
[auth.external.google]
enabled = true
client_id = "env(GOOGLE_CLIENT_ID)"
secret = "env(GOOGLE_CLIENT_SECRET)"

[auth.external.github]
enabled = true
client_id = "env(GITHUB_CLIENT_ID)"
secret = "env(GITHUB_CLIENT_SECRET)"
```

---

## Governança de Identidade

### Modelo de Roles e Permissões

**Hierarquia**:

```
┌─────────────────────────────────────┐
│         System Admin                │  (Supabase Dashboard)
├─────────────────────────────────────┤
│         Tenant Admin                │  Gerencia tenant, membros, configurações
├─────────────────────────────────────┤
│         Instructor                  │  Cria turmas, visualiza progresso, relatórios
├─────────────────────────────────────┤
│         Learner                     │  Estuda, marca progresso, visualiza estatísticas
└─────────────────────────────────────┘
```

**Schema de Roles**:

```sql
-- Enum de roles
CREATE TYPE user_role AS ENUM ('admin', 'instructor', 'learner');

-- Tabela de tenants
CREATE TABLE tenants (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name varchar(255) NOT NULL,
  slug varchar(100) UNIQUE NOT NULL,
  settings jsonb DEFAULT '{}',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Perfis de usuários (synced com auth.users)
CREATE TABLE profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email varchar(255) NOT NULL,
  full_name varchar(255),
  avatar_url varchar(500),
  default_tenant_id uuid REFERENCES tenants(id),
  preferences jsonb DEFAULT '{"theme": "light", "locale": "pt-BR"}',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Membros de tenants (many-to-many)
CREATE TABLE tenant_members (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  role user_role NOT NULL DEFAULT 'learner',
  invited_by uuid REFERENCES auth.users(id),
  invited_at timestamptz DEFAULT now(),
  accepted_at timestamptz,
  UNIQUE(tenant_id, user_id)
);

-- Índices para performance
CREATE INDEX idx_tenant_members_tenant ON tenant_members(tenant_id);
CREATE INDEX idx_tenant_members_user ON tenant_members(user_id);
CREATE INDEX idx_tenant_members_role ON tenant_members(role);
```

### Matriz de Permissões

| Recurso | Admin | Instructor | Learner |
|---------|-------|------------|---------|
| **Tenant Settings** | ✅ CRUD | ❌ | ❌ |
| **Invite Members** | ✅ | ✅ (learners only) | ❌ |
| **Manage Roles** | ✅ | ❌ | ❌ |
| **View All Progress** | ✅ | ✅ (own groups) | ❌ |
| **Export Data** | ✅ | ✅ (own groups) | ✅ (own only) |
| **Manage Study Plans** | ✅ | ✅ | ❌ |
| **Mark Progress** | ✅ | ✅ | ✅ |
| **View Statistics** | ✅ All | ✅ Groups | ✅ Personal |

### LGPD Compliance

**Princípios**:

1. **Consentimento** ✅
   - Termo de uso e política de privacidade
   - Opt-in explícito para coleta de dados
   - Revogável a qualquer momento

2. **Transparência** ✅
   - Dashboard de dados coletados
   - Finalidade clara de cada dado
   - Compartilhamentos explícitos

3. **Segurança** ✅
   - Criptografia em repouso (pgcrypto)
   - Criptografia em trânsito (TLS 1.3)
   - Acesso baseado em roles (RLS)

4. **Portabilidade** ✅
   - Exportação em JSON/CSV
   - API para migração
   - Formato estruturado

5. **Direito ao Esquecimento** ✅
   - Soft delete (anonymization)
   - Hard delete (CASCADE)
   - Purge de backups após período

**Implementação**:

```sql
-- Tabela de consentimentos
CREATE TABLE user_consents (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  consent_type varchar(50) NOT NULL, -- 'terms', 'privacy', 'marketing'
  version varchar(20) NOT NULL,
  granted_at timestamptz DEFAULT now(),
  revoked_at timestamptz,
  ip_address inet,
  user_agent text
);

-- Tabela de data requests (portabilidade, exclusão)
CREATE TABLE data_requests (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id),
  request_type varchar(50) NOT NULL, -- 'export', 'delete'
  status varchar(50) DEFAULT 'pending', -- 'pending', 'processing', 'completed', 'failed'
  requested_at timestamptz DEFAULT now(),
  completed_at timestamptz,
  data_url text, -- S3 URL para exportação
  expires_at timestamptz
);
```

---

## Modelagem de Dados Multi-Tenant

### Schema Completo

```sql
-- ============================================
-- CORE TABLES
-- ============================================

-- Tenants (Organizações)
CREATE TABLE tenants (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name varchar(255) NOT NULL,
  slug varchar(100) UNIQUE NOT NULL,
  settings jsonb DEFAULT '{}',
  subscription_tier varchar(50) DEFAULT 'free', -- 'free', 'pro', 'enterprise'
  subscription_expires_at timestamptz,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Profiles (extensão de auth.users)
CREATE TABLE profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email varchar(255) NOT NULL,
  full_name varchar(255),
  avatar_url varchar(500),
  default_tenant_id uuid REFERENCES tenants(id),
  preferences jsonb DEFAULT '{"theme": "light", "locale": "pt-BR"}',
  onboarding_completed boolean DEFAULT false,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Tenant Members (many-to-many)
CREATE TABLE tenant_members (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  role user_role NOT NULL DEFAULT 'learner',
  invited_by uuid REFERENCES auth.users(id),
  invited_at timestamptz DEFAULT now(),
  accepted_at timestamptz,
  UNIQUE(tenant_id, user_id)
);

-- ============================================
-- EDITAL STRUCTURE (Multi-tenant aware)
-- ============================================

-- Subjects (Matérias)
CREATE TABLE subjects (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid REFERENCES tenants(id) ON DELETE CASCADE,
  external_id varchar(50) NOT NULL, -- 'CON-0', 'CON-1', etc.
  name varchar(255) NOT NULL,
  slug varchar(100) NOT NULL,
  type varchar(50) NOT NULL, -- 'CONHECIMENTOS GERAIS', 'CONHECIMENTOS ESPECÍFICOS'
  order_index int NOT NULL,
  is_custom boolean DEFAULT false, -- true se criado pelo tenant, false se seed data
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(tenant_id, external_id)
);

-- Topics (Tópicos)
CREATE TABLE topics (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_id uuid NOT NULL REFERENCES subjects(id) ON DELETE CASCADE,
  external_id varchar(50) NOT NULL, -- 'CON-0-1', etc.
  title text NOT NULL,
  order_index int NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Subtopics (Subtópicos - hierarquia recursiva)
CREATE TABLE subtopics (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  topic_id uuid NOT NULL REFERENCES topics(id) ON DELETE CASCADE,
  parent_id uuid REFERENCES subtopics(id) ON DELETE CASCADE,
  external_id varchar(50) NOT NULL, -- 'CON-0-1.1', etc.
  title text NOT NULL,
  level int NOT NULL DEFAULT 1, -- 1, 2, 3 (profundidade)
  order_index int NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- ============================================
-- USER PROGRESS
-- ============================================

-- Study Plans (Planos de estudo personalizados)
CREATE TABLE study_plans (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name varchar(255) NOT NULL,
  description text,
  target_date date, -- Data alvo de conclusão
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Progress (Progresso do usuário)
CREATE TABLE progress (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  subtopic_id uuid NOT NULL REFERENCES subtopics(id) ON DELETE CASCADE,
  completed_at timestamptz DEFAULT now(),
  notes text,
  confidence_level int CHECK (confidence_level BETWEEN 1 AND 5),
  UNIQUE(tenant_id, user_id, subtopic_id)
);

-- Study Sessions (Sessões de estudo para analytics)
CREATE TABLE study_sessions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  started_at timestamptz DEFAULT now(),
  ended_at timestamptz,
  duration_seconds int GENERATED ALWAYS AS (
    EXTRACT(EPOCH FROM (ended_at - started_at))::int
  ) STORED,
  subjects_studied uuid[] -- array de subject_ids
);

-- ============================================
-- AUDIT & COMPLIANCE
-- ============================================

-- Audit Log (Imutável)
CREATE TABLE audit_log (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid REFERENCES tenants(id) ON DELETE SET NULL,
  user_id uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  action varchar(100) NOT NULL, -- 'user.login', 'progress.update', etc.
  resource_type varchar(50), -- 'progress', 'tenant', etc.
  resource_id uuid,
  old_values jsonb,
  new_values jsonb,
  ip_address inet,
  user_agent text,
  timestamp timestamptz DEFAULT now()
);

-- Prevent deletion or updates (immutable)
CREATE RULE audit_log_no_delete AS ON DELETE TO audit_log DO INSTEAD NOTHING;
CREATE RULE audit_log_no_update AS ON UPDATE TO audit_log DO INSTEAD NOTHING;

-- User Consents (LGPD)
CREATE TABLE user_consents (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  consent_type varchar(50) NOT NULL,
  version varchar(20) NOT NULL,
  granted_at timestamptz DEFAULT now(),
  revoked_at timestamptz,
  ip_address inet,
  user_agent text
);

-- Data Requests (LGPD - portabilidade e exclusão)
CREATE TABLE data_requests (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id),
  request_type varchar(50) NOT NULL,
  status varchar(50) DEFAULT 'pending',
  requested_at timestamptz DEFAULT now(),
  completed_at timestamptz,
  data_url text,
  expires_at timestamptz
);

-- ============================================
-- ÍNDICES
-- ============================================

-- Tenant Members
CREATE INDEX idx_tenant_members_tenant ON tenant_members(tenant_id);
CREATE INDEX idx_tenant_members_user ON tenant_members(user_id);
CREATE INDEX idx_tenant_members_role ON tenant_members(role);

-- Subjects
CREATE INDEX idx_subjects_tenant ON subjects(tenant_id);
CREATE INDEX idx_subjects_type ON subjects(type);

-- Topics
CREATE INDEX idx_topics_subject ON topics(subject_id);

-- Subtopics
CREATE INDEX idx_subtopics_topic ON subtopics(topic_id);
CREATE INDEX idx_subtopics_parent ON subtopics(parent_id);

-- Progress
CREATE INDEX idx_progress_tenant_user ON progress(tenant_id, user_id);
CREATE INDEX idx_progress_subtopic ON progress(subtopic_id);
CREATE INDEX idx_progress_completed_at ON progress(completed_at DESC);

-- Audit Log
CREATE INDEX idx_audit_log_tenant ON audit_log(tenant_id);
CREATE INDEX idx_audit_log_user ON audit_log(user_id);
CREATE INDEX idx_audit_log_timestamp ON audit_log(timestamp DESC);
CREATE INDEX idx_audit_log_action ON audit_log(action);
```

### Row Level Security (RLS) Policies

**Princípios**:
1. ✅ **Default Deny**: Tudo bloqueado por padrão
2. ✅ **Explicit Allow**: Policies explícitas para cada caso
3. ✅ **Tenant Isolation**: Usuários só veem dados do seu tenant
4. ✅ **Role-based**: Permissões por role
5. ✅ **Context Aware**: Usa `current_setting('app.current_tenant')`
6. ✅ **Insert Protection**: WITH CHECK clauses impedem inserções cross-tenant

**Setting Tenant Context per Session**:

```typescript
// lib/supabase/server.ts
export async function setTenantContext(supabase: SupabaseClient, tenantId: string) {
  // Set tenant context for RLS policies
  const { error } = await supabase.rpc('set_config', {
    setting_name: 'app.current_tenant',
    setting_value: tenantId,
    is_local: true // Session-scoped
  });
  
  if (error) {
    throw new Error(`Failed to set tenant context: ${error.message}`);
  }
}

// middleware.ts - Set context on every request
export async function middleware(request: NextRequest) {
  const supabase = createServerClient();
  const session = await supabase.auth.getSession();
  
  if (!session.data.session) {
    return NextResponse.redirect(new URL('/login', request.url));
  }
  
  // Get user's default tenant or tenant from header
  const tenantId = request.headers.get('x-tenant-id') || 
                   session.data.session.user.user_metadata.default_tenant_id;
  
  if (tenantId) {
    await setTenantContext(supabase, tenantId);
  }
  
  return NextResponse.next();
}
```

**Implementação**:

```sql
-- ============================================
-- ENABLE RLS ON ALL TABLES
-- ============================================

ALTER TABLE tenants ENABLE ROW LEVEL SECURITY;
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE tenant_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE subjects ENABLE ROW LEVEL SECURITY;
ALTER TABLE topics ENABLE ROW LEVEL SECURITY;
ALTER TABLE subtopics ENABLE ROW LEVEL SECURITY;
ALTER TABLE study_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE study_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_log ENABLE ROW LEVEL SECURITY;

-- ============================================
-- HELPER FUNCTIONS
-- ============================================

-- Get current user's role in a tenant
CREATE OR REPLACE FUNCTION get_user_role(p_tenant_id uuid)
RETURNS user_role AS $$
  SELECT role
  FROM tenant_members
  WHERE tenant_id = p_tenant_id
    AND user_id = auth.uid()
    AND accepted_at IS NOT NULL;
$$ LANGUAGE sql STABLE SECURITY DEFINER;

-- Check if user is admin in tenant
CREATE OR REPLACE FUNCTION is_tenant_admin(p_tenant_id uuid)
RETURNS boolean AS $$
  SELECT EXISTS (
    SELECT 1 FROM tenant_members
    WHERE tenant_id = p_tenant_id
      AND user_id = auth.uid()
      AND role = 'admin'
      AND accepted_at IS NOT NULL
  );
$$ LANGUAGE sql STABLE SECURITY DEFINER;

-- ============================================
-- POLICIES: PROFILES
-- ============================================

-- Users can view their own profile
CREATE POLICY "Users can view own profile"
  ON profiles FOR SELECT
  USING (id = auth.uid());

-- Users can update their own profile
CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  USING (id = auth.uid());

-- ============================================
-- POLICIES: TENANT_MEMBERS
-- ============================================

-- Users can view members of their tenants
CREATE POLICY "Users can view tenant members"
  ON tenant_members FOR SELECT
  USING (
    tenant_id IN (
      SELECT tenant_id FROM tenant_members
      WHERE user_id = auth.uid() AND accepted_at IS NOT NULL
    )
  );

-- Admins and instructors can invite members
CREATE POLICY "Admins can manage members"
  ON tenant_members FOR ALL
  USING (
    is_tenant_admin(tenant_id)
    OR (
      get_user_role(tenant_id) = 'instructor'
      AND role = 'learner' -- instructors can only invite learners
    )
  );

-- ============================================
-- POLICIES: PROGRESS
-- ============================================

-- Users can view their own progress
CREATE POLICY "Users can view own progress"
  ON progress FOR SELECT
  USING (
    user_id = auth.uid()
    AND tenant_id IN (
      SELECT tenant_id FROM tenant_members
      WHERE user_id = auth.uid() AND accepted_at IS NOT NULL
    )
  );

-- Admins and instructors can view all progress in their tenant
CREATE POLICY "Admins and instructors can view all progress"
  ON progress FOR SELECT
  USING (
    get_user_role(tenant_id) IN ('admin', 'instructor')
  );

-- Users can insert/update their own progress
CREATE POLICY "Users can manage own progress"
  ON progress FOR INSERT
  WITH CHECK (
    user_id = auth.uid()
    AND tenant_id = current_setting('app.current_tenant')::uuid
    AND tenant_id IN (
      SELECT tenant_id FROM tenant_members
      WHERE user_id = auth.uid() AND accepted_at IS NOT NULL
    )
  );

CREATE POLICY "Users can update own progress"
  ON progress FOR UPDATE
  USING (user_id = auth.uid() AND tenant_id = current_setting('app.current_tenant')::uuid)
  WITH CHECK (user_id = auth.uid() AND tenant_id = current_setting('app.current_tenant')::uuid);

CREATE POLICY "Users can delete own progress"
  ON progress FOR DELETE
  USING (user_id = auth.uid() AND tenant_id = current_setting('app.current_tenant')::uuid);

-- Performance: Índice composto para queries tenant-scoped
CREATE INDEX idx_progress_tenant_user_composite ON progress(tenant_id, user_id, completed_at DESC);

-- ============================================
-- POLICIES: AUDIT_LOG
-- ============================================

-- Admins can view audit logs for their tenant
CREATE POLICY "Admins can view audit logs"
  ON audit_log FOR SELECT
  USING (is_tenant_admin(tenant_id));

-- System can insert audit logs (SECURITY DEFINER function)
-- Users cannot modify audit logs (protected by RULES)
```

### Performance Considerations

**Indexing Strategy**:

```sql
-- Composite indexes for tenant-scoped queries
CREATE INDEX idx_progress_tenant_user_completed 
  ON progress(tenant_id, user_id, completed_at DESC)
  WHERE completed_at IS NOT NULL;

CREATE INDEX idx_progress_tenant_subtopic 
  ON progress(tenant_id, subtopic_id)
  INCLUDE (completed_at, confidence_level);

-- Partial indexes for active data
CREATE INDEX idx_active_study_plans 
  ON study_plans(tenant_id, user_id)
  WHERE is_active = true;

-- GIN index for jsonb preferences
CREATE INDEX idx_profiles_preferences 
  ON profiles USING GIN (preferences);
```

**Query Optimization**:

```sql
-- Materialized view for aggregate statistics
CREATE MATERIALIZED VIEW tenant_progress_stats AS
SELECT 
  p.tenant_id,
  p.user_id,
  COUNT(DISTINCT p.subtopic_id) as completed_subtopics,
  COUNT(DISTINCT s.subject_id) as subjects_touched,
  AVG(p.confidence_level) as avg_confidence,
  MAX(p.completed_at) as last_study_date
FROM progress p
JOIN subtopics st ON p.subtopic_id = st.id
JOIN topics t ON st.topic_id = t.id
JOIN subjects s ON t.subject_id = s.id
GROUP BY p.tenant_id, p.user_id;

-- Refresh strategy (triggered or scheduled)
CREATE INDEX idx_progress_stats_tenant_user 
  ON tenant_progress_stats(tenant_id, user_id);

-- Refresh on demand or via cron
REFRESH MATERIALIZED VIEW CONCURRENTLY tenant_progress_stats;
```

**Seed Data Performance**:

```sql
-- Bulk insert edital structure (16 matérias, 380 subtópicos)
-- Use COPY for performance
COPY subjects(tenant_id, external_id, name, slug, type, order_index, is_custom)
FROM '/path/to/subjects.csv' WITH (FORMAT csv, HEADER true);

-- Disable triggers during bulk insert
ALTER TABLE topics DISABLE TRIGGER ALL;
COPY topics(...) FROM '/path/to/topics.csv' WITH (FORMAT csv);
ALTER TABLE topics ENABLE TRIGGER ALL;

-- Analyze tables after bulk insert
ANALYZE subjects, topics, subtopics;
```

---

## Experiência do Usuário (UX)

### Design System

**Componentes Base (Shadcn/ui)**:

```typescript
// components/ui/button.tsx
import * as React from "react"
import { Slot } from "@radix-ui/react-slot"
import { cva, type VariantProps } from "class-variance-authority"
import { cn } from "@/lib/utils"

const buttonVariants = cva(
  "inline-flex items-center justify-center rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:opacity-50 disabled:pointer-events-none ring-offset-background",
  {
    variants: {
      variant: {
        default: "bg-primary text-primary-foreground hover:bg-primary/90",
        destructive: "bg-destructive text-destructive-foreground hover:bg-destructive/90",
        outline: "border border-input hover:bg-accent hover:text-accent-foreground",
        secondary: "bg-secondary text-secondary-foreground hover:bg-secondary/80",
        ghost: "hover:bg-accent hover:text-accent-foreground",
        link: "underline-offset-4 hover:underline text-primary",
      },
      size: {
        default: "h-10 py-2 px-4",
        sm: "h-9 px-3 rounded-md",
        lg: "h-11 px-8 rounded-md",
        icon: "h-10 w-10",
      },
    },
    defaultVariants: {
      variant: "default",
      size: "default",
    },
  }
)

export interface ButtonProps
  extends React.ButtonHTMLAttributes<HTMLButtonElement>,
    VariantProps<typeof buttonVariants> {
  asChild?: boolean
}

const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant, size, asChild = false, ...props }, ref) => {
    const Comp = asChild ? Slot : "button"
    return (
      <Comp
        className={cn(buttonVariants({ variant, size, className }))}
        ref={ref}
        {...props}
      />
    )
  }
)
Button.displayName = "Button"

export { Button, buttonVariants }
```

**Design Tokens (Tailwind)**:

```typescript
// tailwind.config.ts
import type { Config } from 'tailwindcss'

const config: Config = {
  darkMode: ['class'],
  content: [
    './pages/**/*.{ts,tsx}',
    './components/**/*.{ts,tsx}',
    './app/**/*.{ts,tsx}',
  ],
  theme: {
    extend: {
      colors: {
        border: 'hsl(var(--border))',
        input: 'hsl(var(--input))',
        ring: 'hsl(var(--ring))',
        background: 'hsl(var(--background))',
        foreground: 'hsl(var(--foreground))',
        primary: {
          DEFAULT: 'hsl(var(--primary))',
          foreground: 'hsl(var(--primary-foreground))',
        },
        secondary: {
          DEFAULT: 'hsl(var(--secondary))',
          foreground: 'hsl(var(--secondary-foreground))',
        },
        destructive: {
          DEFAULT: 'hsl(var(--destructive))',
          foreground: 'hsl(var(--destructive-foreground))',
        },
        muted: {
          DEFAULT: 'hsl(var(--muted))',
          foreground: 'hsl(var(--muted-foreground))',
        },
        accent: {
          DEFAULT: 'hsl(var(--accent))',
          foreground: 'hsl(var(--accent-foreground))',
        },
      },
      borderRadius: {
        lg: 'var(--radius)',
        md: 'calc(var(--radius) - 2px)',
        sm: 'calc(var(--radius) - 4px)',
      },
    },
  },
  plugins: [require('tailwindcss-animate')],
}

export default config
```

### Acessibilidade (WCAG 2.1 AA)

**Checklist de Implementação**:

- ✅ **Contraste**: Ratio mínimo 4.5:1 para texto normal, 3:1 para texto grande
- ✅ **Navegação por Teclado**: Tab order lógica, focus indicators visíveis
- ✅ **ARIA Labels**: Todos os elementos interativos rotulados
- ✅ **Screen Reader**: Semantic HTML, landmarks, live regions
- ✅ **Responsive Text**: Suporte para zoom até 200%
- ✅ **Formulários**: Labels associados, error messages claros

**Exemplo**:

```tsx
// components/ProgressCheckbox.tsx
import { Checkbox } from '@/components/ui/checkbox'
import { Label } from '@/components/ui/label'

interface ProgressCheckboxProps {
  subtopicId: string
  title: string
  completed: boolean
  onToggle: () => void
}

export function ProgressCheckbox({ 
  subtopicId, 
  title, 
  completed, 
  onToggle 
}: ProgressCheckboxProps) {
  const id = `subtopic-${subtopicId}`
  
  return (
    <div className="flex items-center space-x-2">
      <Checkbox
        id={id}
        checked={completed}
        onCheckedChange={onToggle}
        aria-describedby={`${id}-description`}
      />
      <Label
        htmlFor={id}
        className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
      >
        {title}
      </Label>
      <span id={`${id}-description`} className="sr-only">
        {completed ? 'Concluído' : 'Não concluído'}. 
        Pressione espaço para alternar.
      </span>
    </div>
  )
}
```

### Internacionalização (i18n)

**Setup com next-intl**:

```typescript
// i18n/config.ts
export const locales = ['pt-BR', 'en-US'] as const
export type Locale = (typeof locales)[number]
export const defaultLocale: Locale = 'pt-BR'

// messages/pt-BR.json
{
  "common": {
    "welcome": "Bem-vindo",
    "login": "Entrar",
    "logout": "Sair",
    "save": "Salvar",
    "cancel": "Cancelar"
  },
  "dashboard": {
    "title": "Painel de Controle",
    "progress": "Progresso",
    "subjects": "Matérias",
    "completed": "{count} de {total} concluídos"
  },
  "lgpd": {
    "consent_title": "Consentimento de Dados",
    "consent_description": "Precisamos do seu consentimento para processar seus dados de estudo.",
    "accept": "Aceito os termos",
    "decline": "Não aceito"
  }
}

// messages/en-US.json
{
  "common": {
    "welcome": "Welcome",
    "login": "Login",
    "logout": "Logout",
    "save": "Save",
    "cancel": "Cancel"
  },
  "dashboard": {
    "title": "Dashboard",
    "progress": "Progress",
    "subjects": "Subjects",
    "completed": "{count} of {total} completed"
  },
  "lgpd": {
    "consent_title": "Data Consent",
    "consent_description": "We need your consent to process your study data.",
    "accept": "I accept the terms",
    "decline": "I decline"
  }
}

// app/[locale]/layout.tsx
import { NextIntlClientProvider } from 'next-intl'
import { getMessages } from 'next-intl/server'

export default async function LocaleLayout({
  children,
  params: { locale }
}: {
  children: React.ReactNode
  params: { locale: string }
}) {
  const messages = await getMessages()
  
  return (
    <html lang={locale}>
      <body>
        <NextIntlClientProvider messages={messages}>
          {children}
        </NextIntlClientProvider>
      </body>
    </html>
  )
}

// Usage in components
import { useTranslations } from 'next-intl'

export function DashboardHeader() {
  const t = useTranslations('dashboard')
  
  return (
    <h1>{t('title')}</h1>
  )
}
```

### Estados de Feedback

**Loading States**:

```tsx
// components/ProgressSkeleton.tsx
export function ProgressSkeleton() {
  return (
    <div className="space-y-4">
      {[...Array(5)].map((_, i) => (
        <div key={i} className="flex items-center space-x-4">
          <Skeleton className="h-4 w-4 rounded" />
          <Skeleton className="h-4 w-3/4" />
        </div>
      ))}
    </div>
  )
}
```

**Error Boundaries**:

```tsx
// components/ErrorBoundary.tsx
'use client'

import { useEffect } from 'react'
import { Button } from '@/components/ui/button'

export function ErrorBoundary({
  error,
  reset,
}: {
  error: Error & { digest?: string }
  reset: () => void
}) {
  useEffect(() => {
    // Log to Sentry
    console.error(error)
  }, [error])

  return (
    <div className="flex min-h-screen flex-col items-center justify-center">
      <div className="space-y-4 text-center">
        <h2 className="text-2xl font-bold">Algo deu errado!</h2>
        <p className="text-muted-foreground">
          {error.message || 'Ocorreu um erro inesperado.'}
        </p>
        <Button onClick={reset}>Tentar novamente</Button>
      </div>
    </div>
  )
}
```

---

## Infraestrutura e Operações

### Deployment Architecture

**Topology (Serverless)**:

```
┌─────────────────────────────────────────────────┐
│               Vercel Edge Network               │
│  ┌──────────────────────────────────────────┐   │
│  │        Next.js App (Edge Runtime)        │   │
│  │  ┌────────────┐      ┌────────────┐      │   │
│  │  │   Pages    │      │    API     │      │   │
│  │  │ (SSR/SSG)  │      │  Routes    │      │   │
│  │  └────────────┘      └────────────┘      │   │
│  └──────────────────────────────────────────┘   │
└─────────────────────────────────────────────────┘
                       ↓
┌─────────────────────────────────────────────────┐
│            Supabase Platform (AWS)              │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│  │PostgreSQL│  │   Auth   │  │ Storage  │      │
│  │   + RLS  │  │          │  │          │      │
│  └──────────┘  └──────────┘  └──────────┘      │
│  ┌──────────┐  ┌──────────┐                    │
│  │ Realtime │  │   Edge   │                    │
│  │          │  │ Functions│                    │
│  └──────────┘  └──────────┘                    │
└─────────────────────────────────────────────────┘
                       ↓
┌─────────────────────────────────────────────────┐
│              Observability Stack                │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│  │  Sentry  │  │ Logflare │  │  Vercel  │      │
│  │  (Errors)│  │  (Logs)  │  │(Analytics│      │
│  └──────────┘  └──────────┘  └──────────┘      │
└─────────────────────────────────────────────────┘
```

**Environment Strategy**:

| Environment | Branch | URL | Purpose |
|-------------|--------|-----|---------|
| **Development** | `feature/*` | localhost:3000 | Local dev |
| **Preview** | PR branches | `pr-{number}.vercel.app` | Testing PRs |
| **Staging** | `develop` | `staging.tcu-dashboard.com` | Pre-prod |
| **Production** | `main` | `app.tcu-dashboard.com` | Live |

### CI/CD Pipeline

**GitHub Actions Workflow**:

```yaml
# .github/workflows/ci.yml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

env:
  NODE_VERSION: '20.x'

jobs:
  lint-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Lint
        run: npm run lint
      
      - name: Type check
        run: npm run type-check
      
      - name: Unit tests
        run: npm run test:run
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage/coverage-final.json

  rls-policy-tests:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: supabase/postgres:15
        env:
          POSTGRES_PASSWORD: postgres
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
    steps:
      - uses: actions/checkout@v4
      
      - name: Run RLS policy tests
        run: |
          psql -h localhost -U postgres -f supabase/migrations/*.sql
          psql -h localhost -U postgres -f supabase/tests/rls-policies.sql

  e2e-tests:
    needs: lint-and-test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
      
      - name: Install dependencies
        run: npm ci
      
      - name: Install Playwright
        run: npx playwright install --with-deps
      
      - name: Run E2E tests
        run: npm run test:e2e
        env:
          SUPABASE_URL: ${{ secrets.SUPABASE_URL_TEST }}
          SUPABASE_ANON_KEY: ${{ secrets.SUPABASE_ANON_KEY_TEST }}
      
      - uses: actions/upload-artifact@v3
        if: failure()
        with:
          name: playwright-report
          path: playwright-report/

  deploy-preview:
    if: github.event_name == 'pull_request'
    needs: [lint-and-test, rls-policy-tests]
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Deploy to Vercel (Preview)
        uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
          scope: ${{ secrets.VERCEL_ORG_ID }}

  deploy-production:
    if: github.ref == 'refs/heads/main' && github.event_name == 'push'
    needs: [lint-and-test, rls-policy-tests, e2e-tests]
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Deploy to Vercel (Production)
        uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
          vercel-args: '--prod'
          scope: ${{ secrets.VERCEL_ORG_ID }}
      
      - name: Notify Sentry of deployment
        run: |
          curl -X POST \
            https://sentry.io/api/0/organizations/${{ secrets.SENTRY_ORG }}/releases/ \
            -H 'Authorization: Bearer ${{ secrets.SENTRY_AUTH_TOKEN }}' \
            -H 'Content-Type: application/json' \
            -d '{"version": "${{ github.sha }}", "projects": ["tcu-dashboard"]}'
```

### Monitoring & Observability

**Sentry Configuration**:

```typescript
// sentry.client.config.ts
import * as Sentry from '@sentry/nextjs'

Sentry.init({
  dsn: process.env.NEXT_PUBLIC_SENTRY_DSN,
  environment: process.env.NEXT_PUBLIC_VERCEL_ENV || 'development',
  tracesSampleRate: 0.1,
  replaysSessionSampleRate: 0.1,
  replaysOnErrorSampleRate: 1.0,
  
  beforeSend(event, hint) {
    // Filter out known errors
    if (event.exception) {
      const error = hint.originalException
      if (error instanceof Error && error.message.includes('NetworkError')) {
        return null // Don't send network errors
      }
    }
    return event
  },
  
  integrations: [
    new Sentry.BrowserTracing(),
    new Sentry.Replay({
      maskAllText: true,
      blockAllMedia: true,
    }),
  ],
})
```

**Logflare Integration**:

```typescript
// lib/logger.ts
import pino from 'pino'

const logger = pino({
  level: process.env.LOG_LEVEL || 'info',
  transport: {
    target: '@logflare/pino',
    options: {
      apiKey: process.env.LOGFLARE_API_KEY,
      sourceToken: process.env.LOGFLARE_SOURCE_TOKEN,
    },
  },
})

export { logger }

// Usage
logger.info({ tenantId, userId }, 'User logged in')
logger.error({ error, context }, 'Failed to save progress')
```

**Alerting Rules**:

```yaml
# supabase/alerts.yml
alerts:
  - name: high-error-rate
    condition: error_rate > 0.01
    window: 5m
    channels: [slack, pagerduty]
    message: "Error rate exceeded 1% in the last 5 minutes"
  
  - name: rls-policy-violation
    condition: count(audit_log WHERE action = 'rls.violation') > 0
    window: 1m
    channels: [slack, sentry]
    message: "RLS policy violation detected"
  
  - name: slow-queries
    condition: p95(query_duration) > 500ms
    window: 5m
    channels: [slack]
    message: "Database queries are slow (p95 > 500ms)"
  
  - name: failed-logins
    condition: count(auth.failed_login) > 10
    window: 1m
    channels: [slack]
    message: "High number of failed login attempts"
```

### Backup & Disaster Recovery

**Supabase PITR (Point-in-Time Recovery)**:

```bash
# Enable PITR (Pro plan+)
supabase db backup enable --retention-days 30

# Restore to specific timestamp
supabase db restore --timestamp "2025-10-29 12:00:00+00"

# Automated backup verification (weekly)
# .github/workflows/backup-verify.yml
name: Verify Backups
on:
  schedule:
    - cron: '0 0 * * 0' # Weekly on Sunday
  workflow_dispatch:

jobs:
  verify:
    runs-on: ubuntu-latest
    steps:
      - name: Restore latest backup to test DB
        run: |
          supabase db restore --db test --latest
          
      - name: Verify data integrity
        run: |
          psql $TEST_DATABASE_URL -f tests/integrity-check.sql
```

**Data Export (LGPD Portability)**:

```sql
-- Stored procedure for user data export
CREATE OR REPLACE FUNCTION export_user_data(p_user_id uuid)
RETURNS jsonb AS $$
DECLARE
  result jsonb;
BEGIN
  SELECT jsonb_build_object(
    'profile', (SELECT row_to_json(p.*) FROM profiles p WHERE id = p_user_id),
    'progress', (SELECT jsonb_agg(row_to_json(pr.*)) FROM progress pr WHERE user_id = p_user_id),
    'study_plans', (SELECT jsonb_agg(row_to_json(sp.*)) FROM study_plans sp WHERE user_id = p_user_id),
    'study_sessions', (SELECT jsonb_agg(row_to_json(ss.*)) FROM study_sessions ss WHERE user_id = p_user_id),
    'consents', (SELECT jsonb_agg(row_to_json(c.*)) FROM user_consents c WHERE user_id = p_user_id)
  ) INTO result;
  
  -- Log export request
  INSERT INTO audit_log (user_id, action, resource_type)
  VALUES (p_user_id, 'data.exported', 'user');
  
  RETURN result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

**Rollback Plan**:

```markdown
# Rollback Procedures

## Scenario 1: Code Deployment Failure

1. Identify failing deployment in Vercel dashboard
2. Click "Rollback to Previous Deployment"
3. Verify rollback success in staging
4. Monitor error rates for 30 minutes

## Scenario 2: Database Migration Failure

1. Identify last successful migration timestamp
2. Restore database using PITR:
   ```bash
   supabase db restore --timestamp "YYYY-MM-DD HH:MM:SS+00"
   ```
3. Re-run application with previous schema
4. Investigate migration failure
5. Fix and re-deploy

## Scenario 3: Data Corruption

1. Stop all writes to affected table(s)
2. Identify corruption timestamp from audit logs
3. Restore from PITR before corruption
4. Re-apply valid transactions after restore point
5. Verify data integrity
6. Resume writes

## Scenario 4: Security Breach

1. Immediately revoke all active sessions:
   ```sql
   DELETE FROM auth.sessions;
   ```
2. Force password reset for affected users
3. Rotate all API keys and secrets
4. Review audit logs for breach extent
5. Notify affected users (LGPD requirement)
6. Conduct post-mortem
```

---

## Segurança e Compliance

### Zero-Trust Architecture

**Princípios**:

1. **Never Trust, Always Verify** ✅
   - Toda request é autenticada
   - Tokens validados em cada endpoint
   - Session expiração curta (1h)

2. **Least Privilege** ✅
   - RLS policies granulares
   - Funções SECURITY DEFINER apenas quando necessário
   - Roles com permissões mínimas

3. **Micro-segmentation** ✅
   - Tenants isolados por RLS
   - API routes com middleware de autorização
   - Edge Functions para lógica sensível

**Implementação**:

```typescript
// middleware.ts (Next.js)
export async function middleware(request: NextRequest) {
  const supabase = createServerClient();
  
  // Verify session
  const {
    data: { session },
    error
  } = await supabase.auth.getSession();
  
  if (!session) {
    return NextResponse.redirect(new URL('/login', request.url));
  }
  
  // Set tenant context for RLS
  const tenantId = request.headers.get('x-tenant-id');
  if (tenantId) {
    await supabase.rpc('set_tenant_context', { tenant_id: tenantId });
  }
  
  return NextResponse.next();
}

export const config = {
  matcher: ['/dashboard/:path*', '/api/:path*']
};
```

### Criptografia

**Em Trânsito** (TLS 1.3):
- ✅ HTTPS obrigatório
- ✅ Certificate pinning (mobile)
- ✅ HSTS headers

**Em Repouso** (pgcrypto):

```sql
-- Enable pgcrypto extension
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Exemplo: criptografar dados sensíveis
CREATE TABLE sensitive_data (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id),
  encrypted_notes bytea, -- dados criptografados
  -- ...
);

-- Encrypt function
CREATE OR REPLACE FUNCTION encrypt_sensitive_data(plaintext text, key text)
RETURNS bytea AS $$
  SELECT pgp_sym_encrypt(plaintext, key);
$$ LANGUAGE sql;

-- Decrypt function
CREATE OR REPLACE FUNCTION decrypt_sensitive_data(ciphertext bytea, key text)
RETURNS text AS $$
  SELECT pgp_sym_decrypt(ciphertext, key);
$$ LANGUAGE sql;
```

**Key Rotation**:
```bash
# GitHub Actions workflow
name: Rotate Encryption Keys
on:
  schedule:
    - cron: '0 0 1 */3 *' # Quarterly
  workflow_dispatch:

jobs:
  rotate:
    runs-on: ubuntu-latest
    steps:
      - name: Generate new key
        run: openssl rand -base64 32 > new_key.txt
      
      - name: Update Supabase secrets
        run: |
          supabase secrets set ENCRYPTION_KEY=$(cat new_key.txt)
      
      - name: Re-encrypt data
        run: |
          psql $DATABASE_URL -c "SELECT re_encrypt_all_data();"
```

### Monitoring & Alerting

**Observability Stack**:

```yaml
# Sentry (Error Tracking)
SENTRY_DSN: "https://..."
SENTRY_ENVIRONMENT: "production"
SENTRY_TRACES_SAMPLE_RATE: 0.1

# Logflare (Log Aggregation)
LOGFLARE_API_KEY: "..."
LOGFLARE_SOURCE_ID: "..."

# Supabase Metrics
SUPABASE_PROJECT_REF: "..."
```

**Alertas**:
1. ✅ Falhas de autenticação > 10/min
2. ✅ RLS policy violations
3. ✅ Anomalias de uso (taxa de requests)
4. ✅ Erros 5xx > 1%
5. ✅ Latência p95 > 500ms

---

## Migração e Rollout

### Estratégia Phased Migration

**Abordagem**: Incremental com Blue-Green Deployment

```
┌──────────────┐         ┌──────────────┐
│   Blue       │         │   Green      │
│  (v1.0)      │────────>│  (v2.0)      │
│  React/Vite  │  Beta   │  Next.js 14  │
└──────────────┘         └──────────────┘
      ↓                         ↓
  localStorage            Supabase + RLS
```

---

### Phase 0: Preparação (Semana 1)

**Objetivos**: Infraestrutura base e governança

#### Tarefas Detalhadas

| # | Tarefa | Owner | Duração | Output |
|---|--------|-------|---------|--------|
| 0.1 | Provisionar Supabase project (Pro plan) | DevOps | 1h | Project ID, URLs, credentials |
| 0.2 | Configurar ambientes (dev/staging/prod) | DevOps | 4h | Environment variables, branch strategy |
| 0.3 | Habilitar PITR backups (30-day retention) | DevOps | 1h | Backup config confirmado |
| 0.4 | Setup Sentry (error tracking) | DevOps | 2h | DSN, integrations |
| 0.5 | Setup Logflare (log aggregation) | DevOps | 2h | Source tokens, retention |
| 0.6 | Documentar rollback procedures | Tech Lead | 4h | RUNBOOK.md |
| 0.7 | Define success metrics | PM | 2h | KPIs dashboard |

**Deliverables**:
- ✅ Supabase Pro project configurado
- ✅ 3 ambientes (dev, staging, prod)
- ✅ Observability stack ativo
- ✅ Rollback playbook documentado

**Exit Criteria**:
- [ ] Supabase dashboard acessível por toda equipe
- [ ] Backups automáticos verificados
- [ ] Alertas de erro enviando para Slack
- [ ] Rollback testado em ambiente staging

---

### Phase 1: Identity & Auth (Semanas 2-3)

**Objetivos**: Autenticação multi-usuário e Next.js migration

#### Week 2: Next.js Foundation

| # | Tarefa | Owner | Duração | Dependencies |
|---|--------|-------|---------|--------------|
| 1.1 | Inicializar Next.js 14 project | Frontend | 4h | - |
| 1.2 | Configurar TypeScript + ESLint | Frontend | 2h | 1.1 |
| 1.3 | Setup Tailwind + Shadcn/ui | Frontend | 4h | 1.1 |
| 1.4 | Migrar componentes base (Button, Card, etc.) | Frontend | 8h | 1.3 |
| 1.5 | Configurar App Router structure | Frontend | 4h | 1.1 |
| 1.6 | Setup Supabase client (SSR) | Frontend | 4h | 1.1, 0.1 |
| 1.7 | Deploy preview to Vercel | DevOps | 2h | 1.1-1.6 |

#### Week 3: Auth Implementation

| # | Tarefa | Owner | Duração | Dependencies |
|---|--------|-------|---------|--------------|
| 1.8 | Configurar Supabase Auth providers | Backend | 4h | 0.1 |
| 1.9 | Implementar auth middleware | Backend | 6h | 1.6, 1.8 |
| 1.10 | UI de Login/Signup | Frontend | 8h | 1.4, 1.9 |
| 1.11 | MFA setup (TOTP) | Backend | 6h | 1.9 |
| 1.12 | Recovery codes | Backend | 4h | 1.11 |
| 1.13 | LGPD consent flow | Frontend/Legal | 8h | 1.10 |
| 1.14 | E2E auth tests | QA | 8h | 1.10-1.13 |

**Deliverables**:
- ✅ Next.js 14 app funcionando em staging
- ✅ Login com Google/GitHub
- ✅ MFA opcional
- ✅ Consent LGPD capturado

**Exit Criteria**:
- [ ] Usuário pode se cadastrar e logar via OAuth
- [ ] MFA pode ser habilitado e funciona
- [ ] Consent é apresentado e armazenado
- [ ] Testes E2E de auth passam 100%

---

### Phase 2: Data Model & RLS (Semanas 4-5)

**Objetivos**: Schema multi-tenant com isolamento via RLS

#### Week 4: Database Schema

| # | Tarefa | Owner | Duração | Dependencies |
|---|--------|-------|---------|--------------|
| 2.1 | Criar migration inicial (tenants, profiles) | Backend | 4h | 0.1 |
| 2.2 | Schema de subjects/topics/subtopics | Backend | 6h | 2.1 |
| 2.3 | Schema de progress e study_plans | Backend | 4h | 2.2 |
| 2.4 | Schema de audit_log e consents | Backend | 4h | 2.1 |
| 2.5 | Criar seed data (16 matérias, 380 subtópicos) | Backend | 8h | 2.2 |
| 2.6 | Bulk import seed data | Backend | 2h | 2.5 |
| 2.7 | Verificar integridade referencial | QA | 4h | 2.6 |

#### Week 5: RLS Policies

| # | Tarefa | Owner | Duração | Dependencies |
|---|--------|-------|---------|--------------|
| 2.8 | RLS helper functions | Backend | 4h | 2.1-2.4 |
| 2.9 | RLS policies: tenants, profiles | Backend | 6h | 2.8 |
| 2.10 | RLS policies: progress, study_plans | Backend | 6h | 2.8 |
| 2.11 | RLS policies: audit_log | Backend | 4h | 2.8 |
| 2.12 | Performance indexes | Backend | 4h | 2.1-2.4 |
| 2.13 | RLS policy tests (SQL) | QA | 8h | 2.9-2.11 |
| 2.14 | Performance benchmarks | DevOps | 4h | 2.12, 2.13 |

**Deliverables**:
- ✅ Schema completo com 12+ tabelas
- ✅ 380 subtópicos seedados
- ✅ RLS policies testadas e seguras
- ✅ Performance p95 < 100ms

**Exit Criteria**:
- [ ] Schema migrations aplicadas sem erros
- [ ] Seed data completo e validado
- [ ] RLS tests passam 100% (cross-tenant isolation)
- [ ] Queries com tenant_id indexed executam <100ms

---

### Phase 3: Security Architecture (Semana 6)

**Objetivos**: Zero-trust, encryption, audit logs

| # | Tarefa | Owner | Duração | Dependencies |
|---|--------|-------|---------|--------------|
| 3.1 | Implementar session context setter | Backend | 4h | 2.8 |
| 3.2 | Next.js middleware (zero-trust) | Backend | 6h | 1.9, 3.1 |
| 3.3 | Enable pgcrypto extension | Backend | 1h | 0.1 |
| 3.4 | Encrypt sensitive fields | Backend | 6h | 3.3 |
| 3.5 | Audit log triggers | Backend | 6h | 2.4 |
| 3.6 | Key rotation workflow (GitHub Actions) | DevOps | 4h | 3.4 |
| 3.7 | Security audit | Security | 8h | 3.1-3.6 |
| 3.8 | Penetration testing | Security | 8h | 3.7 |

**Deliverables**:
- ✅ Zero-trust middleware ativo
- ✅ Dados sensíveis criptografados
- ✅ Audit logs imutáveis
- ✅ Security audit aprovado

**Exit Criteria**:
- [ ] Nenhuma request sem auth token válido passa
- [ ] Dados sensíveis encrypted at rest
- [ ] Audit logs capturando todas mutations
- [ ] Penetration test sem vulnerabilidades críticas

---

### Phase 4: Application Features (Semanas 7-8)

**Objetivos**: UI multi-tenant, i18n, data migration

#### Week 7: Multi-Tenant UI

| # | Tarefa | Owner | Duração | Dependencies |
|---|--------|-------|---------|--------------|
| 4.1 | Dashboard multi-tenant | Frontend | 12h | 1.4, 2.1 |
| 4.2 | Tenant switcher component | Frontend | 6h | 4.1 |
| 4.3 | Progress tracking UI | Frontend | 12h | 2.3, 4.1 |
| 4.4 | Statistics & analytics views | Frontend | 8h | 4.3 |
| 4.5 | Admin panel (tenant management) | Frontend | 12h | 4.1 |
| 4.6 | Accessibility audit (WCAG 2.1 AA) | Frontend/QA | 8h | 4.1-4.5 |

#### Week 8: i18n & Migration

| # | Tarefa | Owner | Duração | Dependencies |
|---|--------|-------|---------|--------------|
| 4.7 | Setup next-intl | Frontend | 4h | 1.1 |
| 4.8 | Translate pt-BR messages | Frontend | 8h | 4.7 |
| 4.9 | Translate en-US messages | Frontend | 8h | 4.7 |
| 4.10 | Data migration worker (localStorage → Supabase) | Backend | 12h | 2.3 |
| 4.11 | Beta user onboarding flow | Frontend | 8h | 4.1, 4.10 |
| 4.12 | Beta testing (50 users) | QA/PM | 40h | 4.1-4.11 |

**Deliverables**:
- ✅ UI completa multi-tenant
- ✅ Suporte pt-BR e en-US
- ✅ Data migration automática
- ✅ 50 beta users testando

**Exit Criteria**:
- [ ] Usuário pode trocar entre tenants
- [ ] Todas interfaces acessíveis (WCAG AA)
- [ ] i18n funcionando em todas pages
- [ ] 80%+ beta users satisfeitos (NPS > 8)

---

### Phase 5: Launch & Operations (Semana 9)

**Objetivos**: CI/CD, testing, documentação, go-live

| # | Tarefa | Owner | Duração | Dependencies |
|---|--------|-------|---------|--------------|
| 5.1 | CI/CD pipeline completo | DevOps | 8h | 1.7 |
| 5.2 | E2E test suite (Playwright) | QA | 16h | 4.1-4.11 |
| 5.3 | Load testing (1000 concurrent users) | DevOps | 8h | 5.1 |
| 5.4 | Atualizar documentação (ARCHITECTURE, API) | Tech Writer | 12h | Todas fases |
| 5.5 | LGPD compliance review | Legal | 8h | 1.13, 3.1-3.8 |
| 5.6 | Comunicação de go-live (email, blog) | Marketing | 8h | 5.4 |
| 5.7 | Go-live cutover (30min manutenção) | DevOps | 2h | 5.1-5.6 |
| 5.8 | Post-launch monitoring (24h war room) | Toda equipe | 24h | 5.7 |

**Deliverables**:
- ✅ CI/CD automático
- ✅ Testes E2E 100% passing
- ✅ Documentação atualizada
- ✅ v2.0 em produção

**Exit Criteria**:
- [ ] Deploy automático via GitHub Actions
- [ ] Load test suporta 1000 users simultâneos
- [ ] Documentação completa e revisada
- [ ] v2.0 live com <0.1% error rate

---

### Migration Cutover Plan

**Data**: TBD (após Week 8, beta testing completo)  
**Duração**: 30 minutos de manutenção programada  
**Horário**: Sábado, 02:00 AM BRT (baixo tráfego)

#### Checklist Pre-Cutover (T-24h)

- [ ] Backup completo de localStorage de todos usuários ativos
- [ ] Dry-run de data migration em staging
- [ ] Verificar PITR backup Supabase (última 24h)
- [ ] Comunicar usuários via email (48h antes)
- [ ] Banner de manutenção programada no app
- [ ] Rollback plan documentado e ensaiado
- [ ] War room Slack channel criado

#### Cutover Steps (30min)

| Tempo | Ação | Responsável | Rollback |
|-------|------|-------------|----------|
| T+0 | Banner "Em manutenção" | DevOps | N/A |
| T+1 | v1.0 em modo read-only | DevOps | Remove read-only flag |
| T+2 | Export localStorage de todos usuários | Backend | N/A (backup) |
| T+5 | Import para Supabase (bulk) | Backend | PITR restore |
| T+15 | Validação de integridade (checksums) | QA | - |
| T+18 | DNS switch para v2.0 | DevOps | DNS rollback |
| T+20 | Smoke tests (critical paths) | QA | DNS rollback |
| T+25 | Monitorar error rates | DevOps | - |
| T+30 | Remove banner, go-live | DevOps | Full rollback |

#### Post-Cutover (T+24h)

- [ ] Monitorar error rates (target: <0.1%)
- [ ] Validar performance (p95 <500ms)
- [ ] Check user feedback (support tickets, Twitter)
- [ ] Daily standups por 1 semana
- [ ] Post-mortem meeting (T+7 days)

---

### Rollback Plan

**Triggers para Rollback**:
1. Error rate >1% sustained por >5min
2. Data loss detectado
3. RLS policy breach
4. Degradação de performance >50%

**Rollback Steps** (15 minutos):

1. **Immediate**: DNS rollback para v1.0 (2min)
2. **Database**: PITR restore para T-1h (5min)
3. **Validation**: Smoke tests em v1.0 (5min)
4. **Communication**: Notificar usuários via email/banner (2min)
5. **Post-mortem**: Root cause analysis (1h após)

---

### Risk Register

| Risco | Impacto | Prob. | Mitigação | Owner |
|-------|---------|-------|-----------|-------|
| **Data loss durante migration** | 🔴 Critical | 🟡 Medium | PITR backups, dry-runs, validation | Backend Lead |
| **RLS policy leak** | 🔴 Critical | 🟢 Low | Extensive testing, security audit | Security |
| **Performance degradation** | 🟡 High | 🟡 Medium | Load testing, indexes, caching | DevOps |
| **User adoption baixa** | 🟡 High | 🟡 Medium | Beta program, UX research | PM |
| **Supabase downtime** | 🟡 High | 🟢 Low | SLA 99.9%, monitoring, alerts | DevOps |
| **Key rotation failure** | 🟡 High | 🟢 Low | Automated workflow, tests | DevOps |

---

## Tecnologias e Stack

### Frontend

```json
{
  "framework": "Next.js 14.2",
  "language": "TypeScript 5.8",
  "ui": "Shadcn/ui + Radix UI",
  "styling": "Tailwind CSS 3.x",
  "validation": "Zod 3.x",
  "i18n": "next-intl",
  "forms": "react-hook-form + zod resolver",
  "state": "Zustand (client), Server Components (server)"
}
```

### Backend

```json
{
  "runtime": "Next.js Edge Runtime",
  "database": "Supabase (PostgreSQL 15)",
  "auth": "Supabase Auth",
  "storage": "Supabase Storage",
  "realtime": "Supabase Realtime",
  "functions": "Supabase Edge Functions + Next.js Route Handlers"
}
```

### DevOps

```json
{
  "hosting": "Vercel (Serverless)",
  "ci_cd": "GitHub Actions",
  "monitoring": "Sentry + Logflare",
  "analytics": "Vercel Analytics",
  "testing": "Vitest + Playwright"
}
```

---

## Fases de Implementação

Ver [CHANGELOG.md](../CHANGELOG.md) e task list para detalhes de cada fase.

### Resumo

| Fase | Duração | Entregas | Status |
|------|---------|----------|--------|
| **0: Preparação** | 1 semana | Supabase setup, observability | 📋 Planejado |
| **1: Identity** | 2 semanas | Next.js, Supabase Auth, roles | 📋 Planejado |
| **2: Data Model** | 2 semanas | Schema, RLS, migration | 📋 Planejado |
| **3: Security** | 1 semana | Zero-trust, encryption, audit | 📋 Planejado |
| **4: Features** | 2 semanas | UI, i18n, worker | 📋 Planejado |
| **5: Launch** | 1 semana | CI/CD, testes, docs | 📋 Planejado |

**Total**: 9 semanas (~2 meses)

---

## Riscos e Mitigações

| Risco | Impacto | Probabilidade | Mitigação |
|-------|---------|---------------|-----------|
| **Data loss durante migração** | 🔴 Alto | 🟡 Médio | Backups automáticos, dry-run, rollback plan |
| **Performance degradation (RLS)** | 🟡 Médio | 🟢 Baixo | Índices otimizados, caching, query profiling |
| **Complexidade de RLS policies** | 🟡 Médio | 🟡 Médio | Testes de policies, documentação, code review |
| **LGPD non-compliance** | 🔴 Alto | 🟢 Baixo | Legal review, audit trail, portability features |
| **Auth provider downtime** | 🟡 Médio | 🟢 Baixo | Multiple providers, fallback to magic links |

---

## Referências

- [Supabase Multi-Tenancy Guide](https://supabase.com/docs/guides/database/postgres/row-level-security)
- [Next.js 14 Documentation](https://nextjs.org/docs)
- [LGPD - Lei Geral de Proteção de Dados](http://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/l13709.htm)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Shadcn/ui Components](https://ui.shadcn.com/)

---

[⬅ Voltar](./README.md) | [📘 Installation](./INSTALLATION.md) | [🏗️ Architecture](./ARCHITECTURE.md)
