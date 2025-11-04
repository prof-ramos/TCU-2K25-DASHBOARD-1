require('dotenv').config();
const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');
const path = require('path');

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

// Parse do arquivo de texto do edital
function parseEditalFile(filePath) {
  const content = fs.readFileSync(filePath, 'utf-8');
  const lines = content.split('\n');
  
  const materias = [];
  let currentType = null;
  let currentMateria = null;
  let currentTopic = null;
  let indentLevel = 0;
  
  for (let line of lines) {
    line = line.trim();
    
    // Ignorar linhas vazias e separadores (mas não ## e ###)
    if (!line || line === '---' || line.startsWith('---')) {
      continue;
    }
    
    // Ignorar título principal (# Edital...)
    if (line.startsWith('# ') && !line.startsWith('##')) {
      continue;
    }
    
    // Detectar tipo de conhecimento (##)
    if (line.startsWith('##') && !line.startsWith('###')) {
      const possibleType = line.replace(/##\s*/g, '').trim();
      if (possibleType === 'CONHECIMENTOS GERAIS' || possibleType === 'CONHECIMENTOS ESPECÍFICOS') {
        currentType = possibleType;
      }
      continue;
    }
    
    // Detectar matéria (linha com ### antes)
    if (line.startsWith('###')) {
      const materiaName = line.replace(/###\s*/g, '').trim();
      if (currentType) {
        currentMateria = {
          name: materiaName,
          type: currentType,
          topics: []
        };
        materias.push(currentMateria);
      }
      continue;
    }
    
    // Detectar tópicos e subtópicos
    // Formato: "1. Texto" ou "1.1 Texto" ou "1.1.1 Texto"
    const topicMatch = line.match(/^(\d+(?:\.\d+)*)\.\s+(.+)$/);
    if (topicMatch && currentMateria) {
      const [, numbering, title] = topicMatch;
      const levels = numbering.split('.');
      
      if (levels.length === 1) {
        // Tópico principal
        currentTopic = {
          title: title.trim(),
          numbering,
          subtopics: []
        };
        currentMateria.topics.push(currentTopic);
      } else if (levels.length === 2 && currentTopic) {
        // Subtópico de primeiro nível
        currentTopic.subtopics.push({
          title: title.trim(),
          numbering,
          subtopics: []
        });
      } else if (levels.length === 3 && currentTopic) {
        // Subtópico de segundo nível
        const parentSubtopic = currentTopic.subtopics.find(s => s.numbering === levels.slice(0, 2).join('.'));
        if (parentSubtopic) {
          if (!parentSubtopic.subtopics) parentSubtopic.subtopics = [];
          parentSubtopic.subtopics.push({
            title: title.trim(),
            numbering
          });
        }
      }
    }
  }
  
  return materias;
}

// Função principal de migração
async function migrateEdital(filePath) {
  console.log('🚀 Iniciando migração do edital para Supabase...\n');
  console.log(`📄 Arquivo: ${filePath}\n`);

  try {
    // Parse do arquivo
    console.log('📖 Parseando arquivo do edital...');
    const materias = parseEditalFile(filePath);
    console.log(`✅ ${materias.length} matérias encontradas\n`);

    // Limpar tabelas existentes (em ordem devido às constraints)
    console.log('🗑️  Limpando tabelas existentes...');
    await supabase.from('subtopics').delete().neq('id', '');
    await supabase.from('topics').delete().neq('id', '');
    await supabase.from('materias').delete().neq('id', '');
    console.log('✅ Tabelas limpas\n');

    let materiaOrdem = 0;
    let totalTopics = 0;
    let totalSubtopics = 0;

    // Processar cada matéria
    for (const materia of materias) {
      materiaOrdem++;
      const materiaSlug = createSlug(materia.name);
      const materiaId = materiaSlug;

      console.log(`📚 ${materiaOrdem}. ${materia.name} (${materia.type})`);

      // Inserir matéria
      const { error: materiaError } = await supabase
        .from('materias')
        .insert({
          id: materiaId,
          slug: materiaSlug,
          name: materia.name,
          type: materia.type,
          ordem: materiaOrdem
        });

      if (materiaError) {
        console.error(`   ❌ Erro: ${materiaError.message}`);
        continue;
      }

      // Processar tópicos
      let topicOrdem = 0;
      for (const topic of materia.topics) {
        topicOrdem++;
        totalTopics++;
        const topicId = `${materiaId}.${topic.numbering}`;

        // Inserir tópico
        const { error: topicError } = await supabase
          .from('topics')
          .insert({
            id: topicId,
            materia_id: materiaId,
            title: topic.title,
            ordem: topicOrdem
          });

        if (topicError) {
          console.error(`     ❌ Tópico ${topic.numbering}: ${topicError.message}`);
          continue;
        }

        console.log(`   ✓ ${topic.numbering}. ${topic.title.substring(0, 60)}${topic.title.length > 60 ? '...' : ''}`);

        // Processar subtópicos de primeiro nível
        if (topic.subtopics && topic.subtopics.length > 0) {
          let subtopicOrdem = 0;
          for (const subtopic of topic.subtopics) {
            subtopicOrdem++;
            totalSubtopics++;
            const subtopicId = `${materiaId}.${subtopic.numbering}`;

            const { error: subtopicError } = await supabase
              .from('subtopics')
              .insert({
                id: subtopicId,
                topic_id: topicId,
                parent_id: null,
                title: subtopic.title,
                ordem: subtopicOrdem
              });

            if (subtopicError) {
              console.error(`       ❌ Subtópico ${subtopic.numbering}: ${subtopicError.message}`);
              continue;
            }

            console.log(`       ${subtopic.numbering} ${subtopic.title.substring(0, 55)}${subtopic.title.length > 55 ? '...' : ''}`);

            // Processar subtópicos de segundo nível
            if (subtopic.subtopics && subtopic.subtopics.length > 0) {
              let subsubtopicOrdem = 0;
              for (const subsubtopic of subtopic.subtopics) {
                subsubtopicOrdem++;
                totalSubtopics++;
                const subsubtopicId = `${materiaId}.${subsubtopic.numbering}`;

                const { error: subsubtopicError } = await supabase
                  .from('subtopics')
                  .insert({
                    id: subsubtopicId,
                    topic_id: null,
                    parent_id: subtopicId,
                    title: subsubtopic.title,
                    ordem: subsubtopicOrdem
                  });

                if (subsubtopicError) {
                  console.error(`         ❌ Subtópico ${subsubtopic.numbering}: ${subsubtopicError.message}`);
                } else {
                  console.log(`         ${subsubtopic.numbering} ${subsubtopic.title.substring(0, 50)}${subsubtopic.title.length > 50 ? '...' : ''}`);
                }
              }
            }
          }
        }
      }
      console.log();
    }

    console.log('\n✅ Migração concluída com sucesso!');
    console.log('\n📊 Estatísticas:');
    console.log(`  - Matérias: ${materiaOrdem}`);
    console.log(`  - Tópicos: ${totalTopics}`);
    console.log(`  - Subtópicos: ${totalSubtopics}`);
    console.log(`  - Total de itens: ${materiaOrdem + totalTopics + totalSubtopics}`);

  } catch (error) {
    console.error('\n❌ Erro durante a migração:', error);
    process.exit(1);
  }
}

// Executar migração
if (require.main === module) {
  const editalFile = process.argv[2] || path.join(__dirname, '../attached_assets/Pasted--Edital-Verticalizado-TCU-TI-TRIBUNAL-DE-CONTAS-DA-UNI-O-CONHECIMENTOS-GERAIS-L-NGUA-P-1761729457160_1761729457161.txt');
  
  if (!fs.existsSync(editalFile)) {
    console.error(`❌ Arquivo não encontrado: ${editalFile}`);
    console.error('Uso: node parse-and-migrate-edital.js [caminho-do-arquivo]');
    process.exit(1);
  }

  migrateEdital(editalFile)
    .then(() => process.exit(0))
    .catch((error) => {
      console.error('❌ Erro fatal:', error);
      process.exit(1);
    });
}

module.exports = { migrateEdital, parseEditalFile };
