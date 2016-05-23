# ionic2-up
Fast starting, simple bootstrap for your ionic 2 project's development environment.

## Overview
This project is a [developer-up](https://github.com/Hotshotsteam/developer-up) environment for Ionic 2 development.  It allows your developers to on-board with:

```sh
git clone git@github.com:Hotshotsteam/ionic2-up.git .
git clone <path/to/your/repo> project/
vagrant up
```

For more information on developer-up, see the [developer-up README.md](https://github.com/Hotshotsteam/developer-up).

## Set up

### Prerequisites
First install the pre-requisites if you don't already have them installed:

- [Git](https://git-scm.com/)
- [Vagrant](https://www.vagrantup.com/)
- [Virtualbox](https://www.virtualbox.org/)
- [Oracle VM Virtualbox Extension Pack](https://www.virtualbox.org/wiki/Downloads)

### Start the environment
**Note:** It's highly recommended to enable docker image caching before your first run.  See [Caching](https://github.com/Hotshotsteam/client/wiki/Development-Environment#caching) below.

Clone the client project and open a command line in the project directory, then:

```sh
vagrant up
```

### Customisation
The environment and VM can be customised to better suit your host machine and network.  To configure your environment without committing to the repo, create a ```dev-up/developer-config.yml``` and add the configuration that you need.  This file will be ignored by git.  See ```dev-up/example-config.yml``` for details on the available option.

For developers, the most interesting options are:

```yaml
# Port forwarding
# Forward any additional ports
forward_ports:
  8100: 8100
  35792: 35792
  5037: 5037

# Run a shell script on boot
bootstrap: dev-up/developer.sh

# SSH Port
# If this is not specified then Vagrant will resolve it for you
ssh_port: 2222

# Resources
ram: 2048
cpus: 1

# Disable key generation on vagrant up.  This allows you to use the
# default vagrant key every time.  Consider your network security first.
insecure_key: true

# Set a path for docker image caching.
# This greatly reduces vagrant destroy && vagrant up times.
docker_cache_path: C:\path\to\cache

# Specify tce extensions to install
# These are cached in dev-up/cache/tce for faster restarts.
# The extensions are installed in addition to any installed for the project.
tce_extensions:
  less
  nano

# USB devices
# Add the vendor id of any usb devices to attach.  Be aware of conflicts with other
# running boxes.
usb_devices:
  18d1
```

### Connect via SSH
Once the VM is running use ```vagrant ssh``` to get the SSH details for the machine, and optionally connect with a third party SSH terminal.

If you set ```ssh_port``` in your config then this should be the SSH port, allowing a consistent port when you stop and start the environment.

The default user and password is ```docker``` and ```tcuser``` but you will have a better experience logging in with a key.  To use the default vagrant key, set ```insecure_key``` to true in your ```developer-config.yml```.  You can then use the ```.vagrant.d/insecure_private_key``` in your home folder.  Please be aware of your network security.  Ensure the ssh port is fire-walled on your host machine.

### Caching
The environment supports caching of docker images.  This allows images to be saved to and loaded from your host machine.  Enabling docker image caching greatly reduces the time to delete and restart the development VM.  To enable caching update ```docker_cache_path``` in your ```development-config.yml``` to point to an absolute path on your host machine.

### Using Ionic and adb
The Ionic2 environment is provided by a docker image that is pulled / built on start up.  Useful wrapper scripts are also created in ```/usr/bin``` to let you use ionic and adb as if they were on the VM rather than in the container.

Simply use the ```ionic``` and ```adb``` commands as documented.

```
# Start the live server
ionic serve

# Check connected USB devices
adb devices

# Run on your android device
ionic run android
```

Commands for other tools may be added later if found to be necessary.

Note that the first time you use some of the ionic commands (```serve```, ```run```, ```build```), ionic will need to provision dependencies and platform files.  This means the first run may take some time.  These files are added to the project path (and ignored by git) so that the next time you run them, serve and build times will be much quicker.

### Connecting a USB device
Before you can run on a local Android device you will need to add the device id to your ```developer-config.yml```.  This only needs to be done once.

1. Find out the ```deviceId``` of your device (there are probably faster ways than this):
 1. Plug your device in.
 1. Open the Virtualbox app.
 1. Check for your VM in the list (```ionic2-up``` by default).
 1. If it's not there, use ```vagrant up``` to start it.
 1. If it **is** running, use ```vagrant halt``` to power off the machine.
 1. Click the VM in Virtualbox.
 1. Click *Settings* to open the Settings dialogue for the VM.
 1. Click *USB* to open the USB options.
 1. If not enabled, check *Enable USB Controller*.
 1. Select ```USB 2.0 (EHCI) Controller```.
 1. Click the *Add Device Filter* icon (usb plug with a + symbol).
 1. Hover the mouse pointer over your device in the list and make a note of the *Vendor ID*.
 1. You can *Cancel* all the dialogues and exit Virtualbox.
1. Update ```usb_devices``` in your ```developer-config.yml``` (see above) with the device id.
1. Reprovision the VM with either:
```vagrant up --provision``` or ```vagrant destroy``` and ```vagrant up```
1. Reconnect the device and check it's working in the VM with ```adb devices```.
1. Whenever you connect your device to a new dev instance, you will need to authorise the device.  Unlock the device, tap the *USB debugging connected* notification, and then allow the connection shown in the authorisation dialogue that is shown.

## Working on your project
By default ```project/``` is ignored by git, allowing you to add your project(s) here and sync them with the VM.  Simply use ```ionic``` as you normally would.  You can check out and work on multiple projects in the same ionic2-up environment.

There is also an ```ionic-up``` command which will run the ionic2-up container and
give you the shell.  This may be useful for several workflows that are not covered by
the command wrappers.

Note: Windows Users: As many npm modules use symlinks you will likely need to run 
```vagrant up``` as an administrator.

### Caveats
The docker image used for the ionic 2 environment ([hotshotsxyz/ionic2-up](https://hub.docker.com/r/hotshotsxyz/ionic2-up/)) only has the latest stable Android platform and tools.  If you need older or newer, non-stable platforms then you can create your own docker images, optionally ```FROM hotshotsxyz/ionic2-up``` and add them to your docker-compose.yml.

You can configure the docker-compose.yml to run with ```compose``` in your project or developer config.

No Xcode, as Xcode requires OSX.  It may still be convenient to use ionic2-up and ionic to prepare the Xcode project and then run a simple build on an OSX machine but I haven't tried this yet.  I will update the readme when I have.
