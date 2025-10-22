# Prompt para Futuras Sessões do Claude Code

## 📋 Contexto do Projeto

Este projeto é um **sistema de agendamento para clínicas** com integração completa de:
- **n8n**: Automação de workflows (537 nós disponíveis)
- **Supabase**: Banco de dados PostgreSQL com 9 tabelas
- **Evolution API**: Automação de WhatsApp
- **Mercado Pago**: Processamento de pagamentos

## 🎯 Status Atual: 100% Funcional

### Empresa Configurada
- **Nome**: Clinica Dr Fernandes
- **ID**: fdb64361-e13a-42c6-ba27-ba60c9ed59c0
- **Nicho**: Clínica Popular
- **WhatsApp**: 91985533022
- **Status**: inativo (onboarding step 2)

### Sistemas Integrados
1. **n8n API**: https://automate-n8n.lhwtdz.easypanel.host
2. **Supabase**: https://ytuudnmxmhpuhnfhikkc.supabase.co
3. **Evolution API**: Instance ID configurado
4. **Workflow ativo**: "WhatsApp - Create Instance"

## 🔑 Credenciais (GitHub Codespaces Secrets)

As credenciais estão configuradas como secrets do GitHub Codespaces:
- `N8N_API_URL`
- `N8N_API_KEY`
- `SUPABASE_URL`
- `SUPABASE_SERVICE_ROLE_KEY`

**Verificar se estão carregadas:**
```bash
printenv | grep N8N
printenv | grep SUPABASE
```

## 📁 Estrutura do Projeto

```
/workspaces/claude-code/
├── .mcp.json                      # Configuração MCP (n8n + Supabase)
├── .env.example                    # Template de variáveis
├── .gitignore                      # Proteção de credenciais
├── README.md                       # Overview do projeto
├── MCP_SETUP.md                    # Setup completo dos MCPs
├── TESTING_GUIDE.md                # Guia de testes
├── SUPABASE_SCHEMA.md              # Schema de 9 tabelas
├── MCP_WEB_LIMITATIONS.md          # Limitações no web
├── INTEGRATION_TEST_RESULTS.md     # Resultados dos testes
└── scripts/
    ├── n8n_search_nodes.sh         # Buscar nós do n8n
    ├── list_n8n_workflows.sh       # Listar workflows
    ├── query_supabase.sh           # Consultar tabelas
    ├── list_supabase_tables.sh     # Listar tabelas
    └── create_n8n_workflow_template.sh  # Gerar templates
```

## 🗄️ Schema do Banco Supabase

### 9 Tabelas Principais:
1. **empresas** - Dados da clínica/empresa
2. **servicos** - Serviços oferecidos
3. **clientes** - Base de pacientes
4. **agendamentos** - Consultas agendadas
5. **horarios** - Horários de funcionamento
6. **pagamentos** - Pagamentos via MP
7. **nicho_templates** - Templates por setor
8. **faq_entries** - Perguntas frequentes
9. **logs** - Logs do sistema

### RPC Functions:
- `try_book_slot` - Reservar horário atomicamente

## 🚀 Como Usar os MCPs no Claude Code Web

### ⚠️ IMPORTANTE: Limitações do Ambiente Web

O Claude Code Web **NÃO TEM ACESSO DIRETO** aos MCP servers porque:
- Executa em ambiente servidor separado
- Não acessa GitHub Codespaces Secrets automaticamente
- Variáveis de ambiente não são visíveis para o Claude

### ✅ Solução: Usar Scripts Utilitários

Os scripts têm acesso às variáveis porque rodam no terminal do Codespaces:

#### 1. Listar Workflows do n8n
```bash
./scripts/list_n8n_workflows.sh
```

#### 2. Buscar Nós do n8n
```bash
./scripts/n8n_search_nodes.sh "termo de busca"

# Exemplos:
./scripts/n8n_search_nodes.sh "Supabase"
./scripts/n8n_search_nodes.sh "HTTP"
./scripts/n8n_search_nodes.sh "WhatsApp"
```

#### 3. Consultar Supabase
```bash
./scripts/query_supabase.sh <tabela> [campos] [filtro]

# Exemplos:
./scripts/query_supabase.sh empresas
./scripts/query_supabase.sh clientes 'id,nome,whatsapp'
./scripts/query_supabase.sh agendamentos '*' 'status=eq.pendente'
```

