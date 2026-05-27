#!/bin/bash
# Wrapper to launch tapitocam.sh from a desktop entry
# This uses $HOME, which is correctly expanded by desktop environments
cd "$HOME/Downloads/TapitoCAM" || exit
./tapitocam.sh
