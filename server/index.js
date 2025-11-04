require('dotenv').config()
const express = require('express')
const cors = require('cors')
const helmet = require('helmet')
const rateLimit = require('express-rate-limit')
const { GoogleGenAI } = require('@google/genai')

// Importar configurações e middlewares
const { supabase, testConnection } = require('./config/supabase')
const { validateBody, progressIdsSchema, geminiRequestSchema } = require('./middlewares/validation')
const { errorHandler, notFoundHandler } = require('./middlewares/errorHandler')

// Inicializar Express
const app = express()
const PORT = process.env.PORT || 3001

// =====================================================
// MIDDLEWARES DE SEGURANÇA
// =====================================================

// Helmet - Headers de segurança
app.use(helmet({
  crossOriginResourcePolicy: { policy: 'cross-origin' }
}))

// CORS - Configuração restritiva
const corsOptions = {
  origin: process.env.CORS_ORIGIN || 'http://localhost:3000',
  methods: ['GET', 'POST', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: true,
  maxAge: 86400 // 24 horas
}
app.use(cors(corsOptions))

// Rate Limiting - Proteção contra abuso
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutos
  max: 100, // 100 requisições por IP
  message: {
    error: 'Muitas requisições deste IP, tente novamente em 15 minutos'
  },
  standardHeaders: true,
  legacyHeaders: false
})
app.use(limiter)

// Rate limiting específico para Gemini (mais restritivo)
const geminiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutos
  max: 20, // 20 requisições de IA por IP
  message: {
    error: 'Limite de requisições de IA atingido, tente novamente em 15 minutos'
  }
})

// Body parser
app.use(express.json({ limit: '10mb' }))

// =====================================================
// INICIALIZAÇÃO
// =====================================================

// Inicializar Gemini AI
let ai
try {
  if (!process.env.GEMINI_API_KEY) {
    console.warn('⚠️ GEMINI_API_KEY não configurada - endpoint /api/gemini-proxy estará indisponível')
  } else {
    ai = new GoogleGenAI({ apiKey: process.env.GEMINI_API_KEY })
    console.log('✅ Google Gemini AI inicializado')
  }
} catch (error) {
  console.error('❌ Erro ao inicializar Gemini AI:', error.message)
}

// =====================================================
// HEALTH CHECK
// =====================================================

app.get('/health', async (req, res) => {
  const health = {
    status: 'OK',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: process.env.NODE_ENV || 'development'
  }

  // Testar conexão com Supabase
  try {
    const { error } = await supabase
      .from('progress')
      .select('count')
      .limit(1)

    health.database = error ? 'error' : 'connected'
    if (error) health.databaseError = error.message
  } catch (err) {
    health.database = 'error'
    health.databaseError = err.message
  }

  // Status 503 se banco não estiver conectado
  const statusCode = health.database === 'error' ? 503 : 200

  res.status(statusCode).json(health)
})

// =====================================================
// ROTAS DE PROGRESSO (Supabase)
// =====================================================

// GET /api/progress - Buscar todos os IDs de progresso
app.get('/api/progress', async (req, res, next) => {
  try {
    const { data, error } = await supabase
      .from('progress')
      .select('item_id')
      .order('completed_at', { ascending: false })

    if (error) {
      console.error('Erro ao buscar progresso:', error)
      return res.status(500).json({
        error: 'Erro ao buscar progresso do banco de dados',
        details: process.env.NODE_ENV === 'development' ? error.message : undefined
      })
    }

    // Retornar array de IDs (compatível com frontend)
    const completedIds = data.map(row => row.item_id)

    res.json({ completedIds })
  } catch (error) {
    next(error)
  }
})

// POST /api/progress - Adicionar IDs de progresso
app.post('/api/progress', validateBody(progressIdsSchema), async (req, res, next) => {
  try {
    const { ids } = req.body

    // Inserir ou ignorar se já existir (upsert)
    const records = ids.map(id => ({ item_id: id }))

    const { data, error } = await supabase
      .from('progress')
      .upsert(records, {
        onConflict: 'item_id',
        ignoreDuplicates: true
      })

    if (error) {
      console.error('Erro ao adicionar progresso:', error)
      return res.status(500).json({
        error: 'Erro ao salvar progresso no banco de dados',
        details: process.env.NODE_ENV === 'development' ? error.message : undefined
      })
    }

    res.json({
      message: 'Progresso atualizado com sucesso',
      added: ids.length
    })
  } catch (error) {
    next(error)
  }
})

