#!/bin/bash
# Script de demonstração - Inicia servidor e executa testes automaticamente

echo "========================================================================"
echo "🎬 DEMO - Test Server & API Client"
echo "========================================================================"
echo

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }
print_info() { echo -e "${CYAN}ℹ️  $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }

# Verifica Node.js
if ! command -v node &> /dev/null; then
    print_error "Node.js não encontrado!"
    echo "Instale com: sudo apt install nodejs npm"
    exit 1
fi

# Verifica Python 3
if ! command -v python3 &> /dev/null; then
    print_error "Python 3 não encontrado!"
    echo "Instale com: sudo apt install python3 python3-pip"
    exit 1
fi

# Verifica requests
if ! python3 -c "import requests" &> /dev/null; then
    print_warning "Biblioteca 'requests' não encontrada. Instalando..."
    pip3 install requests
fi

print_success "Dependências verificadas!"
echo

# Inicia o servidor em background
print_info "Iniciando servidor de testes na porta 3000..."
node test-server.js > /tmp/test-server.log 2>&1 &
SERVER_PID=$!

# Aguarda o servidor iniciar
sleep 2

# Verifica se o servidor está rodando
if ! ps -p $SERVER_PID > /dev/null; then
    print_error "Falha ao iniciar o servidor!"
    cat /tmp/test-server.log
    exit 1
fi

print_success "Servidor iniciado! (PID: $SERVER_PID)"
echo

# Executa os testes
print_info "Executando testes..."
echo
python3 test-api-client.py http://localhost:3000

# Captura o código de saída
EXIT_CODE=$?

echo
echo "========================================================================"
print_info "Encerrando servidor..."
kill $SERVER_PID 2>/dev/null

# Aguarda o servidor fechar
sleep 1

if [ $EXIT_CODE -eq 0 ]; then
    print_success "Demo concluída com sucesso!"
else
    print_warning "Demo concluída com avisos/erros"
fi

echo
print_info "📄 Logs do servidor salvos em: /tmp/test-server.log"
print_info "📊 Relatório salvo em: test_results.json"
echo
echo "========================================================================"
echo "🎉 Para mais detalhes, consulte: TEST_SERVER_README.md"
echo "========================================================================"

exit $EXIT_CODE
