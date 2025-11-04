
import React, { useState } from 'react';
import type { Topic, Subtopic } from '../../types';
import { useProgresso } from '../../hooks/useProgresso';
import { cn } from '../../lib/utils';
import { BrainCircuit, Loader2 } from 'lucide-react';
import { fetchTopicInfo, GeminiSearchResult } from '../../services/geminiService';
import GeminiInfoModal from './GeminiInfoModal';
import { Accordion, AccordionContent, AccordionItem, AccordionTrigger } from '../ui/accordion';
import { Checkbox } from '../ui/checkbox';
import { Button } from '../ui/button';

interface TopicItemProps {
    topic: Topic | Subtopic;
}

const TopicItem: React.FC<TopicItemProps> = ({ topic }) => {
    const hasSubtopics = 'subtopics' in topic && topic.subtopics && topic.subtopics.length > 0;
    const { toggleCompleted, getItemStatus } = useProgresso();
    
    const [isModalOpen, setIsModalOpen] = useState(false);
    const [geminiResult, setGeminiResult] = useState<GeminiSearchResult | null>(null);
    const [isLoading, setIsLoading] = useState(false);

    const status = getItemStatus(topic as Topic);
    
    const handleCheckboxClick = (e: React.MouseEvent) => {
        e.stopPropagation(); // Prevent accordion from toggling
        toggleCompleted(topic);
    };
    
    const handleGeminiClick = async (e: React.MouseEvent) => {
        e.stopPropagation();
        setIsLoading(true);
        setIsModalOpen(true);
        const result = await fetchTopicInfo(topic.title);
        setGeminiResult(result);
        setIsLoading(false);
    };

    const checkboxState = status === 'completed' ? true : status === 'partial' ? 'indeterminate' : false;

    if (!hasSubtopics) {
        return (
            <div className="flex items-center gap-2 py-2 pl-8 pr-2 group">
                 <Checkbox 
                    id={topic.id}
                    checked={checkboxState} 
                    onClick={() => toggleCompleted(topic)}
                    aria-label={`Marcar ${topic.title}`}
                />
                <label 
                    htmlFor={topic.id}
                    className={cn(
                        "flex-1 text-sm cursor-pointer", 
                        status === 'completed' && 'line-through text-muted-foreground'
                    )}
                >
                    {topic.title}
                </label>
                 <Button
                    variant="ghost"
                    size="icon"
                    onClick={handleGeminiClick}
                    className="h-6 w-6 opacity-0 group-hover:opacity-100"
                    title="Buscar informações com IA"
                    disabled={isLoading}
                >
                    {isLoading ? <Loader2 className="h-4 w-4 animate-spin" /> : <BrainCircuit className="h-4 w-4" />}
                </Button>
            </div>
        )
    }

    return (
        <AccordionItem value={topic.id} className="border-b-0">
             <div className="flex items-center gap-2 group -ml-4">
                <Checkbox 
                    checked={checkboxState} 
                    onClick={handleCheckboxClick} 
                    aria-label={`Marcar todos os subtópicos de ${topic.title}`}
                />
                <AccordionTrigger className="flex-1 py-2 text-left">
                    <span className={cn("font-semibold", status === 'completed' && 'line-through text-muted-foreground')}>
                        {topic.title}
                    </span>
                </AccordionTrigger>
                 <Button
                    variant="ghost"
                    size="icon"
                    onClick={handleGeminiClick}
                    className="h-6 w-6 opacity-0 group-hover:opacity-100"
                    title="Buscar informações com IA"
                    disabled={isLoading}
                >
                     {isLoading ? <Loader2 className="h-4 w-4 animate-spin" /> : <BrainCircuit className="h-4 w-4" />}
                </Button>
            </div>
            <AccordionContent className="pl-4 border-l ml-2">
                 {topic.subtopics?.map(subtopic => (
                    <TopicItem key={subtopic.id} topic={subtopic} />
                ))}
            </AccordionContent>
            
            <GeminiInfoModal
                isOpen={isModalOpen}
                onClose={() => setIsModalOpen(false)}
                topicTitle={topic.title}
                result={geminiResult}
                isLoading={isLoading}
            />
        </AccordionItem>
    );
};

export default TopicItem;
