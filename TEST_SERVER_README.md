# 🧪 Test Server & API Client

Sistema completo de servidor de testes e cliente para testar APIs com medição de performance.

## 📁 Arquivos

- **`test-server.js`** - Servidor HTTP com APIs de teste
- **`test-api-client.py`** - Cliente Python para testar APIs
- **`TEST_SERVER_README.md`** - Esta documentação

---

## 🚀 Como Usar

### Opção 1: Teste Local (Simples)

**Terminal 1 - Inicie o servidor:**
```bash
node test-server.js
```

**Terminal 2 - Execute os testes:**
```bash
python3 test-api-client.py http://localhost:3000
```

### Opção 2: Teste com LocalTunnel (Público)

**Terminal 1 - Inicie o servidor:**
```bash
node test-server.js
```

**Terminal 2 - Crie o túnel:**
```bash
npx localtunnel --port 3000
# Sua URL: https://seu-endereco-aqui.loca.lt
```

**Terminal 3 - Execute os testes com a URL pública:**
```bash
python3 test-api-client.py https://seu-endereco-aqui.loca.lt
```

---

## 📋 Endpoints do Servidor

O servidor de teste possui os seguintes endpoints:

| Endpoint | Descrição |
|----------|-----------|
| `GET /` | Página HTML com documentação |
| `GET /api/status` | Status do servidor |
| `GET /api/pacientes/internados` | Lista de pacientes internados |
| `GET /api/pacientes/urgencia` | Pacientes em urgência |
| `GET /api/pacientes/acolhimento` | Pacientes em acolhimento |
| `GET /api/pacientes/todos` | Todos os pacientes |
| `GET /api/especialistas` | Lista de especialistas |
| `GET /api/especialidades` | Lista de especialidades |
| `GET /api/slow` | Rota lenta (2s) para testar timeouts |
| `GET /api/error` | Retorna erro 500 |
| `GET /api/notfound` | Retorna 404 |

---

## 🧪 Cliente de Testes (test-api-client.py)

### Uso Básico

```bash
# Testar servidor local
python3 test-api-client.py http://localhost:3000

# Testar servidor remoto
python3 test-api-client.py https://api.exemplo.com

# Modo interativo (pergunta a URL)
python3 test-api-client.py
```

### O que o cliente faz?

- ✅ Testa todos os endpoints automaticamente
- ✅ Mede tempo de resposta (em milissegundos)
- ✅ Valida status HTTP (200, 404, 500, etc)
- ✅ Identifica tipo de resposta (JSON, HTML, etc)
- ✅ Conta registros retornados
- ✅ Exibe progresso em tempo real
- ✅ Gera relatório em JSON
- ✅ Mostra estatísticas de sucesso/falha

### Exemplo de Saída

```
================================================================================
🚀 TEST API CLIENT - INICIANDO TESTES
================================================================================
📡 Base URL: http://localhost:3000
🧪 Total de endpoints: 10
🕐 Data/Hora: 27/10/2025 15:30:00
--------------------------------------------------------------------------------

[1/10] Testando /api/status...
✅ [200] /api/status (45ms)
   └─ success=True

[2/10] Testando /api/pacientes/internados...
✅ [200] /api/pacientes/internados (123ms)
   └─ 1 registro(s)

[3/10] Testando /api/pacientes/urgencia...
✅ [200] /api/pacientes/urgencia (98ms)
   └─ 1 registro(s)

...

================================================================================
📊 RESUMO DOS TESTES
================================================================================

Total de requisições: 10
✅ Sucesso: 8
❌ Falhas: 2
📈 Taxa de sucesso: 80.0%

--------------------------------------------------------------------------------
Endpoint                                 Status          Tempo      Tipo
--------------------------------------------------------------------------------
/api/status                              200             45ms       JSON
/api/pacientes/internados                200             123ms      JSON
/api/error                               500             32ms       JSON
/api/notfound                            404             28ms       JSON
...

✅ Relatório salvo em: test_results.json
```

---

## 📊 Arquivo de Relatório (test_results.json)

O cliente gera um arquivo JSON com:

