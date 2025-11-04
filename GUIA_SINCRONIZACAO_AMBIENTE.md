# 🔄 Guia de Sincronização de Variáveis de Ambiente

## 📋 Visão Geral

Este guia explica como gerenciar e sincronizar variáveis de ambiente entre seu ambiente de desenvolvimento local e a plataforma Vercel.

---

## 🎯 Estrutura de Arquivos de Ambiente

### Arquivos de Ambiente no Projeto

```
TCU-2K25-DASHBOARD/
├── .env                      # Variáveis padrão (commitado no git)
├── .env.local                # Variáveis locais (NÃO commitado)
├── .env.production           # Variáveis de produção (NÃO commitado)
├── .env.production.example   # Template de produção (commitado)
└── .env.example              # Template geral (commitado)
```

### Prioridade de Carregamento

O Vite carrega os arquivos nesta ordem (o último sobrescreve o anterior):

1. `.env` - Variáveis para todos os ambientes
2. `.env.local` - Sobrescreve .env localmente
3. `.env.[mode]` - Variáveis específicas do modo (ex: .env.production)
4. `.env.[mode].local` - Sobrescreve .env.[mode] localmente

---

## 🔑 Variáveis de Ambiente do Projeto

### Obrigatórias

| Variável | Descrição | Onde Obter |
|----------|-----------|------------|
| `GEMINI_API_KEY` | Chave da API Google Gemini | https://aistudio.google.com/app/apikey |

### Opcionais (Supabase)

| Variável | Descrição | Onde Obter |
|----------|-----------|------------|
| `SUPABASE_URL` | URL do projeto Supabase | Dashboard Supabase → Settings → API |
| `SUPABASE_ANON_PUBLIC` | Chave pública/anon do Supabase | Dashboard Supabase → Settings → API |
| `SUPABASE_SERVICE_ROLE` | Chave service_role (backend apenas) | Dashboard Supabase → Settings → API |

---

## 🚀 Script de Sincronização

### Instalação

O script já está incluído no projeto:

```bash
# Tornar executável (já feito)
chmod +x scripts/sync-env.sh
```

### Comandos Disponíveis

#### 1. **Baixar Variáveis do Vercel** (`pull`)

Baixa todas as variáveis de ambiente do Vercel para seu `.env.local`:

```bash
./scripts/sync-env.sh pull
```

**O que faz:**
- ✅ Cria backup do `.env.local` existente
- ✅ Baixa variáveis do Vercel
- ✅ Salva em `.env.local`
- ✅ Mostra resumo das variáveis

**Quando usar:**
- Ao configurar novo ambiente de desenvolvimento
- Ao trocar de máquina
- Para sincronizar com configurações do time

#### 2. **Enviar Variáveis para o Vercel** (`push`)

Envia variáveis locais para a plataforma Vercel:

```bash
# Enviar do arquivo .env
./scripts/sync-env.sh push

# Enviar de arquivo específico
./scripts/sync-env.sh push .env.production
```

**Processo interativo:**
1. Seleciona ambiente de destino (Development/Preview/Production/Todos)
2. Confirma operação
3. Envia variável por variável

**Quando usar:**
- Ao adicionar novas variáveis de ambiente
- Ao atualizar valores existentes
- Ao configurar ambiente pela primeira vez

#### 3. **Validar Variáveis** (`validate`)

Valida se as variáveis estão configuradas corretamente:

```bash
# Validar .env
./scripts/sync-env.sh validate

# Validar arquivo específico
./scripts/sync-env.sh validate .env.production
```

**Verificações:**
- ✅ Variáveis obrigatórias presentes
- ✅ Formato dos valores
- ✅ Valores placeholder não utilizados
- ✅ Segurança (.gitignore configurado)

**Quando usar:**
- Antes de fazer deploy
- Ao configurar novo ambiente
- Para troubleshooting

#### 4. **Criar Backup** (`backup`)

Cria backup de todos os arquivos de ambiente:

```bash
./scripts/sync-env.sh backup
```

**O que faz:**
- ✅ Backup de todos os arquivos .env*
- ✅ Backup das variáveis do Vercel (3 ambientes)
- ✅ Salva em `.env-backups/` com timestamp

**Quando usar:**
- Antes de fazer mudanças importantes
- Rotina de backup regular
- Antes de restaurar de backup

#### 5. **Restaurar Backup** (`restore`)

Restaura variáveis de um backup anterior:

```bash
./scripts/sync-env.sh restore
```

**Processo interativo:**
1. Lista backups disponíveis
2. Seleciona backup para restaurar
3. Confirma operação
4. Restaura arquivos

