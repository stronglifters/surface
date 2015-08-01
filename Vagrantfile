# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "phusion/ubuntu-14.04-amd64"
  config.vm.network :forwarded_port, guest: 3000, host: 3000
  config.vm.provision :chef_apply do |chef|
    chef.recipe = File.read("config/chef_apply.rb")
    chef.version = 'latest'
  end
  config.vm.provider :vmware_workstation do |vm|
    vm.gui = false
    vm.vmx["displayname"] = "stronglifters"
  end
  config.vm.provider :vmware_fusion do |v|
    v.vmx["memsize"] = "2048"
    v.vmx["numvcpus"] = "2"
  end
  config.omnibus.chef_version = :latest
  config.ssh.forward_agent = true
end
