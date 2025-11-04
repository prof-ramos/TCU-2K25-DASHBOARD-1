import type { Materia, Topic, Subtopic, Edital } from '@/types/types';

export const mockSubtopic: Subtopic = {
  id: 'subtopic-1-1',
  title: 'Mock Subtopic 1.1',
};

export const mockSubtopic2: Subtopic = {
  id: 'subtopic-1-2',
  title: 'Mock Subtopic 1.2',
};

export const mockTopicWithSubtopics: Topic = {
  id: 'topic-1',
  title: 'Mock Topic with Subtopics',
  subtopics: [mockSubtopic, mockSubtopic2]
};

export const mockTopicWithoutSubtopics: Topic = {
  id: 'topic-2',
  title: 'Mock Topic without Subtopics',
};

export const mockTopicNested: Topic = {
  id: 'topic-3',
  title: 'Mock Nested Topic',
  subtopics: [
    {
      id: 'subtopic-3-1',
      title: 'Parent Subtopic',
      subtopics: [
        {
          id: 'subtopic-3-1-1',
          title: 'Nested Subtopic'
        }
      ]
    }
  ]
};

export const mockMateria: Materia = {
  id: 'materia-1',
  slug: 'mock-materia',
  name: 'Mock Matéria',
  type: 'CONHECIMENTOS GERAIS',
  topics: [mockTopicWithSubtopics, mockTopicWithoutSubtopics]
};

export const mockEdital: Edital = {
  examDate: '2025-12-31',
  materias: [mockMateria]
};
