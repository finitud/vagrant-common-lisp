# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# Vagrantfile for vagrant-common-lisp
# 
# Invoke this way to print extra debugging info:
#
#     DEBUG=true vagrant up
#
# or:
#
#     DEBUG=true vagrant provision
#
# Invoke with PORT_FORWARD to switch the port that the guest port 80
# is forwarded to:
#
#     PORT_FORWARD=8888 vagrant up

case ENV["DEBUG"]
when "true"
    puppet_install = "apt-get update && apt-get install -y puppet"
    puppet_options = ["--debug", "--verbose"]
else
    puppet_install = "apt-get -qq update && apt-get -qq install puppet"
    puppet_options = []
end

case ENV["PORT_FORWARD"]
when /^([1-9][0-9]*)/
    port_forward = ENV["PORT_FORWARD"]
else
    port_forward=8000
end


Vagrant::Config.run do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.forward_port 80, port_forward

  config.vm.provision :shell, inline: puppet_install

  config.vm.provision :puppet, :options => puppet_options do |puppet|
    puppet.manifests_path = "private/puppet/manifests"
    puppet.module_path = "private/puppet/modules"
    puppet.manifest_file  = "base.pp"
  end

#  config.vm.provision :shell, :path => "common_lisp.sh"

end
