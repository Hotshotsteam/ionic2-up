#!/bin/sh

# Include shared
source /vagrant/dev-up/shared.sh

HOST_CACHE=/vagrant/dev-up/cache/tce/
GUEST_CACHE=/tmp/tce/optional/

if [ -z $1 ]; then
  error_exit "No packages specified for cached installation"
fi

# Load host cache
if [ -d $HOST_CACHE ] && [ `ls $HOST_CACHE | wc -l` -gt 0 ] ; then
  yes n | cp  $HOST_CACHE* $GUEST_CACHE
fi

# Install specified packages
for ext in $@
do
  su -c "tce-load -i $ext" docker &>/dev/null
  if [ ! $? -eq 0 ]; then
    echo "Downloading tce package $ext..."
    su -c "tce-load -wi $ext" docker &>/dev/null
  fi
done

# Save guest cache
if [ ! -d $GUEST_CACHE ]; then
  mkdir $GUEST_CACHE || error_exit "Could not create host directory $GUEST_CACHE for tce caching"
fi

if [ `ls $GUEST_CACHE | wc -l` -gt 0 ]; then
  yes n | cp $GUEST_CACHE* $HOST_CACHE
fi

echo "Installed and cached requested tce packages"
