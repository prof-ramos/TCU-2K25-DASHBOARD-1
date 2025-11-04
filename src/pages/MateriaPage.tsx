import React from 'react';
import { useNavigate } from 'react-router-dom';
import type { Materia } from '../types';
import TopicItem from '../components/features/TopicItem';
import { useProgresso } from '../hooks/useProgresso';
import { ArrowLeft, BookOpen } from 'lucide-react';
import { Progress } from '../components/ui/progress';
import { Accordion } from '../components/ui/accordion';
import { Card, CardContent, CardHeader, CardTitle } from '../components/ui/card';
import { Button } from '../components/ui/button';

interface MateriaPageProps {
    materia: Materia;
}

const MateriaPage: React.FC<MateriaPageProps> = ({ materia }) => {
    const navigate = useNavigate();
    const { getMateriaStats } = useProgresso();
    const { completed, total, percentage } = getMateriaStats(materia);

    return (
        <div className="max-w-4xl mx-auto">
            <div className="flex gap-2 mb-4">
                <Button variant="ghost" onClick={() => navigate('/materias')} className="flex-1 sm:flex-none">
                    <BookOpen className="h-4 w-4 mr-2" />
                    Voltar às Matérias
                </Button>
                <Button variant="outline" onClick={() => navigate('/')} className="flex-1 sm:flex-none">
                    <ArrowLeft className="h-4 w-4 mr-2" />
                    Dashboard
                </Button>
            </div>
            <Card>
                <CardHeader>
                    <CardTitle className="text-2xl">{materia.name}</CardTitle>
                    <div className="pt-4">
                        <div className="flex justify-between mb-1 text-sm">
                            <span className="text-muted-foreground">Progresso</span>
                            <span className="font-semibold text-primary">{percentage.toFixed(0)}%</span>
                        </div>
                        <Progress value={percentage} className="h-2" />
                        <div className="text-right mt-1 text-xs text-muted-foreground">{completed}/{total}</div>
                    </div>
                </CardHeader>
                <CardContent>
                     <Accordion type="multiple" defaultValue={materia.topics.map(t => t.id)} className="w-full">
                        {materia.topics.map(topic => (
                            <TopicItem key={topic.id} topic={topic} />
                        ))}
                    </Accordion>
                </CardContent>
            </Card>
        </div>
    );
};

export default MateriaPage;
