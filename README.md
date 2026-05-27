# TapitoCAM

TP-Link Tapo Camera RSTP Client for Linux.

To enable RTSP (Real-Time Streaming Protocol) on a TP-Link Tapo camera, you must use the Tapo app to create a
  specific account for camera streaming. Here is the standard process:

   1. Open the Tapo App: Select your camera from the home screen.
   2. Go to Camera Settings: Tap the gear icon in the top right corner.
   3. Advanced Settings: Tap "Advanced Settings" (this is usually near the bottom).
   4. Camera Account: 
       * Tap "Camera Account".
       * If you haven't set it up, you will be prompted to create a username and password.
       * Note: This is separate from your main TP-Link account credentials.
   5. Connect: Once created, you can use these credentials to access the stream via your local IP address (e.g.,
      rtsp://username:password@192.168.x.x:554/stream1).

## Usage

1. Clone this repository to your desired location (e.g., `~/Downloads/TapitoCAM`):
   ```bash
   git clone https://github.com/dressedinblack5/TapitoCAM.git ~/Downloads/TapitoCAM && cd ~/Downloads/TapitoCAM

2. Make the script executable:
   ```bash
   chmod +x tapitocam.sh
   ```
3. Run the script:
   ```bash
   bash tapitocam.sh
   ```

When you run the script for the first time, it will interactively prompt you for:
- Tapo Username
- Tapo Password
- Camera IP Address

*These will be saved securely in a local hidden file named `.tapitocam.env` in the same directory as the script.*
