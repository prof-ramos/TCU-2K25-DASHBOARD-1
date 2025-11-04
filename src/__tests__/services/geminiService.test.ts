import { describe, it, expect, beforeEach, afterEach } from 'vitest';
import { server } from '../mocks/server';
import { errorHandlers } from '../mocks/handlers';
import { fetchTopicInfo } from '@/services/geminiService';

describe('geminiService', () => {
  afterEach(() => {
    server.resetHandlers();
  });

  describe('fetchTopicInfo', () => {
    it('should fetch topic information successfully', async () => {
      const result = await fetchTopicInfo('Test Topic');

      expect(result).not.toBeNull();
      expect(result?.summary).toBe('Mock summary for: Test Topic');
      expect(result?.sources).toHaveLength(1);
      expect(result?.sources[0].web.uri).toBe('https://example.com');
      expect(result?.sources[0].web.title).toBe('Example Source');
    });

    it('should return null when API fails', async () => {
      server.use(...errorHandlers);

      const result = await fetchTopicInfo('Test Topic');

      expect(result).toBeNull();
    });

    it('should handle network errors gracefully', async () => {
      server.use(...errorHandlers);

      const result = await fetchTopicInfo('Error Topic');

      expect(result).toBeNull();
    });

    it('should send correct request payload', async () => {
      const topicTitle = 'Specific Topic Title';
      
      const result = await fetchTopicInfo(topicTitle);

      expect(result).not.toBeNull();
      expect(result?.summary).toContain(topicTitle);
    });
  });
});
