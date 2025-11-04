-- =====================================================
-- TCU Dashboard - Schema do Edital
-- =====================================================
-- Execute este arquivo no SQL Editor do Supabase Dashboard
-- para criar as tabelas que armazenarão o conteúdo do edital
-- =====================================================

-- Tabela de Matérias (disciplinas do concurso)
CREATE TABLE IF NOT EXISTS materias (
  id TEXT PRIMARY KEY,
  slug TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('CONHECIMENTOS GERAIS', 'CONHECIMENTOS ESPECÍFICOS')),
  ordem INTEGER NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabela de Tópicos (tópicos principais de cada matéria)
CREATE TABLE IF NOT EXISTS topics (
  id TEXT PRIMARY KEY,
  materia_id TEXT NOT NULL REFERENCES materias(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  ordem INTEGER NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabela de Subtópicos (subtópicos hierárquicos)
-- Suporta múltiplos níveis de hierarquia através de parent_id
CREATE TABLE IF NOT EXISTS subtopics (
  id TEXT PRIMARY KEY,
  topic_id TEXT REFERENCES topics(id) ON DELETE CASCADE,
  parent_id TEXT REFERENCES subtopics(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  ordem INTEGER NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CHECK (topic_id IS NOT NULL OR parent_id IS NOT NULL),
  CHECK (NOT (topic_id IS NOT NULL AND parent_id IS NOT NULL))
);

-- Índices para melhor performance
CREATE INDEX IF NOT EXISTS idx_topics_materia ON topics(materia_id);
CREATE INDEX IF NOT EXISTS idx_subtopics_topic ON subtopics(topic_id);
CREATE INDEX IF NOT EXISTS idx_subtopics_parent ON subtopics(parent_id);
CREATE INDEX IF NOT EXISTS idx_materias_type ON materias(type);
CREATE INDEX IF NOT EXISTS idx_materias_ordem ON materias(ordem);
CREATE INDEX IF NOT EXISTS idx_topics_ordem ON topics(ordem);
CREATE INDEX IF NOT EXISTS idx_subtopics_ordem ON subtopics(ordem);

-- Comentários para documentação
COMMENT ON TABLE materias IS 'Matérias/disciplinas do edital TCU TI';
COMMENT ON TABLE topics IS 'Tópicos principais de cada matéria';
COMMENT ON TABLE subtopics IS 'Subtópicos hierárquicos (podem ter múltiplos níveis)';

COMMENT ON COLUMN materias.slug IS 'Identificador único em formato URL (ex: lingua-portuguesa)';
COMMENT ON COLUMN materias.type IS 'Tipo da matéria: CONHECIMENTOS GERAIS ou CONHECIMENTOS ESPECÍFICOS';
COMMENT ON COLUMN materias.ordem IS 'Ordem de apresentação da matéria';
COMMENT ON COLUMN topics.materia_id IS 'ID da matéria à qual este tópico pertence';
COMMENT ON COLUMN subtopics.topic_id IS 'ID do tópico pai (se for subtópico de 1º nível)';
COMMENT ON COLUMN subtopics.parent_id IS 'ID do subtópico pai (se for subtópico de 2º+ nível)';

-- Desabilitar Row Level Security (dashboard pessoal)
ALTER TABLE materias DISABLE ROW LEVEL SECURITY;
ALTER TABLE topics DISABLE ROW LEVEL SECURITY;
ALTER TABLE subtopics DISABLE ROW LEVEL SECURITY;

-- =====================================================
-- View para facilitar consultas do edital completo
-- =====================================================
CREATE OR REPLACE VIEW edital_completo AS
SELECT 
  m.id as materia_id,
  m.slug as materia_slug,
  m.name as materia_name,
  m.type as materia_type,
  m.ordem as materia_ordem,
  t.id as topic_id,
  t.title as topic_title,
  t.ordem as topic_ordem,
  s.id as subtopic_id,
  s.title as subtopic_title,
  s.ordem as subtopic_ordem,
  s.parent_id as subtopic_parent_id
FROM materias m
LEFT JOIN topics t ON m.id = t.materia_id
LEFT JOIN subtopics s ON t.id = s.topic_id
ORDER BY m.ordem, t.ordem, s.ordem;

COMMENT ON VIEW edital_completo IS 'View que une todas as tabelas do edital para facilitar consultas';
