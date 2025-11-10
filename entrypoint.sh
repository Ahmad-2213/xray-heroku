#!/bin/sh
set -e

# ============================
#  XRAY Auto Config + Run
#  AlwaysData Home: /home/ahmad2213
# ============================

# Default environment variables
PORT=${PORT:-80}
PROTOCOL=${PROTOCOL:-vless}
UUID=${UUID:-43e8276e-104b-45d7-9dac-b8a1fc7c2a24}

# Directories inside your home
CONFIG_DIR="/home/ahmad2213/xray_config"
BIN_DIR="/home/ahmad2213/xray_bin"
XRAY_BIN="$BIN_DIR/xray"

# ============================
#  Create Config Directory
# ============================
mkdir -p "$CONFIG_DIR"

# Create the config.json dynamically
cat << EOF > "$CONFIG_DIR/config.json"
{
  "inbounds": [
    {
      "port": $PORT,
      "protocol": "$PROTOCOL",
      "settings": {
        "decryption": "none",
        "clients": [
          {
            "id": "$UUID"
          }
        ]
      },
      "streamSettings": {
        "network": "xhttp"
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom"
    }
  ]
}
EOF

# ============================
#  Download & Install Xray
# ============================
if [ ! -f "$XRAY_BIN" ]; then
    echo "Downloading Xray to $BIN_DIR..."
    mkdir -p "$BIN_DIR"
    wget -q -O "$BIN_DIR/xray.zip" https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip
    unzip -o "$BIN_DIR/xray.zip" -d "$BIN_DIR"
    chmod +x "$XRAY_BIN"
    rm "$BIN_DIR/xray.zip"
fi

# ============================
#  Run Xray
# ============================
echo "Starting Xray..."
exec "$XRAY_BIN" -c "$CONFIG_DIR/config.json"
