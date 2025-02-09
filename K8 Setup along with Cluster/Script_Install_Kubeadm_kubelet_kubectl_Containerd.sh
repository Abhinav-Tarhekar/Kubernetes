#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Define the Kubernetes repository file
K8S_REPO="/etc/yum.repos.d/kubernetes.repo"

# Add Kubernetes repository
cat <<EOF | sudo tee $K8S_REPO
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/repodata/repomd.xml.key
EOF

# Install Kubernetes components
sudo dnf -y install kubelet kubeadm kubectl

# Add containerd repository
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Install containerd
sudo dnf install -y containerd.io

# Generate and move containerd configuration file
containerd config default > config.toml
sudo mv config.toml /etc/containerd/config.toml

# Restart and enable containerd
sudo systemctl restart containerd
sudo systemctl enable containerd

# Verify containerd status
sudo systemctl status containerd --no-pager

# Start and enable kubelet
sudo systemctl start kubelet
sudo systemctl enable kubelet

# Verify kubelet status
sudo systemctl status kubelet --no-pager

echo "Installation and configuration completed successfully!"