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

if [ ! -z "$3" ]; then
  SHELL_COMMAND=$3
fi

DEBOUNCE_TIME=5
if [ ! -z $4 ]; then
  DEBOUNCE_TIME=$4
fi
echo $DEBOUNCE_TIME

if [ ! -f $TAIL_FILE ]; then
    touch $TAIL_FILE
fi

last_run=$(date +%s)

tail -fn0 $TAIL_FILE | \
while read change_file; do
  echo "$WORK_PATH/$change_file was updated"
  touch $WORK_PATH/$change_file

  # execute command if specified
  if [ ! -z "$SHELL_COMMAND" ]; then
    time_now=$(date +%s)
    let "time_past = $time_now - $last_run"

    if [ $time_past -gt $DEBOUNCE_TIME ]; then
      last_run=$(date +%s)
      echo "triggering command \"$SHELL_COMMAND\""
      eval "$SHELL_COMMAND"
    fi
  fi

  # some times truncate the tail file
  if [ $(( RANDOM % 100 )) -eq 50 ]; then
    echo "Truncating tail file.."
    > $TAIL_FILE
  fi
done
