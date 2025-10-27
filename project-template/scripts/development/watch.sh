#!/bin/bash

# ====================
# Development Watch Script
# ====================
# Monitora mudanças em arquivos e reinicia automaticamente

set -euo pipefail

WATCH_DIR="${1:-.}"
COMMAND="${2:-npm run dev}"

echo "👀 Watching for changes in: $WATCH_DIR"
echo "🚀 Command: $COMMAND"
echo ""
echo "Press Ctrl+C to stop"
echo ""

# Verificar se inotify-tools está instalado
if ! command -v inotifywait &> /dev/null; then
  echo "⚠️  inotifywait not found. Installing inotify-tools..."
  sudo apt-get update && sudo apt-get install -y inotify-tools
fi

# PID do processo em execução
CURRENT_PID=""

# Função para matar processo atual
kill_current() {
  if [ -n "$CURRENT_PID" ]; then
    echo "🛑 Stopping current process (PID: $CURRENT_PID)..."
    kill $CURRENT_PID 2>/dev/null || true
    wait $CURRENT_PID 2>/dev/null || true
  fi
}

# Função para iniciar processo
start_process() {
  kill_current
  echo "🔄 Starting process..."
  eval "$COMMAND" &
  CURRENT_PID=$!
  echo "✅ Process started (PID: $CURRENT_PID)"
}

# Cleanup ao sair
trap 'kill_current; exit 0' INT TERM

# Iniciar processo pela primeira vez
start_process

# Watch for changes
inotifywait -m -r -e modify,create,delete \
  --exclude '(node_modules|\.git|logs|dist|build|\.next)' \
  "$WATCH_DIR" |
while read path action file; do
  echo ""
  echo "📝 Detected $action: $path$file"
  start_process
done
