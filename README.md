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

### Setup and Run

1. Navigate to the `p1` directory.
2. Start the virtual machines:
   ```bash
   vagrant up
   ```

### Validation

You can SSH into the nodes to verify the installation:

**Master Node (ssianS):**
```bash
vagrant ssh ssianS
sudo kubectl get nodes -o wide
sudo systemctl status k3s
```

**Worker Node (ssianSW):**
```bash
vagrant ssh ssianSW
sudo systemctl status k3s-agent
```

### Cleanup

To stop and remove the VMs:
```bash
vagrant halt
vagrant destroy -f
```

## Part 2: K3s Deployment & Ingress

Part 2 builds upon the cluster setup to deploy applications and configure Ingress.

### Usage

1. Navigate to the `p2` directory.
2. Start the environment (if not already running from Part 1 setup, though P2 has its own Vagrantfile):
   ```bash
   vagrant up
   ```
3. Connect to the server node:
   ```bash
   vagrant ssh ssianS
   ```

### Verification & Testing

Check the status of deployments, services, and ingress:
```bash
sudo kubectl get all -n kube-system
sudo kubectl get all
sudo kubectl get ingress
```

Test the applications using `curl` with specific Host headers (assuming IP `192.168.56.110`):
```bash
curl -H "Host:app1.com" 192.168.56.110
curl -H "Host:app2.com" 192.168.56.110
curl -H "Host:app3.com" 192.168.56.110
```

*Note: You may need to update your local `/etc/hosts` file for browser access.*

## Part 3: K3d & ArgoCD

Part 3 utilizes `k3d` to create a cluster and implements GitOps using ArgoCD.

### Setup

1. Navigate to the `p3` directory.
2. Run the setup script:
   ```bash
   ./scripts/setup.sh
   ```

### Cluster Management

Commands to manage the k3d cluster:
```bash
k3d cluster create ssian-cluster
k3d cluster start ssian-cluster
k3d cluster stop ssian-cluster
k3d cluster delete ssian-cluster
```

### Accessing Services

**ArgoCD:**
1. Port forward the ArgoCD server:
   ```bash
   kubectl port-forward -n argocd svc/argocd-server 8080:443
   ```
2. Access at `http://localhost:8080`.
3. Username: `admin`
4. Retrieve the initial password:
   ```bash
   kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo
   ```

**Application (Wil Playground):**
1. Port forward the service:
   ```bash
   kubectl port-forward -n dev svc/wil-playground-service 8888:8888
   ```
2. Access at `http://localhost:8888`.
