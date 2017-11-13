#!/bin/bash

CURRENT_DATETIME=`date +%d%m%y%H%M`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "$CURRENT_DATETIME - DropCassandra.sh" | tee "$DIR/DropCassandra.log"

source $DIR/avs_bookmark/init.cfg

export CSQL=$CSQL
export CQLSH_HOST=$CQLSH_HOST
export CQLSH_PORT=$CQLSH_PORT

echo "$CSQL $CQLSH_HOST $CQLSH_PORT"

#Drop Cassandra - avs_bookmark
$CSQL $CQLSH_HOST $CQLSH_PORT -e "drop keyspace if exists avs_bookmark;" >> "$DIR/DropCassandra.log"

if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully Drop Cassandra - avs_bookmark" | tee -a "$DIR/DropCassandra.log"
else
	echo "$CURRENT_DATETIME - Not successfully Drop Cassandra - avs_bookmark" | tee -a "$DIR/DropCassandra.log"
	exit 1
fi

source $DIR/avs_concurrent_streams/init.cfg

export CSQL=$CSQL
export CQLSH_HOST=$CQLSH_HOST
export CQLSH_PORT=$CQLSH_PORT

echo "$CSQL $CQLSH_HOST $CQLSH_PORT"

#Drop Cassandra - avs_concurrent_streams
$CSQL $CQLSH_HOST $CQLSH_PORT -e "drop keyspace if exists avs_concurrent_streams;" >> "$DIR/DropCassandra.log"

if [ $? -eq 0 ]; then
    echo "$CURRENT_DATETIME - Successfully Drop Cassandra - avs_concurrent_streams" | tee -a "$DIR/DropCassandra.log"
else
    echo "$CURRENT_DATETIME - Not successfully Drop Cassandra - avs_concurrent_streams" | tee -a "$DIR/DropCassandra.log"
    exit 1
fi

source $DIR/group_definition/init.cfg

export CSQL=$CSQL
export CQLSH_HOST=$CQLSH_HOST
export CQLSH_PORT=$CQLSH_PORT

echo "$CSQL $CQLSH_HOST $CQLSH_PORT"

#Drop Cassandra - group_definition
$CSQL $CQLSH_HOST $CQLSH_PORT -e "drop keyspace if exists group_definition;" >> "$DIR/DropCassandra.log"

if [ $? -eq 0 ]; then
    echo "$CURRENT_DATETIME - Successfully Drop Cassandra - group_definition" | tee -a "$DIR/DropCassandra.log"
else
    echo "$CURRENT_DATETIME - Not successfully Drop Cassandra - group_definition" | tee -a "$DIR/DropCassandra.log"
    exit 1
fi


echo "$CURRENT_DATETIME - DropCassandra.sh Successfully completed" | tee -a "$DIR/DropCassandra.log"