```json
{
  "metadata": {
    "base_url": "http://localhost:3000",
    "timestamp": "2025-10-27T15:30:00.123456",
    "total_requests": 10,
    "successful_requests": 8,
    "failed_requests": 2,
    "success_rate": "80.0%"
  },
  "results": {
    "/api/status": {
      "status_code": 200,
      "tempo_ms": 45,
      "tipo": "JSON",
      "resumo": "success=True",
      "descricao": "Status do servidor",
      "exemplo_dados": {
        "success": true,
        "status": "online",
        "timestamp": "2025-10-27T15:30:00.123Z",
        "version": "1.0.0"
      }
    }
  }
}
```

---

## 🔧 Personalização

### Adicionar Novos Endpoints no Servidor

Edite `test-server.js`:

```javascript
const routes = {
    '/api/seu-endpoint': (req, res) => {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({
            success: true,
            data: { /* seus dados */ }
        }));
    }
};
```

### Adicionar Novos Testes no Cliente

Edite `test-api-client.py`:

```python
self.endpoints = [
    {
        "path": "/api/seu-endpoint",
        "method": "GET",
        "description": "Descrição do endpoint"
    }
]
```

---

## 🌐 Testando APIs Externas

Você pode usar o cliente para testar **qualquer API**:

```bash
# GitHub API
python3 test-api-client.py https://api.github.com

# JSONPlaceholder (API de teste pública)
python3 test-api-client.py https://jsonplaceholder.typicode.com

# Sua API no SANDRA
python3 test-api-client.py https://sandra.hgumba.eb.mil.br
```

**Nota:** Para APIs que requerem autenticação, você precisará modificar o cliente para incluir headers de autenticação.

---

## 📝 Casos de Uso

### 1. Testar Performance

Identifique endpoints lentos:

```bash
python3 test-api-client.py http://localhost:3000
# Veja quais endpoints demoram mais de 500ms
```

### 2. Verificar Disponibilidade

Check se a API está online:

```bash
python3 test-api-client.py https://sua-api.com
# Veja a taxa de sucesso
```

### 3. Documentar APIs

Gere documentação automática:

```bash
python3 test-api-client.py http://localhost:3000
# Use o test_results.json para documentação
```

### 4. Testes de Integração

Use em pipelines CI/CD:

```bash
#!/bin/bash
# Inicia servidor
node test-server.js &
SERVER_PID=$!

# Aguarda servidor iniciar
sleep 2

# Executa testes
python3 test-api-client.py http://localhost:3000

# Captura código de saída
EXIT_CODE=$?

# Mata servidor
kill $SERVER_PID

exit $EXIT_CODE
```

---

## ⚡ Comandos Rápidos

```bash
# Instalar Node.js (se necessário)
sudo apt install nodejs npm  # Ubuntu/Debian
brew install node             # macOS

# Instalar dependências Python
pip3 install requests

# Iniciar servidor
node test-server.js

# Testar localmente
python3 test-api-client.py http://localhost:3000

# Criar túnel público
npx localtunnel --port 3000

# Testar via túnel
python3 test-api-client.py https://your-url.loca.lt

# Ver relatório JSON formatado
cat test_results.json | python3 -m json.tool
```

---

## 🐛 Problemas Comuns

### "Porta 3000 já em uso"

```bash
# Encontre o processo
lsof -i :3000

# Mate o processo
kill -9 PID
```

### "ModuleNotFoundError: No module named 'requests'"

```bash
pip3 install requests
```

### "Erro de conexão" ao testar

- Verifique se o servidor está rodando
- Verifique se a URL está correta
- Teste primeiro: `curl http://localhost:3000/api/status`

### LocalTunnel pede senha

LocalTunnel às vezes pede para clicar em um link e autorizar. Siga as instruções no terminal.

---

## 📚 Recursos Adicionais

- [Node.js Documentation](https://nodejs.org/docs)
- [Python Requests Library](https://requests.readthedocs.io/)
- [LocalTunnel Documentation](https://theboroer.github.io/localtunnel-www/)

---

**Desenvolvido por Manus AI** | 27/10/2025
