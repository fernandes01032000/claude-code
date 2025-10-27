#!/bin/bash

# Script para listar tabelas do Supabase via API REST
# Requer: SUPABASE_URL e SUPABASE_SERVICE_ROLE_KEY como variáveis de ambiente

if [ -z "$SUPABASE_URL" ] || [ -z "$SUPABASE_SERVICE_ROLE_KEY" ]; then
    echo "❌ Erro: Variáveis de ambiente não configuradas"
    echo ""
    echo "Configure as variáveis:"
    echo "  export SUPABASE_URL=https://ytuudnmxmhpuhnfhikkc.supabase.co"
    echo "  export SUPABASE_SERVICE_ROLE_KEY=sua_key_aqui"
    echo ""
    echo "Ou execute com:"
    echo "  SUPABASE_URL=... SUPABASE_SERVICE_ROLE_KEY=... $0"
    exit 1
fi

echo "🔍 Listando tabelas do Supabase..."
echo ""

# Lista todas as tabelas usando a API REST
curl -s "${SUPABASE_URL}/rest/v1/" \
  -H "apikey: ${SUPABASE_SERVICE_ROLE_KEY}" \
  -H "Authorization: Bearer ${SUPABASE_SERVICE_ROLE_KEY}" \
  | jq -r 'keys[]' 2>/dev/null || echo "Erro ao buscar tabelas. Verifique as credenciais."

echo ""
echo "✅ Consulta concluída!"
