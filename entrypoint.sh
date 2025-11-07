#!/bin/sh

# Config xray

mkdir -p /tmp/xray
rm -f /app/config.json
cat << EOF > /tmp/xray/config.json
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
        "network": "ws"
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

# Run xray

xray -c /tmp/xray/config.json
