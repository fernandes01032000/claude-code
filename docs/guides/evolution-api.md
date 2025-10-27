# Evolution API (WhatsApp / Omnichannel)

## Overview
Evolution API is an open-source bridge for automating WhatsApp, Instagram, and other channels through a single REST interface. This guide consolidates the most frequently used endpoints and the official documentation references so the material can be archived in the repository for offline reading.

## Official Documentation Sources
- Main site: https://doc.evolution-api.com/
- REST reference: https://doc.evolution-api.com/reference/introduction
- Webhook events: https://doc.evolution-api.com/docs/webhooks

Download strategy:
1. Mirror the HTML with `wget -E -H -k -p https://doc.evolution-api.com/`.
2. Store the snapshot in `docs/external/evolution-api/<YYYY-MM-DD>/`.
3. Keep this Markdown summary aligned with the downloaded version and add update notes to `docs/CHANGELOG.md`.

## Authentication
Evolution API uses an instance-based token model.

```http
X-Evolution-API-Key: <instance_api_key>
Content-Type: application/json
```

You must create an instance through the provider dashboard or the `/instance/create` endpoint before you can send messages.

## Core Endpoints
| Endpoint | Method | Description |
|----------|--------|-------------|
| `/instance/create` | `POST` | Creates a new messaging instance and returns connection details. |
| `/instance/fetch` | `GET` | Retrieves information about an existing instance. |
| `/message/sendText` | `POST` | Sends a text message to a WhatsApp JID. |
| `/message/sendMedia` | `POST` | Uploads and sends media (images, audio, docs). |
| `/webhook/set` | `POST` | Registers webhook URL for message and status events. |
| `/qr/` | `GET` | Obtains the QR code for pairing the WhatsApp session. |

### Send Text Message
```json
POST https://api.evolution-api.com/message/sendText
{
  "instanceName": "loja-01",
  "to": "5511999990000",
  "text": "Olá! Seu pedido foi recebido."
}
```

### Send Media Message
```json
POST https://api.evolution-api.com/message/sendMedia
{
  "instanceName": "loja-01",
  "to": "5511999990000",
  "mediaType": "image",
  "caption": "Cupom de desconto",
  "mediaUrl": "https://example.com/cupom.png"
}
```

## Webhooks
Evolution API delivers events such as `message.upsert`, `message.status`, and `connection.update`.

Security guidelines:
- Verify the `X-Evolution-Signature` header (HMAC SHA256) when enabled.
- Respond with HTTP 200 to acknowledge receipt.
- Queue heavy processing and avoid blocking the webhook response.

## Session Lifecycle
1. Create an instance.
2. Fetch the QR code and scan it with the WhatsApp app.
3. Monitor `connection.update` events until status becomes `CONNECTED`.
4. Use the messaging endpoints.
5. Delete the instance (`DELETE /instance/delete`) when no longer needed.

## Rate Limits and Best Practices
- Default per-instance throughput is ~50 messages/minute; throttle bursts client-side.
- Cache media uploads and reuse `mediaId` when sending the same asset repeatedly.
- Handle `429 Too Many Requests` by implementing exponential backoff.

## Troubleshooting
- `401 Unauthorized`: token expired or wrong instance key.
- `404 Instance not found`: confirm `instanceName` matches the created instance.
- `423 Instance disconnected`: re-scan the QR code.

## Compliance Notes
WhatsApp automation may require user consent. Follow Meta's commerce and data policies. Store personal data securely and respect opt-out requests.
