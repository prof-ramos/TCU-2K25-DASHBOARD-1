-- Seed data for TCU TI 2025 Edital
-- Generated: 2025-10-30T03:04:50.392Z
-- Migration: 00010_seed_edital_data

-- ============================================
-- SUBJECTS (16 matérias)
-- ============================================

INSERT INTO subjects (tenant_id, external_id, name, slug, type, order_index, is_custom)
VALUES (NULL, 'CON-0', 'LÍNGUA PORTUGUESA', 'lngua-portuguesa', 'CONHECIMENTOS GERAIS', 0, false);
INSERT INTO subjects (tenant_id, external_id, name, slug, type, order_index, is_custom)
VALUES (NULL, 'CON-1', 'LÍNGUA INGLESA', 'lngua-inglesa', 'CONHECIMENTOS GERAIS', 1, false);
INSERT INTO subjects (tenant_id, external_id, name, slug, type, order_index, is_custom)
VALUES (NULL, 'CON-2', 'RACIOCÍNIO ANÁLITICO', 'raciocnio-anlitico', 'CONHECIMENTOS GERAIS', 2, false);
INSERT INTO subjects (tenant_id, external_id, name, slug, type, order_index, is_custom)
VALUES (NULL, 'CON-3', 'CONTROLE EXTERNO', 'controle-externo', 'CONHECIMENTOS GERAIS', 3, false);
INSERT INTO subjects (tenant_id, external_id, name, slug, type, order_index, is_custom)
VALUES (NULL, 'CON-4', 'ADMINISTRAÇÃO PÚBLICA', 'administrao-pblica', 'CONHECIMENTOS GERAIS', 4, false);
INSERT INTO subjects (tenant_id, external_id, name, slug, type, order_index, is_custom)
VALUES (NULL, 'CON-5', 'DIREITO CONSTITUCIONAL', 'direito-constitucional', 'CONHECIMENTOS GERAIS', 5, false);
INSERT INTO subjects (tenant_id, external_id, name, slug, type, order_index, is_custom)
VALUES (NULL, 'CON-6', 'DIREITO ADMINISTRATIVO', 'direito-administrativo', 'CONHECIMENTOS GERAIS', 6, false);
INSERT INTO subjects (tenant_id, external_id, name, slug, type, order_index, is_custom)
VALUES (NULL, 'CON-7', 'AUDITORIA GOVERNAMENTAL', 'auditoria-governamental', 'CONHECIMENTOS GERAIS', 7, false);
INSERT INTO subjects (tenant_id, external_id, name, slug, type, order_index, is_custom)
VALUES (NULL, 'ESP-0', 'INFRAESTRUTURA DE TI', 'infraestrutura-de-ti', 'CONHECIMENTOS ESPECÍFICOS', 100, false);
INSERT INTO subjects (tenant_id, external_id, name, slug, type, order_index, is_custom)
VALUES (NULL, 'ESP-1', 'ENGENHARIA DE DADOS', 'engenharia-de-dados', 'CONHECIMENTOS ESPECÍFICOS', 101, false);
INSERT INTO subjects (tenant_id, external_id, name, slug, type, order_index, is_custom)
VALUES (NULL, 'ESP-2', 'ENGENHARIA DE SOFTWARE', 'engenharia-de-software', 'CONHECIMENTOS ESPECÍFICOS', 102, false);
INSERT INTO subjects (tenant_id, external_id, name, slug, type, order_index, is_custom)
VALUES (NULL, 'ESP-3', 'SEGURANÇA DA INFORMAÇÃO', 'segurana-da-informao', 'CONHECIMENTOS ESPECÍFICOS', 103, false);
INSERT INTO subjects (tenant_id, external_id, name, slug, type, order_index, is_custom)
VALUES (NULL, 'ESP-4', 'COMPUTAÇÃO EM NUVEM', 'computao-em-nuvem', 'CONHECIMENTOS ESPECÍFICOS', 104, false);
INSERT INTO subjects (tenant_id, external_id, name, slug, type, order_index, is_custom)
VALUES (NULL, 'ESP-5', 'INTELIGÊNCIA ARTIFICIAL', 'inteligncia-artificial', 'CONHECIMENTOS ESPECÍFICOS', 105, false);
INSERT INTO subjects (tenant_id, external_id, name, slug, type, order_index, is_custom)
VALUES (NULL, 'ESP-6', 'CONTRATAÇÕES DE TI', 'contrataes-de-ti', 'CONHECIMENTOS ESPECÍFICOS', 106, false);
INSERT INTO subjects (tenant_id, external_id, name, slug, type, order_index, is_custom)
VALUES (NULL, 'ESP-7', 'GESTÃO DE TECNOLOGIA DA INFORMAÇÃO', 'gesto-de-tecnologia-da-informao', 'CONHECIMENTOS ESPECÍFICOS', 107, false);

-- ============================================
-- TOPICS (112 tópicos principais)
-- ============================================

INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-0'), 'CON-0-1', 'Compreensão e interpretação de textos de gêneros variados', 0);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-0'), 'CON-0-2', 'Reconhecimento de tipos e gêneros textuais', 1);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-0'), 'CON-0-3', 'Domínio da ortografia oficial', 2);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-0'), 'CON-0-4', 'Domínio dos mecanismos de coesão textual', 3);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-0'), 'CON-0-6', 'Domínio da estrutura morfossintática do período', 5);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-0'), 'CON-0-8', 'Reescrita de frases e parágrafos do texto', 7);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-1'), 'CON-1-1', 'Compreensão de textos variados: domínio do vocabulário e da estrutura da língua, ideias principais e secundárias, explícitas e implícitas, relações intratextuais e intertextuais', 0);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-1'), 'CON-1-2', 'Itens gramaticais relevantes para compreensão de conteúdos semânticos', 1);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-1'), 'CON-1-3', 'Conhecimento e uso das formas contemporâneas da linguagem inglesa', 2);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-2'), 'CON-2-1', 'Raciocínio analítico e a argumentação', 0);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-3'), 'CON-3-1', 'Conceito, tipos e formas de controle', 0);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-3'), 'CON-3-2', 'Controle interno e externo', 1);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-3'), 'CON-3-3', 'Controle parlamentar', 2);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-3'), 'CON-3-4', 'Controle pelos tribunais de contas', 3);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-3'), 'CON-3-5', 'Controle administrativo', 4);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-3'), 'CON-3-6', 'Lei nº 8.429/1992 (Lei de Improbidade Administrativa)', 5);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-3'), 'CON-3-7', 'Sistemas de controle jurisdicional da administração pública', 6);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-3'), 'CON-3-9', 'Controle jurisdicional da administração pública no direito brasileiro', 8);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-3'), 'CON-3-10', 'Controle da atividade financeira do Estado: espécies e sistemas', 9);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-3'), 'CON-3-11', 'Tribunal de Contas da União (TCU), Tribunais de Contas dos Estados e do Distrito Federal', 10);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-4'), 'CON-4-1', 'Administração', 0);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-4'), 'CON-4-3', 'Processo administrativo', 2);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-4'), 'CON-4-5', 'Gestão de pessoas', 4);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-4'), 'CON-4-7', 'Noções de gestão de processos: técnicas de mapeamento, análise e melhoria de processos', 6);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-4'), 'CON-4-8', 'Gestão de projetos', 7);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-4'), 'CON-4-10', 'Administração de recursos materiais', 9);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-4'), 'CON-4-11', 'ESG', 10);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-5'), 'CON-5-1', 'Constituição', 0);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-5'), 'CON-5-3', 'Poder constituinte', 2);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-5'), 'CON-5-5', 'Princípios fundamentais', 4);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-5'), 'CON-5-6', 'Direitos e garantias fundamentais', 5);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-5'), 'CON-5-8', 'Organização do Estado', 7);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-5'), 'CON-5-10', 'Administração pública', 9);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-5'), 'CON-5-12', 'Organização dos poderes no Estado', 11);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-5'), 'CON-5-14', 'Funções essenciais à justiça', 13);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-5'), 'CON-5-16', 'Controle de constitucionalidade', 15);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-5'), 'CON-5-18', 'Defesa do Estado e das instituições democráticas', 17);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-5'), 'CON-5-20', 'Sistema Tributário Nacional', 19);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-6'), 'CON-6-1', 'Estado, governo e administração pública', 0);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-6'), 'CON-6-3', 'Direito administrativo', 2);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-6'), 'CON-6-5', 'Ato administrativo', 4);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-6'), 'CON-6-7', 'Agentes públicos', 6);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-6'), 'CON-6-9', 'Poderes da administração pública', 8);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-6'), 'CON-6-11', 'Regime jurídico-administrativo', 10);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-6'), 'CON-6-13', 'Responsabilidade civil do Estado', 12);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-6'), 'CON-6-15', 'Serviços públicos', 14);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-6'), 'CON-6-17', 'Organização administrativa', 16);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-7'), 'CON-7-1', 'Conceito, finalidade, objetivo, abrangência e atuação', 0);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-7'), 'CON-7-3', 'Instrumentos de fiscalização: auditoria, levantamento, monitoramento, acompanhamento e inspeção', 2);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-7'), 'CON-7-4', 'Tipos de auditoria', 3);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-7'), 'CON-7-6', 'Normas de auditoria', 5);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-7'), 'CON-7-8', 'Planejamento de auditoria', 7);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-7'), 'CON-7-10', 'Execução da auditoria', 9);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-7'), 'CON-7-12', 'Evidências', 11);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'CON-7'), 'CON-7-14', 'Comunicação dos resultados: relatórios de auditoria', 13);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-0'), 'ESP-0-1', 'Arquitetura e Infraestrutura de TI', 0);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-0'), 'ESP-0-3', 'Redes e Comunicação de Dados', 2);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-0'), 'ESP-0-5', 'Sistemas Operacionais e Servidores', 4);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-0'), 'ESP-0-7', 'Armazenamento e Backup', 6);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-0'), 'ESP-0-9', 'Segurança de Infraestrutura', 8);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-0'), 'ESP-0-11', 'Monitoramento, Gestão e Automação', 10);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-0'), 'ESP-0-13', 'Alta Disponibilidade e Recuperação de Desastres', 12);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-1'), 'ESP-1-1', 'Bancos de Dados', 0);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-1'), 'ESP-1-3', 'Arquitetura de Inteligência de Negócio', 2);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-1'), 'ESP-1-5', 'Conectores e Integração com Fontes de Dados', 4);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-1'), 'ESP-1-7', 'Fluxo de Manipulação de Dados', 6);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-1'), 'ESP-1-9', 'Governança e Qualidade de Dados', 8);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-1'), 'ESP-1-11', 'Integração com Nuvem', 10);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-2'), 'ESP-2-1', 'Arquitetura de Software', 0);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-2'), 'ESP-2-3', 'Design e Programação', 2);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-2'), 'ESP-2-5', 'APIs e Integrações', 4);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-2'), 'ESP-2-7', 'Persistência de Dados', 6);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-2'), 'ESP-2-9', 'DevOps e Integração Contínua', 8);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-2'), 'ESP-2-11', 'Testes e Qualidade de Código', 10);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-2'), 'ESP-2-13', 'Linguagens de Programação', 12);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-2'), 'ESP-2-15', 'Desenvolvimento Seguro', 14);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-3'), 'ESP-3-1', 'Gestão de Identidades e Acesso', 0);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-3'), 'ESP-3-3', 'Privacidade e segurança por padrão', 2);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-3'), 'ESP-3-4', 'Malware', 3);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-3'), 'ESP-3-6', 'Controles e testes de segurança para aplicações Web e Web Services', 5);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-3'), 'ESP-3-7', 'Múltiplos Fatores de Autenticação (MFA)', 6);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-3'), 'ESP-3-8', 'Soluções para Segurança da Informação', 7);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-3'), 'ESP-3-10', 'Frameworks de segurança', 9);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-3'), 'ESP-3-12', 'Tratamento de incidentes cibernéticos', 11);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-3'), 'ESP-3-13', 'Assinatura e certificação digital, criptografia e proteção de dados em trânsito e em repouso', 12);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-3'), 'ESP-3-14', 'Segurança em nuvens e de contêineres', 13);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-3'), 'ESP-3-15', 'Ataques a redes', 14);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-4'), 'ESP-4-1', 'Fundamentos de Computação em Nuvem', 0);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-4'), 'ESP-4-3', 'Plataformas e Serviços de Nuvem', 2);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-4'), 'ESP-4-5', 'Arquitetura de Soluções em Nuvem', 4);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-4'), 'ESP-4-7', 'Redes e Segurança em Nuvem', 6);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-4'), 'ESP-4-9', 'DevOps, CI/CD e Infraestrutura como Código (IaC)', 8);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-4'), 'ESP-4-11', 'Governança, Compliance e Custos', 10);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-4'), 'ESP-4-13', 'Armazenamento e Processamento de Dados', 12);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-4'), 'ESP-4-15', 'Migração e Modernização de Aplicações', 14);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-4'), 'ESP-4-17', 'Multicloud', 16);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-4'), 'ESP-4-19', 'Normas sobre computação em nuvem no governo federal', 18);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-5'), 'ESP-5-1', 'Aprendizado de Máquina', 0);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-5'), 'ESP-5-3', 'Redes Neurais e Deep Learning', 2);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-5'), 'ESP-5-5', 'Processamento de Linguagem Natural', 4);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-5'), 'ESP-5-7', 'Inteligência Artificial Generativa', 6);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-5'), 'ESP-5-8', 'Arquitetura e Engenharia de Sistemas de IA', 7);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-5'), 'ESP-5-10', 'Ética, Transparência e Responsabilidade em IA', 9);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-6'), 'ESP-6-1', 'Etapas da Contratação de Soluções de TI', 0);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-6'), 'ESP-6-3', 'Tipos de Soluções e Modelos de Serviço', 2);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-6'), 'ESP-6-5', 'Governança, Fiscalização e Gestão de Contratos', 4);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-6'), 'ESP-6-7', 'Riscos e Controles em Contratações', 6);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-6'), 'ESP-6-9', 'Aspectos Técnicos e Estratégicos', 8);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-6'), 'ESP-6-11', 'Legislação e Normativos Aplicáveis', 10);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-7'), 'ESP-7-1', 'Gerenciamento de Serviços (ITIL v4)', 0);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-7'), 'ESP-7-3', 'Governança de TI (COBIT 5)', 2);
INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = 'ESP-7'), 'ESP-7-5', 'Metodologias Ágeis', 4);

