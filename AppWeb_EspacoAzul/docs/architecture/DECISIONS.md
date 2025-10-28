# Decisões de Arquitetura

Este documento registra decisões importantes de arquitetura e design do projeto.

## Formato

Cada decisão segue o formato:

```markdown
## [Data] - Título da Decisão

**Status**: Aceito | Proposto | Rejeitado | Substituído

**Contexto**: Por que essa decisão foi necessária?

**Decisão**: O que foi decidido?

**Consequências**: Quais os impactos dessa decisão?

**Alternativas Consideradas**: Quais outras opções foram avaliadas?
```

---

## Template para Novas Decisões

```markdown
## [YYYY-MM-DD] - Título da Decisão

**Status**: Proposto

**Contexto**:
Descreva o problema ou necessidade que motivou esta decisão.

**Decisão**:
Descreva a solução escolhida e como ela será implementada.

**Consequências**:
- Positivas:
  - ...
- Negativas:
  - ...
- Neutras:
  - ...

**Alternativas Consideradas**:
1. Alternativa A - Por que não foi escolhida
2. Alternativa B - Por que não foi escolhida

**Referências**:
- Links relevantes
- Documentação
```

---

## Exemplo: Estrutura de Pastas

**Status**: Aceito

**Contexto**:
Precisávamos de uma estrutura de pastas clara e organizada que suportasse diferentes tipos de projetos (API, web, CLI, scripts) e que fosse fácil de entender para novos desenvolvedores.

**Decisão**:
Adotar uma estrutura baseada em funcionalidade com separação clara:
- `src/` - Código fonte
- `docs/` - Documentação
- `scripts/` - Scripts auxiliares
- `tests/` - Testes
- `config/` - Configurações
- `.secrets-template/` - Templates de secrets

**Consequências**:
- Positivas:
  - Fácil navegação
  - Separação clara de responsabilidades
  - Escalável para projetos grandes
  - Facilita onboarding de novos devs

- Negativas:
  - Pode parecer complexa para projetos muito simples
  - Algumas pastas podem ficar vazias em projetos pequenos

- Neutras:
  - Requer documentação clara

**Alternativas Consideradas**:
1. Estrutura flat (todos arquivos na raiz) - Rejeitada por não escalar
2. Estrutura por tecnologia - Rejeitada por não ser flexível o suficiente

---

## Exemplo: Gerenciamento de Secrets

**Status**: Aceito

**Contexto**:
Secrets e credenciais precisam ser gerenciados de forma segura, sem risco de serem commitados acidentalmente no git.

**Decisão**:
Usar uma combinação de:
1. `.env` para variáveis de ambiente de desenvolvimento
2. `.secrets/` para arquivos de configuração sensíveis (gitignored)
3. `.secrets-template/` para templates e documentação
4. Validação no CI/CD para garantir que secrets não sejam commitados

**Consequências**:
- Positivas:
  - Secrets nunca são commitados
  - Templates ajudam novos desenvolvedores
  - Flexível para diferentes tipos de secrets
  - Suporta múltiplos ambientes (dev/staging/prod)

- Negativas:
  - Desenvolvedores precisam configurar manualmente
  - Possível confusão inicial

- Neutras:
  - Requer boa documentação

**Alternativas Consideradas**:
1. Apenas .env - Muito limitado para projetos complexos
2. HashiCorp Vault - Ótimo mas complexo demais para começar
3. Git-crypt - Adiciona complexidade desnecessária

**Referências**:
- [12 Factor App - Config](https://12factor.net/config)
- [OWASP Secrets Management](https://owasp.org/www-community/vulnerabilities/Use_of_hard-coded_password)

---

## Como Adicionar uma Nova Decisão

1. Copie o template acima
2. Preencha todos os campos
3. Discuta com a equipe (se aplicável)
4. Adicione ao documento
5. Referencie no código ou documentação quando relevante
