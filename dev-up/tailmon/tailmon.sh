#!/bin/sh

# Parse arguments
WORK_PATH=$PWD
if [ ! -z $1 ]; then
  WORK_PATH=$1
fi
WORK_PATH=${WORK_PATH%/}

TAIL_FILE=.tailmon
if [ ! -z $2 ]; then
  TAIL_FILE=$2
fi
TAIL_FILE=$WORK_PATH/$TAIL_FILE

if [ ! -f $TAIL_FILE ]; then
    touch $TAIL_FILE
fi

tail -fn0 $TAIL_FILE | \
while read change_file; do
  echo "$WORK_PATH/$change_file was updated"
  touch $WORK_PATH/$change_file

  # some times truncate the tail file
  if [ $(( RANDOM % 100 )) -eq 50 ]; then
    echo "Truncating tail file.."
    > $TAIL_FILE
  fi
done
