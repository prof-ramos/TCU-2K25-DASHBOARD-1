const { createClient } = require('@supabase/supabase-js')

// Validar variáveis de ambiente
const supabaseUrl = process.env.SUPABASE_URL
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE

if (!supabaseUrl) {
  throw new Error('SUPABASE_URL não está definida nas variáveis de ambiente')
}

if (!supabaseServiceKey) {
  throw new Error('SUPABASE_SERVICE_ROLE não está definida nas variáveis de ambiente')
}

// Criar cliente Supabase com a service role key
// IMPORTANTE: Esta chave NUNCA deve ser exposta no frontend
// Ela tem permissões administrativas completas
const supabase = createClient(supabaseUrl, supabaseServiceKey, {
  auth: {
    autoRefreshToken: false,
    persistSession: false,
    detectSessionInUrl: false
  },
  db: {
    schema: 'public'
  }
})

// Testar conexão (executado na inicialização)
async function testConnection() {
  try {
    const { data, error } = await supabase
      .from('progress')
      .select('count')
      .limit(1)

    if (error) {
      console.error('❌ Erro ao conectar no Supabase:', error.message)
      return false
    }

    console.log('✅ Conexão com Supabase estabelecida com sucesso')
    return true
  } catch (err) {
    console.error('❌ Erro crítico ao conectar no Supabase:', err.message)
    return false
  }
}

module.exports = {
  supabase,
  testConnection
}
