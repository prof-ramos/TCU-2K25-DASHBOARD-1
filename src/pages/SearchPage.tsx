import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft } from 'lucide-react';
import { Button } from '../components/ui/button';
import { Card, CardHeader, CardTitle, CardContent } from '../components/ui/card';
import SearchAndFilters, { SearchResult } from '../components/features/SearchAndFilters';
import SearchResults from '../components/features/SearchResults';
import { getEdital } from '../data/edital';

const SearchPage: React.FC = () => {
    const navigate = useNavigate();
    const edital = getEdital();
    const [searchResults, setSearchResults] = useState<SearchResult[]>([]);
    const [isSearching, setIsSearching] = useState(false);

    const handleSearchResults = (results: SearchResult[]) => {
        setIsSearching(false);
        setSearchResults(results);
    };

    const handleSearchStart = () => {
        setIsSearching(true);
    };

    return (
        <div className="max-w-4xl mx-auto">
            <div className="mb-6">
                <Button variant="ghost" onClick={() => navigate('/')} className="mb-4">
                    <ArrowLeft className="h-4 w-4 mr-2" />
                    Voltar ao Dashboard
                </Button>

                <div className="text-center space-y-2">
                    <h1 className="text-3xl font-bold tracking-tight">Buscar no Edital</h1>
                    <p className="text-muted-foreground">
                        Encontre rapidamente tópicos e subtópicos nos 380 itens do edital TCU TI 2025
                    </p>
                </div>
            </div>

            <Card className="mb-6">
                <CardHeader>
                    <CardTitle className="text-lg">Filtros de Busca</CardTitle>
                </CardHeader>
                <CardContent>
                    <SearchAndFilters
                        materias={edital.materias}
                        onFilteredResults={handleSearchResults}
                        placeholder="Digite para buscar tópicos, subtópicos ou matérias..."
                    />
                </CardContent>
            </Card>

            <div className="space-y-4">
                <div className="flex items-center justify-between">
                    <h2 className="text-xl font-semibold">Resultados da Busca</h2>
                    <div className="text-sm text-muted-foreground">
                        {searchResults.length > 0 && (
                            <span>{searchResults.length} resultado{searchResults.length !== 1 ? 's' : ''} encontrado{searchResults.length !== 1 ? 's' : ''}</span>
                        )}
                    </div>
                </div>

                <SearchResults
                    results={searchResults}
                    isLoading={isSearching}
                />
            </div>

            {/* Quick Stats */}
            <Card className="mt-8">
                <CardHeader>
                    <CardTitle className="text-lg">Estatísticas do Edital</CardTitle>
                </CardHeader>
                <CardContent>
                    <div className="grid grid-cols-2 md:grid-cols-4 gap-4 text-center">
                        <div>
                            <div className="text-2xl font-bold text-blue-600">{edital.materias.length}</div>
                            <div className="text-sm text-muted-foreground">Matérias</div>
                        </div>
                        <div>
                            <div className="text-2xl font-bold text-green-600">
                                {edital.materias.reduce((acc, m) => acc + m.topics.length, 0)}
                            </div>
                            <div className="text-sm text-muted-foreground">Tópicos</div>
                        </div>
                        <div>
                            <div className="text-2xl font-bold text-orange-600">
                                {edital.materias.reduce((acc, m) =>
                                    acc + m.topics.reduce((tAcc, t) =>
                                        tAcc + (t.subtopics?.length || 0), 0
                                    ), 0
                                )}
                            </div>
                            <div className="text-sm text-muted-foreground">Subtópicos</div>
                        </div>
                        <div>
                            <div className="text-2xl font-bold text-purple-600">
                                {edital.materias.reduce((acc, m) =>
                                    acc + m.topics.reduce((tAcc, t) =>
                                        tAcc + (t.subtopics?.length || 0) + 1, 0
                                    ), 0
                                )}
                            </div>
                            <div className="text-sm text-muted-foreground">Total de Itens</div>
                        </div>
                    </div>
                </CardContent>
            </Card>
        </div>
    );
};

export default SearchPage;
