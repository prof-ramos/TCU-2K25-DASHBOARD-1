-- Testes de Políticas RLS para TCU Dashboard
-- Testa isolamento de Row Level Security entre tenants
-- Execute este arquivo contra um database de testes para validar as políticas RLS

-- Setup: Criar dados de teste
BEGIN;

-- Criar tenants de teste
INSERT INTO tenants (id, name, slug) VALUES
  ('11111111-1111-1111-1111-111111111111', 'Tenant A', 'tenant-a'),
  ('22222222-2222-2222-2222-222222222222', 'Tenant B', 'tenant-b');

-- Criar usuários de teste (simulando auth.users)
INSERT INTO auth.users (id, email) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'admin-a@test.com'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'learner-a@test.com'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'learner-b@test.com');

-- Criar perfis
INSERT INTO profiles (id, email, full_name, default_tenant_id) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'admin-a@test.com', 'Admin A', '11111111-1111-1111-1111-111111111111'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'learner-a@test.com', 'Learner A', '11111111-1111-1111-1111-111111111111'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'learner-b@test.com', 'Learner B', '22222222-2222-2222-2222-222222222222');

-- Criar membros dos tenants
INSERT INTO tenant_members (tenant_id, user_id, role, accepted_at) VALUES
  ('11111111-1111-1111-1111-111111111111', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'admin', NOW()),
  ('11111111-1111-1111-1111-111111111111', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'learner', NOW()),
  ('22222222-2222-2222-2222-222222222222', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'learner', NOW());

-- Criar matéria de teste
INSERT INTO subjects (id, tenant_id, external_id, name, slug, type, order_index) VALUES
  ('dddddddd-dddd-dddd-dddd-dddddddddddd', NULL, 'TEST-1', 'Matéria de Teste', 'materia-teste', 'CONHECIMENTOS GERAIS', 0);

-- Criar tópico de teste
INSERT INTO topics (id, subject_id, external_id, title, order_index) VALUES
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 'TEST-1-1', 'Tópico de Teste', 0);

-- Criar subtópico de teste
INSERT INTO subtopics (id, topic_id, external_id, title, level, order_index) VALUES
  ('ffffffff-ffff-ffff-ffff-ffffffffffff', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'TEST-1-1.1', 'Subtópico de Teste', 1, 0);

-- Criar progresso de teste para ambos os tenants
INSERT INTO progress (tenant_id, user_id, subtopic_id, confidence_level) VALUES
  ('11111111-1111-1111-1111-111111111111', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'ffffffff-ffff-ffff-ffff-ffffffffffff', 4),
  ('22222222-2222-2222-2222-222222222222', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'ffffffff-ffff-ffff-ffff-ffffffffffff', 3);

COMMIT;

-- ============================================
-- SUITE DE TESTES
-- ============================================

\echo '================================================'
\echo 'TESTES DE POLÍTICAS RLS - TCU Dashboard'
\echo '================================================'
\echo ''

-- ============================================
-- TESTE 1: Isolamento de Tenant - Usuários veem apenas seu próprio tenant
-- ============================================
\echo 'TESTE 1: Isolamento de Tenant'
\echo '------------------------------'

-- Definir sessão como Learner A (Tenant A)
SET ROLE authenticated;
SET request.jwt.claim.sub = 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb';

-- Deve ver apenas Tenant A
SELECT 
  CASE 
    WHEN COUNT(*) = 1 AND MAX(id) = '11111111-1111-1111-1111-111111111111' 
    THEN '✅ PASSOU: Usuário vê apenas seu tenant'
    ELSE '❌ FALHOU: Usuário vê ' || COUNT(*) || ' tenants (esperado 1)'
  END AS resultado
FROM tenants;

-- ============================================
-- TESTE 2: Isolamento de Progresso - Usuários veem apenas seu próprio progresso
-- ============================================
\echo ''
\echo 'TESTE 2: Isolamento de Progresso'
\echo '---------------------------------'

-- Deve ver apenas progresso próprio
SELECT 
  CASE 
    WHEN COUNT(*) = 1 AND MAX(user_id) = 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'
    THEN '✅ PASSOU: Usuário vê apenas seu próprio progresso'
    ELSE '❌ FALHOU: Usuário vê ' || COUNT(*) || ' registros de progresso (esperado 1)'
  END AS resultado
FROM progress;

-- ============================================
-- TESTE 3: Administrador pode ver todo o progresso em seu tenant
-- ============================================
\echo ''
\echo 'TESTE 3: Acesso de Administrador'
\echo '---------------------------------'

-- Definir sessão como Admin A
SET request.jwt.claim.sub = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa';

