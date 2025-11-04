# Guia de Migração do Edital para Supabase

Este guia explica como migrar todo o conteúdo do edital TCU TI para o Supabase.

## Passo 1: Criar as Tabelas no Supabase

1. Acesse o SQL Editor do seu projeto Supabase:
   👉 https://supabase.com/dashboard/project/imwohmhgzamdahfiahdk/editor

2. Cole o conteúdo do arquivo `supabase-edital-schema.sql` no editor

3. Clique em "Run" para criar as tabelas:
   - `materias` - Armazena as disciplinas (Língua Portuguesa, Direito, etc)
   - `topics` - Armazena os tópicos principais de cada matéria
   - `subtopics` - Armazena os subtópicos (suporta múltiplos níveis)
   - `progress` - Tabela de progresso (já criada anteriormente)

## Passo 2: Migrar os Dados do Edital

Depois de criar as tabelas, execute o script de migração:

```bash
cd server
node parse-and-migrate-edital.js
```

O script irá:
1. Ler o arquivo de texto do edital
2. Parsear toda a estrutura hierárquica
3. Inserir todas as matérias, tópicos e subtópicos no Supabase

Você verá um log detalhado mostrando o progresso:
```
🚀 Iniciando migração do edital para Supabase...
📖 Parseando arquivo do edital...
✅ 17 matérias encontradas

📚 1. LÍNGUA PORTUGUESA (CONHECIMENTOS GERAIS)
   ✓ 1. Compreensão e interpretação de textos...
   ✓ 2. Reconhecimento de tipos e gêneros textuais...
   ...
```

## Passo 3: Verificar os Dados

Após a migração, você pode verificar os dados no Supabase:

**Ver todas as matérias:**
```sql
SELECT * FROM materias ORDER BY ordem;
```

**Ver tópicos de uma matéria:**
```sql
SELECT t.* 
FROM topics t
JOIN materias m ON t.materia_id = m.id
WHERE m.name = 'LÍNGUA PORTUGUESA'
ORDER BY t.ordem;
```

**Ver o edital completo (usando a view):**
```sql
SELECT * FROM edital_completo LIMIT 100;
```

## Estrutura das Tabelas

### Tabela `materias`
- `id` - Identificador único (slug)
- `slug` - Slug para URLs (ex: "lingua-portuguesa")
- `name` - Nome da matéria
- `type` - "CONHECIMENTOS GERAIS" ou "CONHECIMENTOS ESPECÍFICOS"
- `ordem` - Ordem de exibição

### Tabela `topics`
- `id` - Identificador único (ex: "lingua-portuguesa.1")
- `materia_id` - Referência à matéria
- `title` - Título do tópico
- `ordem` - Ordem dentro da matéria

### Tabela `subtopics`
- `id` - Identificador único (ex: "lingua-portuguesa.1.1")
- `topic_id` - Referência ao tópico pai (se for subtópico de 1º nível)
- `parent_id` - Referência ao subtópico pai (se for subtópico de 2º+ nível)
- `title` - Título do subtópico
- `ordem` - Ordem dentro do pai

## IDs dos Itens

Os IDs seguem um padrão hierárquico:
- Matéria: `lingua-portuguesa`
- Tópico: `lingua-portuguesa.1`
- Subtópico nível 1: `lingua-portuguesa.1.1`
- Subtópico nível 2: `lingua-portuguesa.1.1.1`

Isso permite:
- Rastrear progresso de forma precisa
- Navegar pela hierarquia facilmente
- Manter compatibilidade com o sistema atual

## Próximos Passos (Opcional)

Se quiser servir o edital dinamicamente do banco de dados:

1. Adicionar endpoints no backend para buscar o edital
2. Atualizar o frontend para consumir a API
3. Remover o edital hardcoded do `src/data/edital.ts`

## Troubleshooting

**Erro: "Could not find the table 'public.materias'"**
- Certifique-se de executar o `supabase-edital-schema.sql` primeiro

**Erro: "violates foreign key constraint"**
- Execute o script de migração novamente (ele limpa as tabelas primeiro)

**Arquivo não encontrado**
- Verifique se o arquivo do edital está em `attached_assets/`
