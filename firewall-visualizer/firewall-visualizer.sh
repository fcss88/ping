#!/usr/bin/env bash

# Firewall Visualizer
# Supports iptables and nftables
# Outputs table, json, yaml
# Can export results to a file

###############################################
# Global variables
###############################################

OUTPUT_FORMAT="table"
EXPORT_FILE=""
FIREWALL_TYPE="auto"

###############################################
# Helper: detect firewall type automatically
###############################################
detect_firewall() {
    if command -v nft >/dev/null 2>&1; then
        FIREWALL_TYPE="nftables"
    elif command -v iptables >/dev/null 2>&1; then
        FIREWALL_TYPE="iptables"
    else
        echo "ERROR: Neither nftables nor iptables found."
        exit 1
    fi
}

###############################################
# Parse iptables rules
###############################################
parse_iptables() {
    iptables -S 2>/dev/null | while read -r line; do
        # Parse using simple pattern extraction
        CHAIN=$(echo "$line" | awk '{print $2}')
        SRC=$(echo "$line" | grep -oP '(?<=-s )\S+' || echo "any")
        DST=$(echo "$line" | grep -oP '(?<=-d )\S+' || echo "any")
        PROTO=$(echo "$line" | grep -oP '(?<=-p )\S+' || echo "any")
        ACTION=$(echo "$line" | grep -oP '(?<=-j )\S+' || echo "none")

        echo "$CHAIN|$SRC|$DST|$PROTO|$ACTION"
    done
}

###############################################
# Parse nftables rules
###############################################
parse_nftables() {
    nft list ruleset | grep "ip " | while read -r line; do
        CHAIN=$(echo "$line" | awk '{print $2}')
        SRC=$(echo "$line" | grep -oP '(?<=saddr )\S+' || echo "any")
        DST=$(echo "$line" | grep -oP '(?<=daddr )\S+' || echo "any")
        PROTO=$(echo "$line" | grep -oP '(?<=ip protocol )\S+' || echo "any")
        ACTION=$(echo "$line" | grep -oP '(?<=counter )\w+' || echo "accept")

        echo "$CHAIN|$SRC|$DST|$PROTO|$ACTION"
    done
}

###############################################
# Load rules depending on firewall type
###############################################
load_rules() {
    case "$FIREWALL_TYPE" in
        iptables)
            parse_iptables
            ;;
        nftables)
            parse_nftables
            ;;
        auto)
            detect_firewall
            load_rules
            ;;
    esac
}

###############################################
# Print table format
###############################################
output_table() {
    printf "%-15s %-20s %-20s %-10s %-10s\n" "CHAIN" "SOURCE" "DESTINATION" "PROTO" "ACTION"
    printf -- "-------------------------------------------------------------------------------------\n"

    while read -r rule; do
        IFS="|" read -r CHAIN SRC DST PROTO ACTION <<<"$rule"
        printf "%-15s %-20s %-20s %-10s %-10s\n" "$CHAIN" "$SRC" "$DST" "$PROTO" "$ACTION"
    done <<< "$(load_rules)"
}

###############################################
# Print JSON format
###############################################
output_json() {
    echo "["

    FIRST=1
    while read -r rule; do
        IFS="|" read -r CHAIN SRC DST PROTO ACTION <<< "$rule"

        if [ $FIRST -eq 0 ]; then echo ","; fi
        FIRST=0

        cat <<EOF
  {
    "chain": "$CHAIN",
    "source": "$SRC",
    "destination": "$DST",
    "protocol": "$PROTO",
    "action": "$ACTION"
  }
EOF
    done <<< "$(load_rules)"

    echo "]"
}

###############################################
# Print YAML format
###############################################
output_yaml() {
    echo "rules:"

    while read -r rule; do
        IFS="|" read -r CHAIN SRC DST PROTO ACTION <<< "$rule"

        cat <<EOF
  - chain: "$CHAIN"
    source: "$SRC"
    destination: "$DST"
    protocol: "$PROTO"
    action: "$ACTION"
EOF
    done <<< "$(load_rules)"
}

###############################################
# Export to file
###############################################
export_output() {
    if [ -n "$EXPORT_FILE" ]; then
        case "$OUTPUT_FORMAT" in
            table) output_table > "$EXPORT_FILE" ;;
            json)  output_json  > "$EXPORT_FILE" ;;
            yaml)  output_yaml  > "$EXPORT_FILE" ;;
        esac

        echo "Exported to $EXPORT_FILE"
        exit 0
    fi
}

###############################################
# Argument parsing
###############################################
while [[ $# -gt 0 ]]; do
    case "$1" in
        --json) OUTPUT_FORMAT="json" ;;
        --yaml) OUTPUT_FORMAT="yaml" ;;
        --table) OUTPUT_FORMAT="table" ;;
        --export)
            EXPORT_FILE="$2"
            shift
            ;;
        --iptables) FIREWALL_TYPE="iptables" ;;
        --nftables) FIREWALL_TYPE="nftables" ;;
        --help)
            echo "Usage: ./firewall-visualizer.sh [--json|--yaml|--table] [--export file]"
            exit 0
            ;;
    esac
    shift
done

###############################################
# Main logic
###############################################
export_output

case "$OUTPUT_FORMAT" in
    table) output_table ;;
    json)  output_json ;;
    yaml)  output_yaml ;;
esac
