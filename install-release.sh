#!/bin/bash

VER="v"$V2RAY_VERSION

ARCH=$(uname -m)
VDIS="64"

if [[ "$ARCH" == "i686" ]] || [[ "$ARCH" == "i386" ]]; then
  VDIS="32"
elif [[ "$ARCH" == *"armv7"* ]]; then
  VDIS="arm"
elif [[ "$ARCH" == *"armv8"* ]]; then
  VDIS="arm64"
fi

DOWNLOAD_LINK="https://github.com/v2ray/v2ray-core/releases/download/${VER}/v2ray-linux-${VDIS}.zip"

rm -rf /tmp/v2ray
mkdir -p /tmp/v2ray

curl -L -o "/tmp/v2ray/v2ray.zip" ${DOWNLOAD_LINK}
unzip "/tmp/v2ray/v2ray.zip" -d "/tmp/v2ray/"

# Create folder for V2Ray log
mkdir -p /var/log/v2ray

# Install V2Ray binary to /usr/bin/v2ray
mkdir -p /usr/bin/v2ray
cp "/tmp/v2ray/v2ray-${VER}-linux-${VDIS}/v2ray" "/usr/bin/v2ray/v2ray"
chmod +x "/usr/bin/v2ray/v2ray"

# Install V2Ray server config to /etc/v2ray
mkdir -p /etc/v2ray
if [ ! -f "/etc/v2ray/config.json" ]; then
  # cp "/tmp/v2ray/v2ray-${VER}-linux-${VDIS}/vpoint_vmess_freedom.json" "/etc/v2ray/config.json"
  cp "/usr/v2ray/config.json" "/etc/v2ray/config.json"

  PORT=$V2RAY_PORT
  sed -i "s/17173/${PORT}/g" "/etc/v2ray/config.json"

  ALTERID=$V2RAY_ALTERID
  sed -i "s/1024/${ALTERID}/g" "/etc/v2ray/config.json"

  UUID=$(cat /proc/sys/kernel/random/uuid)
  sed -i "s/1ad52bdc-16d1-41a5-811d-f5c0c76d677b/${UUID}/g" "/etc/v2ray/config.json"

  SS_PORT=$SS_PORT
  sed -i "s/30001/${SS_PORT}/g" "/etc/v2ray/config.json"
  
  SS_METHOD=$SS_METHOD
  sed -i "s/chacha20/${SS_METHOD}/g" "/etc/v2ray/config.json"

  SS_PASSWD=$SS_PASSWD
  sed -i "s/v2rayss/${SS_PASSWD}/g" "/etc/v2ray/config.json"

  echo "PORT:${PORT}"
  echo "ALTERID:${ALTERID}"
  echo "UUID:${UUID}"
  echo "SS_PORT:${SS_PORT}"
  echo "SS_METHOD:${SS_METHOD}"
  echo "SS_PASSWD:${SS_PASSWD}"
fi

echo "========================================================================"
echo "  Hey, you can use V2Ray Service now  "
echo "  Version: $VER   Port: $PORT  "
echo "  ALTERID: $ALTERID     UUID: $UUID  "
echo "  SS_PORT: $SS_PORT   SS_METHOD: $SS_METHOD   SS_PASSWD: $SS_PASSWD  "
echo "========================================================================"

/usr/bin/v2ray/v2ray -config /etc/v2ray/config.json
