# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"
  config.vm.forward_port 80, 8000
#  config.vm.provision :shell, :path => "common_lisp.sh"

  config.vm.provision :puppet, :module_path => "private/puppet/modules" do |puppet|
    puppet.manifests_path = "private/puppet/manifests"
    puppet.manifest_file  = "base.pp"
  end

end
