-- =====================================================
-- TCU Dashboard - Supabase Schema
-- =====================================================
-- Execute este arquivo no SQL Editor do Supabase Dashboard
-- https://supabase.com/dashboard/project/imwohmhgzamdahfiahdk/editor
-- =====================================================

-- Criar tabela de progresso
CREATE TABLE IF NOT EXISTS progress (
  id BIGSERIAL PRIMARY KEY,
  item_id TEXT UNIQUE NOT NULL,
  completed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Criar índices para melhor performance
CREATE INDEX IF NOT EXISTS idx_progress_item_id ON progress(item_id);
CREATE INDEX IF NOT EXISTS idx_progress_completed_at ON progress(completed_at);

-- Adicionar comentários para documentação
COMMENT ON TABLE progress IS 'Armazena o progresso de estudo dos tópicos do edital TCU';
COMMENT ON COLUMN progress.item_id IS 'ID único do tópico (ex: "1.2.3")';
COMMENT ON COLUMN progress.completed_at IS 'Data e hora em que o tópico foi marcado como concluído';

-- =====================================================
-- Tabela opcional: Sessões de Estudo (FUTURO)
-- =====================================================
-- Descomente abaixo se quiser rastrear horas de estudo

/*
CREATE TABLE IF NOT EXISTS study_sessions (
  id BIGSERIAL PRIMARY KEY,
  study_date DATE NOT NULL,
  hours_studied DECIMAL(4,2) CHECK (hours_studied >= 0 AND hours_studied <= 24),
  topics_completed INTEGER DEFAULT 0,
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_study_sessions_date ON study_sessions(study_date);

COMMENT ON TABLE study_sessions IS 'Registro diário de sessões de estudo';
COMMENT ON COLUMN study_sessions.hours_studied IS 'Horas estudadas no dia (0.00 a 24.00)';
*/

-- =====================================================
-- Políticas de Segurança (RLS - Row Level Security)
-- =====================================================
-- Como é um dashboard pessoal, vamos desabilitar RLS
-- Se quiser adicionar autenticação no futuro, habilite RLS

ALTER TABLE progress DISABLE ROW LEVEL SECURITY;

-- Para habilitar RLS no futuro (com autenticação):
/*
ALTER TABLE progress ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Usuários podem ver seu próprio progresso"
  ON progress FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Usuários podem inserir seu próprio progresso"
  ON progress FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Usuários podem deletar seu próprio progresso"
  ON progress FOR DELETE
  USING (auth.uid() = user_id);
*/

-- =====================================================
-- Dados de Teste (Opcional - Descomente para testar)
-- =====================================================
/*
INSERT INTO progress (item_id) VALUES
  ('1.1.1'),
  ('1.1.2'),
  ('2.3.4')
ON CONFLICT (item_id) DO NOTHING;

SELECT * FROM progress ORDER BY completed_at DESC;
*/

-- =====================================================
-- Queries Úteis para Monitoramento
-- =====================================================

-- Ver todos os tópicos concluídos
-- SELECT item_id, completed_at FROM progress ORDER BY completed_at DESC;

-- Contar total de tópicos concluídos
-- SELECT COUNT(*) as total_concluido FROM progress;

-- Tópicos concluídos hoje
-- SELECT COUNT(*) FROM progress WHERE completed_at::date = CURRENT_DATE;

-- Tópicos concluídos nos últimos 7 dias
-- SELECT DATE(completed_at) as dia, COUNT(*) as total
-- FROM progress
-- WHERE completed_at >= NOW() - INTERVAL '7 days'
-- GROUP BY DATE(completed_at)
-- ORDER BY dia DESC;