**Quando usar:**
- Após mudanças problemáticas
- Para reverter configurações
- Em caso de perda de dados

#### 6. **Comparar Local vs Vercel** (`compare`)

Compara variáveis locais com as do Vercel:

```bash
# Comparar .env com Vercel
./scripts/sync-env.sh compare

# Comparar arquivo específico
./scripts/sync-env.sh compare .env.production
```

**Mostra:**
- ➖ Variáveis apenas locais
- ➕ Variáveis apenas no Vercel
- ✅ Variáveis em ambos (identifica diferenças)

**Quando usar:**
- Para debugging
- Antes de fazer push/pull
- Para auditoria de configuração

#### 7. **Listar Variáveis do Vercel** (`list`)

Lista todas as variáveis configuradas no Vercel:

```bash
./scripts/sync-env.sh list
```

**Mostra:**
- Variáveis de Production
- Variáveis de Preview
- Variáveis de Development

**Quando usar:**
- Para verificar configuração remota
- Para auditoria
- Para documentação

---

## 🔧 Workflow Recomendado

### 1. Configuração Inicial (Primeira Vez)

```bash
# 1. Vincular projeto ao Vercel (já feito)
vercel link

# 2. Copiar template e preencher valores
cp .env.example .env.local

# 3. Editar .env.local com suas chaves
nano .env.local
# Adicionar: GEMINI_API_KEY=sua_chave_aqui

# 4. Validar configuração
./scripts/sync-env.sh validate .env.local

# 5. Enviar para Vercel
./scripts/sync-env.sh push .env.local
```

### 2. Desenvolvimento Diário

```bash
# Ao iniciar desenvolvimento
./scripts/sync-env.sh pull

# Ao adicionar nova variável
# 1. Adicionar em .env.local
echo "NOVA_VARIAVEL=valor" >> .env.local

# 2. Validar
./scripts/sync-env.sh validate

# 3. Enviar para Vercel
./scripts/sync-env.sh push .env.local
```

### 3. Antes de Deploy

```bash
# 1. Criar backup
./scripts/sync-env.sh backup

# 2. Validar ambiente de produção
./scripts/sync-env.sh validate .env.production

# 3. Comparar com Vercel
./scripts/sync-env.sh compare .env.production

# 4. Enviar se necessário
./scripts/sync-env.sh push .env.production
```

### 4. Troubleshooting

```bash
# Verificar diferenças
./scripts/sync-env.sh compare

# Validar configuração
./scripts/sync-env.sh validate

# Listar variáveis do Vercel
./scripts/sync-env.sh list

# Se necessário, restaurar backup
./scripts/sync-env.sh restore
```

---

## ⚙️ Configuração Manual via Vercel CLI

### Adicionar Variável Individual

```bash
# Adicionar para um ambiente específico
vercel env add NOME_VARIAVEL production

# Adicionar para todos os ambientes
vercel env add NOME_VARIAVEL
```

### Remover Variável

```bash
vercel env rm NOME_VARIAVEL production
```

### Listar Variáveis

```bash
# Listar todas
vercel env ls

# Listar de ambiente específico
vercel env ls --environment=production
```

### Baixar Variáveis

```bash
# Baixar para .env.local
vercel env pull

# Baixar para arquivo específico
vercel env pull .env.production.local
```

---

## 🔐 Segurança

### Boas Práticas

1. **Nunca Commite Segredos**
   ```bash
   # Verificar se .gitignore está correto
   cat .gitignore | grep ".env"
   ```

2. **Use Valores Fortes**
   - Chaves de API: mínimo 32 caracteres
   - Secrets: use geradores de senha
   - Tokens: rotacione regularmente

3. **Separe Ambientes**
   - Development: chaves de teste
   - Preview: chaves de staging
   - Production: chaves reais

4. **Restrinja Chaves de API**
   - Configure restrições de domínio no Google Cloud Console
   - Use CORS_ORIGIN para limitar origens
   - Implemente rate limiting

### Verificação de Segurança

O comando `validate` já verifica:
- ✅ Arquivos .env* no .gitignore
- ✅ Valores placeholder não utilizados
- ✅ Tamanho mínimo de secrets
- ✅ URLs hardcoded em produção

---

## 📊 Estrutura de Ambientes Vercel

### Development
- Usado para branches de desenvolvimento
- Variáveis de teste/desenvolvimento
- Rebuilds automáticos em push

### Preview
- Usado para pull requests
- Variáveis de staging/teste
- URLs únicas por PR

