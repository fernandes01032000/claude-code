# 🗺️ Guia Completo - Todos os Arquivos e Como Usá-los

## 📦 Você tem DOIS sistemas diferentes:

---

## 1️⃣ Sistema SANDRA (Produção Real)

### Para usar com o sistema SANDRA real (https://sandra.hgumba.eb.mil.br)

### 📄 Arquivos:

#### `sandra_api_scanner.js` (Console do Navegador)
- **Onde executar:** Console do navegador (F12)
- **Requisito:** Estar logado no SANDRA
- **O que faz:**
  - Extrai token CSRF automaticamente
  - Testa todas as APIs do SANDRA
  - Copia resultados para área de transferência
  - Exibe tabela no console

**Como usar:**
```javascript
1. Abra https://sandra.hgumba.eb.mil.br
2. Faça login
3. Pressione F12 → Console
4. Cole o código de sandra_api_scanner.js
5. Pressione Enter
6. Aguarde os resultados
7. JSON será copiado automaticamente
```

#### `sandra_api_scanner.py` (Terminal)
- **Onde executar:** Terminal do Linux
- **Requisito:** Cookies do navegador configurados
- **O que faz:**
  - Faz requisições via Python
  - Não precisa do navegador aberto
  - Gera arquivo JSON
  - Permite automação

**Como usar:**
```bash
# 1. Configure os cookies (veja QUICK_START.md)
# 2. Execute:
python3 sandra_api_scanner.py
```

#### `sandra_dashboard_bootstrap.html` (Dashboard Visual)
- **Onde executar:** Navegador
- **Requisito:** Estar logado no SANDRA em outra aba
- **O que faz:**
  - Dashboard visual bonito
  - Atualização em tempo real
  - Tabelas filtráveis
  - Exportação CSV
  - Auto-refresh a cada 30s

**Como usar:**
```bash
# Opção 1: Abrir diretamente
firefox sandra_dashboard_bootstrap.html

# Opção 2: Via servidor local
python3 -m http.server 8080
# Acesse: http://localhost:8080/sandra_dashboard_bootstrap.html

# IMPORTANTE: Você precisa estar logado no SANDRA em outra aba!
```

---

## 2️⃣ Sistema de TESTES (Desenvolvimento Local)

### Para testar localmente SEM conexão com SANDRA real

### 📄 Arquivos:

#### `test-server.js` (Servidor Mock)
- **Onde executar:** Terminal
- **Requisito:** Node.js instalado
- **O que faz:**
  - Servidor HTTP local
  - APIs fake para testes
  - Não precisa de autenticação
  - Ideal para desenvolvimento

**Como usar:**
```bash
node test-server.js
# Servidor em: http://localhost:3000
```

#### `test-api-client.py` (Cliente Universal)
- **Onde executar:** Terminal
- **Requisito:** Python 3 + requests
- **O que faz:**
  - Testa qualquer API
  - Funciona com servidor local OU remoto
  - Gera relatório JSON
  - Output colorido

**Como usar:**
```bash
# Local
python3 test-api-client.py http://localhost:3000

# LocalTunnel (seu caso!)
python3 test-api-client.py https://flat-paths-cheat.loca.lt

# SANDRA (se tiver acesso)
python3 test-api-client.py https://sandra.hgumba.eb.mil.br
```

#### `run-demo.sh` (Demo Automática)
- **Onde executar:** Terminal
- **O que faz:**
  - Inicia servidor
  - Executa testes
  - Gera relatório
  - Encerra tudo

**Como usar:**
```bash
./run-demo.sh
```

---

## 🎯 Qual Usar e Quando?

### Cenário 1: Você está logado no SANDRA e quer coletar dados REAIS
```
✅ Use: sandra_api_scanner.js (no console do navegador)
✅ OU: sandra_dashboard_bootstrap.html (visual bonito)
```

### Cenário 2: Você quer automatizar coleta de dados do SANDRA
```
✅ Use: sandra_api_scanner.py (configure cookies primeiro)
```

### Cenário 3: Você quer testar seu próprio servidor local
```
✅ Use: test-server.js + test-api-client.py
```

### Cenário 4: Você tem um servidor com LocalTunnel (SEU CASO!)
```
✅ Terminal 1: node test-server.js (ou seu servidor)
✅ Terminal 2: npx localtunnel --port 3000
✅ Terminal 3: python3 test-api-client.py https://flat-paths-cheat.loca.lt
```

### Cenário 5: Você quer fazer uma demo rápida
```
✅ Use: ./run-demo.sh
```

---

## 🔄 Fluxo de Trabalho Recomendado

### Fase 1: DESENVOLVIMENTO (Testes Locais)
```bash
# Terminal 1
node test-server.js

# Terminal 2
python3 test-api-client.py http://localhost:3000

# Desenvolva e teste suas funcionalidades aqui
```

### Fase 2: TESTES COM LOCALTUNNEL (Compartilhar)
```bash
# Terminal 1
node test-server.js

# Terminal 2
npx localtunnel --port 3000

# Terminal 3
python3 test-api-client.py https://sua-url.loca.lt

# Compartilhe a URL com colegas para testar
```

### Fase 3: PRODUÇÃO (SANDRA Real)
```bash
# Opção A: Console do Navegador
1. Abra SANDRA no navegador
2. F12 → Console
3. Cole sandra_api_scanner.js
4. Copie os resultados

# Opção B: Dashboard Visual
1. Abra sandra_dashboard_bootstrap.html no navegador
2. Certifique-se de estar logado no SANDRA em outra aba
3. Use a interface visual
```

