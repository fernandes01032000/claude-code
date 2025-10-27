# Guia Completo: Túneis Reversos e Instalação do Node.js

## Problema Identificado

Você está enfrentando dois problemas:
1. **Erro 429** ao tentar instalar nvm (rate limiting do GitHub)
2. **Sem permissões sudo** para instalar pacotes do sistema
3. **Dúvida sobre túneis reversos** para expor serviços locais

---

## Solução 1: Instalar Node.js Manualmente

### Passo 1: Executar o script de instalação

```bash
# No seu terminal (saladeestudos@localhost)
cd ~
bash ~/install-node-manual.sh
```

### Passo 2: Configurar o PATH

```bash
# Adicionar ao ~/.bashrc
echo 'export PATH="$HOME/node/bin:$PATH"' >> ~/.bashrc

# Recarregar o bashrc
source ~/.bashrc
```

### Passo 3: Verificar instalação

```bash
node -v    # Deve mostrar v22.21.0
npm -v     # Deve mostrar 10.9.4
```

---

## Solução 2: Túneis Reversos

### Opção A: SSH Reverse Tunnel (Você já tem servidor!)

Você já tentou usar: `ssh -R 3000:localhost:3000 root@212.85.12.78`

**Como usar corretamente:**

```bash
# Expor porta local 3000 na porta 8080 do servidor remoto
ssh -N -R 8080:localhost:3000 root@212.85.12.78

# Depois acesse: http://212.85.12.78:8080
```

**Explicação:**
- `-N`: Não executar comandos remotos
- `-R 8080:localhost:3000`: Redirecionar porta 8080 do servidor para sua porta 3000 local

**Importante:** Verifique se `GatewayPorts yes` está habilitado no `/etc/ssh/sshd_config` do servidor.

### Opção B: Cloudflare Tunnel (Recomendado para produção)

**Vantagens:**
- ✅ HTTPS automático
- ✅ Sem necessidade de abrir portas
- ✅ Proteção DDoS
- ✅ Gratuito

**Instalação (sem sudo):**

```bash
# Baixar cloudflared
cd ~/
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
chmod +x cloudflared-linux-amd64
mv cloudflared-linux-amd64 node/bin/cloudflared

# Usar
cloudflared tunnel --url http://localhost:3000
```

### Opção C: localtunnel (Mais simples com Node.js)

```bash
# Após instalar Node.js
npx localtunnel --port 3000

# Ou instalar globalmente
npm install -g localtunnel
lt --port 3000
```

**Você receberá uma URL como:** `https://abc-123.loca.lt`

### Opção D: serveo (Sem cadastro, apenas SSH)

```bash
# Expor porta 3000 publicamente
ssh -R 80:localhost:3000 serveo.net

# Com subdomínio personalizado
ssh -R meuapp:80:localhost:3000 serveo.net
# Acesse: https://meuapp.serveo.net
```

### Opção E: ngrok (Popular, plano gratuito)

```bash
# Baixar
wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
tar xvzf ngrok-v3-stable-linux-amd64.tgz
mv ngrok ~/node/bin/

# Cadastrar em: https://dashboard.ngrok.com/signup
# Configurar token
ngrok config add-authtoken SEU_TOKEN

# Usar
ngrok http 3000
```

---

## Comparação das Soluções

| Solução | Gratuito | HTTPS | Setup | Velocidade | Uso Recomendado |
|---------|----------|-------|-------|------------|-----------------|
| SSH Reverse | ✅ | ⚠️ Manual | Médio | ⭐⭐⭐⭐⭐ | Intranet/VPN |
| Cloudflare | ✅ | ✅ | Médio | ⭐⭐⭐⭐ | Produção |
| localtunnel | ✅ | ✅ | Fácil | ⭐⭐⭐ | Desenvolvimento |
| serveo | ✅ | ✅ | Muito Fácil | ⭐⭐⭐ | Testes rápidos |
| ngrok | ⚠️ Limitado | ✅ | Fácil | ⭐⭐⭐⭐ | Desenvolvimento |

---

## Solução Rápida para Seu Caso

Baseado no seu log, recomendo:

### 1. Instalar Node.js manualmente (script fornecido)

```bash
bash ~/install-node-manual.sh
source ~/.bashrc
```

### 2. Usar serveo para teste rápido

```bash
# Terminal 1: Rodar sua aplicação
npm start  # ou node server.js

# Terminal 2: Criar túnel
ssh -R 80:localhost:3000 serveo.net
```

### 3. OU usar seu servidor VPS existente

```bash
# Conectar ao servidor e configurar
ssh root@212.85.12.78
echo "GatewayPorts yes" >> /etc/ssh/sshd_config
systemctl restart sshd
exit

# Criar túnel
ssh -N -R 8080:localhost:3000 root@212.85.12.78

# Acessar: http://212.85.12.78:8080
```

---

## Segurança

⚠️ **Importante:** Ao expor serviços localmente:

1. **Use autenticação:** Sempre adicione senha/token
2. **HTTPS:** Prefira túneis com HTTPS automático
3. **Firewall:** Configure regras adequadas no servidor
4. **Logs:** Monitore acessos suspeitos
5. **Rate limiting:** Implemente limites de requisições

---

## Comandos Úteis

```bash
# Ver processos SSH
ps aux | grep ssh

# Matar túnel SSH
pkill -f "ssh -R"

# Testar conexão local
curl http://localhost:3000

# Ver portas em uso
netstat -tuln | grep LISTEN
# ou
ss -tuln | grep LISTEN
```

---

## Troubleshooting

### Node.js não encontrado após instalação
```bash
export PATH="$HOME/node/bin:$PATH"
source ~/.bashrc
```

### Túnel SSH cai após alguns minutos
```bash
# Adicionar keepalive
ssh -R 8080:localhost:3000 -o ServerAliveInterval=60 root@212.85.12.78
```

### Erro de permissão no servidor
```bash
# No servidor remoto, editar /etc/ssh/sshd_config
GatewayPorts yes
AllowTcpForwarding yes
```

---

## Recursos Adicionais

- [Cloudflare Tunnel Docs](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/)
- [SSH Tunneling Guide](https://www.ssh.com/academy/ssh/tunneling)
- [ngrok Documentation](https://ngrok.com/docs)
- [localtunnel GitHub](https://github.com/localtunnel/localtunnel)

---

## Próximos Passos

1. ✅ Instalar Node.js usando o script `install-node-manual.sh`
2. ✅ Escolher uma solução de túnel (recomendo serveo ou seu VPS)
3. ✅ Testar com aplicação local
4. ✅ Implementar segurança adequada
