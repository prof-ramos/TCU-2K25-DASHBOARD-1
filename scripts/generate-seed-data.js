/**
 * Generate SQL seed data from edital.ts
 * Creates SQL INSERT statements for subjects, topics, and subtopics
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const rawData = {
  "CONHECIMENTOS GERAIS": {
    "LÍNGUA PORTUGUESA": ["Compreensão e interpretação de textos de gêneros variados","Reconhecimento de tipos e gêneros textuais","Domínio da ortografia oficial","Domínio dos mecanismos de coesão textual",{"subtopics":["Emprego de elementos de referenciação, substituição e repetição, de conectores e de outros elementos de sequenciação textual","Emprego de tempos e modos verbais"]},"Domínio da estrutura morfossintática do período",{"subtopics":["Emprego das classes de palavras","Relações de coordenação entre orações e entre termos da oração","Relações de subordinação entre orações e entre termos da oração","Emprego dos sinais de pontuação","Concordância verbal e nominal","Regência verbal e nominal","Emprego do sinal indicativo de crase","Colocação dos pronomes átonos"]},"Reescrita de frases e parágrafos do texto",{"subtopics":["Significação das palavras","Substituição de palavras ou de trechos de texto","Reorganização da estrutura de orações e de períodos do texto","Reescrita de textos de diferentes gêneros e níveis de formalidade"]}],
    "LÍNGUA INGLESA": ["Compreensão de textos variados: domínio do vocabulário e da estrutura da língua, ideias principais e secundárias, explícitas e implícitas, relações intratextuais e intertextuais", "Itens gramaticais relevantes para compreensão de conteúdos semânticos", "Conhecimento e uso das formas contemporâneas da linguagem inglesa"],
    "RACIOCÍNIO ANÁLITICO": ["Raciocínio analítico e a argumentação", {"subtopics":["O uso do senso crítico na argumentação","Tipos de argumentos: argumentos falaciosos e apelativos","Comunicação eficiente de argumentos"]}],
    "CONTROLE EXTERNO": ["Conceito, tipos e formas de controle","Controle interno e externo","Controle parlamentar","Controle pelos tribunais de contas","Controle administrativo","Lei nº 8.429/1992 (Lei de Improbidade Administrativa)","Sistemas de controle jurisdicional da administração pública",{"subtopics":["Contencioso administrativo e sistema da jurisdição una"]},"Controle jurisdicional da administração pública no direito brasileiro","Controle da atividade financeira do Estado: espécies e sistemas","Tribunal de Contas da União (TCU), Tribunais de Contas dos Estados e do Distrito Federal"],
    "ADMINISTRAÇÃO PÚBLICA": ["Administração",{"subtopics":["Abordagens clássica, burocrática e sistêmica da administração","Evolução da administração pública no Brasil após 1930; reformas administrativas; a nova gestão pública"]},"Processo administrativo",{"subtopics":["Funções da administração: planejamento, organização, direção e controle","Estrutura organizacional","Cultura organizacional"]},"Gestão de pessoas",{"subtopics":["Equilíbrio organizacional","Objetivos, desafios e características da gestão de pessoas","Comportamento organizacional: relações indivíduo/organização, motivação, liderança, desempenho"]},"Noções de gestão de processos: técnicas de mapeamento, análise e melhoria de processos","Gestão de projetos",{"subtopics":["Elaboração, análise e avaliação de projetos","Principais características dos modelos de gestão de projetos","Projetos e suas etapas","Metodologia ágil"]},"Administração de recursos materiais","ESG"],
    "DIREITO CONSTITUCIONAL": ["Constituição",{"subtopics":["Conceito, objeto, elementos e classificações","Supremacia da Constituição","Aplicabilidade das normas constitucionais","Interpretação das normas constitucionais","Mutação constitucional"]},"Poder constituinte",{"subtopics":["Características","Poder constituinte originário","Poder constituinte derivado"]},"Princípios fundamentais","Direitos e garantias fundamentais",{"subtopics":["Direitos e deveres individuais e coletivos","Habeas corpus, mandado de segurança, mandado de injunção e habeas data","Direitos sociais","Direitos políticos","Partidos políticos","O ente estatal titular de direitos fundamentais"]},"Organização do Estado",{"subtopics":["Organização político-administrativa","Estado federal brasileiro","A União","Estados federados","Municípios","O Distrito Federal","Territórios","Intervenção federal","Intervenção dos estados nos municípios"]},"Administração pública",{"subtopics":["Disposições gerais","Servidores públicos"]},"Organização dos poderes no Estado",{"subtopics":["Mecanismos de freios e contrapesos","Poder Legislativo","Poder Executivo","Poder Judiciário"]},"Funções essenciais à justiça",{"subtopics":["Ministério Público","Advocacia Pública","Advocacia e Defensoria Pública"]},"Controle de constitucionalidade",{"subtopics":["Sistemas gerais e sistema brasileiro","Controle incidental ou concreto","Controle abstrato de constitucionalidade","Exame *in abstractu* da constitucionalidade de proposições legislativas","Ação declaratória de constitucionalidade","Ação direta de inconstitucionalidade","Arguição de descumprimento de preceito fundamental","Ação direta de inconstitucionalidade por omissão","Ação direta de inconstitucionalidade interventiva"]},"Defesa do Estado e das instituições democráticas",{"subtopics":["Estado de defesa e estado de sítio","Forças armadas","Segurança pública"]},"Sistema Tributário Nacional",{"subtopics":["Princípios gerais","Limitações do poder de tributar","Impostos da União","Impostos dos estados e do Distrito Federal","Impostos dos municípios"]}],
    "DIREITO ADMINISTRATIVO": ["Estado, governo e administração pública",{"subtopics":["Conceitos","Elementos"]},"Direito administrativo",{"subtopics":["Conceito","Objeto","Fontes"]},"Ato administrativo",{"subtopics":["Conceito, requisitos, atributos, classificação e espécies","Extinção do ato administrativo: cassação, anulação, revogação e convalidação","Decadência administrativa"]},"Agentes públicos",{"subtopics":["Legislação pertinente",{"subtopics":["Lei nº 8.112/1990","Disposições constitucionais aplicáveis"]},"Disposições doutrinárias",{"subtopics":["Conceito","Espécies","Cargo, emprego e função pública","Provimento","Vacância","Efetividade, estabilidade e vitaliciedade","Remuneração","Direitos e deveres","Responsabilidade","Processo administrativo disciplinar"]}]},"Poderes da administração pública",{"subtopics":["Hierárquico, disciplinar, regulamentar e de polícia","Uso e abuso do poder"]},"Regime jurídico-administrativo",{"subtopics":["Conceito","Princípios expressos e implícitos da administração pública"]},"Responsabilidade civil do Estado",{"subtopics":["Evolução histórica","Responsabilidade civil do Estado no direito brasileiro",{"subtopics":["Responsabilidade por ato comissivo do Estado","Responsabilidade por omissão do Estado"]},"Requisitos para a demonstração da responsabilidade do Estado","Causas excludentes e atenuantes da responsabilidade do Estado","Reparação do dano","Direito de regresso"]},"Serviços públicos",{"subtopics":["Conceito","Elementos constitutivos","Formas de prestação e meios de execução","Delegação: concessão, permissão e autorização","Classificação","Princípios"]},"Organização administrativa",{"subtopics":["Centralização, descentralização, concentração e desconcentração","Administração direta e indireta","Autarquias, fundações, empresas públicas e sociedades de economia mista","Entidades paraestatais e terceiro setor"]}],
    "AUDITORIA GOVERNAMENTAL": ["Conceito, finalidade, objetivo, abrangência e atuação",{"subtopics":["Auditoria interna e externa: papéis"]},"Instrumentos de fiscalização: auditoria, levantamento, monitoramento, acompanhamento e inspeção","Tipos de auditoria",{"subtopics":["Auditoria de conformidade","Auditoria operacional","Auditoria financeira"]},"Normas de auditoria",{"subtopics":["Normas de Auditoria do TCU","Normas da INTOSAI (Organização Internacional das Instituições Superiores de Controle): código de ética e princípios fundamentais de auditoria do setor público (ISSAIs 100, 200, 300 e 400)","Normas Brasileiras de Auditoria do Setor Público (NBASP)"]},"Planejamento de auditoria",{"subtopics":["Determinação de escopo","Materialidade, risco e relevância","Importância da amostragem estatística em auditoria","Matriz de planejamento"]},"Execução da auditoria",{"subtopics":["Programas de auditoria","Papéis de trabalho","Testes de auditoria","Técnicas e procedimentos"]},"Evidências",{"subtopics":["Caracterização de achados de auditoria","Matriz de Achados e Matriz de Responsabilização"]},"Comunicação dos resultados: relatórios de auditoria"]
  },
  "CONHECIMENTOS ESPECÍFICOS": {
    "INFRAESTRUTURA DE TI": ["Arquitetura e Infraestrutura de TI",{"subtopics":["Topologias físicas e lógicas de redes corporativas","Arquiteturas de data center (on-premises, cloud, híbrida)","Infraestrutura hiperconvergente","Arquitetura escalável, tolerante a falhas e redundante"]},"Redes e Comunicação de Dados",{"subtopics":["Protocolos de comunicação de dados","VLANs, STP, QoS, roteamento e switching em ambientes corporativos","SDN (Software Defined Networking) e redes programáveis","Wireless corporativo: Wi-Fi 6, WPA3, roaming, mesh"]},"Sistemas Operacionais e Servidores",{"subtopics":["Administração avançada de Linux e Windows Server","Virtualização (KVM, VMware vSphere/ESXi)","Serviços de diretório (Active Directory, LDAP)","Gerenciamento de usuários, permissões e GPOS"]},"Armazenamento e Backup",{"subtopics":["SAN, NAS, DAS: arquiteturas e protocolos (iSCSI, NFS, SMB)","RAID (níveis, vantagens, hot-spare)","Backup e recuperação: RPO, RTO, snapshots, deduplicação","Oracle RMAN"]},"Segurança de Infraestrutura",{"subtopics":["Hardening de servidores e dispositivos de rede","Firewalls (NGFW), IDS/IPS, proxies, NAC","VPNs, SSL/TLS, PKI, criptografia de dados","Segmentação de rede e zonas de segurança"]},"Monitoramento, Gestão e Automação",{"subtopics":["Ferramentas: Zabbix, New Relic e Grafana","Gerência de capacidade, disponibilidade e desempenho","ITIL v4: incidentes, problemas, mudanças e configurações (CMDB)","Scripts e automação com PowerShell, Bash e Puppet"]},"Alta Disponibilidade e Recuperação de Desastres",{"subtopics":["Clusters de alta disponibilidade e balanceamento de carga","Failover, heartbeat, fencing","Planos de continuidade de negócios e testes de DR"]}],
    "ENGENHARIA DE DADOS": ["Bancos de Dados",{"subtopics":["Relacionais: Oracle e Microsoft SQL Server","Não relacionais (NoSQL): Elasticsearch e MongoDB","Modelagens de dados: relacional, multidimensional e NoSQL","SQL (Procedural Language / Structured Query Language)"]},"Arquitetura de Inteligência de Negócio",{"subtopics":["Data Warehouse","Data Mart","Data Lake","Data Mesh"]},"Conectores e Integração com Fontes de Dados",{"subtopics":["APIs REST/SOAP e Web Services","Arquivos planos (CSV, JSON, XML, Parquet)","Mensageria e eventos","Controle de integridade de dados","Segurança na captação de dados","Estratégias de buffer e ordenação"]},"Fluxo de Manipulação de Dados",{"subtopics":["ETL","Pipeline de dados","Integração com CI/CD"]},"Governança e Qualidade de Dados",{"subtopics":["Linhagem e catalogação","Qualidade de dados","Metadados, glossários de dados e políticas de acesso"]},"Integração com Nuvem",{"subtopics":["Serviços gerenciados (Azure Data Factory, Azure Service Fabric, Azure Databricks)","Armazenamento (S3, Azure Blob, GCS)","Integração com serviços de IA e análise"]}],
    "ENGENHARIA DE SOFTWARE": ["Arquitetura de Software",{"subtopics":["Padrões arquiteturais","Monolito","Microserviços","Serverless","Arquitetura orientada a eventos e mensageria","Padrões de integração (API Gateway, Service Mesh, CQRS)"]},"Design e Programação",{"subtopics":["Padrões de projeto (GoF e GRASP)","Concorrência, paralelismo, multithreading e programação assíncrona"]},"APIs e Integrações",{"subtopics":["Design e versionamento de APIs RESTful","Boas práticas de autenticação e autorização (OAuth2, JWT, OpenID Connect)"]},"Persistência de Dados",{"subtopics":["Modelagem relacional e normalização","Bancos NoSQL (MongoDB e Elasticsearch)","Versionamento e migração de esquemas"]},"DevOps e Integração Contínua",{"subtopics":["Pipelines de CI/CD (GitHub Actions)","Build, testes e deploy automatizados","Docker e orquestração com Kubernetes","Monitoramento e observabilidade: Grafana e New Relic"]},"Testes e Qualidade de Código",{"subtopics":["Testes automatizados: unitários, de integração e de contrato (API)","Análise estática de código e cobertura (SonarQube)"]},"Linguagens de Programação",{"subtopics":["Java"]},"Desenvolvimento Seguro",{"subtopics":["DevSecOps"]}],
    "SEGURANÇA DA INFORMAÇÃO": ["Gestão de Identidades e Acesso",{"subtopics":["Autenticação e autorização","Single Sign-On (SSO)","Security Assertion Markup Language (SAML)","OAuth2 e OpenID Connect"]},"Privacidade e segurança por padrão","Malware",{"subtopics":["Vírus","Keylogger","Trojan","Spyware","Backdoor","Worms","Rootkit","Adware","Fileless","Ransomware"]},"Controles e testes de segurança para aplicações Web e Web Services","Múltiplos Fatores de Autenticação (MFA)","Soluções para Segurança da Informação",{"subtopics":["Firewall","Intrusion Detection System (IDS)","Intrusion Prevention System (IPS)","Security Information and Event Management (SIEM)","Proxy","Identity Access Management (IAM)","Privileged Access Management (PAM)","Antivírus","Antispam"]},"Frameworks de segurança",{"subtopics":["MITRE ATT&CK","CIS Controls","NIST CyberSecurity Framework (NIST CSF)"]},"Tratamento de incidentes cibernéticos","Assinatura e certificação digital, criptografia e proteção de dados em trânsito e em repouso","Segurança em nuvens e de contêineres","Ataques a redes",{"subtopics":["DoS","DDoS","Botnets","Phishing","Zero-day exploits","SQL injection","Cross-Site Scripting (XSS)","DNS Poisoning"]}],
    "COMPUTAÇÃO EM NUVEM": ["Fundamentos de Computação em Nuvem",{"subtopics":["Modelos de serviço: IaaS, PaaS, SaaS","Modelos de implantação: nuvem pública, privada e híbrida","Arquitetura orientada a serviços (SOA) e microsserviços","Elasticidade, escalabilidade e alta disponibilidade"]},"Plataformas e Serviços de Nuvem",{"subtopics":["AWS","Microsoft Azure","Google Cloud Platform"]},"Arquitetura de Soluções em Nuvem",{"subtopics":["Design de sistemas distribuídos resilientes","Arquiteturas serverless e event-driven","Balanceamento de carga e autoescalonamento","Containers e orquestração (Docker, Kubernetes)"]},"Redes e Segurança em Nuvem",{"subtopics":["VPNs, sub-redes, gateways e grupos de segurança","Gestão de identidade e acesso (IAM, RBAC, MFA)","Criptografia em trânsito e em repouso (TLS, KMS)","Zero Trust Architecture em ambientes de nuvem"]},"DevOps, CI/CD e Infraestrutura como Código (IaC)",{"subtopics":["Ferramentas: Terraform","Pipelines de integração e entrega contínua","Observabilidade: monitoramento, logging e tracing"]},"Governança, Compliance e Custos",{"subtopics":["Gerenciamento de custos e otimização de recursos","Políticas de uso e governança em nuvem","Conformidade com normas e padrões","FinOps"]},"Armazenamento e Processamento de Dados",{"subtopics":["Tipos de armazenamento","Data Lakes e processamento distribuído","Integração com Big Data e IA"]},"Migração e Modernização de Aplicações",{"subtopics":["Estratégias de migração","Ferramentas de migração"]},"Multicloud",{"subtopics":["Arquiteturas multicloud e híbridas","Nuvem soberana e soberania de dados"]},"Normas sobre computação em nuvem no governo federal"],
    "INTELIGÊNCIA ARTIFICIAL": ["Aprendizado de Máquina",{"subtopics":["Supervisionado","Não supervisionado","Semi-supervisionado","Aprendizado por reforço","Análise preditiva"]},"Redes Neurais e Deep Learning",{"subtopics":["Arquiteturas de redes neurais","Frameworks","Técnicas de treinamento","Aplicações"]},"Processamento de Linguagem Natural",{"subtopics":["Modelos","Pré-processamento","Agentes inteligentes","Sistemas multiagentes"]},"Inteligência Artificial Generativa","Arquitetura e Engenharia de Sistemas de IA",{"subtopics":["MLOps","Deploy de modelos","Integração com computação em nuvem"]},"Ética, Transparência e Responsabilidade em IA",{"subtopics":["Explicabilidade e interpretabilidade de modelos","Viés algorítmico e discriminação","LGPD e impactos regulatórios da IA","Princípios éticos para uso de IA"]}],
    "CONTRATAÇÕES DE TI": ["Etapas da Contratação de Soluções de TI",{"subtopics":["Estudo Técnico Preliminar (ETP)","Termo de Referência (TR) e Projeto Básico","Análise de riscos","Pesquisa de preços e matriz RACI"]},"Tipos de Soluções e Modelos de Serviço",{"subtopics":["Contratação de software sob demanda","Licenciamento","SaaS, IaaS e PaaS","Fábrica de software e sustentação de sistemas"]},"Governança, Fiscalização e Gestão de Contratos",{"subtopics":["Papéis e responsabilidades","Indicadores de nível de serviço (SLAs)","Gestão de mudanças contratuais"]},"Riscos e Controles em Contratações",{"subtopics":["Identificação, análise e resposta a riscos","Controles internos","Auditoria e responsabilização"]},"Aspectos Técnicos e Estratégicos",{"subtopics":["Integração com o PDTIC","Mapeamento de requisitos","Sustentabilidade, acessibilidade e segurança"]},"Legislação e Normativos Aplicáveis",{"subtopics":["Lei nº 14.133/2021","Decreto nº 10.540/2020","Lei nº 13.709/2018 – LGPD","Instruções Normativas"]}],
    "GESTÃO DE TECNOLOGIA DA INFORMAÇÃO": ["Gerenciamento de Serviços (ITIL v4)",{"subtopics":["Conceitos básicos","Estrutura","Objetivos"]},"Governança de TI (COBIT 5)",{"subtopics":["Conceitos básicos","Estrutura","Objetivos"]},"Metodologias Ágeis",{"subtopics":["Scrum","XP (Extreme Programming)","Kanban","TDD (Test Driven Development)","BDD (Behavior Driven Development)","DDD (Domain Driven Design)"]}]
  }
};

// Helper to escape SQL strings
function escapeSql(str) {
  if (typeof str !== 'string') return str;
  return str.replace(/'/g, "''");
}

// Generate UUIDs (using timestamp-based for reproducibility)
let uuidCounter = 1;
function genUuid() {
  return `gen_random_uuid()`;
}

function parseSubtopics(items, parentTopicRef, parentSubtopicRef = null, level = 1) {
  const inserts = [];
  let subtopicCounter = 1;
  let currentSubtopicRef = null;

  items.forEach((item) => {
    if (typeof item === 'string') {
      const externalId = parentSubtopicRef 
        ? `${parentSubtopicRef}.${subtopicCounter}`
        : `${parentTopicRef}.${subtopicCounter}`;
      currentSubtopicRef = externalId;
      
      inserts.push({
        topic_ref: parentTopicRef,
        parent_ref: parentSubtopicRef,
        external_id: externalId,
        title: escapeSql(item),
        level: level,
        order_index: subtopicCounter - 1
      });
      subtopicCounter++;
    } else if (item.subtopics && currentSubtopicRef) {
      const nested = parseSubtopics(item.subtopics, parentTopicRef, currentSubtopicRef, level + 1);
      inserts.push(...nested);
    }
  });
  
  return inserts;
}

function parseTopics(items, materiaRef) {
  const topicInserts = [];
  const subtopicInserts = [];
  let currentTopicRef = null;

  items.forEach((item, index) => {
    const topicRef = `${materiaRef}-${index + 1}`;
    
    if (typeof item === 'string') {
      currentTopicRef = topicRef;
      topicInserts.push({
        subject_ref: materiaRef,
        external_id: topicRef,
        title: escapeSql(item),
        order_index: index
      });
    } else if (item.subtopics && currentTopicRef) {
      const nested = parseSubtopics(item.subtopics, currentTopicRef);
      subtopicInserts.push(...nested);
    }
  });

  return { topicInserts, subtopicInserts };
}

// Main generation
let sql = `-- Seed data for TCU TI 2025 Edital
-- Generated: ${new Date().toISOString()}
-- Migration: 00010_seed_edital_data

-- ============================================
-- SUBJECTS (16 matérias)
-- ============================================

`;

const allTopicInserts = [];
const allSubtopicInserts = [];

Object.entries(rawData).forEach(([type, materias]) => {
  Object.entries(materias).forEach(([name, topicsRaw], index) => {
    // Use different prefixes for each type to avoid external_id collision
    const prefix = type === 'CONHECIMENTOS GERAIS' ? 'CON' : 'ESP';
    const materiaId = `${prefix}-${index}`;
    const slug = name.toLowerCase().replace(/\s+/g, '-').replace(/[^a-z0-9-]/g, '');
    
    sql += `INSERT INTO subjects (tenant_id, external_id, name, slug, type, order_index, is_custom)
VALUES (NULL, '${materiaId}', '${escapeSql(name)}', '${slug}', '${type}', ${Object.keys(rawData).indexOf(type) * 100 + index}, false);\n`;
    
    const { topicInserts, subtopicInserts } = parseTopics(topicsRaw, materiaId);
    allTopicInserts.push(...topicInserts.map(t => ({ ...t, subject_ref: materiaId })));
    allSubtopicInserts.push(...subtopicInserts);
  });
});

sql += `\n-- ============================================\n-- TOPICS (${allTopicInserts.length} tópicos principais)\n-- ============================================\n\n`;

allTopicInserts.forEach(topic => {
  sql += `INSERT INTO topics (subject_id, external_id, title, order_index)
VALUES ((SELECT id FROM subjects WHERE external_id = '${topic.subject_ref}'), '${topic.external_id}', '${topic.title}', ${topic.order_index});\n`;
});

sql += `\n-- ============================================\n-- SUBTOPICS (${allSubtopicInserts.length} subtópicos)\n-- ============================================\n\n`;

allSubtopicInserts.forEach(subtopic => {
  const parentClause = subtopic.parent_ref
    ? `(SELECT id FROM subtopics WHERE external_id = '${subtopic.parent_ref}')`
    : 'NULL';
    
  sql += `INSERT INTO subtopics (topic_id, parent_id, external_id, title, level, order_index)
VALUES (
  (SELECT id FROM topics WHERE external_id = '${subtopic.topic_ref}'),
  ${parentClause},
  '${subtopic.external_id}',
  '${subtopic.title}',
  ${subtopic.level},
  ${subtopic.order_index}
);\n`;
});

sql += `\n-- ============================================\n-- STATISTICS\n-- ============================================\n
-- Subjects: ${Object.values(rawData).reduce((sum, m) => sum + Object.keys(m).length, 0)}
-- Topics: ${allTopicInserts.length}
-- Subtopics: ${allSubtopicInserts.length}
-- Total: ${Object.values(rawData).reduce((sum, m) => sum + Object.keys(m).length, 0) + allTopicInserts.length + allSubtopicInserts.length}
`;

// Write to file
const outputPath = path.join(__dirname, '../supabase/seed/00010_seed_edital_data.sql');
fs.mkdirSync(path.dirname(outputPath), { recursive: true });
fs.writeFileSync(outputPath, sql);

console.log(`✅ Generated seed data SQL: ${outputPath}`);
console.log(`📊 Statistics:`);
console.log(`   - Subjects: ${Object.values(rawData).reduce((sum, m) => sum + Object.keys(m).length, 0)}`);
console.log(`   - Topics: ${allTopicInserts.length}`);
console.log(`   - Subtopics: ${allSubtopicInserts.length}`);
