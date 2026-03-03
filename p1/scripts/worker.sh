#!/bin/bash
set -e

SERVER_IP="192.168.56.110"

# Wait until token is available
until [ -f /vagrant/token ]; do
  sleep 2
done

TOKEN=$(cat /vagrant/token)

curl -sfL https://get.k3s.io | \
  K3S_URL="https://$SERVER_IP:6443" \
  K3S_TOKEN="$TOKEN" \
  sh -s - agent \
  --node-ip=192.168.56.111

# Install networking tools
sudo apt update
sudo apt install -y net-tools
