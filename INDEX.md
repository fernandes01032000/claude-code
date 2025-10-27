# 📚 Índice Geral - Navegação Rápida

## 🚀 Começar AGORA

| Quero... | Use isto... |
|----------|-------------|
| **Teste rápido (30 seg)** | `./run-demo.sh` |
| **Ver dados do SANDRA visualmente** | `sandra_dashboard_bootstrap.html` |
| **Testar meu LocalTunnel** | `python3 test-api-client.py https://sua-url.loca.lt` |
| **Coletar dados do SANDRA (console)** | `sandra_api_scanner.js` no navegador |
| **Automação Python do SANDRA** | `sandra_api_scanner.py` |

---

## 📖 Documentação Completa

### Guias Principais
- **[GUIA_COMPLETO.md](GUIA_COMPLETO.md)** ⭐ **← LEIA ESTE PRIMEIRO!**
  - Explicação completa de TODOS os arquivos
  - Quando usar cada um
  - Fluxos de trabalho
  - FAQ completo

### Sistema SANDRA (Produção)
- **[SANDRA_SCANNER_README.md](SANDRA_SCANNER_README.md)** - Documentação completa do scanner
- **[QUICK_START.md](QUICK_START.md)** - Início rápido para o SANDRA

### Sistema de Testes (Desenvolvimento)
- **[TEST_SERVER_README.md](TEST_SERVER_README.md)** - Servidor de testes mock
- **[LOCALTUNNEL_GUIDE.md](LOCALTUNNEL_GUIDE.md)** - Como usar LocalTunnel
- **[EXEMPLO_PRATICO.md](EXEMPLO_PRATICO.md)** - Exemplos práticos de uso

---

## 🔵 Arquivos do Sistema SANDRA

### Scripts para Navegador
```javascript
sandra_api_scanner.js          // Console do navegador (F12)
extrair_cookies.js             // Extrai cookies para usar no Python
```

### Scripts Python
```python
sandra_api_scanner.py          // Scanner via terminal (requer cookies)
```

### Scripts Bash
```bash
setup_sandra_scanner.sh        // Configuração automática
```

### Interface Visual
```html
sandra_dashboard_bootstrap.html // Dashboard visual completo
```

---

## 🟢 Arquivos do Sistema de Testes

### Servidor Mock
```javascript
test-server.js                 // Servidor HTTP com APIs fake
```

### Cliente de Testes
```python
test-api-client.py             // Cliente universal para testar APIs
```

### Automação
```bash
run-demo.sh                    // Demo automática completa
```

---

## 📁 Estrutura do Projeto

```
/home/user/claude-code/
│
├── 📘 DOCUMENTAÇÃO
│   ├── INDEX.md                       ← Você está aqui!
│   ├── GUIA_COMPLETO.md               ← Leia este!
│   ├── SANDRA_SCANNER_README.md
│   ├── TEST_SERVER_README.md
│   ├── LOCALTUNNEL_GUIDE.md
│   ├── QUICK_START.md
│   └── EXEMPLO_PRATICO.md
│
├── 🔵 SISTEMA SANDRA
│   ├── sandra_api_scanner.js
│   ├── sandra_api_scanner.py
│   ├── sandra_dashboard_bootstrap.html
│   ├── extrair_cookies.js
│   └── setup_sandra_scanner.sh
│
├── 🟢 SISTEMA TESTES
│   ├── test-server.js
│   ├── test-api-client.py
│   └── run-demo.sh
│
└── 📊 RESULTADOS (gerados)
    ├── test_results.json
    └── sandra_resultados.json
```

---

## 🎯 Casos de Uso Rápidos

### 1. Coleta de Dados do SANDRA

#### Método Visual (Recomendado)
```bash
# 1. Faça login no SANDRA no navegador
# 2. Abra o dashboard
firefox sandra_dashboard_bootstrap.html
```

#### Método Console
```javascript
// 1. Abra https://sandra.hgumba.eb.mil.br
// 2. Faça login
// 3. F12 → Console
// 4. Cole o conteúdo de sandra_api_scanner.js
// 5. Enter
```

