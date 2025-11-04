# Docker Setup for TCU Dashboard

Este projeto inclui um setup completo de Docker com SQLite para facilitar o desenvolvimento e deployment.

## Arquitetura

- **Frontend**: React + TypeScript + Vite (porta 3000)
- **Backend API**: Node.js + Express + SQLite (porta 3001)
- **Database**: SQLite em container Docker com persistência

## Como usar

### Desenvolvimento

1. **Construir e iniciar todos os serviços:**
   ```bash
   docker-compose up --build
   ```

2. **Acessar a aplicação:**
   - Frontend: http://localhost:3000
   - API: http://localhost:3001

3. **Parar os serviços:**
   ```bash
   docker-compose down
   ```

### Produção

1. **Build para produção:**
   ```bash
   docker-compose -f docker-compose.yml up --build -d
   ```

2. **Ver logs:**
   ```bash
   docker-compose logs -f
   ```

## Volumes

- `sqlite_data`: Persiste os dados do SQLite entre restarts dos containers

## Comandos úteis

```bash
# Ver status dos containers
docker-compose ps

# Acessar shell do container da API
docker-compose exec api sh

# Acessar shell do container do banco
docker-compose exec db sh

# Ver logs específicos
docker-compose logs api
docker-compose logs db

# Reiniciar um serviço específico
docker-compose restart api
```

## API Endpoints

- `GET /api/progress` - Obter IDs completados
- `POST /api/progress` - Adicionar IDs completados
- `DELETE /api/progress` - Remover IDs completados
- `GET /health` - Health check

## Desenvolvimento local

Para desenvolvimento local sem Docker:

1. **Instalar dependências:**
   ```bash
   npm install
   npm install -g nodemon  # opcional para desenvolvimento da API
   ```

2. **Iniciar API:**
   ```bash
   npm run start:server  # ou nodemon server/index.js
   ```

3. **Iniciar frontend:**
   ```bash
   npm run dev
   ```

## Estrutura dos arquivos

```
.
├── Dockerfile              # Frontend container
├── Dockerfile.api          # API container
├── docker-compose.yml      # Orquestração dos serviços
├── nginx.conf             # Configuração do nginx
├── init-db.sql            # Inicialização do banco
├── server/                # Código da API
│   └── index.js
├── package-server.json    # Dependências da API
└── .dockerignore          # Arquivos ignorados no build
```