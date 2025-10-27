# Multi-Project Development Repository

Repositório organizado para desenvolvimento de múltiplos projetos e ferramentas com funcionalidades diversas.

## Estrutura do Repositório

```
.
├── projects/          # Projetos independentes
│   ├── sandra-api-scanner/    # Scanner de API SANDRA para sistemas de saúde
│   └── test-tools/            # Ferramentas de teste de API e servidor
├── scripts/           # Scripts utilitários organizados
│   ├── installation/          # Scripts de instalação
│   ├── setup/                 # Scripts de configuração
│   └── utilities/             # Scripts de utilidade geral
├── docs/              # Documentação
│   ├── guides/               # Guias em inglês
│   ├── pt-BR/                # Documentação em português
│   └── examples/             # Exemplos e outputs
└── .ai/               # Contexto de desenvolvimento com IA
```

## Projetos Disponíveis

### 1. SANDRA API Scanner
Scanner terminal para testes de API de sistemas de saúde.

**Localização:** `projects/sandra-api-scanner/`

**Recursos:**
- Busca de pacientes e médicos
- Consulta de agendamentos
- Validação de CPF
- Testes de endpoints

**Como usar:**
```bash
cd projects/sandra-api-scanner
python sandra_api_scanner.py
```

**Documentação:** [projects/sandra-api-scanner/README.md](projects/sandra-api-scanner/README.md)

---

### 2. Test Tools (API Testing Framework)
Framework completo de teste de API com servidor e cliente.

**Localização:** `projects/test-tools/`

**Recursos:**
- Servidor de teste Node.js
- Cliente Python com métricas de performance
- Suporte a LocalTunnel para exposição pública
- Testes de carga e latência

**Como usar:**
```bash
cd projects/test-tools
node test-server.js  # Terminal 1
python test-api-client.py  # Terminal 2
```

**Documentação:** [projects/test-tools/README.md](projects/test-tools/README.md)

---

## Scripts Organizados

### Instalação
- **install-node-manual.sh** - Instalação manual do Node.js v22

**Localização:** `scripts/installation/`

### Configuração
- **setup_sandra_scanner.sh** - Configuração do SANDRA Scanner
- **setup-tunnel.sh** - Configuração de túneis LocalTunnel

**Localização:** `scripts/setup/`

### Utilidades
- **run-demo.sh** - Execução de demonstrações
- **create_n8n_workflow_template.sh** - Templates de workflow n8n
- **list_n8n_workflows.sh** - Listar workflows n8n
- **list_supabase_tables.sh** - Listar tabelas Supabase
- **n8n_search_nodes.sh** - Buscar nós n8n
- **query_supabase.sh** - Consultar dados Supabase

**Localização:** `scripts/utilities/`

---

## Documentação

### Guias Principais (Inglês)
- [Tunnel Guide](docs/guides/TUNNEL_GUIDE.md) - Guia completo de túneis
- [LocalTunnel Guide](docs/guides/LOCALTUNNEL_GUIDE.md) - Configuração LocalTunnel
- [Test Server](docs/guides/TEST_SERVER_README.md) - Servidor de testes
- [Testing Guide](docs/guides/TESTING_GUIDE.md) - Guia de testes
- [MCP Setup](docs/guides/MCP_SETUP.md) - Configuração MCP
- [Supabase Schema](docs/guides/SUPABASE_SCHEMA.md) - Schema do banco
- [Integration Tests](docs/guides/INTEGRATION_TEST_RESULTS.md) - Resultados de testes

### Documentação em Português
- [Guia de Túneis PT](docs/pt-BR/README_TUNNELS_PT.md)
- [Exemplo Prático](docs/pt-BR/EXEMPLO_PRATICO.md)

### Exemplos
- [Exemplo de Output SANDRA Scanner](docs/examples/sandra_scanner_output.txt)

---

## Integrações Disponíveis

### n8n + Supabase (Status: ✅ 100% Funcional)
- **n8n MCP**: 537 nós, 41 ferramentas
- **Supabase MCP**: 9 tabelas, API REST
- **Integrações**: Evolution API, Mercado Pago

**Sistema de Agendamento:**
- Gestão de empresas e serviços
- Agendamentos com clientes
- Pagamentos via Mercado Pago
- WhatsApp (Evolution API)
- FAQ automático

---

## Configuração Inicial

### 1. Clone o repositório
```bash
git clone <repository-url>
cd claude-code
```

### 2. Configure credenciais
Copie `.env.example` para `.env` e preencha:
```bash
cp .env.example .env
```

**Variáveis necessárias:**
- `N8N_API_URL` - URL da instância n8n
- `N8N_API_KEY` - Chave de API n8n
- `SUPABASE_URL` - URL do projeto Supabase
- `SUPABASE_SERVICE_ROLE_KEY` - Service role key Supabase

### 3. Instale dependências
```bash
# Node.js (recomendado: v22)
./scripts/installation/install-node-manual.sh

# Python 3.6+
pip install requests
```

---

## Adicionando Novos Projetos

Para adicionar um novo projeto:

1. Crie diretório em `projects/nome-do-projeto/`
2. Adicione arquivo `README.md` no projeto
3. Organize código-fonte, testes e docs no diretório do projeto
4. Atualize este README com link para o novo projeto

---

## Recursos Externos

- [n8n MCP Server](https://github.com/czlonkowski/n8n-mcp)
- [Supabase MCP Docs](https://supabase.com/docs/guides/getting-started/mcp)
- [Model Context Protocol](https://www.anthropic.com/news/model-context-protocol)
- [Evolution API](https://evolution-api.com/)

---

## Licença

Este repositório é para uso pessoal e desenvolvimento de múltiplos projetos.