#!/bin/sh

# Include shared
source /vagrant/dev-up/shared.sh

# Check cache folder is mounted
if [ ! -d /docker-cache ]; then
  error_exit "/docker-cache not synced, check your Vagrantfile"
fi

# Wait for docker
wait_docker

# Load images from cache
echo "Loading docker image cache..."

if [ `ls /docker-cache | grep .tar | wc -l` -lt 1 ]; then
  echo "No cache files to load."
  return
fi

errors=0
loaded=0
for file in `ls /docker-cache/ | grep .tar`
do
  error=0
  docker load -i "/docker-cache/$file" &>/dev/null || error=1

  if [ $error -eq 0 ]; then
    loaded=$((loaded + 1))
  else
    errors=$((errors + 1))
  fi
done

echo "loaded $loaded images from cache with $errors errors"
