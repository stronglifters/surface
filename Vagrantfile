# -*- mode: ruby -*-
# vi: set ft=ruby :

# https://docs.vagrantup.com/v2/vmware/kernel-upgrade.html
$fix_vmware_tools_script = <<SCRIPT
sed -i.bak 's/answer AUTO_KMODS_ENABLED_ANSWER no/answer AUTO_KMODS_ENABLED_ANSWER yes/g' /etc/vmware-tools/locations
sed -i 's/answer AUTO_KMODS_ENABLED no/answer AUTO_KMODS_ENABLED yes/g' /etc/vmware-tools/locations
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "phusion/ubuntu-14.04-amd64"
  config.vm.network :forwarded_port, guest: 3000, host: 3000
  config.vm.provision :shell, inline: $fix_vmware_tools_script
  config.vm.provision :chef_apply do |chef|
    chef.recipe = File.read("config/chef_apply.rb")
  end
  config.vm.provider :vmware_workstation do |vm|
    vm.vmx["memsize"] = "2048"
    vm.vmx["numvcpus"] = "2"
  end
  config.vm.provider :vmware_fusion do |vm|
    vm.vmx["memsize"] = "2048"
    vm.vmx["numvcpus"] = "2"
  end
  config.ssh.forward_agent = true
end
