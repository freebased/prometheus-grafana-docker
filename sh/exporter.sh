#!/usr/bin/env bash

set -e
set -u

NODE_TAR="*node*.tar.gz"
NODE_TAR_TMP="temp.tar.gz"
PROM_DIR="/etc/prometheus"
NODE_DIR=$(find "$PROM_DIR" -type d -name "node*")
FIREWALL_RULES=$(iptables -S | grep "9100" | sed 's/.* //g')

if [[ "$FIREWALL_RULES" ]]; then
    echo "OK"
else
    echo "You need to allow your firewall on port 9090"
fi

cd "$PROM_DIR"

if [ -f "$NODE_TAR" ]; then
    mv "$NODE_TAR" "$NODE_TAR_TMP"
fi

cd "$NODE_DIR"

./node_exporter
