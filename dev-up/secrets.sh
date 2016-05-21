#!/bin/sh
#
# Copies secrets to the appropriate location.
#
# Currently id_rsa and dockerHUB credentials are supported.
# Note that the id_rsa file must be accompanied by a public key with the same name
# and a .pub extension.
#
# Usage:
#   secrets.sh <path to id_rsa private key> <path to docker hub credentials json>

# Include shared
source /vagrant/dev-up/shared.sh

SECRETS_PATH=$1
if [ ! -d $SECRETS_PATH ]; then
  SECRETS_PATH=/vagrant/dev-up/secrets
fi

# Add id_rsa file
ID_RSA=$SECRETS_PATH/id_rsa
TARGET_ID_RSA=/home/docker/.ssh/id_rsa

if [ -f $ID_RSA ]; then
  if [ ! -f "$ID_RSA.pub" ]; then
    error_exit "Found private id_rsa but could not find public id_rsa.pub"
  fi

  cp $ID_RSA $TARGET_ID_RSA || error_exit "Could not copy id_rsa file $ID_RSA"
  chown docker.docker $TARGET_ID_RSA || error_exit "Could not chown $TARGET_ID_RSA with docker.docker"
  chmod 600 $TARGET_ID_RSA || error_exit "Could not chmod $TARGET_ID_RSA"

  cp $ID_RSA.pub $TARGET_ID_RSA.pub || error_exit "Could not copy id_rsa file $ID_RSA.pub"
  chown docker.docker $TARGET_ID_RSA.pub || error_exit "Could not chown $TARGET_ID_RSA.pub with docker.docker"
  chmod 600 $TARGET_ID_RSA.pub || error_exit "Could not chmod $TARGET_ID_RSA.pub"

  echo "Copied id_rsa public and private keys"
fi

DOCKER_HOME=/home/docker/.docker
DOCKER_SECRET=$SECRETS_PATH/.docker/config.json

# Copy DockerHUB credentials.
if [ ! -f $DOCKER_HOME/config.json ]; then
  if [ -f $DOCKER_SECRET ]; then
    if [ ! -d $DOCKER_HOME ]; then
      mkdir -p $DOCKER_HOME || error_exit "Could not make docker user config path"
    fi

    cp $DOCKER_SECRET $DOCKER_HOME/config.json || error_exit "Could not copy docker user config"
    chown docker.staff $DOCKER_HOME/config.json || error_exit "Could not chown docker user config"

    echo "Copied docker user config"
  fi
fi
