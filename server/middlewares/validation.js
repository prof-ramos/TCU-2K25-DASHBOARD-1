const { z } = require('zod')

// Schema para validar array de IDs de progresso
const progressIdsSchema = z.object({
  ids: z.array(z.string().min(1, 'ID não pode ser vazio'))
    .min(1, 'Array de IDs não pode ser vazio')
    .max(1000, 'Máximo de 1000 IDs por requisição')
})

// Schema para validar requisição do Gemini
const geminiRequestSchema = z.object({
  topicTitle: z.string()
    .min(1, 'topicTitle é obrigatório')
    .max(500, 'topicTitle não pode ter mais de 500 caracteres')
})

// Middleware genérico para validar body com Zod
function validateBody(schema) {
  return (req, res, next) => {
    try {
      // Validar e parsear o body
      const validated = schema.parse(req.body)

      // Substituir req.body pelo body validado
      req.body = validated

      next()
    } catch (error) {
      // Se for erro de validação do Zod
      if (error instanceof z.ZodError) {
        return res.status(400).json({
          error: 'Dados inválidos',
          details: error.errors.map(err => ({
            field: err.path.join('.'),
            message: err.message
          }))
        })
      }

      // Outros erros
      console.error('Erro na validação:', error)
      return res.status(500).json({
        error: 'Erro interno ao validar requisição'
      })
    }
  }
}

// Exportar schemas e middleware
module.exports = {
  progressIdsSchema,
  geminiRequestSchema,
  validateBody
}
