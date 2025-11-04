import { describe, it, expect, vi } from 'vitest';
import { render, screen } from '../utils/test-utils';
import GeminiInfoModal from '@/components/features/GeminiInfoModal';
import type { GeminiSearchResult } from '@/services/geminiService';

describe('GeminiInfoModal', () => {
  const mockOnClose = vi.fn();

  const mockResult: GeminiSearchResult = {
    summary: 'This is a test summary about the topic.',
    sources: [
      {
        web: {
          uri: 'https://example.com/article',
          title: 'Example Article'
        }
      },
      {
        web: {
          uri: 'https://test.com/doc',
          title: 'Test Documentation'
        }
      }
    ]
  };

  it('should not render when isOpen is false', () => {
    const { container } = render(
      <GeminiInfoModal
        isOpen={false}
        onClose={mockOnClose}
        topicTitle="Test Topic"
        result={null}
        isLoading={false}
      />
    );

    expect(container.querySelector('[role="dialog"]')).not.toBeInTheDocument();
  });

  it('should show loading state', () => {
    render(
      <GeminiInfoModal
        isOpen={true}
        onClose={mockOnClose}
        topicTitle="Test Topic"
        result={null}
        isLoading={true}
      />
    );

    expect(screen.getByText(/buscando informações atualizadas/i)).toBeInTheDocument();
  });

  it('should show error message when result is null and not loading', () => {
    render(
      <GeminiInfoModal
        isOpen={true}
        onClose={mockOnClose}
        topicTitle="Test Topic"
        result={null}
        isLoading={false}
      />
    );

    expect(screen.getByText(/ocorreu um erro ao buscar as informações/i)).toBeInTheDocument();
    expect(screen.getByText(/verifique sua chave de api/i)).toBeInTheDocument();
  });

  it('should display topic title', () => {
    render(
      <GeminiInfoModal
        isOpen={true}
        onClose={mockOnClose}
        topicTitle="Test Topic Title"
        result={mockResult}
        isLoading={false}
      />
    );

    expect(screen.getByText('Test Topic Title')).toBeInTheDocument();
  });

  it('should display summary when result is available', () => {
    render(
      <GeminiInfoModal
        isOpen={true}
        onClose={mockOnClose}
        topicTitle="Test Topic"
        result={mockResult}
        isLoading={false}
      />
    );

    expect(screen.getByText('Resumo')).toBeInTheDocument();
    expect(screen.getByText(mockResult.summary)).toBeInTheDocument();
  });

  it('should display sources when available', () => {
    render(
      <GeminiInfoModal
        isOpen={true}
        onClose={mockOnClose}
        topicTitle="Test Topic"
        result={mockResult}
        isLoading={false}
      />
    );

    expect(screen.getByText('Fontes')).toBeInTheDocument();
    expect(screen.getByText('Example Article')).toBeInTheDocument();
    expect(screen.getByText('Test Documentation')).toBeInTheDocument();
  });

  it('should render source links with correct attributes', () => {
    render(
      <GeminiInfoModal
        isOpen={true}
        onClose={mockOnClose}
        topicTitle="Test Topic"
        result={mockResult}
        isLoading={false}
      />
    );

    const link = screen.getByText('Example Article').closest('a');
    expect(link).toHaveAttribute('href', 'https://example.com/article');
    expect(link).toHaveAttribute('target', '_blank');
    expect(link).toHaveAttribute('rel', 'noopener noreferrer');
  });

  it('should show fallback message when no summary is generated', () => {
    const resultWithoutSummary: GeminiSearchResult = {
      summary: '',
      sources: []
    };

    render(
      <GeminiInfoModal
        isOpen={true}
        onClose={mockOnClose}
        topicTitle="Test Topic"
        result={resultWithoutSummary}
        isLoading={false}
      />
    );

    expect(screen.getByText(/nenhum resumo foi gerado/i)).toBeInTheDocument();
  });
});
