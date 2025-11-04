-- Create RLS helper functions
-- Migration: 00007_create_rls_helper_functions
-- Created: 2025-10-30

-- ============================================
-- TENANT CONTEXT HELPERS
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

COMMENT ON FUNCTION get_user_role IS 'Get current user role in specified tenant';

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

COMMENT ON FUNCTION is_tenant_admin IS 'Check if current user is admin in tenant';

-- Check if user is member of tenant
CREATE OR REPLACE FUNCTION is_tenant_member(p_tenant_id uuid)
RETURNS boolean AS $$
  SELECT EXISTS (
    SELECT 1 FROM tenant_members
    WHERE tenant_id = p_tenant_id
      AND user_id = auth.uid()
      AND accepted_at IS NOT NULL
  );
$$ LANGUAGE sql STABLE SECURITY DEFINER;

COMMENT ON FUNCTION is_tenant_member IS 'Check if current user is member of tenant';

-- Get user's tenant IDs
CREATE OR REPLACE FUNCTION get_user_tenants()
RETURNS SETOF uuid AS $$
  SELECT tenant_id FROM tenant_members
  WHERE user_id = auth.uid()
    AND accepted_at IS NOT NULL;
$$ LANGUAGE sql STABLE SECURITY DEFINER;

COMMENT ON FUNCTION get_user_tenants IS 'Get all tenant IDs where user is a member';

-- ============================================
-- PROFILE SYNC ON USER CREATION
-- ============================================

-- Automatically create profile when user signs up
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO profiles (id, email, full_name, avatar_url)
  VALUES (
    NEW.id,
    NEW.email,
    NEW.raw_user_meta_data->>'full_name',
    NEW.raw_user_meta_data->>'avatar_url'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger on auth.users insert
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();

COMMENT ON FUNCTION handle_new_user IS 'Auto-create profile on user signup';

-- ============================================
-- DATA EXPORT FUNCTION (LGPD)
-- ============================================

-- Export all user data for LGPD portability
CREATE OR REPLACE FUNCTION export_user_data(p_user_id uuid)
RETURNS jsonb AS $$
DECLARE
  result jsonb;
BEGIN
  -- Verify user can only export their own data
  IF p_user_id != auth.uid() THEN
    RAISE EXCEPTION 'Unauthorized: can only export own data';
  END IF;

  SELECT jsonb_build_object(
    'profile', (SELECT row_to_json(p.*) FROM profiles p WHERE id = p_user_id),
    'tenant_memberships', (
      SELECT jsonb_agg(row_to_json(tm.*)) 
      FROM tenant_members tm 
      WHERE user_id = p_user_id
    ),
    'progress', (
      SELECT jsonb_agg(row_to_json(pr.*)) 
      FROM progress pr 
      WHERE user_id = p_user_id
    ),
    'study_plans', (
      SELECT jsonb_agg(row_to_json(sp.*)) 
      FROM study_plans sp 
      WHERE user_id = p_user_id
    ),
    'study_sessions', (
      SELECT jsonb_agg(row_to_json(ss.*)) 
      FROM study_sessions ss 
      WHERE user_id = p_user_id
    ),
    'consents', (
      SELECT jsonb_agg(row_to_json(c.*)) 
      FROM user_consents c 
      WHERE user_id = p_user_id
    ),
    'exported_at', now()
  ) INTO result;
  
  -- Log export request
  PERFORM log_audit_event('data.exported', 'user', p_user_id);
  
  RETURN result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION export_user_data IS 'Export all user data for LGPD portability (user can only export own data)';

-- ============================================
-- SOFT DELETE USER DATA (LGPD)
-- ============================================

-- Anonymize user data for soft delete
CREATE OR REPLACE FUNCTION anonymize_user_data(p_user_id uuid)
RETURNS boolean AS $$
BEGIN
  -- Verify user can only delete their own data
  IF p_user_id != auth.uid() THEN
    RAISE EXCEPTION 'Unauthorized: can only delete own data';
  END IF;

  -- Anonymize profile
  UPDATE profiles SET
    email = 'deleted-' || id || '@anonymized.local',
    full_name = 'Deleted User',
    avatar_url = NULL,
    preferences = '{}',
    updated_at = now()
  WHERE id = p_user_id;

  -- Delete progress (keep for statistics, but dissociate from user)
  -- Or DELETE if required by policy
  DELETE FROM progress WHERE user_id = p_user_id;
  DELETE FROM study_plans WHERE user_id = p_user_id;
  DELETE FROM study_sessions WHERE user_id = p_user_id;
  
  -- Revoke all consents
  UPDATE user_consents SET
    revoked_at = now()
  WHERE user_id = p_user_id AND revoked_at IS NULL;
  
  -- Log deletion
  PERFORM log_audit_event('data.deleted', 'user', p_user_id);
  
  RETURN true;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION anonymize_user_data IS 'Anonymize user data for LGPD right to erasure';

-- ============================================
-- AUDIT TRIGGERS
-- ============================================

-- Function to automatically log changes to important tables
CREATE OR REPLACE FUNCTION audit_table_changes()
RETURNS trigger AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    PERFORM log_audit_event(
      TG_TABLE_NAME || '.deleted',
      TG_TABLE_NAME,
      OLD.id,
      row_to_json(OLD)::jsonb,
      NULL
    );
    RETURN OLD;
  ELSIF TG_OP = 'UPDATE' THEN
    PERFORM log_audit_event(
      TG_TABLE_NAME || '.updated',
      TG_TABLE_NAME,
      NEW.id,
      row_to_json(OLD)::jsonb,
      row_to_json(NEW)::jsonb
    );
    RETURN NEW;
  ELSIF TG_OP = 'INSERT' THEN
    PERFORM log_audit_event(
      TG_TABLE_NAME || '.created',
      TG_TABLE_NAME,
      NEW.id,
      NULL,
      row_to_json(NEW)::jsonb
    );
    RETURN NEW;
  END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Apply audit triggers to sensitive tables
CREATE TRIGGER audit_tenants_changes
  AFTER INSERT OR UPDATE OR DELETE ON tenants
  FOR EACH ROW EXECUTE FUNCTION audit_table_changes();

CREATE TRIGGER audit_tenant_members_changes
  AFTER INSERT OR UPDATE OR DELETE ON tenant_members
  FOR EACH ROW EXECUTE FUNCTION audit_table_changes();

CREATE TRIGGER audit_progress_changes
  AFTER INSERT OR UPDATE OR DELETE ON progress
  FOR EACH ROW EXECUTE FUNCTION audit_table_changes();
