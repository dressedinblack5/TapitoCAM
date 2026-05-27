#!/bin/bash
# tapitocam.sh - TP-Link Tapo Camera RSTP Client

# Check for dependencies
if ! command -v mpv &> /dev/null; then
    echo "Error: mpv is not installed. Please install it (e.g., sudo apt install mpv)."
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${SCRIPT_DIR}/.tapitocam.env"

# Cleanup temporary log files on exit
trap 'rm -f "$ERROR_LOG" 2>/dev/null' EXIT

save_config() {
    # Use printf %q to safely escape special characters for shell sourcing
    printf 'TAPO_USER=%q\nTAPO_PASS=%q\nTAPO_IP=%q\n' "$TAPO_USER" "$TAPO_PASS" "$TAPO_IP" > "$CONFIG_FILE"
    chmod 600 "$CONFIG_FILE"
}

if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
    export TAPO_USER TAPO_PASS TAPO_IP
fi

# Prompt for missing credentials
if [[ -z "$TAPO_USER" || -z "$TAPO_PASS" || -z "$TAPO_IP" ]]; then
    echo "--- tapitoCAM Configuration ---"
    read -r -p "Enter Tapo Username: " TAPO_USER
    read -r -s -p "Enter Tapo Password: " TAPO_PASS
    echo ""
    read -r -p "Enter Camera IP (e.g., 192.168.1.100): " TAPO_IP
    
    # Simple IP validation
    if [[ ! "$TAPO_IP" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
        echo "Warning: The entered IP address format may be invalid."
    fi

    read -r -p "Save these settings to .tapitocam.env? (y/n): " SAVE_CONF
    if [[ "$SAVE_CONF" == "y" || "$SAVE_CONF" == "Y" ]]; then
        save_config
        echo "Settings saved."
    fi
fi

# Final check
if [[ -z "$TAPO_USER" || -z "$TAPO_PASS" || -z "$TAPO_IP" ]]; then
    echo "Error: Missing credentials."
    exit 1
fi

while true; do
    # Run mpv and capture log to a temp file
    ERROR_LOG=$(mktemp)
    mpv --log-file="$ERROR_LOG" --profile=fast --untimed --cache=no --demuxer-readahead-secs=0 --vd-lavc-threads=1 --rtsp-transport=udp --demuxer-lavf-o-add=fflags=+nobuffer --demuxer-lavf-o-add=probesize=32 --demuxer-lavf-o-add=analyzeduration=0 --video-sync=audio "rtsp://${TAPO_USER}:${TAPO_PASS}@${TAPO_IP}/stream1"
    MPV_EXIT_CODE=$?
    
    # Exit if mpv was interrupted (Ctrl+C)
    if [ "$MPV_EXIT_CODE" -eq 130 ]; then
        break
    fi

    # Break if successful
    if [ "$MPV_EXIT_CODE" -eq 0 ]; then
        break
    fi
    
    # Search for network errors in the log
    if grep -Ei "No route to host|Connection timed out|Connection refused|Failed to resolve hostname" "$ERROR_LOG" > /dev/null; then
        echo ""
        echo "!!! Connection Error Detected !!!"
        grep -Ei "No route to host|Connection timed out|Connection refused|Failed to resolve hostname" "$ERROR_LOG" | head -n 1
        echo ""
        read -r -p "Would you like to enter a different IP? (y/n): " RETRY_IP
        
        if [[ "$RETRY_IP" == "y" || "$RETRY_IP" == "Y" ]]; then
            read -r -p "Enter new Camera IP: " TAPO_IP
            save_config
            echo "IP updated to $TAPO_IP. Retrying..."
            rm "$ERROR_LOG" 2>/dev/null
            continue
        fi
    fi

    break
done
