VAGRANTFILE_API_VERSION = '2'
require 'yaml'

# Box details
B2D_BOX="AlbanMontaigu/boot2docker"
B2D_VERSION="1.11.0"

# developer-up constants
DEV_UP_PATH="dev-up/"

# Whether the project folder was synced
project_synced = false

# Configuration
# To override add vagrant/project-config.yml and vagrant/developer-config.yml
dev_up_config = {
  # Project and developer config
  'box_check_update'   => true,
  'vm_name'            => false,
  'hostname'           => false,
  'forward_ports'      => false,
  'bootstrap'          => false,
  'compose'            => false,
  'tce_extensions'     => false,
  'host_project_path'  => 'project',
  'guest_project_path' => '/project',
  'fs_notify_log'      => false,

  # Developer config
  'ssh_port'           => false,
  'ram'                => 2048,
  'cpus'               => 1,
  'bridged_adapter'    => false,
  'bridged_ip'         => false,
  'insecure_key'       => false,
  'docker_cache_path'  => false,
  'usb_devices'        => false,
}

# Load configs specified by configs.yml
if File.exists?(DEV_UP_PATH + 'configs.yml')
  File.open(DEV_UP_PATH + 'configs.yml') do |f|
    if configs = YAML.load(f)
      if configs['configs'].length > 0
        configs['configs'].each do |config_file|
          if File.exists?(DEV_UP_PATH + config_file)
            File.open(DEV_UP_PATH + config_file, 'r') do |f|
              if loaded = YAML.load(f)
                dev_up_config = dev_up_config.merge(loaded)
              end
            end
          end
        end
      end
    end
  end
end

# Configure VM
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Configure box
  config.vm.box = B2D_BOX
  config.vm.box_version = B2D_VERSION
  config.vm.box_check_update = dev_up_config['box_check_update']

  # Configure hostname
  if hostname = dev_up_config['hostname']
    config.vm.hostname = dev_up_config['hostname']
  end

  # Allow insecure key
  if dev_up_config['insecure_key']
    config.ssh.insert_key = false
  end

  # Forwarding for SSH
  if dev_up_config['ssh_port']
    config.ssh.port = dev_up_config['ssh_port']
    config.vm.network :forwarded_port, guest: 22, host: 2200, id: "ssh", disabled: "true"
    config.vm.network :forwarded_port, guest: 22, host: dev_up_config['ssh_port']
  end

  # Port forwarding
  if dev_up_config['forward_ports'] && (dev_up_config['forward_ports'].length > 0)
    dev_up_config['forward_ports'].each_pair do |guest_port, host_port|
      config.vm.network :forwarded_port, guest: guest_port, host: host_port
    end
  end

  # Add project sync folder
  if dev_up_config['host_project_path']
    if !dev_up_config['guest_project_path']
      puts "host_project_path specified but no guest.  Check your project and developer config."
    else
      config.vm.synced_folder dev_up_config['host_project_path'], dev_up_config['guest_project_path'], create: true
      project_synced = true
    end
  end

  # Virtualbox specific customisation
  config.vm.provider :virtualbox do |vb|

    # Box name
    if dev_up_config['vm_name']
      vb.name = dev_up_config['vm_name']
    end

    # Resources
    vb.customize ["modifyvm", :id, "--cpus", dev_up_config['cpus']]
    vb.customize ['modifyvm', :id, '--memory', dev_up_config['ram']]

    # Add bridged adaptor for network ip.  This is not reliable.
    if dev_up_config['bridged_adapter']
      config.vm.network 'public_network', bridge: dev_up_config['bridged_adapter'], ip: dev_up_config['bridged_ip'], adapter: 2
    end

    # Add USB device filters
    if dev_up_config['usb_devices'] && dev_up_config['usb_devices'].length > 0
      vb.customize ["modifyvm", :id, "--usb", "on"]
      vb.customize ["modifyvm", :id, "--usbehci", "on"]

      index = 1
      dev_up_config['usb_devices'].each do |usb_device|
        vb.customize ["usbfilter", "add", "0",
        "--target", :id,
        "--name", "developer-up filter #{index}",
        "--vendorid", usb_device]

        index+=1
      end
    end

    if project_synced && (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
      vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate//srv/project", "1"]
    end
  end

  # Export environment variables
  config.vm.provision :shell, :path => DEV_UP_PATH + "env.sh", name: "Environment Variables", run: "always", args: dev_up_config['guest_project_path']

  # Load tce cache
  if dev_up_config['tce_extensions'] && (dev_up_config['tce_extensions'].length > 0)
    config.vm.provision :shell, :path => DEV_UP_PATH + "tce-cache-install.sh", name: "Load TCE Cache", run: "always", args: dev_up_config['tce_extensions']
  end

  # Load docker cache
  if dev_up_config['docker_cache_path']
    if !File.directory?(dev_up_config['docker_cache_path'])
      puts "Cannot find host docker cache path #{dev_up_config['docker_cache_path']}"
      dev_up_config['docker_cache_path'] = false
    else
      config.vm.synced_folder dev_up_config['docker_cache_path'], '/docker-cache'
      config.vm.provision :shell, :path => DEV_UP_PATH + "docker-cache-load.sh", name: "Load Docker Cache"
    end
  end

  # Provision secrets
  config.vm.provision :shell, :path => DEV_UP_PATH + "secrets.sh", name: "Secrets", run: "always", args: "/vagrant/#{DEV_UP_PATH}/secrets"

  # Optional project compose
  if dev_up_config['compose']
    if !dev_up_config['compose'].kind_of?(Array)
      dev_up_config['compose'] = [dev_up_config['compose']]
    end

    dev_up_config['compose'].each do |compose_file|
      config.vm.provision :shell, :path => DEV_UP_PATH + "compose.sh", name: "Docker Compose", run: "always", args: "/vagrant/#{compose_file}"
    end
  end

  # Optional bootstrap
  if dev_up_config['bootstrap']
    config.vm.provision :shell, :path => "#{dev_up_config['bootstrap']}", run: "always", name: "Project Bootstrap"
  end

  # Forward fs events from file name log
  if dev_up_config['fs_notify_log']
    config.vm.provision :shell, :path => DEV_UP_PATH + "tailmon-up.sh", name: "FS Event Forwarding", run: "always", args: dev_up_config['fs_notify_log']
  end

  # Save docker cache
  if dev_up_config['docker_cache_path']
    config.vm.provision :shell, :path => DEV_UP_PATH + "docker-cache-save.sh", name: "Docker Save Cache"
  end
end
