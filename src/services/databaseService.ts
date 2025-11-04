import { env } from '@/config/env';

const API_BASE_URL = env.apiUrl;

interface ApiResponse {
    completedIds?: string[];
    message?: string;
    error?: string;
}

async function apiRequest(endpoint: string, options: RequestInit = {}): Promise<any> {
    const url = `${API_BASE_URL}${endpoint}`;
    const config: RequestInit = {
        headers: {
            'Content-Type': 'application/json',
            ...options.headers,
        },
        ...options,
    };

    try {
        const response = await fetch(url, config);
        const data = await response.json();

        if (!response.ok) {
            throw new Error(data.error || `HTTP error! status: ${response.status}`);
        }

        return data;
    } catch (error) {
        console.error(`API request failed for ${endpoint}:`, error);
        throw error;
    }
}

export async function getCompletedIds(): Promise<Set<string>> {
    try {
        const response = await apiRequest('/api/progress');
        return new Set(response.completedIds || []);
    } catch (error) {
        console.error('Failed to get completed IDs:', error);
        // Fallback to localStorage for offline support
        const fallback = localStorage.getItem('studyProgress');
        if (fallback) {
            try {
                const ids = JSON.parse(fallback);
                return new Set(Array.isArray(ids) ? ids : []);
            } catch (e) {
                console.error('Failed to parse fallback data:', e);
            }
        }
        return new Set();
    }
}

export async function addCompletedIds(ids: string[]) {
    if (ids.length === 0) return;

    try {
        await apiRequest('/api/progress', {
            method: 'POST',
            body: JSON.stringify({ ids }),
        });
    } catch (error) {
        console.error('Failed to add completed IDs:', error);
        // Fallback to localStorage
        const existing = localStorage.getItem('studyProgress');
        const currentIds = existing ? JSON.parse(existing) : [];
        const updatedIds = [...new Set([...currentIds, ...ids])];
        localStorage.setItem('studyProgress', JSON.stringify(updatedIds));
    }
}

export async function removeCompletedIds(ids: string[]) {
    if (ids.length === 0) return;

    try {
        await apiRequest('/api/progress', {
            method: 'DELETE',
            body: JSON.stringify({ ids }),
        });
    } catch (error) {
        console.error('Failed to remove completed IDs:', error);
        // Fallback to localStorage
        const existing = localStorage.getItem('studyProgress');
        if (existing) {
            const currentIds = JSON.parse(existing);
            const updatedIds = currentIds.filter((id: string) => !ids.includes(id));
            localStorage.setItem('studyProgress', JSON.stringify(updatedIds));
        }
    }
}