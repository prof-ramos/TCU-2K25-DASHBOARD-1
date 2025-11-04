# 🔄 Documentação do Pipeline CI/CD

## 📋 Visão Geral

Este projeto utiliza **GitHub Actions** para automação completa de CI/CD com testes, análise de qualidade, segurança e deployment automatizado no Vercel.

---

## 🎯 Workflows Disponíveis

### 1. CI/CD Pipeline Principal (`ci-cd.yml`)

**Triggers**:
- Push para `main` ou `develop`
- Pull Requests para `main` ou `develop`
- Execução manual (workflow_dispatch)

**Jobs**:

#### 🔍 Lint & Code Quality
- ESLint validation
- Prettier format check
- TypeScript type checking

**Quando executa**: Todo push e PR
**Duração estimada**: ~2 min

#### 🧪 Testes Unitários
- Executa testes com Vitest
- Gera relatório de cobertura
- Upload para Codecov (opcional)

**Quando executa**: Todo push e PR
**Duração estimada**: ~3 min

#### 🔐 Security Audit
- NPM vulnerability scanning
- TruffleHog secret detection
- Dependency security check

**Quando executa**: Todo push e PR
**Duração estimada**: ~2 min

#### 🏗️ Build de Produção
- Build otimizado com Vite
- Análise de bundle size
- Upload de artifacts
- Cache de build

**Quando executa**: Após lint e test passarem
**Duração estimada**: ~2 min

#### 🎭 Testes E2E (Playwright)
- Testes end-to-end automatizados
- Upload de relatórios
- Screenshots e vídeos de falhas

**Quando executa**: Após build
**Duração estimada**: ~5 min

#### 🚀 Deploy Preview
- Deploy automático para preview
- Comentário no PR com URL
- Ambiente temporário

**Quando executa**: Pull Requests
**Duração estimada**: ~3 min

#### 🌐 Deploy Staging
- Deploy para ambiente de staging
- URL: `tcu-2-k25-dashboard-staging.vercel.app`

**Quando executa**: Push para `develop`
**Duração estimada**: ~3 min

#### 🎯 Deploy Production
- Deploy para produção
- URL: `tcu-2-k25-dashboard.vercel.app`
- Notificação Slack (opcional)

**Quando executa**: Push para `main`
**Duração estimada**: ~3 min

---

### 2. Dependency Updates (`dependency-update.yml`)

**Triggers**:
- Agendado: Toda segunda-feira às 9h
- Execução manual

**Funcionalidades**:
- Lista dependências desatualizadas
- Executa audit de segurança
- Cria issues automáticas para vulnerabilidades

**Duração estimada**: ~2 min

---

### 3. Performance Monitoring (`performance.yml`)

**Triggers**:
- Pull Requests para `main`
- Execução manual

**Jobs**:

#### 🔦 Lighthouse CI
- Análise de performance
- Métricas de Core Web Vitals
- Relatório detalhado no PR

**Métricas analisadas**:
- Performance Score
- Accessibility Score
- Best Practices Score
- SEO Score

#### 📦 Bundle Size Analysis
- Análise de tamanho do bundle
- Comparação com builds anteriores
- Comentário automático no PR

**Duração estimada**: ~5 min

---

## 🔧 Configuração Necessária

### Secrets do GitHub

Configure os seguintes secrets em **Settings → Secrets → Actions**:

| Secret | Descrição | Obrigatório |
|--------|-----------|-------------|
| `GEMINI_API_KEY` | Chave da API Google Gemini | ✅ Sim |
| `VERCEL_TOKEN` | Token de autenticação Vercel | ✅ Sim |
| `VERCEL_ORG_ID` | ID da organização Vercel | ✅ Sim |
| `VERCEL_PROJECT_ID` | ID do projeto Vercel | ✅ Sim |
| `CODECOV_TOKEN` | Token Codecov (opcional) | ⚠️ Opcional |
| `SLACK_WEBHOOK_URL` | Webhook Slack (opcional) | ⚠️ Opcional |

### Como Obter os Secrets

#### VERCEL_TOKEN
```bash
# Instalar Vercel CLI
npm i -g vercel

# Login
vercel login

# Gerar token
vercel tokens create
```

#### VERCEL_ORG_ID e VERCEL_PROJECT_ID
```bash
# No diretório do projeto
vercel link

# Os IDs estarão em .vercel/project.json
cat .vercel/project.json
```

#### GEMINI_API_KEY
1. Acesse: https://aistudio.google.com/app/apikey
2. Crie uma nova API key
3. Copie e adicione aos secrets

---

## 📊 Ambientes de Deployment

### Development (Local)
- **Trigger**: Não automatizado
- **Uso**: Desenvolvimento local
- **URL**: http://localhost:3000

### Preview (PR)
- **Trigger**: Pull Requests
- **Uso**: Review de código, testes
- **URL**: Gerada automaticamente pelo Vercel
- **Retenção**: Até merge/close do PR

### Staging (`develop` branch)
- **Trigger**: Push para `develop`
- **Uso**: Testes de integração, QA
- **URL**: https://tcu-2-k25-dashboard-staging.vercel.app
- **Proteção**: Environment protection rules

### Production (`main` branch)
- **Trigger**: Push para `main`
- **Uso**: Produção
- **URL**: https://tcu-2-k25-dashboard.vercel.app
- **Proteção**: Environment protection + approvals

---

## 🔄 Fluxo de Trabalho Recomendado

