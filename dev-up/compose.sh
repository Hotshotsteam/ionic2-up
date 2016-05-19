#!/bin/sh

# Include shared
source /vagrant/dev-up/shared.sh

# Constants
COMPOSE_VERSION='1.7.1'
COMPOSE_BIN_CACHE="/vagrant/dev-up/cache/docker-compose-$COMPOSE_VERSION"
CACHE_PATH="/vagrant/dev-up/cache"

# Parse args
OUT=/dev/null
for i in "$@"; do
  case $i in
    -v|--verbose)
    OUT=/dev/stdout
    ;;
  esac
done

for last; do true; done
COMPOSE_FILE=$last

echo "Composing with $COMPOSE_FILE..."

if [ ! -f $COMPOSE_FILE ]; then
  error_exit "Could not load compose file"
fi

# Check if we need to install compose
install=true
version="$(docker-compose version --short)" &> /dev/null
if [ $? -eq 0 ] && [ $version == $COMPOSE_VERSION ]; then
  install=
fi

if [ $install ]; then
  # Ensure compose is installed
  if [ ! -f $COMPOSE_BIN_CACHE ]; then
    echo "Installing docker-compose..."

    if [ ! -d $CACHE_PATH ]; then
      mkdir -p $CACHE_PATH || error_exit "Could not make cache dir for compose"
    fi

    echo "Downloading..."
    curl -L \
      https://github.com/docker/compose/releases/download/$COMPOSE_VERSION/docker-compose-`uname -s`-`uname -m` \
      -o $COMPOSE_BIN_CACHE \
      &> $OUT \
    || error_exit "Could not download docker-compose"
  fi

  cp -f $COMPOSE_BIN_CACHE /usr/local/bin/docker-compose || error_exit "Could not copy $COMPOSE_BIN_CACHE to /usr/local/bin/docker-compose"
  chmod +x /usr/local/bin/docker-compose || error_exit "Could not add executable bit to docker-compose"
fi

# Wait for docker to run
wait_docker

# If docker hasn't started, try starting it
if [ ! $? -eq 0 ]; then
  /etc/init.d/docker start &>/dev/null || error_exit "Could not start docker"
  if ! wait_docker; then
    echo error_exit "Could not start docker..."
  fi
fi

# Clean up any exited containers
if [ $(docker ps -aq -f status=exited | wc -l) -gt 0 ]; then
  docker ps -aq -f status=exited | awk '{print $1}' | xargs docker rm &>/dev/null
fi

# Start containers with compose
echo "Starting compose..."

# Start compose
docker-compose -f $COMPOSE_FILE up -d || error_exit "Could not compose project"
