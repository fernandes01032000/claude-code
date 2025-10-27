# Resumo Rápido – Mercado Pago PIX

## Objetivo
Centralizar as etapas críticas para criar cobranças PIX usando a API do Mercado Pago e indicar como baixar a documentação oficial para uso offline.

## Passos para baixar a documentação
1. Acesse a página oficial de QR Code PIX: https://www.mercadopago.com.br/developers/pt/docs/checkout-api/integration-configuration/qr-code
2. Utilize `wget -E -H -k -p <URL>` ou a opção "Salvar como PDF" do navegador para obter uma cópia local.
3. Salve os arquivos em `docs/external/mercadopago/` mantendo a data do download no nome do arquivo.

## Fluxo Básico da Cobrança
1. Obter o `ACCESS_TOKEN` no painel de desenvolvedor.
2. Fazer `POST /v1/payments` com `payment_method_id = "pix"`.
3. Exibir o QR Code usando `point_of_interaction.transaction_data.qr_code_base64`.
4. Monitorar o pagamento via Webhooks (`payment.updated`).
5. Confirmar o status com `GET /v1/payments/{id}` antes de liberar o serviço.

## Campos Importantes
- `transaction_amount`: valor a cobrar.
- `payer.identification`: CPF/CNPJ obrigatório em produção.
- `date_of_expiration`: validade do QR Code (padrão ~30 minutos, configurável).

## Segurança
- Configure o webhook com HTTPS e valide o header `x-signature`.
- Guarde logs de idempotência para evitar cobranças duplicadas.
- Revogue tokens comprometidos imediatamente no painel.
