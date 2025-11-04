# 📚 Documentação do TCU TI 2025 Study Dashboard

Bem-vindo à documentação completa do projeto! Aqui você encontrará tudo o que precisa para entender, instalar, desenvolver e contribuir com o dashboard.

---

## 🗺️ Navegação Rápida

### Para Usuários

| Documento | Descrição | Tempo de Leitura |
|-----------|-----------|------------------|
| [📖 README Principal](../README.md) | Visão geral, features e quick start | 5 min |
| [📘 Guia de Instalação](./INSTALLATION.md) | Instruções detalhadas de instalação | 10 min |
| [❓ FAQ](./FAQ.md) | Perguntas frequentes | 5 min |

### Para Desenvolvedores

| Documento | Descrição | Tempo de Leitura |
|-----------|-----------|------------------|
| [💻 Guia de Desenvolvimento](./DEVELOPMENT.md) | Setup, padrões e workflow | 15 min |
| [🏗️ Arquitetura](./ARCHITECTURE.md) | Arquitetura técnica e decisões | 20 min |
| [🧪 Testes](./TESTING.md) | Estratégia de testes e como executar | 15 min |
| [🔌 API Reference](./API.md) | Documentação das APIs | 10 min |

### Para Contribuidores

| Documento | Descrição | Tempo de Leitura |
|-----------|-----------|------------------|
| [🤝 Guia de Contribuição](./CONTRIBUTING.md) | Como contribuir com o projeto | 10 min |
| [📜 Código de Conduta](../CODE_OF_CONDUCT.md) | Regras de convivência | 5 min |
| [📝 Changelog](../CHANGELOG.md) | Histórico de versões | 5 min |

---

## 🎯 Guias por Objetivo

### "Quero usar a aplicação"

