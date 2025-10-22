# MCP no Claude Code Web - Configuração Atualizada

## 🎯 Problema Identificado

O Claude Code Web (navegador) **não tem acesso direto** às GitHub Codespaces Secrets porque executa em um ambiente servidor separado do terminal do Codespaces.

## ✅ Soluções Disponíveis

### Opção 1: Usar APIs diretamente (Recomendado para Web)

Ao invés de depender dos MCPs, posso acessar seus serviços diretamente através das APIs:

#### Para Supabase:
```bash
# Instale o Supabase CLI no Codespace
npm install -g supabase

# Ou use a API REST diretamente
```

Você pode me fornecer comandos como:
> "Use a API REST do Supabase para listar as tabelas"

E eu vou usar curl ou scripts para acessar diretamente.

#### Para n8n:
```bash
# Posso usar a API do n8n diretamente
curl -H "X-N8N-API-KEY: sua_key" https://automate-n8n.lhwtdz.easypanel.host/api/v1/workflows
```

### Opção 2: Configuração hardcoded (APENAS para dev/teste)

⚠️ **NÃO recomendado para produção**

Edite o `.mcp.json` com valores diretos:

```json
{
  "mcpServers": {
    "supabase": {
      "command": "npx",
      "args": ["-y", "@supabase/mcp-server-supabase"],
      "env": {
        "SUPABASE_URL": "https://ytuudnmxmhpuhnfhikkc.supabase.co",
        "SUPABASE_SERVICE_ROLE_KEY": "sua_key_aqui"
      }
    }
  }
}
```

🚨 **NUNCA faça commit deste arquivo com credenciais reais!**

### Opção 3: Claude Code CLI (Melhor suporte MCP)

Se você instalar o Claude Code CLI localmente na sua máquina:

```bash
# Na sua máquina local (não no Codespaces)
npm install -g @anthropic-ai/claude-code

# Configure as variáveis de ambiente
export SUPABASE_URL=...
export SUPABASE_SERVICE_ROLE_KEY=...

# Inicie
claude-code
```

Os MCPs funcionarão perfeitamente porque terão acesso às variáveis de ambiente locais.

### Opção 4: Wrapper Script (Solução híbrida)

Crie um script que carrega as variáveis do Codespaces:

```bash
#!/bin/bash
# load_mcp_env.sh

# Carrega as secrets do Codespaces
export N8N_API_URL="${N8N_API_URL}"
export N8N_API_KEY="${N8N_API_KEY}"
export SUPABASE_URL="${SUPABASE_URL}"
export SUPABASE_SERVICE_ROLE_KEY="${SUPABASE_SERVICE_ROLE_KEY}"

# Inicia o servidor MCP com as variáveis
echo "MCPs configurados com sucesso!"
```

## 🔄 Alternativa Imediata: APIs REST

**Posso ajudá-lo AGORA** sem MCPs! Me diga o que precisa e vou:

### Para Supabase:
- Usar a API REST do Supabase diretamente
- Instalar e usar o Supabase CLI
- Conectar via PostgreSQL diretamente

### Para n8n:
- Usar a API REST do n8n
- Criar/editar workflows via API
- Consultar nós disponíveis

## 📝 Exemplo Prático - Listar Tabelas Supabase AGORA

Execute isto no seu terminal Codespaces:

```bash
# Usando curl com a API REST
curl "https://ytuudnmxmhpuhnfhikkc.supabase.co/rest/v1/" \
  -H "apikey: sua_anon_key" \
  -H "Authorization: Bearer sua_anon_key"

# Ou instale o Supabase CLI
npm install -g supabase
supabase login
supabase link --project-ref ytuudnmxmhpuhnfhikkc
supabase db remote commit
```

Ou então, **me passe a anon_key** (que é segura para compartilhar) e eu faço as consultas através da API REST!

## 🎯 Qual caminho você prefere?

1. **API REST direta** (funciona agora, sem MCPs)
2. **Instalar Claude Code CLI localmente** (melhor experiência MCP)
3. **Hardcode temporário no .mcp.json** (apenas para teste rápido)
4. **Script wrapper** (solução híbrida)

Me diga qual prefere e vou ajudar a configurar!
