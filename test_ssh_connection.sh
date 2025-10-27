#!/bin/bash
# Script para testar conectividade SSH

echo "=========================================================================="
echo "🔍 TESTE DE CONECTIVIDADE SSH"
echo "=========================================================================="
echo

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_info() { echo -e "${BLUE}ℹ${NC} $1"; }

# ============================================
# 1. VERIFICAR SSH LOCAL
# ============================================
echo "1️⃣  Verificando SSH localmente..."
echo

if systemctl is-active --quiet ssh 2>/dev/null || systemctl is-active --quiet sshd 2>/dev/null; then
    print_success "Serviço SSH está ATIVO"
else
    print_error "Serviço SSH NÃO está ativo"
    echo
    print_info "Para ativar:"
    echo "sudo systemctl start ssh"
    echo "sudo systemctl enable ssh"
    exit 1
fi

# Porta SSH
SSH_PORT=$(ss -tln | grep -E ":22\s" | head -n1 | awk '{print $4}' | grep -oP ":\K[0-9]+")

if [ -n "$SSH_PORT" ]; then
    print_success "SSH listening na porta: $SSH_PORT"
else
    print_warning "Porta SSH não detectada (pode estar em porta customizada)"
    SSH_PORT=22
fi

echo

# ============================================
# 2. TESTE LOCAL (localhost)
# ============================================
echo "2️⃣  Testando conexão SSH local (localhost)..."
echo

# Gerar chave temporária se não existir
if [ ! -f ~/.ssh/id_rsa ] && [ ! -f ~/.ssh/id_ed25519 ]; then
    print_info "Gerando par de chaves SSH temporário..."
    ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N "" -q
fi

# Teste de conexão local
timeout 5 ssh -o StrictHostKeyChecking=no -o ConnectTimeout=3 -o BatchMode=yes $(whoami)@localhost "echo test" 2>/dev/null

if [ $? -eq 0 ]; then
    print_success "Conexão SSH local funcionando (com chave)"
elif timeout 5 ssh -o StrictHostKeyChecking=no -o ConnectTimeout=3 $(whoami)@localhost "echo test" 2>/dev/null; then
    print_success "Conexão SSH local funcionando (com senha)"
else
    print_warning "Conexão SSH local falhou (pode precisar configurar chave ou senha)"
    echo
    print_info "Para testar manualmente:"
    echo "ssh $(whoami)@localhost"
fi

echo

# ============================================
# 3. TESTE NA REDE LOCAL
# ============================================
echo "3️⃣  Testando conexão SSH na rede local..."
echo

LOCAL_IP=$(hostname -I | awk '{print $1}')

if [ -n "$LOCAL_IP" ]; then
    print_info "Seu IP local: $LOCAL_IP"
    echo
    echo "Para conectar de outro computador NA MESMA REDE:"
    echo "ssh $(whoami)@$LOCAL_IP"
    echo

    # Teste se está acessível
    if timeout 3 nc -zv $LOCAL_IP $SSH_PORT 2>&1 | grep -q "succeeded"; then
        print_success "Porta SSH acessível no IP local"
    else
        print_warning "Porta SSH pode não estar acessível (firewall?)"
    fi
else
    print_error "Não foi possível detectar IP local"
fi

echo

# ============================================
# 4. VERIFICAR FERRAMENTAS DE TÚNEL
# ============================================
echo "4️⃣  Verificando ferramentas de túnel instaladas..."
echo

check_tool() {
    if command -v $1 &> /dev/null; then
        print_success "$1 instalado"
        return 0
    else
        print_warning "$1 NÃO instalado"
        return 1
    fi
}

TAILSCALE_OK=false
NGROK_OK=false

if check_tool "tailscale"; then
    TAILSCALE_OK=true
    TAILSCALE_IP=$(tailscale ip -4 2>/dev/null)
    if [ -n "$TAILSCALE_IP" ]; then
        echo "   └─ IP Tailscale: $TAILSCALE_IP"
        echo "   └─ Comando SSH: ssh $(whoami)@$TAILSCALE_IP"
    fi
fi

