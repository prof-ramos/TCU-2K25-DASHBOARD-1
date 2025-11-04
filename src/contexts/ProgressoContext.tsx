import React, { createContext, useState, useContext, useEffect, ReactNode, useCallback } from 'react';
import type { Materia, Edital, Topic, Subtopic } from '../types';
import { getCompletedIds, addCompletedIds, removeCompletedIds } from '../services/databaseService';

export interface ProgressoContextType {
    completedItems: Set<string>;
    toggleCompleted: (item: Topic | Subtopic) => void;
    getMateriaStats: (materia: Materia) => { total: number; completed: number; percentage: number };
    getGlobalStats: (edital: Edital) => { total: number; completed: number; percentage: number };
    getItemStatus: (item: Topic) => 'completed' | 'partial' | 'incomplete';
}

export const ProgressoContext = createContext<ProgressoContextType | undefined>(undefined);

const countLeafNodes = (items: (Topic | { subtopics?: any[] })[]): number => {
    let count = 0;
    for (const item of items) {
        if (item.subtopics && item.subtopics.length > 0) {
            count += countLeafNodes(item.subtopics);
        } else {
            count++;
        }
    }
    return count;
};

const getLeafIds = (item: Topic | Subtopic): string[] => {
    if (!item.subtopics || item.subtopics.length === 0) {
        return [item.id];
    }
    return item.subtopics.flatMap(getLeafIds);
};


export const ProgressoProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
    const [completedItems, setCompletedItems] = useState<Set<string>>(new Set());

    useEffect(() => {
        getCompletedIds().then(ids => {
            setCompletedItems(ids);
        }).catch(error => {
            console.error("Failed to load progress from database", error);
        });
    }, []);

    const toggleCompleted = useCallback((item: Topic | Subtopic) => {
        const leafIds = getLeafIds(item);
        const allCompleted = leafIds.every(id => completedItems.has(id));

        // Optimistic UI update
        setCompletedItems(prev => {
            const newSet = new Set(prev);
            if (allCompleted) {
                leafIds.forEach(id => newSet.delete(id));
            } else {
                leafIds.forEach(id => newSet.add(id));
            }
            return newSet;
        });

        // Background database update
        (async () => {
            try {
                if (allCompleted) {
                    await removeCompletedIds(leafIds);
                } else {
                    await addCompletedIds(leafIds);
                }
            } catch (error) {
                console.error('Failed to update progress in DB', error);
                // Optionally revert optimistic update on failure
            }
        })();
    }, [completedItems]);
    
    const getMateriaStats = useCallback((materia: Materia) => {
        const total = countLeafNodes(materia.topics);
        let completed = 0;

        const checkCompleted = (items: any[]) => {
            for (const item of items) {
                if (item.subtopics && item.subtopics.length > 0) {
                    checkCompleted(item.subtopics);
                } else {
                    if (completedItems.has(item.id)) {
                        completed++;
                    }
                }
            }
        };

        checkCompleted(materia.topics);
        const percentage = total > 0 ? (completed / total) * 100 : 0;
        return { total, completed, percentage };
    }, [completedItems]);

    const getGlobalStats = useCallback((edital: Edital) => {
        let total = 0;
        let completed = 0;
        edital.materias.forEach(materia => {
            const stats = getMateriaStats(materia);
            total += stats.total;
            completed += stats.completed;
        });
        const percentage = total > 0 ? (completed / total) * 100 : 0;
        return { total, completed, percentage };
    }, [getMateriaStats]);

    const getItemStatus = useCallback((item: Topic): 'completed' | 'partial' | 'incomplete' => {
        if (!item.subtopics || item.subtopics.length === 0) {
            return completedItems.has(item.id) ? 'completed' : 'incomplete';
        }
        
        const leafNodes = getLeafIds(item);

        const completedCount = leafNodes.filter(id => completedItems.has(id)).length;

        if (completedCount === 0) return 'incomplete';
        if (completedCount === leafNodes.length) return 'completed';
        return 'partial';

    }, [completedItems]);

    return (
        <ProgressoContext.Provider value={{ completedItems, toggleCompleted, getMateriaStats, getGlobalStats, getItemStatus }}>
            {children}
        </ProgressoContext.Provider>
    );
};