#### 4. Listar Tabelas
```bash
./scripts/list_supabase_tables.sh
```

#### 5. Gerar Templates de Workflow
```bash
./scripts/create_n8n_workflow_template.sh webhook-to-supabase
./scripts/create_n8n_workflow_template.sh scheduled-report
```

## 🎯 Como o Claude Deve Trabalhar

### Quando o usuário pedir informações:

**❌ NÃO TENTE:**
- Usar MCPs diretamente (não funcionam no web)
- Acessar variáveis de ambiente (não estão disponíveis)
- Executar comandos que exigem autenticação MCP

**✅ FAÇA ISSO:**
- Peça ao usuário para executar os scripts no terminal
- Use a saída dos scripts para trabalhar
- Crie novos scripts se necessário
- Acesse via API REST quando possível

### Exemplo de Fluxo Correto:

**Usuário pergunta:** "Quais workflows estão ativos no n8n?"

**Claude responde:**
```
Por favor, execute no terminal do seu Codespaces:

./scripts/list_n8n_workflows.sh

Cole a saída aqui e vou analisar para você!
```

**Usuário cola a saída, Claude analisa e responde.**

## 📊 Queries Úteis via curl

Se os scripts não funcionarem, use curl diretamente:

### n8n API
```bash
# Listar workflows
curl -s "${N8N_API_URL}/api/v1/workflows" \
  -H "X-N8N-API-KEY: ${N8N_API_KEY}" | jq

# Buscar workflow por ID
curl -s "${N8N_API_URL}/api/v1/workflows/ID" \
  -H "X-N8N-API-KEY: ${N8N_API_KEY}" | jq
```

### Supabase REST API
```bash
# Listar empresas
curl -s "${SUPABASE_URL}/rest/v1/empresas?select=*" \
  -H "apikey: ${SUPABASE_SERVICE_ROLE_KEY}" \
  -H "Authorization: Bearer ${SUPABASE_SERVICE_ROLE_KEY}" | jq

# Filtrar por status
curl -s "${SUPABASE_URL}/rest/v1/agendamentos?status=eq.pendente" \
  -H "apikey: ${SUPABASE_SERVICE_ROLE_KEY}" \
  -H "Authorization: Bearer ${SUPABASE_SERVICE_ROLE_KEY}" | jq

# Inserir registro
curl -X POST "${SUPABASE_URL}/rest/v1/clientes" \
  -H "apikey: ${SUPABASE_SERVICE_ROLE_KEY}" \
  -H "Authorization: Bearer ${SUPABASE_SERVICE_ROLE_KEY}" \
  -H "Content-Type: application/json" \
  -d '{"empresa_id":"fdb64361-e13a-42c6-ba27-ba60c9ed59c0","nome":"João","whatsapp":"91999999999"}'
```

## 🤖 Automações Disponíveis

### 1. Confirmação de Agendamento
```
Trigger: Novo em 'agendamentos'
→ Buscar dados da empresa
→ Enviar WhatsApp via Evolution
→ Criar pagamento no MP
→ Enviar link de pagamento
```

### 2. Lembrete 24h Antes
```
Trigger: Cron diário
→ Buscar agendamentos próximos
→ Enviar lembretes via WhatsApp
```

### 3. Processamento de Pagamento
```
Webhook: Mercado Pago IPN
→ Atualizar status pagamento
→ Atualizar status agendamento
→ Notificar cliente
```

### 4. FAQ Automático
```
Webhook: WhatsApp recebido
→ Buscar em faq_entries
→ Responder automaticamente
```

### 5. Relatório Diário
```
Cron: Diário 18h
→ Contar agendamentos
→ Calcular receita
→ Enviar resumo
```

## 🔧 Troubleshooting

### Scripts não executam
```bash
# Tornar executável
chmod +x scripts/*.sh

# Verificar se está no diretório correto
cd /workspaces/claude-code
```

### Variáveis não carregadas
```bash
# Verificar
printenv | grep SUPABASE
printenv | grep N8N

# Se vazias, recarregar
# As secrets do GitHub devem estar configuradas em:
# https://github.com/settings/codespaces
```

### MCP não funciona
```
⚠️ IMPORTANTE: MCPs não funcionam no Claude Code Web!

Use os scripts utilitários que acessam as APIs diretamente.
```

## 📚 Documentação Completa

