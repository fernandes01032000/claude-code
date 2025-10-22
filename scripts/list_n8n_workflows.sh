#!/bin/bash

# Script para listar workflows do n8n
# Requer: N8N_API_URL e N8N_API_KEY

if [ -z "$N8N_API_URL" ] || [ -z "$N8N_API_KEY" ]; then
    echo "❌ Erro: Variáveis de ambiente não configuradas"
    echo ""
    echo "Configure:"
    echo "  export N8N_API_URL=https://automate-n8n.lhwtdz.easypanel.host"
    echo "  export N8N_API_KEY=sua_key"
    exit 1
fi

echo "🔍 Listando workflows do n8n..."
echo ""

# Lista workflows via API REST
curl -s "${N8N_API_URL}/api/v1/workflows" \
  -H "X-N8N-API-KEY: ${N8N_API_KEY}" \
  | jq -r '.data[] | "[\(.id)] \(.name) - Ativo: \(.active)"' 2>/dev/null \
  || echo "Erro ao buscar workflows. Verifique suas credenciais."

echo ""
echo "✅ Consulta concluída!"
