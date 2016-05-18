VAGRANTFILE_API_VERSION = '2'
require 'yaml'

# Box details
B2D_BOX="AlbanMontaigu/boot2docker"
B2D_VERSION="1.11.0"

# Project configuration
# To override update vagrant/project-config.yml
project_config = {
  'vm_name'       => false,
  'hostname'      => false,
  'forward_ports' => false,
  'bootstrap'     => false,
  'compose'       => false
}

# Load project config
if File.exists?('vagrant/project-config.yml')
  File.open('vagrant/project-config.yml', 'r') do |f|
    project_config = project_config.merge(YAML.load(f))
  end
end

# Developer configuration
# To override copy vagrant/developer-config-example.yml to vagrant/developer-config.yml
dev_config = {
  'vm_name'         => false,
  'hostname'        => false,
  'forward_ports'   => false,
  'ssh_port'        => false,
  'ram'             => 2048,
  'cpus'            => 1,
  'bridged_adapter' => false,
  'bridged_ip'      => false,
  'compose'         => false
}

# Load developer config
if File.exists?('vagrant/developer-config.yml')
  File.open('vagrant/developer-config.yml', 'r') do |f|
    dev_config = dev_config.merge(YAML.load(f))
  end
end

# Configure VM
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Configure box
  config.vm.box = B2D_BOX
  config.vm.box_version = B2D_VERSION

  # Configure hostname
  hostname = dev_config['hostname'] || project_config['hostname']
  if hostname
    config.vm.hostname = hostname
  end

  # Forwarding for SSH
  if dev_config['ssh_port']
    config.ssh.port = dev_config['ssh_port']
    config.vm.network :forwarded_port, guest: 22, host: 2200, id: "ssh", disabled: "true"
    config.vm.network :forwarded_port, guest: 22, host: dev_config['ssh_port']
  end

  # Port forwarding
  forward_ports = {};
  if project_config['forward_ports']
    forward_ports = forward_ports.merge(project_config['forward_ports'])
  end
  if dev_config['forward_ports']
    forward_ports = forward_ports.merge(dev_config['forward_ports'])
  end

  # Project port forwarding
  if forward_ports.length > 0
    forward_ports.each_pair do |guest_port, host_port|
      config.vm.network :forwarded_port, guest: guest_port, host: host_port
    end
  end

  # Virtualbox specific customisation
  config.vm.provider :virtualbox do |vb|

    # Box name
    vm_name = dev_config['vm_name'] || project_config['vm_name']
    if vm_name
      vb.name = vm_name
    end

    # Resources
    vb.customize ["modifyvm", :id, "--cpus", dev_config['cpus']]
    vb.customize ['modifyvm', :id, '--memory', dev_config['ram']]

    # Add bridged adaptor for network ip.  This is not reliable.
    if dev_config['bridged_adapter']
      config.vm.network 'public_network', bridge: dev_config['bridged_adapter'], ip: dev_config['bridged_ip'], adapter: 2
    end
  end

  # Optional project compose
  if project_config['compose'] && (!dev_config['compose_replace'] || !dev_config['compose'])
    config.vm.provision :shell, :path => "vagrant/compose.sh", name: "Docker Compose", args: "/vagrant/#{project_config['compose']}"
  end

  # Optional dev compose
  if dev_config['compose']
    config.vm.provision :shell, :path => "vagrant/compose.sh", name: "Docker Compose", args: "/vagrant/#{dev_config['compose']}"
  end

  # Optional project bootstrap
  if project_config['bootstrap']
    config.vm.provision :shell, :path => "#{project_config['bootstrap']}", name: "project"
  end
end
