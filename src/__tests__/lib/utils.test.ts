import { describe, it, expect } from 'vitest';
import { cn } from '@/lib/utils';

describe('utils', () => {
  describe('cn', () => {
    it('should merge class names', () => {
      const result = cn('class1', 'class2');
      expect(result).toBe('class1 class2');
    });

    it('should handle conditional classes', () => {
      const result = cn('base', true && 'conditional', false && 'excluded');
      expect(result).toBe('base conditional');
    });

    it('should merge Tailwind classes without conflicts', () => {
      const result = cn('px-4', 'px-8');
      expect(result).toBe('px-8');
    });

    it('should handle arrays', () => {
      const result = cn(['class1', 'class2'], 'class3');
      expect(result).toBe('class1 class2 class3');
    });

    it('should handle objects', () => {
      const result = cn({
        'class1': true,
        'class2': false,
        'class3': true
      });
      expect(result).toBe('class1 class3');
    });

    it('should handle undefined and null', () => {
      const result = cn('class1', undefined, null, 'class2');
      expect(result).toBe('class1 class2');
    });

    it('should handle empty input', () => {
      const result = cn();
      expect(result).toBe('');
    });

    it('should merge conflicting Tailwind utilities correctly', () => {
      const result = cn('text-red-500', 'text-blue-500');
      expect(result).toBe('text-blue-500');
    });

    it('should handle complex Tailwind merging', () => {
      const result = cn(
        'bg-red-500 hover:bg-red-600',
        'bg-blue-500 hover:bg-blue-600'
      );
      expect(result).toContain('bg-blue-500');
      expect(result).toContain('hover:bg-blue-600');
      expect(result).not.toContain('bg-red-500');
      expect(result).not.toContain('hover:bg-red-600');
    });
  });
});
