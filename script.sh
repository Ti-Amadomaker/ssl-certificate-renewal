#!/bin/bash
# salvar como extract_dns_challenge.sh

sudo certbot certonly --manual --preferred-challenges dns -d amadoplay.amadomaker.com.br -d www.amadoplay.amadomaker.com.br 2>&1 | tee /tmp/certbot_log.txt &
CERTBOT_PID=$!

# Aguarda o arquivo ser criado e monitora por mudanças
while [ ! -f /tmp/certbot_log.txt ]; do
    sleep 1
done

# Extrai os dados DNS quando aparecem
tail -f /tmp/certbot_log.txt | while read line; do
    if [[ $line == *"_acme-challenge"* ]]; then
        echo "DNS Record Name: $line" | grep -o "_acme-challenge[^.]*\.amadoplay\.amadomaker\.com\.br\."
    fi
    if [[ $line =~ ^[A-Za-z0-9_-]{43}$ ]]; then
        echo "DNS Record Value: $line"
    fi
done