---

## 📊 Comparação dos Arquivos

| Arquivo | Ambiente | Autenticação | Dados | Visual |
|---------|----------|--------------|-------|--------|
| sandra_api_scanner.js | Navegador | Cookie automático | Real | Console |
| sandra_api_scanner.py | Terminal | Cookie manual | Real | Terminal |
| sandra_dashboard_bootstrap.html | Navegador | Cookie automático | Real | Dashboard |
| test-server.js | Terminal | Nenhuma | Fake | Logs |
| test-api-client.py | Terminal | Nenhuma | Qualquer | Terminal |

---

## 🎨 Qual é mais VISUAL?

### Ranking de Visualização:
1. **sandra_dashboard_bootstrap.html** ⭐⭐⭐⭐⭐
   - Interface gráfica completa
   - Gráficos e métricas
   - Tabelas bonitas
   - Filtros e busca

2. **test-api-client.py** ⭐⭐⭐
   - Output colorido no terminal
   - Tabelas formatadas
   - Estatísticas

3. **sandra_api_scanner.js** ⭐⭐⭐
   - console.table() no navegador
   - JSON formatado

4. **test-server.js** ⭐⭐
   - Página HTML simples
   - Lista de endpoints

5. **sandra_api_scanner.py** ⭐⭐
   - Output de terminal
   - Texto formatado

---

## 🚀 Início Rápido para SEU CASO

### Você tem LocalTunnel rodando em https://flat-paths-cheat.loca.lt

**Opção 1: Testar o túnel**
```bash
cd /home/user/claude-code
python3 test-api-client.py https://flat-paths-cheat.loca.lt
```

**Opção 2: Dashboard visual do SANDRA (se tiver acesso)**
```bash
# Abra em outra aba:
firefox https://sandra.hgumba.eb.mil.br
# Faça login

# Depois abra:
firefox ~/Downloads/sandra_dashboard_bootstrap.html
```

**Opção 3: Script do console**
```bash
# 1. Abra o navegador em https://sandra.hgumba.eb.mil.br
# 2. Faça login
# 3. F12 → Console
# 4. Cole o conteúdo de sandra_api_scanner.js
# 5. Enter
```

---

## 📁 Estrutura Organizada

```
/home/user/claude-code/
│
├── 🔵 SISTEMA SANDRA (Produção)
│   ├── sandra_api_scanner.js          # Console do navegador
│   ├── sandra_api_scanner.py          # Terminal (requer cookies)
│   ├── sandra_dashboard_bootstrap.html # Dashboard visual
│   ├── extrair_cookies.js             # Auxiliar para cookies
│   ├── setup_sandra_scanner.sh        # Setup do scanner Python
│   ├── SANDRA_SCANNER_README.md       # Docs do SANDRA
│   └── QUICK_START.md                 # Início rápido SANDRA
│
├── 🟢 SISTEMA TESTES (Desenvolvimento)
│   ├── test-server.js                 # Servidor mock
│   ├── test-api-client.py             # Cliente universal
│   ├── run-demo.sh                    # Demo automática
│   ├── TEST_SERVER_README.md          # Docs do test server
│   ├── LOCALTUNNEL_GUIDE.md           # Guia LocalTunnel
│   └── EXEMPLO_PRATICO.md             # Exemplos práticos
│
└── 📚 DOCUMENTAÇÃO
    ├── GUIA_COMPLETO.md               # Este arquivo
    └── test_results.json              # Resultados (gerado)
```

---

## 💡 Dicas Importantes

1. **sandra_dashboard_bootstrap.html** só funciona se você estiver logado no SANDRA em outra aba do navegador (usa os mesmos cookies)

2. **test-api-client.py** é universal - funciona com QUALQUER servidor

3. **sandra_api_scanner.py** precisa de configuração manual dos cookies

4. **test-server.js** é perfeito para desenvolvimento sem precisar do SANDRA

5. **LocalTunnel** adiciona latência (~200-500ms), normal!

---

## ❓ FAQ

**Q: Qual arquivo devo usar para ver dados do SANDRA agora?**
```
A: sandra_dashboard_bootstrap.html (mais bonito)
   OU sandra_api_scanner.js no console
```

**Q: Como testar meu túnel LocalTunnel?**
```
A: python3 test-api-client.py https://flat-paths-cheat.loca.lt
```

**Q: Posso usar o dashboard com meu servidor local?**
```
A: Não diretamente. O dashboard HTML foi feito para o SANDRA.
   Você precisaria adaptar as URLs e endpoints.
```

**Q: Qual a diferença entre os .js e os .py?**
```
A: .js roda no navegador (console)
   .py roda no terminal (Python)
```

---

## 🎯 Recomendação para VOCÊ

Baseado no seu cenário (LocalTunnel + Servidor Local):

```bash
# 1. Teste seu servidor via LocalTunnel
cd /home/user/claude-code
python3 test-api-client.py https://flat-paths-cheat.loca.lt

# 2. Se quiser ver dados do SANDRA real
firefox sandra_dashboard_bootstrap.html
# (certifique-se de estar logado no SANDRA em outra aba)

# 3. Para desenvolvimento local
./run-demo.sh
```

---

**Precisa de ajuda específica com algum arquivo? Me diga qual!** 🚀
