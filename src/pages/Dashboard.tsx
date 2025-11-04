import React from 'react';
import type { Edital, Materia } from '../types';
import Countdown from '../components/features/Countdown';
import MateriaCard from '../components/features/MateriaCard';
import { useProgresso } from '../hooks/useProgresso';
import { Card, CardContent, CardHeader, CardTitle } from '../components/ui/card';
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
    const generalMaterias = edital.materias.filter(m => m.type === 'CONHECIMENTOS GERAIS');
    const specificMaterias = edital.materias.filter(m => m.type === 'CONHECIMENTOS ESPECÍFICOS');

    return (
        <div className="space-y-12">
            <section className="text-center space-y-4">
                <h1 className="text-4xl font-bold tracking-tight lg:text-5xl">Dashboard TCU TI 2025</h1>
                <p className="text-muted-foreground">Sua jornada para a aprovação começa aqui.</p>
            </section>
            
            <section className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <Card>
                    <CardHeader>
                        <CardTitle className="text-center">Contagem Regressiva para a Prova</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <Countdown dataProva={edital.examDate} />
                    </CardContent>
                </Card>
                 <GlobalProgress edital={edital} />
            </section>
            
            <section>
                <h2 className="text-2xl font-bold mb-6 border-b pb-2 text-blue-600 dark:text-blue-400">Conhecimentos Gerais</h2>
                <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                    {generalMaterias.map(materia => (
                        <MateriaCard key={materia.id} materia={materia} color="blue" />
                    ))}
                </div>
            </section>

            <section>
                <h2 className="text-2xl font-bold mb-6 border-b pb-2 text-green-600 dark:text-green-400">Conhecimentos Específicos</h2>
                <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                    {specificMaterias.map(materia => (
                        <MateriaCard key={materia.id} materia={materia} color="green" />
                    ))}
                </div>
            </section>
        </div>
    );
};

export default Dashboard;