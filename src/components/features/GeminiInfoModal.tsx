import React from 'react';
import type { GeminiSearchResult } from '../../services/geminiService';
import { ExternalLink, Loader2 } from 'lucide-react';
import {
    Dialog,
    DialogContent,
    DialogHeader,
    DialogTitle,
    DialogDescription,
} from '../ui/dialog';

interface GeminiInfoModalProps {
    isOpen: boolean;
    onClose: () => void;
    topicTitle: string;
    result: GeminiSearchResult | null;
    isLoading: boolean;
}

const GeminiInfoModal: React.FC<GeminiInfoModalProps> = ({ isOpen, onClose, topicTitle, result, isLoading }) => {
    return (
        <Dialog open={isOpen} onOpenChange={onClose}>
            <DialogContent className="max-w-2xl max-h-[90vh] flex flex-col">
                <DialogHeader>
                    <DialogTitle>Análise com IA</DialogTitle>
                    <DialogDescription>{topicTitle}</DialogDescription>
                </DialogHeader>
                
                <div className="overflow-y-auto pr-6 -mr-6">
                    {isLoading && (
                        <div className="flex flex-col items-center justify-center space-y-4 h-64">
                            <Loader2 className="h-12 w-12 animate-spin text-primary" />
                            <p className="text-muted-foreground">Buscando informações atualizadas...</p>
                        </div>
                    )}
                    {!isLoading && !result && (
                         <div className="flex flex-col items-center justify-center space-y-4 h-64">
                            <p className="text-destructive">Ocorreu um erro ao buscar as informações.</p>
                            <p className="text-sm text-muted-foreground">Verifique sua chave de API e tente novamente.</p>
                        </div>
                    )}
                    {!isLoading && result && (
                        <div className="space-y-6 text-sm">
                            <div>
                                <h3 className="font-semibold mb-2 text-base">Resumo</h3>
                                <div className="prose prose-sm dark:prose-invert max-w-none whitespace-pre-wrap text-muted-foreground">
                                    {result.summary || "Nenhum resumo foi gerado."}
                                </div>
                            </div>
                            
                            {result.sources && result.sources.length > 0 && (
                                <div>
                                    <h3 className="font-semibold mb-2 text-base">Fontes</h3>
                                    <ul className="space-y-2">
                                        {result.sources.map((source, index) => source.web && (
                                            <li key={index}>
                                                <a 
                                                    href={source.web.uri} 
                                                    target="_blank" 
                                                    rel="noopener noreferrer"
                                                    className="flex items-center gap-2 text-blue-500 hover:underline"
                                                >
                                                    <ExternalLink className="h-4 w-4 flex-shrink-0" />
                                                    <span className="truncate">{source.web.title || source.web.uri}</span>
                                                </a>
                                            </li>
                                        ))}
                                    </ul>
                                </div>
                            )}
                        </div>
                    )}
                </div>
            </DialogContent>
        </Dialog>
    );
};

export default GeminiInfoModal;