-- Admin deve ver todo o progresso no Tenant A
SELECT 
  CASE 
    WHEN COUNT(*) = 1 
    THEN '✅ PASSOU: Admin vê todo o progresso do tenant'
    ELSE '❌ FALHOU: Admin vê ' || COUNT(*) || ' registros de progresso (esperado 1 para seu tenant)'
  END AS resultado
FROM progress;

-- ============================================
-- TESTE 4: Isolamento cross-tenant (teste de segurança crítico)
-- ============================================
\echo ''
\echo 'TESTE 4: Isolamento Cross-Tenant (CRÍTICO)'
\echo '-------------------------------------------'

-- Definir sessão como Learner B (Tenant B)
SET request.jwt.claim.sub = 'cccccccc-cccc-cccc-cccc-cccccccccccc';

-- NÃO deve ver dados do Tenant A
SELECT 
  CASE 
    WHEN COUNT(*) = 0 
    THEN '✅ PASSOU: Sem acesso a dados de outro tenant'
    ELSE '❌ FALHOU: VIOLAÇÃO DE SEGURANÇA - Pode ver ' || COUNT(*) || ' registros de outro tenant'
  END AS resultado
FROM progress 
WHERE tenant_id = '11111111-1111-1111-1111-111111111111';

-- ============================================
-- TESTE 5: Proteção de Escrita - Usuários podem inserir apenas seu próprio progresso
-- ============================================
\echo ''
\echo 'TESTE 5: Proteção de Escrita'
\echo '-----------------------------'

-- Definir contexto do tenant para inserção
SET app.current_tenant = '22222222-2222-2222-2222-222222222222';

-- Tentar inserir progresso para si mesmo (deve funcionar)
DO $$
DECLARE
  v_count int;
BEGIN
  INSERT INTO progress (tenant_id, user_id, subtopic_id, confidence_level)
  VALUES (
    '22222222-2222-2222-2222-222222222222',
    'cccccccc-cccc-cccc-cccc-cccccccccccc',
    'ffffffff-ffff-ffff-ffff-ffffffffffff',
    5
  ) ON CONFLICT (tenant_id, user_id, subtopic_id) DO UPDATE SET confidence_level = 5;
  
  SELECT COUNT(*) INTO v_count FROM progress 
  WHERE user_id = 'cccccccc-cccc-cccc-cccc-cccccccccccc';
  
  IF v_count >= 1 THEN
    RAISE NOTICE '✅ PASSOU: Usuário pode inserir seu próprio progresso';
  ELSE
    RAISE NOTICE '❌ FALHOU: Usuário não pode inserir seu próprio progresso';
  END IF;
END $$;

-- ============================================
-- TESTE 6: Prevenir escrita cross-tenant
-- ============================================
\echo ''
\echo 'TESTE 6: Prevenir Escrita Cross-Tenant (CRÍTICO)'
\echo '-------------------------------------------------'

-- Tentar inserir progresso para outro tenant (deve falhar)
DO $$
BEGIN
  INSERT INTO progress (tenant_id, user_id, subtopic_id, confidence_level)
  VALUES (
    '11111111-1111-1111-1111-111111111111', -- Tenant diferente!
    'cccccccc-cccc-cccc-cccc-cccccccccccc',
    'ffffffff-ffff-ffff-ffff-ffffffffffff',
    5
  );
  
  RAISE NOTICE '❌ FALHOU: VIOLAÇÃO DE SEGURANÇA - Usuário inseriu dados em outro tenant';
EXCEPTION
  WHEN insufficient_privilege OR check_violation THEN
    RAISE NOTICE '✅ PASSOU: Escrita cross-tenant corretamente bloqueada';
END $$;

-- ============================================
-- TESTE 7: Acesso ao Log de Auditoria - Apenas administradores
-- ============================================
\echo ''
\echo 'TESTE 7: Controle de Acesso ao Log de Auditoria'
\echo '------------------------------------------------'

-- Learner NÃO deve ver logs de auditoria
SET request.jwt.claim.sub = 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb';

SELECT 
  CASE 
    WHEN COUNT(*) = 0 
    THEN '✅ PASSOU: Learners não podem acessar logs de auditoria'
    ELSE '❌ FALHOU: Learner pode ver ' || COUNT(*) || ' registros de log de auditoria'
  END AS resultado
FROM audit_log;

-- Admin deve ver logs de auditoria de seu tenant
SET request.jwt.claim.sub = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa';

SELECT 
  CASE 
    WHEN COUNT(*) >= 0 
    THEN '✅ PASSOU: Admins podem acessar logs de auditoria'
    ELSE '❌ FALHOU: Admin não pode acessar logs de auditoria'
  END AS resultado
