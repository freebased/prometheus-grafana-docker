#!/usr/bin/env bash

set -e
set -u

NODE_TAR="node*.tar.gz"
NODE_TAR_TMP="temp.tar.gz"
PROM_DIR="/etc/prometheus"
NODE_DIR=$(find "$PROM_DIR" -type d -name "node*")
FIREWALL_RULES=$(iptables -S | grep "9100" | sed 's/.* //g')

BIN="amd64"

LATEST=$(curl -s https://api.github.com/repos/prometheus/node_exporter/releases/latest | grep "linux-${BIN}.tar.gz" | cut -d '"' -f 4 | tail -1)

if [[ "$FIREWALL_RULES" == "ACCEPT" ]]; then
    echo "OK"
else
    echo "Your firewall is off or you need to allow your firewall on port 9090"
    echo "Continue? [Y/n]"
    read IN
    if [ "$IN" != "Y" ]; then
        echo "NO"
	exit 1
    fi
fi

cd "$PROM_DIR"

if [ ! -f "$PROM_DIR"/tmp.tar.gz ]; then
    curl -s -LJO $LATEST
    tar -xzvf node*.tar.gz
    mv node*.tar.gz tmp.tar.gz
fi

cd node*

./node_exporter
