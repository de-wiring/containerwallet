# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'ubuntu/trusty64'
  config.vm.box_check_update = false
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.customize ["modifyvm", :id, "--memory", "256"]
  end

  # master
  config.vm.define 'wallet', primary: true do |m|
	  m.vm.network "private_network", type: "dhcp"
	  m.vm.hostname = "wallet"
	  #m.vm.network "forwarded_port", guest: 8500, host: 8500

	  m.vm.provision 'shell', path: 'provision.d/01_os.sh'
	  m.vm.provision 'shell', path: 'provision.d/10_docker.sh'
  end

end

