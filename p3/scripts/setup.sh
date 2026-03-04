#!/bin/bash
set -e

CLUSTER_NAME="ssian-cluster"

k3d cluster create $CLUSTER_NAME \
  --port "8080:30080@server:0" \
  --port "8888:30088@server:0" \
  --wait

kubectl config use-context k3d-$CLUSTER_NAME

kubectl wait --for=condition=Ready nodes --all --timeout=120s

kubectl apply --server-side -f ../confs/namespace.yaml

kubectl apply --server-side -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl wait \
  --for=condition=Available \
  deployment/argocd-server \
  -n argocd \
  --timeout=600s

kubectl patch svc argocd-server -n argocd \
-p '{"spec":{"type":"NodePort","ports":[{"port":80,"targetPort":8080,"nodePort":30080}]}}'


kubectl apply --server-side -f ../confs/wil-playground-app.yaml
