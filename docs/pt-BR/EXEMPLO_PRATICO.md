# 🎯 Exemplo Prático - Uso Imediato

## Cenário: Você tem um servidor local e quer testá-lo

---

## ⚡ Opção 1: DEMO AUTOMÁTICA (Mais Fácil)

```bash
./run-demo.sh
```

**Pronto! O script faz tudo sozinho:**
- ✅ Verifica dependências
- ✅ Inicia o servidor
- ✅ Executa os testes
- ✅ Gera relatório
- ✅ Encerra o servidor

---

## 🚀 Opção 2: MANUAL (Controle Total)

### Terminal 1 - Servidor
```bash
node test-server.js
```

### Terminal 2 - Testes
```bash
python3 test-api-client.py http://localhost:3000
```

**Veja os resultados:**
```bash
cat test_results.json | python3 -m json.tool
```

---

## 🌐 Opção 3: COM LOCALTUNNEL (Público)

Como você já tem o túnel funcionando:

### Seu cenário atual:
```
Terminal 1: node /tmp/test-server.js
✅ Servidor em http://localhost:3000

Terminal 2: npx localtunnel --port 3000
✅ URL pública: https://flat-paths-cheat.loca.lt
```

### Agora no Terminal 3:
```bash
cd /home/user/claude-code
python3 test-api-client.py https://flat-paths-cheat.loca.lt
```

---

## 📊 Resultado Esperado

```
================================================================================
🚀 TEST API CLIENT - INICIANDO TESTES
================================================================================
📡 Base URL: https://flat-paths-cheat.loca.lt
🧪 Total de endpoints: 10
🕐 Data/Hora: 27/10/2025 15:50:00
--------------------------------------------------------------------------------

[1/10] Testando /api/status...
✅ [200] /api/status (234ms)
   └─ success=True

[2/10] Testando /api/pacientes/internados...
✅ [200] /api/pacientes/internados (189ms)
   └─ 1 registro(s)

[3/10] Testando /api/pacientes/urgencia...
✅ [200] /api/pacientes/urgencia (201ms)
   └─ 1 registro(s)

[4/10] Testando /api/pacientes/acolhimento...
✅ [200] /api/pacientes/acolhimento (167ms)
   └─ 1 registro(s)

[5/10] Testando /api/pacientes/todos...
✅ [200] /api/pacientes/todos (145ms)
   └─ 3 registro(s)

[6/10] Testando /api/especialistas...
✅ [200] /api/especialistas (312ms)
   └─ 3 registro(s)

[7/10] Testando /api/especialidades...
✅ [200] /api/especialidades (278ms)
   └─ 3 registro(s)

[8/10] Testando /api/slow...
✅ [200] /api/slow (2045ms)
   └─ success=True

[9/10] Testando /api/error...
❌ [500] /api/error (32ms)
   └─ success=False

[10/10] Testando /api/notfound...
⚠️ [404] /api/notfound (28ms)
   └─ success=False

--------------------------------------------------------------------------------
🏁 TESTES CONCLUÍDOS!
--------------------------------------------------------------------------------

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
/api/status                              200             234ms      JSON
/api/pacientes/internados                200             189ms      JSON
/api/pacientes/urgencia                  200             201ms      JSON
/api/pacientes/acolhimento               200             167ms      JSON
/api/pacientes/todos                     200             145ms      JSON
/api/especialistas                       200             312ms      JSON
/api/especialidades                      200             278ms      JSON
/api/slow                                200             2045ms     JSON
/api/error                               500             32ms       JSON
/api/notfound                            404             28ms       JSON

✅ Relatório salvo em: test_results.json

================================================================================
✨ TESTES FINALIZADOS COM SUCESSO!
================================================================================
```

---

## 🎯 Use Cases

### 1. Testar API do SANDRA (real)

Se você tiver acesso e cookies configurados:

```bash
python3 sandra_api_scanner.py
```

### 2. Testar servidor local de desenvolvimento

```bash
python3 test-api-client.py http://localhost:3000
```

### 3. Testar API pública qualquer

```bash
python3 test-api-client.py https://jsonplaceholder.typicode.com
python3 test-api-client.py https://api.github.com
```

### 4. Testar via LocalTunnel

```bash
# Substitua pela sua URL do LocalTunnel
python3 test-api-client.py https://flat-paths-cheat.loca.lt
```

---

## 🧪 Teste Rápido - 30 Segundos

```bash
# 1. Clone ou entre no diretório
cd /home/user/claude-code

# 2. Execute a demo
./run-demo.sh

# 3. Veja o resultado
cat test_results.json | python3 -m json.tool | head -20
```

---

## 📱 Testando Pelo Navegador

Abra no navegador:

**Local:**
- http://localhost:3000

**Público (LocalTunnel):**
- https://flat-paths-cheat.loca.lt

Você verá uma página HTML bonita com todos os endpoints e links para testar!

---

## 🔍 Inspeção Manual (curl)

```bash
# Status
curl http://localhost:3000/api/status | python3 -m json.tool

# Pacientes
curl http://localhost:3000/api/pacientes/todos | python3 -m json.tool

# Via LocalTunnel
curl https://flat-paths-cheat.loca.lt/api/status | python3 -m json.tool
```

---

## 📁 Estrutura de Arquivos

```
/home/user/claude-code/
├── sandra_api_scanner.py       # Scanner do SANDRA (cookies)
├── extrair_cookies.js          # Extrai cookies do navegador
├── test-server.js              # Servidor de testes mock
├── test-api-client.py          # Cliente universal de testes
├── run-demo.sh                 # Demo automática
├── SANDRA_SCANNER_README.md    # Doc do SANDRA scanner
├── TEST_SERVER_README.md       # Doc do test server
├── LOCALTUNNEL_GUIDE.md        # Guia do LocalTunnel
├── QUICK_START.md              # Início rápido SANDRA
└── EXEMPLO_PRATICO.md          # Este arquivo
```

---

## ❓ FAQ Rápido

**Q: Qual a diferença entre os scanners?**

- `sandra_api_scanner.py` = Para sistema SANDRA real (requer cookies)
- `test-api-client.py` = Universal, testa qualquer API

**Q: Preciso de autenticação?**

- SANDRA: Sim, precisa cookies
- Test Server: Não, é público

**Q: Posso testar APIs de terceiros?**

- Sim! Use `test-api-client.py` com qualquer URL

**Q: O LocalTunnel é seguro?**

- Para testes, sim. Para produção, não!

---

## 🎓 Próximos Passos

1. ✅ Experimente a demo: `./run-demo.sh`
2. ✅ Teste com seu servidor: `python3 test-api-client.py [URL]`
3. ✅ Personalize endpoints no `test-server.js`
4. ✅ Adapte o cliente para suas necessidades
5. ✅ Leia a documentação completa: `TEST_SERVER_README.md`

---

## 💡 Dicas

- Use `Ctrl+C` para parar servidor ou testes
- Logs do servidor ficam visíveis no terminal
- Relatório JSON sempre é gerado
- Formato colorido ajuda a identificar problemas rapidamente

---

**Comece agora:** `./run-demo.sh` 🚀

---

**Desenvolvido por Manus AI** | 27/10/2025
