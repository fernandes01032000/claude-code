# Schema do Banco de Dados Supabase

## 📊 Tabelas Disponíveis

### 1. **empresas** (Empresas/Negócios)
Tabela principal de empresas no sistema.

**Campos principais:**
- `id` (UUID) - Primary Key
- `owner_uid` (UUID) - Dono da empresa
- `nome` (text) - Nome da empresa
- `whatsapp_numero` (text) - Número WhatsApp
- `evolution_instance_id` (text) - ID da instância Evolution API
- `evolution_token` (text) - Token Evolution API
- `mp_access_token` (text) - Token Mercado Pago
- `mp_user_id` (text) - User ID Mercado Pago
- `status` (text) - Status (default: 'inativo')
- `nicho` (text) - Nicho do negócio
- `onboarding_step` (integer) - Passo do onboarding (default: 1)
- `created_at`, `updated_at` (timestamp)

---

### 2. **servicos** (Serviços)
Serviços oferecidos pelas empresas.

**Campos principais:**
- `id` (UUID) - Primary Key
- `empresa_id` (UUID) - Foreign Key → empresas.id
- `nome` (text) - Nome do serviço
- `preco_cents` (integer) - Preço em centavos (default: 0)
- `duracao_min` (integer) - Duração em minutos (default: 30)
- `ativo` (boolean) - Se está ativo (default: true)
- `ordem` (integer) - Ordem de exibição (default: 0)
- `created_at`, `updated_at` (timestamp)

---

### 3. **clientes** (Clientes)
Clientes das empresas.

**Campos principais:**
- `id` (UUID) - Primary Key
- `empresa_id` (UUID) - Foreign Key → empresas.id
- `nome` (text) - Nome do cliente
- `whatsapp` (text) - WhatsApp (required)
- `email` (text) - Email
- `tags` (text[]) - Array de tags
- `ultimo_contato` (timestamp) - Último contato
- `created_at`, `updated_at` (timestamp)

---

### 4. **agendamentos** (Agendamentos)
Agendamentos de serviços pelos clientes.

**Campos principais:**
- `id` (UUID) - Primary Key
- `empresa_id` (UUID) - Foreign Key → empresas.id
- `servico_id` (UUID) - Foreign Key → servicos.id
- `cliente_id` (UUID) - Foreign Key → clientes.id
- `cliente_nome` (text) - Nome do cliente
- `cliente_whatsapp` (text) - WhatsApp do cliente
- `inicio` (timestamp) - Horário de início
- `duracao_min` (integer) - Duração em minutos
- `status` (text) - Status (default: 'pendente')
- `pagamento_id` (UUID) - ID do pagamento
- `notas` (text) - Notas adicionais
- `created_at`, `updated_at` (timestamp)

---

### 5. **horarios** (Horários de Funcionamento)
Horários de funcionamento das empresas.

**Campos principais:**
- `id` (UUID) - Primary Key
- `empresa_id` (UUID) - Foreign Key → empresas.id
- `dia_semana` (smallint) - Dia da semana (0-6)
- `inicio` (time) - Horário de início
- `fim` (time) - Horário de fim
- `intervalo_min` (integer) - Intervalo entre slots (default: 10)
- `ativo` (boolean) - Se está ativo (default: true)
- `created_at` (timestamp)

---

### 6. **pagamentos** (Pagamentos)
Pagamentos via Mercado Pago.

**Campos principais:**
- `id` (UUID) - Primary Key
- `empresa_id` (UUID) - Foreign Key → empresas.id
- `agendamento_id` (UUID) - Foreign Key → agendamentos.id
- `mp_preference_id` (text) - ID da preferência MP
- `mp_payment_id` (text) - ID do pagamento MP
- `valor_cents` (integer) - Valor em centavos
- `status` (text) - Status (default: 'pendente')
- `link_pagamento` (text) - Link do pagamento
- `qr_code_base64` (text) - QR Code em base64
- `raw_data` (jsonb) - Dados brutos do MP
- `created_at`, `updated_at` (timestamp)

---

### 7. **nicho_templates** (Templates por Nicho)
Templates pré-configurados por nicho de negócio.

**Campos principais:**
- `id` (UUID) - Primary Key
- `nicho` (text) - Nome do nicho
- `emoji` (text) - Emoji representativo
- `servicos_padrao` (jsonb) - Serviços padrão
- `horarios_padrao` (text[]) - Horários padrão
- `mensagem_boas_vindas` (text) - Mensagem de boas-vindas
- `created_at` (timestamp)

---

### 8. **faq_entries** (FAQ)
Entradas de perguntas frequentes.

**Campos principais:**
- `id` (UUID) - Primary Key
- `empresa_id` (UUID) - Foreign Key → empresas.id
- `pergunta` (text) - Pergunta
- `resposta` (text) - Resposta
- `ativo` (boolean) - Se está ativo (default: true)
- `ordem` (integer) - Ordem de exibição (default: 0)
- `created_at`, `updated_at` (timestamp)

---

### 9. **logs** (Logs do Sistema)
Logs de atividades e eventos.