#### Método Terminal (Requer Configuração)
```bash
# 1. Configure cookies (veja QUICK_START.md)
python3 sandra_api_scanner.py
```

---

### 2. Testes Locais (Desenvolvimento)

#### Demo Automática
```bash
./run-demo.sh
```

#### Manual
```bash
# Terminal 1
node test-server.js

# Terminal 2
python3 test-api-client.py http://localhost:3000
```

---

### 3. Testes com LocalTunnel (Seu Caso!)

```bash
# Terminal 1: Seu servidor
node test-server.js
# OU node /tmp/test-server.js se você tem outro servidor

# Terminal 2: LocalTunnel
npx localtunnel --port 3000
# Anote a URL: https://flat-paths-cheat.loca.lt

# Terminal 3: Testes
cd /home/user/claude-code
python3 test-api-client.py https://flat-paths-cheat.loca.lt
```

---

## 🔍 Como Encontrar o que Preciso?

### Preciso de...

**Instruções passo a passo do SANDRA**
→ `QUICK_START.md`

**Entender TUDO sobre os arquivos**
→ `GUIA_COMPLETO.md` ⭐

**Configurar servidor de testes**
→ `TEST_SERVER_README.md`

**Usar LocalTunnel**
→ `LOCALTUNNEL_GUIDE.md`

**Exemplos práticos**
→ `EXEMPLO_PRATICO.md`

**Troubleshooting do SANDRA**
→ `SANDRA_SCANNER_README.md`

---

## 💻 Comandos Mais Usados

```bash
# Demo rápida
./run-demo.sh

# Testar LocalTunnel
python3 test-api-client.py https://sua-url.loca.lt

# Iniciar servidor de testes
node test-server.js

# Scanner do SANDRA (terminal)
python3 sandra_api_scanner.py

# Configurar ambiente
./setup_sandra_scanner.sh

# Ver relatório JSON
cat test_results.json | python3 -m json.tool
```

---

## 🌟 Top 3 - Mais Úteis

### 🥇 Para Visualização
**sandra_dashboard_bootstrap.html**
- Interface gráfica completa
- Atualização em tempo real
- Métricas e gráficos

### 🥈 Para Testes
**test-api-client.py**
- Funciona com qualquer API
- Output colorido
- Relatórios JSON

### 🥉 Para Demo
**run-demo.sh**
- Tudo automático
- Sem configuração
- Resultados em segundos

---

## 📞 Precisa de Ajuda?

1. **Leia primeiro:** [GUIA_COMPLETO.md](GUIA_COMPLETO.md)
2. **FAQ:** Cada README tem seção de troubleshooting
3. **Teste básico:** `./run-demo.sh` para ver se tudo funciona

---

## 🔄 Atualizações

- **27/10/2025:** Criação inicial com todos os sistemas
- Scripts testados e funcionais
- Documentação completa

---

## 📊 Comparação Rápida

| Característica | SANDRA | Testes |
|----------------|--------|--------|
| Autenticação | ✅ Necessária | ❌ Não |
| Dados Reais | ✅ Sim | ❌ Mock |
| Visual | ⭐⭐⭐⭐⭐ Dashboard | ⭐⭐⭐ Terminal |
| Configuração | ⚙️ Média | ✅ Simples |
| Uso | Produção | Desenvolvimento |

---

## 🎓 Ordem de Aprendizado Sugerida

1. **Teste a demo** → `./run-demo.sh`
2. **Entenda o básico** → `GUIA_COMPLETO.md`
3. **Teste o LocalTunnel** → `python3 test-api-client.py https://sua-url`
4. **Explore o dashboard SANDRA** → `sandra_dashboard_bootstrap.html`
5. **Configure automação** → `sandra_api_scanner.py`

---

**🚀 Comece agora:** `./run-demo.sh`

**📖 Dúvidas?** Leia: [GUIA_COMPLETO.md](GUIA_COMPLETO.md)

---

*Última atualização: 27/10/2025*
