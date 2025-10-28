# Documentação da API

Esta pasta contém a documentação completa da API do projeto.

## Estrutura

```
api/
├── README.md              # Este arquivo
├── authentication.md      # Autenticação e autorização
├── endpoints/            # Documentação de endpoints
│   ├── users.md
│   ├── products.md
│   └── orders.md
├── errors.md             # Códigos de erro e tratamento
├── rate-limiting.md      # Políticas de rate limiting
└── changelog.md          # Histórico de mudanças da API
```

## Padrões da API

### Base URL
- Desenvolvimento: `http://localhost:3000/api/v1`
- Staging: `https://staging-api.example.com/v1`
- Produção: `https://api.example.com/v1`

### Formato de Requisição/Resposta
- Content-Type: `application/json`
- Charset: UTF-8

### Autenticação
Todas as requisições (exceto endpoints públicos) requerem autenticação via:
- Bearer Token no header: `Authorization: Bearer <token>`
- API Key no header: `X-API-Key: <key>`

### Versionamento
A API usa versionamento via URL: `/api/v1/`, `/api/v2/`

### Rate Limiting
- 100 requisições por minuto por IP
- 1000 requisições por hora por usuário autenticado

### Paginação
```json
{
  "data": [...],
  "pagination": {
    "total": 100,
    "page": 1,
    "per_page": 20,
    "total_pages": 5
  }
}
```

### Formato de Erro
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid request parameters",
    "details": [
      {
        "field": "email",
        "message": "Email is required"
      }
    ]
  }
}
```

### Códigos de Status HTTP

| Código | Descrição |
|--------|-----------|
| 200 | OK - Requisição bem sucedida |
| 201 | Created - Recurso criado |
| 204 | No Content - Sucesso sem retorno |
| 400 | Bad Request - Requisição inválida |
| 401 | Unauthorized - Não autenticado |
| 403 | Forbidden - Sem permissão |
| 404 | Not Found - Recurso não encontrado |
| 429 | Too Many Requests - Rate limit |
| 500 | Internal Server Error - Erro do servidor |

## Exemplo de Endpoint

### GET /users/:id

Retorna informações de um usuário específico.

**Autenticação:** Requerida

**Parâmetros:**
- `id` (path, required): ID do usuário

**Query Parameters:**
- `include` (optional): Campos adicionais (ex: `profile,preferences`)

**Request:**
```bash
curl -X GET \
  https://api.example.com/v1/users/123 \
  -H 'Authorization: Bearer <token>' \
  -H 'Content-Type: application/json'
```

**Response (200):**
```json
{
  "id": 123,
  "email": "user@example.com",
  "name": "João Silva",
  "created_at": "2024-01-15T10:30:00Z",
  "updated_at": "2024-01-20T14:45:00Z"
}
```

**Erros:**
- `401`: Token inválido ou expirado
- `403`: Sem permissão para acessar este usuário
- `404`: Usuário não encontrado

## SDKs e Clientes

### JavaScript/Node.js
```javascript
const ApiClient = require('./sdk/api-client');

const client = new ApiClient({
  apiKey: process.env.API_KEY,
  baseUrl: 'https://api.example.com/v1'
});

const user = await client.users.get(123);
```

### Python
```python
from sdk import ApiClient

client = ApiClient(
    api_key=os.environ['API_KEY'],
    base_url='https://api.example.com/v1'
)

user = client.users.get(123)
```

## Webhooks

A API pode enviar webhooks para notificar eventos importantes.

Ver `webhooks.md` para detalhes.

## Changelog

Ver `changelog.md` para histórico de mudanças.

## Suporte

- Email: api-support@example.com
- Status: https://status.example.com
- Documentação interativa: https://api.example.com/docs
