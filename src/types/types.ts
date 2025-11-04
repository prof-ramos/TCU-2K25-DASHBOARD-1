
export interface Subtopic {
  id: string;
  title: string;
  subtopics?: Subtopic[];
}

export interface Topic {
  id: string;
  title: string;
  subtopics?: Subtopic[];
}

export interface Materia {
  id: string;
  slug: string;
  name: string;
  type: 'CONHECIMENTOS GERAIS' | 'CONHECIMENTOS ESPECÍFICOS';
  topics: Topic[];
}

export interface Edital {
  examDate: string;
  materias: Materia[];
}

export interface ProgressItem {
  id: string;
  completed: boolean;
}
