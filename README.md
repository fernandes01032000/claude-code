# claude-code

Projeto configurado com MCP (Model Context Protocol) para integração com n8n e Supabase.

## MCP Servers Configurados

Este projeto inclui integração com:

- **n8n MCP**: Automação de workflows com acesso a 525+ nós do n8n
- **Supabase MCP**: Gerenciamento e consultas ao banco de dados Supabase

## Quick Start

1. Configure as variáveis de ambiente:
   ```bash
   cp .env.example .env
   # Edite .env com suas credenciais
   ```

2. Carregue as variáveis e inicie o Claude Code:
   ```bash
   source .env
   claude-code
   ```

3. Verifique os MCP servers:
   ```
   /mcp
   ```

## Documentação Completa

Para instruções detalhadas de configuração, credenciais e troubleshooting, consulte:

**[MCP_SETUP.md](./MCP_SETUP.md)**

## Recursos

- [n8n MCP Server](https://github.com/czlonkowski/n8n-mcp)
- [Supabase MCP Docs](https://supabase.com/docs/guides/getting-started/mcp)
- [Model Context Protocol](https://www.anthropic.com/news/model-context-protocol)