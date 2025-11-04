import { useContext } from 'react';
import { ProgressoContext } from '../contexts/ProgressoContext';

export const useProgresso = () => {
    const context = useContext(ProgressoContext);
    if (!context) {
        throw new Error('useProgresso must be used within a ProgressoProvider');
    }
    return context;
};