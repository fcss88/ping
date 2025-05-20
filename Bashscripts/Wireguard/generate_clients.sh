#!/bin/bash

CLIENTS_DIR="/clients"
KEYS_DIR="/keys"
SERVER_PUBLIC_KEY=$(cat /config/server_public.key)
ENDPOINT="your.domain.com" # or IP

mkdir -p "$CLIENTS_DIR"

for ID in {2..10}; do
    CLIENT_NAME="client$ID"

    echo "[*] generate keys for $CLIENT_NAME..."
    wg genkey | tee $KEYS_DIR/${CLIENT_NAME}_private.key | wg pubkey > $KEYS_DIR/${CLIENT_NAME}_public.key

    PRIV_KEY=$(cat $KEYS_DIR/${CLIENT_NAME}_private.key)

    CONFIG_FILE="$CLIENTS_DIR/${CLIENT_NAME}.conf"
    cp /config/wg0.conf.template "$CONFIG_FILE"

    sed -i "s|<PRIVATE_KEY>|$PRIV_KEY|g" "$CONFIG_FILE"
    sed -i "s|<SERVER_PUBLIC_KEY>|$SERVER_PUBLIC_KEY|g" "$CONFIG_FILE"
    sed -i "s|<CLIENT_ID>|$ID|g" "$CONFIG_FILE"
    sed -i "s|<ENDPOINT>|$ENDPOINT|g" "$CONFIG_FILE"

    echo "[+] config for $CLIENT_NAME created: $CONFIG_FILE"
done
