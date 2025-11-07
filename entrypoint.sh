#!/bin/sh

# Config xray

mkdir -p /app
rm -f /app/config.json
cat << EOF > /app/config.json
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

xray -c /app/config.json
