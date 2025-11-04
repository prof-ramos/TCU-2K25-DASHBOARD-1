import { env } from '@/config/env';

export interface GroundingChunk {
    web: {
        uri: string;
        title: string;
    }
}

export interface GeminiSearchResult {
    summary: string;
    sources: GroundingChunk[];
}

export const fetchTopicInfo = async (topicTitle: string): Promise<GeminiSearchResult | null> => {
    try {
        const response = await fetch(`${env.apiUrl}/api/gemini-proxy`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ topicTitle }),
        });

        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }

        const data: GeminiSearchResult = await response.json();
        return data;
    } catch (error) {
        console.error("Error fetching data from Gemini API:", error);
        return null;
    }
};
