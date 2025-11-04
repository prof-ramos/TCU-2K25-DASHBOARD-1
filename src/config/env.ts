/// <reference types="vite/client" />

/**
 * Configuração de variáveis de ambiente
 */

export const env = {
  // API URL - empty string in production (use relative paths), localhost in dev
  apiUrl: import.meta.env.VITE_API_URL || (import.meta.env.PROD ? '' : 'http://localhost:3001'),

  // Ambiente
  isDevelopment: import.meta.env.DEV,
  isProduction: import.meta.env.PROD,

  // Mode
  mode: import.meta.env.MODE
} as const

// Validação de variáveis críticas
export function validateEnv() {
  // Environment validation can be added here if needed
  return true
}
