
import React, { ReactNode } from 'react';
import Header from './Header';

const Layout: React.FC<{ children: ReactNode }> = ({ children }) => {
    return (
        <div className="min-h-screen bg-background text-foreground">
            <Header />
            <main className="container mx-auto px-6 py-6 max-w-7xl">
                {children}
            </main>
        </div>
    );
};

export default Layout;
