#!/bin/bash
# Script de Diagnóstico para Acesso Remoto
# Coleta informações necessárias para determinar viabilidade de acesso remoto

echo "=========================================================================="
echo "🔍 DIAGNÓSTICO DE ACESSO REMOTO - Sistema Linux"
echo "=========================================================================="
echo

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

print_section() { echo -e "\n${BLUE}=== $1 ===${NC}\n"; }
print_info() { echo -e "${GREEN}✓${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }

# ============================================
# 1. INFORMAÇÕES DE REDE
# ============================================
print_section "1. INFORMAÇÕES DE REDE"

echo "📍 IP Local (Privado):"
hostname -I

echo -e "\n📍 IP Público (se acessível):"
IP_PUBLICO=$(curl -s --max-time 5 ifconfig.me 2>/dev/null)
if [ -n "$IP_PUBLICO" ]; then
    echo "$IP_PUBLICO"
else
    echo "(Não foi possível obter)"
fi

echo -e "\n📍 Gateway/Roteador:"
ip route | grep default

echo -e "\n📍 Interface de Rede:"
ip addr show | grep -E "^[0-9]+:|inet "

# ============================================
# 2. SERVIÇO SSH
# ============================================
print_section "2. SERVIÇO SSH"

if systemctl is-active --quiet ssh 2>/dev/null || systemctl is-active --quiet sshd 2>/dev/null; then
    print_info "SSH está ATIVO"

    echo -e "\n📋 Status do SSH:"
    systemctl status ssh 2>/dev/null || systemctl status sshd 2>/dev/null | head -n 5

    echo -e "\n🔑 Porta SSH:"
    ss -tlnp | grep ssh || ss -tln | grep :22
else
    print_warning "SSH não está ativo ou não foi detectado"
fi

# ============================================
# 3. FIREWALL
# ============================================
print_section "3. FIREWALL"

if command -v ufw &> /dev/null; then
    echo "🛡️ UFW (Firewall):"
    sudo ufw status 2>/dev/null || echo "(Requer sudo para verificar)"
elif command -v firewall-cmd &> /dev/null; then
    echo "🛡️ Firewalld:"
    sudo firewall-cmd --list-all 2>/dev/null || echo "(Requer sudo para verificar)"
else
    echo "ℹ️ Nenhum firewall conhecido detectado (ou sem sudo)"
fi

# ============================================
# 4. PORTAS ABERTAS
# ============================================
print_section "4. PORTAS ABERTAS (LISTENING)"

echo "📡 Portas TCP abertas:"
ss -tln | grep LISTEN | sort -n -k5

echo -e "\n📡 Portas acessíveis externamente (0.0.0.0):"
ss -tln | grep LISTEN | grep "0.0.0.0" | sort -n -k5

# ============================================
# 5. TESTES DE CONECTIVIDADE
# ============================================
print_section "5. TESTES DE CONECTIVIDADE"

echo "🌐 Teste de ping ao gateway:"
GATEWAY=$(ip route | grep default | awk '{print $3}' | head -n1)
if [ -n "$GATEWAY" ]; then
    ping -c 2 -W 2 "$GATEWAY" >/dev/null 2>&1 && print_info "Gateway acessível" || print_warning "Gateway não responde a ping"
fi

echo -e "\n🌐 Teste de ping à internet:"
ping -c 2 -W 2 8.8.8.8 >/dev/null 2>&1 && print_info "Internet acessível" || print_warning "Internet não acessível"

echo -e "\n🌐 Teste DNS:"
ping -c 2 -W 2 google.com >/dev/null 2>&1 && print_info "DNS funcionando" || print_warning "DNS não funciona"

# ============================================
# 6. INFORMAÇÕES DO SISTEMA
# ============================================
print_section "6. INFORMAÇÕES DO SISTEMA"

echo "💻 Sistema Operacional:"
cat /etc/os-release | grep -E "^(NAME|VERSION)=" | head -n2

echo -e "\n👤 Usuário atual:"
echo "$(whoami)@$(hostname)"

echo -e "\n🔐 Chave SSH pública (se existir):"
if [ -f ~/.ssh/id_rsa.pub ]; then
    print_info "Chave RSA encontrada"
    cat ~/.ssh/id_rsa.pub
elif [ -f ~/.ssh/id_ed25519.pub ]; then
    print_info "Chave ED25519 encontrada"
    cat ~/.ssh/id_ed25519.pub
else
    print_warning "Nenhuma chave SSH pública encontrada"
fi

# ============================================
# 7. VERIFICAÇÃO DE FERRAMENTAS
# ============================================
print_section "7. FERRAMENTAS DISPONÍVEIS"

check_tool() {
    if command -v $1 &> /dev/null; then
        print_info "$1 instalado"
    else
        print_warning "$1 NÃO instalado"
    fi
}

check_tool "ssh"
check_tool "curl"
check_tool "wget"
check_tool "nc"
check_tool "nmap"
check_tool "ngrok"

# ============================================
# 8. ANÁLISE E RECOMENDAÇÕES
# ============================================
print_section "8. ANÁLISE E RECOMENDAÇÕES"

echo "📊 Análise da situação:"
echo

# Verifica se está em rede privada
IP_LOCAL=$(hostname -I | awk '{print $1}')
if [[ $IP_LOCAL == 10.* ]] || [[ $IP_LOCAL == 172.* ]] || [[ $IP_LOCAL == 192.168.* ]]; then
    print_warning "IP Local é PRIVADO ($IP_LOCAL)"
    echo "   → Você está atrás de um roteador/NAT"
    echo "   → Acesso direto via SSH NÃO é possível sem configuração adicional"
    echo
    echo "💡 Opções disponíveis:"
    echo "   1. Port Forwarding no roteador (requer acesso administrativo)"
    echo "   2. Usar serviço de túnel (ngrok, localtunnel, cloudflare tunnel)"
    echo "   3. VPN (Tailscale, ZeroTier, WireGuard)"
    echo "   4. Proxy reverso (SSH via servidor intermediário)"
else
    print_info "IP Local parece ser PÚBLICO"
    echo "   → Acesso SSH direto pode ser possível"
fi

echo
if systemctl is-active --quiet ssh 2>/dev/null || systemctl is-active --quiet sshd 2>/dev/null; then
    print_info "SSH está rodando e pronto para conexões"
else
    print_error "SSH NÃO está rodando - precisa ser instalado/iniciado"
fi

echo
echo "=========================================================================="
echo "✅ Diagnóstico completo! Veja as recomendações acima."
echo "=========================================================================="
