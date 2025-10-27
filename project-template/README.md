# Template de Projeto - Estrutura Completa

Template base para desenvolvimento de aplicações, sistemas, APIs, páginas web e scripts bash.

## Estrutura do Projeto

```
project-template/
├── .secrets-template/      # Templates para gerenciamento de secrets
│   ├── README.md          # Guia de segurança e boas práticas
│   ├── database.template.json
│   └── api-keys.template.json
├── assets/                # Arquivos estáticos (imagens, fontes, etc)
├── config/                # Arquivos de configuração
│   └── config.example.json
├── docs/                  # Documentação do projeto
│   ├── api/              # Documentação de APIs
│   ├── integration/      # Guias de integração
│   ├── guides/           # Guias de uso
│   └── architecture/     # Documentação de arquitetura
├── logs/                  # Logs da aplicação (não commitado)
├── scripts/               # Scripts auxiliares
│   ├── setup/            # Scripts de instalação/setup
│   ├── deploy/           # Scripts de deploy
│   ├── maintenance/      # Scripts de manutenção
│   └── development/      # Scripts de desenvolvimento
├── src/                   # Código fonte principal
│   ├── api/              # Endpoints e rotas da API
│   ├── cli/              # Interface de linha de comando
│   ├── models/           # Modelos de dados
│   ├── services/         # Lógica de negócio
│   ├── utils/            # Funções utilitárias
│   └── web/              # Interface web (frontend)
├── tests/                 # Testes
│   ├── unit/             # Testes unitários
│   ├── integration/      # Testes de integração
│   └── e2e/              # Testes end-to-end
├── .editorconfig          # Configuração do editor
├── .env.example           # Exemplo de variáveis de ambiente
├── .gitignore            # Arquivos ignorados pelo git
└── README.md             # Este arquivo
```

## Início Rápido

### 1. Clonar o Template

```bash
# Copiar template para novo projeto
cp -r project-template/ meu-novo-projeto/
cd meu-novo-projeto/
```

### 2. Configurar Ambiente

```bash
# Copiar arquivo de ambiente
cp .env.example .env

# Editar com suas configurações
nano .env

# Criar pasta de secrets (não será commitada)
mkdir -p .secrets/development
chmod 700 .secrets
```

### 3. Configurar Secrets

```bash
# Copiar templates de secrets
cp .secrets-template/database.template.json .secrets/development/database.json
cp .secrets-template/api-keys.template.json .secrets/development/api-keys.json

# Editar com valores reais
nano .secrets/development/database.json

# Proteger arquivos
chmod 600 .secrets/development/*
```

### 4. Inicializar Git

```bash
git init
git add .
git commit -m "Initial commit from template"
```

## Guias de Uso

### Para Aplicação Web

1. Coloque código frontend em `src/web/`
2. Configure build em `scripts/development/`
3. Assets estáticos em `assets/`
4. Documentação em `docs/guides/`

### Para API/Backend

1. Endpoints em `src/api/`
2. Modelos em `src/models/`
3. Lógica de negócio em `src/services/`
4. Documentação de API em `docs/api/`

### Para Scripts Bash

1. Scripts em `scripts/` nas subpastas apropriadas
2. Utilitários em `src/utils/`
3. Documentação em `docs/guides/`

### Para Aplicação CLI

1. Comandos em `src/cli/`
2. Lógica em `src/services/`
3. Utilitários em `src/utils/`

## Gerenciamento de Secrets

### NUNCA commitar:
- Arquivos `.env` (exceto `.env.example`)
- Pasta `.secrets/`
- Chaves privadas (`.key`, `.pem`)
- Credenciais em código

### Sempre usar:
- Variáveis de ambiente para desenvolvimento
- Vault/Secrets Manager para produção
- Templates em `.secrets-template/`
- `.gitignore` para proteger

## Documentação

### docs/api/
Documentação de endpoints, requests/responses, autenticação

### docs/integration/
Guias de integração com serviços externos, webhooks, APIs

### docs/guides/
Tutoriais, how-tos, guias de uso

### docs/architecture/
Decisões de arquitetura, diagramas, fluxos

## Scripts Úteis

### scripts/setup/
Scripts de instalação inicial, dependências, banco de dados

### scripts/deploy/
Scripts de deploy para diferentes ambientes

### scripts/maintenance/
Backup, limpeza, rotação de logs, manutenção

### scripts/development/
Scripts de desenvolvimento, build, watch, hot-reload

## Testes

```bash
# Testes unitários
npm test tests/unit/

# Testes de integração
npm test tests/integration/

# Testes e2e
npm test tests/e2e/

# Todos os testes
npm test
```

## Boas Práticas

1. **Segurança**
   - Use .env para configurações sensíveis
   - Nunca commite secrets
   - Use HTTPS em produção
   - Valide todas as entradas

2. **Código**
   - Mantenha código organizado por funcionalidade
   - Use nomes descritivos
   - Comente código complexo
   - Siga padrões da linguagem

3. **Documentação**
   - Documente APIs e integrações
   - Mantenha README atualizado
   - Documente decisões importantes
   - Use exemplos práticos

4. **Versionamento**
   - Commits descritivos
   - Use branches para features
   - Tags para releases
   - Keep changelog atualizado

## Ambientes

### Development
- `.env` com configurações locais
- Logs detalhados
- Debug ativado

### Staging
- Variáveis de ambiente do servidor
- Simulação de produção
- Testes finais

### Production
- Secrets Manager/Vault
- Logs otimizados
- Monitoramento ativo

## Contribuindo

1. Crie uma branch para sua feature
2. Faça commits descritivos
3. Adicione testes
4. Atualize documentação
5. Abra Pull Request

## Licença

Defina a licença do seu projeto aqui.

## Suporte

Adicione informações de contato e suporte aqui.
