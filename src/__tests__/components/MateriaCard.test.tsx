import { describe, it, expect, vi, beforeEach } from 'vitest';
import { render, screen } from '../utils/test-utils';
import MateriaCard from '@/components/features/MateriaCard';
import { mockMateria } from '../mocks/mockData';
import { useProgresso } from '@/hooks/useProgresso';

vi.mock('@/hooks/useProgresso');

describe('MateriaCard', () => {
  beforeEach(() => {
    vi.mocked(useProgresso).mockReturnValue({
      completedItems: new Set(),
      toggleCompleted: vi.fn(),
      getMateriaStats: vi.fn(() => ({
        total: 10,
        completed: 3,
        percentage: 30
      })),
      getGlobalStats: vi.fn(),
      getItemStatus: vi.fn()
    });
  });

  it('should render materia name', () => {
    render(<MateriaCard materia={mockMateria} color="blue" />);

    expect(screen.getByText(mockMateria.name)).toBeInTheDocument();
  });

  it('should display progress percentage', () => {
    render(<MateriaCard materia={mockMateria} color="blue" />);

    expect(screen.getByText('30%')).toBeInTheDocument();
  });

  it('should display completed/total count', () => {
    render(<MateriaCard materia={mockMateria} color="blue" />);

    expect(screen.getByText('3/10')).toBeInTheDocument();
  });

  it('should render as a link to materia page', () => {
    render(<MateriaCard materia={mockMateria} color="blue" />);

    const link = screen.getByRole('link');
    expect(link).toHaveAttribute('href', `/materia/${mockMateria.slug}`);
  });

  it('should apply blue color classes', () => {
    const { container } = render(<MateriaCard materia={mockMateria} color="blue" />);

    const percentageElement = screen.getByText('30%');
    expect(percentageElement).toHaveClass('text-blue-600');
  });

  it('should apply green color classes', () => {
    const { container } = render(<MateriaCard materia={mockMateria} color="green" />);

    const percentageElement = screen.getByText('30%');
    expect(percentageElement).toHaveClass('text-green-600');
  });

  it('should call getMateriaStats with correct materia', () => {
    const getMateriaStats = vi.fn(() => ({
      total: 10,
      completed: 5,
      percentage: 50
    }));

    vi.mocked(useProgresso).mockReturnValue({
      completedItems: new Set(),
      toggleCompleted: vi.fn(),
      getMateriaStats,
      getGlobalStats: vi.fn(),
      getItemStatus: vi.fn()
    });

    render(<MateriaCard materia={mockMateria} color="blue" />);

    expect(getMateriaStats).toHaveBeenCalledWith(mockMateria);
  });

  it('should display 0% when no topics are completed', () => {
    vi.mocked(useProgresso).mockReturnValue({
      completedItems: new Set(),
      toggleCompleted: vi.fn(),
      getMateriaStats: vi.fn(() => ({
        total: 10,
        completed: 0,
        percentage: 0
      })),
      getGlobalStats: vi.fn(),
      getItemStatus: vi.fn()
    });

    render(<MateriaCard materia={mockMateria} color="blue" />);

    expect(screen.getByText('0%')).toBeInTheDocument();
    expect(screen.getByText('0/10')).toBeInTheDocument();
  });

  it('should display 100% when all topics are completed', () => {
    vi.mocked(useProgresso).mockReturnValue({
      completedItems: new Set(),
      toggleCompleted: vi.fn(),
      getMateriaStats: vi.fn(() => ({
        total: 10,
        completed: 10,
        percentage: 100
      })),
      getGlobalStats: vi.fn(),
      getItemStatus: vi.fn()
    });

    render(<MateriaCard materia={mockMateria} color="blue" />);

    expect(screen.getByText('100%')).toBeInTheDocument();
    expect(screen.getByText('10/10')).toBeInTheDocument();
  });
});
