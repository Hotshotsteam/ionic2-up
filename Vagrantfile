VAGRANTFILE_API_VERSION = '2'
require 'yaml'

# Box details
B2D_BOX="AlbanMontaigu/boot2docker"
B2D_VERSION="1.11.0"

# Configure VM
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Configure box
  config.vm.box = B2D_BOX
  config.vm.box_version = B2D_VERSION

  # Forwarding for SSH
  config.vm.network "forwarded_port", guest: 22, host: 22, auto_correct: true
end
