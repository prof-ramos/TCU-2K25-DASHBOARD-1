#!/usr/bin/env node

/**
 * Script de Migração: SQLite → Supabase
 *
 * Este script migra dados existentes do SQLite local para o Supabase PostgreSQL.
 *
 * Uso:
 *   npm run migrate
 *
 * Ou diretamente:
 *   node server/migrate-to-supabase.js
 */

require('dotenv').config()
const sqlite3 = require('sqlite3').verbose()
const { createClient } = require('@supabase/supabase-js')
const path = require('path')

// =====================================================
// CONFIGURAÇÃO
// =====================================================

const DB_PATH = process.env.OLD_DATABASE_URL || path.join(__dirname, '../data/study_progress.db')
const SUPABASE_URL = process.env.SUPABASE_URL
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE

// Validar configuração
if (!SUPABASE_URL || !SUPABASE_SERVICE_KEY) {
  console.error('❌ Erro: Variáveis de ambiente SUPABASE_URL e SUPABASE_SERVICE_ROLE são obrigatórias')
  process.exit(1)
}

// Inicializar clientes
const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY)

// =====================================================
// FUNÇÕES AUXILIARES
// =====================================================

function openSQLiteDatabase() {
  return new Promise((resolve, reject) => {
    const db = new sqlite3.Database(DB_PATH, sqlite3.OPEN_READONLY, (err) => {
      if (err) {
        reject(new Error(`Erro ao abrir banco SQLite: ${err.message}`))
      } else {
        console.log(`✅ Conectado ao SQLite: ${DB_PATH}`)
        resolve(db)
      }
    })
  })
}

function fetchAllProgress(db) {
  return new Promise((resolve, reject) => {
    db.all('SELECT id, completed_at FROM progress', [], (err, rows) => {
      if (err) {
        reject(new Error(`Erro ao buscar dados do SQLite: ${err.message}`))
      } else {
        resolve(rows)
      }
    })
  })
}

function closeSQLiteDatabase(db) {
  return new Promise((resolve, reject) => {
    db.close((err) => {
      if (err) {
        reject(new Error(`Erro ao fechar banco SQLite: ${err.message}`))
      } else {
        console.log('✅ Conexão com SQLite fechada')
        resolve()
      }
    })
  })
}

async function testSupabaseConnection() {
  try {
    const { data, error } = await supabase
      .from('progress')
      .select('count')
      .limit(1)

    if (error) {
      throw new Error(error.message)
    }

    console.log('✅ Conexão com Supabase validada')
    return true
  } catch (error) {
    console.error(`❌ Erro ao conectar no Supabase: ${error.message}`)
    return false
  }
}

async function migrateToSupabase(records) {
  if (records.length === 0) {
    console.log('ℹ️  Nenhum registro para migrar')
    return { inserted: 0, failed: 0 }
  }

  console.log(`\n📦 Migrando ${records.length} registros para o Supabase...`)

  // Transformar formato: SQLite usa "id", Supabase usa "item_id"
  const supabaseRecords = records.map(row => ({
    item_id: row.id,
    completed_at: row.completed_at
  }))

  // Inserir em lotes de 100 (limite recomendado do Supabase)
  const BATCH_SIZE = 100
  let inserted = 0
  let failed = 0

  for (let i = 0; i < supabaseRecords.length; i += BATCH_SIZE) {
    const batch = supabaseRecords.slice(i, i + BATCH_SIZE)

    try {
      const { data, error } = await supabase
        .from('progress')
        .upsert(batch, {
          onConflict: 'item_id',
          ignoreDuplicates: false // Atualizar se já existir
        })

      if (error) {
        console.error(`❌ Erro no lote ${Math.floor(i / BATCH_SIZE) + 1}: ${error.message}`)
        failed += batch.length
      } else {
        inserted += batch.length
        console.log(`✅ Lote ${Math.floor(i / BATCH_SIZE) + 1}: ${batch.length} registros inseridos`)
      }
    } catch (err) {
      console.error(`❌ Erro ao inserir lote ${Math.floor(i / BATCH_SIZE) + 1}: ${err.message}`)
      failed += batch.length
    }
  }

  return { inserted, failed }
}

// =====================================================
// SCRIPT PRINCIPAL
// =====================================================

async function main() {
  console.log('='.repeat(60))
  console.log('🔄 Migração SQLite → Supabase')
  console.log('='.repeat(60))

  let db

  try {
    // 1. Testar conexão com Supabase
    console.log('\n📡 Testando conexão com Supabase...')
    const isConnected = await testSupabaseConnection()

    if (!isConnected) {
      throw new Error('Não foi possível conectar ao Supabase. Verifique suas credenciais.')
    }

    // 2. Abrir banco SQLite
    console.log('\n📂 Abrindo banco SQLite...')
    db = await openSQLiteDatabase()

    // 3. Buscar todos os registros
    console.log('\n📊 Buscando registros do SQLite...')
    const records = await fetchAllProgress(db)

    console.log(`ℹ️  Total de registros encontrados: ${records.length}`)

    if (records.length > 0) {
      console.log('\nPrimeiros 5 registros:')
      records.slice(0, 5).forEach((row, idx) => {
        console.log(`  ${idx + 1}. ID: ${row.id}, Concluído em: ${row.completed_at}`)
      })
    }

    // 4. Confirmar migração
    console.log('\n⚠️  Esta operação irá:')
    console.log('   - Inserir todos os registros no Supabase')
    console.log('   - Atualizar registros existentes (se houver conflito)')
    console.log('   - NÃO irá deletar dados do SQLite local')

    // Pedir confirmação (em produção, use um prompt interativo)
    const shouldProceed = process.env.CONFIRM_MIGRATION === 'yes'

    if (!shouldProceed) {
      console.log('\n❌ Migração cancelada.')
      console.log('ℹ️  Para confirmar, execute: CONFIRM_MIGRATION=yes npm run migrate')
      process.exit(0)
    }

    // 5. Executar migração
    const { inserted, failed } = await migrateToSupabase(records)

    // 6. Resumo
    console.log('\n' + '='.repeat(60))
    console.log('📊 RESUMO DA MIGRAÇÃO')
    console.log('='.repeat(60))
    console.log(`✅ Registros migrados com sucesso: ${inserted}`)
    console.log(`❌ Registros que falharam: ${failed}`)
    console.log(`📁 Total no SQLite original: ${records.length}`)

    if (failed === 0) {
      console.log('\n🎉 Migração concluída com sucesso!')
      console.log('\nPróximos passos:')
      console.log('  1. Verifique os dados no dashboard do Supabase')
      console.log('  2. Teste a API com os novos dados')
      console.log('  3. (Opcional) Faça backup do arquivo SQLite antigo')
    } else {
      console.log('\n⚠️  Migração concluída com erros.')
      console.log('Revise os logs acima e tente novamente se necessário.')
    }

  } catch (error) {
    console.error('\n❌ Erro fatal durante migração:', error.message)
    process.exit(1)
  } finally {
    // Fechar conexão SQLite
    if (db) {
      try {
        await closeSQLiteDatabase(db)
      } catch (err) {
        console.error('⚠️  Erro ao fechar SQLite:', err.message)
      }
    }
  }

  console.log('\n' + '='.repeat(60))
}

// Executar script
main().catch(error => {
  console.error('❌ Erro não tratado:', error)
  process.exit(1)
})