// DELETE /api/progress - Remover IDs de progresso
app.delete('/api/progress', validateBody(progressIdsSchema), async (req, res, next) => {
  try {
    const { ids } = req.body

    const { data, error } = await supabase
      .from('progress')
      .delete()
      .in('item_id', ids)

    if (error) {
      console.error('Erro ao remover progresso:', error)
      return res.status(500).json({
        error: 'Erro ao remover progresso do banco de dados',
        details: process.env.NODE_ENV === 'development' ? error.message : undefined
      })
    }

    res.json({
      message: 'Progresso removido com sucesso',
      removed: ids.length
    })
  } catch (error) {
    next(error)
  }
})

// =====================================================
// GEMINI PROXY (mantido no backend para segurança)
// =====================================================

app.post('/api/gemini-proxy', geminiLimiter, validateBody(geminiRequestSchema), async (req, res, next) => {
  try {
    // Verificar se Gemini está disponível
    if (!ai) {
      return res.status(503).json({
        error: 'Serviço de IA temporariamente indisponível',
        message: 'Gemini API não está configurada'
      })
    }

    const { topicTitle } = req.body

    // Prompt otimizado para TCU
    const prompt = `Para um candidato estudando para o concurso 'TCU - Auditor Federal de Controle Externo - Tecnologia da Informação' no Brasil, forneça uma explicação concisa e clara sobre o seguinte tópico: "${topicTitle}".

Foque em:
- Conceitos-chave e definições
- Aplicações práticas relevantes para auditoria de TI
- Pontos importantes para o concurso

Use Google Search para garantir informações atualizadas e precisas.`

    const response = await ai.models.generateContent({
      model: 'gemini-2.0-flash-exp',
      contents: [{ role: 'user', parts: [{ text: prompt }] }],
      config: {
        tools: [{ googleSearch: {} }]
      }
    })

    const summary = response.text
    const groundingChunks = response.candidates?.[0]?.groundingMetadata?.groundingChunks || []

    res.json({
      summary,
      sources: groundingChunks
    })
  } catch (error) {
    console.error('Erro no Gemini proxy:', error)

    // Tratamento específico para erros da API do Gemini
    if (error.message?.includes('API key')) {
      return res.status(401).json({
        error: 'Erro de autenticação com Gemini API',
        message: 'Chave de API inválida ou expirada'
      })
    }

    if (error.message?.includes('quota')) {
      return res.status(429).json({
        error: 'Cota da API excedida',
        message: 'Limite de requisições do Gemini atingido, tente novamente mais tarde'
      })
    }

    next(error)
  }
})

// =====================================================
// MIDDLEWARES DE ERRO (devem ser os últimos)
// =====================================================

// 404 - Rota não encontrada
app.use(notFoundHandler)

// Error handler centralizado
app.use(errorHandler)

// =====================================================
// INICIALIZAÇÃO DO SERVIDOR
// =====================================================

async function startServer() {
  // Testar conexão com Supabase antes de iniciar
  const isConnected = await testConnection()

  if (!isConnected) {
    console.error('⚠️ Aviso: Não foi possível conectar ao Supabase')
    console.error('Verifique suas variáveis de ambiente: SUPABASE_URL e SUPABASE_SERVICE_ROLE')
    if (process.env.NODE_ENV === 'production') {
      process.exit(1) // Falhar em produção se DB não estiver disponível
    }
  }

  // Iniciar servidor
  app.listen(PORT, () => {
    console.log('='.repeat(50))
    console.log('🚀 TCU Dashboard API Server')
    console.log('='.repeat(50))
    console.log(`📡 Servidor rodando na porta: ${PORT}`)
    console.log(`🌍 Ambiente: ${process.env.NODE_ENV || 'development'}`)
    console.log(`🗄️  Banco de dados: Supabase ${isConnected ? '✅' : '⚠️'}`)
    console.log(`🤖 Gemini AI: ${ai ? '✅' : '⚠️'}`)
    console.log(`🔒 Segurança: Helmet + Rate Limiting habilitados`)
    console.log('='.repeat(50))
  })
}

// Graceful shutdown
process.on('SIGINT', () => {
  console.log('\n🛑 Encerrando servidor...')
  process.exit(0)
})

process.on('SIGTERM', () => {
  console.log('\n🛑 Encerrando servidor...')
  process.exit(0)
})

// Iniciar
startServer().catch(error => {
  console.error('❌ Erro fatal ao iniciar servidor:', error)
  process.exit(1)
})
