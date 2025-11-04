/**
 * Rotas da aplicação
 */
export const ROUTES = {
  HOME: '/',
  DASHBOARD: '/',
  MATERIA: '/materia/:slug',
  getMateriaPath: (slug: string) => `/materia/${slug}`
} as const
