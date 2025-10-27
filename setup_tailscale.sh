#!/bin/bash
# Script de instalação e configuração do Tailscale
# Solução recomendada para acesso remoto

echo "=========================================================================="
echo "🦎 INSTALAÇÃO DO TAILSCALE - VPN Mesh Segura"
echo "=========================================================================="
echo

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info() { echo -e "${GREEN}✓${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_step() { echo -e "\n${BLUE}▶${NC} $1\n"; }

# Verificar se já está instalado
if command -v tailscale &> /dev/null; then
    print_info "Tailscale já está instalado!"
    echo
    tailscale version
    echo

    read -p "Deseja reinstalar? (s/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[SsYy]$ ]]; then
        echo "Pulando instalação..."
        exit 0
    fi
fi

# ============================================
# INSTALAÇÃO
# ============================================
print_step "1. Baixando e instalando Tailscale..."

# Detectar sistema
if [ -f /etc/debian_version ]; then
    # Debian/Ubuntu
    curl -fsSL https://tailscale.com/install.sh | sh
elif [ -f /etc/redhat-release ]; then
    # RHEL/CentOS/Fedora
    curl -fsSL https://tailscale.com/install.sh | sh
elif [ -f /etc/arch-release ]; then
    # Arch Linux
    sudo pacman -S tailscale
else
    print_warning "Sistema não detectado automaticamente"
    echo "Visite: https://tailscale.com/download/linux"
    exit 1
fi

# Verificar instalação
if ! command -v tailscale &> /dev/null; then
    echo "❌ Erro na instalação. Tente manualmente em: https://tailscale.com/download"
    exit 1
fi

print_info "Tailscale instalado com sucesso!"

# ============================================
# CONFIGURAÇÃO
# ============================================
print_step "2. Configurando Tailscale..."

echo "Iniciando serviço Tailscale..."
sudo systemctl enable --now tailscaled 2>/dev/null || true

echo
echo "Agora você precisa autenticar com sua conta Tailscale."
echo "Uma janela do navegador será aberta (ou copie o link)."
echo
read -p "Pressione ENTER para continuar..." -r
echo

# Autenticar
sudo tailscale up

# ============================================
# INFORMAÇÕES
# ============================================
print_step "3. Informações da conexão:"

echo "📍 Seu IP Tailscale:"
tailscale ip -4
TAILSCALE_IP=$(tailscale ip -4)

echo
echo "📍 Seu IP IPv6 Tailscale:"
tailscale ip -6

echo
echo "🌐 Status da conexão:"
tailscale status

echo
echo "=========================================================================="
echo "✅ INSTALAÇÃO CONCLUÍDA COM SUCESSO!"
echo "=========================================================================="
echo
echo "📋 PRÓXIMOS PASSOS:"
echo
echo "1️⃣  No OUTRO computador (de onde vai conectar):"
echo "   - Instale também o Tailscale"
echo "   - Execute: curl -fsSL https://tailscale.com/install.sh | sh"
echo "   - Execute: sudo tailscale up"
echo
echo "2️⃣  Para conectar via SSH deste computador:"
echo "   ssh $(whoami)@$TAILSCALE_IP"
echo
echo "3️⃣  Ver dispositivos conectados:"
echo "   tailscale status"
echo
echo "4️⃣  Administrar via web:"
echo "   https://login.tailscale.com/admin/machines"
echo
echo "=========================================================================="
echo "💡 DICAS:"
echo "   - O Tailscale cria uma VPN privada entre seus dispositivos"
echo "   - Funciona mesmo atrás de firewall/NAT"
echo "   - Totalmente criptografado (WireGuard)"
echo "   - Grátis até 100 dispositivos"
echo "=========================================================================="

# Salvar informações
cat > ~/tailscale_info.txt <<EOF
========================================
TAILSCALE - Informações de Conexão
========================================
Data: $(date)
Usuário: $(whoami)
Hostname: $(hostname)

IP Tailscale: $TAILSCALE_IP

Comando SSH:
ssh $(whoami)@$TAILSCALE_IP

Painel Web:
https://login.tailscale.com/admin/machines
========================================
EOF

echo
print_info "Informações salvas em: ~/tailscale_info.txt"
echo
