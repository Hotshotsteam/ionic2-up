#!/bin/sh

source /etc/profile.d/dev-up.sh

if [ ! -f /usr/bin/ionic ]; then
  echo '#!/bin/sh' > /usr/bin/ionic
  echo "docker run --rm -ti --privileged \
    -v /dev/bus/usb:/dev/bus/usb \
    -v=$PROJECT_PATH:/project:rw \
    -p 8100:8100 -p 35792:35792 -p 5037:5037 \
    hotshotsxyz/ionic2-up:dev \
    ionic \$@" \
  > /usr/bin/ionic
  chmod +x /usr/bin/ionic
fi

if [ ! -f /usr/bin/adb ]; then
  echo '#!/bin/sh' > /usr/bin/adb
  echo "docker run --rm -ti --privileged \
    -v /dev/bus/usb:/dev/bus/usb \
    -v=$PROJECT_PATH:/project:rw \
    -p 8100:8100 -p 35792:35792 -p 5037:5037 \
    hotshotsxyz/ionic2-up:dev /bin/bash -c \". /root/.bashrc && \
    adb \$@\"" \
  > /usr/bin/adb
  chmod +x /usr/bin/adb
fi
