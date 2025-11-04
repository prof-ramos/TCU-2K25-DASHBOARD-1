/**
 * Chaves do localStorage usadas na aplicação
 */
export const STORAGE_KEYS = {
  THEME: 'theme',
  PROGRESS: 'progress',
  COMPLETED_ITEMS: 'completedItems'
} as const

export type StorageKey = typeof STORAGE_KEYS[keyof typeof STORAGE_KEYS]
