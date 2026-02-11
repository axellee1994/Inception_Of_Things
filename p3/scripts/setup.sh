#!/bin/bash
set -e

k3d cluster create mycluster

kubectl wait --for=condition=Ready nodes --all --timeout=120s

kubectl config use-context k3d-mycluster

kubectl apply --server-side -f ../confs/namespace.yaml

kubectl apply --server-side -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl wait \
  --for=condition=Available \
  deployment/argocd-server \
  -n argocd \
  --timeout=180s

kubectl apply --server-side -f ../confs/wil-playground-app.yaml
