# Guia de Implementação: Branch Protection

Este documento fornece instruções passo a passo para implementar branch protection no repositório.

---

## Passo 1: Criar Branch Principal

### Via Git (Linha de Comando)

```bash
# 1. Criar branch main a partir do estado atual
git checkout -b main

# 2. Push para o remote
git push -u origin main

# 3. Verificar se foi criada
git branch -a | grep main
```

### Via GitHub Web Interface

1. Acesse: https://github.com/fernandes01032000/claude-code
2. Clique em "Settings" > "Branches"
3. Em "Default branch", clique em "Switch to another branch"
4. Crie ou selecione "main"
5. Confirme a mudança

---

## Passo 2: Configurar Branch Protection Rules

### Acessar Configurações

1. Vá para: https://github.com/fernandes01032000/claude-code/settings/branches
2. Seção "Branch protection rules"

### Opção A: Atualizar Regra Existente "auto/claude-code"

1. Clique em "Edit" na regra "auto/claude-code"
2. Altere o padrão de branch:
   - De: `auto/claude-code`
   - Para: `main`

### Opção B: Criar Nova Regra para Main

1. Clique em "Add branch protection rule"
2. Em "Branch name pattern", digite: `main`
3. Configure as opções abaixo

### Configurações Recomendadas

#### Básico (Essencial)

```
☑ Require a pull request before merging
  ☑ Require approvals: 1
  ☐ Dismiss stale pull request approvals when new commits are pushed
  ☐ Require review from Code Owners

☑ Require conversation resolution before merging

☐ Require status checks to pass before merging
  (Habilitar depois de configurar CI/CD)

☑ Require linear history

☐ Do not allow bypassing the above settings
  (Recomendado para equipes)

☐ Restrict who can push to matching branches
  (Opcional - útil para equipes grandes)

Lock branch:
  ☐ Branch is read-only
  (NÃO marcar - impediria merges)

Force pushes:
  ☑ Do not allow force pushes

Deletions:
  ☑ Do not allow deletions
```

#### Avançado (Opcional)

```
☐ Require signed commits
  (Recomendado para produção)

☐ Require deployments to succeed before merging
  (Se usar GitHub Deployments)

☐ Lock branch
  (Apenas para branches arquivadas)
```

### Salvar

Clique em "Create" ou "Save changes"

---

## Passo 3: Criar Estrutura de CI/CD (Opcional mas Recomendado)

### 3.1. Criar Diretório de Workflows

```bash
mkdir -p .github/workflows
```

### 3.2. Criar Workflow Básico de CI

Criar arquivo `.github/workflows/ci.yml`:

```yaml
name: Continuous Integration

on:
  pull_request:
    branches: [ main ]
  push:
    branches: [ main ]

jobs:
  lint-python:
    name: Lint Python Files
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.x'

      - name: Check Python syntax
        run: |
          # Verifica sintaxe de todos os arquivos Python
          find . -name "*.py" -exec python -m py_compile {} \;

  lint-bash:
    name: Lint Bash Scripts
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Check Bash scripts
        run: |
          # Verifica sintaxe de scripts bash
          find ./scripts -name "*.sh" -exec bash -n {} \;

  check-structure:
    name: Check Repository Structure
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Verify required files
        run: |
          # Verifica arquivos essenciais
          test -f README.md || exit 1
          test -f .env.example || exit 1
          test -d projects || exit 1
          test -d docs || exit 1
          echo "✅ All required files present"
```

### 3.3. Criar Workflow de Validação de PRs

Criar arquivo `.github/workflows/pr-validation.yml`:

```yaml
name: PR Validation

on:
  pull_request:
    types: [opened, synchronize, reopened]

jobs:
  pr-title-check:
    name: Check PR Title Format
    runs-on: ubuntu-latest

    steps:
      - name: Validate PR title
        uses: amannn/action-semantic-pull-request@v5
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          types: |
            feat
            fix
            docs
            style
            refactor
            perf
            test
            build
            ci
            chore
          requireScope: false

  pr-size-check:
    name: Check PR Size
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Check PR size
        run: |
          # Conta linhas modificadas
          LINES_CHANGED=$(git diff --shortstat origin/main | grep -oE '[0-9]+ insertion|[0-9]+ deletion' | awk '{sum+=$1} END {print sum}')

          if [ "$LINES_CHANGED" -gt 500 ]; then
            echo "⚠️  PR is large ($LINES_CHANGED lines). Consider splitting."
          else
            echo "✅ PR size is reasonable ($LINES_CHANGED lines)"
          fi
```

### 3.4. Habilitar Status Checks na Branch Protection

Depois de criar os workflows:

1. Vá para Settings > Branches > Edit rule for "main"
2. Marque: ☑ Require status checks to pass before merging
3. Busque e adicione:
   - `Lint Python Files`
   - `Lint Bash Scripts`
   - `Check Repository Structure`
4. Salve as mudanças

---

## Passo 4: Criar CODEOWNERS (Opcional)

### 4.1. Criar Arquivo

```bash
mkdir -p .github
touch .github/CODEOWNERS
```

### 4.2. Configurar Proprietários

Editar `.github/CODEOWNERS`:

```
# Proprietário padrão de tudo
* @fernandes01032000

# Projetos específicos
/projects/sandra-api-scanner/ @fernandes01032000
/projects/test-tools/ @fernandes01032000

# Documentação
/docs/ @fernandes01032000

# Scripts de instalação (críticos)
/scripts/installation/ @fernandes01032000

# Configuração de ambiente
.env.example @fernandes01032000
.mcp.json @fernandes01032000

# CI/CD
/.github/ @fernandes01032000
```

### 4.3. Habilitar Code Owners Review

