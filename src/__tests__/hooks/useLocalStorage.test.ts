import { describe, it, expect, beforeEach } from 'vitest';
import { renderHook, act } from '@testing-library/react';
import { useLocalStorage } from '@/hooks/useLocalStorage';

describe('useLocalStorage', () => {
  beforeEach(() => {
    localStorage.clear();
  });

  it('should initialize with initial value when localStorage is empty', () => {
    const { result } = renderHook(() => useLocalStorage('test-key', 'initial-value'));

    expect(result.current[0]).toBe('initial-value');
  });

  it('should initialize with value from localStorage if present', () => {
    localStorage.setItem('test-key', JSON.stringify('stored-value'));

    const { result } = renderHook(() => useLocalStorage('test-key', 'initial-value'));

    expect(result.current[0]).toBe('stored-value');
  });

  it('should update localStorage when value changes', () => {
    const { result } = renderHook(() => useLocalStorage('test-key', 'initial'));

    act(() => {
      result.current[1]('updated');
    });

    expect(result.current[0]).toBe('updated');
    expect(localStorage.getItem('test-key')).toBe(JSON.stringify('updated'));
  });

  it('should handle function updater', () => {
    const { result } = renderHook(() => useLocalStorage('counter', 0));

    act(() => {
      result.current[1]((prev) => prev + 1);
    });

    expect(result.current[0]).toBe(1);
    expect(localStorage.getItem('counter')).toBe('1');
  });

  it('should handle complex objects', () => {
    const { result } = renderHook(() => 
      useLocalStorage('user', { name: 'John', age: 30 })
    );

    expect(result.current[0]).toEqual({ name: 'John', age: 30 });

    act(() => {
      result.current[1]({ name: 'Jane', age: 25 });
    });

    expect(result.current[0]).toEqual({ name: 'Jane', age: 25 });
    const stored = localStorage.getItem('user');
    expect(JSON.parse(stored!)).toEqual({ name: 'Jane', age: 25 });
  });

  it('should handle arrays', () => {
    const { result } = renderHook(() => useLocalStorage<number[]>('numbers', [1, 2, 3]));

    expect(result.current[0]).toEqual([1, 2, 3]);

    act(() => {
      result.current[1]([4, 5, 6]);
    });

    expect(result.current[0]).toEqual([4, 5, 6]);
  });

  it('should return initial value if localStorage parsing fails', () => {
    localStorage.setItem('bad-key', 'invalid-json{');

    const { result } = renderHook(() => useLocalStorage('bad-key', 'fallback'));

    expect(result.current[0]).toBe('fallback');
  });

  it('should handle null and undefined', () => {
    const { result: nullResult } = renderHook(() => useLocalStorage('null-key', null));
    expect(nullResult.current[0]).toBe(null);

    const { result: undefinedResult } = renderHook(() => 
      useLocalStorage('undefined-key', undefined)
    );
    expect(undefinedResult.current[0]).toBe(undefined);
  });
});
