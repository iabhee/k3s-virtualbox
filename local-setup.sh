#!/bin/bash

# Create .kube directory if it doesn't exist
mkdir -p ~/.kube

# Copy kubeconfig from Vagrant shared directory
cp kubeconfig/config ~/.kube/config

# Set correct permissions
chmod 600 ~/.kube/config

# Test connection
echo "Testing connection to K3s cluster..."
kubectl cluster-info

# Show nodes
echo "Displaying cluster nodes..."
kubectl get nodes