### Production
- Branch principal (main/master)
- Variáveis de produção reais
- Domínio de produção

---

## 🚨 Solução de Problemas

### Erro: "Project not linked to Vercel"

```bash
# Vincular projeto
vercel link
```

### Erro: "Vercel CLI not found"

```bash
# Instalar Vercel CLI globalmente
npm install -g vercel
```

### Variáveis não Carregam no Build

1. Verificar se estão configuradas no Vercel:
   ```bash
   vercel env ls
   ```

2. Fazer redeploy após adicionar variáveis:
   ```bash
   vercel --prod
   ```

3. Verificar se nomes estão corretos (case-sensitive)

### Diferenças entre Local e Vercel

```bash
# Comparar para identificar divergências
./scripts/sync-env.sh compare

# Sincronizar do Vercel para local
./scripts/sync-env.sh pull

# Ou enviar local para Vercel
./scripts/sync-env.sh push
```

---

## 📝 Checklist de Configuração

### Configuração Inicial
- [ ] Vercel CLI instalado (`npm install -g vercel`)
- [ ] Projeto vinculado (`vercel link`)
- [ ] `.env.local` criado e configurado
- [ ] `GEMINI_API_KEY` configurada
- [ ] Validação passou (`./scripts/sync-env.sh validate`)
- [ ] Variáveis enviadas para Vercel (`./scripts/sync-env.sh push`)

### Antes de Deploy
- [ ] Backup criado (`./scripts/sync-env.sh backup`)
- [ ] Variáveis de produção validadas
- [ ] Comparação local vs Vercel feita
- [ ] Secrets rotacionados (se necessário)
- [ ] Restrições de API configuradas

### Manutenção Regular
- [ ] Backups semanais
- [ ] Auditoria mensal de variáveis não utilizadas
- [ ] Rotação trimestral de secrets
- [ ] Sincronização de time (pull/push)

---

## 🔗 Recursos Adicionais

### Documentação
- [Vercel Environment Variables](https://vercel.com/docs/concepts/projects/environment-variables)
- [Vite Environment Variables](https://vitejs.dev/guide/env-and-mode.html)
- [VERCEL_DEPLOYMENT.md](./VERCEL_DEPLOYMENT.md) - Guia completo de deployment
- [DEPLOYMENT_QUICK_START.md](./DEPLOYMENT_QUICK_START.md) - Guia rápido

### Scripts NPM

Adicionados em `package.json`:

```json
{
  "scripts": {
    "env:pull": "./scripts/sync-env.sh pull",
    "env:push": "./scripts/sync-env.sh push",
    "env:validate": "./scripts/sync-env.sh validate",
    "env:backup": "./scripts/sync-env.sh backup",
    "env:compare": "./scripts/sync-env.sh compare"
  }
}
```

Uso:
```bash
npm run env:pull
npm run env:validate
npm run env:backup
```

---

## 💡 Dicas Avançadas

### 1. Sincronização de Time

```bash
# Lead cria configuração base
./scripts/sync-env.sh push .env.example

# Time members baixam
./scripts/sync-env.sh pull
# Depois editam .env.local com chaves pessoais
```

### 2. Ambientes Múltiplos

```bash
# Configurar staging
cp .env.production .env.staging
nano .env.staging  # Ajustar para staging
./scripts/sync-env.sh push .env.staging

# Configurar development
./scripts/sync-env.sh push .env.local
```

### 3. Automação com Git Hooks

Adicione em `.git/hooks/pre-commit`:

```bash
#!/bin/bash
./scripts/sync-env.sh validate || exit 1
```

### 4. CI/CD Integration

Adicione ao GitHub Actions:

```yaml
- name: Validar Ambiente
  run: ./scripts/sync-env.sh validate

- name: Sincronizar com Vercel
  env:
    VERCEL_TOKEN: ${{ secrets.VERCEL_TOKEN }}
  run: ./scripts/sync-env.sh push
```

---

## ✅ Próximos Passos

1. **Configurar Variáveis Agora**
   ```bash
   ./scripts/sync-env.sh push .env
   ```

2. **Fazer Deploy**
   ```bash
   vercel --prod
   ```

3. **Verificar Deployment**
   - Acesse a URL do Vercel
   - Teste funcionalidade de IA (Gemini API)
   - Verifique progresso (localStorage/Supabase)

4. **Configurar Monitoramento**
   - Enable Vercel Analytics
   - Configure error tracking
   - Set up performance monitoring

---

**Pronto!** Suas variáveis de ambiente estão sincronizadas e seu projeto está pronto para deployment! 🚀
