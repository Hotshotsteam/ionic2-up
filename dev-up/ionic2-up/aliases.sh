#!/bin/sh

source /etc/profile.d/dev-up.sh

mkdir -p /vagrant/dev-up/temp
mkdir -p /vagrant/dev-up/temp/.android
mkdir -p /vagrant/dev-up/temp/.gradle

if [ ! -f /usr/bin/ionic ]; then
  echo '#!/bin/sh' > /usr/bin/ionic
  echo "docker run --rm -ti --privileged \
    -v /dev/bus/usb:/dev/bus/usb \
    -v /vagrant/dev-up/temp/.android:/root/.android:rw \
    -v /vagrant/dev-up/temp/.gradle:/root/.gradle:rw \
    -v=\$PWD:/project:rw \
    -p 8100:8100 -p 35729:35729 -p 5037:5037 \
    hotshotsxyz/ionic2-up:dev \
    ionic \$@" \
  > /usr/bin/ionic
  chmod +x /usr/bin/ionic
fi

if [ ! -f /usr/bin/adb ]; then
  echo '#!/bin/sh' > /usr/bin/adb
  echo "docker run --rm -ti --privileged \
    -v /dev/bus/usb:/dev/bus/usb \
    -v /vagrant/dev-up/temp/.android:/root/.android:rw \
    -v=\$PWD:/project:rw \
    -p 8100:8100 -p 35729:35729 -p 5037:5037 \
    hotshotsxyz/ionic2-up:dev /bin/bash -c \". /root/.bashrc && \
    adb \$@\"" \
  > /usr/bin/adb
  chmod +x /usr/bin/adb
fi

if [ ! -f /usr/bin/npm ]; then
  echo '#!/bin/sh' > /usr/bin/npm
  echo "docker run --rm -ti --privileged \
    -v=\$PWD:/project:rw \
    -p 8100:8100 -p 35729:35729 -p 5037:5037 \
    hotshotsxyz/ionic2-up:dev /bin/bash -c \". /root/.bashrc && \
    npm \$@\"" \
  > /usr/bin/npm
  chmod +x /usr/bin/npm
fi
