import React from 'react';
import { Link } from 'react-router-dom';
import type { Materia } from '../../types';
import { useProgresso } from '../../hooks/useProgresso';
import { cn } from '../../lib/utils';
import { Card, CardContent, CardHeader, CardTitle } from '../ui/card';
import { Progress } from '../ui/progress';

interface MateriaCardProps {
    materia: Materia;
    color: 'blue' | 'green';
}

const MateriaCard: React.FC<MateriaCardProps> = ({ materia, color }) => {
    const { getMateriaStats } = useProgresso();
    const { completed, total, percentage } = getMateriaStats(materia);
    
    const colorClasses = {
        blue: {
            indicator: 'bg-gradient-to-r from-blue-500 to-sky-500',
            text: 'text-blue-600 dark:text-blue-400',
            hoverBorder: 'hover:border-blue-500/50'
        },
        green: {
            indicator: 'bg-gradient-to-r from-green-500 to-emerald-500',
            text: 'text-green-600 dark:text-green-400',
            hoverBorder: 'hover:border-green-500/50'
        }
    }

    return (
        <Link to={`/materia/${materia.slug}`} className="block h-full">
            <Card className={cn("h-full transition-all duration-300 transform hover:-translate-y-1 hover:shadow-lg", colorClasses[color].hoverBorder)}>
                <div className="flex flex-col h-full">
                     <CardHeader>
                        <CardTitle className="text-base font-semibold">{materia.name}</CardTitle>
                    </CardHeader>
                    <CardContent className="mt-auto">
                        <div className="flex justify-between mb-1 text-sm text-muted-foreground">
                            <span>Progresso</span>
                            <span className={cn('font-semibold', colorClasses[color].text)}>{Math.round(percentage)}%</span>
                        </div>
                        <Progress value={percentage} indicatorClassName={colorClasses[color].indicator} className="h-2"/>
                        <div className="text-right mt-1 text-xs text-muted-foreground">{completed}/{total}</div>
                    </CardContent>
                </div>
            </Card>
        </Link>
    );
};

export default MateriaCard;