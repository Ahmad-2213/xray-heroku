#!/bin/sh
set -e

# ============================
#  XRAY Auto Config + Run
# ============================

# Default environment variables
PORT=${PORT:-8080}
PROTOCOL=${PROTOCOL:-vless}
UUID=${UUID:-$(cat /proc/sys/kernel/random/uuid)}

# ============================
#  Create Config Directory
# ============================
CONFIG_DIR="$HOME/xray_config"
mkdir -p "$CONFIG_DIR"

cat << EOF > "$CONFIG_DIR/config.json"
{
  "inbounds": [
    {
      "port": $PORT,
      "protocol": "$PROTOCOL",
      "settings": {
        "decryption": "none",
        "clients": [
          { "id": "$UUID" }
        ]
      },
      "streamSettings": {
        "network": "xhttp"
      }
    }
  ],
  "outbounds": [
    { "protocol": "freedom" }
  ]
}
EOF

# ============================
#  Download & Install Xray
# ============================
XRAY_DIR="$HOME/xray_bin"
XRAY_BIN="$XRAY_DIR/xray"

if [ ! -f "$XRAY_BIN" ]; then
    echo "Downloading Xray..."
    mkdir -p "$XRAY_DIR"
    wget -q -O "$XRAY_DIR/xray.zip" https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip
    unzip -o "$XRAY_DIR/xray.zip" -d "$XRAY_DIR"
    chmod +x "$XRAY_BIN"
    rm -f "$XRAY_DIR/xray.zip"
else
    echo "Xray already exists, skipping download."
fi

# ============================
#  Run Xray
# ============================
echo "Starting Xray..."
exec "$XRAY_BIN" -c "$CONFIG_DIR/config.json"
