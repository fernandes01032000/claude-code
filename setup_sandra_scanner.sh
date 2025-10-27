#!/bin/bash
# Script de configuração e verificação do SANDRA API Scanner

echo "========================================================================"
echo "🔧 SANDRA API Scanner - Configuração e Verificação"
echo "========================================================================"
echo

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para imprimir mensagens coloridas
print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
print_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }

# Verifica Python 3
echo "🔍 Verificando Python..."
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
    print_success "Python 3 encontrado: versão $PYTHON_VERSION"
else
    print_error "Python 3 não encontrado!"
    echo
    print_info "Instale o Python 3 com:"
    echo "  Ubuntu/Debian: sudo apt install python3 python3-pip"
    echo "  Fedora/RHEL:   sudo dnf install python3 python3-pip"
    echo "  MacOS:         brew install python3"
    exit 1
fi

echo

# Verifica pip
echo "🔍 Verificando pip..."
if command -v pip3 &> /dev/null; then
    PIP_VERSION=$(pip3 --version 2>&1 | awk '{print $2}')
    print_success "pip3 encontrado: versão $PIP_VERSION"
else
    print_warning "pip3 não encontrado. Tentando instalar..."
    python3 -m ensurepip --default-pip
    if [ $? -eq 0 ]; then
        print_success "pip3 instalado com sucesso"
    else
        print_error "Falha ao instalar pip3"
        exit 1
    fi
fi

echo

# Verifica e instala requests
echo "🔍 Verificando biblioteca 'requests'..."
if python3 -c "import requests" &> /dev/null; then
    REQUESTS_VERSION=$(python3 -c "import requests; print(requests.__version__)")
    print_success "requests já instalado: versão $REQUESTS_VERSION"
else
    print_warning "requests não encontrado. Instalando..."
    pip3 install requests
    if [ $? -eq 0 ]; then
        print_success "requests instalado com sucesso"
    else
        print_error "Falha ao instalar requests"
        echo
        print_info "Tente manualmente: pip3 install requests"
        exit 1
    fi
fi

echo
echo "========================================================================"
echo "📋 Verificando arquivos do projeto..."
echo "========================================================================"
echo

# Verifica arquivos necessários
FILES=("sandra_api_scanner.py" "extrair_cookies.js" "SANDRA_SCANNER_README.md")
MISSING=0

for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        print_success "$file encontrado"
    else
        print_error "$file NÃO encontrado"
        MISSING=1
    fi
done

echo

if [ $MISSING -eq 1 ]; then
    print_error "Alguns arquivos estão faltando!"
    exit 1
fi

# Torna o script Python executável
chmod +x sandra_api_scanner.py 2>/dev/null

echo "========================================================================"
echo "✨ CONFIGURAÇÃO CONCLUÍDA COM SUCESSO!"
echo "========================================================================"
echo
echo "📖 Próximos passos:"
echo
echo "1️⃣  Abra o sistema SANDRA no navegador e faça login"
echo "2️⃣  Pressione F12 e vá na aba Console"
echo "3️⃣  Cole o conteúdo do arquivo extrair_cookies.js e pressione Enter"
echo "4️⃣  Copie o código gerado e cole no arquivo sandra_api_scanner.py"
echo "5️⃣  Execute: python3 sandra_api_scanner.py"
echo
echo "📚 Para mais detalhes, consulte: SANDRA_SCANNER_README.md"
echo
echo "========================================================================"

# Pergunta se deseja executar agora
echo
read -p "❓ Deseja executar o scanner agora? (s/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[SsYy]$ ]]; then
    echo
    print_info "Executando scanner..."
    echo
    python3 sandra_api_scanner.py
else
    echo
    print_info "Execute manualmente quando estiver pronto:"
    echo "  python3 sandra_api_scanner.py"
fi

echo