if check_tool "ngrok"; then
    NGROK_OK=true
    echo "   └─ Para criar túnel: ngrok tcp 22"
fi

check_tool "cloudflared" && echo "   └─ Para criar túnel: cloudflared tunnel"

echo

# ============================================
# 5. INFORMAÇÕES DE FIREWALL
# ============================================
echo "5️⃣  Verificando firewall..."
echo

if command -v ufw &> /dev/null; then
    UFW_STATUS=$(sudo ufw status 2>/dev/null | grep -i status || echo "Status desconhecido")
    echo "🛡️ UFW: $UFW_STATUS"

    if echo "$UFW_STATUS" | grep -qi "inactive"; then
        print_success "Firewall UFW desativado (SSH não está bloqueado)"
    elif echo "$UFW_STATUS" | grep -qi "active"; then
        print_info "Firewall UFW ativo - verifique se porta SSH está liberada:"
        echo "   sudo ufw allow 22/tcp"
    fi
elif command -v firewall-cmd &> /dev/null; then
    FIREWALLD_STATUS=$(sudo firewall-cmd --state 2>/dev/null || echo "desconhecido")
    echo "🛡️ Firewalld: $FIREWALLD_STATUS"

    if [ "$FIREWALLD_STATUS" = "running" ]; then
        print_info "Verifique se SSH está liberado:"
        echo "   sudo firewall-cmd --list-services"
    fi
else
    print_info "Nenhum firewall conhecido detectado (ou sem sudo)"
fi

echo

# ============================================
# 6. RECOMENDAÇÕES
# ============================================
echo "=========================================================================="
echo "📋 RECOMENDAÇÕES"
echo "=========================================================================="
echo

if [ "$TAILSCALE_OK" = true ] && [ -n "$TAILSCALE_IP" ]; then
    print_success "Tailscale configurado e funcionando!"
    echo
    echo "✅ PRONTO PARA ACESSO REMOTO via Tailscale:"
    echo "   ssh $(whoami)@$TAILSCALE_IP"
    echo
    echo "   (De qualquer computador com Tailscale instalado)"
    echo
elif [ "$NGROK_OK" = true ]; then
    print_info "ngrok instalado - você pode criar um túnel SSH:"
    echo
    echo "   1. Execute: ngrok tcp 22"
    echo "   2. Anote o endereço fornecido"
    echo "   3. Conecte com: ssh $(whoami)@ENDERECO -p PORTA"
    echo
else
    print_warning "Nenhuma ferramenta de túnel detectada"
    echo
    echo "Para acesso remoto, instale uma das opções:"
    echo
    echo "   Tailscale (recomendado):"
    echo "   bash setup_tailscale.sh"
    echo
    echo "   ngrok:"
    echo "   bash setup_ngrok.sh"
    echo
fi

echo "=========================================================================="
echo "📚 DOCUMENTAÇÃO COMPLETA"
echo "=========================================================================="
echo
echo "Leia o guia completo: ACESSO_REMOTO_GUIA.md"
echo "cat ACESSO_REMOTO_GUIA.md"
echo
echo "=========================================================================="

# ============================================
# 7. SALVAR RELATÓRIO
# ============================================
{
    echo "========================================="
    echo "RELATÓRIO DE CONECTIVIDADE SSH"
    echo "========================================="
    echo "Data: $(date)"
    echo "Usuário: $(whoami)"
    echo "Hostname: $(hostname)"
    echo
    echo "IP Local: $LOCAL_IP"
    echo "Porta SSH: $SSH_PORT"

    if [ "$TAILSCALE_OK" = true ] && [ -n "$TAILSCALE_IP" ]; then
        echo "IP Tailscale: $TAILSCALE_IP"
        echo
        echo "Comando SSH (Tailscale):"
        echo "ssh $(whoami)@$TAILSCALE_IP"
    fi

    echo
    echo "SSH Service: $(systemctl is-active ssh 2>/dev/null || systemctl is-active sshd 2>/dev/null || echo 'unknown')"
    echo
    echo "========================================="
} > ~/ssh_connectivity_report.txt

print_info "Relatório salvo em: ~/ssh_connectivity_report.txt"
echo
