-- Create core tables: tenants, profiles, tenant_members
-- Migration: 00003_create_core_tables
-- Created: 2025-10-30

-- ============================================
-- TENANTS (Organizations)
-- ============================================

CREATE TABLE tenants (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name varchar(255) NOT NULL,
  slug varchar(100) UNIQUE NOT NULL,
  settings jsonb DEFAULT '{}',
  subscription_tier subscription_tier DEFAULT 'free',
  subscription_expires_at timestamptz,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  
  CONSTRAINT tenants_slug_format CHECK (slug ~ '^[a-z0-9-]+$'),
  CONSTRAINT tenants_slug_length CHECK (char_length(slug) >= 3)
);

-- Indexes
CREATE INDEX idx_tenants_slug ON tenants(slug);
CREATE INDEX idx_tenants_subscription ON tenants(subscription_tier, subscription_expires_at);

-- Comments
COMMENT ON TABLE tenants IS 'Multi-tenant organizations (companies, schools, study groups)';
COMMENT ON COLUMN tenants.slug IS 'URL-friendly unique identifier';
COMMENT ON COLUMN tenants.settings IS 'Tenant-specific configuration (theme, locale, etc.)';

-- ============================================
-- PROFILES (User profiles extending auth.users)
-- ============================================

CREATE TABLE profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email varchar(255) NOT NULL,
  full_name varchar(255),
  avatar_url varchar(500),
  default_tenant_id uuid REFERENCES tenants(id) ON DELETE SET NULL,
  preferences jsonb DEFAULT '{"theme": "light", "locale": "pt-BR"}',
  onboarding_completed boolean DEFAULT false,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Indexes
CREATE INDEX idx_profiles_email ON profiles(email);
CREATE INDEX idx_profiles_default_tenant ON profiles(default_tenant_id);
CREATE INDEX idx_profiles_preferences ON profiles USING GIN (preferences);

-- Comments
COMMENT ON TABLE profiles IS 'User profile data extending Supabase Auth users';
COMMENT ON COLUMN profiles.preferences IS 'User preferences (theme, locale, notifications)';
COMMENT ON COLUMN profiles.onboarding_completed IS 'Whether user has completed onboarding flow';

-- ============================================
-- TENANT_MEMBERS (Many-to-many: users ↔ tenants)
-- ============================================

CREATE TABLE tenant_members (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  role user_role NOT NULL DEFAULT 'learner',
  invited_by uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  invited_at timestamptz DEFAULT now(),
  accepted_at timestamptz,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  
  UNIQUE(tenant_id, user_id)
);

-- Indexes
CREATE INDEX idx_tenant_members_tenant ON tenant_members(tenant_id);
CREATE INDEX idx_tenant_members_user ON tenant_members(user_id);
CREATE INDEX idx_tenant_members_role ON tenant_members(role);
CREATE INDEX idx_tenant_members_accepted ON tenant_members(accepted_at) WHERE accepted_at IS NOT NULL;

-- Comments
COMMENT ON TABLE tenant_members IS 'User membership in tenants with roles';
COMMENT ON COLUMN tenant_members.role IS 'User role: admin, instructor, or learner';
COMMENT ON COLUMN tenant_members.accepted_at IS 'When user accepted the invitation (NULL = pending)';

-- ============================================
-- UPDATED_AT TRIGGERS
-- ============================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply triggers
CREATE TRIGGER update_tenants_updated_at BEFORE UPDATE ON tenants
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_tenant_members_updated_at BEFORE UPDATE ON tenant_members
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
