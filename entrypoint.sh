#!/bin/sh

# ============================
#  XRAY Auto Config + Run
# ============================

# Ensure required environment variables are set
if [ -z "$PORT" ]; then
  PORT=8080
fi

if [ -z "$PROTOCOL" ]; then
  PROTOCOL="vless"
fi

if [ -z "$UUID" ]; then
  UUID=$(cat /proc/sys/kernel/random/uuid)
fi

# ============================
#  Create Config Directory
# ============================
mkdir -p /tmp/xray

# Create the config.json dynamically
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

if ! command -v xray >/dev/null 2>&1; then
  echo "Downloading and installing Xray..."
  mkdir -p /usr/local/bin
  wget -O /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip
  unzip /tmp/xray.zip -d /tmp/xray_bin
  mv /tmp/xray_bin/xray /usr/local/bin/xray
  chmod +x /usr/local/bin/xray
  rm -rf /tmp/xray.zip /tmp/xray_bin
else
  echo "Xray already installed."
fi

# ============================
#  Run Xray
# ============================

echo "Starting Xray with config..."
xray -c /tmp/xray/config.json
