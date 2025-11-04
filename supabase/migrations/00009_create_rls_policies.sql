-- Create Row Level Security policies
-- Migration: 00009_create_rls_policies
-- Created: 2025-10-30

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
  USING (id = auth.uid())
  WITH CHECK (id = auth.uid());

-- ============================================
-- POLICIES: TENANTS
-- ============================================

-- Users can view tenants they belong to
CREATE POLICY "Users can view their tenants"
  ON tenants FOR SELECT
  USING (
    id IN (SELECT get_user_tenants())
  );

-- Only admins can create tenants (via backend)
-- No direct INSERT policy - must go through backend function

-- Admins can update their tenant
CREATE POLICY "Admins can update their tenant"
  ON tenants FOR UPDATE
  USING (is_tenant_admin(id))
  WITH CHECK (is_tenant_admin(id));

-- ============================================
-- POLICIES: TENANT_MEMBERS
-- ============================================

-- Users can view members of their tenants
CREATE POLICY "Users can view tenant members"
  ON tenant_members FOR SELECT
  USING (
    tenant_id IN (SELECT get_user_tenants())
  );

-- Admins can manage all members
CREATE POLICY "Admins can manage all members"
  ON tenant_members FOR ALL
  USING (is_tenant_admin(tenant_id))
  WITH CHECK (is_tenant_admin(tenant_id));

-- Instructors can invite learners
CREATE POLICY "Instructors can invite learners"
  ON tenant_members FOR INSERT
  WITH CHECK (
    get_user_role(tenant_id) = 'instructor'
    AND role = 'learner'
  );

-- ============================================
-- POLICIES: SUBJECTS (Global seed data)
-- ============================================

-- All authenticated users can view subjects
CREATE POLICY "Users can view subjects"
  ON subjects FOR SELECT
  USING (
    -- Global subjects (tenant_id IS NULL)
    tenant_id IS NULL
    -- OR custom subjects for their tenant
    OR is_tenant_member(tenant_id)
  );

-- Only admins can create custom subjects for their tenant
CREATE POLICY "Admins can create custom subjects"
  ON subjects FOR INSERT
  WITH CHECK (
    is_tenant_admin(tenant_id)
    AND is_custom = true
  );

-- ============================================
-- POLICIES: TOPICS & SUBTOPICS
-- ============================================

-- Users can view topics of accessible subjects
CREATE POLICY "Users can view topics"
  ON topics FOR SELECT
  USING (
    subject_id IN (
      SELECT id FROM subjects 
      WHERE tenant_id IS NULL 
         OR is_tenant_member(tenant_id)
    )
  );

-- Users can view subtopics of accessible topics
CREATE POLICY "Users can view subtopics"
  ON subtopics FOR SELECT
  USING (
    topic_id IN (
      SELECT t.id FROM topics t
      JOIN subjects s ON t.subject_id = s.id
      WHERE s.tenant_id IS NULL 
         OR is_tenant_member(s.tenant_id)
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
    AND is_tenant_member(tenant_id)
  );

-- Admins and instructors can view all progress in their tenant
CREATE POLICY "Admins and instructors can view all progress"
  ON progress FOR SELECT
  USING (
    get_user_role(tenant_id) IN ('admin', 'instructor')
  );

-- Users can insert their own progress
CREATE POLICY "Users can insert own progress"
  ON progress FOR INSERT
  WITH CHECK (
    user_id = auth.uid()
    AND is_tenant_member(tenant_id)
    AND tenant_id = current_setting('app.current_tenant', true)::uuid
  );

-- Users can update their own progress
CREATE POLICY "Users can update own progress"
  ON progress FOR UPDATE
  USING (user_id = auth.uid() AND is_tenant_member(tenant_id))
  WITH CHECK (user_id = auth.uid() AND is_tenant_member(tenant_id));

-- Users can delete their own progress
CREATE POLICY "Users can delete own progress"
  ON progress FOR DELETE
  USING (user_id = auth.uid() AND is_tenant_member(tenant_id));

-- ============================================
-- POLICIES: STUDY_PLANS
-- ============================================

-- Users can manage their own study plans
CREATE POLICY "Users can view own study plans"
  ON study_plans FOR SELECT
  USING (user_id = auth.uid() AND is_tenant_member(tenant_id));

CREATE POLICY "Users can insert own study plans"
  ON study_plans FOR INSERT
  WITH CHECK (
    user_id = auth.uid()
    AND is_tenant_member(tenant_id)
  );

CREATE POLICY "Users can update own study plans"
  ON study_plans FOR UPDATE
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can delete own study plans"
  ON study_plans FOR DELETE
  USING (user_id = auth.uid());

-- Admins and instructors can view all study plans
CREATE POLICY "Admins and instructors can view all study plans"
  ON study_plans FOR SELECT
  USING (get_user_role(tenant_id) IN ('admin', 'instructor'));

-- ============================================
-- POLICIES: STUDY_SESSIONS
-- ============================================

-- Users can manage their own study sessions
CREATE POLICY "Users can view own study sessions"
  ON study_sessions FOR SELECT
  USING (user_id = auth.uid() AND is_tenant_member(tenant_id));

CREATE POLICY "Users can insert own study sessions"
  ON study_sessions FOR INSERT
  WITH CHECK (user_id = auth.uid() AND is_tenant_member(tenant_id));

CREATE POLICY "Users can update own study sessions"
  ON study_sessions FOR UPDATE
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

-- ============================================
-- POLICIES: AUDIT_LOG
-- ============================================

-- Only admins can view audit logs for their tenant
CREATE POLICY "Admins can view audit logs"
  ON audit_log FOR SELECT
  USING (is_tenant_admin(tenant_id));

-- System can insert audit logs (via SECURITY DEFINER functions)
-- No direct INSERT policy - audit logs are created via functions only

-- ============================================
-- POLICIES: USER_CONSENTS
-- ============================================

-- Users can view their own consents
CREATE POLICY "Users can view own consents"
  ON user_consents FOR SELECT
  USING (user_id = auth.uid());

-- Users can insert their own consents
CREATE POLICY "Users can grant consents"
  ON user_consents FOR INSERT
  WITH CHECK (user_id = auth.uid());

-- Users can revoke their own consents (update revoked_at)
CREATE POLICY "Users can revoke consents"
  ON user_consents FOR UPDATE
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

-- ============================================
-- POLICIES: DATA_REQUESTS
-- ============================================

-- Users can view their own data requests
CREATE POLICY "Users can view own data requests"
  ON data_requests FOR SELECT
  USING (user_id = auth.uid());

-- Users can create their own data requests
CREATE POLICY "Users can create data requests"
  ON data_requests FOR INSERT
  WITH CHECK (user_id = auth.uid());

-- System can update data requests (via backend)
-- No UPDATE policy - updates happen via backend functions only
