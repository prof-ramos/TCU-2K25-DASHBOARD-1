import { describe, it, expect, beforeEach, afterEach } from 'vitest';
import { server } from '../mocks/server';
import { errorHandlers } from '../mocks/handlers';
import { getCompletedIds, addCompletedIds, removeCompletedIds } from '@/services/databaseService';

describe('databaseService', () => {
  beforeEach(() => {
    localStorage.clear();
  });

  afterEach(() => {
    server.resetHandlers();
  });

  describe('getCompletedIds', () => {
    it('should fetch completed IDs from API successfully', async () => {
      const result = await getCompletedIds();
      
      expect(result).toBeInstanceOf(Set);
      expect(result.has('topic-1')).toBe(true);
      expect(result.has('subtopic-1-1')).toBe(true);
      expect(result.size).toBe(2);
    });

    it('should fallback to localStorage when API fails', async () => {
      server.use(...errorHandlers);
      
      localStorage.setItem('studyProgress', JSON.stringify(['local-topic-1', 'local-topic-2']));
      
      const result = await getCompletedIds();
      
      expect(result).toBeInstanceOf(Set);
      expect(result.has('local-topic-1')).toBe(true);
      expect(result.has('local-topic-2')).toBe(true);
      expect(result.size).toBe(2);
    });

    it('should return empty Set when API fails and no localStorage data', async () => {
      server.use(...errorHandlers);
      
      const result = await getCompletedIds();
      
      expect(result).toBeInstanceOf(Set);
      expect(result.size).toBe(0);
    });

    it('should handle corrupted localStorage data gracefully', async () => {
      server.use(...errorHandlers);
      
      localStorage.setItem('studyProgress', 'invalid-json{');
      
      const result = await getCompletedIds();
      
      expect(result).toBeInstanceOf(Set);
      expect(result.size).toBe(0);
    });
  });

  describe('addCompletedIds', () => {
    it('should add completed IDs via API successfully', async () => {
      const ids = ['new-topic-1', 'new-topic-2'];
      
      await expect(addCompletedIds(ids)).resolves.not.toThrow();
    });

    it('should not make API call when ids array is empty', async () => {
      await expect(addCompletedIds([])).resolves.not.toThrow();
    });

    it('should fallback to localStorage when API fails', async () => {
      server.use(...errorHandlers);
      
      const ids = ['fallback-topic-1', 'fallback-topic-2'];
      
      await addCompletedIds(ids);
      
      const stored = localStorage.getItem('studyProgress');
      expect(stored).toBeTruthy();
      const parsed = JSON.parse(stored!);
      expect(parsed).toContain('fallback-topic-1');
      expect(parsed).toContain('fallback-topic-2');
    });

    it('should merge with existing localStorage data when API fails', async () => {
      server.use(...errorHandlers);
      
      localStorage.setItem('studyProgress', JSON.stringify(['existing-topic']));
      
      const ids = ['new-topic'];
      await addCompletedIds(ids);
      
      const stored = localStorage.getItem('studyProgress');
      const parsed = JSON.parse(stored!);
      expect(parsed).toContain('existing-topic');
      expect(parsed).toContain('new-topic');
      expect(parsed.length).toBe(2);
    });
  });

  describe('removeCompletedIds', () => {
    it('should remove completed IDs via API successfully', async () => {
      const ids = ['topic-to-remove'];
      
      await expect(removeCompletedIds(ids)).resolves.not.toThrow();
    });

    it('should not make API call when ids array is empty', async () => {
      await expect(removeCompletedIds([])).resolves.not.toThrow();
    });

    it('should fallback to localStorage when API fails', async () => {
      server.use(...errorHandlers);
      
      localStorage.setItem('studyProgress', JSON.stringify(['topic-1', 'topic-2', 'topic-3']));
      
      const ids = ['topic-2'];
      await removeCompletedIds(ids);
      
      const stored = localStorage.getItem('studyProgress');
      const parsed = JSON.parse(stored!);
      expect(parsed).not.toContain('topic-2');
      expect(parsed).toContain('topic-1');
      expect(parsed).toContain('topic-3');
      expect(parsed.length).toBe(2);
    });

    it('should handle removing non-existent IDs gracefully', async () => {
      server.use(...errorHandlers);
      
      localStorage.setItem('studyProgress', JSON.stringify(['topic-1']));
      
      const ids = ['non-existent-topic'];
      await removeCompletedIds(ids);
      
      const stored = localStorage.getItem('studyProgress');
      const parsed = JSON.parse(stored!);
      expect(parsed).toContain('topic-1');
      expect(parsed.length).toBe(1);
    });
  });
});
