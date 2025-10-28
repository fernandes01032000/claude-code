# Gerenciamento de Secrets e Senhas

## IMPORTANTE: NUNCA COMMITAR SECRETS REAIS!

Esta pasta contém apenas templates. Os arquivos reais de secrets devem ser:
1. Criados na pasta `.secrets/` (que está no .gitignore)
2. Armazenados em gerenciadores de senhas (1Password, LastPass, etc)
3. Usar variáveis de ambiente (.env)
4. Usar serviços de vault (HashiCorp Vault, AWS Secrets Manager, etc)

## Estrutura Recomendada

```
.secrets/              # Pasta real (NÃO commitada)
├── development/
│   ├── database.json
│   ├── api-keys.json
│   └── certificates/
├── staging/
│   └── ...
└── production/
    └── ...
```

## Como Usar

1. Copie os templates para `.secrets/`
2. Preencha com valores reais
3. Configure permissões: `chmod 600 .secrets/**/*`
4. Use em seu código através de variáveis de ambiente

## Boas Práticas

- ✅ Use .env para desenvolvimento local
- ✅ Use vault/secrets manager para produção
- ✅ Rotacione senhas regularmente
- ✅ Use diferentes credenciais por ambiente
- ❌ NUNCA commite senhas no git
- ❌ NUNCA compartilhe .env files
- ❌ NUNCA use senhas em código
