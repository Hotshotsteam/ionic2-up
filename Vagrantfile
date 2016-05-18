VAGRANTFILE_API_VERSION = '2'
require 'yaml'

# Box details
B2D_BOX="AlbanMontaigu/boot2docker"
B2D_VERSION="1.11.0"

# Project configuration
project_config = {
  'forward_ports': false
}
# Load project config
if File.exists?('vagrant/project-config.yml')
  File.open('vagrant/project-config.yml', 'r') do |f|
    project_config = project_config.merge(YAML.load(f))
  end
end

# Configure VM
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Configure box
  config.vm.box = B2D_BOX
  config.vm.box_version = B2D_VERSION

  # Forwarding for SSH
  config.vm.network "forwarded_port", guest: 22, host: 22, auto_correct: true

  # Project port forwarding
  if project_config['forward_ports']
    project_config['forward_ports'].each_pair do |guest_port, host_port|
      config.vm.network :forwarded_port, guest: guest_port, host: host_port
    end
  end

end
