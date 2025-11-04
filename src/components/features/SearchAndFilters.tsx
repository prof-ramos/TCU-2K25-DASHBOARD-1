import React, { useState, useMemo } from 'react';
import { Search, Filter, X, Bookmark, History } from 'lucide-react';
import { Input } from '../ui/input';
import { Button } from '../ui/button';
import { Badge } from '../ui/badge';
import { Checkbox } from '../ui/checkbox';
import { Collapsible, CollapsibleContent, CollapsibleTrigger } from '../ui/collapsible';
import type { Materia, Topic, Subtopic } from '../../types';
import { useProgresso } from '../../hooks/useProgresso';

interface SearchAndFiltersProps {
    materias: Materia[];
    onFilteredResults: (results: SearchResult[]) => void;
    placeholder?: string;
}

export interface SearchResult {
    type: 'materia' | 'topic' | 'subtopic';
    item: Materia | Topic | Subtopic;
    materia?: Materia;
    path: string[]; // Breadcrumb path
    score: number; // Relevance score
}

const SearchAndFilters: React.FC<SearchAndFiltersProps> = ({
    materias,
    onFilteredResults,
    placeholder = "Buscar tópicos, subtópicos..."
}) => {
    const { getItemStatus } = useProgresso();
    const [searchQuery, setSearchQuery] = useState('');
    const [filters, setFilters] = useState({
        status: [] as ('completed' | 'partial' | 'incomplete')[],
        materia: [] as string[],
        bookmarked: false,
        recent: false
    });
    const [isFiltersOpen, setIsFiltersOpen] = useState(false);

    // Flatten all items for search
    const allItems = useMemo(() => {
        const items: SearchResult[] = [];

        materias.forEach(materia => {
            // Add materia itself
            items.push({
                type: 'materia',
                item: materia,
                path: [materia.name],
                score: 0
            });

            materia.topics.forEach(topic => {
                // Add topic
                items.push({
                    type: 'topic',
                    item: topic,
                    materia,
                    path: [materia.name, topic.title],
                    score: 0
                });

                // Add subtopics recursively
                const addSubtopics = (subtopics: Subtopic[], currentPath: string[]) => {
                    subtopics.forEach(subtopic => {
                        items.push({
                            type: 'subtopic',
                            item: subtopic,
                            materia,
                            path: [...currentPath, subtopic.title],
                            score: 0
                        });

                        if (subtopic.subtopics) {
                            addSubtopics(subtopic.subtopics, [...currentPath, subtopic.title]);
                        }
                    });
                };

                if (topic.subtopics) {
                    addSubtopics(topic.subtopics, [materia.name, topic.title]);
                }
            });
        });

        return items;
    }, [materias]);

    // Search and filter logic
    const filteredResults = useMemo(() => {
        let results = allItems;

        // Apply search query
        if (searchQuery.trim()) {
            const query = searchQuery.toLowerCase();
            results = results.map(item => {
                const title = 'title' in item.item ? item.item.title : item.item.name;
                const searchText = title.toLowerCase();

                // Simple fuzzy matching
                let score = 0;
                if (searchText.includes(query)) {
                    score = query.length / searchText.length; // Higher score for better matches
                    if (searchText.startsWith(query)) score += 0.5; // Bonus for prefix matches
                }

                return { ...item, score };
            }).filter(item => item.score > 0)
              .sort((a, b) => b.score - a.score); // Sort by relevance
        }

        // Apply filters
        if (filters.status.length > 0) {
            results = results.filter(item => {
                if (item.type === 'materia') return true; // Always show materias in filtered results
                const status = getItemStatus(item.item as Topic);
                return filters.status.includes(status);
            });
        }

        if (filters.materia.length > 0) {
            results = results.filter(item =>
                !item.materia || filters.materia.includes(item.materia.id)
            );
        }

        // TODO: Implement bookmarked and recent filters
        // if (filters.bookmarked) { ... }
        // if (filters.recent) { ... }

        return results;
    }, [allItems, searchQuery, filters, getItemStatus]);

    // Update parent component with filtered results
    React.useEffect(() => {
        onFilteredResults(filteredResults);
    }, [filteredResults, onFilteredResults]);

    const toggleFilter = (filterType: keyof typeof filters, value: any) => {
        setFilters(prev => {
            const current = prev[filterType];
            if (Array.isArray(current)) {
                const newArray = current.includes(value)
                    ? current.filter(v => v !== value)
                    : [...current, value];
                return { ...prev, [filterType]: newArray };
            } else {
                return { ...prev, [filterType]: !current };
            }
        });
    };

    const clearFilters = () => {
        setFilters({
            status: [],
            materia: [],
            bookmarked: false,
            recent: false
        });
        setSearchQuery('');
    };

    const hasActiveFilters = filters.status.length > 0 ||
                           filters.materia.length > 0 ||
                           filters.bookmarked ||
                           filters.recent ||
                           searchQuery.trim() !== '';

    return (
        <div className="space-y-4">
            {/* Search Input */}
            <div className="relative">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-muted-foreground h-4 w-4" />
                <Input
                    type="text"
                    placeholder={placeholder}
                    value={searchQuery}
                    onChange={(e) => setSearchQuery(e.target.value)}
                    className="pl-10 pr-10"
                />
                {searchQuery && (
                    <Button
                        variant="ghost"
                        size="icon"
                        className="absolute right-1 top-1/2 transform -translate-y-1/2 h-8 w-8"
                        onClick={() => setSearchQuery('')}
                    >
                        <X className="h-4 w-4" />
                    </Button>
                )}
            </div>

            {/* Filters Toggle */}
            <div className="flex items-center justify-between">
                <Collapsible open={isFiltersOpen} onOpenChange={setIsFiltersOpen}>
                    <CollapsibleTrigger asChild>
                        <Button variant="outline" size="sm">
                            <Filter className="h-4 w-4 mr-2" />
                            Filtros
                            {hasActiveFilters && (
                                <Badge variant="secondary" className="ml-2 h-5 w-5 p-0 text-xs">
                                    {(filters.status.length + filters.materia.length + (filters.bookmarked ? 1 : 0) + (filters.recent ? 1 : 0))}
                                </Badge>
                            )}
                        </Button>
                    </CollapsibleTrigger>

                    <CollapsibleContent className="space-y-4 mt-4 p-4 border rounded-lg bg-muted/50">
                        {/* Status Filters */}
                        <div>
                            <h4 className="font-medium mb-2">Status</h4>
                            <div className="flex flex-wrap gap-2">
                                {[
                                    { value: 'completed' as const, label: 'Concluído', color: 'bg-green-500' },
                                    { value: 'partial' as const, label: 'Parcial', color: 'bg-yellow-500' },
                                    { value: 'incomplete' as const, label: 'Pendente', color: 'bg-gray-500' }
                                ].map(({ value, label, color }) => (
                                    <label key={value} className="flex items-center space-x-2 cursor-pointer">
                                        <Checkbox
                                            checked={filters.status.includes(value)}
                                            onCheckedChange={() => toggleFilter('status', value)}
                                        />
                                        <div className={`w-3 h-3 rounded-full ${color}`} />
                                        <span className="text-sm">{label}</span>
                                    </label>
                                ))}
                            </div>
                        </div>

                        {/* Materia Filters */}
                        <div>
                            <h4 className="font-medium mb-2">Matérias</h4>
                            <div className="flex flex-wrap gap-2">
                                {materias.map(materia => (
                                    <label key={materia.id} className="flex items-center space-x-2 cursor-pointer">
                                        <Checkbox
                                            checked={filters.materia.includes(materia.id)}
                                            onCheckedChange={() => toggleFilter('materia', materia.id)}
                                        />
                                        <span className="text-sm">{materia.name}</span>
                                    </label>
                                ))}
                            </div>
                        </div>

                        {/* Other Filters */}
                        <div>
                            <h4 className="font-medium mb-2">Outros</h4>
                            <div className="flex flex-wrap gap-2">
                                <label className="flex items-center space-x-2 cursor-pointer">
                                    <Checkbox
                                        checked={filters.bookmarked}
                                        onCheckedChange={() => toggleFilter('bookmarked', null)}
                                    />
                                    <Bookmark className="h-4 w-4" />
                                    <span className="text-sm">Favoritos</span>
                                </label>

                                <label className="flex items-center space-x-2 cursor-pointer">
                                    <Checkbox
                                        checked={filters.recent}
                                        onCheckedChange={() => toggleFilter('recent', null)}
                                    />
                                    <History className="h-4 w-4" />
                                    <span className="text-sm">Recentes</span>
                                </label>
                            </div>
                        </div>

                        {/* Clear Filters */}
                        {hasActiveFilters && (
                            <Button variant="outline" size="sm" onClick={clearFilters} className="w-full">
                                Limpar Filtros
                            </Button>
                        )}
                    </CollapsibleContent>
                </Collapsible>

                {/* Results Count */}
                <div className="text-sm text-muted-foreground">
                    {filteredResults.length} resultado{filteredResults.length !== 1 ? 's' : ''}
                </div>
            </div>
        </div>
    );
};

export default SearchAndFilters;