1. Settings > Branches > Edit rule for "main"
2. Em "Require a pull request before merging"
3. Marque: ☑ Require review from Code Owners
4. Salve

---

## Passo 5: Testar a Configuração

### 5.1. Criar Branch de Teste

```bash
# Criar branch de teste
git checkout -b test/branch-protection

# Fazer uma mudança pequena
echo "# Test" >> TEST.md
git add TEST.md
git commit -m "test: verify branch protection"

# Push para remote
git push -u origin test/branch-protection
```

### 5.2. Criar Pull Request

1. Vá para GitHub
2. Crie PR de `test/branch-protection` para `main`
3. Verifique que:
   - ❌ Não é possível fazer merge direto (se configurado)
   - ⏳ Checks estão rodando (se CI/CD configurado)
   - 👤 Revisão é necessária (se configurado)

### 5.3. Tentar Push Direto (Deve Falhar)

```bash
# Checkout para main
git checkout main

# Tentar fazer mudança direta
echo "# Direct change" >> TEST.md
git add TEST.md
git commit -m "test: direct push"
git push

# Resultado esperado:
# ❌ Erro: branch protection rules
```

---

## Passo 6: Limpeza e Manutenção

### Limpar Branches Antigas do Claude

```bash
# Listar branches remotas do tipo claude/*
git branch -r | grep "origin/claude/"

# Deletar branches específicas já mergeadas
git push origin --delete claude/create-project-template-011CUYBQBNDpBtu2YaapA5Gz
git push origin --delete claude/organize-repository-011CUY98Ck95Bxf3GGCVSNZd

# Limpar referências locais
git remote prune origin
```

### Script de Limpeza Automática

Criar `scripts/utilities/cleanup-merged-branches.sh`:

```bash
#!/bin/bash

# Script para limpar branches do Claude já mergeadas

echo "🧹 Limpando branches mergeadas do Claude..."

# Listar branches remotas do Claude
BRANCHES=$(git branch -r --merged main | grep "origin/claude/" | sed 's|origin/||')

if [ -z "$BRANCHES" ]; then
    echo "✅ Nenhuma branch para limpar"
    exit 0
fi

echo "Branches encontradas para deleção:"
echo "$BRANCHES"
echo ""

read -p "Deletar estas branches? (y/N) " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "$BRANCHES" | while read branch; do
        echo "Deletando: $branch"
        git push origin --delete "$branch"
    done

    echo "🧹 Limpando referências locais..."
    git remote prune origin

    echo "✅ Limpeza concluída!"
else
    echo "❌ Operação cancelada"
fi
```

---

## Checklist de Implementação

### Fase 1: Básico
- [ ] Criar branch `main`
- [ ] Definir `main` como branch padrão
- [ ] Configurar branch protection para `main`
  - [ ] Require pull requests
  - [ ] Require 1 approval
  - [ ] Require conversation resolution
  - [ ] Block force pushes
  - [ ] Block deletions

### Fase 2: CI/CD
- [ ] Criar `.github/workflows/`
- [ ] Adicionar workflow de CI básico
- [ ] Adicionar workflow de validação de PRs
- [ ] Habilitar status checks na branch protection

### Fase 3: Avançado
- [ ] Criar arquivo CODEOWNERS
- [ ] Habilitar review de Code Owners
- [ ] Configurar signed commits (opcional)
- [ ] Criar script de limpeza de branches

### Fase 4: Testes
- [ ] Testar criação de PR
- [ ] Verificar que push direto é bloqueado
- [ ] Confirmar que checks rodam automaticamente
- [ ] Validar que aprovação é necessária

---

## Solução de Problemas

### Problema: "Branch protection rule already exists"

**Solução:**
1. Vá para Settings > Branches
2. Delete a regra "auto/claude-code"
3. Crie nova regra para "main"

### Problema: "Required status check is not enabled"

**Solução:**
1. Certifique-se que os workflows em `.github/workflows/` foram commitados
2. Execute os workflows pelo menos uma vez
3. Os checks aparecerão disponíveis para seleção

### Problema: "Cannot push to protected branch"

**Solução:**
- Isso é esperado! Use o fluxo de Pull Request:
  1. Crie branch: `git checkout -b feature/my-feature`
  2. Faça commits
  3. Push: `git push -u origin feature/my-feature`
  4. Crie PR no GitHub
  5. Aguarde aprovação e merge

### Problema: Workflows não estão rodando

**Solução:**
1. Verifique sintaxe YAML: https://www.yamllint.com/
2. Verifique permissões em Settings > Actions > General
3. Certifique-se que Actions está habilitado para o repositório

---

## Recursos Adicionais

### Documentação GitHub
- [Protected Branches](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches)
- [GitHub Actions](https://docs.github.com/en/actions)
- [CODEOWNERS](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners)

### Exemplos de Workflows
- [Awesome Actions](https://github.com/sdras/awesome-actions)
- [GitHub Actions Examples](https://github.com/actions/starter-workflows)

### Ferramentas
- [YAML Validator](https://www.yamllint.com/)
- [GitHub Actions Toolkit](https://github.com/actions/toolkit)

---

## Próximos Passos Recomendados

1. **Curto Prazo (Esta Semana)**
   - Criar branch `main`
   - Configurar proteção básica
   - Testar fluxo de PR

2. **Médio Prazo (Este Mês)**
   - Implementar CI/CD básico
   - Adicionar CODEOWNERS
   - Treinar equipe no novo fluxo

3. **Longo Prazo (Próximos Meses)**
   - Adicionar testes automáticos
   - Configurar deployments automáticos
   - Implementar code coverage tracking
   - Adicionar security scanning

---

**Data de Criação:** 2025-10-28
**Última Atualização:** 2025-10-28
**Autor:** Claude Code Analysis
