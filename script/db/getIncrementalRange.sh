#!/bin/bash
set -e
set -u

databseName=$1

if [  -z "$1" ] || [  -z "$2" ]
  then
    echo "Database name must be provided eg: [ ./fulldb.sh admin_service] "
    exit 1
fi

echo "Getting Incremental range from [${databseName}]"

export start_incremental=1
export last_incremental=2