**Campos principais:**
- `id` (bigint) - Primary Key
- `empresa_id` (UUID) - Foreign Key → empresas.id
- `nivel` (text) - Nível do log (info, warning, error)
- `origem` (text) - Origem do log
- `mensagem` (text) - Mensagem
- `payload` (jsonb) - Dados adicionais
- `created_at` (timestamp)

---

## 🔧 Funções RPC (Remote Procedure Calls)

### **try_book_slot**
Tenta reservar um horário de agendamento.

**Parâmetros:**
- `p_empresa_id` (UUID) - ID da empresa
- `p_servico_id` (UUID) - ID do serviço
- `p_cliente_id` (UUID) - ID do cliente
- `p_cliente_nome` (text) - Nome do cliente
- `p_cliente_whatsapp` (text) - WhatsApp do cliente
- `p_inicio` (timestamp) - Horário de início
- `p_duracao_min` (integer) - Duração em minutos

**Uso:** Verifica disponibilidade e cria o agendamento atomicamente.

---

## 📈 Relacionamentos

```
empresas (1) ────┬──→ (N) servicos
                 ├──→ (N) clientes
                 ├──→ (N) agendamentos
                 ├──→ (N) horarios
                 ├──→ (N) pagamentos
                 ├──→ (N) faq_entries
                 └──→ (N) logs

servicos (1) ────→ (N) agendamentos
clientes (1) ────→ (N) agendamentos
agendamentos (1) ─→ (1) pagamentos
```

---

## 🎯 Integrações Identificadas

### 1. **Evolution API** (WhatsApp)
- Campos em `empresas`: `evolution_instance_id`, `evolution_token`
- Usado para automação de mensagens WhatsApp

### 2. **Mercado Pago** (Pagamentos)
- Campos em `empresas`: `mp_access_token`, `mp_user_id`
- Campos em `pagamentos`: `mp_preference_id`, `mp_payment_id`, etc.
- Gera links e QR codes para pagamento

### 3. **Sistema de Autenticação**
- Campo `owner_uid` em empresas (provavelmente Supabase Auth)

---

## 💡 Possíveis Automações com n8n

### 1. **Confirmação de Agendamento**
```
Trigger: Novo registro em 'agendamentos'
→ Buscar dados da empresa
→ Enviar mensagem WhatsApp via Evolution API
→ Criar pagamento no Mercado Pago
→ Enviar link de pagamento ao cliente
```

### 2. **Lembrete de Agendamento**
```
Trigger: Cron (diário)
→ Buscar agendamentos nas próximas 24h
→ Para cada agendamento:
  → Enviar lembrete via WhatsApp
  → Verificar status do pagamento
```

### 3. **Processamento de Pagamentos**
```
Webhook: Mercado Pago IPN
→ Atualizar status em 'pagamentos'
→ Atualizar status em 'agendamentos'
→ Enviar confirmação ao cliente via WhatsApp
→ Registrar log
```

### 4. **FAQ Automático**
```
Webhook: Mensagem WhatsApp recebida
→ Buscar em 'faq_entries'
→ Se encontrar resposta:
  → Enviar resposta automática
→ Se não encontrar:
  → Encaminhar para atendimento humano
```

### 5. **Relatório Diário**
```
Trigger: Cron (diário às 9h)
→ Buscar agendamentos do dia
→ Buscar pagamentos pendentes
→ Gerar relatório
→ Enviar para o WhatsApp do dono
```

---

## 🔐 Segurança

### Campos Sensíveis (nunca exibir):
- `evolution_token`
- `mp_access_token`
- `mp_user_id`

### Row Level Security (RLS)
Configure RLS policies no Supabase para garantir que:
- Empresas só acessem seus próprios dados
- Clientes só vejam seus próprios agendamentos
- Logs sejam read-only via API

---

## 📝 Queries Úteis

### Listar empresas ativas:
```bash
curl "${SUPABASE_URL}/rest/v1/empresas?status=eq.ativo" \
  -H "apikey: ${SUPABASE_SERVICE_ROLE_KEY}" \
  -H "Authorization: Bearer ${SUPABASE_SERVICE_ROLE_KEY}"
```

### Buscar agendamentos de hoje:
```bash
curl "${SUPABASE_URL}/rest/v1/agendamentos?inicio=gte.$(date -u +%Y-%m-%dT00:00:00Z)&inicio=lt.$(date -u -d tomorrow +%Y-%m-%dT00:00:00Z)" \
  -H "apikey: ${SUPABASE_SERVICE_ROLE_KEY}" \
  -H "Authorization: Bearer ${SUPABASE_SERVICE_ROLE_KEY}"
```

### Criar um novo agendamento:
```bash
curl -X POST "${SUPABASE_URL}/rest/v1/agendamentos" \
  -H "apikey: ${SUPABASE_SERVICE_ROLE_KEY}" \
  -H "Authorization: Bearer ${SUPABASE_SERVICE_ROLE_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "empresa_id": "uuid-aqui",
    "servico_id": "uuid-aqui",
    "cliente_nome": "João",
    "cliente_whatsapp": "5511999999999",
    "inicio": "2025-10-23T10:00:00Z",
    "duracao_min": 30,
    "status": "pendente"
  }'
```
