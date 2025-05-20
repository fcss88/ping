#!/bin/bash

# add new client for WireGuard-server
CLIENT_NAME="$1"
if [[ -z "$CLIENT_NAME" ]]; then
  echo "Enter client-name: ./add_client.sh clientname"
  exit 1
fi

KEYS_DIR="/keys"
CLIENTS_DIR="/clients"
CONFIG_TEMPLATE="/config/wg0.conf.template"
SERVER_PUBLIC_KEY=$(cat /config/server_public.key)
ENDPOINT="your.domain.com"  # or IP
WG_INTERFACE="wg0"

# Generate keys for the new client
wg genkey | tee $KEYS_DIR/${CLIENT_NAME}_private.key | wg pubkey > $KEYS_DIR/${CLIENT_NAME}_public.key
PRIV_KEY=$(cat $KEYS_DIR/${CLIENT_NAME}_private.key)
PUB_KEY=$(cat $KEYS_DIR/${CLIENT_NAME}_public.key)

# IP for new client
LAST_IP=$(grep -oP '10\.13\.13\.\K[0-9]+' $CLIENTS_DIR/*.conf | sort -n | tail -1)
NEW_IP=$((LAST_IP + 1))
[[ -z "$NEW_IP" || "$NEW_IP" -lt 2 ]] && NEW_IP=2

# Generate config
CONFIG_FILE="$CLIENTS_DIR/${CLIENT_NAME}.conf"
cp "$CONFIG_TEMPLATE" "$CONFIG_FILE"

sed -i "s|<PRIVATE_KEY>|$PRIV_KEY|g" "$CONFIG_FILE"
sed -i "s|<SERVER_PUBLIC_KEY>|$SERVER_PUBLIC_KEY|g" "$CONFIG_FILE"
sed -i "s|<CLIENT_ID>|$NEW_IP|g" "$CONFIG_FILE"
sed -i "s|<ENDPOINT>|$ENDPOINT|g" "$CONFIG_FILE"

# Add client for server interface (if u need)
wg set $WG_INTERFACE peer $PUB_KEY allowed-ips 10.13.13.${NEW_IP}/32

echo "Clien $CLIENT_NAME added. File: $CONFIG_FILE"
exit 0