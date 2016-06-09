#!/bin/sh

source /vagrant/dev-up/shared.sh

# Parse arguments
if [ -z $1 ]; then
  echo "Running tailmon fs event forwarding but no log file was specified.  Check your config."
  return 1;
fi

FULL_PATH=$1

# Split into the workdir and the log file
PROJECT_PATH=$(dirname "${FULL_PATH}")
FILE_NAME=$(basename "${FULL_PATH}")

# Wait for docker
wait_docker

# Stop and remove tailmon if it's running or exists already
RUNNING=$(docker inspect --format="{{ .State.Running }}" tailmon 2> /dev/null)
if [ $? -eq 0 ]; then
  if [ "$RUNNING" == "true" ]; then
    echo "Stopping tailmon..."
    docker stop tailmon || error_exit "Could not stop tailmon container"
  fi
  docker rm tailmon &>/dev/null || error_exit "Could not remove tailmon container"
fi

# Build the tailmon image if it doesn't exist
docker images | awk '{print $1 ":" $2}' | grep 'hotshotsxyz\/tailmon:dev' &>/dev/null || \
  docker build -f /vagrant/dev-up/tailmon/tailmon.Dockerfile -t hotshotsxyz/tailmon:dev /vagrant/dev-up/tailmon

# Start tailmon
docker run --name="tailmon" -d -v=$PROJECT_PATH:/project:rw hotshotsxyz\/tailmon:dev tailmon /project $FILE_NAME
