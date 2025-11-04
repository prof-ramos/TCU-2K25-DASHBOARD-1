import { http, HttpResponse } from 'msw';

const API_BASE_URL = 'http://localhost:3001';

export const handlers = [
  http.get(`${API_BASE_URL}/api/progress`, () => {
    return HttpResponse.json({
      completedIds: ['topic-1', 'subtopic-1-1']
    });
  }),

  http.post(`${API_BASE_URL}/api/progress`, async ({ request }) => {
    const body = await request.json();
    return HttpResponse.json({
      message: 'Progress added successfully',
      ids: (body as any).ids
    });
  }),

  http.delete(`${API_BASE_URL}/api/progress`, async ({ request }) => {
    const body = await request.json();
    return HttpResponse.json({
      message: 'Progress removed successfully',
      ids: (body as any).ids
    });
  }),

  http.post(`${API_BASE_URL}/api/gemini-proxy`, async ({ request }) => {
    const body = await request.json();
    return HttpResponse.json({
      summary: `Mock summary for: ${(body as any).topicTitle}`,
      sources: [
        {
          web: {
            uri: 'https://example.com',
            title: 'Example Source'
          }
        }
      ]
    });
  }),
];

export const errorHandlers = [
  http.get(`${API_BASE_URL}/api/progress`, () => {
    return HttpResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }),

  http.post(`${API_BASE_URL}/api/progress`, () => {
    return HttpResponse.json(
      { error: 'Failed to save progress' },
      { status: 500 }
    );
  }),

  http.delete(`${API_BASE_URL}/api/progress`, () => {
    return HttpResponse.json(
      { error: 'Failed to delete progress' },
      { status: 500 }
    );
  }),

  http.post(`${API_BASE_URL}/api/gemini-proxy`, () => {
    return HttpResponse.json(
      { error: 'Gemini API error' },
      { status: 500 }
    );
  }),
];