Para detalhes completos sobre cada aspecto:

- **MCP_SETUP.md** - Como configurar do zero
- **TESTING_GUIDE.md** - Como testar funcionalidades
- **SUPABASE_SCHEMA.md** - Todas as tabelas e campos
- **MCP_WEB_LIMITATIONS.md** - Por que MCPs não funcionam no web
- **INTEGRATION_TEST_RESULTS.md** - Testes já realizados

## 🎯 Tarefas Comuns

### Ativar a Empresa
```bash
curl -X PATCH "${SUPABASE_URL}/rest/v1/empresas?id=eq.fdb64361-e13a-42c6-ba27-ba60c9ed59c0" \
  -H "apikey: ${SUPABASE_SERVICE_ROLE_KEY}" \
  -H "Authorization: Bearer ${SUPABASE_SERVICE_ROLE_KEY}" \
  -H "Content-Type: application/json" \
  -H "Prefer: return=representation" \
  -d '{"status": "ativo"}'
```

### Criar Serviço
```bash
curl -X POST "${SUPABASE_URL}/rest/v1/servicos" \
  -H "apikey: ${SUPABASE_SERVICE_ROLE_KEY}" \
  -H "Authorization: Bearer ${SUPABASE_SERVICE_ROLE_KEY}" \
  -H "Content-Type: application/json" \
  -H "Prefer: return=representation" \
  -d '{
    "empresa_id": "fdb64361-e13a-42c6-ba27-ba60c9ed59c0",
    "nome": "Consulta Geral",
    "preco_cents": 5000,
    "duracao_min": 30,
    "ativo": true
  }'
```

### Buscar Agendamentos de Hoje
```bash
TODAY=$(date -u +%Y-%m-%d)
curl -s "${SUPABASE_URL}/rest/v1/agendamentos?inicio=gte.${TODAY}T00:00:00Z&inicio=lt.${TODAY}T23:59:59Z" \
  -H "apikey: ${SUPABASE_SERVICE_ROLE_KEY}" \
  -H "Authorization: Bearer ${SUPABASE_SERVICE_ROLE_KEY}" | jq
```

## 💡 Dicas para o Claude

1. **Sempre peça ao usuário** para executar scripts no terminal
2. **Analise a saída** que o usuário colar
3. **Crie novos scripts** quando necessário
4. **Use curl direto** se preferir
5. **Nunca tente acessar MCPs diretamente** no ambiente web
6. **Consulte a documentação** nos arquivos .md quando precisar
7. **Verifique o schema** em SUPABASE_SCHEMA.md antes de queries

## 🚦 Checklist de Início de Sessão

Quando começar uma nova sessão, peça ao usuário:

```bash
# 1. Verificar branch
git branch

# 2. Pull das últimas mudanças
git pull origin claude/mcp-talude-integration-011CUMikQkzzpTZqAp4rd6Vg

# 3. Verificar variáveis
printenv | grep SUPABASE
printenv | grep N8N

# 4. Testar conectividade
./scripts/query_supabase.sh empresas
./scripts/list_n8n_workflows.sh
```

Se tudo mostrar dados, está tudo funcionando! ✅

## 🎓 Resumo Executivo

**Para usar os MCPs neste projeto:**

1. Os MCPs estão configurados mas **não funcionam diretamente** no Claude Code Web
2. Use os **5 scripts utilitários** que fazem as chamadas API
3. Peça ao usuário para **executar scripts no terminal** do Codespaces
4. **Analise a saída** que o usuário colar
5. **Crie automações** baseado nos dados obtidos
6. **Consulte a documentação** nos arquivos .md quando precisar

**Empresa atual:**
- Clinica Dr Fernandes (ID: fdb64361-e13a-42c6-ba27-ba60c9ed59c0)
- WhatsApp: 91985533022
- Status: inativo (precisa ativar)
- 1 workflow ativo no n8n

**Próximos passos típicos:**
1. Ativar empresa
2. Cadastrar serviços
3. Configurar horários
4. Criar automações de agendamento
5. Integrar WhatsApp + Pagamentos

---

**Este prompt garante que qualquer sessão futura do Claude Code saberá:**
- ✅ Como o projeto está estruturado
- ✅ Onde estão as credenciais
- ✅ Por que MCPs não funcionam direto
- ✅ Como usar os scripts corretamente
- ✅ O que já foi feito e o que falta
