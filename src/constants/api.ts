/// <reference types="vite/client" />

/**
 * Constantes de configuração da API
 */

// Base URL da API backend
export const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:3001'

// Endpoints da API
export const API_ENDPOINTS = {
  PROGRESS: '/api/progress',
  HEALTH: '/health'
} as const

// Configuração do timeout de requisições (ms)
export const API_TIMEOUT = 5000

// Headers padrão
export const DEFAULT_HEADERS = {
  'Content-Type': 'application/json'
} as const
