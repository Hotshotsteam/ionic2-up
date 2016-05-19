#!/bin/sh
# Shared functions and constants

CACHE_PATH="/docker-cache"

wait_on () {
  if [ -z "$1" ]; then
    echo "Must specify a command to wait_on"
    return 1
  fi

  LIMIT=$2
  if [ -z $2 ]; then
    LIMIT=3
  fi

  elapsed=0
  eval $1 &>/dev/null
  r=$?
  until [ $r -eq 0 ]; do
    eval $1 &>/dev/null
    r=$?
    usleep 100000
    elapsed=$((elapsed + 1))
    if [ $elapsed -gt $((LIMIT * 10)) ]; then
      return 1
    fi
  done

  return 0
}

wait_docker() {
  wait_on 'pidof docker'
  wait_on "docker -H unix://$1 ps -q"

  return $?
}

error_exit () {
  echo "${1:-\"Unknown Error\"}" 1>&2
  exit 1
}
