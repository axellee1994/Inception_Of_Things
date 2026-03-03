#!/bin/bash
set -e

curl -sfL https://get.k3s.io | sh -s - server \
  --node-ip=192.168.56.110 \
  --advertise-address=192.168.56.110

# Wait for token to exist
until [ -f /var/lib/rancher/k3s/server/node-token ]; do
  sleep 2
done

# Copy token to shared folder
cp /var/lib/rancher/k3s/server/node-token /vagrant/token
chmod 644 /vagrant/token

# Install networking tools
sudo apt update
sudo apt install -y net-tools
