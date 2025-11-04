# 📖 RUNBOOK - TCU Dashboard Enterprise

> **Procedimentos operacionais, estratégias de rollback e resposta a incidentes para produção**

**Versão**: 1.0.0  
**Última Atualização**: 30 de outubro de 2025  
**Responsável**: Equipe DevOps

---

## 📋 Índice

- [Contatos de Emergência](#contatos-de-emergência)
- [Arquitetura do Sistema](#arquitetura-do-sistema)
- [Procedimentos de Deploy](#procedimentos-de-deploy)
- [Procedimentos de Rollback](#procedimentos-de-rollback)
- [Resposta a Incidentes](#resposta-a-incidentes)
- [Operações de Banco de Dados](#operações-de-banco-de-dados)
- [Monitoramento e Alertas](#monitoramento-e-alertas)
- [Problemas Comuns](#problemas-comuns)
- [Recuperação de Desastres](#recuperação-de-desastres)

---

## Contatos de Emergência

### Escala de Plantão

| Função | Principal | Backup | Escalação |
|--------|-----------|--------|-----------|
| **DevOps Lead** | A definir | A definir | CTO |
| **Backend Lead** | A definir | A definir | Diretor de Tecnologia |
| **Frontend Lead** | A definir | A definir | Diretor de Tecnologia |
| **Security Lead** | A definir | A definir | CISO |
| **Database Admin** | A definir | A definir | DevOps Lead |

### Serviços Externos

- **Supabase Support**: support@supabase.com (Plano Pro SLA: resposta em 24h)
- **Vercel Support**: vercel.com/support (Enterprise: chat ao vivo)
- **Sentry Support**: support@sentry.io

---

## Arquitetura do Sistema

### Ambiente de Produção

```
┌─────────────────────────────────────────────────┐
│            Vercel Edge Network                  │
│  ┌──────────────────────────────────────────┐   │
│  │     Next.js 14 App (Edge Runtime)        │   │
│  │  URL: app.tcu-dashboard.com              │   │
│  └──────────────────────────────────────────┘   │
└─────────────────────────────────────────────────┘
                       ↓
┌─────────────────────────────────────────────────┐
│            Supabase (AWS us-east-1)             │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│  │PostgreSQL│  │   Auth   │  │ Storage  │      │
│  │ (RLS ON) │  │  (OAuth) │  │ (Avatar) │      │
│  └──────────┘  └──────────┘  └──────────┘      │
└─────────────────────────────────────────────────┘
                       ↓
┌─────────────────────────────────────────────────┐
│           Stack de Observabilidade              │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│  │  Sentry  │  │ Logflare │  │  Vercel  │      │
│  │ (Erros)  │  │  (Logs)  │  │(Analytics│      │
│  └──────────┘  └──────────┘  └──────────┘      │
└─────────────────────────────────────────────────┘
```

### URLs Principais

| Ambiente | Frontend | Database | Dashboard |
|----------|----------|----------|-----------|
| **Produção** | https://app.tcu-dashboard.com | `$SUPABASE_URL` | https://app.supabase.com/project/[ref] |
| **Staging** | https://staging.tcu-dashboard.com | `$SUPABASE_URL_STAGING` | https://app.supabase.com/project/[ref-staging] |
| **Desenvolvimento** | http://localhost:3000 | Supabase Local | http://localhost:54323 |

---

## Procedimentos de Deploy

### Deploy Padrão (Produção)

**Pré-requisitos**:
- [ ] Todos os testes passando (CI/CD)
- [ ] Código revisado e aprovado
- [ ] Deploy em staging bem-sucedido
- [ ] Changelog atualizado

**Passos**:

1. **Merge para branch `main`**
   ```bash
   git checkout main
   git pull origin main
   git merge --no-ff feature/sua-feature
   git push origin main
   ```

2. **Deploy Automático**
   - GitHub Actions dispara automaticamente
   - Vercel faz build e deploy para produção
   - Monitorar deploy: https://vercel.com/[org]/[project]/deployments

3. **Verificar Deploy** (~5 minutos)
   ```bash
   # Verificar status do deploy
   curl https://app.tcu-dashboard.com/api/health
   
   # Resposta esperada: {"status": "ok", "version": "x.y.z"}
   ```

4. **Checagens Pós-Deploy**
   - [ ] Endpoint de health check respondendo
   - [ ] Taxa de erro <0.1% (Sentry)
   - [ ] Tempo de resposta p95 <500ms (Vercel Analytics)
   - [ ] Sem violações de política RLS (logs Supabase)

### Deploy de Migração de Banco de Dados

**CRÍTICO**: Migrações de banco de dados são irreversíveis e requerem cautela extra.

**Pré-requisitos**:
- [ ] Migração testada em staging
- [ ] Backup verificado (PITR habilitado)
- [ ] Plano de rollback documentado
- [ ] Janela de manutenção agendada (se necessário)

**Passos**:

1. **Verificar Schema Atual**
   ```sql
   -- Conectar ao DB de produção
   psql $DATABASE_URL
   
   -- Verificar versão atual da migração
   SELECT * FROM _prisma_migrations ORDER BY finished_at DESC LIMIT 5;
   ```

2. **Aplicar Migração**
   ```bash
   # Via Supabase CLI
   supabase db push --db-url $SUPABASE_URL
   
   # Ou via Supabase Dashboard > Database > Migrations
   ```

3. **Verificar Migração**
   ```sql
   -- Verificar se novas tabelas/colunas existem
   \dt+ tenants
   \d+ progress
   
   -- Verificar políticas RLS
   SELECT schemaname, tablename, policyname 
   FROM pg_policies 
   WHERE schemaname = 'public';
   ```

4. **Testar Políticas RLS**
   ```bash
   npm run test:rls
   ```

---

## Procedimentos de Rollback

### Rollback de Código (Frontend)

**Condições de Ativação**:
- Taxa de erro >1% por >5 minutos
- Funcionalidade crítica quebrada
- Vulnerabilidade de segurança descoberta

**Passos (15 minutos)**:

1. **Identificar Último Deploy Bom**
   - Ir para: https://vercel.com/[org]/[project]/deployments
   - Encontrar último deployment bem-sucedido antes do problema

2. **Rollback via Vercel Dashboard**
   - Clicar no menu "..." do último deploy bom
   - Clicar em "Promote to Production"
   - Confirmar rollback

3. **Verificar Rollback**
   ```bash
   curl https://app.tcu-dashboard.com/api/health
   ```

4. **Notificar Equipe**
   ```
   Canal #incidents:
   🚨 Rollback de Produção Executado
   - De: [versão-ruim]
   - Para: [versão-boa]
   - Motivo: [descrição-erro]
   - Status: Monitorando
   ```

### Rollback de Banco de Dados (PITR)

**⚠️ ATENÇÃO**: Rollback de banco afeta TODOS os tenants. Usar apenas para corrupção crítica de dados.

**Condições de Ativação**:
- Corrupção de dados detectada
- Migração falha causando perda de dados
- Acesso não autorizado/violação RLS

**Passos (30 minutos)**:

1. **Parar Todas as Escritas** (Modo Manutenção)
   ```sql
   -- Revogar permissões de escrita temporariamente
   REVOKE INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public FROM authenticated;
   ```

2. **Identificar Ponto de Restauração**
   ```sql
   -- Verificar audit_log para último estado bom conhecido
   SELECT timestamp, action, resource_type 
   FROM audit_log 
   WHERE timestamp > NOW() - INTERVAL '1 hour'
   ORDER BY timestamp DESC 
   LIMIT 20;
   ```

3. **Restaurar via Supabase Dashboard**
   - Settings > Database > Point in Time Recovery
   - Selecionar timestamp (deve estar dentro de 30 dias)
   - Clicar em "Restore"
   - **Duração**: ~5-15 minutos dependendo do tamanho do DB

4. **Verificar Integridade dos Dados**
   ```sql
   -- Verificar tabelas críticas
   SELECT COUNT(*) FROM tenants;
   SELECT COUNT(*) FROM progress;
   SELECT COUNT(*) FROM audit_log WHERE timestamp > '[ponto-restauracao]';
   ```

5. **Reabilitar Escritas**
   ```sql
   GRANT INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO authenticated;
   ```

6. **Revisão Pós-Incidente**
   - Documentar causa raiz
   - Atualizar runbook com lições aprendidas
   - Agendar reunião de post-mortem

---

## Resposta a Incidentes

### Níveis de Severidade

| Nível | Definição | Tempo de Resposta | Exemplo |
|-------|-----------|-------------------|---------|
| **P0 - Crítico** | Queda completa, vazamento de dados | 15 min | DB fora, violação RLS |
| **P1 - Alto** | Funcionalidade principal quebrada | 1 hora | Auth quebrado, perda de dados |
| **P2 - Médio** | Funcionalidade parcial degradada | 4 horas | Queries lentas, bugs de UI |
| **P3 - Baixo** | Problemas menores, workaround existe | 24 horas | Bugs cosméticos, analytics fora |

### Fluxo de Resposta a Incidentes

#### 1. Detectar & Alertar

**Alertas Automatizados** (Sentry, Logflare, Vercel):
- Taxa de erro >1%
- Tempo de resposta p95 >500ms
- Logins falhados >10/min
- Violações de política RLS

**Relatos Manuais**:
- Relatos de usuários via suporte
- Membro da equipe observa problema

#### 2. Reconhecer & Avaliar

```
Template:
🚨 INCIDENTE #[número] - [Severidade]
- Detectado: [timestamp]
- Impactado: [usuários/features]
- Severidade: [P0/P1/P2/P3]
- IC (Comandante de Incidente): [nome]
- Status: INVESTIGANDO
```

#### 3. Mitigar

**Ações Imediatas P0/P1**:
1. Ativar canal de incidente (#incident-[número])
2. Acionar engenheiro de plantão
3. Iniciar chamada de war room (se necessário)
4. Habilitar modo manutenção (se necessário)
   ```bash
   # Criar página de manutenção
   vercel env add MAINTENANCE_MODE true
   vercel --prod
   ```

#### 4. Resolver

- Aplicar correção ou rollback
- Verificar resolução
- Monitorar por 30 minutos

#### 5. Comunicar

**Durante o Incidente**:
- Atualizar página de status (se pública)
- Notificar usuários afetados
- Postar atualizações a cada 15-30 minutos

**Após Resolução**:
```
✅ INCIDENTE #[número] RESOLVIDO
- Duração: [tempo]
- Causa Raiz: [breve]
- Resolução: [ação tomada]
- Próximos Passos: [post-mortem agendado]
```

#### 6. Post-Mortem

**Dentro de 48 horas**:
- [ ] Documentar timeline
- [ ] Identificar causa raiz (5 Porquês)
- [ ] Listar itens de ação
- [ ] Atualizar runbook
- [ ] Compartilhar aprendizados

---

## Operações de Banco de Dados

### Tarefas Administrativas Comuns

#### 1. Visualizar Sessões Ativas

```sql
SELECT 
  pid,
  usename,
  application_name,
  client_addr,
  state,
  query_start,
  state_change,
  query
FROM pg_stat_activity
WHERE datname = current_database()
  AND state = 'active'
ORDER BY query_start DESC;
```

#### 2. Verificar Tamanho das Tabelas

```sql
SELECT 
  schemaname,
  tablename,
  pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size,
  pg_total_relation_size(schemaname||'.'||tablename) AS size_bytes
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY size_bytes DESC;
```

#### 3. Analisar Queries Lentas

```sql
-- Habilitar logging de queries temporariamente
ALTER DATABASE postgres SET log_min_duration_statement = 1000; -- 1 segundo

-- Ver log de queries lentas em Supabase Dashboard > Logs
```

#### 4. Atualizar Materialized Views

```sql
REFRESH MATERIALIZED VIEW CONCURRENTLY tenant_progress_stats;
```

#### 5. Purgar Logs de Auditoria Antigos Manualmente

```sql
-- Arquivar logs com mais de 90 dias
DELETE FROM audit_log 
WHERE timestamp < NOW() - INTERVAL '90 days';

-- Ou exportar primeiro
COPY (SELECT * FROM audit_log WHERE timestamp < NOW() - INTERVAL '90 days')
TO '/tmp/audit_archive.csv' WITH CSV HEADER;
```

### Debugging de Políticas RLS

**Verificar se RLS está habilitado**:
```sql
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public';
```

**Ver todas as políticas**:
```sql
SELECT 
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual,
  with_check
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, policyname;
```

**Testar política como usuário específico**:
```sql
-- Definir sessão como usuário específico
SET ROLE authenticated;
SET app.current_tenant = '[tenant-uuid]';

-- Tentar query
SELECT * FROM progress WHERE user_id = auth.uid();

-- Resetar
RESET ROLE;
```

---

## Monitoramento e Alertas

### Dashboard de Métricas-Chave

**Sentry** (https://sentry.io/organizations/[org]/projects/tcu-dashboard/):
- Taxa de erro (meta: <0.1%)
- Distribuição de tipos de erro
- Contagem de usuários afetados
- Score de saúde do release

**Vercel Analytics** (https://vercel.com/[org]/[project]/analytics):
- Tempo de resposta p50/p95/p99
- Volume de requisições
- Taxa de hit do cache edge
- Distribuição geográfica

**Supabase Dashboard** (https://app.supabase.com/project/[ref]):
- Crescimento do tamanho do database
- Uso do pool de conexões
- Performance de queries (latência p95)
- Usuários ativos no Auth

### Configuração de Alertas

**Alertas Sentry**:
```yaml
- Taxa de erro > 1% por 5 minutos → #incidents
- Novo tipo de erro introduzido → #engineering
- Taxa de erro do release > baseline 2x → #on-call
```

**Alertas Customizados** (via Supabase Functions + Slack):
```sql
-- Função para detectar anomalias
CREATE OR REPLACE FUNCTION detect_anomalies()
RETURNS void AS $$
BEGIN
  -- Alta taxa de login falho
  IF (SELECT COUNT(*) FROM audit_log 
      WHERE action = 'auth.failed_login' 
        AND timestamp > NOW() - INTERVAL '5 minutes') > 50 THEN
    PERFORM pg_notify('slack_alert', 'Alta taxa de login falho detectada');
  END IF;
  
  -- Violações suspeitas de RLS
  IF (SELECT COUNT(*) FROM audit_log 
      WHERE action = 'rls.violation' 
        AND timestamp > NOW() - INTERVAL '1 minute') > 0 THEN
    PERFORM pg_notify('slack_alert', 'Violação de política RLS detectada');
  END IF;
END;
$$ LANGUAGE plpgsql;
```

---

## Problemas Comuns

### Problema: Erros "RLS policy violation"

**Sintomas**:
- Usuários recebendo 403 Forbidden
- Logs de auditoria mostrando eventos `rls.violation`

**Diagnóstico**:
```sql
-- Verificar quais políticas estão falhando
SELECT * FROM audit_log 
WHERE action LIKE '%rls%' 
ORDER BY timestamp DESC 
LIMIT 10;
```

**Resolução**:
1. Verificar se contexto do tenant está definido corretamente
2. Verificar membership do usuário no tenant
3. Revisar definições de política
4. Testar com `EXPLAIN` para ver avaliação da política

### Problema: Queries lentas no banco de dados

**Sintomas**:
- Tempo de resposta p95 >500ms
- Alto uso de CPU no database

**Diagnóstico**:
```sql
-- Verificar índices faltantes
SELECT schemaname, tablename, attname, n_distinct
FROM pg_stats
WHERE schemaname = 'public'
  AND n_distinct > 100
  AND tablename NOT IN (
    SELECT tablename FROM pg_indexes WHERE schemaname = 'public'
  );
```

**Resolução**:
1. Adicionar índices faltantes
2. Atualizar materialized views
3. Executar `ANALYZE` em tabelas grandes
4. Considerar otimização de queries

### Problema: Falhas de autenticação

**Sintomas**:
- Usuários não conseguem fazer login
- Erros "Invalid credentials"

**Diagnóstico**:
1. Verificar logs do Supabase Auth
2. Verificar status do provedor OAuth
3. Verificar configurações de expiração de sessão

**Resolução**:
- Verificar credenciais do provedor OAuth
- Verificar configuração CORS
- Validar URLs de redirecionamento

---

## Recuperação de Desastres

### Estratégia de Backup

**Backups Automatizados** (Supabase Pro):
- **PITR**: Contínuo, retenção de 30 dias
- **Snapshots Diários**: Database completo, retenção de 7 dias
- **Arquivos Semanais**: Exportado para S3, retenção de 90 dias

**Backup Manual**:
```bash
# Dump completo do database
pg_dump $DATABASE_URL > backup-$(date +%Y%m%d).sql

# Apenas schema
pg_dump --schema-only $DATABASE_URL > schema-$(date +%Y%m%d).sql

# Apenas dados
pg_dump --data-only $DATABASE_URL > data-$(date +%Y%m%d).sql
```

### Cenários de Recuperação

#### Cenário 1: Perda Completa do Database

**RTO**: 2 horas  
**RPO**: 5 minutos (PITR)

**Passos**:
1. Contactar suporte Supabase imediatamente
2. Solicitar restauração PITR para mais recente
3. Verificar integridade dos dados
4. Atualizar DNS se necessário
5. Notificar usuários

#### Cenário 2: Queda da Região Supabase

**RTO**: 4 horas  
**RPO**: 24 horas (snapshot diário)

**Passos**:
1. Provisionar novo projeto Supabase em região diferente
2. Restaurar do snapshot diário mais recente
3. Atualizar variáveis de ambiente
4. Redeploy da app Vercel
5. Atualizar DNS

#### Cenário 3: Queda da Vercel

**RTO**: 1 hora  
**RPO**: 0 (stateless)

**Passos**:
1. Deploy para provedor backup (Netlify, CloudFlare Pages)
2. Atualizar CNAME do DNS
3. Verificar deployment
4. Monitorar

### Simulações de Recuperação de Desastres

**Teste Trimestral de DR**:
- [ ] Restaurar database do PITR
- [ ] Verificar integridade dos dados
- [ ] Testar procedimentos de rollback
- [ ] Atualizar runbook com descobertas

---

## Apêndice

### Comandos Úteis

```bash
# Verificar status do deployment Vercel
vercel ls --prod

# Ver logs recentes do Supabase
supabase functions logs --tail

# Testar políticas RLS
npm run test:rls

# Analisar performance do database
npm run db:analyze

# Gerar backup
npm run db:backup
```

### Documentação Relacionada

- [📘 ENTERPRISE-ARCHITECTURE.md](./ENTERPRISE-ARCHITECTURE.md) - Design do sistema
- [🏗️ ARCHITECTURE.md](./ARCHITECTURE.md) - Arquitetura técnica
- [💻 DEVELOPMENT.md](./DEVELOPMENT.md) - Guia de desenvolvimento
- [🧪 TESTING.md](./TESTING.md) - Estratégia de testes

---

**Última Atualização**: 30 de outubro de 2025  
**Próxima Revisão**: 30 de janeiro de 2026  
**Responsável**: Equipe DevOps

[⬅ Voltar](./README.md)