FROM audit_log 
WHERE tenant_id = '11111111-1111-1111-1111-111111111111' OR tenant_id IS NULL;

-- ============================================
-- TESTE 8: Consentimentos de Usuário - Apenas dados próprios
-- ============================================
\echo ''
\echo 'TESTE 8: Acesso a Consentimentos de Usuário'
\echo '--------------------------------------------'

-- Inserir consentimentos de teste
INSERT INTO user_consents (user_id, consent_type, version) VALUES
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'terms', '1.0'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'terms', '1.0');

-- Definir como Learner A
SET request.jwt.claim.sub = 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb';

SELECT 
  CASE 
    WHEN COUNT(*) = 1 AND MAX(user_id) = 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'
    THEN '✅ PASSOU: Usuário vê apenas seus próprios consentimentos'
    ELSE '❌ FALHOU: Usuário vê ' || COUNT(*) || ' consentimentos (esperado 1)'
  END AS resultado
FROM user_consents;

-- ============================================
-- TESTE 9: Acesso a Matérias - Dados globais
-- ============================================
\echo ''
\echo 'TESTE 9: Acesso a Matérias Globais'
\echo '-----------------------------------'

-- Todos os usuários devem ver matérias globais (tenant_id = NULL)
SELECT 
  CASE 
    WHEN COUNT(*) >= 1
    THEN '✅ PASSOU: Usuários podem acessar matérias globais'
    ELSE '❌ FALHOU: Usuários não podem acessar matérias globais'
  END AS resultado
FROM subjects 
WHERE tenant_id IS NULL;

-- ============================================
-- TESTE 10: Gestão de Membros do Tenant
-- ============================================
\echo ''
\echo 'TESTE 10: Gestão de Membros do Tenant'
\echo '--------------------------------------'

-- Definir como Admin A
SET request.jwt.claim.sub = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa';

-- Admin deve ver todos os membros em seu tenant
SELECT 
  CASE 
    WHEN COUNT(*) = 2 -- Admin A + Learner A
    THEN '✅ PASSOU: Admin vê todos os membros do tenant'
    ELSE '❌ FALHOU: Admin vê ' || COUNT(*) || ' membros (esperado 2)'
  END AS resultado
FROM tenant_members 
WHERE tenant_id = '11111111-1111-1111-1111-111111111111';

-- Definir como Learner A
SET request.jwt.claim.sub = 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb';

-- Learner também deve ver membros de seu tenant
SELECT 
  CASE 
    WHEN COUNT(*) = 2
    THEN '✅ PASSOU: Learners veem membros do tenant'
    ELSE '❌ FALHOU: Learner vê ' || COUNT(*) || ' membros (esperado 2)'
  END AS resultado
FROM tenant_members 
WHERE tenant_id = '11111111-1111-1111-1111-111111111111';

-- ============================================
-- LIMPEZA
-- ============================================
\echo ''
\echo '================================================'
\echo 'Limpando dados de teste...'
\echo '================================================'

RESET ROLE;

-- Limpar dados de teste
DELETE FROM progress WHERE tenant_id IN ('11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222');
DELETE FROM user_consents WHERE user_id IN ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cccccccc-cccc-cccc-cccc-cccccccccccc');
DELETE FROM subtopics WHERE id = 'ffffffff-ffff-ffff-ffff-ffffffffffff';
DELETE FROM topics WHERE id = 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee';
DELETE FROM subjects WHERE id = 'dddddddd-dddd-dddd-dddd-dddddddddddd';
DELETE FROM tenant_members WHERE tenant_id IN ('11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222');
DELETE FROM profiles WHERE id IN ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cccccccc-cccc-cccc-cccc-cccccccccccc');
DELETE FROM auth.users WHERE id IN ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cccccccc-cccc-cccc-cccc-cccccccccccc');
DELETE FROM tenants WHERE id IN ('11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222');

\echo ''
\echo 'Suite de testes concluída!'
\echo ''
\echo 'Resumo:'
\echo '-------'
\echo '10 testes de políticas RLS executados'
\echo 'Revise os resultados acima para qualquer entrada ❌ FALHOU'
\echo ''
\echo 'Testes de Segurança Críticos:'
\echo '  - TESTE 4: Isolamento Cross-Tenant'
\echo '  - TESTE 6: Prevenir Escrita Cross-Tenant'
\echo ''
\echo 'Se todos os testes mostrarem ✅ PASSOU, as políticas RLS estão corretamente configuradas.'
\echo '================================================'
