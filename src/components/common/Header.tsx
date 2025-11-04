
import React from 'react';
import { Link, useLocation } from 'react-router-dom';
import ThemeToggle from './ThemeToggle';
import { GraduationCap, Home, BookOpen, Search } from 'lucide-react';
import { Button } from '../ui/button';
import { cn } from '../../lib/utils';

const Header: React.FC = () => {
    const location = useLocation();

    const navItems = [
        { path: '/', label: 'Dashboard', icon: Home },
        { path: '/materias', label: 'Matérias', icon: BookOpen },
        { path: '/search', label: 'Buscar', icon: Search },
    ];

    return (
        <header className="sticky top-0 z-50 w-full border-b border-border/40 bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
            <div className="container flex h-14 max-w-screen-2xl items-center mx-auto px-4">
                <Link to="/" className="flex items-center space-x-2 mr-6">
                    <GraduationCap className="h-6 w-6 text-primary" />
                    <span className="font-bold sm:inline-block">TCU TI 2025</span>
                </Link>

                <nav className="hidden md:flex items-center space-x-1">
                    {navItems.map(({ path, label, icon: Icon }) => (
                        <Link key={path} to={path}>
                            <Button
                                variant={location.pathname === path ? "default" : "ghost"}
                                size="sm"
                                className={cn(
                                    "transition-all duration-200",
                                    location.pathname === path && "bg-primary text-primary-foreground"
                                )}
                            >
                                <Icon className="h-4 w-4 mr-2" />
                                {label}
                            </Button>
                        </Link>
                    ))}
                </nav>

                <div className="flex flex-1 items-center justify-end space-x-2">
                    <ThemeToggle />
                </div>
            </div>
        </header>
    );
};

export default Header;
