# Guia de Início Rápido

## Escolha Seu Tipo de Projeto

1. [API REST/Backend](#api-restbackend)
2. [Aplicação Web Frontend](#aplicação-web-frontend)
3. [Script Bash](#script-bash)
4. [CLI Tool](#cli-tool)
5. [Full Stack](#full-stack)

---

## API REST/Backend

### Setup Inicial

```bash
# 1. Copiar template
cp -r project-template/ minha-api/
cd minha-api/

# 2. Configurar ambiente
cp .env.example .env

# 3. Instalar dependências (Node.js exemplo)
npm init -y
npm install express dotenv cors helmet
npm install --save-dev nodemon

# 4. Estrutura para API
mkdir -p src/api/{routes,controllers,middleware}
mkdir -p src/models
mkdir -p src/services
```

### Exemplo Básico (src/api/server.js)

```javascript
require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');

const app = express();
const PORT = process.env.APP_PORT || 3000;

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());

// Routes
app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

app.use('/api/v1/users', require('./routes/users'));

// Error handling
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Something went wrong!' });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
```

### package.json Scripts

```json
{
  "scripts": {
    "start": "node src/api/server.js",
    "dev": "nodemon src/api/server.js",
    "test": "jest"
  }
}
```

---

## Aplicação Web Frontend

### Setup Inicial

```bash
# 1. Copiar template
cp -r project-template/ meu-app-web/
cd meu-app-web/

# 2. Inicializar projeto frontend
# React
npx create-react-app src/web
# ou Vue
npm create vue@latest src/web
# ou Next.js
npx create-next-app src/web

# 3. Estrutura
mkdir -p src/web/{components,pages,services,utils}
mkdir -p assets/{images,styles,fonts}
```

### Exemplo de Estrutura React

```
src/web/
├── components/
│   ├── common/
│   │   ├── Button.jsx
│   │   └── Input.jsx
│   └── layout/
│       ├── Header.jsx
│       └── Footer.jsx
├── pages/
│   ├── Home.jsx
│   └── About.jsx
├── services/
│   └── api.js
├── utils/
│   └── helpers.js
├── App.jsx
└── index.js
```

### Exemplo de Service (src/web/services/api.js)

```javascript
const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:3000/api/v1';

export const api = {
  get: async (endpoint) => {
    const response = await fetch(`${API_BASE_URL}${endpoint}`, {
      headers: {
        'Authorization': `Bearer ${localStorage.getItem('token')}`
      }
    });
    return response.json();
  },

  post: async (endpoint, data) => {
    const response = await fetch(`${API_BASE_URL}${endpoint}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${localStorage.getItem('token')}`
      },
      body: JSON.stringify(data)
    });
    return response.json();
  }
};
```

---

## Script Bash

### Setup Inicial

```bash
# 1. Copiar template
cp -r project-template/ meu-script/
cd meu-script/

# 2. Criar script principal
touch scripts/main.sh
chmod +x scripts/main.sh
```

### Template de Script (scripts/main.sh)

```bash
#!/bin/bash

# ====================
# Configuração
# ====================
set -euo pipefail  # Exit on error, undefined vars, pipe failures
IFS=$'\n\t'        # Better word splitting

# Carregar variáveis de ambiente
if [ -f .env ]; then
  export $(cat .env | grep -v '^#' | xargs)
fi

# ====================
# Variáveis
# ====================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
LOG_FILE="${PROJECT_ROOT}/logs/script.log"

# ====================
# Funções
# ====================
log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

error() {
  echo "[ERROR] $*" >&2 | tee -a "$LOG_FILE"
  exit 1
}

usage() {
  cat << EOF
Uso: $(basename "$0") [OPÇÕES]

Opções:
  -h, --help        Mostra esta mensagem
  -v, --verbose     Modo verbose
  -d, --dry-run     Simula execução

Exemplos:
  $(basename "$0") --verbose
  $(basename "$0") --dry-run
EOF
}

# ====================
# Parse Arguments
# ====================
VERBOSE=false
DRY_RUN=false

while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      usage
      exit 0
      ;;
    -v|--verbose)
      VERBOSE=true
      shift
      ;;
    -d|--dry-run)
      DRY_RUN=true
      shift
      ;;
    *)
      error "Opção desconhecida: $1"
      ;;
  esac
done

# ====================
# Main
# ====================
main() {
  log "Iniciando script..."

  if [ "$VERBOSE" = true ]; then
    log "Modo verbose ativado"
  fi

  if [ "$DRY_RUN" = true ]; then
    log "Modo dry-run - apenas simulando"
  fi

  # Seu código aqui
  log "Executando tarefa principal..."

  log "Script concluído com sucesso!"
}

# Executar
main "$@"
```

---

## CLI Tool

### Setup Inicial

```bash
# 1. Copiar template
cp -r project-template/ minha-cli/
cd minha-cli/

# 2. Instalar dependências
npm init -y
npm install commander inquirer chalk ora

# 3. Estrutura
mkdir -p src/cli/{commands,utils}
```

### Exemplo CLI (src/cli/index.js)

```javascript
#!/usr/bin/env node

const { Command } = require('commander');
const inquirer = require('inquirer');
const chalk = require('chalk');
const ora = require('ora');

const program = new Command();

program
  .name('mycli')
  .description('Descrição da sua CLI')
  .version('1.0.0');

program
  .command('init')
  .description('Inicializar novo projeto')
  .action(async () => {
    const answers = await inquirer.prompt([
      {
        type: 'input',
        name: 'name',
        message: 'Nome do projeto:',
        default: 'my-project'
      },
      {
        type: 'list',
        name: 'type',
        message: 'Tipo de projeto:',
        choices: ['api', 'web', 'cli', 'fullstack']
      }
    ]);

    const spinner = ora('Criando projeto...').start();

    // Lógica de criação
    setTimeout(() => {
      spinner.succeed(chalk.green('Projeto criado com sucesso!'));
      console.log(chalk.blue(`\nPróximos passos:`));
      console.log(`  cd ${answers.name}`);
      console.log(`  npm install`);
      console.log(`  npm start`);
    }, 2000);
  });

program
  .command('deploy')
  .description('Deploy do projeto')
  .option('-e, --env <environment>', 'Ambiente (dev/staging/prod)', 'staging')
  .action((options) => {
    console.log(chalk.yellow(`Deploying to ${options.env}...`));
  });

program.parse();
```

### package.json para CLI

```json
{
  "name": "mycli",
  "version": "1.0.0",
  "bin": {
    "mycli": "./src/cli/index.js"
  },
  "scripts": {
    "link": "npm link"
  }
}
```

### Instalar globalmente

```bash
npm link
mycli --help
```

---

## Full Stack

Combine API + Frontend usando a estrutura do template:

```
project/
├── src/
│   ├── api/          # Backend
│   └── web/          # Frontend
├── scripts/
│   ├── development/
│   │   └── start-all.sh    # Iniciar ambos
│   └── deploy/
│       └── deploy-full.sh  # Deploy completo
```

### Script para Iniciar Tudo (scripts/development/start-all.sh)

```bash
#!/bin/bash

echo "Starting backend..."
cd src/api && npm run dev &
BACKEND_PID=$!

echo "Starting frontend..."
cd src/web && npm start &
FRONTEND_PID=$!

echo "Backend PID: $BACKEND_PID"
echo "Frontend PID: $FRONTEND_PID"

# Cleanup on exit
trap "kill $BACKEND_PID $FRONTEND_PID" EXIT

wait
```

---

## Próximos Passos

1. Configure seu `.env` com as variáveis necessárias
2. Leia a documentação em `docs/`
3. Configure testes em `tests/`
4. Adicione CI/CD em `.github/workflows/`
5. Configure secrets conforme `docs/security.md`

## Recursos Adicionais

- Ver `docs/architecture/` para decisões de design
- Ver `docs/api/` para documentação de API
- Ver `docs/integration/` para integrações com serviços
