#!/bin/bash
# Script para configurar túneis reversos

echo "=== Opções de Túnel Reverso ==="
echo ""
echo "1. SSH Reverse Tunnel (requer servidor remoto)"
echo "2. Cloudflare Tunnel (gratuito, requer cadastro)"
echo "3. localtunnel (via npx, requer Node.js)"
echo "4. serveo (apenas SSH, sem cadastro)"
echo ""

# Função para SSH Reverse Tunnel
ssh_tunnel() {
    echo "=== SSH Reverse Tunnel ==="
    echo ""
    echo "Exemplo de uso:"
    echo "ssh -R 8080:localhost:3000 user@seu-servidor.com"
    echo ""
    echo "Isso irá:"
    echo "  - Conectar ao servidor remoto"
    echo "  - Expor sua porta local 3000 na porta 8080 do servidor"
    echo "  - Acessível em: http://seu-servidor.com:8080"
    echo ""
    echo "Para manter rodando use: -N -f"
    echo "ssh -N -f -R 8080:localhost:3000 user@seu-servidor.com"
}

# Função para Cloudflare Tunnel
cloudflare_tunnel() {
    echo "=== Cloudflare Tunnel ==="
    echo ""
    echo "1. Instalar cloudflared:"
    echo "   wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb"
    echo "   # Se não tiver sudo, extrair o .deb manualmente"
    echo ""
    echo "2. Autenticar:"
    echo "   cloudflared tunnel login"
    echo ""
    echo "3. Criar túnel:"
    echo "   cloudflared tunnel --url http://localhost:3000"
    echo ""
    echo "Vantagens:"
    echo "  - HTTPS automático"
    echo "  - Sem necessidade de servidor próprio"
    echo "  - Proteção DDoS da Cloudflare"
}

# Função para localtunnel
localtunnel_setup() {
    echo "=== localtunnel ==="
    echo ""
    echo "Uso com npx (requer Node.js):"
    echo "npx localtunnel --port 3000"
    echo ""
    echo "Ou instalar globalmente:"
    echo "npm install -g localtunnel"
    echo "lt --port 3000"
    echo ""
    echo "Você receberá uma URL pública como:"
    echo "https://xyz-123.loca.lt"
}

# Função para serveo
serveo_setup() {
    echo "=== serveo (mais simples) ==="
    echo ""
    echo "Uso direto com SSH:"
    echo "ssh -R 80:localhost:3000 serveo.net"
    echo ""
    echo "Com subdomínio personalizado:"
    echo "ssh -R meuapp:80:localhost:3000 serveo.net"
    echo ""
    echo "Você receberá uma URL como:"
    echo "https://meuapp.serveo.net"
}

# Função para ngrok
ngrok_setup() {
    echo "=== ngrok ==="
    echo ""
    echo "1. Baixar de: https://ngrok.com/download"
    echo "2. Extrair: tar xvzf ngrok-*.tgz"
    echo "3. Cadastrar em: https://dashboard.ngrok.com/signup"
    echo "4. Configurar token: ./ngrok config add-authtoken SEU_TOKEN"
    echo "5. Executar: ./ngrok http 3000"
    echo ""
    echo "Você receberá URLs como:"
    echo "https://abc123.ngrok.io"
}

echo "Escolha uma opção (1-5) ou 'all' para ver todas:"
read -r choice

case "$choice" in
    1) ssh_tunnel ;;
    2) cloudflare_tunnel ;;
    3) localtunnel_setup ;;
    4) serveo_setup ;;
    5) ngrok_setup ;;
    all)
        ssh_tunnel
        echo ""
        cloudflare_tunnel
        echo ""
        localtunnel_setup
        echo ""
        serveo_setup
        echo ""
        ngrok_setup
        ;;
    *)
        echo "Opção inválida"
        exit 1
        ;;
esac
