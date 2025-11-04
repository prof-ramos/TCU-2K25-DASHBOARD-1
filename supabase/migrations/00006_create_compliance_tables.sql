-- Create LGPD compliance tables: audit_log, user_consents, data_requests
-- Migration: 00006_create_compliance_tables
-- Created: 2025-10-30

-- ============================================
-- AUDIT LOG (Immutable)
-- ============================================

CREATE TABLE audit_log (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid REFERENCES tenants(id) ON DELETE SET NULL,
  user_id uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  action varchar(100) NOT NULL,
  resource_type varchar(50),
  resource_id uuid,
  old_values jsonb,
  new_values jsonb,
  ip_address inet,
  user_agent text,
  timestamp timestamptz DEFAULT now()
);

-- Indexes
CREATE INDEX idx_audit_log_tenant ON audit_log(tenant_id);
CREATE INDEX idx_audit_log_user ON audit_log(user_id);
CREATE INDEX idx_audit_log_timestamp ON audit_log(timestamp DESC);
CREATE INDEX idx_audit_log_action ON audit_log(action);
CREATE INDEX idx_audit_log_resource ON audit_log(resource_type, resource_id);

-- Prevent modifications (immutable)
CREATE RULE audit_log_no_delete AS ON DELETE TO audit_log DO INSTEAD NOTHING;
CREATE RULE audit_log_no_update AS ON UPDATE TO audit_log DO INSTEAD NOTHING;

-- Comments
COMMENT ON TABLE audit_log IS 'Immutable audit trail of all system actions';
COMMENT ON COLUMN audit_log.action IS 'Action type (e.g., user.login, progress.update)';
COMMENT ON COLUMN audit_log.old_values IS 'JSON snapshot of data before change';
COMMENT ON COLUMN audit_log.new_values IS 'JSON snapshot of data after change';

-- ============================================
-- USER CONSENTS (LGPD)
-- ============================================

CREATE TABLE user_consents (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  consent_type consent_type NOT NULL,
  version varchar(20) NOT NULL,
  granted_at timestamptz DEFAULT now(),
  revoked_at timestamptz,
  ip_address inet,
  user_agent text,
  
  CONSTRAINT user_consents_revoked_after_granted 
    CHECK (revoked_at IS NULL OR revoked_at > granted_at)
);

-- Indexes
CREATE INDEX idx_user_consents_user ON user_consents(user_id);
CREATE INDEX idx_user_consents_type ON user_consents(consent_type);
CREATE INDEX idx_user_consents_granted ON user_consents(granted_at DESC);
CREATE INDEX idx_user_consents_active ON user_consents(user_id, consent_type) 
  WHERE revoked_at IS NULL;

-- Comments
COMMENT ON TABLE user_consents IS 'User consent tracking for LGPD compliance';
COMMENT ON COLUMN user_consents.version IS 'Version of terms/privacy policy';
COMMENT ON COLUMN user_consents.revoked_at IS 'When consent was revoked (NULL = active)';

-- ============================================
-- DATA REQUESTS (LGPD - Portability & Deletion)
-- ============================================

CREATE TABLE data_requests (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id),
  request_type data_request_type NOT NULL,
  status data_request_status DEFAULT 'pending',
  requested_at timestamptz DEFAULT now(),
  completed_at timestamptz,
  data_url text,
  expires_at timestamptz,
  error_message text,
  
  CONSTRAINT data_requests_completed_after_requested 
    CHECK (completed_at IS NULL OR completed_at >= requested_at),
  CONSTRAINT data_requests_export_has_url 
    CHECK (request_type != 'export' OR status != 'completed' OR data_url IS NOT NULL)
);

-- Indexes
CREATE INDEX idx_data_requests_user ON data_requests(user_id);
CREATE INDEX idx_data_requests_status ON data_requests(status);
CREATE INDEX idx_data_requests_requested_at ON data_requests(requested_at DESC);
CREATE INDEX idx_data_requests_expires ON data_requests(expires_at) 
  WHERE expires_at IS NOT NULL;

-- Comments
COMMENT ON TABLE data_requests IS 'LGPD data portability and deletion requests';
COMMENT ON COLUMN data_requests.data_url IS 'Signed URL for data export download';
COMMENT ON COLUMN data_requests.expires_at IS 'When the export URL expires (typically 7 days)';

-- ============================================
-- HELPER FUNCTIONS
-- ============================================

-- Function to log audit events
CREATE OR REPLACE FUNCTION log_audit_event(
  p_action varchar,
  p_resource_type varchar DEFAULT NULL,
  p_resource_id uuid DEFAULT NULL,
  p_old_values jsonb DEFAULT NULL,
  p_new_values jsonb DEFAULT NULL
)
RETURNS uuid AS $$
DECLARE
  v_audit_id uuid;
BEGIN
  INSERT INTO audit_log (
    tenant_id,
    user_id,
    action,
    resource_type,
    resource_id,
    old_values,
    new_values,
    ip_address,
    user_agent
  ) VALUES (
    current_setting('app.current_tenant', true)::uuid,
    auth.uid(),
    p_action,
    p_resource_type,
    p_resource_id,
    p_old_values,
    p_new_values,
    inet_client_addr(),
    current_setting('request.headers', true)::json->>'user-agent'
  ) RETURNING id INTO v_audit_id;
  
  RETURN v_audit_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION log_audit_event IS 'Helper function to create audit log entries';

-- Function to check active consent
CREATE OR REPLACE FUNCTION has_active_consent(
  p_user_id uuid,
  p_consent_type consent_type
)
RETURNS boolean AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM user_consents
    WHERE user_id = p_user_id
      AND consent_type = p_consent_type
      AND revoked_at IS NULL
  );
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

COMMENT ON FUNCTION has_active_consent IS 'Check if user has active consent of given type';
