-- Create edital structure tables: subjects, topics, subtopics
-- Migration: 00004_create_edital_tables
-- Created: 2025-10-30

-- ============================================
-- SUBJECTS (Matérias)
-- ============================================

CREATE TABLE subjects (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid REFERENCES tenants(id) ON DELETE CASCADE,
  external_id varchar(50) NOT NULL,
  name varchar(255) NOT NULL,
  slug varchar(100) NOT NULL,
  type varchar(50) NOT NULL,
  order_index int NOT NULL,
  is_custom boolean DEFAULT false,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  
  UNIQUE(tenant_id, external_id)
);

-- Indexes
CREATE INDEX idx_subjects_tenant ON subjects(tenant_id);
CREATE INDEX idx_subjects_type ON subjects(type);
CREATE INDEX idx_subjects_order ON subjects(order_index);
CREATE INDEX idx_subjects_custom ON subjects(is_custom) WHERE is_custom = true;

-- Comments
COMMENT ON TABLE subjects IS 'Study subjects/disciplines from TCU edital';
COMMENT ON COLUMN subjects.tenant_id IS 'NULL for global/seed data, tenant_id for custom subjects';
COMMENT ON COLUMN subjects.external_id IS 'Original ID from edital (e.g., CON-0, CON-1)';
COMMENT ON COLUMN subjects.is_custom IS 'True if created by tenant, false if seed data';

-- ============================================
-- TOPICS (Tópicos)
-- ============================================

CREATE TABLE topics (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_id uuid NOT NULL REFERENCES subjects(id) ON DELETE CASCADE,
  external_id varchar(50) NOT NULL,
  title text NOT NULL,
  order_index int NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Indexes
CREATE INDEX idx_topics_subject ON topics(subject_id);
CREATE INDEX idx_topics_order ON topics(order_index);

-- Comments
COMMENT ON TABLE topics IS 'Main topics within subjects';
COMMENT ON COLUMN topics.external_id IS 'Original ID from edital (e.g., CON-0-1)';

-- ============================================
-- SUBTOPICS (Subtópicos - hierárquico)
-- ============================================

CREATE TABLE subtopics (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  topic_id uuid NOT NULL REFERENCES topics(id) ON DELETE CASCADE,
  parent_id uuid REFERENCES subtopics(id) ON DELETE CASCADE,
  external_id varchar(50) NOT NULL,
  title text NOT NULL,
  level int NOT NULL DEFAULT 1,
  order_index int NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  
  CONSTRAINT subtopics_level_check CHECK (level BETWEEN 1 AND 3)
);

-- Indexes
CREATE INDEX idx_subtopics_topic ON subtopics(topic_id);
CREATE INDEX idx_subtopics_parent ON subtopics(parent_id);
CREATE INDEX idx_subtopics_level ON subtopics(level);
CREATE INDEX idx_subtopics_order ON subtopics(order_index);

-- Comments
COMMENT ON TABLE subtopics IS 'Hierarchical subtopics (up to 3 levels deep)';
COMMENT ON COLUMN subtopics.parent_id IS 'Parent subtopic for nested hierarchy (NULL for top-level)';
COMMENT ON COLUMN subtopics.level IS 'Depth in hierarchy (1, 2, or 3)';
COMMENT ON COLUMN subtopics.external_id IS 'Original ID from edital (e.g., CON-0-1.1)';

-- Triggers
CREATE TRIGGER update_subjects_updated_at BEFORE UPDATE ON subjects
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_topics_updated_at BEFORE UPDATE ON topics
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_subtopics_updated_at BEFORE UPDATE ON subtopics
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
