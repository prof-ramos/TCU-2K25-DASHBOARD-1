require('dotenv').config();
const { createClient } = require('@supabase/supabase-js');

// Dados do edital (copiados do src/data/edital.ts)
const editalData = {
  "CONHECIMENTOS GERAIS": {
    "LÍNGUA PORTUGUESA": [
      "Compreensão e interpretação de textos de gêneros variados",
      "Reconhecimento de tipos e gêneros textuais",
      "Domínio da ortografia oficial",
      "Domínio dos mecanismos de coesão textual",
      {
        "subtopics": [
          "Emprego de elementos de referenciação, substituição e repetição, de conectores e de outros elementos de sequenciação textual",
          "Emprego de tempos e modos verbais"
        ]
      },
      "Domínio da estrutura morfossintática do período",
      {
        "subtopics": [
          "Emprego das classes de palavras",
          "Relações de coordenação entre orações e entre termos da oração",
          "Relações de subordinação entre orações e entre termos da oração",
          "Emprego dos sinais de pontuação",
          "Concordância verbal e nominal",
          "Regência verbal e nominal",
          "Emprego do sinal indicativo de crase",
          "Colocação dos pronomes átonos"
        ]
      },
      "Reescrita de frases e parágrafos do texto",
      {
        "subtopics": [
          "Significação das palavras",
          "Substituição de palavras ou de trechos de texto",
          "Reorganização da estrutura de orações e de períodos do texto",
          "Reescrita de textos de diferentes gêneros e níveis de formalidade"
        ]
      }
    ],
    "LÍNGUA INGLESA": [
      "Compreensão de textos variados: domínio do vocabulário e da estrutura da língua, ideias principais e secundárias, explícitas e implícitas, relações intratextuais e intertextuais",
      "Itens gramaticais relevantes para compreensão de conteúdos semânticos",
      "Conhecimento e uso das formas contemporâneas da linguagem inglesa"
    ],
    "RACIOCÍNIO ANÁLITICO": [
      "Raciocínio analítico e a argumentação",
      {
        "subtopics": [
          "O uso do senso crítico na argumentação",
          "Tipos de argumentos: argumentos falaciosos e apelativos",
          "Comunicação eficiente de argumentos"
        ]
      }
    ],
    "CONTROLE EXTERNO": [
      "Conceito, tipos e formas de controle",
      "Controle interno e externo",
      "Controle parlamentar",
      "Controle pelos tribunais de contas",
      "Controle administrativo",
      "Lei nº 8.429/1992 (Lei de Improbidade Administrativa)",
      "Sistemas de controle jurisdicional da administração pública",
      {
        "subtopics": ["Contencioso administrativo e sistema da jurisdição una"]
      },
      "Controle jurisdicional da administração pública no direito brasileiro",
      "Controle da atividade financeira do Estado: espécies e sistemas",
      "Tribunal de Contas da União (TCU), Tribunais de Contas dos Estados e do Distrito Federal"
    ]
    // ... outros conteúdos serão adicionados depois
  },
  "CONHECIMENTOS ESPECÍFICOS": {
    // ... será adicionado depois
  }
};

// Inicializar cliente Supabase
const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE
);

// Função para criar slug
function createSlug(text) {
  return text
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '');
}

// Função principal de migração
async function migrateEdital() {
  console.log('🚀 Iniciando migração do edital para Supabase...\n');

  try {
    // Limpar tabelas existentes (em ordem devido às constraints)
    console.log('🗑️  Limpando tabelas existentes...');
    await supabase.from('subtopics').delete().neq('id', '');
    await supabase.from('topics').delete().neq('id', '');
    await supabase.from('materias').delete().neq('id', '');
    console.log('✅ Tabelas limpas\n');

    let materiaOrdem = 0;

    // Iterar sobre os tipos de conhecimento (GERAIS e ESPECÍFICOS)
    for (const [tipoConhecimento, materias] of Object.entries(editalData)) {
      console.log(`📚 Processando: ${tipoConhecimento}`);

      // Iterar sobre cada matéria
      for (const [nomeMateria, topicos] of Object.entries(materias)) {
        materiaOrdem++;
        const materiaSlug = createSlug(nomeMateria);
        const materiaId = materiaSlug;

        console.log(`  📖 Matéria: ${nomeMateria} (${materiaId})`);

        // Inserir matéria
        const { error: materiaError } = await supabase
          .from('materias')
          .insert({
            id: materiaId,
            slug: materiaSlug,
            name: nomeMateria,
            type: tipoConhecimento,
            ordem: materiaOrdem
          });

        if (materiaError) {
          console.error(`    ❌ Erro ao inserir matéria: ${materiaError.message}`);
          continue;
        }

        // Processar tópicos
        let topicOrdem = 0;
        let topicIndex = 1;

        for (const item of topicos) {
          if (typeof item === 'string') {
            // É um tópico simples
            topicOrdem++;
            const topicId = `${materiaId}.${topicIndex}`;

            const { error: topicError } = await supabase
              .from('topics')
              .insert({
                id: topicId,
                materia_id: materiaId,
                title: item,
                ordem: topicOrdem
              });

            if (topicError) {
              console.error(`      ❌ Erro ao inserir tópico: ${topicError.message}`);
            } else {
              console.log(`      ✓ Tópico: ${topicId} - ${item.substring(0, 60)}...`);
            }

            topicIndex++;
          } else if (item.subtopics) {
            // O tópico anterior tem subtópicos
            const lastTopicId = `${materiaId}.${topicIndex - 1}`;
            let subtopicOrdem = 0;
            let subtopicIndex = 1;

            for (const subtopicTitle of item.subtopics) {
              subtopicOrdem++;
              const subtopicId = `${lastTopicId}.${subtopicIndex}`;

              const { error: subtopicError } = await supabase
                .from('subtopics')
                .insert({
                  id: subtopicId,
                  topic_id: lastTopicId,
                  parent_id: null,
                  title: subtopicTitle,
                  ordem: subtopicOrdem
                });

              if (subtopicError) {
                console.error(`        ❌ Erro ao inserir subtópico: ${subtopicError.message}`);
              } else {
                console.log(`        ✓ Subtópico: ${subtopicId} - ${subtopicTitle.substring(0, 50)}...`);
              }

              subtopicIndex++;
            }
          }
        }
      }
      console.log();
    }

    console.log('\n✅ Migração concluída com sucesso!');
    console.log('\n📊 Estatísticas:');

    // Contar registros inseridos
    const { count: countMaterias } = await supabase
      .from('materias')
      .select('*', { count: 'exact', head: true });
    
    const { count: countTopics } = await supabase
      .from('topics')
      .select('*', { count: 'exact', head: true });
    
    const { count: countSubtopics } = await supabase
      .from('subtopics')
      .select('*', { count: 'exact', head: true });

    console.log(`  - Matérias: ${countMaterias}`);
    console.log(`  - Tópicos: ${countTopics}`);
    console.log(`  - Subtópicos: ${countSubtopics}`);

  } catch (error) {
    console.error('\n❌ Erro durante a migração:', error);
    process.exit(1);
  }
}

// Executar migração
if (require.main === module) {
  migrateEdital()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error('❌ Erro fatal:', error);
      process.exit(1);
    });
}

module.exports = { migrateEdital };
