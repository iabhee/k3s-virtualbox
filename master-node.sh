#!/bin/bash

# Update system
apt-get update
apt-get upgrade -y

# Install required packages
apt-get install -y curl wget

# Install K3s master with TLS-SAN and disabled components
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server \
  --tls-san 192.168.56.10 \
  --disable traefik \
  --disable metrics-server \
  --write-kubeconfig-mode 644" sh -

# Get node token for worker nodes
NODE_TOKEN=$(cat /var/lib/rancher/k3s/server/node-token)
echo $NODE_TOKEN > /vagrant/node-token

# Configure kubeconfig for vagrant user
mkdir -p /home/vagrant/.kube
cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube
echo "export KUBECONFIG=/home/vagrant/.kube/config" >> /home/vagrant/.bashrc

# Copy kubeconfig to shared vagrant directory for local access
mkdir -p /vagrant/kubeconfig
cp /etc/rancher/k3s/k3s.yaml /vagrant/kubeconfig/config
sed -i "s/127.0.0.1/192.168.56.10/g" /vagrant/kubeconfig/config
chmod 644 /vagrant/kubeconfig/config