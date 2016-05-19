# ionic2-up
Fast starting, simple bootstrap for your ionic2 project's development environment.

## Overview
The goal of this project is to provide the simplest possible on-boarding for
developers on an ionic2 project.  To start on a project, developers simply:

1. Install git
1. Install Vagrant

```sh
git clone <path/to/repo>
cd <path/to/repo>
vagrant up
```

A lightweight 36mb, TinyCore based
[boot2docker](https://github.com/boot2docker/boot2docker) VM image is used care
of [Alban Montaigu](https://github.com/AlbanMontaigu)'s
[Vagrant box](https://atlas.hashicorp.com/AlbanMontaigu/boxes/boot2docker).

The bootstrap is arranged in a way to allow projects and developers to customise
their development environment without editing the default files.  This allows
projects to update developer-up when new features are added.

Configuration is also arranged to allow new bootstrap projects based on this one,
to set up more specific platforms and environments without specific app code.

Project dependencies are expected to be provided by docker containers and
are started with docker-compose.

## Features

### Containerised Dependencies
Your project dependencies can be containerised and specified in a simple
docker-compose.yml which will auto fetch and start on ```vagrant up```.

### Simple configuration
Use a simple ```project-config.yml``` and ```developer-config.yml``` to
customise the box provisioning without editing the boilerplate Vagrantfile or
shell scripts.

Projects can:
- Specify the default ports to forward, as used by the project.
- Customise the default box and host names.
- Specify additional TinyCore extensions to load.
- Specify an additional shell script to run on provision.
- Specify a docker-compose.yml to run after provision.

Developers can:
- Customise the resources used by the box (RAM and CPU).
- Customise the box and host names.
- Override and add additional ports to forward.
- Override the SSH port.
- Add a bridged network adapter to join the host network.
- Add SSH keys to the box (for example, to authenticate with GitHUB).
- Specify additional TinyCore extensions to load.
- Specify an additional shell script to run on provision.
- Specify a docker-compose.yml to run after provision, in place of, or in
addition to the project.
- Enable Docker image caching by specifying a cache path on the host.

### Image and Package caching
Docker images and tce packages can be cached on the host, greatly reducing the
restart time on ```vagrant destroy && vagrant up```.

To enable, configure ```docker_cache_path```.

TinyCore extensions are automatically cached in the
project's ```dev-up/cache/tce``` directory.

## Usage
The bootstrap can be used in a number of ways, depending on your project and
workflow.  Typically you would create a ```dev-up/project-config.yml``` and
version it in your repo, while developers on your project create
a ```dev-up/developer-config.yml```, which is ignored.

See ```dev-up/config-example.yml``` for more detailed help.

### Boilerplate
Simply download the raw files from this repo and add to your project.  Take
ownership and maintain the bootstrap as your project requires.  Optionally star
this repo to watch for any interesting additions.

### Remote
Add this repository as a remote:

```git remote add dev-up https://github.com/Hotshotsteam/developer-up.git```

You can now fetch and merge updates:
  ```git fetch dev-up```
  ```git merge dev-up/master```

### Fork
Fork this repo and track updates.  This is useful if you are creating your own
development bootstrap for specific platforms and libraries that other projects
can use.

## Tips
If developers are using a non linux host and prefer using git on a linux shell,
they can add less to the ```tce_extensions``` and provide an SSH key for gitHUB
in their development config:

```yaml
tce_extensions:
  less
secret_rsa: dev-up/secrets/id_rsa
```

This will offer a better git experience in the guest.

## Extending
You can extend the project to provide a new bootstrap with additional
environment for specific platforms.  Update ```dev-up/configs.yml``` with a new
base config.  For example:

```yaml
configs:
  - nodejs-config.yml
  - project-config.yml
  - developer-config.yml
```

Then include the new configs in your repo.  Now projects can use your bootstrap
in the same way they would use developer-up.

## Contributing
Pull requests are welcome.

Do note the project goals:

- Simplicity (```vagrant up```)
- The ability to pull updates into existing projects without conflicts.

Support for other providers, and improvements for OSX (currently untested) are especially welcome.

## See also
- Albian Montaigu's [boot2docker-vagrant-template](https://github.com/AlbanMontaigu/boot2docker-vagrant-template)
