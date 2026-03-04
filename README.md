# Inception of Things

This project is a comprehensive guide to setting up and managing Kubernetes clusters using K3s, K3d, Vagrant, and ArgoCD. It is divided into three parts, each focusing on different aspects of Kubernetes infrastructure and deployment.

## Prerequisites

Before starting, ensure you have the following installed on your system:

- **VirtualBox** (for Parts 1 & 2)
- **Vagrant** (for Parts 1 & 2)
- **Docker** (for Part 3)
- **K3d** (for Part 3)
- **Kubectl** (Command-line tool for Kubernetes)

## Part 1: K3s with Vagrant (Server + Worker)

Part 1 focuses on setting up a K3s cluster with a master (server) node and a worker node using Vagrant and VirtualBox.

### Installation

**Install Oracle VirtualBox:**
```bash
sudo apt update
sudo apt install wget gcc make perl dkms build-essential linux-headers-$(uname -r)
wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg --dearmor
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian <mydist> contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
sudo apt update
sudo apt install virtualbox-7.2
sudo usermod -a -G vboxusers $USER
```

**Install Vagrant:**
```bash
sudo apt install vagrant
```

**Turn off KVM (if necessary):**
```bash
sudo modprobe -r kvm_intel kvm
```

### Setup and Run

Start the virtual machines:
```bash
vagrant up
```

### Validation

**Login to Server VM (ssianS):**
```bash
vagrant ssh ssianS
sudo kubectl get nodes -o wide
ifconfig eth1
hostnamectl
sudo kubectl get nodes
sudo systemctl status k3s
```

**Login to Worker VM (ssianSW):**
```bash
vagrant ssh ssianSW
ifconfig eth1
hostnamectl
sudo systemctl status k3s-agent
```

### Cleanup

Stop and destroy the VMs:
```bash
vagrant halt
vagrant destroy -f
```

## Part 2: K3s Deployment & Ingress

Part 2 builds upon the cluster setup to deploy applications and configure Ingress.

### Operations

**Access Server and Check Status:**
```bash
vagrant ssh ssianS
ifconfig eth1
hostnamectl
sudo systemctl status k3s
sudo kubectl get nodes -o wide
sudo kubectl get all -n kube-system
sudo kubectl get all
```

**Test Ingress:**
```bash
curl -H "Host:app1.com" 192.168.56.110
curl -H "Host:app2.com" 192.168.56.110
curl -H "Host:app3.com" 192.168.56.110
```

**Configuration & Inspection:**
```bash
sudo nano /etc/hosts  # (change local hosts file)
sudo kubectl get ingress
sudo kubectl get deployments
sudo kubectl get pods
sudo kubectl get svc
sudo kubectl get endpoints
```

## Part 3: K3d & ArgoCD

Part 3 utilizes `k3d` to create a cluster and implements GitOps using ArgoCD.

### Installation

**Install kubectl:**
```bash
curl -LO https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
```

### Setup and Management

**Run Setup:**
```bash
./scripts/setup.sh
```

**Cluster Commands:**
```bash
k3d cluster create ssian-cluster
k3d cluster start ssian-cluster
k3d cluster stop ssian-cluster
k3d cluster delete ssian-cluster
```

**Verification:**
```bash
kubectl get pods -n dev
kubectl get pods -A
```

### Port Forwarding & Access

**ArgoCD (http://localhost:8080):**
```bash
kubectl port-forward -n argocd svc/argocd-server 8080:443
```

**Application (http://localhost:8888):**
```bash
kubectl port-forward -n dev svc/wil-playground-service 8888:8888
```

**Retrieve ArgoCD Admin Password:**
Username: `admin`
```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
    -o jsonpath="{.data.password}" | base64 -d && echo
```
