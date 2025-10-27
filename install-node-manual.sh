#!/bin/bash
# Script para instalar Node.js manualmente sem permissões sudo

set -e

echo "=== Instalando Node.js v22.21.0 manualmente ==="

# Criar diretório para Node.js
NODE_DIR="$HOME/node"
mkdir -p "$NODE_DIR"

# Detectar arquitetura
ARCH=$(uname -m)
case "$ARCH" in
    x86_64)
        NODE_ARCH="x64"
        ;;
    aarch64)
        NODE_ARCH="arm64"
        ;;
    armv7l)
        NODE_ARCH="armv7l"
        ;;
    *)
        echo "Arquitetura não suportada: $ARCH"
        exit 1
        ;;
esac

echo "Arquitetura detectada: $NODE_ARCH"

# Download do Node.js
NODE_VERSION="v22.21.0"
NODE_DISTRO="node-$NODE_VERSION-linux-$NODE_ARCH"
NODE_URL="https://nodejs.org/dist/$NODE_VERSION/$NODE_DISTRO.tar.xz"

echo "Baixando Node.js de: $NODE_URL"
cd /tmp
curl -fsSL "$NODE_URL" -o node.tar.xz

echo "Extraindo arquivos..."
tar -xf node.tar.xz
rm -rf "$NODE_DIR"/*
mv "$NODE_DISTRO"/* "$NODE_DIR/"
rm -rf "$NODE_DISTRO" node.tar.xz

echo ""
echo "=== Node.js instalado com sucesso! ==="
echo ""
echo "Adicione ao seu ~/.bashrc:"
echo "export PATH=\"\$HOME/node/bin:\$PATH\""
echo ""
echo "E execute:"
echo "source ~/.bashrc"
echo ""
echo "Ou para usar imediatamente:"
echo "export PATH=\"\$HOME/node/bin:\$PATH\""
echo "node -v"
echo "npm -v"
