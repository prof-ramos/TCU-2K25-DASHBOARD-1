import { describe, it, expect, vi, beforeEach } from 'vitest';
import { renderHook, act, waitFor } from '@testing-library/react';
import { ProgressoProvider } from '@/contexts/ProgressoContext';
import { useProgresso } from '@/hooks/useProgresso';
import * as databaseService from '@/services/databaseService';
import { mockMateria, mockTopicWithSubtopics, mockTopicWithoutSubtopics, mockEdital } from '../mocks/mockData';

vi.mock('@/services/databaseService');

const wrapper = ({ children }: { children: React.ReactNode }) => (
  <ProgressoProvider>{children}</ProgressoProvider>
);

describe('ProgressoContext', () => {
  beforeEach(() => {
    vi.clearAllMocks();
    vi.mocked(databaseService.getCompletedIds).mockResolvedValue(new Set());
    vi.mocked(databaseService.addCompletedIds).mockResolvedValue(undefined);
    vi.mocked(databaseService.removeCompletedIds).mockResolvedValue(undefined);
  });

  describe('Initialization', () => {
    it('should load completed IDs from database on mount', async () => {
      const mockIds = new Set(['topic-1', 'topic-2']);
      vi.mocked(databaseService.getCompletedIds).mockResolvedValue(mockIds);

      const { result } = renderHook(() => useProgresso(), { wrapper });

      await waitFor(() => {
        expect(result.current.completedItems.size).toBe(2);
      });

      expect(result.current.completedItems.has('topic-1')).toBe(true);
      expect(result.current.completedItems.has('topic-2')).toBe(true);
    });

    it('should handle database errors gracefully', async () => {
      vi.mocked(databaseService.getCompletedIds).mockRejectedValue(new Error('DB Error'));

      const { result } = renderHook(() => useProgresso(), { wrapper });

      await waitFor(() => {
        expect(result.current.completedItems.size).toBe(0);
      });
    });
  });

  describe('toggleCompleted', () => {
    it('should mark a simple topic as completed', async () => {
      const { result } = renderHook(() => useProgresso(), { wrapper });

      await waitFor(() => {
        expect(result.current.completedItems.size).toBe(0);
      });

      act(() => {
        result.current.toggleCompleted(mockTopicWithoutSubtopics);
      });

      expect(result.current.completedItems.has(mockTopicWithoutSubtopics.id)).toBe(true);
      expect(databaseService.addCompletedIds).toHaveBeenCalledWith([mockTopicWithoutSubtopics.id]);
    });

    it('should mark all subtopics when completing a topic with subtopics', async () => {
      const { result } = renderHook(() => useProgresso(), { wrapper });

      await waitFor(() => {
        expect(result.current.completedItems.size).toBe(0);
      });

      act(() => {
        result.current.toggleCompleted(mockTopicWithSubtopics);
      });

      expect(result.current.completedItems.has('subtopic-1-1')).toBe(true);
      expect(result.current.completedItems.has('subtopic-1-2')).toBe(true);
      expect(databaseService.addCompletedIds).toHaveBeenCalledWith(['subtopic-1-1', 'subtopic-1-2']);
    });

    it('should unmark a completed topic', async () => {
      const initialIds = new Set([mockTopicWithoutSubtopics.id]);
      vi.mocked(databaseService.getCompletedIds).mockResolvedValue(initialIds);

      const { result } = renderHook(() => useProgresso(), { wrapper });

      await waitFor(() => {
        expect(result.current.completedItems.has(mockTopicWithoutSubtopics.id)).toBe(true);
      });

      act(() => {
        result.current.toggleCompleted(mockTopicWithoutSubtopics);
      });

      expect(result.current.completedItems.has(mockTopicWithoutSubtopics.id)).toBe(false);
      expect(databaseService.removeCompletedIds).toHaveBeenCalledWith([mockTopicWithoutSubtopics.id]);
    });

    it('should unmark all subtopics when uncompleting a topic', async () => {
      const initialIds = new Set(['subtopic-1-1', 'subtopic-1-2']);
      vi.mocked(databaseService.getCompletedIds).mockResolvedValue(initialIds);

      const { result } = renderHook(() => useProgresso(), { wrapper });

      await waitFor(() => {
        expect(result.current.completedItems.size).toBe(2);
      });

      act(() => {
        result.current.toggleCompleted(mockTopicWithSubtopics);
      });

      expect(result.current.completedItems.has('subtopic-1-1')).toBe(false);
      expect(result.current.completedItems.has('subtopic-1-2')).toBe(false);
      expect(databaseService.removeCompletedIds).toHaveBeenCalledWith(['subtopic-1-1', 'subtopic-1-2']);
    });
  });

  describe('getMateriaStats', () => {
    it('should calculate stats for materia with no completed items', async () => {
      const { result } = renderHook(() => useProgresso(), { wrapper });

      await waitFor(() => {
        expect(result.current.completedItems.size).toBe(0);
      });

      const stats = result.current.getMateriaStats(mockMateria);

      expect(stats.total).toBe(3);
      expect(stats.completed).toBe(0);
      expect(stats.percentage).toBe(0);
    });

    it('should calculate stats for partially completed materia', async () => {
      const initialIds = new Set(['subtopic-1-1']);
      vi.mocked(databaseService.getCompletedIds).mockResolvedValue(initialIds);

      const { result } = renderHook(() => useProgresso(), { wrapper });

      await waitFor(() => {
        expect(result.current.completedItems.size).toBe(1);
      });

      const stats = result.current.getMateriaStats(mockMateria);

      expect(stats.total).toBe(3);
      expect(stats.completed).toBe(1);
      expect(stats.percentage).toBeCloseTo(33.33, 1);
    });

    it('should calculate stats for fully completed materia', async () => {
      const initialIds = new Set(['subtopic-1-1', 'subtopic-1-2', 'topic-2']);
      vi.mocked(databaseService.getCompletedIds).mockResolvedValue(initialIds);

      const { result } = renderHook(() => useProgresso(), { wrapper });

      await waitFor(() => {
        expect(result.current.completedItems.size).toBe(3);
      });

      const stats = result.current.getMateriaStats(mockMateria);

      expect(stats.total).toBe(3);
      expect(stats.completed).toBe(3);
      expect(stats.percentage).toBe(100);
    });
  });

  describe('getGlobalStats', () => {
    it('should aggregate stats across all materias', async () => {
      const initialIds = new Set(['subtopic-1-1', 'topic-2']);
      vi.mocked(databaseService.getCompletedIds).mockResolvedValue(initialIds);

      const { result } = renderHook(() => useProgresso(), { wrapper });

      await waitFor(() => {
        expect(result.current.completedItems.size).toBe(2);
      });

      const stats = result.current.getGlobalStats(mockEdital);

      expect(stats.total).toBe(3);
      expect(stats.completed).toBe(2);
      expect(stats.percentage).toBeCloseTo(66.67, 1);
    });
  });

  describe('getItemStatus', () => {
    it('should return "incomplete" for uncompleted topic without subtopics', async () => {
      const { result } = renderHook(() => useProgresso(), { wrapper });

      await waitFor(() => {
        expect(result.current.completedItems.size).toBe(0);
      });

      const status = result.current.getItemStatus(mockTopicWithoutSubtopics);

      expect(status).toBe('incomplete');
    });

    it('should return "completed" for completed topic without subtopics', async () => {
      const initialIds = new Set([mockTopicWithoutSubtopics.id]);
      vi.mocked(databaseService.getCompletedIds).mockResolvedValue(initialIds);

      const { result } = renderHook(() => useProgresso(), { wrapper });

      await waitFor(() => {
        expect(result.current.completedItems.size).toBe(1);
      });

      const status = result.current.getItemStatus(mockTopicWithoutSubtopics);

      expect(status).toBe('completed');
    });

    it('should return "partial" for topic with some subtopics completed', async () => {
      const initialIds = new Set(['subtopic-1-1']);
      vi.mocked(databaseService.getCompletedIds).mockResolvedValue(initialIds);

      const { result } = renderHook(() => useProgresso(), { wrapper });

      await waitFor(() => {
        expect(result.current.completedItems.size).toBe(1);
      });

      const status = result.current.getItemStatus(mockTopicWithSubtopics);

      expect(status).toBe('partial');
    });

    it('should return "completed" for topic with all subtopics completed', async () => {
      const initialIds = new Set(['subtopic-1-1', 'subtopic-1-2']);
      vi.mocked(databaseService.getCompletedIds).mockResolvedValue(initialIds);

      const { result } = renderHook(() => useProgresso(), { wrapper });

      await waitFor(() => {
        expect(result.current.completedItems.size).toBe(2);
      });

      const status = result.current.getItemStatus(mockTopicWithSubtopics);

      expect(status).toBe('completed');
    });

    it('should return "incomplete" for topic with no subtopics completed', async () => {
      const { result } = renderHook(() => useProgresso(), { wrapper });

      await waitFor(() => {
        expect(result.current.completedItems.size).toBe(0);
      });

      const status = result.current.getItemStatus(mockTopicWithSubtopics);

      expect(status).toBe('incomplete');
    });
  });
});
