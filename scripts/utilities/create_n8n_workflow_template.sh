#!/bin/bash

# Script para criar template de workflow n8n
# Gera um JSON base para workflows comuns

WORKFLOW_TYPE="$1"

if [ -z "$WORKFLOW_TYPE" ]; then
    echo "📋 Tipos de workflow disponíveis:"
    echo ""
    echo "  1) webhook-to-supabase   - Webhook que salva no Supabase"
    echo "  2) scheduled-report      - Relatório agendado"
    echo "  3) payment-processor     - Processador de pagamentos"
    echo "  4) whatsapp-automation   - Automação de WhatsApp"
    echo ""
    echo "Uso: $0 <tipo>"
    echo ""
    echo "Exemplo: $0 webhook-to-supabase"
    exit 1
fi

case "$WORKFLOW_TYPE" in
    "webhook-to-supabase")
        cat > "workflow-webhook-to-supabase.json" <<'EOF'
{
  "name": "Webhook para Supabase",
  "nodes": [
    {
      "parameters": {
        "httpMethod": "POST",
        "path": "webhook",
        "responseMode": "onReceived"
      },
      "name": "Webhook",
      "type": "n8n-nodes-base.webhook",
      "position": [250, 300]
    },
    {
      "parameters": {
        "authentication": "serviceAccount",
        "serviceAccountEmail": "{{ $env.SUPABASE_URL }}",
        "operation": "insert",
        "table": "agendamentos",
        "fields": {
          "mappingMode": "defineBelow",
          "value": {
            "empresa_id": "={{ $json.empresa_id }}",
            "cliente_nome": "={{ $json.cliente_nome }}",
            "cliente_whatsapp": "={{ $json.cliente_whatsapp }}"
          }
        }
      },
      "name": "Supabase",
      "type": "n8n-nodes-base.supabase",
      "position": [450, 300]
    }
  ],
  "connections": {
    "Webhook": {
      "main": [[{"node": "Supabase", "type": "main", "index": 0}]]
    }
  }
}
EOF
        echo "✅ Template criado: workflow-webhook-to-supabase.json"
        ;;

    "scheduled-report")
        cat > "workflow-scheduled-report.json" <<'EOF'
{
  "name": "Relatório Diário",
  "nodes": [
    {
      "parameters": {
        "rule": {
          "interval": [{"field": "cronExpression", "expression": "0 9 * * *"}]
        }
      },
      "name": "Schedule Trigger",
      "type": "n8n-nodes-base.scheduleTrigger",
      "position": [250, 300]
    },
    {
      "parameters": {
        "authentication": "serviceAccount",
        "operation": "select",
        "table": "agendamentos",
        "returnAll": true
      },
      "name": "Buscar Agendamentos",
      "type": "n8n-nodes-base.supabase",
      "position": [450, 300]
    },
    {
      "parameters": {
        "operation": "sendMessage",
        "message": "Relatório diário: {{ $json.length }} agendamentos"
      },
      "name": "Enviar WhatsApp",
      "type": "n8n-nodes-base.whatsapp",
      "position": [650, 300]
    }
  ]
}
EOF
        echo "✅ Template criado: workflow-scheduled-report.json"
        ;;

    "payment-processor")
        echo "📝 Template de processador de pagamentos em desenvolvimento..."
        ;;

    "whatsapp-automation")
        echo "📝 Template de automação WhatsApp em desenvolvimento..."
        ;;

    *)
        echo "❌ Tipo de workflow desconhecido: $WORKFLOW_TYPE"
        exit 1
        ;;
esac
