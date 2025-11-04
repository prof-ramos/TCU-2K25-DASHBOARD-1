import React from 'react';
import { useNavigate } from 'react-router-dom';
import { Search, BookOpen, BarChart3 } from 'lucide-react';
import type { Edital, Materia } from '../types';
import Countdown from '../components/features/Countdown';
import { useProgresso } from '../hooks/useProgresso';
import { Card, CardContent, CardHeader, CardTitle } from '../components/ui/card';
import { Button } from '../components/ui/button';
import { Progress } from '../components/ui/progress';


interface DashboardProps {
    edital: Edital;
}

const GlobalProgress: React.FC<{ edital: Edital }> = ({ edital }) => {
    const { getGlobalStats } = useProgresso();
    const { total, completed, percentage } = getGlobalStats(edital);

    return (
        <Card>
            <CardHeader>
                <CardTitle>Progresso Global</CardTitle>
            </CardHeader>
            <CardContent>
                <Progress value={percentage} indicatorClassName="bg-gradient-to-r from-blue-500 to-indigo-600 dark:from-blue-400 dark:to-indigo-500" />
                <div className="flex justify-between mt-2 text-sm text-muted-foreground">
                    <span>{Math.round(percentage)}%</span>
                    <span>{completed} / {total} subtópicos</span>
                </div>
            </CardContent>
        </Card>
    );
};


const Dashboard: React.FC<DashboardProps> = ({ edital }) => {
    const navigate = useNavigate();
    const generalMaterias = edital.materias.filter(m => m.type === 'CONHECIMENTOS GERAIS');
    const specificMaterias = edital.materias.filter(m => m.type === 'CONHECIMENTOS ESPECÍFICOS');

    return (
        <div className="space-y-8">
            <section className="text-center space-y-3">
                <h1 className="text-4xl font-bold tracking-tight lg:text-5xl">Dashboard TCU TI 2025</h1>
                <p className="text-muted-foreground text-lg">Sua jornada para a aprovação começa aqui.</p>

                {/* Search Button */}
                <div className="pt-1">
                    <Button
                        onClick={() => navigate('/search')}
                        variant="outline"
                        size="lg"
                        className="border-2 hover:bg-primary hover:text-primary-foreground transition-all duration-300"
                    >
                        <Search className="h-4 w-4 mr-2" />
                        Buscar no Edital (380 itens)
                    </Button>
                    <p className="text-xs text-muted-foreground mt-1">
                        Encontre rapidamente tópicos e subtópicos específicos
                    </p>
                </div>
            </section>

            <section className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <Card className="shadow-md">
                    <CardHeader className="pb-3">
                        <CardTitle className="text-center text-lg">Contagem Regressiva para a Prova</CardTitle>
                    </CardHeader>
                    <CardContent className="pt-2">
                        <Countdown dataProva={edital.examDate} />
                    </CardContent>
                </Card>
                 <GlobalProgress edital={edital} />
            </section>

            <section className="text-center">
                <h2 className="text-2xl font-bold mb-6">Acesse suas Matérias</h2>
                <div className="flex flex-col sm:flex-row gap-4 justify-center max-w-md mx-auto">
                    <Button
                        onClick={() => navigate('/materias')}
                        size="lg"
                        className="bg-gradient-to-r from-blue-500 to-sky-500 hover:from-blue-600 hover:to-sky-600 text-white shadow-lg flex-1"
                    >
                        <BookOpen className="h-5 w-5 mr-2" />
                        Todas as Matérias
                    </Button>
                    <Button
                        onClick={() => navigate('/search')}
                        variant="outline"
                        size="lg"
                        className="border-2 flex-1"
                    >
                        <BarChart3 className="h-5 w-5 mr-2" />
                        Estatísticas
                    </Button>
                </div>
                <p className="text-sm text-muted-foreground mt-4">
                    Explore todas as {generalMaterias.length + specificMaterias.length} matérias organizadas por categoria
                </p>
            </section>
        </div>
    );
};

export default Dashboard;
