# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"

  # Master Node
  config.vm.define "master" do |master|
    master.vm.hostname = "master"
    master.vm.network "private_network", ip: "192.168.56.10"
    
    master.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.cpus = 2
      vb.name = "k3s-master"
    end

    # Provision master node
    master.vm.provision "shell", path: "master-node.sh"
    
    # Provision local machine setup inline
    master.vm.provision "shell", run: "always", privileged: false, inline: <<-SHELL
      echo "Setting up kubectl configuration on master node..."
      
      # Create .kube directory if it doesn't exist
      mkdir -p $HOME/.kube
      
      # Copy kubeconfig from vagrant shared directory
      if [ -f "/vagrant/kubeconfig/config" ]; then
          cp /vagrant/kubeconfig/config $HOME/.kube/config
          chmod 600 $HOME/.kube/config
          echo "Kubeconfig copied successfully"
          
          # Test the connection
          echo "Testing cluster connection..."
          kubectl cluster-info
          echo "Listing cluster nodes..."
          kubectl get nodes
      else
          echo "Error: Kubeconfig file not found in /vagrant/kubeconfig/config"
          exit 1
      fi
    SHELL
  end

  # Worker Node 1
  config.vm.define "worker1" do |worker|
    worker.vm.hostname = "worker1"
    worker.vm.network "private_network", ip: "192.168.56.11"
    
    worker.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
      vb.cpus = 1
      vb.name = "k3s-worker1"
    end

    worker.vm.provision "shell", path: "worker-node.sh"
  end

  # Worker Node 2
  config.vm.define "worker2" do |worker|
    worker.vm.hostname = "worker2"
    worker.vm.network "private_network", ip: "192.168.56.12"
    
    worker.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
      vb.cpus = 1
      vb.name = "k3s-worker2"
    end

    worker.vm.provision "shell", path: "worker-node.sh"
  end
end