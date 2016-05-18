#!/bin/sh

# Include shared
source /vagrant/vagrant/shared.sh

# Check cache folder is mounted
if [ ! -d /docker-cache ]; then
  error_exit "/docker-cache not synced, check your Vagrantfile"
fi

# Wait for docker
wait_docker

# Save the cache
echo "Saving docker image cache..."
echo "You can now use your development server while the docker image cache is being saved."

# TODO: Save each image as a separate tar file
IMAGES=`docker images | awk '{print $1}' | grep -v '<none>' | tail -n +2`
docker save -o /docker-cache/images.tar $(echo $IMAGES) || error_exit "Could not save docker image cache"

echo "docker image cache saved."

# Allow this script to be run with 'cache-docker'
if [ ! -f /usr/bin/cache-docker ]; then
  ln -s /vagrant/vagrant/docker-cache-save.sh /usr/bin/cache-docker
fi