### Para Features
```bash
# 1. Criar branch de feature
git checkout -b feature/nova-funcionalidade

# 2. Desenvolver e commitar
git add .
git commit -m "feat: adiciona nova funcionalidade"

# 3. Push para remote
git push origin feature/nova-funcionalidade

# 4. Abrir Pull Request
# → GitHub Actions executa:
#    - Lint
#    - Tests
#    - Security
#    - Build
#    - E2E
#    - Deploy Preview
#    - Performance Analysis

# 5. Review e ajustes

# 6. Merge para develop
# → Deploy automático para Staging

# 7. Testes em staging

# 8. Merge develop → main
# → Deploy automático para Production
```

### Para Hotfixes
```bash
# 1. Criar branch de hotfix da main
git checkout main
git checkout -b hotfix/critical-bug

# 2. Fix e commit
git commit -m "fix: corrige bug crítico"

# 3. Push e PR direto para main
git push origin hotfix/critical-bug

# 4. Review acelerado

# 5. Merge para main
# → Deploy imediato para Production

# 6. Merge main → develop
# → Sincronizar develop com fix
```

---

## 🎯 Melhores Práticas

### Commits
- ✅ Use Conventional Commits (`feat:`, `fix:`, `docs:`)
- ✅ Commits pequenos e focados
- ✅ Mensagens descritivas

### Pull Requests
- ✅ Aguarde CI passar antes de review
- ✅ Revise o deploy preview
- ✅ Verifique métricas de performance
- ✅ Confirme bundle size não aumentou significativamente

### Testes
- ✅ Escreva testes para novas features
- ✅ Mantenha cobertura > 70%
- ✅ Teste em preview antes de merge

### Segurança
- ✅ Nunca commite secrets
- ✅ Revise security audit warnings
- ✅ Atualize dependências regularmente

---

## 📈 Monitoramento e Métricas

### GitHub Actions
- **Dashboard**: https://github.com/prof-ramos/TCU-2K25-DASHBOARD/actions
- **Métricas**: Tempo de execução, taxa de sucesso, consumo de minutos

### Vercel Analytics
- **Dashboard**: https://vercel.com/gaya-lex/tcu-2-k25-dashboard/analytics
- **Métricas**: Core Web Vitals, page views, performance

### Codecov (se configurado)
- **Dashboard**: https://codecov.io/gh/prof-ramos/TCU-2K25-DASHBOARD
- **Métricas**: Cobertura de código, trends

---

## 🚨 Troubleshooting

### Build falha no CI
```bash
# 1. Reproduzir localmente
npm run build

# 2. Verificar logs no GitHub Actions
# 3. Verificar variáveis de ambiente
# 4. Limpar cache se necessário
```

### Testes falham no CI mas passam local
```bash
# 1. Verificar versão do Node.js
node -v  # Deve ser 20.x

# 2. Limpar e reinstalar
rm -rf node_modules package-lock.json
npm install

# 3. Executar testes
npm test
```

### Deploy para Vercel falha
```bash
# 1. Verificar secrets configurados
# 2. Verificar permissões do token Vercel
# 3. Testar deploy manual
vercel --prod

# 4. Verificar logs no Vercel dashboard
```

### Performance degradou
```bash
# 1. Revisar Lighthouse report no PR
# 2. Analisar bundle size report
# 3. Verificar se novas dependências foram adicionadas
# 4. Executar audit local
npm run build
npx lighthouse http://localhost:4173
```

---

## 🔐 Segurança

### Proteções Implementadas
- ✅ Branch protection rules
- ✅ Required status checks
- ✅ Secret scanning (TruffleHog)
- ✅ Dependency vulnerability scanning
- ✅ Environment protection rules

### Boas Práticas
- 🔒 Secrets nunca em código
- 🔒 Tokens com permissões mínimas
- 🔒 Rotate tokens periodicamente
- 🔒 Review dependency updates
- 🔒 Approve production deploys

---

## 📚 Recursos Adicionais

### Documentação
- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [Vercel Deployment](https://vercel.com/docs)
- [Playwright Testing](https://playwright.dev/)
- [Lighthouse CI](https://github.com/GoogleChrome/lighthouse-ci)

### Links Úteis
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)
- [CI/CD Best Practices](https://docs.github.com/en/actions/learn-github-actions/best-practices-for-github-actions)

---

## 📊 Status dos Workflows

### Badges
Adicione ao README.md:

```markdown
[![CI/CD](https://github.com/prof-ramos/TCU-2K25-DASHBOARD/workflows/CI/CD%20Pipeline/badge.svg)](https://github.com/prof-ramos/TCU-2K25-DASHBOARD/actions/workflows/ci-cd.yml)
[![Performance](https://github.com/prof-ramos/TCU-2K25-DASHBOARD/workflows/Performance%20Monitoring/badge.svg)](https://github.com/prof-ramos/TCU-2K25-DASHBOARD/actions/workflows/performance.yml)
```

---

## 🎓 Para Estudantes TCU

Este pipeline CI/CD demonstra práticas profissionais da indústria:

**Conceitos Aplicados**:
- ✅ Continuous Integration
- ✅ Continuous Deployment
- ✅ Automated Testing
- ✅ Security Scanning
- ✅ Performance Monitoring
- ✅ Infrastructure as Code

**Habilidades Desenvolvidas**:
- DevOps practices
- GitHub Actions
- Automated deployments
- Quality gates
- Security best practices

---

**Última atualização**: 2025-10-29
**Versão**: 1.0
**Mantenedor**: Prof. Ramos

**Boa sorte nos estudos para o TCU TI 2025!** 🎓🚀
