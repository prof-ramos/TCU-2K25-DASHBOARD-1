
import React, { useState, useEffect, useMemo } from 'react';
import { HashRouter, Routes, Route, useParams, useNavigate, useLocation } from 'react-router-dom';
import { ThemeProvider } from './contexts/ThemeContext';
import { useTheme } from './hooks/useTheme';
import { ProgressoProvider } from './contexts/ProgressoContext';
import Dashboard from './pages/Dashboard';
import MateriaPage from './pages/MateriaPage';
import Layout from './components/common/Layout';
import { getEdital, getMateriaBySlug } from '@/data/edital';
import type { Materia } from './types';

const App: React.FC = () => {
    return (
        <ThemeProvider>
            <ProgressoProvider>
                <HashRouter>
                    <Main />
                </HashRouter>
            </ProgressoProvider>
        </ThemeProvider>
    );
};

const Main: React.FC = () => {
    const edital = useMemo(() => getEdital(), []);
    const { theme } = useTheme();

    useEffect(() => {
        document.body.className = theme;
    }, [theme]);
    
    return (
        <Layout>
            <Routes>
                <Route path="/" element={<Dashboard edital={edital} />} />
                <Route path="/materia/:slug" element={<MateriaPageRoute />} />
            </Routes>
        </Layout>
    );
};

const MateriaPageRoute: React.FC = () => {
    const { slug } = useParams<{ slug: string }>();
    const navigate = useNavigate();
    const [materia, setMateria] = useState<Materia | null | undefined>(undefined);

    useEffect(() => {
        if (slug) {
            const foundMateria = getMateriaBySlug(slug);
            setMateria(foundMateria);
            if (foundMateria === undefined) {
                // Navigate to a 404 or back home if not found
                // For simplicity, we just log it and show loading/not found
            }
        }
    }, [slug]);

    if (materia === undefined) {
       return <div className="text-center p-8">Matéria não encontrada. <button onClick={() => navigate('/')} className="text-primary underline">Voltar</button></div>;
    }
    
    if (materia === null) {
        return <div className="text-center p-8">Carregando matéria...</div>;
    }

    return <MateriaPage materia={materia} />;
};

export default App;
