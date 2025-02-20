#!/bin/bash

# Update system
apt-get update
apt-get upgrade -y

# Install required packages
apt-get install -y curl wget

# Wait for master node token
while [ ! -f /vagrant/node-token ]; do
  sleep 5
done

# Get master node token
NODE_TOKEN=$(cat /vagrant/node-token)

# Install K3s worker
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.56.10:6443 K3S_TOKEN=${NODE_TOKEN} sh -