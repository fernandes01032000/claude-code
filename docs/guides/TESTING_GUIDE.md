# Guia de Testes - MCP Servers

Agora que você configurou as credenciais via GitHub Codespaces Secrets, os MCP servers devem estar ativos no Claude Code Web!

## ⚠️ Importante: Reinicie o Codespace

Após adicionar as secrets no GitHub, você precisa **reiniciar o Codespace** para que as variáveis sejam carregadas:

1. Feche o Codespace atual
2. Reabra em: https://github.com/codespaces
3. Ou clique no menu "..." → "Restart Codespace"

## 🧪 Como Testar os MCP Servers

Depois de reiniciar, você pode testar perguntando diretamente ao Claude Code (eu!) sobre seus sistemas:

### Teste 1: n8n MCP

Pergunte ao Claude:

```
"Mostre-me quais nós do n8n estão disponíveis para criar um workflow de automação de email"
```

ou

```
"Liste meus workflows existentes no n8n"
```

Se o MCP estiver funcionando, o Claude terá acesso a:
- Documentação de 525+ nós do n8n
- Seus workflows existentes (se configurou a API key)
- Capacidade de criar/editar workflows

### Teste 2: Supabase MCP

Pergunte ao Claude:

```
"Liste as tabelas disponíveis no meu banco de dados Supabase"
```

ou

```
"Mostre-me o schema da base de dados Supabase"
```

Se o MCP estiver funcionando, o Claude terá acesso a:
- Estrutura das tabelas
- Consultas ao banco de dados
- Gerenciamento de configurações
- Tipos TypeScript gerados

### Teste 3: Verificar Status MCP

No Claude Code, você pode verificar quais MCP servers estão ativos digitando:

```
/mcp
```

Isso mostrará o status de todos os servidores configurados.

## 🔍 Troubleshooting

### MCP servers não aparecem?

1. **Verifique se reiniciou o Codespace** após adicionar as secrets
2. **Verifique se as secrets foram adicionadas corretamente:**
   - Vá em: https://github.com/settings/codespaces
   - Confirme que as 4 variáveis estão lá:
     - `N8N_API_URL`
     - `N8N_API_KEY`
     - `SUPABASE_URL`
     - `SUPABASE_SERVICE_ROLE_KEY`

3. **Verifique se o arquivo .mcp.json existe no root:**
   ```bash
   cat .mcp.json
   ```

4. **Teste manualmente se npx funciona:**
   ```bash
   npx -y n8n-mcp --version
   ```

### Erros de autenticação?

**Para n8n:**
- Teste a API manualmente:
  ```bash
  curl -H "X-N8N-API-KEY: sua_api_key" https://automate-n8n.lhwtdz.easypanel.host/api/v1/workflows
  ```

**Para Supabase:**
- Verifique se a URL e a key estão corretas no dashboard Supabase
- Certifique-se de usar a **service_role** key, não a anon key

## 🎯 Exemplos Práticos de Uso

### Criar um workflow n8n

Pergunte ao Claude:

```
"Crie um workflow n8n que:
1. Monitora um webhook
2. Envia os dados para o Supabase
3. Notifica por email quando completo"
```

O Claude usará o n8n MCP para sugerir os nós corretos e criar o workflow.

### Consultar dados do Supabase

Pergunte ao Claude:

```
"Mostre-me os últimos 10 registros da tabela 'users' no Supabase"
```

ou

```
"Crie uma função TypeScript com os tipos do Supabase para buscar usuários ativos"
```

### Combinar ambos

```
"Crie uma automação que:
1. Monitora novos registros na tabela 'leads' do Supabase
2. Cria um workflow n8n para processar cada lead
3. Atualiza o status de volta no Supabase"
```

## 📊 Verificação de Configuração

Execute este checklist no seu terminal:

```bash
# 1. Confirme que está no branch correto
git branch

# 2. Verifique se .mcp.json existe
ls -la .mcp.json

# 3. Veja o conteúdo
cat .mcp.json

# 4. Teste npx (deve baixar e executar)
npx -y n8n-mcp --help 2>&1 | head -5
```

## ✅ Tudo Funcionando?

Se os MCP servers estiverem ativos, você poderá:

- 🔧 **n8n**: Criar workflows complexos com orientação do Claude sobre todos os 525+ nós disponíveis
- 🗄️ **Supabase**: Consultar, inserir e gerenciar dados no banco com segurança de tipos TypeScript
- 🤖 **Combinados**: Criar automações completas que integram dados e workflows

## 🚀 Próximos Passos

Agora que tudo está configurado, experimente pedir ao Claude para:

1. Explorar a documentação dos nós n8n mais úteis
2. Analisar o schema do seu banco Supabase
3. Sugerir automações baseadas nos dados disponíveis
4. Criar workflows que conectam ambos os sistemas

---

💡 **Dica**: Os MCP servers funcionam em segundo plano - você não precisa fazer nada especial além de conversar normalmente com o Claude Code!
