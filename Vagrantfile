VAGRANTFILE_API_VERSION = '2'
require 'yaml'

# Box details
B2D_BOX="AlbanMontaigu/boot2docker"
B2D_VERSION="1.11.0"

# Project configuration
project_config = {
  'vm_name' => false,
  'hostname' => false,
  'forward_ports' => false,
  'bootstrap' => false,
  'compose' => false
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

  # Configure hostname
  if project_config['hostname']
    config.vm.hostname = project_config['hostname']
  end

  # Forwarding for SSH
  config.vm.network "forwarded_port", guest: 22, host: 22, auto_correct: true

  # Project port forwarding
  if project_config['forward_ports']
    project_config['forward_ports'].each_pair do |guest_port, host_port|
      config.vm.network :forwarded_port, guest: guest_port, host: host_port
    end
  end

  # Virtualbox specific customisation
  config.vm.provider :virtualbox do |vb|

    # Customize the box name
    if project_config['vm_name']
      vb.name = project_config['vm_name']
    end

  end

  # Optional compose bootstrap
  if project_config['compose']
    config.vm.provision :shell, :path => "vagrant/compose.sh", name: "Docker Compose", args: "/vagrant/#{project_config['compose']}"
  end

  # Optional project bootstrap
  if project_config['bootstrap']
    config.vm.provision :shell, :path => "#{project_config['bootstrap']}", name: "project"
  end
end
