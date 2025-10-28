# Integração com Stripe (Exemplo)

## Visão Geral
Integração com Stripe para processamento de pagamentos online.

## Autenticação
- Tipo: API Key (Secret Key para backend, Publishable Key para frontend)
- Onde obter: https://dashboard.stripe.com/apikeys
- Modo Test: Use chaves começando com `sk_test_` e `pk_test_`
- Modo Produção: Use chaves começando com `sk_live_` e `pk_live_`

## Configuração

### Variáveis de Ambiente
```env
STRIPE_SECRET_KEY=sk_test_YOUR_SECRET_KEY_HERE
STRIPE_PUBLISHABLE_KEY=pk_test_YOUR_PUBLISHABLE_KEY_HERE
STRIPE_WEBHOOK_SECRET=whsec_YOUR_WEBHOOK_SECRET_HERE
```

### Instalação
```bash
npm install stripe
```

### Código de Configuração
```javascript
// src/services/stripe.js
const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);

module.exports = stripe;
```

## Endpoints Principais

### Criar Payment Intent

**Código:**
```javascript
const paymentIntent = await stripe.paymentIntents.create({
  amount: 2000, // em centavos
  currency: 'brl',
  payment_method_types: ['card'],
  metadata: {
    order_id: '123456'
  }
});
```

**Response:**
```json
{
  "id": "pi_XXXXXXXXXXXXX",
  "amount": 2000,
  "currency": "brl",
  "status": "requires_payment_method",
  "client_secret": "pi_XXX_secret_XXX"
}
```

### Criar Cliente

```javascript
const customer = await stripe.customers.create({
  email: 'cliente@example.com',
  name: 'João Silva',
  metadata: {
    user_id: '789'
  }
});
```

### Criar Subscription

```javascript
const subscription = await stripe.subscriptions.create({
  customer: customer.id,
  items: [{ price: 'price_XXXXXXXXXXXXX' }],
  payment_behavior: 'default_incomplete',
  expand: ['latest_invoice.payment_intent']
});
```

## Webhooks

### Configuração
1. Acesse: https://dashboard.stripe.com/webhooks
2. Adicione endpoint: `https://seu-app.com/webhooks/stripe`
3. Selecione eventos
4. Copie o signing secret para `STRIPE_WEBHOOK_SECRET`

### Implementação

```javascript
// src/api/webhooks/stripe.js
const stripe = require('../../services/stripe');
const express = require('express');
const router = express.Router();

router.post('/stripe', express.raw({type: 'application/json'}), async (req, res) => {
  const sig = req.headers['stripe-signature'];

  let event;

  try {
    event = stripe.webhooks.constructEvent(
      req.body,
      sig,
      process.env.STRIPE_WEBHOOK_SECRET
    );
  } catch (err) {
    console.log(`Webhook signature verification failed.`, err.message);
    return res.status(400).send(`Webhook Error: ${err.message}`);
  }

  // Handle the event
  switch (event.type) {
    case 'payment_intent.succeeded':
      const paymentIntent = event.data.object;
      console.log('PaymentIntent was successful!');
      // Atualizar banco de dados
      break;
    case 'payment_intent.payment_failed':
      const failedPayment = event.data.object;
      console.log('Payment failed.');
      // Notificar usuário
      break;
    case 'customer.subscription.created':
      const subscription = event.data.object;
      // Ativar acesso do usuário
      break;
    case 'customer.subscription.deleted':
      const deletedSub = event.data.object;
      // Desativar acesso do usuário
      break;
    default:
      console.log(`Unhandled event type ${event.type}`);
  }

  res.json({received: true});
});

module.exports = router;
```

### Eventos Importantes

| Evento | Descrição | Ação |
|--------|-----------|------|
| `payment_intent.succeeded` | Pagamento confirmado | Liberar pedido |
| `payment_intent.payment_failed` | Pagamento falhou | Notificar usuário |
| `customer.subscription.created` | Assinatura criada | Ativar acesso |
| `customer.subscription.deleted` | Assinatura cancelada | Desativar acesso |
| `invoice.payment_succeeded` | Fatura paga | Renovar serviço |
| `invoice.payment_failed` | Fatura não paga | Alertar usuário |

## Tratamento de Erros

```javascript
try {
  const paymentIntent = await stripe.paymentIntents.create({...});
} catch (error) {
  switch (error.type) {
    case 'StripeCardError':
      // Cartão foi recusado
      console.log('Card error:', error.message);
      break;
    case 'StripeRateLimitError':
      // Muitas requisições
      console.log('Rate limit exceeded');
      break;
    case 'StripeInvalidRequestError':
      // Parâmetros inválidos
      console.log('Invalid parameters:', error.message);
      break;
    case 'StripeAPIError':
      // Erro interno do Stripe
      console.log('Stripe API error');
      break;
    case 'StripeConnectionError':
      // Falha de rede
      console.log('Network error');
      break;
    case 'StripeAuthenticationError':
      // Falha de autenticação
      console.log('Authentication failed - check API key');
      break;
    default:
      console.log('Unknown error:', error);
      break;
  }
}
```

## Rate Limits
- Test mode: Sem limite rígido, mas evite abuso
- Live mode: Dinâmico baseado no histórico da conta
- Recomendação: Implementar retry com backoff exponencial

## Segurança

### ✅ Fazer
- Usar Secret Key apenas no backend
- Validar webhooks usando signature
- Usar HTTPS em produção
- Armazenar chaves em variáveis de ambiente
- Implementar idempotency keys para operações críticas

### ❌ Não Fazer
- Expor Secret Key no frontend
- Commitar chaves no git
- Processar webhooks sem validação
- Usar dados do frontend sem validação

## Teste

### Cartões de Teste
```
Sucesso: 4242 4242 4242 4242
Recusado: 4000 0000 0000 0002
Requer autenticação: 4000 0025 0000 3155
Data de expiração: Qualquer data futura
CVC: Qualquer 3 dígitos
```

### Trigger Webhooks Manualmente
```bash
stripe trigger payment_intent.succeeded
```

## Recursos
- Documentação: https://stripe.com/docs/api
- Dashboard: https://dashboard.stripe.com
- Status: https://status.stripe.com
- CLI: https://stripe.com/docs/stripe-cli
