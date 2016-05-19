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

# Add id_rsa file
ID_RSA=$1
TARGET_ID_RSA=/home/docker/.ssh/id_rsa

if [ ! -z "$ID_RSA" -a "$ID_RSA" != " " ]; then
  ID_RSA_FILE=$ID_RSA

  if [ ! -f $ID_RSA ]; then
    error_exit "Could not find id_rsa file $ID_RSA"
  fi
  if [ ! -f "$ID_RSA.pub" ]; then
    error_exit "Could not find public id_rsa file $ID_RSA.pub"
  fi

  cp $ID_RSA $TARGET_ID_RSA || error_exit "Could not copy id_rsa file $ID_RSA"
  chown docker.docker $TARGET_ID_RSA || error_exit "Could not chown $TARGET_ID_RSA with docker.docker"
  chmod 600 $TARGET_ID_RSA || error_exit "Could not chmod $TARGET_ID_RSA"

  cp $ID_RSA.pub $TARGET_ID_RSA.pub || error_exit "Could not copy id_rsa file $ID_RSA.pub"
  chown docker.docker $TARGET_ID_RSA.pub || error_exit "Could not chown $TARGET_ID_RSA.pub with docker.docker"
  chmod 600 $TARGET_ID_RSA.pub || error_exit "Could not chmod $TARGET_ID_RSA.pub"

  echo "Copied id_rsa public and private keys"
fi
