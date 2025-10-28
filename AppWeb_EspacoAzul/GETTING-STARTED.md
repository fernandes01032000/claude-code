# 🚀 Começando com AppWeb EspacoAzul

Guia rápido para configurar e iniciar o projeto AppWeb EspacoAzul.

## Opção 1: Setup Automático (Recomendado)

```bash
# Executar script de setup
./scripts/setup/setup-new-project.sh
```

O script irá:
- ✅ Criar arquivo `.env` baseado no `.env.example`
- ✅ Configurar estrutura de secrets em `.secrets/`
- ✅ Inicializar Git
- ✅ Instalar dependências
- ✅ Criar README personalizado

## Opção 2: Setup Manual

### 1. Configurar Ambiente

```bash
# Copiar exemplo de variáveis de ambiente
cp .env.example .env

# Editar com suas configurações
nano .env
```

### 2. Configurar Secrets

```bash
# Criar pasta de secrets
mkdir -p .secrets/development
chmod 700 .secrets

# Copiar templates
cp .secrets-template/database.template.json .secrets/development/database.json
cp .secrets-template/api-keys.template.json .secrets/development/api-keys.json

# Editar com valores reais
nano .secrets/development/database.json

# Proteger arquivos
chmod 600 .secrets/development/*
```

### 3. Inicializar Git

```bash
git init
git add .
git commit -m "Initial commit from template"
```

### 4. Instalar Dependências

Escolha baseado na sua linguagem:

**JavaScript/Node.js:**
```bash
npm init -y
npm install express dotenv cors helmet
npm install --save-dev nodemon
```

**Python:**
```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

**Go:**
```bash
go mod init seu-projeto
go get -u github.com/joho/godotenv
```

## Próximos Passos

### 📖 Leia a Documentação

- **[README.md](README.md)** - Visão geral completa
- **[docs/guides/quick-start.md](docs/guides/quick-start.md)** - Guia rápido por tipo de projeto
- **[docs/api/README.md](docs/api/README.md)** - Documentação de API (se aplicável)
- **[docs/integration/README.md](docs/integration/README.md)** - Guia de integrações

### 🏗️ Escolha Seu Tipo de Projeto

#### Para API/Backend:
```bash
# Ver exemplo
cat src/api/example-server.js

# Iniciar
node src/api/example-server.js
```

#### Para Aplicação Web:
```bash
# Criar app React
npx create-react-app src/web

# ou Vue
npm create vue@latest src/web

# ou Next.js
npx create-next-app src/web
```

#### Para Scripts Bash:
```bash
# Ver exemplo
cat scripts/main.sh

# Tornar executável
chmod +x scripts/main.sh

# Executar
./scripts/main.sh
```

#### Para CLI Tool:
```bash
# Ver exemplo em docs/guides/quick-start.md
# Instalar dependências para CLI
npm install commander inquirer chalk ora
```

### ⚙️ Configurar Ferramentas de Desenvolvimento

#### ESLint (JavaScript)
```bash
npm install --save-dev eslint
npx eslint --init
```

#### Prettier
```bash
npm install --save-dev prettier
echo '{"semi": true, "singleQuote": true}' > .prettierrc
```

#### Testes
```bash
# Jest (JavaScript)
npm install --save-dev jest
npm pkg set scripts.test="jest"

# Pytest (Python)
pip install pytest
```

### 🔐 Segurança

⚠️ **IMPORTANTE:**

1. **NUNCA** commite arquivos `.env` ou `.secrets/`
2. **SEMPRE** use `.env.example` como template
3. **SEMPRE** adicione arquivos sensíveis ao `.gitignore`
4. **Verifique** antes de cada commit: `git status`

```bash
# Verificar o que será commitado
git status

# Se vir .env ou .secrets/, NÃO COMMITE!
# Adicione ao .gitignore se necessário
```

## Estrutura de Pastas

```
AppWeb_EspacoAzul/
├── .secrets-template/      # 🔐 Templates de secrets
├── assets/                # 🖼️  Arquivos estáticos
├── config/                # ⚙️  Configurações
├── docs/                  # 📚 Documentação
│   ├── api/              # Docs da API
│   ├── guides/           # Guias de uso
│   ├── integration/      # Guias de integração
│   └── architecture/     # Decisões de arquitetura
├── logs/                  # 📝 Logs (não commitado)
├── scripts/               # 🛠️  Scripts auxiliares
│   ├── setup/            # Scripts de instalação
│   ├── deploy/           # Scripts de deploy
│   ├── maintenance/      # Manutenção
│   └── development/      # Desenvolvimento
├── src/                   # 💻 Código fonte
│   ├── api/              # Backend/API
│   ├── cli/              # CLI
│   ├── models/           # Modelos de dados
│   ├── services/         # Lógica de negócio
│   ├── utils/            # Utilitários
│   └── web/              # Frontend
├── tests/                 # 🧪 Testes
├── .env.example           # Exemplo de variáveis de ambiente
├── .gitignore            # Arquivos ignorados pelo git
└── README.md             # Documentação principal
```

## Comandos Úteis

### Desenvolvimento
```bash
# Iniciar servidor de desenvolvimento (se aplicável)
npm run dev
# ou
python src/main.py
# ou
./scripts/development/start-all.sh
```

### Testes
```bash
# Executar testes
npm test
# ou
pytest
```

### Build
```bash
# Criar build de produção (se aplicável)
npm run build
```

### Deploy
```bash
# Ver scripts de deploy
ls scripts/deploy/
```

## Precisa de Ajuda?

- 📖 Leia a [documentação completa](README.md)
- 🔍 Veja [exemplos práticos](docs/guides/quick-start.md)
- 🏗️ Consulte [decisões de arquitetura](docs/architecture/DECISIONS.md)
- 🔐 Revise [boas práticas de segurança](.secrets-template/README.md)

## Checklist de Setup

- [ ] Executar script de setup OU configurar manualmente
- [ ] Criar e configurar `.env`
- [ ] Configurar `.secrets/development/`
- [ ] Inicializar Git
- [ ] Instalar dependências
- [ ] Ler documentação relevante para seu tipo de projeto
- [ ] Executar primeiro teste
- [ ] Verificar que secrets não estão sendo commitados

## Pronto! 🎉

Agora você está pronto para começar a desenvolver!

Lembre-se de:
- ✅ Commitar frequentemente
- ✅ Escrever testes
- ✅ Documentar decisões importantes
- ✅ Nunca commitar secrets
