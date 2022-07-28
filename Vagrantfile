# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    # Base VM OS configuration.
    config.vm.box = "fedora/36-cloud-base"
    config.ssh.insert_key = false
    config.vm.synced_folder '.', '/vagrant'
  
    # General VirtualBox VM configuration.
    config.vm.provider :virtualbox do |v|
      v.memory = 2048
      v.cpus = 2
      v.linked_clone = true
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--ioapic", "on"]
    end
    
    # Kubernetes master node 01.
    config.vm.define "kmaster01" do |kmaster01|
      kmaster01.vm.hostname = "kmaster01.local"
  
      kmaster01.vm.provision "shell",
        inline: "cd /vagrant && ./k8s-base-bootstrap-fedora36.sh"
    end
  
    # Kubernetes worker node 01.
    config.vm.define "kworker01" do |kworker01|
      kworker01.vm.hostname = "kworker01.local"
  
      kworker01.vm.provision "shell",
        inline: "cd /vagrant && ./k8s-base-bootstrap-fedora36.sh"
    end

    # Kubernetes worker node 02.
    config.vm.define "kworker02" do |kworker02|
      kworker02.vm.hostname = "kworker02.local"

      kworker02.vm.provision "shell",
        inline: "cd /vagrant && ./k8s-base-bootstrap-fedora36.sh"
    end
end