-- ============================================
-- SUBTOPICS (327 subtópicos)
-- ============================================

INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-0-4'),
  NULL,
  'CON-0-4.1',
  'Emprego de elementos de referenciação, substituição e repetição, de conectores e de outros elementos de sequenciação textual',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-0-4'),
  NULL,
  'CON-0-4.2',
  'Emprego de tempos e modos verbais',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-0-6'),
  NULL,
  'CON-0-6.1',
  'Emprego das classes de palavras',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-0-6'),
  NULL,
  'CON-0-6.2',
  'Relações de coordenação entre orações e entre termos da oração',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-0-6'),
  NULL,
  'CON-0-6.3',
  'Relações de subordinação entre orações e entre termos da oração',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-0-6'),
  NULL,
  'CON-0-6.4',
  'Emprego dos sinais de pontuação',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-0-6'),
  NULL,
  'CON-0-6.5',
  'Concordância verbal e nominal',
  1,
  4
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-0-6'),
  NULL,
  'CON-0-6.6',
  'Regência verbal e nominal',
  1,
  5
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-0-6'),
  NULL,
  'CON-0-6.7',
  'Emprego do sinal indicativo de crase',
  1,
  6
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-0-6'),
  NULL,
  'CON-0-6.8',
  'Colocação dos pronomes átonos',
  1,
  7
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-0-8'),
  NULL,
  'CON-0-8.1',
  'Significação das palavras',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-0-8'),
  NULL,
  'CON-0-8.2',
  'Substituição de palavras ou de trechos de texto',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-0-8'),
  NULL,
  'CON-0-8.3',
  'Reorganização da estrutura de orações e de períodos do texto',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-0-8'),
  NULL,
  'CON-0-8.4',
  'Reescrita de textos de diferentes gêneros e níveis de formalidade',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-2-1'),
  NULL,
  'CON-2-1.1',
  'O uso do senso crítico na argumentação',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-2-1'),
  NULL,
  'CON-2-1.2',
  'Tipos de argumentos: argumentos falaciosos e apelativos',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-2-1'),
  NULL,
  'CON-2-1.3',
  'Comunicação eficiente de argumentos',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-3-7'),
  NULL,
  'CON-3-7.1',
  'Contencioso administrativo e sistema da jurisdição una',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-4-1'),
  NULL,
  'CON-4-1.1',
  'Abordagens clássica, burocrática e sistêmica da administração',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-4-1'),
  NULL,
  'CON-4-1.2',
  'Evolução da administração pública no Brasil após 1930; reformas administrativas; a nova gestão pública',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-4-3'),
  NULL,
  'CON-4-3.1',
  'Funções da administração: planejamento, organização, direção e controle',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-4-3'),
  NULL,
  'CON-4-3.2',
  'Estrutura organizacional',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-4-3'),
  NULL,
  'CON-4-3.3',
  'Cultura organizacional',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-4-5'),
  NULL,
  'CON-4-5.1',
  'Equilíbrio organizacional',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-4-5'),
  NULL,
  'CON-4-5.2',
  'Objetivos, desafios e características da gestão de pessoas',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-4-5'),
  NULL,
  'CON-4-5.3',
  'Comportamento organizacional: relações indivíduo/organização, motivação, liderança, desempenho',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-4-8'),
  NULL,
  'CON-4-8.1',
  'Elaboração, análise e avaliação de projetos',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-4-8'),
  NULL,
  'CON-4-8.2',
  'Principais características dos modelos de gestão de projetos',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-4-8'),
  NULL,
  'CON-4-8.3',
  'Projetos e suas etapas',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-4-8'),
  NULL,
  'CON-4-8.4',
  'Metodologia ágil',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-1'),
  NULL,
  'CON-5-1.1',
  'Conceito, objeto, elementos e classificações',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-1'),
  NULL,
  'CON-5-1.2',
  'Supremacia da Constituição',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-1'),
  NULL,
  'CON-5-1.3',
  'Aplicabilidade das normas constitucionais',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-1'),
  NULL,
  'CON-5-1.4',
  'Interpretação das normas constitucionais',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-1'),
  NULL,
  'CON-5-1.5',
  'Mutação constitucional',
  1,
  4
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-3'),
  NULL,
  'CON-5-3.1',
  'Características',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-3'),
  NULL,
  'CON-5-3.2',
  'Poder constituinte originário',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-3'),
  NULL,
  'CON-5-3.3',
  'Poder constituinte derivado',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-6'),
  NULL,
  'CON-5-6.1',
  'Direitos e deveres individuais e coletivos',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-6'),
  NULL,
  'CON-5-6.2',
  'Habeas corpus, mandado de segurança, mandado de injunção e habeas data',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-6'),
  NULL,
  'CON-5-6.3',
  'Direitos sociais',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-6'),
  NULL,
  'CON-5-6.4',
  'Direitos políticos',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-6'),
  NULL,
  'CON-5-6.5',
  'Partidos políticos',
  1,
  4
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-6'),
  NULL,
  'CON-5-6.6',
  'O ente estatal titular de direitos fundamentais',
  1,
  5
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-8'),
  NULL,
  'CON-5-8.1',
  'Organização político-administrativa',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-8'),
  NULL,
  'CON-5-8.2',
  'Estado federal brasileiro',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-8'),
  NULL,
  'CON-5-8.3',
  'A União',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-8'),
  NULL,
  'CON-5-8.4',
  'Estados federados',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-8'),
  NULL,
  'CON-5-8.5',
  'Municípios',
  1,
  4
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-8'),
  NULL,
  'CON-5-8.6',
  'O Distrito Federal',
  1,
  5
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-8'),
  NULL,
  'CON-5-8.7',
  'Territórios',
  1,
  6
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-8'),
  NULL,
  'CON-5-8.8',
  'Intervenção federal',
  1,
  7
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-8'),
  NULL,
  'CON-5-8.9',
  'Intervenção dos estados nos municípios',
  1,
  8
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-10'),
  NULL,
  'CON-5-10.1',
  'Disposições gerais',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-10'),
  NULL,
  'CON-5-10.2',
  'Servidores públicos',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-12'),
  NULL,
  'CON-5-12.1',
  'Mecanismos de freios e contrapesos',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-12'),
  NULL,
  'CON-5-12.2',
  'Poder Legislativo',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-12'),
  NULL,
  'CON-5-12.3',
  'Poder Executivo',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-12'),
  NULL,
  'CON-5-12.4',
  'Poder Judiciário',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-14'),
  NULL,
  'CON-5-14.1',
  'Ministério Público',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-14'),
  NULL,
  'CON-5-14.2',
  'Advocacia Pública',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-14'),
  NULL,
  'CON-5-14.3',
  'Advocacia e Defensoria Pública',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-16'),
  NULL,
  'CON-5-16.1',
  'Sistemas gerais e sistema brasileiro',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-16'),
  NULL,
  'CON-5-16.2',
  'Controle incidental ou concreto',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-16'),
  NULL,
  'CON-5-16.3',
  'Controle abstrato de constitucionalidade',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-16'),
  NULL,
  'CON-5-16.4',
  'Exame *in abstractu* da constitucionalidade de proposições legislativas',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-16'),
  NULL,
  'CON-5-16.5',
  'Ação declaratória de constitucionalidade',
  1,
  4
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-16'),
  NULL,
  'CON-5-16.6',
  'Ação direta de inconstitucionalidade',
  1,
  5
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-16'),
  NULL,
  'CON-5-16.7',
  'Arguição de descumprimento de preceito fundamental',
  1,
  6
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-16'),
  NULL,
  'CON-5-16.8',
  'Ação direta de inconstitucionalidade por omissão',
  1,
  7
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-16'),
  NULL,
  'CON-5-16.9',
  'Ação direta de inconstitucionalidade interventiva',
  1,
  8
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-18'),
  NULL,
  'CON-5-18.1',
  'Estado de defesa e estado de sítio',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-18'),
  NULL,
  'CON-5-18.2',
  'Forças armadas',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-18'),
  NULL,
  'CON-5-18.3',
  'Segurança pública',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-20'),
  NULL,
  'CON-5-20.1',
  'Princípios gerais',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-20'),
  NULL,
  'CON-5-20.2',
  'Limitações do poder de tributar',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-20'),
  NULL,
  'CON-5-20.3',
  'Impostos da União',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-20'),
  NULL,
  'CON-5-20.4',
  'Impostos dos estados e do Distrito Federal',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-5-20'),
  NULL,
  'CON-5-20.5',
  'Impostos dos municípios',
  1,
  4
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-1'),
  NULL,
  'CON-6-1.1',
  'Conceitos',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-1'),
  NULL,
  'CON-6-1.2',
  'Elementos',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-3'),
  NULL,
  'CON-6-3.1',
  'Conceito',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-3'),
  NULL,
  'CON-6-3.2',
  'Objeto',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-3'),
  NULL,
  'CON-6-3.3',
  'Fontes',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-5'),
  NULL,
  'CON-6-5.1',
  'Conceito, requisitos, atributos, classificação e espécies',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-5'),
  NULL,
  'CON-6-5.2',
  'Extinção do ato administrativo: cassação, anulação, revogação e convalidação',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-5'),
  NULL,
  'CON-6-5.3',
  'Decadência administrativa',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-7'),
  NULL,
  'CON-6-7.1',
  'Legislação pertinente',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-7'),
  (SELECT id FROM subtopics WHERE external_id = 'CON-6-7.1'),
  'CON-6-7.1.1',
  'Lei nº 8.112/1990',
  2,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-7'),
  (SELECT id FROM subtopics WHERE external_id = 'CON-6-7.1'),
  'CON-6-7.1.2',
  'Disposições constitucionais aplicáveis',
  2,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-7'),
  NULL,
  'CON-6-7.2',
  'Disposições doutrinárias',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-7'),
  (SELECT id FROM subtopics WHERE external_id = 'CON-6-7.2'),
  'CON-6-7.2.1',
  'Conceito',
  2,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-7'),
  (SELECT id FROM subtopics WHERE external_id = 'CON-6-7.2'),
  'CON-6-7.2.2',
  'Espécies',
  2,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-7'),
  (SELECT id FROM subtopics WHERE external_id = 'CON-6-7.2'),
  'CON-6-7.2.3',
  'Cargo, emprego e função pública',
  2,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-7'),
  (SELECT id FROM subtopics WHERE external_id = 'CON-6-7.2'),
  'CON-6-7.2.4',
  'Provimento',
  2,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-7'),
  (SELECT id FROM subtopics WHERE external_id = 'CON-6-7.2'),
  'CON-6-7.2.5',
  'Vacância',
  2,
  4
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-7'),
  (SELECT id FROM subtopics WHERE external_id = 'CON-6-7.2'),
  'CON-6-7.2.6',
  'Efetividade, estabilidade e vitaliciedade',
  2,
  5
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-7'),
  (SELECT id FROM subtopics WHERE external_id = 'CON-6-7.2'),
  'CON-6-7.2.7',
  'Remuneração',
  2,
  6
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-7'),
  (SELECT id FROM subtopics WHERE external_id = 'CON-6-7.2'),
  'CON-6-7.2.8',
  'Direitos e deveres',
  2,
  7
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-7'),
  (SELECT id FROM subtopics WHERE external_id = 'CON-6-7.2'),
  'CON-6-7.2.9',
  'Responsabilidade',
  2,
  8
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-7'),
  (SELECT id FROM subtopics WHERE external_id = 'CON-6-7.2'),
  'CON-6-7.2.10',
  'Processo administrativo disciplinar',
  2,
  9
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-9'),
  NULL,
  'CON-6-9.1',
  'Hierárquico, disciplinar, regulamentar e de polícia',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-9'),
  NULL,
  'CON-6-9.2',
  'Uso e abuso do poder',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-11'),
  NULL,
  'CON-6-11.1',
  'Conceito',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-11'),
  NULL,
  'CON-6-11.2',
  'Princípios expressos e implícitos da administração pública',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-13'),
  NULL,
  'CON-6-13.1',
  'Evolução histórica',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-13'),
  NULL,
  'CON-6-13.2',
  'Responsabilidade civil do Estado no direito brasileiro',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-13'),
  (SELECT id FROM subtopics WHERE external_id = 'CON-6-13.2'),
  'CON-6-13.2.1',
  'Responsabilidade por ato comissivo do Estado',
  2,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-13'),
  (SELECT id FROM subtopics WHERE external_id = 'CON-6-13.2'),
  'CON-6-13.2.2',
  'Responsabilidade por omissão do Estado',
  2,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-13'),
  NULL,
  'CON-6-13.3',
  'Requisitos para a demonstração da responsabilidade do Estado',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-13'),
  NULL,
  'CON-6-13.4',
  'Causas excludentes e atenuantes da responsabilidade do Estado',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-13'),
  NULL,
  'CON-6-13.5',
  'Reparação do dano',
  1,
  4
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-13'),
  NULL,
  'CON-6-13.6',
  'Direito de regresso',
  1,
  5
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-15'),
  NULL,
  'CON-6-15.1',
  'Conceito',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-15'),
  NULL,
  'CON-6-15.2',
  'Elementos constitutivos',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-15'),
  NULL,
  'CON-6-15.3',
  'Formas de prestação e meios de execução',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-15'),
  NULL,
  'CON-6-15.4',
  'Delegação: concessão, permissão e autorização',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-15'),
  NULL,
  'CON-6-15.5',
  'Classificação',
  1,
  4
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-15'),
  NULL,
  'CON-6-15.6',
  'Princípios',
  1,
  5
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-17'),
  NULL,
  'CON-6-17.1',
  'Centralização, descentralização, concentração e desconcentração',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-17'),
  NULL,
  'CON-6-17.2',
  'Administração direta e indireta',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-17'),
  NULL,
  'CON-6-17.3',
  'Autarquias, fundações, empresas públicas e sociedades de economia mista',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-6-17'),
  NULL,
  'CON-6-17.4',
  'Entidades paraestatais e terceiro setor',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-7-1'),
  NULL,
  'CON-7-1.1',
  'Auditoria interna e externa: papéis',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-7-4'),
  NULL,
  'CON-7-4.1',
  'Auditoria de conformidade',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-7-4'),
  NULL,
  'CON-7-4.2',
  'Auditoria operacional',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-7-4'),
  NULL,
  'CON-7-4.3',
  'Auditoria financeira',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-7-6'),
  NULL,
  'CON-7-6.1',
  'Normas de Auditoria do TCU',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-7-6'),
  NULL,
  'CON-7-6.2',
  'Normas da INTOSAI (Organização Internacional das Instituições Superiores de Controle): código de ética e princípios fundamentais de auditoria do setor público (ISSAIs 100, 200, 300 e 400)',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-7-6'),
  NULL,
  'CON-7-6.3',
  'Normas Brasileiras de Auditoria do Setor Público (NBASP)',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-7-8'),
  NULL,
  'CON-7-8.1',
  'Determinação de escopo',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-7-8'),
  NULL,
  'CON-7-8.2',
  'Materialidade, risco e relevância',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-7-8'),
  NULL,
  'CON-7-8.3',
  'Importância da amostragem estatística em auditoria',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-7-8'),
  NULL,
  'CON-7-8.4',
  'Matriz de planejamento',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-7-10'),
  NULL,
  'CON-7-10.1',
  'Programas de auditoria',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-7-10'),
  NULL,
  'CON-7-10.2',
  'Papéis de trabalho',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-7-10'),
  NULL,
  'CON-7-10.3',
  'Testes de auditoria',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-7-10'),
  NULL,
  'CON-7-10.4',
  'Técnicas e procedimentos',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-7-12'),
  NULL,
  'CON-7-12.1',
  'Caracterização de achados de auditoria',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'CON-7-12'),
  NULL,
  'CON-7-12.2',
  'Matriz de Achados e Matriz de Responsabilização',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-0-1'),
  NULL,
  'ESP-0-1.1',
  'Topologias físicas e lógicas de redes corporativas',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-0-1'),
  NULL,
  'ESP-0-1.2',
  'Arquiteturas de data center (on-premises, cloud, híbrida)',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-0-1'),
  NULL,
  'ESP-0-1.3',
  'Infraestrutura hiperconvergente',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-0-1'),
  NULL,
  'ESP-0-1.4',
  'Arquitetura escalável, tolerante a falhas e redundante',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-0-3'),
  NULL,
  'ESP-0-3.1',
  'Protocolos de comunicação de dados',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-0-3'),
  NULL,
  'ESP-0-3.2',
  'VLANs, STP, QoS, roteamento e switching em ambientes corporativos',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-0-3'),
  NULL,
  'ESP-0-3.3',
  'SDN (Software Defined Networking) e redes programáveis',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-0-3'),
  NULL,
  'ESP-0-3.4',
  'Wireless corporativo: Wi-Fi 6, WPA3, roaming, mesh',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-0-5'),
  NULL,
  'ESP-0-5.1',
  'Administração avançada de Linux e Windows Server',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-0-5'),
  NULL,
  'ESP-0-5.2',
  'Virtualização (KVM, VMware vSphere/ESXi)',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-0-5'),
  NULL,
  'ESP-0-5.3',
  'Serviços de diretório (Active Directory, LDAP)',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-0-5'),
  NULL,
  'ESP-0-5.4',
  'Gerenciamento de usuários, permissões e GPOS',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-0-7'),
  NULL,
  'ESP-0-7.1',
  'SAN, NAS, DAS: arquiteturas e protocolos (iSCSI, NFS, SMB)',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-0-7'),
  NULL,
  'ESP-0-7.2',
  'RAID (níveis, vantagens, hot-spare)',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-0-7'),
  NULL,
  'ESP-0-7.3',
  'Backup e recuperação: RPO, RTO, snapshots, deduplicação',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-0-7'),
  NULL,
  'ESP-0-7.4',
  'Oracle RMAN',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-0-9'),
  NULL,
  'ESP-0-9.1',
  'Hardening de servidores e dispositivos de rede',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-0-9'),
  NULL,
  'ESP-0-9.2',
  'Firewalls (NGFW), IDS/IPS, proxies, NAC',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-0-9'),
  NULL,
  'ESP-0-9.3',
  'VPNs, SSL/TLS, PKI, criptografia de dados',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-0-9'),
  NULL,
  'ESP-0-9.4',
  'Segmentação de rede e zonas de segurança',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-0-11'),
  NULL,
  'ESP-0-11.1',
  'Ferramentas: Zabbix, New Relic e Grafana',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-0-11'),
  NULL,
  'ESP-0-11.2',
  'Gerência de capacidade, disponibilidade e desempenho',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-0-11'),
  NULL,
  'ESP-0-11.3',
  'ITIL v4: incidentes, problemas, mudanças e configurações (CMDB)',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-0-11'),
  NULL,
  'ESP-0-11.4',
  'Scripts e automação com PowerShell, Bash e Puppet',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-0-13'),
  NULL,
  'ESP-0-13.1',
  'Clusters de alta disponibilidade e balanceamento de carga',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-0-13'),
  NULL,
  'ESP-0-13.2',
  'Failover, heartbeat, fencing',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-0-13'),
  NULL,
  'ESP-0-13.3',
  'Planos de continuidade de negócios e testes de DR',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-1-1'),
  NULL,
  'ESP-1-1.1',
  'Relacionais: Oracle e Microsoft SQL Server',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-1-1'),
  NULL,
  'ESP-1-1.2',
  'Não relacionais (NoSQL): Elasticsearch e MongoDB',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-1-1'),
  NULL,
  'ESP-1-1.3',
  'Modelagens de dados: relacional, multidimensional e NoSQL',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-1-1'),
  NULL,
  'ESP-1-1.4',
  'SQL (Procedural Language / Structured Query Language)',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-1-3'),
  NULL,
  'ESP-1-3.1',
  'Data Warehouse',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-1-3'),
  NULL,
  'ESP-1-3.2',
  'Data Mart',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-1-3'),
  NULL,
  'ESP-1-3.3',
  'Data Lake',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-1-3'),
  NULL,
  'ESP-1-3.4',
  'Data Mesh',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-1-5'),
  NULL,
  'ESP-1-5.1',
  'APIs REST/SOAP e Web Services',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-1-5'),
  NULL,
  'ESP-1-5.2',
  'Arquivos planos (CSV, JSON, XML, Parquet)',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-1-5'),
  NULL,
  'ESP-1-5.3',
  'Mensageria e eventos',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-1-5'),
  NULL,
  'ESP-1-5.4',
  'Controle de integridade de dados',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-1-5'),
  NULL,
  'ESP-1-5.5',
  'Segurança na captação de dados',
  1,
  4
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-1-5'),
  NULL,
  'ESP-1-5.6',
  'Estratégias de buffer e ordenação',
  1,
  5
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-1-7'),
  NULL,
  'ESP-1-7.1',
  'ETL',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-1-7'),
  NULL,
  'ESP-1-7.2',
  'Pipeline de dados',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-1-7'),
  NULL,
  'ESP-1-7.3',
  'Integração com CI/CD',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-1-9'),
  NULL,
  'ESP-1-9.1',
  'Linhagem e catalogação',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-1-9'),
  NULL,
  'ESP-1-9.2',
  'Qualidade de dados',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-1-9'),
  NULL,
  'ESP-1-9.3',
  'Metadados, glossários de dados e políticas de acesso',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-1-11'),
  NULL,
  'ESP-1-11.1',
  'Serviços gerenciados (Azure Data Factory, Azure Service Fabric, Azure Databricks)',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-1-11'),
  NULL,
  'ESP-1-11.2',
  'Armazenamento (S3, Azure Blob, GCS)',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-1-11'),
  NULL,
  'ESP-1-11.3',
  'Integração com serviços de IA e análise',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-2-1'),
  NULL,
  'ESP-2-1.1',
  'Padrões arquiteturais',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-2-1'),
  NULL,
  'ESP-2-1.2',
  'Monolito',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-2-1'),
  NULL,
  'ESP-2-1.3',
  'Microserviços',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-2-1'),
  NULL,
  'ESP-2-1.4',
  'Serverless',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-2-1'),
  NULL,
  'ESP-2-1.5',
  'Arquitetura orientada a eventos e mensageria',
  1,
  4
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-2-1'),
  NULL,
  'ESP-2-1.6',
  'Padrões de integração (API Gateway, Service Mesh, CQRS)',
  1,
  5
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-2-3'),
  NULL,
  'ESP-2-3.1',
  'Padrões de projeto (GoF e GRASP)',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-2-3'),
  NULL,
  'ESP-2-3.2',
  'Concorrência, paralelismo, multithreading e programação assíncrona',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-2-5'),
  NULL,
  'ESP-2-5.1',
  'Design e versionamento de APIs RESTful',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-2-5'),
  NULL,
  'ESP-2-5.2',
  'Boas práticas de autenticação e autorização (OAuth2, JWT, OpenID Connect)',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-2-7'),
  NULL,
  'ESP-2-7.1',
  'Modelagem relacional e normalização',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-2-7'),
  NULL,
  'ESP-2-7.2',
  'Bancos NoSQL (MongoDB e Elasticsearch)',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-2-7'),
  NULL,
  'ESP-2-7.3',
  'Versionamento e migração de esquemas',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-2-9'),
  NULL,
  'ESP-2-9.1',
  'Pipelines de CI/CD (GitHub Actions)',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-2-9'),
  NULL,
  'ESP-2-9.2',
  'Build, testes e deploy automatizados',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-2-9'),
  NULL,
  'ESP-2-9.3',
  'Docker e orquestração com Kubernetes',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-2-9'),
  NULL,
  'ESP-2-9.4',
  'Monitoramento e observabilidade: Grafana e New Relic',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-2-11'),
  NULL,
  'ESP-2-11.1',
  'Testes automatizados: unitários, de integração e de contrato (API)',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-2-11'),
  NULL,
  'ESP-2-11.2',
  'Análise estática de código e cobertura (SonarQube)',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-2-13'),
  NULL,
  'ESP-2-13.1',
  'Java',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-2-15'),
  NULL,
  'ESP-2-15.1',
  'DevSecOps',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-3-1'),
  NULL,
  'ESP-3-1.1',
  'Autenticação e autorização',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-3-1'),
  NULL,
  'ESP-3-1.2',
  'Single Sign-On (SSO)',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-3-1'),
  NULL,
  'ESP-3-1.3',
  'Security Assertion Markup Language (SAML)',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-3-1'),
  NULL,
  'ESP-3-1.4',
  'OAuth2 e OpenID Connect',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-3-4'),
  NULL,
  'ESP-3-4.1',
  'Vírus',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-3-4'),
  NULL,
  'ESP-3-4.2',
  'Keylogger',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-3-4'),
  NULL,
  'ESP-3-4.3',
  'Trojan',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-3-4'),
  NULL,
  'ESP-3-4.4',
  'Spyware',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-3-4'),
  NULL,
  'ESP-3-4.5',
  'Backdoor',
  1,
  4
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-3-4'),
  NULL,
  'ESP-3-4.6',
  'Worms',
  1,
  5
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-3-4'),
  NULL,
  'ESP-3-4.7',
  'Rootkit',
  1,
  6
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-3-4'),
  NULL,
  'ESP-3-4.8',
  'Adware',
  1,
  7
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-3-4'),
  NULL,
  'ESP-3-4.9',
  'Fileless',
  1,
  8
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-3-4'),
  NULL,
  'ESP-3-4.10',
  'Ransomware',
  1,
  9
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-3-8'),
  NULL,
  'ESP-3-8.1',
  'Firewall',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-3-8'),
  NULL,
  'ESP-3-8.2',
  'Intrusion Detection System (IDS)',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-3-8'),
  NULL,
  'ESP-3-8.3',
  'Intrusion Prevention System (IPS)',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-3-8'),
  NULL,
  'ESP-3-8.4',
  'Security Information and Event Management (SIEM)',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-3-8'),
  NULL,
  'ESP-3-8.5',
  'Proxy',
  1,
  4
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-3-8'),
  NULL,
  'ESP-3-8.6',
  'Identity Access Management (IAM)',
  1,
  5
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-3-8'),
  NULL,
  'ESP-3-8.7',
  'Privileged Access Management (PAM)',
  1,
  6
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-3-8'),
  NULL,
  'ESP-3-8.8',
  'Antivírus',
  1,
  7
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-3-8'),
  NULL,
  'ESP-3-8.9',
  'Antispam',
  1,
  8
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-3-10'),
  NULL,
  'ESP-3-10.1',
  'MITRE ATT&CK',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-3-10'),
  NULL,
  'ESP-3-10.2',
  'CIS Controls',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-3-10'),
  NULL,
  'ESP-3-10.3',
  'NIST CyberSecurity Framework (NIST CSF)',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-3-15'),
  NULL,
  'ESP-3-15.1',
  'DoS',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-3-15'),
  NULL,
  'ESP-3-15.2',
  'DDoS',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-3-15'),
  NULL,
  'ESP-3-15.3',
  'Botnets',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-3-15'),
  NULL,
  'ESP-3-15.4',
  'Phishing',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-3-15'),
  NULL,
  'ESP-3-15.5',
  'Zero-day exploits',
  1,
  4
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-3-15'),
  NULL,
  'ESP-3-15.6',
  'SQL injection',
  1,
  5
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-3-15'),
  NULL,
  'ESP-3-15.7',
  'Cross-Site Scripting (XSS)',
  1,
  6
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-3-15'),
  NULL,
  'ESP-3-15.8',
  'DNS Poisoning',
  1,
  7
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-4-1'),
  NULL,
  'ESP-4-1.1',
  'Modelos de serviço: IaaS, PaaS, SaaS',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-4-1'),
  NULL,
  'ESP-4-1.2',
  'Modelos de implantação: nuvem pública, privada e híbrida',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-4-1'),
  NULL,
  'ESP-4-1.3',
  'Arquitetura orientada a serviços (SOA) e microsserviços',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-4-1'),
  NULL,
  'ESP-4-1.4',
  'Elasticidade, escalabilidade e alta disponibilidade',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-4-3'),
  NULL,
  'ESP-4-3.1',
  'AWS',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-4-3'),
  NULL,
  'ESP-4-3.2',
  'Microsoft Azure',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-4-3'),
  NULL,
  'ESP-4-3.3',
  'Google Cloud Platform',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-4-5'),
  NULL,
  'ESP-4-5.1',
  'Design de sistemas distribuídos resilientes',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-4-5'),
  NULL,
  'ESP-4-5.2',
  'Arquiteturas serverless e event-driven',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-4-5'),
  NULL,
  'ESP-4-5.3',
  'Balanceamento de carga e autoescalonamento',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-4-5'),
  NULL,
  'ESP-4-5.4',
  'Containers e orquestração (Docker, Kubernetes)',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-4-7'),
  NULL,
  'ESP-4-7.1',
  'VPNs, sub-redes, gateways e grupos de segurança',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-4-7'),
  NULL,
  'ESP-4-7.2',
  'Gestão de identidade e acesso (IAM, RBAC, MFA)',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-4-7'),
  NULL,
  'ESP-4-7.3',
  'Criptografia em trânsito e em repouso (TLS, KMS)',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-4-7'),
  NULL,
  'ESP-4-7.4',
  'Zero Trust Architecture em ambientes de nuvem',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-4-9'),
  NULL,
  'ESP-4-9.1',
  'Ferramentas: Terraform',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-4-9'),
  NULL,
  'ESP-4-9.2',
  'Pipelines de integração e entrega contínua',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-4-9'),
  NULL,
  'ESP-4-9.3',
  'Observabilidade: monitoramento, logging e tracing',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-4-11'),
  NULL,
  'ESP-4-11.1',
  'Gerenciamento de custos e otimização de recursos',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-4-11'),
  NULL,
  'ESP-4-11.2',
  'Políticas de uso e governança em nuvem',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-4-11'),
  NULL,
  'ESP-4-11.3',
  'Conformidade com normas e padrões',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-4-11'),
  NULL,
  'ESP-4-11.4',
  'FinOps',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-4-13'),
  NULL,
  'ESP-4-13.1',
  'Tipos de armazenamento',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-4-13'),
  NULL,
  'ESP-4-13.2',
  'Data Lakes e processamento distribuído',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-4-13'),
  NULL,
  'ESP-4-13.3',
  'Integração com Big Data e IA',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-4-15'),
  NULL,
  'ESP-4-15.1',
  'Estratégias de migração',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-4-15'),
  NULL,
  'ESP-4-15.2',
  'Ferramentas de migração',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-4-17'),
  NULL,
  'ESP-4-17.1',
  'Arquiteturas multicloud e híbridas',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-4-17'),
  NULL,
  'ESP-4-17.2',
  'Nuvem soberana e soberania de dados',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-5-1'),
  NULL,
  'ESP-5-1.1',
  'Supervisionado',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-5-1'),
  NULL,
  'ESP-5-1.2',
  'Não supervisionado',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-5-1'),
  NULL,
  'ESP-5-1.3',
  'Semi-supervisionado',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-5-1'),
  NULL,
  'ESP-5-1.4',
  'Aprendizado por reforço',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-5-1'),
  NULL,
  'ESP-5-1.5',
  'Análise preditiva',
  1,
  4
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-5-3'),
  NULL,
  'ESP-5-3.1',
  'Arquiteturas de redes neurais',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-5-3'),
  NULL,
  'ESP-5-3.2',
  'Frameworks',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-5-3'),
  NULL,
  'ESP-5-3.3',
  'Técnicas de treinamento',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-5-3'),
  NULL,
  'ESP-5-3.4',
  'Aplicações',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-5-5'),
  NULL,
  'ESP-5-5.1',
  'Modelos',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-5-5'),
  NULL,
  'ESP-5-5.2',
  'Pré-processamento',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-5-5'),
  NULL,
  'ESP-5-5.3',
  'Agentes inteligentes',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-5-5'),
  NULL,
  'ESP-5-5.4',
  'Sistemas multiagentes',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-5-8'),
  NULL,
  'ESP-5-8.1',
  'MLOps',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-5-8'),
  NULL,
  'ESP-5-8.2',
  'Deploy de modelos',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-5-8'),
  NULL,
  'ESP-5-8.3',
  'Integração com computação em nuvem',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-5-10'),
  NULL,
  'ESP-5-10.1',
  'Explicabilidade e interpretabilidade de modelos',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-5-10'),
  NULL,
  'ESP-5-10.2',
  'Viés algorítmico e discriminação',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-5-10'),
  NULL,
  'ESP-5-10.3',
  'LGPD e impactos regulatórios da IA',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-5-10'),
  NULL,
  'ESP-5-10.4',
  'Princípios éticos para uso de IA',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-6-1'),
  NULL,
  'ESP-6-1.1',
  'Estudo Técnico Preliminar (ETP)',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-6-1'),
  NULL,
  'ESP-6-1.2',
  'Termo de Referência (TR) e Projeto Básico',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-6-1'),
  NULL,
  'ESP-6-1.3',
  'Análise de riscos',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-6-1'),
  NULL,
  'ESP-6-1.4',
  'Pesquisa de preços e matriz RACI',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-6-3'),
  NULL,
  'ESP-6-3.1',
  'Contratação de software sob demanda',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-6-3'),
  NULL,
  'ESP-6-3.2',
  'Licenciamento',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-6-3'),
  NULL,
  'ESP-6-3.3',
  'SaaS, IaaS e PaaS',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-6-3'),
  NULL,
  'ESP-6-3.4',
  'Fábrica de software e sustentação de sistemas',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-6-5'),
  NULL,
  'ESP-6-5.1',
  'Papéis e responsabilidades',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-6-5'),
  NULL,
  'ESP-6-5.2',
  'Indicadores de nível de serviço (SLAs)',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-6-5'),
  NULL,
  'ESP-6-5.3',
  'Gestão de mudanças contratuais',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-6-7'),
  NULL,
  'ESP-6-7.1',
  'Identificação, análise e resposta a riscos',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-6-7'),
  NULL,
  'ESP-6-7.2',
  'Controles internos',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-6-7'),
  NULL,
  'ESP-6-7.3',
  'Auditoria e responsabilização',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-6-9'),
  NULL,
  'ESP-6-9.1',
  'Integração com o PDTIC',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-6-9'),
  NULL,
  'ESP-6-9.2',
  'Mapeamento de requisitos',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-6-9'),
  NULL,
  'ESP-6-9.3',
  'Sustentabilidade, acessibilidade e segurança',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-6-11'),
  NULL,
  'ESP-6-11.1',
  'Lei nº 14.133/2021',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-6-11'),
  NULL,
  'ESP-6-11.2',
  'Decreto nº 10.540/2020',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-6-11'),
  NULL,
  'ESP-6-11.3',
  'Lei nº 13.709/2018 – LGPD',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-6-11'),
  NULL,
  'ESP-6-11.4',
  'Instruções Normativas',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-7-1'),
  NULL,
  'ESP-7-1.1',
  'Conceitos básicos',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-7-1'),
  NULL,
  'ESP-7-1.2',
  'Estrutura',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-7-1'),
  NULL,
  'ESP-7-1.3',
  'Objetivos',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-7-3'),
  NULL,
  'ESP-7-3.1',
  'Conceitos básicos',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-7-3'),
  NULL,
  'ESP-7-3.2',
  'Estrutura',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-7-3'),
  NULL,
  'ESP-7-3.3',
  'Objetivos',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-7-5'),
  NULL,
  'ESP-7-5.1',
  'Scrum',
  1,
  0
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-7-5'),
  NULL,
  'ESP-7-5.2',
  'XP (Extreme Programming)',
  1,
  1
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-7-5'),
  NULL,
  'ESP-7-5.3',
  'Kanban',
  1,
  2
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-7-5'),
  NULL,
  'ESP-7-5.4',
  'TDD (Test Driven Development)',
  1,
  3
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-7-5'),
  NULL,
  'ESP-7-5.5',
  'BDD (Behavior Driven Development)',
  1,
  4
);
INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = 'ESP-7-5'),
  NULL,
  'ESP-7-5.6',
  'DDD (Domain Driven Design)',
  1,
  5
);

-- ============================================
-- STATISTICS
-- ============================================

-- Subjects: 16
-- Topics: 112
-- Subtopics: 327
-- Total: 455
