#!/bin/sh

# Include shared
source /vagrant/dev-up/shared.sh

# Check cache folder is mounted
if [ ! -d /docker-cache ]; then
  error_exit "/docker-cache not synced, check your Vagrantfile"
fi

# Wait for docker
wait_docker

echo "Saving docker image cache..."
echo "You can now use your development server while the docker image cache is being saved."

# Save images
errors=0
saved=0
for image in `docker images | awk '{print $1 "#" $2 "#" $3}' | grep -v '<none>' | tail -n +2`
do
  error=0

  name=$(echo $image | cut -f1 -d#)
  tag=$(echo $image | cut -f2 -d#)
  hash=$(echo $image | cut -f3 -d#)

  if [ ! -f /docker-cache/$name-$tag-$hash.tar ]; then
    docker save -o /docker-cache/$name-$tag-$hash.tar $name:$tag &>/dev/null || error=1
  fi

  if [ $error -eq 0 ]; then
    saved=$((saved + 1))
  else
    errors=$((errors + 1))
  fi
done

echo "saved $saved images with $errors errors"

# Allow this script to be run with 'cache-docker'
if [ ! -f /usr/bin/cache-docker ]; then
  ln -s /vagrant/dev-up/docker-cache-save.sh /usr/bin/cache-docker
fi