1. Leia o [README Principal](../README.md) para entender o projeto
2. Siga o [Guia de Instalação Básica](./INSTALLATION.md#instalação-básica-frontend-only)
3. Consulte o [FAQ](./FAQ.md) se tiver dúvidas

### "Quero desenvolver uma feature"

1. Configure o ambiente com o [Guia de Instalação Completa](./INSTALLATION.md#instalação-completa-frontend--backend)
2. Leia o [Guia de Desenvolvimento](./DEVELOPMENT.md)
3. Entenda a [Arquitetura](./ARCHITECTURE.md)
4. Veja como [Contribuir](./CONTRIBUTING.md)
5. Execute os [Testes](./TESTING.md)

### "Quero corrigir um bug"

1. Reproduza o bug localmente (veja [Instalação](./INSTALLATION.md))
2. Consulte [Troubleshooting](./INSTALLATION.md#solução-de-problemas)
3. Leia sobre [Debugging](./DEVELOPMENT.md#debugging)
4. Execute [Testes](./TESTING.md) relacionados
5. Siga o [Processo de PR](./CONTRIBUTING.md#processo-de-pull-request)

### "Quero entender como funciona"

1. Comece pela [Visão Geral](../README.md#-sobre-o-projeto)
2. Explore a [Arquitetura de Alto Nível](./ARCHITECTURE.md#arquitetura-de-alto-nível)
3. Veja o [Fluxo de Dados](./ARCHITECTURE.md#fluxo-de-dados)
4. Consulte a [API Reference](./API.md)

---

## 📖 Índice Detalhado

### 1. Instalação e Configuração

- **[Guia de Instalação](./INSTALLATION.md)**
  - Pré-requisitos
  - Instalação Básica (Frontend Only)
  - Instalação Completa (Frontend + Backend)
  - Configuração de Variáveis de Ambiente
  - Deploy em Produção
  - Solução de Problemas

### 2. Arquitetura e Design

- **[Documentação de Arquitetura](./ARCHITECTURE.md)**
  - Visão Geral do Sistema
  - Arquitetura de Alto Nível
  - Frontend (React + TypeScript)
  - Backend (Express + Supabase)
  - Banco de Dados (Schema e Relacionamentos)
  - Integrações (Gemini AI, Supabase)
  - Fluxo de Dados
  - Decisões Técnicas
  - Padrões de Código
  - Segurança e Performance

### 3. Desenvolvimento

- **[Guia de Desenvolvimento](./DEVELOPMENT.md)**
  - Configuração do Ambiente
  - Estrutura do Código
  - Padrões de Desenvolvimento
  - Criando Novos Componentes
  - Trabalhando com Estado
  - Integrações com APIs
  - Estilização (Tailwind CSS)
  - Debugging
  - Boas Práticas

### 4. Testes

- **[Documentação de Testes](./TESTING.md)**
  - Visão Geral da Estratégia
  - Estrutura de Testes
  - Tipos de Testes (Unit, Integration, E2E)
  - Executando Testes
  - Escrevendo Testes
  - Mocking (MSW, Vitest)
  - Cobertura de Código
  - CI/CD

### 5. API

- **[API Reference](./API.md)**
  - Autenticação
  - Endpoints
  - Modelos de Dados
  - Códigos de Status
  - Exemplos de Uso
  - Rate Limiting
  - Tratamento de Erros

### 6. Contribuição

- **[Guia de Contribuição](./CONTRIBUTING.md)**
  - Código de Conduta
  - Como Contribuir
  - Processo de Desenvolvimento
  - Padrões de Código
  - Convenção de Commits
  - Processo de Pull Request
  - Reportando Bugs
  - Sugerindo Melhorias

---

## 🔍 Recursos por Tecnologia

### React
- [Componentes](./DEVELOPMENT.md#criando-novos-componentes)
- [Hooks](./DEVELOPMENT.md#trabalhando-com-estado)
- [Context API](./ARCHITECTURE.md#estado-global-contexts)
- [Testes de Componentes](./TESTING.md#testes-de-componentes)

### TypeScript
- [Padrões](./DEVELOPMENT.md#typescript)
- [Types e Interfaces](./ARCHITECTURE.md#type-layer)
- [Type Safety](./ARCHITECTURE.md#decisões-técnicas)

### Tailwind CSS
- [Estilização](./DEVELOPMENT.md#estilização)
- [Variantes com CVA](./DEVELOPMENT.md#componentes-com-variantes-cva)
- [Utility Classes](./ARCHITECTURE.md#por-que-tailwind-css)

### Vite
- [Configuração](./INSTALLATION.md#instalação-básica-frontend-only)
- [Build](./DEVELOPMENT.md#scripts-úteis)
- [Performance](./ARCHITECTURE.md#performance)

### Supabase
- [Setup](./INSTALLATION.md#configure-o-banco-de-dados-supabase)
- [Schema](./ARCHITECTURE.md#banco-de-dados)
- [Integração](./API.md)

### Google Gemini
- [Configuração](./INSTALLATION.md#obtenha-api-key-do-google-gemini)
- [Uso](./ARCHITECTURE.md#google-gemini-api)
- [Exemplos](./API.md)

---

## 📊 Diagramas e Visualizações

### Arquitetura do Sistema
Veja o [diagrama de alto nível](./ARCHITECTURE.md#arquitetura-de-alto-nível)

### Fluxo de Dados
- [Marcação de Tópico](./ARCHITECTURE.md#marcação-de-tópico-como-completo)
- [Carregamento Inicial](./ARCHITECTURE.md#carregamento-inicial)

### Estrutura de Diretórios
- [Frontend](./ARCHITECTURE.md#estrutura-de-diretórios)
- [Backend](./ARCHITECTURE.md#estrutura)
- [Testes](./TESTING.md#estrutura-de-testes)

---

## 🆘 Ajuda e Suporte

### Precisa de Ajuda?

1. **Documentação**: Busque na documentação acima
2. **FAQ**: Consulte as [perguntas frequentes](./FAQ.md)
3. **Issues**: Veja [issues existentes](https://github.com/seu-usuario/tcu-ti-2025-study-dashboard/issues)
4. **Discussions**: Inicie uma [discussão](https://github.com/seu-usuario/tcu-ti-2025-study-dashboard/discussions)
5. **Contato**: seuemail@exemplo.com

### Encontrou um Bug?

1. Verifique se já foi reportado
2. Siga o [guia de bug report](./CONTRIBUTING.md#reportando-bugs)
3. Abra uma [nova issue](https://github.com/seu-usuario/tcu-ti-2025-study-dashboard/issues/new)

### Tem uma Sugestão?

1. Leia o [guia de feature request](./CONTRIBUTING.md#sugerindo-melhorias)
2. Abra uma [discussion](https://github.com/seu-usuario/tcu-ti-2025-study-dashboard/discussions/new)
3. Contribua com código!

---

## 📝 Convenções da Documentação

Esta documentação segue os seguintes padrões:

- ✅ **Markdown padrão** (CommonMark + GFM)
- 📋 **Índice** em todos os documentos longos
- 🔗 **Links internos** para navegação fácil
- 💡 **Exemplos de código** em todos os guias técnicos
- ⚠️ **Avisos** para informações importantes
- ✅ **Checklists** para processos passo-a-passo
- 📊 **Tabelas** para comparações e referências
- 🎨 **Emojis** para melhor escaneabilidade

---

## 🔄 Atualizações

Esta documentação é mantida ativamente e atualizada a cada release.

**Última atualização**: 29 de outubro de 2025 (v1.0.0)

**Próxima revisão planejada**: v1.1.0

---

## 🙏 Contribuindo com a Documentação

Documentação também precisa de contribuições! Se você encontrar:

- ❌ Erros ou typos
- 📝 Explicações confusas
- 🔗 Links quebrados
- 📚 Falta de exemplos
- 🌐 Necessidade de tradução

Por favor, [abra uma issue](https://github.com/seu-usuario/tcu-ti-2025-study-dashboard/issues) ou envie um PR!

---

## 📄 Licença

A documentação, assim como o projeto, está sob a [Licença MIT](../LICENSE).

---

<div align="center">

**[⬅ Voltar ao README Principal](../README.md)**

---

Feito com ❤️ para a comunidade de concurseiros TCU TI 2025

</div>
