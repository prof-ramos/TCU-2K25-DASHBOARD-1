#!/bin/bash

# ====================================================================
# TCU Dashboard - Script de Sincronização de Variáveis de Ambiente
# ====================================================================
#
# Este script sincroniza variáveis de ambiente entre desenvolvimento
# local e a plataforma Vercel
#
# Uso:
#   ./scripts/sync-env.sh [comando] [opcoes]
#
# Comandos:
#   pull      - Baixa variáveis do Vercel para .env.local
#   push      - Envia variáveis locais para o Vercel
#   validate  - Valida configuração das variáveis de ambiente
#   backup    - Cria backup das variáveis de ambiente
#   restore   - Restaura variáveis de um backup
#   compare   - Compara variáveis locais com Vercel
#   list      - Lista variáveis de ambiente do Vercel
#
# ====================================================================

set -e  # Sair em caso de erro

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Sem cor

# Diretórios
BACKUP_DIR=".env-backups"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Arquivos de ambiente
ENV_FILES=(".env" ".env.local" ".env.production" ".env.example")

# ====================================================================
# Funções Auxiliares
# ====================================================================

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Verificar se Vercel CLI está instalado
check_vercel_cli() {
    if ! command -v vercel &> /dev/null; then
        log_error "Vercel CLI não está instalado"
        echo ""
        echo "Instale com: npm install -g vercel"
        exit 1
    fi
    log_success "Vercel CLI encontrado ($(vercel --version))"
}

# Verificar se projeto está vinculado ao Vercel
check_vercel_link() {
    if ! vercel env ls &> /dev/null; then
        log_error "Projeto não está vinculado ao Vercel"
        echo ""
        echo "Execute primeiro:"
        echo "  vercel link"
        echo ""
        echo "Ou importe o projeto em: https://vercel.com/new"
        exit 1
    fi
    log_success "Projeto vinculado ao Vercel"
}

# ====================================================================
# Comando: PULL - Baixar variáveis do Vercel
# ====================================================================

pull_env() {
    log_info "Baixando variáveis de ambiente do Vercel..."
    echo ""

    # Criar backup do .env.local existente
    if [ -f ".env.local" ]; then
        local timestamp=$(date +%Y%m%d_%H%M%S)
        mkdir -p "$BACKUP_DIR"
        cp .env.local "$BACKUP_DIR/.env.local.backup.$timestamp"
        log_success "Backup criado: $BACKUP_DIR/.env.local.backup.$timestamp"
    fi

    # Baixar variáveis do Vercel
    log_info "Executando: vercel env pull .env.local"
    vercel env pull .env.local

    if [ $? -eq 0 ]; then
        log_success "Variáveis baixadas com sucesso!"
        echo ""

        # Mostrar resumo
        log_info "Resumo das Variáveis:"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

        local total=$(grep -c "=" .env.local 2>/dev/null || echo "0")
        echo "Total de variáveis: $total"
        echo ""

        # Listar nomes das variáveis (mascarar valores)
        echo "Variáveis encontradas:"
        grep "^[A-Z]" .env.local 2>/dev/null | cut -d'=' -f1 | while read -r var; do
            echo "  • $var"
        done

        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    else
        log_error "Falha ao baixar variáveis"
        exit 1
    fi
}

# ====================================================================
# Comando: PUSH - Enviar variáveis para o Vercel
# ====================================================================

