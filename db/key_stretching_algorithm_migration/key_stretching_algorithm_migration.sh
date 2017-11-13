#!/bin/bash

CURRENT_DATETIME=`date +%d%m%y%H%M`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "$CURRENT_DATETIME - Starting key stretching algorithm migration" | tee "$DIR/key_stretching_algorithm_migration.log"

db_host_ip=$1

source $DIR/../init.cfg

mysql -uroot -p$password --host=$db_host_ip --port=$port_number  <<EOF
	SOURCE key_stretching_algorithm_migration.sql
    SELECT "key_stretching_algorithm_migration OK";
    
EOF
