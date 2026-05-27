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

while true; do
    # Run mpv and capture stderr to a temp file
    ERROR_LOG=$(mktemp)
    mpv --profile=low-latency --untimed --cache=no --demuxer-readahead-secs=0 --vd-lavc-threads=1 --rtsp-transport=udp --demuxer-lavf-o-add=fflags=+nobuffer --demuxer-lavf-o-add=probesize=32 --demuxer-lavf-o-add=analyzeduration=0 --video-sync=audio "rtsp://${TAPO_USER}:${TAPO_PASS}@${TAPO_IP}/stream1" 2> "$ERROR_LOG"
    MPV_EXIT_CODE=$?

    # For now, just break if exit code is 0
    if [ $MPV_EXIT_CODE -eq 0 ]; then
        rm "$ERROR_LOG"
        break
    fi
    
    # Search for network errors in the log
    if grep -Ei "No route to host|Connection timed out|Connection refused|Failed to resolve hostname" "$ERROR_LOG" > /dev/null; then
        echo ""
        echo "!!! Connection Error Detected !!!"
        grep -Ei "No route to host|Connection timed out|Connection refused|Failed to resolve hostname" "$ERROR_LOG" | head -n 1
        echo ""
        read -p "Would you like to enter a different IP? (y/n): " RETRY_IP
        
        if [[ "$RETRY_IP" == "y" || "$RETRY_IP" == "Y" ]]; then
            read -p "Enter new Camera IP: " TAPO_IP
            
            # Update the config file
            cat <<EOF > "$CONFIG_FILE"
TAPO_USER="$TAPO_USER"
TAPO_PASS="$TAPO_PASS"
TAPO_IP="$TAPO_IP"
EOF
            chmod 600 "$CONFIG_FILE"
            echo "IP updated to $TAPO_IP. Retrying..."
            rm "$ERROR_LOG"
            continue
        fi
    fi

    rm "$ERROR_LOG"
    break
done
