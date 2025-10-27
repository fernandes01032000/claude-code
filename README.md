# Claude Code + n8n + Supabase Integration

Sistema completo de agendamento com automação via n8n e banco de dados Supabase, integrado através do Model Context Protocol (MCP).

## Status: ✅ 100% Funcional

Ambos os MCP servers testados e operacionais:
- **n8n MCP**: 537 nós, 41 ferramentas disponíveis
- **Supabase MCP**: 9 tabelas, API REST funcionando

## Sistema de Agendamento

### Funcionalidades
- Gestão de empresas e serviços
- Agendamentos com clientes
- Pagamentos via Mercado Pago
- Integração WhatsApp (Evolution API)
- FAQ automático
- Sistema de logs

### Dados Atuais
- **1 Empresa:** Clinica Dr Fernandes
- **9 Tabelas:** empresas, servicos, clientes, agendamentos, horarios, pagamentos, nicho_templates, faq_entries, logs
- **Integrações:** Evolution API (WhatsApp), Mercado Pago, n8n

## Quick Start

### 1. Configure as credenciais (GitHub Codespaces)

Adicione secrets no GitHub:
- `N8N_API_URL`
- `N8N_API_KEY`
- `SUPABASE_URL`
- `SUPABASE_SERVICE_ROLE_KEY`

### 2. Use os scripts prontos

```bash
# Listar workflows do n8n
./scripts/list_n8n_workflows.sh

# Buscar nós do n8n
./scripts/n8n_search_nodes.sh "Supabase"

# Consultar dados do Supabase
./scripts/query_supabase.sh empresas
./scripts/query_supabase.sh clientes 'id,nome,whatsapp'

# Criar template de workflow
./scripts/create_n8n_workflow_template.sh webhook-to-supabase
```

## Automações Sugeridas

### 1. Confirmação de Agendamento
Novo agendamento → WhatsApp + Pagamento MP

### 2. Lembrete 24h Antes
Cron diário → Buscar agendamentos → Enviar lembretes

### 3. Processamento de Pagamentos
Webhook MP → Atualizar status → Notificar cliente

### 4. FAQ Automático
WhatsApp recebido → Buscar FAQ → Responder

### 5. Relatório Diário
Cron 18h → Resumo do dia → WhatsApp gestor

## Documentação

- **[MCP_SETUP.md](./MCP_SETUP.md)** - Configuração completa dos MCPs
- **[TESTING_GUIDE.md](./TESTING_GUIDE.md)** - Como testar os servidores
- **[SUPABASE_SCHEMA.md](./SUPABASE_SCHEMA.md)** - Schema completo do banco
- **[INTEGRATION_TEST_RESULTS.md](./INTEGRATION_TEST_RESULTS.md)** - Resultados dos testes
- **[MCP_WEB_LIMITATIONS.md](./MCP_WEB_LIMITATIONS.md)** - Limitações no ambiente web

## Scripts Disponíveis

| Script | Descrição |
|--------|-----------|
| `n8n_search_nodes.sh` | Buscar nós do n8n |
| `list_n8n_workflows.sh` | Listar workflows |
| `query_supabase.sh` | Consultar tabelas |
| `list_supabase_tables.sh` | Listar tabelas |
| `create_n8n_workflow_template.sh` | Gerar templates |

## Recursos Externos

- [n8n MCP Server](https://github.com/czlonkowski/n8n-mcp)
- [Supabase MCP Docs](https://supabase.com/docs/guides/getting-started/mcp)
- [Model Context Protocol](https://www.anthropic.com/news/model-context-protocol)
- [Evolution API](https://evolution-api.com/)

## Próximos Passos

1. Ativar empresa no Supabase
2. Cadastrar serviços e horários
3. Criar primeiro workflow n8n
4. Configurar Evolution API
5. Testar fluxo completo

---

## 🏥 SANDRA API Scanner & Test Server

Sistema completo para testar e documentar APIs do sistema SANDRA (Hospital Geral de Umbuzeiro).

### 📦 Dois Sistemas Independentes

#### 1. Sistema SANDRA (Produção)
- **sandra_api_scanner.js** - Scanner para console do navegador
- **sandra_api_scanner.py** - Scanner Python com automação
- **sandra_dashboard_bootstrap.html** - Dashboard visual em tempo real
- **extrair_cookies.js** - Auxiliar para extração de cookies

#### 2. Sistema de Testes (Desenvolvimento)
- **test-server.js** - Servidor HTTP mock com APIs fake
- **test-api-client.py** - Cliente universal para testar APIs
- **run-demo.sh** - Demo automática completa

### 🚀 Quick Start

```bash
# Demo rápida (30 segundos)
./run-demo.sh

# Testar com LocalTunnel
python3 test-api-client.py https://sua-url.loca.lt

# Scanner do SANDRA (console)
# 1. Abra https://sandra.hgumba.eb.mil.br
# 2. F12 → Console
# 3. Cole o conteúdo de sandra_api_scanner.js

# Dashboard visual
firefox sandra_dashboard_bootstrap.html
```

### 📚 Documentação SANDRA

- **[INDEX.md](./INDEX.md)** ⭐ **Navegação rápida - Comece aqui!**
- **[GUIA_COMPLETO.md](./GUIA_COMPLETO.md)** - Guia completo de todos os arquivos
- **[SANDRA_SCANNER_README.md](./SANDRA_SCANNER_README.md)** - Scanner do SANDRA
- **[TEST_SERVER_README.md](./TEST_SERVER_README.md)** - Servidor de testes
- **[LOCALTUNNEL_GUIDE.md](./LOCALTUNNEL_GUIDE.md)** - Como usar LocalTunnel
- **[EXEMPLO_PRATICO.md](./EXEMPLO_PRATICO.md)** - Exemplos práticos

### 🎯 Casos de Uso

| Quero... | Use isto... |
|----------|-------------|
| Teste rápido (30s) | `./run-demo.sh` |
| Ver dados do SANDRA | `sandra_dashboard_bootstrap.html` |
| Testar LocalTunnel | `python3 test-api-client.py https://url` |
| Automação Python | `sandra_api_scanner.py` |

---

**Sistema pronto para produção!** 🚀