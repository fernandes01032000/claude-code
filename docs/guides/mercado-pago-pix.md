# Mercado Pago PIX API

## Overview
The Mercado Pago PIX API enables QR code generation and instant payment collection in Brazil using the PIX rails. This guide summarizes the key REST resources exposed by Mercado Pago and explains how to mirror the official documentation inside this repository for offline consultation.

## Official Documentation Sources
- PIX overview: https://www.mercadopago.com.br/developers/pt/docs/checkout-api/integration-configuration/qr-code
- Payments endpoint reference: https://www.mercadopago.com.br/developers/pt/reference/payments/_payments/post
- Webhooks: https://www.mercadopago.com.br/developers/pt/docs/checkout-api/additional-content/notifications/webhooks

To archive the docs locally, download the HTML or PDF versions of these pages (using `wget`, `curl`, or your browser) and store them under `docs/external/mercadopago/` if you prefer preserving the raw assets. The Markdown file you are reading keeps a concise, Claude-friendly summary.

## Authentication and Headers
```http
Authorization: Bearer <ACCESS_TOKEN>
Content-Type: application/json
X-Idempotency-Key: <UUID>
```
Access tokens are generated in the Mercado Pago Developer Dashboard for the relevant environment (sandbox or production). Idempotency keys are optional but recommended when retrying payment creation calls.

## Key Endpoints
| Endpoint | Method | Description |
|----------|--------|-------------|
| `/v1/payments` | `POST` | Creates a payment. Use `payment_method_id` = `pix` to issue a PIX charge. |
| `/v1/payments/{id}` | `GET` | Retrieves the status and PIX payload for a payment. |
| `/v1/payments/search` | `GET` | Filters existing payments by status, creation date, etc. |
| `/v1/payment_methods` | `GET` | Lists enabled payment methods including PIX configuration. |

### Create PIX Payment
```json
POST https://api.mercadopago.com/v1/payments
{
  "transaction_amount": 150.00,
  "description": "Pedido #12345",
  "payment_method_id": "pix",
  "payer": {
    "email": "cliente@example.com",
    "first_name": "Joana",
    "last_name": "Silva",
    "identification": {
      "type": "CPF",
      "number": "19119119100"
    }
  }
}
```

### Response Fields of Interest
- `id`: internal Mercado Pago identifier for the payment.
- `status`: `pending`, `approved`, `cancelled`, etc.
- `point_of_interaction.transaction_data.qr_code`: static string representation of the PIX payload.
- `point_of_interaction.transaction_data.qr_code_base64`: Base64 encoded QR image suitable for immediate display.
- `date_of_expiration`: expiration timestamp for the PIX code.

## Webhooks and Notifications
Configure your webhook URL in the Mercado Pago dashboard. PIX payment events emit a `payment` topic with action types such as `payment.created`, `payment.updated`, and `payment.pending`. Validate the `x-signature` header for security.

### Security Checklist
- Verify JWT signature when using notifications with the new signature scheme.
- Double-check payment status with `GET /v1/payments/{id}` before provisioning goods.
- Store only the metadata required for reconciliation to stay compliant with LGPD.

## Sandbox vs Production
Sandbox PIX payments simulate approval asynchronously. Use the Mercado Pago dashboard to trigger status transitions or query the payment history to confirm the simulated payment.

## Change Log Tracking
Record the documentation version and the date downloaded inside `docs/CHANGELOG.md` (append-only) so future updates can be tracked.
