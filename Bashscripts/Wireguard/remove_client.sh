#!/bin/bash

CLIENT_NAME="$1"
if [[ -z "$CLIENT_NAME" ]]; then
  echo "Add clientname for running script: ./remove_client.sh clientname"
  exit 1
fi

KEYS_DIR="/keys"
CLIENTS_DIR="/clients"
WG_INTERFACE="wg0"

PUB_KEY_FILE="$KEYS_DIR/${CLIENT_NAME}_public.key"
CONF_FILE="$CLIENTS_DIR/${CLIENT_NAME}.conf"

if [[ ! -f "$PUB_KEY_FILE" ]]; then
  echo "Key client $CLIENT_NAME not found."
  exit 2
fi

PUB_KEY=$(cat "$PUB_KEY_FILE")

# Remove peer from server config
wg set "$WG_INTERFACE" peer "$PUB_KEY" remove

# Remove client config from server-configuration
rm -f "$KEYS_DIR/${CLIENT_NAME}_private.key"
rm -f "$KEYS_DIR/${CLIENT_NAME}_public.key"
rm -f "$CONF_FILE"

echo " $CLIENT_NAME deleted"
exit 0