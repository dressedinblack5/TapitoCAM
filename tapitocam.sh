#!/bin/bash
# tapitocam.sh - TP-Link Tapo Camera RSTP Client

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${SCRIPT_DIR}/.tapitocam.env"

# Load config if it exists
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
fi

echo "DEBUG: SCRIPT_DIR is $SCRIPT_DIR"
