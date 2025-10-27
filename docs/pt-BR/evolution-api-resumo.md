# Resumo Rápido – Evolution API

## Objetivo
Registrar os passos mínimos para colocar uma instância Evolution API em operação e orientar sobre como manter uma cópia local da documentação.

## Como baixar a documentação
1. Abra https://doc.evolution-api.com/ no navegador.
2. Utilize a função "Imprimir" → "Salvar como PDF" para cada seção principal (Introdução, Referência, Webhooks).
3. Salve em `docs/external/evolution-api/` com a data no nome (`evolution-api-doc-2024-05-01.pdf`).

## Passos de Configuração
1. Criar instância com `POST /instance/create` (informe `instanceName` único).
2. Escanear o QR Code retornado em `/qr/` com o WhatsApp Business ou WhatsApp comum vinculado ao número desejado.
3. Configurar o Webhook com `POST /webhook/set` apontando para seu endpoint HTTPS.
4. Enviar mensagens usando `/message/sendText` ou `/message/sendMedia`.

## Eventos de Webhook
- `message.upsert`: mensagem recebida/enviada.
- `message.status`: confirmações de entrega.
- `connection.update`: status da sessão (ex.: `CONNECTED`, `DISCONNECTED`).

## Boas Práticas
- Armazene o token (`X-Evolution-API-Key`) em um cofre de segredos.
- Implemente retentativas com backoff exponencial para erros 429.
- Desconecte (`DELETE /instance/delete`) instâncias não utilizadas para evitar bloqueios.
