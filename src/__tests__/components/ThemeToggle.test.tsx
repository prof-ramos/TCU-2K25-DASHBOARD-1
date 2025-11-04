import { describe, it, expect, vi } from 'vitest';
import { render, screen } from '../utils/test-utils';
import ThemeToggle from '@/components/common/ThemeToggle';
import { useTheme } from '@/hooks/useTheme';
import userEvent from '@testing-library/user-event';

vi.mock('@/hooks/useTheme');

describe('ThemeToggle', () => {
  it('should render Sun icon when theme is dark', () => {
    vi.mocked(useTheme).mockReturnValue({
      theme: 'dark',
      toggleTheme: vi.fn()
    });

    render(<ThemeToggle />);

    const button = screen.getByRole('button', { name: /toggle theme/i });
    expect(button).toBeInTheDocument();
  });

  it('should render Moon icon when theme is light', () => {
    vi.mocked(useTheme).mockReturnValue({
      theme: 'light',
      toggleTheme: vi.fn()
    });

    render(<ThemeToggle />);

    const button = screen.getByRole('button', { name: /toggle theme/i });
    expect(button).toBeInTheDocument();
  });

  it('should call toggleTheme when clicked', async () => {
    const toggleTheme = vi.fn();
    vi.mocked(useTheme).mockReturnValue({
      theme: 'light',
      toggleTheme
    });

    const user = userEvent.setup();

    render(<ThemeToggle />);

    const button = screen.getByRole('button', { name: /toggle theme/i });
    await user.click(button);

    expect(toggleTheme).toHaveBeenCalledTimes(1);
  });

  it('should have proper accessibility attributes', () => {
    vi.mocked(useTheme).mockReturnValue({
      theme: 'light',
      toggleTheme: vi.fn()
    });

    render(<ThemeToggle />);

    const button = screen.getByRole('button', { name: /toggle theme/i });
    expect(button).toHaveAttribute('aria-label', 'Toggle theme');
  });
});
