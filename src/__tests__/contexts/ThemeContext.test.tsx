import { describe, it, expect, beforeEach } from 'vitest';
import { renderHook, act } from '@testing-library/react';
import { ThemeProvider } from '@/contexts/ThemeContext';
import { useTheme } from '@/hooks/useTheme';

const wrapper = ({ children }: { children: React.ReactNode }) => (
  <ThemeProvider>{children}</ThemeProvider>
);

describe('ThemeContext', () => {
  beforeEach(() => {
    localStorage.clear();
    document.documentElement.className = '';
  });

  describe('Initialization', () => {
    it('should initialize with light theme by default', () => {
      const { result } = renderHook(() => useTheme(), { wrapper });

      expect(result.current.theme).toBe('light');
    });

    it('should load theme from localStorage if present', () => {
      localStorage.setItem('theme', 'dark');

      const { result } = renderHook(() => useTheme(), { wrapper });

      expect(result.current.theme).toBe('dark');
    });

    it('should apply dark class to documentElement on mount if theme is dark', () => {
      localStorage.setItem('theme', 'dark');

      renderHook(() => useTheme(), { wrapper });

      expect(document.documentElement.classList.contains('dark')).toBe(true);
    });
  });

  describe('toggleTheme', () => {
    it('should toggle from light to dark', () => {
      const { result } = renderHook(() => useTheme(), { wrapper });

      expect(result.current.theme).toBe('light');

      act(() => {
        result.current.toggleTheme();
      });

      expect(result.current.theme).toBe('dark');
      expect(localStorage.getItem('theme')).toBe('dark');
      expect(document.documentElement.classList.contains('dark')).toBe(true);
    });

    it('should toggle from dark to light', () => {
      localStorage.setItem('theme', 'dark');

      const { result } = renderHook(() => useTheme(), { wrapper });

      expect(result.current.theme).toBe('dark');

      act(() => {
        result.current.toggleTheme();
      });

      expect(result.current.theme).toBe('light');
      expect(localStorage.getItem('theme')).toBe('light');
      expect(document.documentElement.classList.contains('dark')).toBe(false);
    });

    it('should persist theme changes to localStorage', () => {
      const { result } = renderHook(() => useTheme(), { wrapper });

      act(() => {
        result.current.toggleTheme();
      });

      expect(localStorage.getItem('theme')).toBe('dark');

      act(() => {
        result.current.toggleTheme();
      });

      expect(localStorage.getItem('theme')).toBe('light');
    });

    it('should update documentElement class on toggle', () => {
      const { result } = renderHook(() => useTheme(), { wrapper });

      act(() => {
        result.current.toggleTheme();
      });

      expect(document.documentElement.classList.contains('dark')).toBe(true);

      act(() => {
        result.current.toggleTheme();
      });

      expect(document.documentElement.classList.contains('dark')).toBe(false);
    });
  });
});
