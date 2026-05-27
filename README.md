# TapitoCAM

TP-Link Tapo Camera RSTP Client for Linux.

## Installation

1. Clone this repository to your desired location (e.g., `~/Downloads/TapitoCAM`):
   ```bash
   git clone <repository-url> ~/Downloads/TapitoCAM
   ```

2. Make the script executable:
   ```bash
   chmod +x ~/Downloads/TapitoCAM/tapitocam.sh
   ```

3. **Update Desktop Entry**:
   The provided `TapitoCAM.desktop` assumes you installed the files in `~/Downloads/TapitoCAM`. 
   If you installed it elsewhere, open `TapitoCAM.desktop` and update the `Exec` and `Path` lines to point to your installation directory.

4. Copy the desktop file to your local applications folder:
   ```bash
   cp ~/Downloads/TapitoCAM/TapitoCAM.desktop ~/.local/share/applications/
   ```

## Usage

When you run the application for the first time, it will interactively prompt you for:
- Tapo Username
- Tapo Password
- Camera IP Address

These will be saved securely in a local hidden file named `.tapitocam.env` in the same directory as the script.
