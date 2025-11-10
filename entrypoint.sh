#!/bin/sh
set -e

PORT=${PORT:-8080}
PROTOCOL=${PROTOCOL:-vless}
UUID=${UUID:-$(cat /proc/sys/kernel/random/uuid)}

CONFIG_DIR="/tmp/xray_config"
mkdir -p "$CONFIG_DIR"

cat << EOF > "$CONFIG_DIR/config.json"
{
  "inbounds": [
    {
      "port": $PORT,
      "protocol": "$PROTOCOL",
      "settings": { "decryption": "none", "clients": [{ "id": "$UUID" }] },
      "streamSettings": { "network": "xhttp" }
    }
  ],
  "outbounds": [{ "protocol": "freedom" }]
}
EOF

echo "Starting Xray..."
exec /usr/local/bin/xray -c "$CONFIG_DIR/config.json"
