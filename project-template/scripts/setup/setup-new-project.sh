#!/bin/bash

# ====================
# Setup New Project
# ====================
# Este script configura um novo projeto baseado no template

set -euo pipefail

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ====================
# Funções
# ====================
log() {
  echo -e "${BLUE}[INFO]${NC} $*"
}

success() {
  echo -e "${GREEN}[SUCCESS]${NC} $*"
}

error() {
  echo -e "${RED}[ERROR]${NC} $*" >&2
  exit 1
}

warning() {
  echo -e "${YELLOW}[WARNING]${NC} $*"
}

# ====================
# Banner
# ====================
cat << "EOF"
╔═══════════════════════════════════════════╗
║     Project Template Setup Script         ║
║                                           ║
║  Este script vai configurar seu projeto  ║
╚═══════════════════════════════════════════╝

EOF

# ====================
# Perguntas
# ====================
echo "Responda as perguntas abaixo para configurar seu projeto:"
echo ""

read -p "Nome do projeto: " PROJECT_NAME
read -p "Descrição do projeto: " PROJECT_DESCRIPTION
read -p "Tipo de projeto (api/web/cli/fullstack): " PROJECT_TYPE
read -p "Linguagem principal (javascript/python/bash): " LANGUAGE

# ====================
# Validação
# ====================
if [ -z "$PROJECT_NAME" ]; then
  error "Nome do projeto é obrigatório"
fi

# ====================
# Configuração de Ambiente
# ====================
log "Configurando arquivo .env..."

if [ ! -f .env ]; then
  cp .env.example .env
  sed -i "s/PROJECT_NAME=my-project/PROJECT_NAME=$PROJECT_NAME/" .env
  success "Arquivo .env criado"
else
  warning "Arquivo .env já existe, pulando..."
fi

# ====================
# Criar pastas de secrets
# ====================
log "Criando estrutura de secrets..."

mkdir -p .secrets/{development,staging,production}
chmod 700 .secrets

# Copiar templates
if [ -d .secrets-template ]; then
  cp .secrets-template/*.template.json .secrets/development/ 2>/dev/null || true
  for file in .secrets/development/*.template.json; do
    if [ -f "$file" ]; then
      mv "$file" "${file/.template.json/.json}"
      chmod 600 "${file/.template.json/.json}"
    fi
  done
fi

success "Estrutura de secrets criada em .secrets/"

# ====================
# Configurar Git
# ====================
if [ ! -d .git ]; then
  log "Inicializando repositório Git..."
  git init
  success "Git inicializado"
else
  warning "Git já inicializado"
fi

# ====================
# Instalar Dependências
# ====================
log "Configurando dependências para $LANGUAGE..."

case $LANGUAGE in
  javascript)
    if [ ! -f package.json ]; then
      log "Inicializando package.json..."
      npm init -y
      npm pkg set name="$PROJECT_NAME"
      npm pkg set description="$PROJECT_DESCRIPTION"

      # Instalar dependências comuns
      if [ "$PROJECT_TYPE" = "api" ] || [ "$PROJECT_TYPE" = "fullstack" ]; then
        log "Instalando dependências para API..."
        npm install express dotenv cors helmet
        npm install --save-dev nodemon
      fi

      success "Dependências JavaScript configuradas"
    fi
    ;;

  python)
    if [ ! -f requirements.txt ]; then
      log "Criando requirements.txt..."
      cat > requirements.txt << PYREQ
python-dotenv==1.0.0
requests==2.31.0
PYREQ

      log "Criando ambiente virtual Python..."
      python3 -m venv venv
      source venv/bin/activate
      pip install -r requirements.txt

      success "Ambiente Python configurado"
    fi
    ;;

  bash)
    log "Projeto bash - sem dependências para instalar"
    ;;
esac

# ====================
# Criar Logs
# ====================
log "Criando diretório de logs..."
mkdir -p logs
touch logs/.gitkeep
chmod 755 logs

# ====================
# README personalizado
# ====================
log "Criando README personalizado..."

cat > README.project.md << READMEEOF
# $PROJECT_NAME

$PROJECT_DESCRIPTION

## Tipo
$PROJECT_TYPE

## Linguagem
$LANGUAGE

## Estrutura

Veja a estrutura completa em \`docs/guides/project-structure.md\`

## Início Rápido

\`\`\`bash
# Configurar ambiente
cp .env.example .env

# Instalar dependências
# Ver docs/guides/quick-start.md para seu tipo de projeto

# Executar
npm start  # ou python main.py, ou ./scripts/main.sh
\`\`\`

## Documentação

- API: \`docs/api/\`
- Guias: \`docs/guides/\`
- Integrações: \`docs/integration/\`
- Arquitetura: \`docs/architecture/\`

## Secrets e Configuração

⚠️ NUNCA commite secrets reais!

- Use \`.env\` para desenvolvimento local
- Veja \`.secrets-template/README.md\` para boas práticas
- Secrets reais devem estar em \`.secrets/\` (não commitado)

## Licença

TODO: Adicionar licença

## Contribuindo

1. Fork o projeto
2. Crie uma branch (\`git checkout -b feature/nova-feature\`)
3. Commit suas mudanças (\`git commit -am 'Add nova feature'\`)
4. Push para a branch (\`git push origin feature/nova-feature\`)
5. Abra um Pull Request

READMEEOF

success "README.project.md criado"

# ====================
# Finalização
# ====================
echo ""
success "✨ Projeto configurado com sucesso! ✨"
echo ""
log "Próximos passos:"
echo "  1. Edite o arquivo .env com suas configurações"
echo "  2. Configure seus secrets em .secrets/development/"
echo "  3. Leia a documentação em docs/"
echo "  4. Veja o guia rápido em docs/guides/quick-start.md"
echo ""
log "Estrutura criada:"
echo "  - .env configurado"
echo "  - .secrets/ criado"
echo "  - Git inicializado"
echo "  - Dependências instaladas"
echo "  - README.project.md criado"
echo ""
warning "LEMBRE-SE: Nunca commite arquivos .env ou .secrets/ !"
echo ""
