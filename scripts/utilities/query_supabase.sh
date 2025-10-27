#!/bin/bash

# Script para fazer queries no Supabase
# Uso: ./query_supabase.sh <tabela> [campos] [filtro]

if [ -z "$SUPABASE_URL" ] || [ -z "$SUPABASE_SERVICE_ROLE_KEY" ]; then
    echo "❌ Erro: Variáveis de ambiente não configuradas"
    exit 1
fi

TABELA="$1"
CAMPOS="${2:-*}"
FILTRO="$3"

if [ -z "$TABELA" ]; then
    echo "❌ Erro: Forneça o nome da tabela"
    echo ""
    echo "Uso: $0 <tabela> [campos] [filtro]"
    echo ""
    echo "Exemplos:"
    echo "  $0 empresas"
    echo "  $0 clientes 'id,nome,whatsapp'"
    echo "  $0 agendamentos '*' 'status=eq.pendente'"
    echo ""
    echo "Tabelas disponíveis:"
    echo "  - empresas"
    echo "  - servicos"
    echo "  - clientes"
    echo "  - agendamentos"
    echo "  - horarios"
    echo "  - pagamentos"
    echo "  - faq_entries"
    echo "  - logs"
    exit 1
fi

echo "🔍 Consultando tabela: $TABELA"
echo "📋 Campos: $CAMPOS"
if [ -n "$FILTRO" ]; then
    echo "🔎 Filtro: $FILTRO"
fi
echo ""

# Monta a URL
URL="${SUPABASE_URL}/rest/v1/${TABELA}?select=${CAMPOS}"
if [ -n "$FILTRO" ]; then
    URL="${URL}&${FILTRO}"
fi

# Faz a query
curl -s "$URL" \
  -H "apikey: ${SUPABASE_SERVICE_ROLE_KEY}" \
  -H "Authorization: Bearer ${SUPABASE_SERVICE_ROLE_KEY}" \
  | jq '.' 2>/dev/null

echo ""
echo "✅ Consulta concluída!"
