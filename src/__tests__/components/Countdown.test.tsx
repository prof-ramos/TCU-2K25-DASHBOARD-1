import { describe, it, expect, beforeEach, afterEach, vi } from 'vitest';
import { render, screen, waitFor } from '../utils/test-utils';
import Countdown from '@/components/features/Countdown';

describe('Countdown', () => {
  beforeEach(() => {
    vi.useFakeTimers();
  });

  afterEach(() => {
    vi.clearAllTimers();
    vi.useRealTimers();
  });

  it('should render countdown with correct initial values', async () => {
    const now = new Date('2025-01-01T00:00:00');
    vi.setSystemTime(now);
    
    render(<Countdown dataProva="2025-01-11T05:00:00" />);

    await waitFor(() => {
      expect(screen.getByText('10')).toBeInTheDocument();
    });

    expect(screen.getByText('dias')).toBeInTheDocument();
    expect(screen.getByText('horas')).toBeInTheDocument();
    expect(screen.getByText('minutos')).toBeInTheDocument();
    expect(screen.getByText('segundos')).toBeInTheDocument();
  });

  it('should display zeros when exam date has passed', async () => {
    vi.setSystemTime(new Date('2025-01-15T00:00:00'));
    
    render(<Countdown dataProva="2025-01-01T00:00:00" />);

    await waitFor(() => {
      const zeros = screen.getAllByText('00');
      expect(zeros.length).toBeGreaterThanOrEqual(4);
    });
  });

  it('should format single-digit numbers with leading zero', async () => {
    vi.setSystemTime(new Date('2025-01-01T00:00:00'));
    
    render(<Countdown dataProva="2025-01-01T00:00:09" />);

    await waitFor(() => {
      expect(screen.getByText('09')).toBeInTheDocument();
    });
  });

  it('should calculate days correctly for dates in the same month', async () => {
    vi.setSystemTime(new Date('2025-01-01T00:00:00'));
    
    render(<Countdown dataProva="2025-01-31T00:00:00" />);

    await waitFor(() => {
      expect(screen.getByText('30')).toBeInTheDocument();
    });
  });

  it('should render all time unit labels', async () => {
    vi.setSystemTime(new Date('2025-01-01T00:00:00'));
    
    render(<Countdown dataProva="2025-12-31T23:59:59" />);

    await waitFor(() => {
      expect(screen.getByText('dias')).toBeInTheDocument();
    });
    
    expect(screen.getByText('horas')).toBeInTheDocument();
    expect(screen.getByText('minutos')).toBeInTheDocument();
    expect(screen.getByText('segundos')).toBeInTheDocument();
  });

  it('should display correct time units for short durations', async () => {
    vi.setSystemTime(new Date('2025-01-01T00:00:00'));
    
    render(<Countdown dataProva="2025-01-01T01:00:00" />);

    await waitFor(() => {
      expect(screen.getByText('00')).toBeInTheDocument();
    });
    
    expect(screen.getByText('dias')).toBeInTheDocument();
  });
});
