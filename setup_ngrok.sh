#!/bin/bash
# Script de instalação e configuração do ngrok para túnel SSH

echo "=========================================================================="
echo "🚇 NGROK - Túnel SSH Reverso"
echo "=========================================================================="
echo

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

print_info() { echo -e "${GREEN}✓${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_step() { echo -e "\n${BLUE}▶${NC} $1\n"; }

# ============================================
# VERIFICAÇÃO
# ============================================
if command -v ngrok &> /dev/null; then
    print_info "ngrok já está instalado!"
    ngrok version
    echo
    read -p "Deseja reinstalar? (s/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[SsYy]$ ]]; then
        echo "Pulando instalação..."

        # Pular para configuração
        if [ -f ~/.config/ngrok/ngrok.yml ]; then
            print_info "ngrok já está configurado"
            echo
            print_step "Para criar túnel SSH, execute:"
            echo "ngrok tcp 22"
            exit 0
        else
            print_warning "ngrok instalado mas não configurado"
            echo "Continue para configurar..."
        fi
    fi
fi

# ============================================
# INSTALAÇÃO
# ============================================
print_step "1. Baixando ngrok..."

cd /tmp

# Detectar arquitetura
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    NGROK_FILE="ngrok-v3-stable-linux-amd64.tgz"
elif [ "$ARCH" = "aarch64" ]; then
    NGROK_FILE="ngrok-v3-stable-linux-arm64.tgz"
else
    print_error "Arquitetura não suportada: $ARCH"
    exit 1
fi

wget -q --show-progress "https://bin.equinox.io/c/bNyj1mQVY4c/$NGROK_FILE"

if [ ! -f "$NGROK_FILE" ]; then
    print_error "Falha no download"
    exit 1
fi

print_step "2. Instalando ngrok..."

tar xzf "$NGROK_FILE"
sudo mv ngrok /usr/local/bin/

rm "$NGROK_FILE"

print_info "ngrok instalado em /usr/local/bin/ngrok"

# ============================================
# CONFIGURAÇÃO
# ============================================
print_step "3. Configuração da conta ngrok"

echo
echo "=========================================================================="
echo "📝 VOCÊ PRECISA DE UMA CONTA NGROK (GRÁTIS)"
echo "=========================================================================="
echo
echo "1. Acesse: https://dashboard.ngrok.com/signup"
echo "2. Crie uma conta gratuita"
echo "3. Vá em: https://dashboard.ngrok.com/get-started/your-authtoken"
echo "4. Copie seu Authtoken"
echo
echo "=========================================================================="
echo

read -p "Você já tem uma conta ngrok? (s/N) " -n 1 -r
echo
echo

if [[ $REPLY =~ ^[SsYy]$ ]]; then
    echo "Cole seu Authtoken abaixo:"
    read -p "Authtoken: " AUTHTOKEN

    if [ -z "$AUTHTOKEN" ]; then
        print_error "Authtoken não pode ser vazio"
        exit 1
    fi

    ngrok config add-authtoken "$AUTHTOKEN"

    print_info "Authtoken configurado!"
else
    print_warning "Configure o authtoken depois com:"
    echo "ngrok config add-authtoken SEU_TOKEN_AQUI"
    exit 0
fi

# ============================================
# TESTE
# ============================================
print_step "4. Testando configuração..."

if ngrok version >/dev/null 2>&1; then
    print_info "ngrok está funcionando corretamente"
else
    print_error "Erro ao executar ngrok"
    exit 1
fi

# ============================================
# INSTRUÇÕES
# ============================================
echo
echo "=========================================================================="
echo "✅ INSTALAÇÃO CONCLUÍDA!"
echo "=========================================================================="
echo
echo "📋 COMO USAR:"
echo
echo "1️⃣  Criar túnel SSH (execute e DEIXE RODANDO):"
echo "   ngrok tcp 22"
echo
echo "   Saída exemplo:"
echo "   Forwarding: tcp://0.tcp.ngrok.io:12345 -> localhost:22"
echo
echo "2️⃣  Conectar de outro computador:"
echo "   ssh $(whoami)@0.tcp.ngrok.io -p 12345"
echo "   (use o endereço e porta que o ngrok mostrar)"
echo
echo "3️⃣  Manter o túnel sempre ativo:"
echo "   - Use screen ou tmux"
echo "   - Ou configure como serviço systemd"
echo
echo "=========================================================================="
echo "⚠️  IMPORTANTE:"
echo "   - Cada vez que iniciar o ngrok, a URL/porta muda"
echo "   - Plano grátis: 1 túnel simultâneo, 40 conexões/min"
echo "   - O túnel fecha se você fechar o terminal (use screen/tmux)"
echo "=========================================================================="
echo
echo "💡 DICAS:"
echo
echo "   Executar em background com screen:"
echo "   screen -S ngrok"
echo "   ngrok tcp 22"
echo "   Ctrl+A, D (para desconectar)"
echo "   screen -r ngrok (para reconectar)"
echo
echo "   Ver túneis ativos:"
echo "   curl http://localhost:4040/api/tunnels"
echo
echo "=========================================================================="

# Criar script helper
cat > ~/start_ngrok_ssh.sh <<'EOF'
#!/bin/bash
# Script helper para iniciar túnel SSH via ngrok

echo "🚇 Iniciando túnel SSH via ngrok..."
echo

ngrok tcp 22
EOF

chmod +x ~/start_ngrok_ssh.sh

print_info "Script helper criado: ~/start_ngrok_ssh.sh"
echo
echo "Execute: ~/start_ngrok_ssh.sh"
echo
