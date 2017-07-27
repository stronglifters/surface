# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.provision :chef_apply do |chef|
    file = File.join(__dir__, "config/chef_apply.rb")
    chef.recipe = IO.read(file)
    chef.version = "latest"
    chef.install = "force"
  end
end
