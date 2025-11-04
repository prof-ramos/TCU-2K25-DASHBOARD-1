-- Create user data tables: study_plans, progress, study_sessions
-- Migration: 00005_create_user_data_tables
-- Created: 2025-10-30

-- ============================================
-- STUDY PLANS
-- ============================================

CREATE TABLE study_plans (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name varchar(255) NOT NULL,
  description text,
  target_date date,
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Indexes
CREATE INDEX idx_study_plans_tenant_user ON study_plans(tenant_id, user_id);
CREATE INDEX idx_study_plans_active ON study_plans(is_active) WHERE is_active = true;
CREATE INDEX idx_study_plans_target_date ON study_plans(target_date) WHERE target_date IS NOT NULL;

-- Comments
COMMENT ON TABLE study_plans IS 'User-defined study plans with target dates';
COMMENT ON COLUMN study_plans.is_active IS 'Only one active plan per user recommended';

-- ============================================
-- PROGRESS (User study progress)
-- ============================================

CREATE TABLE progress (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  subtopic_id uuid NOT NULL REFERENCES subtopics(id) ON DELETE CASCADE,
  completed_at timestamptz DEFAULT now(),
  notes text,
  confidence_level int,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  
  UNIQUE(tenant_id, user_id, subtopic_id),
  CONSTRAINT progress_confidence_check CHECK (confidence_level BETWEEN 1 AND 5)
);

-- Indexes
CREATE INDEX idx_progress_tenant_user ON progress(tenant_id, user_id);
CREATE INDEX idx_progress_subtopic ON progress(subtopic_id);
CREATE INDEX idx_progress_completed_at ON progress(completed_at DESC);
CREATE INDEX idx_progress_confidence ON progress(confidence_level) WHERE confidence_level IS NOT NULL;

-- Composite index for common queries
CREATE INDEX idx_progress_tenant_user_completed 
  ON progress(tenant_id, user_id, completed_at DESC)
  WHERE completed_at IS NOT NULL;

-- Covering index for statistics
CREATE INDEX idx_progress_tenant_subtopic 
  ON progress(tenant_id, subtopic_id)
  INCLUDE (completed_at, confidence_level);

-- Comments
COMMENT ON TABLE progress IS 'User progress tracking for subtopics';
COMMENT ON COLUMN progress.confidence_level IS 'Self-assessed confidence (1-5 scale)';
COMMENT ON COLUMN progress.notes IS 'User notes about the subtopic';

-- ============================================
-- STUDY SESSIONS (Analytics)
-- ============================================

CREATE TABLE study_sessions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  started_at timestamptz DEFAULT now(),
  ended_at timestamptz,
  duration_seconds int GENERATED ALWAYS AS (
    EXTRACT(EPOCH FROM (ended_at - started_at))::int
  ) STORED,
  subjects_studied uuid[],
  created_at timestamptz DEFAULT now()
);

-- Indexes
CREATE INDEX idx_study_sessions_tenant_user ON study_sessions(tenant_id, user_id);
CREATE INDEX idx_study_sessions_started_at ON study_sessions(started_at DESC);
CREATE INDEX idx_study_sessions_duration ON study_sessions(duration_seconds DESC NULLS LAST);

-- Comments
COMMENT ON TABLE study_sessions IS 'Study session tracking for analytics';
COMMENT ON COLUMN study_sessions.duration_seconds IS 'Computed duration in seconds';
COMMENT ON COLUMN study_sessions.subjects_studied IS 'Array of subject UUIDs studied in this session';

-- ============================================
-- MATERIALIZED VIEW: Progress Statistics
-- ============================================

CREATE MATERIALIZED VIEW tenant_progress_stats AS
SELECT 
  p.tenant_id,
  p.user_id,
  COUNT(DISTINCT p.subtopic_id) as completed_subtopics,
  COUNT(DISTINCT t.subject_id) as subjects_touched,
  AVG(p.confidence_level) as avg_confidence,
  MAX(p.completed_at) as last_study_date,
  MIN(p.completed_at) as first_study_date,
  COUNT(*) as total_progress_entries
FROM progress p
JOIN subtopics st ON p.subtopic_id = st.id
JOIN topics t ON st.topic_id = t.id
GROUP BY p.tenant_id, p.user_id;

-- Index on materialized view
CREATE UNIQUE INDEX idx_progress_stats_tenant_user 
  ON tenant_progress_stats(tenant_id, user_id);

-- Comments
COMMENT ON MATERIALIZED VIEW tenant_progress_stats IS 'Aggregated progress statistics per user';

-- Refresh function
CREATE OR REPLACE FUNCTION refresh_progress_stats()
RETURNS void AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY tenant_progress_stats;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Triggers
CREATE TRIGGER update_study_plans_updated_at BEFORE UPDATE ON study_plans
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_progress_updated_at BEFORE UPDATE ON progress
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
