# 🌐 Guia LocalTunnel - Expor Servidor Local na Internet

Este guia mostra como expor seu servidor local na internet usando LocalTunnel e testar com o cliente.

---

## 🎯 Cenário

Você tem:
- ✅ Servidor rodando em `http://localhost:3000`
- ✅ LocalTunnel criando túnel público: `https://flat-paths-cheat.loca.lt`

Objetivo: Testar a API através da URL pública

---

## 📋 Passo a Passo

### 1️⃣ Terminal 1 - Inicie o Servidor

```bash
cd /home/user/claude-code
node test-server.js
```

**Saída esperada:**
```
========================================
✅ Servidor rodando em http://localhost:3000
========================================
📋 Endpoints disponíveis:
   - http://localhost:3000/
   - http://localhost:3000/api/status
   - http://localhost:3000/api/pacientes/internados
   ...
========================================
💡 Pressione Ctrl+C para parar
========================================
```

### 2️⃣ Terminal 2 - Crie o Túnel LocalTunnel

```bash
npx localtunnel --port 3000
```

**Saída esperada:**
```
your url is: https://flat-paths-cheat.loca.lt
```

> **Nota:** Sua URL será diferente. Copie a URL fornecida.

### 3️⃣ Terminal 3 - Execute os Testes

```bash
cd /home/user/claude-code
python3 test-api-client.py https://flat-paths-cheat.loca.lt
```

**Substitua `https://flat-paths-cheat.loca.lt` pela sua URL!**

---

## 🚀 Uso Rápido (One-Liner)

Se sua URL do LocalTunnel é `https://flat-paths-cheat.loca.lt`:

```bash
python3 test-api-client.py https://flat-paths-cheat.loca.lt
```

---

## 📊 Exemplo de Resultado

```
================================================================================
🚀 TEST API CLIENT - INICIANDO TESTES
================================================================================
📡 Base URL: https://flat-paths-cheat.loca.lt
🧪 Total de endpoints: 10
🕐 Data/Hora: 27/10/2025 15:45:00
--------------------------------------------------------------------------------

[1/10] Testando /api/status...
✅ [200] /api/status (234ms)
   └─ success=True

[2/10] Testando /api/pacientes/internados...
✅ [200] /api/pacientes/internados (189ms)
   └─ 1 registro(s)

...

================================================================================
📊 RESUMO DOS TESTES
================================================================================

Total de requisições: 10
✅ Sucesso: 10
❌ Falhas: 0
📈 Taxa de sucesso: 100.0%

✅ Relatório salvo em: test_results.json
```

---

## 🧪 Testando Endpoints Específicos

Você pode testar endpoints manualmente com `curl`:

```bash
# Status do servidor
curl https://flat-paths-cheat.loca.lt/api/status

# Pacientes internados
curl https://flat-paths-cheat.loca.lt/api/pacientes/internados

# Todos os pacientes
curl https://flat-paths-cheat.loca.lt/api/pacientes/todos

# Formatando JSON
curl https://flat-paths-cheat.loca.lt/api/status | python3 -m json.tool
```

---

## 🔍 Verificando o Túnel

### Ver logs do servidor

No **Terminal 1** (onde o servidor está rodando), você verá:

```
[2025-10-27T15:45:12.123Z] GET /api/status
[2025-10-27T15:45:13.456Z] GET /api/pacientes/internados
[2025-10-27T15:45:14.789Z] GET /api/pacientes/urgencia
```

### Acessar pelo navegador

Abra no navegador: `https://flat-paths-cheat.loca.lt`

Você verá a página HTML com todos os endpoints disponíveis!

---

## ⚠️ Primeira Vez com LocalTunnel?

Na primeira vez que você acessar a URL do LocalTunnel, pode aparecer uma página pedindo para autorizar o IP.

**Solução:**
1. Clique no link fornecido
2. Clique em "Continue"
3. Tente novamente

Alternativamente, use o navegador para acessar a URL primeiro, depois execute os testes.

---

## 🔒 Compartilhando a URL

A URL do LocalTunnel é **temporária** e **pública**. Qualquer pessoa com a URL pode acessar.

### ✅ Boas práticas:
- Use apenas para testes
- Não exponha dados sensíveis
- Feche o túnel quando não estiver usando (Ctrl+C)
- Não compartilhe a URL publicamente

### ❌ Evite:
- Usar em produção
- Expor APIs com dados reais de pacientes
- Deixar o túnel aberto 24/7

---

## 🛠️ Problemas Comuns

### "Could not locate your LocalTunnel host"

**Causa:** LocalTunnel não consegue conectar ao servidor.

**Solução:**
```bash
# Verifique se o servidor está rodando
curl http://localhost:3000/api/status

# Se não responder, reinicie o servidor
node test-server.js
```

### Timeout ao testar

**Causa:** LocalTunnel adiciona latência (~200-500ms).

**Solução:** Ajuste o timeout no cliente:

```python
# Em test-api-client.py, linha ~137
response = requests.get(
    url,
    headers=self.headers,
    timeout=10,  # Aumente para 10 segundos
    allow_redirects=True
)
```

### "Connection reset by peer"

**Causa:** Túnel foi fechado ou expirou.

**Solução:** Reinicie o LocalTunnel:
```bash
# Ctrl+C no terminal do localtunnel
# Depois execute novamente:
npx localtunnel --port 3000
```

---

## 🎓 Exemplos Avançados

### Testar com URL Customizada

```bash
npx localtunnel --port 3000 --subdomain meu-teste
# URL: https://meu-teste.loca.lt
```

**Nota:** Subdomínios customizados podem não estar disponíveis.

### Usar com Scripts

```bash
#!/bin/bash
# Inicia servidor
node test-server.js &
SERVER_PID=$!

# Inicia túnel
npx localtunnel --port 3000 &
TUNNEL_PID=$!

# Aguarda túnel iniciar
sleep 3

# Captura URL do túnel
TUNNEL_URL=$(curl -s http://localhost:4040/api/tunnels | python3 -c "import sys, json; print(json.load(sys.stdin)['tunnels'][0]['public_url'])")

# Executa testes
python3 test-api-client.py $TUNNEL_URL

# Cleanup
kill $SERVER_PID $TUNNEL_PID
```

### Integração com SANDRA Scanner

Você pode adaptar o `sandra_api_scanner.py` para usar com LocalTunnel:

```python
# No sandra_api_scanner.py, altere:
BASE_URL = "https://flat-paths-cheat.loca.lt"

# Execute normalmente
python3 sandra_api_scanner.py
```

---

## 📚 Alternativas ao LocalTunnel

Se o LocalTunnel não funcionar, tente:

### ngrok
```bash
# Instalar
npm install -g ngrok

# Criar túnel
ngrok http 3000
```

### serveo
```bash
ssh -R 80:localhost:3000 serveo.net
```

### Cloudflare Tunnel
```bash
cloudflared tunnel --url http://localhost:3000
```

---

## ✅ Checklist de Teste

- [ ] Servidor rodando em `localhost:3000`
- [ ] LocalTunnel ativo com URL pública
- [ ] URL pública acessível no navegador
- [ ] Cliente executado com sucesso
- [ ] Relatório JSON gerado
- [ ] Taxa de sucesso > 80%

---

## 📞 Suporte

**Problemas com:**
- LocalTunnel: https://github.com/localtunnel/localtunnel/issues
- Test Server: Consulte `TEST_SERVER_README.md`
- API Client: Consulte `TEST_SERVER_README.md`

---

**Desenvolvido por Manus AI** | 27/10/2025
