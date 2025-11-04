// Middleware centralizado de tratamento de erros
function errorHandler(err, req, res, next) {
  // Log do erro (em produção, use um logger estruturado como Winston)
  console.error('❌ Erro não tratado:', {
    message: err.message,
    stack: process.env.NODE_ENV === 'development' ? err.stack : undefined,
    url: req.url,
    method: req.method,
    timestamp: new Date().toISOString()
  })

  // Determinar código de status
  const statusCode = err.statusCode || err.status || 500

  // Resposta de erro padronizada
  res.status(statusCode).json({
    error: process.env.NODE_ENV === 'production'
      ? 'Erro interno do servidor'
      : err.message,
    ...(process.env.NODE_ENV === 'development' && {
      stack: err.stack,
      details: err
    })
  })
}

// Middleware para rotas não encontradas (404)
function notFoundHandler(req, res) {
  res.status(404).json({
    error: 'Rota não encontrada',
    path: req.url,
    method: req.method
  })
}

module.exports = {
  errorHandler,
  notFoundHandler
}
