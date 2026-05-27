#!/bin/bash
# tapitocam.sh - TP-Link Tapo Camera RSTP Client

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${SCRIPT_DIR}/.tapitocam.env"

if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
fi

# Prompt for missing credentials
if [[ -z "$TAPO_USER" || -z "$TAPO_PASS" || -z "$TAPO_IP" ]]; then
    echo "--- TapitoCAM Configuration ---"
    read -p "Enter Tapo Username: " TAPO_USER
    read -p "Enter Tapo Password: " -s TAPO_PASS
    echo ""
    read -p "Enter Camera IP (e.g., 192.168.1.100): " TAPO_IP
    
    read -p "Save these settings to .tapitocam.env? (y/n): " SAVE_CONF
    if [[ "$SAVE_CONF" == "y" || "$SAVE_CONF" == "Y" ]]; then
        cat <<EOF > "$CONFIG_FILE"
TAPO_USER="$TAPO_USER"
TAPO_PASS="$TAPO_PASS"
TAPO_IP="$TAPO_IP"
EOF
        chmod 600 "$CONFIG_FILE"
        echo "Settings saved."
    fi
fi

# Final check
if [[ -z "$TAPO_USER" || -z "$TAPO_PASS" || -z "$TAPO_IP" ]]; then
    echo "Error: Missing credentials."
    exit 1
fi

mpv --profile=low-latency --untimed --cache=no --demuxer-readahead-secs=0 --vd-lavc-threads=1 --rtsp-transport=udp --demuxer-lavf-o-add=fflags=+nobuffer --demuxer-lavf-o-add=probesize=32 --demuxer-lavf-o-add=analyzeduration=0 --video-sync=audio "rtsp://${TAPO_USER}:${TAPO_PASS}@${TAPO_IP}/stream1"
