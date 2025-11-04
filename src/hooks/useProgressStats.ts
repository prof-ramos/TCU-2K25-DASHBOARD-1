import { useCallback } from 'react'
import type { Materia, Edital, Topic, Subtopic } from '@/types/types'

/**
 * Hook para calcular estatísticas de progresso
 */
export function useProgressStats(completedItems: Set<string>) {
  const countLeafNodes = useCallback((items: (Topic | { subtopics?: any[] })[]): number => {
    let count = 0
    for (const item of items) {
      if (item.subtopics && item.subtopics.length > 0) {
        count += countLeafNodes(item.subtopics)
      } else {
        count++
      }
    }
    return count
  }, [])

  const getLeafIds = useCallback((item: Topic | Subtopic): string[] => {
    if (!item.subtopics || item.subtopics.length === 0) {
      return [item.id]
    }
    return item.subtopics.flatMap(getLeafIds)
  }, [])

  const getMateriaStats = useCallback((materia: Materia) => {
    const total = countLeafNodes(materia.topics)
    let completed = 0

    const checkCompleted = (items: any[]) => {
      for (const item of items) {
        if (item.subtopics && item.subtopics.length > 0) {
          checkCompleted(item.subtopics)
        } else {
          if (completedItems.has(item.id)) {
            completed++
          }
        }
      }
    }

    checkCompleted(materia.topics)
    const percentage = total > 0 ? (completed / total) * 100 : 0
    return { total, completed, percentage }
  }, [completedItems, countLeafNodes])

  const getGlobalStats = useCallback((edital: Edital) => {
    let total = 0
    let completed = 0
    edital.materias.forEach(materia => {
      const stats = getMateriaStats(materia)
      total += stats.total
      completed += stats.completed
    })
    const percentage = total > 0 ? (completed / total) * 100 : 0
    return { total, completed, percentage }
  }, [getMateriaStats])

  const getItemStatus = useCallback((item: Topic): 'completed' | 'partial' | 'incomplete' => {
    if (!item.subtopics || item.subtopics.length === 0) {
      return completedItems.has(item.id) ? 'completed' : 'incomplete'
    }

    const leafNodes = getLeafIds(item)
    const completedCount = leafNodes.filter(id => completedItems.has(id)).length

    if (completedCount === 0) return 'incomplete'
    if (completedCount === leafNodes.length) return 'completed'
    return 'partial'
  }, [completedItems, getLeafIds])

  return {
    countLeafNodes,
    getLeafIds,
    getMateriaStats,
    getGlobalStats,
    getItemStatus
  }
}
