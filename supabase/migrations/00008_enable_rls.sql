-- Enable Row Level Security on all tables
-- Migration: 00008_enable_rls
-- Created: 2025-10-30

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
ALTER TABLE user_consents ENABLE ROW LEVEL SECURITY;
ALTER TABLE data_requests ENABLE ROW LEVEL SECURITY;

-- Comments
COMMENT ON TABLE tenants IS 'RLS enabled - users see only their tenants';
COMMENT ON TABLE profiles IS 'RLS enabled - users see only their profile';
COMMENT ON TABLE tenant_members IS 'RLS enabled - users see members of their tenants';
COMMENT ON TABLE subjects IS 'RLS enabled - global or tenant-scoped';
COMMENT ON TABLE progress IS 'RLS enabled - users see only their progress or as admin';
COMMENT ON TABLE audit_log IS 'RLS enabled - admins only';
