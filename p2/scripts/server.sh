#!/bin/bash
set -e

curl -sfL https://get.k3s.io | sh -s - server \
  --node-ip=192.168.56.110 \
  --advertise-address=192.168.56.110

# Wait for token to exist
until [ -f /var/lib/rancher/k3s/server/node-token ]; do
  sleep 2
done

# Install networking tools
sudo apt update
sudo apt install -y net-tools

# Wait until Kubernetes API is ready
until kubectl get nodes >/dev/null 2>&1; do
  sleep 2
done

# Apply Kubernetes manifests
kubectl apply -f /vagrant/confs/apps.yaml
kubectl apply -f /vagrant/confs/ingress.yaml