push_env() {
    log_info "Enviando variáveis de ambiente para o Vercel..."
    echo ""

    # Determinar qual arquivo usar
    local env_file=".env"

    if [ -n "$1" ]; then
        env_file="$1"
    fi

    if [ ! -f "$env_file" ]; then
        log_error "Arquivo não encontrado: $env_file"
        echo ""
        echo "Uso: $0 push [arquivo-env]"
        echo "Exemplo: $0 push .env.production"
        exit 1
    fi

    log_info "Usando arquivo: $env_file"

    # Perguntar ambiente de destino
    echo ""
    echo "Selecione o ambiente de destino:"
    echo "  1) Development"
    echo "  2) Preview"
    echo "  3) Production"
    echo "  4) Todos"
    echo ""
    read -p "Escolha [1-4]: " env_choice

    local target_envs=()
    case $env_choice in
        1) target_envs=("development") ;;
        2) target_envs=("preview") ;;
        3) target_envs=("production") ;;
        4) target_envs=("development" "preview" "production") ;;
        *)
            log_error "Opção inválida"
            exit 1
            ;;
    esac

    echo ""
    log_warning "ATENÇÃO: Isto irá sobrescrever variáveis existentes no Vercel!"
    read -p "Deseja continuar? (sim/não): " confirm

    if [ "$confirm" != "sim" ]; then
        log_info "Operação cancelada"
        exit 0
    fi

    echo ""

    # Enviar variáveis para cada ambiente
    for target_env in "${target_envs[@]}"; do
        log_info "Enviando para ambiente: $target_env"
        echo ""

        # Ler variáveis do arquivo e enviar
        while IFS='=' read -r key value; do
            # Pular linhas vazias e comentários
            if [[ -z "$key" || "$key" =~ ^#.* ]]; then
                continue
            fi

            # Remover aspas do valor
            value=$(echo "$value" | sed 's/^"\(.*\)"$/\1/' | sed "s/^'\(.*\)'$/\1/")

            echo "  🔑 Configurando $key..."
            echo "$value" | vercel env add "$key" "$target_env" --force 2>&1 | grep -v "Overwriting"

        done < "$env_file"

        log_success "Ambiente $target_env configurado!"
        echo ""
    done

    log_success "Todas as variáveis foram enviadas com sucesso!"
}

# ====================================================================
# Comando: VALIDATE - Validar variáveis de ambiente
# ====================================================================

validate_env() {
    log_info "Validando variáveis de ambiente..."
    echo ""

    local env_file="${1:-.env}"

    if [ ! -f "$env_file" ]; then
        log_error "Arquivo não encontrado: $env_file"
        exit 1
    fi

    log_info "Validando: $env_file"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    local errors=0
    local warnings=0

    # Variáveis obrigatórias para este projeto
    local required_vars=("GEMINI_API_KEY")

    # Verificar variáveis obrigatórias
    for var in "${required_vars[@]}"; do
        if ! grep -q "^${var}=" "$env_file"; then
            log_error "Variável obrigatória ausente: $var"
            ((errors++))
        else
            local value=$(grep "^${var}=" "$env_file" | cut -d'=' -f2-)
            value=$(echo "$value" | sed 's/^"\(.*\)"$/\1/' | sed "s/^'\(.*\)'$/\1/")

            # Verificar valores placeholder
            if [[ "$value" == *"PLACEHOLDER"* || "$value" == *"your_"* || "$value" == *"sua_"* ]]; then
                log_warning "$var contém valor placeholder"
                ((warnings++))
            elif [ ${#value} -lt 10 ]; then
                log_warning "$var parece muito curta (${#value} caracteres)"
                ((warnings++))
            else
                log_success "$var configurada"
            fi
        fi
    done

    # Variáveis opcionais (Supabase)
    local optional_vars=("SUPABASE_URL" "SUPABASE_ANON_PUBLIC" "SUPABASE_SERVICE_ROLE")

    echo ""
    log_info "Variáveis opcionais (Supabase):"

    for var in "${optional_vars[@]}"; do
        if grep -q "^${var}=" "$env_file"; then
            local value=$(grep "^${var}=" "$env_file" | cut -d'=' -f2-)
            value=$(echo "$value" | sed 's/^"\(.*\)"$/\1/' | sed "s/^'\(.*\)'$/\1/")

            if [[ "$value" == *"your_"* || "$value" == *"sua_"* ]]; then
                log_warning "$var contém valor placeholder"
            else
                log_success "$var configurada"
            fi
        else
            echo "  ℹ️  $var não configurada (opcional)"
        fi
    done

    # Verificar se está no .gitignore
    echo ""
    log_info "Verificando segurança..."

    if [ -f ".gitignore" ]; then
        if ! grep -q ".env.local" .gitignore; then
            log_warning ".env.local não está no .gitignore"
            ((warnings++))
        else
            log_success ".env.local está protegido no .gitignore"
        fi

        if ! grep -q ".env.production" .gitignore; then
            log_warning ".env.production não está no .gitignore"
            ((warnings++))
        else
            log_success ".env.production está protegido no .gitignore"
        fi
    else
        log_error ".gitignore não encontrado"
        ((errors++))
    fi

    # Resumo
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    if [ $errors -eq 0 ] && [ $warnings -eq 0 ]; then
        log_success "Validação concluída sem problemas!"
        return 0
    elif [ $errors -eq 0 ]; then
        log_warning "Validação concluída com $warnings avisos"
        return 0
    else
        log_error "Validação falhou com $errors erros e $warnings avisos"
        return 1
    fi
}

# ====================================================================
# Comando: BACKUP - Criar backup das variáveis
# ====================================================================

backup_env() {
    local timestamp=$(date +%Y%m%d_%H%M%S)

    log_info "Criando backup das variáveis de ambiente..."
    echo ""

    mkdir -p "$BACKUP_DIR"

    # Backup de arquivos locais
    for file in "${ENV_FILES[@]}"; do
        if [ -f "$file" ]; then
            cp "$file" "$BACKUP_DIR/${file}.${timestamp}"
            log_success "Backup criado: ${file} → $BACKUP_DIR/${file}.${timestamp}"
        fi
    done

    # Backup de variáveis do Vercel (se vinculado)
    if vercel env ls &> /dev/null; then
        echo ""
        log_info "Fazendo backup das variáveis do Vercel..."

        for env in production preview development; do
            vercel env ls --environment="$env" > "$BACKUP_DIR/vercel-${env}.${timestamp}.txt" 2>&1
            log_success "Backup Vercel ($env) → $BACKUP_DIR/vercel-${env}.${timestamp}.txt"
        done
    fi

    echo ""
    log_success "Backup completo criado em: $BACKUP_DIR/"
    echo ""
    echo "Arquivos criados:"
    ls -lh "$BACKUP_DIR/" | grep "$timestamp" | awk '{print "  •", $9, "(" $5 ")"}'
}

# ====================================================================
# Comando: RESTORE - Restaurar backup
# ====================================================================

restore_env() {
    log_info "Restaurar variáveis de ambiente de um backup"
    echo ""

    if [ ! -d "$BACKUP_DIR" ] || [ -z "$(ls -A $BACKUP_DIR 2>/dev/null)" ]; then
        log_error "Nenhum backup encontrado em $BACKUP_DIR"
        exit 1
    fi

    # Listar backups disponíveis
    log_info "Backups disponíveis:"
    echo ""

    local timestamps=$(ls -1 "$BACKUP_DIR/" | grep -E "\.env" | cut -d'.' -f3 | sort -u)

    if [ -z "$timestamps" ]; then
        log_error "Nenhum backup encontrado"
        exit 1
    fi

    local i=1
    declare -A timestamp_map

    while IFS= read -r ts; do
        timestamp_map[$i]="$ts"
        local formatted_date=$(echo "$ts" | sed 's/\([0-9]\{4\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)_\([0-9]\{2\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)/\1-\2-\3 \4:\5:\6/')
        echo "  $i) $formatted_date"
        ((i++))
    done <<< "$timestamps"

    echo ""
    read -p "Selecione o backup para restaurar [1-$((i-1))]: " choice

    local selected_timestamp="${timestamp_map[$choice]}"

    if [ -z "$selected_timestamp" ]; then
        log_error "Seleção inválida"
        exit 1
    fi

    echo ""
    log_warning "ATENÇÃO: Isto irá sobrescrever os arquivos de ambiente atuais!"
    read -p "Deseja continuar? (sim/não): " confirm

    if [ "$confirm" != "sim" ]; then
        log_info "Operação cancelada"
        exit 0
    fi

    echo ""
    log_info "Restaurando backup de $selected_timestamp..."

    # Restaurar arquivos
    for file in "${ENV_FILES[@]}"; do
        local backup_file="$BACKUP_DIR/${file}.${selected_timestamp}"
        if [ -f "$backup_file" ]; then
            cp "$backup_file" "$file"
            log_success "Restaurado: $file"
        fi
    done

    echo ""
    log_success "Backup restaurado com sucesso!"
}

# ====================================================================
# Comando: COMPARE - Comparar variáveis locais vs Vercel
# ====================================================================

compare_env() {
    log_info "Comparando variáveis locais com Vercel..."
    echo ""

    local env_file="${1:-.env}"

    if [ ! -f "$env_file" ]; then
        log_error "Arquivo não encontrado: $env_file"
        exit 1
    fi

    # Baixar variáveis do Vercel temporariamente
    local temp_file=$(mktemp)
    vercel env pull "$temp_file" 2>&1 > /dev/null

    if [ $? -ne 0 ]; then
        log_error "Falha ao baixar variáveis do Vercel"
        rm -f "$temp_file"
        exit 1
    fi

    log_info "Comparação: $env_file vs Vercel"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    # Extrair variáveis locais
    local local_vars=$(grep "^[A-Z]" "$env_file" | cut -d'=' -f1 | sort)
    local vercel_vars=$(grep "^[A-Z]" "$temp_file" | cut -d'=' -f1 | sort)

    # Variáveis apenas locais
    echo ""
    log_info "➖ Variáveis apenas no arquivo local:"
    local only_local=$(comm -23 <(echo "$local_vars") <(echo "$vercel_vars"))
    if [ -z "$only_local" ]; then
        echo "  (nenhuma)"
    else
        echo "$only_local" | while read -r var; do
            echo "  • $var"
        done
    fi

    # Variáveis apenas no Vercel
    echo ""
    log_info "➕ Variáveis apenas no Vercel:"
    local only_vercel=$(comm -13 <(echo "$local_vars") <(echo "$vercel_vars"))
    if [ -z "$only_vercel" ]; then
        echo "  (nenhuma)"
    else
        echo "$only_vercel" | while read -r var; do
            echo "  • $var"
        done
    fi

    # Variáveis em ambos
    echo ""
    log_info "✅ Variáveis em ambos:"
    local common=$(comm -12 <(echo "$local_vars") <(echo "$vercel_vars"))
    if [ -z "$common" ]; then
        echo "  (nenhuma)"
    else
        echo "$common" | while read -r var; do
            # Comparar valores (mascarados)
            local local_val=$(grep "^${var}=" "$env_file" | cut -d'=' -f2-)
            local vercel_val=$(grep "^${var}=" "$temp_file" | cut -d'=' -f2-)

            if [ "$local_val" = "$vercel_val" ]; then
                echo "  • $var (idêntico)"
            else
                echo "  • $var (diferente)"
            fi
        done
    fi

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    rm -f "$temp_file"
}

# ====================================================================
# Comando: LIST - Listar variáveis do Vercel
# ====================================================================

list_env() {
    log_info "Listando variáveis de ambiente do Vercel..."
    echo ""

    for env in production preview development; do
        echo ""
        log_info "Ambiente: $env"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        vercel env ls --environment="$env" 2>&1 | grep -v "Error" || echo "  (nenhuma variável)"
        echo ""
    done
}

# ====================================================================
# Menu Principal
# ====================================================================

show_help() {
    cat << EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  TCU Dashboard - Sincronização de Variáveis de Ambiente
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Uso: $0 [comando] [opções]

Comandos Disponíveis:

  pull              Baixa variáveis do Vercel para .env.local
  push [arquivo]    Envia variáveis locais para o Vercel
  validate [arquivo] Valida configuração das variáveis
  backup            Cria backup das variáveis de ambiente
  restore           Restaura variáveis de um backup
  compare [arquivo]  Compara variáveis locais com Vercel
  list              Lista variáveis de ambiente do Vercel
  help              Mostra esta mensagem de ajuda

Exemplos:

  # Baixar variáveis do Vercel
  $0 pull

  # Enviar variáveis para o Vercel
  $0 push .env.production

  # Validar variáveis locais
  $0 validate

  # Criar backup
  $0 backup

  # Comparar local vs Vercel
  $0 compare .env

Documentação Completa:
  VERCEL_DEPLOYMENT.md
  DEPLOYMENT_QUICK_START.md

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
}

# ====================================================================
# Executar comando
# ====================================================================

main() {
    local command="${1:-help}"
    shift || true

    case "$command" in
        pull)
            check_vercel_cli
            check_vercel_link
            pull_env "$@"
            ;;
        push)
            check_vercel_cli
            check_vercel_link
            push_env "$@"
            ;;
        validate)
            validate_env "$@"
            ;;
        backup)
            backup_env "$@"
            ;;
        restore)
            restore_env "$@"
            ;;
        compare)
            check_vercel_cli
            check_vercel_link
            compare_env "$@"
            ;;
        list)
            check_vercel_cli
            check_vercel_link
            list_env "$@"
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            log_error "Comando desconhecido: $command"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

# Executar
main "$@"
