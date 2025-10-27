# Configuração dos MCP Servers

Este projeto está configurado com dois servidores MCP (Model Context Protocol):

## 1. n8n MCP Server

O n8n-mcp fornece ao Claude acesso completo à documentação de 525+ nós do n8n e, opcionalmente, gerenciamento de workflows.

### Capacidades:
- **Sem credenciais API**: Acesso à documentação completa dos nós n8n, validação de workflows
- **Com credenciais API**: Gerenciamento completo de workflows (criar, editar, executar)

### Configuração:

1. **Modo básico (apenas documentação)**:
   - Não é necessário configurar variáveis de ambiente
   - O MCP já funcionará com acesso à documentação

2. **Modo completo (com gerenciamento de workflows)**:
   - Configure as variáveis no seu ambiente:
     ```bash
     export N8N_API_URL=https://sua-instancia-n8n.com
     export N8N_API_KEY=sua-api-key
     ```
   - Ou crie um arquivo `.env` baseado no `.env.example`

### Como obter credenciais n8n:
1. Acesse sua instância n8n
2. Vá em Settings > API
3. Gere uma nova API key
4. Use a URL da sua instância e a API key gerada

## 2. Supabase MCP Server

O Supabase MCP permite ao Claude interagir com seu banco de dados Supabase.

### Capacidades:
- Consultar tabelas
- Gerenciar configurações
- Gerar tipos TypeScript
- Interagir com Storage e Edge Functions

### Configuração:

Configure as variáveis de ambiente:
```bash
export SUPABASE_URL=https://seu-projeto.supabase.co
export SUPABASE_SERVICE_ROLE_KEY=sua-service-role-key
```

### Como obter credenciais Supabase:
1. Acesse seu projeto no [Supabase Dashboard](https://app.supabase.com)
2. Vá em Settings > API
3. Copie a **URL** do projeto
4. Copie a **service_role key** (⚠️ Esta chave tem acesso administrativo!)

### ⚠️ Importante - Segurança:
- **Use apenas em ambiente de desenvolvimento/teste**
- **NÃO use com dados de produção**
- **NÃO commite a service_role_key no git**
- Considere criar um projeto Supabase separado para desenvolvimento com IA

## Como usar no Claude Code

### Opção 1: Variáveis de Ambiente (Recomendado)

1. Copie o arquivo de exemplo:
   ```bash
   cp .env.example .env
   ```

2. Edite o `.env` com suas credenciais reais

3. Carregue as variáveis antes de iniciar o Claude Code:
   ```bash
   source .env
   claude-code
   ```

### Opção 2: Exportar manualmente

```bash
export N8N_API_URL=https://sua-instancia-n8n.com
export N8N_API_KEY=sua-api-key
export SUPABASE_URL=https://seu-projeto.supabase.co
export SUPABASE_SERVICE_ROLE_KEY=sua-service-role-key

claude-code
```

### Opção 3: Configuração permanente no shell

Adicione ao seu `~/.bashrc`, `~/.zshrc`, ou similar:
```bash
export N8N_API_URL=https://sua-instancia-n8n.com
export N8N_API_KEY=sua-api-key
export SUPABASE_URL=https://seu-projeto.supabase.co
export SUPABASE_SERVICE_ROLE_KEY=sua-service-role-key
```

## Verificando a configuração

Depois de configurar, você pode verificar se os MCP servers estão ativos:

1. Inicie o Claude Code
2. Digite `/mcp` para ver o status dos servidores
3. Ou use o comando: `claude mcp list`

## Testando os MCP Servers

### Teste n8n:
Pergunte ao Claude:
> "Mostre-me como criar um workflow n8n que envia um email quando um webhook é chamado"

### Teste Supabase:
Pergunte ao Claude:
> "Liste as tabelas disponíveis no meu projeto Supabase"
> "Crie uma query para buscar usuários ativos"

## Troubleshooting

### MCP servers não aparecem
- Verifique se as variáveis de ambiente estão definidas: `echo $N8N_API_URL`
- Reinicie o Claude Code após definir as variáveis
- Verifique se o arquivo `.mcp.json` está no root do projeto

### Erros de autenticação
- Verifique se as credenciais estão corretas
- Para n8n: teste acessar `$N8N_API_URL/api/v1/workflows` com sua API key
- Para Supabase: verifique se a service_role_key está correta no dashboard

### MCP server não conecta
- Certifique-se de ter Node.js instalado (npx precisa estar disponível)
- Execute `npx -y n8n-mcp` manualmente para verificar se há erros
- Execute `npx -y @supabase/mcp-server-supabase` manualmente para verificar

## Recursos Adicionais

- [n8n-mcp GitHub](https://github.com/czlonkowski/n8n-mcp)
- [Supabase MCP Docs](https://supabase.com/docs/guides/getting-started/mcp)
- [Model Context Protocol](https://www.anthropic.com/news/model-context-protocol)
- [Claude Code MCP Documentation](https://docs.claude.com/en/docs/claude-code/mcp)

## Alternativas de Configuração

### n8n-mcp via Docker:
Se preferir usar Docker em vez de npx, edite `.mcp.json`:
```json
{
  "n8n-mcp": {
    "command": "docker",
    "args": [
      "run",
      "-i",
      "--rm",
      "--init",
      "-e", "N8N_API_URL=${N8N_API_URL}",
      "-e", "N8N_API_KEY=${N8N_API_KEY}",
      "ghcr.io/czlonkowski/n8n-mcp:latest"
    ]
  }
}
```

### Instalação local do n8n-mcp:
```bash
git clone https://github.com/czlonkowski/n8n-mcp.git
cd n8n-mcp
npm install
npm run build
npm run rebuild
```

Depois edite `.mcp.json` para apontar para o caminho local:
```json
{
  "n8n-mcp": {
    "command": "node",
    "args": ["/caminho/para/n8n-mcp/dist/index.js"]
  }
}
```
