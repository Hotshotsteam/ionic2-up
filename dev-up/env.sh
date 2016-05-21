#!/bin/sh

PROFILE_FILE=/etc/profile.d/dev-up.sh

echo '#!/bin/sh' > $PROFILE_FILE
echo "export PROJECT_PATH=$1" > $PROFILE_FILE
