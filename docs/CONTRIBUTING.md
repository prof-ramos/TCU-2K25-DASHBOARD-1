# 🤝 Guia de Contribuição

> Como contribuir para o TCU TI 2025 Study Dashboard

Obrigado por considerar contribuir para este projeto! Contribuições da comunidade são essenciais para tornar este dashboard cada vez melhor.

---

## 📋 Índice

- [Código de Conduta](#código-de-conduta)
- [Como Posso Contribuir?](#como-posso-contribuir)
- [Primeiros Passos](#primeiros-passos)
- [Processo de Desenvolvimento](#processo-de-desenvolvimento)
- [Padrões de Código](#padrões-de-código)
- [Processo de Pull Request](#processo-de-pull-request)
- [Reportando Bugs](#reportando-bugs)
- [Sugerindo Melhorias](#sugerindo-melhorias)

---

## Código de Conduta

Este projeto segue um Código de Conduta. Ao participar, você concorda em manter um ambiente respeitoso e acolhedor para todos.

### Nossos Padrões

**Comportamentos incentivados:**
- ✅ Usar linguagem acolhedora e inclusiva
- ✅ Respeitar pontos de vista diferentes
- ✅ Aceitar críticas construtivas
- ✅ Focar no que é melhor para a comunidade
- ✅ Mostrar empatia com outros membros

**Comportamentos não aceitáveis:**
- ❌ Linguagem ou imagens sexualizadas
- ❌ Comentários insultuosos ou depreciativos
- ❌ Assédio público ou privado
- ❌ Publicar informações privadas de outros sem permissão
- ❌ Outras condutas consideradas inadequadas em contexto profissional

---

## Como Posso Contribuir?

### 🐛 Reportar Bugs

Encontrou um bug? Ajude-nos a melhorar reportando!

1. Verifique se o bug já foi reportado em [Issues](https://github.com/seu-usuario/tcu-ti-2025-study-dashboard/issues)
2. Se não encontrar, [abra uma nova issue](https://github.com/seu-usuario/tcu-ti-2025-study-dashboard/issues/new)
3. Use o template de bug report
4. Forneça o máximo de informações possível

### 💡 Sugerir Novas Features

Tem uma ideia para melhorar o projeto?

1. Verifique se já não existe uma issue similar
2. Abra uma [Discussion](https://github.com/seu-usuario/tcu-ti-2025-study-dashboard/discussions) para discutir a ideia
3. Se houver consenso, crie uma issue detalhada
4. Aguarde feedback dos mantenedores

### 📝 Melhorar Documentação

Documentação é crucial! Contribuições podem incluir:
- Corrigir typos ou erros
- Adicionar exemplos
- Melhorar explicações
- Traduzir documentação
- Criar tutoriais

### 💻 Contribuir com Código

Tipos de contribuições de código bem-vindas:
- Correção de bugs
- Novas features (discutidas previamente)
- Melhorias de performance
- Refatoração de código
- Adicionar testes
- Melhorar acessibilidade

---

## Primeiros Passos

### 1. Fork do Repositório

```bash
# Clone seu fork
git clone https://github.com/seu-usuario/tcu-ti-2025-study-dashboard.git
cd tcu-ti-2025-study-dashboard

# Adicione o repositório original como upstream
git remote add upstream https://github.com/original/tcu-ti-2025-study-dashboard.git
```

### 2. Configure o Ambiente

```bash
# Instale dependências
npm install

# Configure variáveis de ambiente
cp .env.example .env
# Edite .env com suas credenciais

# Inicie o desenvolvimento
npm run dev
```

### 3. Crie uma Branch

```bash
# Atualize main
git checkout main
git pull upstream main

# Crie uma branch para sua feature/fix
git checkout -b feature/minha-feature
# ou
git checkout -b fix/corrigir-bug
```

---

## Processo de Desenvolvimento

### Workflow de Desenvolvimento

```
1. Escolha uma Issue
   ↓
2. Comente na issue que vai trabalhar nela
   ↓
3. Crie uma branch
   ↓
4. Desenvolva e teste localmente
   ↓
5. Commit com mensagens descritivas
   ↓
6. Push para seu fork
   ↓
7. Abra Pull Request
   ↓
8. Responda aos code reviews
   ↓
9. Merge! 🎉
```

### Convenção de Commits

Usamos [Conventional Commits](https://www.conventionalcommits.org/):

```bash
# Features
git commit -m "feat: adiciona filtro por matéria no dashboard"
git commit -m "feat(ui): implementa novo componente de badge"

# Correções
git commit -m "fix: corrige cálculo de progresso"
git commit -m "fix(mobile): resolve problema de layout no iOS"

# Documentação
git commit -m "docs: atualiza guia de instalação"
git commit -m "docs(api): adiciona exemplo de uso"

# Refatoração
git commit -m "refactor: simplifica lógica de ProgressoContext"

# Testes
git commit -m "test: adiciona testes para MateriaCard"

# Performance
git commit -m "perf: otimiza renderização de listas grandes"

# Chores
git commit -m "chore: atualiza dependências"
git commit -m "chore(ci): configura GitHub Actions"
```

**Formato:**
```
<tipo>(<escopo>): <descrição curta>

[corpo opcional com mais detalhes]

[footer opcional com breaking changes ou issues]
```

**Tipos:**
- `feat`: Nova feature
- `fix`: Correção de bug
- `docs`: Apenas documentação
- `style`: Formatação (não afeta código)
- `refactor`: Refatoração (sem mudar comportamento)
- `perf`: Melhoria de performance
- `test`: Adicionar/corrigir testes
- `chore`: Tarefas de manutenção

### Nomenclatura de Branches

```bash
# Features
feature/nome-da-feature
feature/filtro-materias
feature/exportar-progresso

# Correções
fix/nome-do-bug
fix/calculo-progresso
fix/layout-mobile

# Documentação
docs/nome-da-doc
docs/guia-contribuicao
docs/api-reference

# Refatoração
refactor/nome-da-refatoracao
refactor/progresso-context
```

---

## Padrões de Código

### TypeScript

```typescript
// ✅ BOM: Tipos explícitos
interface UserProgress {
  userId: string;
  completedIds: string[];
  lastUpdated: Date;
}

function saveProgress(progress: UserProgress): Promise<void> {
  // ...
}

// ❌ RUIM: any
function saveProgress(progress: any) {
  // ...
}
```

### React Components

```typescript
// ✅ BOM: Componente funcional tipado
interface ButtonProps {
  children: React.ReactNode;
  variant?: 'primary' | 'secondary';
  onClick?: () => void;
}

export const Button: React.FC<ButtonProps> = ({ 
  children, 
  variant = 'primary',
  onClick 
}) => {
  return (
    <button 
      className={cn('btn', `btn-${variant}`)}
      onClick={onClick}
    >
      {children}
    </button>
  );
};

// ❌ RUIM: Sem tipos
export const Button = (props) => {
  return <button>{props.children}</button>;
};
```

### Nomeação

```typescript
// Componentes: PascalCase
const MateriaCard = () => {};

// Hooks: camelCase com prefixo "use"
const useProgresso = () => {};

// Funções: camelCase
const calculateProgress = () => {};

// Constantes: UPPER_SNAKE_CASE
const API_BASE_URL = 'http://localhost:3001';

// Tipos/Interfaces: PascalCase
interface Materia {}
type Theme = 'light' | 'dark';
```

### Imports

```typescript
// Ordem de imports
import React, { useState } from 'react';           // 1. React
import { useNavigate } from 'react-router-dom';    // 2. Bibliotecas externas
import { Button } from '@/components/ui/button';   // 3. Componentes internos
import { useProgresso } from '@/hooks/useProgresso'; // 4. Hooks/Contexts
import type { Materia } from '@/types/types';      // 5. Types
```

### Comentários

```typescript
// ✅ BOM: Comentários úteis
/**
 * Calcula a porcentagem de progresso baseado nos tópicos completados
 * @param topics - Lista de todos os tópicos
 * @param completedIds - Set de IDs completados
 * @returns Porcentagem de 0 a 100
 */
function calculateProgress(topics: Topic[], completedIds: Set<string>): number {
  // Implementação...
}

// ❌ RUIM: Comentários óbvios
// Incrementa i em 1
i++;

// Retorna true
return true;
```

---

## Processo de Pull Request

### Checklist Antes de Abrir PR

- [ ] Código segue os padrões do projeto
- [ ] Testes passam localmente (`npm test`)
- [ ] Novos testes foram adicionados (se aplicável)
- [ ] Documentação foi atualizada (se aplicável)
- [ ] Commits seguem a convenção
- [ ] Branch está atualizada com `main`
- [ ] Não há conflitos

### Template de Pull Request

```markdown
## Descrição
Breve descrição do que foi implementado/corrigido.

## Tipo de Mudança
- [ ] Bug fix (correção que resolve uma issue)
- [ ] Nova feature (adiciona funcionalidade)
- [ ] Breaking change (quebra compatibilidade)
- [ ] Documentação

## Como Testar
1. Clone esta branch
2. Execute `npm install`
3. Execute `npm run dev`
4. Navegue para [página específica]
5. Verifique se [comportamento esperado]

## Screenshots (se aplicável)
Adicione screenshots para mudanças visuais.

## Checklist
- [ ] Meu código segue os padrões do projeto
- [ ] Fiz self-review do código
- [ ] Comentei partes complexas
- [ ] Atualizei a documentação
- [ ] Não gerei warnings
- [ ] Adicionei testes
- [ ] Todos os testes passam

## Issues Relacionadas
Closes #123
Fixes #456
```

### Code Review

**Para revisores:**
- ✅ Seja construtivo e respeitoso
- ✅ Explique o "porquê" das sugestões
- ✅ Aprecie o esforço do contribuidor
- ✅ Teste o código localmente
- ✅ Verifique se segue os padrões

**Para autores:**
- ✅ Responda todas as sugestões
- ✅ Faça perguntas se não entender
- ✅ Seja aberto a mudanças
- ✅ Agradeça o feedback

---

## Reportando Bugs

### Template de Bug Report

```markdown
**Descrição do Bug**
Descrição clara e concisa do bug.

**Para Reproduzir**
Passos para reproduzir:
1. Vá para '...'
2. Clique em '...'
3. Role até '...'
4. Veja o erro

**Comportamento Esperado**
O que deveria acontecer.

**Comportamento Atual**
O que está acontecendo.

**Screenshots**
Se aplicável, adicione screenshots.

**Ambiente:**
 - OS: [ex: Windows 10, macOS 13]
 - Browser: [ex: Chrome 120, Safari 17]
 - Versão do Node: [ex: 20.10.0]
 - Versão do projeto: [ex: 1.0.0]

**Contexto Adicional**
Qualquer outra informação relevante.

**Logs de Console**
```
[Cole logs de erro aqui]
```
```

---

## Sugerindo Melhorias

### Template de Feature Request

```markdown
**A feature está relacionada a um problema?**
Ex: Fico frustrado quando [...]

**Descreva a solução que você gostaria**
Descrição clara da feature proposta.

**Descreva alternativas consideradas**
Outras soluções ou features que você considerou.

**Contexto Adicional**
Screenshots, mockups, links, etc.

**Impacto**
- [ ] Alta prioridade (funcionalidade crítica)
- [ ] Média prioridade (melhoria significativa)
- [ ] Baixa prioridade (nice to have)
```

---

## Configuração de Ambiente Completa

### Ferramentas Recomendadas

- **VSCode** com extensões:
  - ESLint
  - Prettier
  - TypeScript and JavaScript Language Features
  - Tailwind CSS IntelliSense
  - GitLens

### Scripts Úteis

```bash
# Desenvolvimento
npm run dev              # Inicia dev server
npm run build            # Build para produção
npm run preview          # Preview do build

# Qualidade
npm run lint             # Verifica erros
npm run lint:fix         # Corrige erros automaticamente
npm run format           # Formata código

# Testes
npm test                 # Testes em watch mode
npm run test:run         # Testa uma vez
npm run test:coverage    # Com cobertura
```

---

## Obtendo Ajuda

### Onde Pedir Ajuda

1. **Documentação**: Leia a [documentação completa](../README.md)
2. **Issues**: Busque em [issues existentes](https://github.com/seu-usuario/tcu-ti-2025-study-dashboard/issues)
3. **Discussions**: Inicie uma [discussion](https://github.com/seu-usuario/tcu-ti-2025-study-dashboard/discussions)
4. **Discord/Slack**: [Link para comunidade] (se houver)

### Perguntas Frequentes

**Q: Como atualizo meu fork?**
```bash
git checkout main
git pull upstream main
git push origin main
```

**Q: Meu PR foi rejeitado, e agora?**
- Leia o feedback com atenção
- Faça as mudanças solicitadas
- Responda aos comentários
- Push as mudanças (serão adicionadas ao PR automaticamente)

**Q: Posso trabalhar em múltiplas issues?**
- Sim, mas crie branches separadas para cada uma
- Foque em finalizar uma antes de começar outra

---

## Reconhecimento

Contribuidores serão reconhecidos:
- ✨ Listados em [CONTRIBUTORS.md](./CONTRIBUTORS.md)
- 🎖️ Mencionados nas release notes
- 🙏 Agradecidos publicamente

---

## Licença

Ao contribuir, você concorda que suas contribuições serão licenciadas sob a mesma licença do projeto (MIT License).

---

## Obrigado! 🎉

Sua contribuição, não importa quão pequena, faz diferença. Obrigado por ajudar a tornar este projeto melhor para todos!

---

[⬅ Voltar](../README.md) | [💻 Desenvolvimento](./DEVELOPMENT.md) | [🧪 Testes](./TESTING.md)
