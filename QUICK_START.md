# 🚀 Quick Start - SANDRA API Scanner

## ⚡ 3 Passos Simples

### 1️⃣ Configure o Ambiente

```bash
# Execute o script de configuração
./setup_sandra_scanner.sh
```

### 2️⃣ Extraia os Cookies do Navegador

1. Abra https://sandra.hgumba.eb.mil.br e **faça login**
2. Pressione `F12` → Aba **Console**
3. Cole este código e pressione Enter:

```javascript
// Copie o conteúdo do arquivo: extrair_cookies.js
// Ou use o código abaixo:

(function() {
    const cookies = {
        ci_session: (document.cookie.match(/ci_session=([^;]+)/) || [])[1],
        csrf_cookie_sandra: (document.cookie.match(/csrf_cookie_sandra=([^;]+)/) || [])[1]
    };

    if (!cookies.ci_session || !cookies.csrf_cookie_sandra) {
        console.error("❌ Cookies não encontrados! Você está logado?");
        return;
    }

    const code = `COOKIES = {\n    "ci_session": "${cookies.ci_session}",\n    "csrf_cookie_sandra": "${cookies.csrf_cookie_sandra}"\n}`;

    navigator.clipboard.writeText(code).then(() => {
        console.log("✅ Código copiado! Cole no arquivo sandra_api_scanner.py");
    });

    console.log(code);
})();
```

4. O código Python será **copiado automaticamente**
5. Cole no arquivo `sandra_api_scanner.py` (linha ~24, na seção COOKIES)

### 3️⃣ Execute o Scanner

```bash
python3 sandra_api_scanner.py
```

## 📊 Resultado

O scanner irá:
- ✅ Testar todas as rotas de API
- ✅ Exibir progresso em tempo real
- ✅ Gerar relatório em `sandra_resultados.json`

## 📁 Estrutura dos Arquivos

```
.
├── sandra_api_scanner.py       # Script principal
├── extrair_cookies.js          # Auxiliar para cookies
├── setup_sandra_scanner.sh     # Configuração automática
├── SANDRA_SCANNER_README.md    # Documentação completa
├── QUICK_START.md              # Este arquivo
└── sandra_resultados.json      # Resultado (gerado após execução)
```

## 🔧 Comandos Úteis

```bash
# Verificar se Python está instalado
python3 --version

# Instalar biblioteca necessária
pip3 install requests

# Dar permissão de execução ao script
chmod +x sandra_api_scanner.py

# Executar diretamente
./sandra_api_scanner.py

# Ver resultado
cat sandra_resultados.json | python3 -m json.tool
```

## ❓ Problemas?

### "Token CSRF não configurado"
→ Execute o passo 2 novamente (extrair cookies do navegador)

### "ModuleNotFoundError: No module named 'requests'"
```bash
pip3 install requests
```

### Erro 401/403
→ Seus cookies expiraram. Faça login novamente e extraia novos cookies.

### Dados sensíveis nos resultados?
```bash
# Limpe os dados após o uso
rm sandra_resultados.json
```

## 📚 Documentação Completa

Para mais detalhes, consulte: [SANDRA_SCANNER_README.md](SANDRA_SCANNER_README.md)

---

**Desenvolvido por Manus AI** | 27/10/2025
