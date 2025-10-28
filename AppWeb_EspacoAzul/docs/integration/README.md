# Guia de Integração

Este diretório contém documentação sobre integrações com serviços externos.

## Estrutura de Documentação de Integração

Cada integração deve ter seu próprio arquivo com:

1. **Visão Geral** - O que é e para que serve
2. **Autenticação** - Como autenticar
3. **Configuração** - Variáveis de ambiente e configurações necessárias
4. **Endpoints** - Principais endpoints utilizados
5. **Exemplos de Uso** - Código de exemplo
6. **Tratamento de Erros** - Erros comuns e como tratá-los
7. **Rate Limits** - Limites de requisições
8. **Webhooks** - Se aplicável

## Template de Documentação

```markdown
# Integração com [Nome do Serviço]

## Visão Geral
Descrição do serviço e propósito da integração.

## Autenticação
- Tipo: API Key / OAuth2 / JWT
- Onde obter: Link para painel
- Como configurar: Passos

## Configuração

### Variáveis de Ambiente
\`\`\`env
SERVICE_API_KEY=your_key_here
SERVICE_BASE_URL=https://api.service.com
SERVICE_TIMEOUT=5000
\`\`\`

### Exemplo de Config
\`\`\`json
{
  "service": {
    "apiKey": process.env.SERVICE_API_KEY,
    "baseUrl": process.env.SERVICE_BASE_URL,
    "timeout": 5000
  }
}
\`\`\`

## Endpoints Principais

### GET /resource
Descrição do endpoint

**Request:**
\`\`\`json
{
  "param": "value"
}
\`\`\`

**Response:**
\`\`\`json
{
  "data": "value"
}
\`\`\`

## Código de Exemplo

\`\`\`javascript
const client = new ServiceClient({
  apiKey: process.env.SERVICE_API_KEY
});

const result = await client.getResource({ id: '123' });
\`\`\`

## Tratamento de Erros

| Código | Descrição | Ação |
|--------|-----------|------|
| 401 | Não autorizado | Verificar API key |
| 429 | Rate limit | Implementar retry |
| 500 | Erro servidor | Log e retry |

## Rate Limits
- Requisições por minuto: 100
- Requisições por hora: 5000

## Webhooks

### Configuração
1. URL: `https://seu-app.com/webhooks/service`
2. Secret: Armazenar em `.env`
3. Validar assinatura

### Eventos
- `resource.created`
- `resource.updated`
- `resource.deleted`
\`\`\`

## Exemplos

Veja `integration-example.md` para um exemplo completo.
