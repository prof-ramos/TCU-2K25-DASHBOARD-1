
import React from 'react';
import { Link } from 'react-router-dom';
import ThemeToggle from './ThemeToggle';
import { GraduationCap } from 'lucide-react';

const Header: React.FC = () => {
    return (
        <header className="sticky top-0 z-50 w-full border-b border-border/40 bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
            <div className="container flex h-14 max-w-screen-2xl items-center mx-auto px-4">
                <Link to="/" className="flex items-center space-x-2 mr-6">
                    <GraduationCap className="h-6 w-6 text-primary" />
                    <span className="font-bold sm:inline-block">TCU TI 2025</span>
                </Link>
                <div className="flex flex-1 items-center justify-end space-x-2">
                    <ThemeToggle />
                </div>
            </div>
        </header>
    );
};

export default Header;
