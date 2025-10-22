#!/bin/bash

# Script para buscar nós do n8n
# Uso: ./n8n_search_nodes.sh "nome do nó"

if [ -z "$1" ]; then
    echo "❌ Erro: Forneça um termo de busca"
    echo ""
    echo "Uso: $0 \"termo de busca\""
    echo ""
    echo "Exemplos:"
    echo "  $0 \"Supabase\""
    echo "  $0 \"HTTP Request\""
    echo "  $0 \"WhatsApp\""
    exit 1
fi

SEARCH_TERM="$1"

echo "🔍 Buscando nós n8n para: $SEARCH_TERM"
echo ""

# Usa o n8n-mcp para buscar nós
npx -y n8n-mcp 2>/dev/null <<EOF
searchNodes "$SEARCH_TERM"
EOF

echo ""
echo "✅ Busca concluída!"
