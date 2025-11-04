import React from 'react';
import { useNavigate } from 'react-router-dom';
import { ChevronRight, BookOpen, FileText, Hash } from 'lucide-react';
import { Card, CardContent } from '../ui/card';
import { Button } from '../ui/button';
import type { SearchResult } from './SearchAndFilters';

interface SearchResultsProps {
    results: SearchResult[];
    isLoading?: boolean;
}

const SearchResults: React.FC<SearchResultsProps> = ({ results, isLoading = false }) => {
    const navigate = useNavigate();

    const getIcon = (type: SearchResult['type']) => {
        switch (type) {
            case 'materia':
                return <BookOpen className="h-4 w-4 text-blue-500" />;
            case 'topic':
                return <FileText className="h-4 w-4 text-green-500" />;
            case 'subtopic':
                return <Hash className="h-4 w-4 text-orange-500" />;
            default:
                return <FileText className="h-4 w-4" />;
        }
    };

    const getTypeLabel = (type: SearchResult['type']) => {
        switch (type) {
            case 'materia':
                return 'Matéria';
            case 'topic':
                return 'Tópico';
            case 'subtopic':
                return 'Subtópico';
            default:
                return 'Item';
        }
    };

    const handleResultClick = (result: SearchResult) => {
        if (result.type === 'materia' && 'slug' in result.item) {
            navigate(`/materia/${result.item.slug}`);
        } else if (result.materia) {
            navigate(`/materia/${result.materia.slug}`);
        }
    };

    if (isLoading) {
        return (
            <div className="space-y-4">
                {[...Array(3)].map((_, i) => (
                    <Card key={i} className="animate-pulse">
                        <CardContent className="p-4">
                            <div className="flex items-center space-x-3">
                                <div className="w-4 h-4 bg-gray-300 rounded"></div>
                                <div className="flex-1">
                                    <div className="h-4 bg-gray-300 rounded w-3/4 mb-2"></div>
                                    <div className="h-3 bg-gray-300 rounded w-1/2"></div>
                                </div>
                            </div>
                        </CardContent>
                    </Card>
                ))}
            </div>
        );
    }

    if (results.length === 0) {
        return (
            <Card>
                <CardContent className="p-8 text-center">
                    <div className="text-muted-foreground">
                        <FileText className="h-12 w-12 mx-auto mb-4 opacity-50" />
                        <p className="text-lg font-medium">Nenhum resultado encontrado</p>
                        <p className="text-sm">Tente ajustar sua busca ou filtros</p>
                    </div>
                </CardContent>
            </Card>
        );
    }

    return (
        <div className="space-y-2">
            {results.map((result, index) => {
                const title = 'title' in result.item ? result.item.title : result.item.name;
                const path = result.path.slice(0, -1).join(' > '); // Remove o último item do breadcrumb

                return (
                    <Card key={`${result.type}-${result.item.id}-${index}`} className="hover:shadow-md transition-shadow">
                        <CardContent className="p-4">
                            <div className="flex items-start justify-between">
                                <div className="flex items-start space-x-3 flex-1">
                                    {getIcon(result.type)}
                                    <div className="flex-1 min-w-0">
                                        <div className="flex items-center space-x-2 mb-1">
                                            <span className="text-xs font-medium text-muted-foreground bg-muted px-2 py-1 rounded">
                                                {getTypeLabel(result.type)}
                                            </span>
                                            {result.score > 0 && (
                                                <span className="text-xs text-muted-foreground">
                                                    {Math.round(result.score * 100)}% match
                                                </span>
                                            )}
                                        </div>
                                        <h3 className="font-medium text-sm mb-1 truncate">{title}</h3>
                                        {path && (
                                            <p className="text-xs text-muted-foreground truncate">
                                                {path}
                                            </p>
                                        )}
                                    </div>
                                </div>
                                <Button
                                    variant="ghost"
                                    size="sm"
                                    onClick={() => handleResultClick(result)}
                                    className="ml-2 flex-shrink-0"
                                >
                                    <ChevronRight className="h-4 w-4" />
                                </Button>
                            </div>
                        </CardContent>
                    </Card>
                );
            })}
        </div>
    );
};

export default SearchResults;
