import React from 'react';
import { Link } from 'react-router-dom';
import type { Edital } from '../types';
import { getEdital } from '../data/edital';
import { useProgresso } from '../hooks/useProgresso';
import { Card, CardContent, CardHeader, CardTitle } from '../components/ui/card';
import { Progress } from '../components/ui/progress';
import { cn } from '../lib/utils';

const MateriasPage: React.FC = () => {
    const edital = getEdital();
    const { getGlobalStats, getMateriaStats } = useProgresso();
    const { total, completed } = getGlobalStats(edital);

    const generalMaterias = edital.materias.filter(m => m.type === 'CONHECIMENTOS GERAIS');
    const specificMaterias = edital.materias.filter(m => m.type === 'CONHECIMENTOS ESPECÍFICOS');

    const MateriaSection: React.FC<{
        title: string;
        materias: typeof generalMaterias;
        color: 'blue' | 'green'
    }> = ({ title, materias, color }) => {
        const colorClasses = {
            blue: {
                title: 'text-blue-600 dark:text-blue-400',
                card: 'hover:border-blue-500/50'
            },
            green: {
                title: 'text-green-600 dark:text-green-400',
                card: 'hover:border-green-500/50'
            }
        };

        return (
            <section className="mb-8">
                <h2 className={`text-2xl font-bold mb-6 border-b pb-2 ${colorClasses[color].title}`}>
                    {title}
                </h2>
                <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
                    {materias.map(materia => {
                        const { completed: materiaCompleted, total: materiaTotal, percentage } = getMateriaStats(materia);
                        return (
                            <Link key={materia.id} to={`/materia/${materia.slug}`} className="block">
                                <Card className={cn("h-full transition-all duration-300 transform hover:-translate-y-1 hover:shadow-lg", colorClasses[color].card)}>
                                    <CardHeader className="pb-3">
                                        <CardTitle className="text-lg font-semibold">{materia.name}</CardTitle>
                                    </CardHeader>
                                    <CardContent>
                                        <div className="space-y-2">
                                            <div className="flex justify-between text-sm">
                                                <span className="text-muted-foreground">Progresso</span>
                                                <span className={`font-semibold ${colorClasses[color].title}`}>
                                                    {Math.round(percentage)}%
                                                </span>
                                            </div>
                                            <Progress
                                                value={percentage}
                                                className="h-2"
                                                indicatorClassName={
                                                    color === 'blue'
                                                        ? 'bg-gradient-to-r from-blue-500 to-sky-500'
                                                        : 'bg-gradient-to-r from-green-500 to-emerald-500'
                                                }
                                            />
                                            <div className="text-right text-xs text-muted-foreground">
                                                {materiaCompleted}/{materiaTotal} tópicos
                                            </div>
                                        </div>
                                    </CardContent>
                                </Card>
                            </Link>
                        );
                    })}
                </div>
            </section>
        );
    };

    return (
        <div className="max-w-6xl mx-auto">
            <div className="mb-8">
                <h1 className="text-3xl font-bold tracking-tight mb-2">Matérias do Edital</h1>
                <p className="text-muted-foreground">
                    Explore todas as matérias organizadas por categoria.
                    <span className="font-semibold text-primary ml-1">
                        {completed}/{total} tópicos concluídos
                    </span>
                </p>
            </div>

            <MateriaSection
                title="Conhecimentos Gerais"
                materias={generalMaterias}
                color="blue"
            />

            <MateriaSection
                title="Conhecimentos Específicos"
                materias={specificMaterias}
                color="green"
            />
        </div>
    );
};

export default MateriasPage;
