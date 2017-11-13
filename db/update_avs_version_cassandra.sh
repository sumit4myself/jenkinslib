#!/bin/bash

CURRENT_DATETIME=`date +%d%m%y%H%M`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "$CURRENT_DATETIME - Starting database updation of release version in avs_version." | tee -a "$DIR/install_cassandra.log"

source $DIR/avs_bookmark/init.cfg

export CSQL=$CSQL
export CQLSH_HOST=$CQLSH_HOST
export CQLSH_PORT=$CQLSH_PORT

$CSQL $CQLSH_HOST $CQLSH_PORT -e "TRUNCATE $keyspace.avs_version;"

#insert version
$CSQL $CQLSH_HOST $CQLSH_PORT -e "insert into $keyspace.avs_version (creation_date, update_date, avs_release, avs_last_incremental, avs_start_incremental) values (totimestamp(now()), totimestamp(now()), '$avs_release', 0, 0);"

if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully updated avs_version - avs_bookmark" | tee -a "$DIR/install_cassandra.log"
else
	echo "$CURRENT_DATETIME - Not successfully updated avs_version - avs_bookmark" | tee -a "$DIR/install_cassandra.log"
	exit 1
fi

echo "$CURRENT_DATETIME - update_avs_version_cassandra.sh Successfully completed - avs_bookmark" | tee -a "$DIR/install_cassandra.log"

source $DIR/avs_concurrent_streams/init.cfg

export CSQL=$CSQL
export CQLSH_HOST=$CQLSH_HOST
export CQLSH_PORT=$CQLSH_PORT

$CSQL $CQLSH_HOST $CQLSH_PORT -e "TRUNCATE $keyspace.avs_version;"

#insert version
$CSQL $CQLSH_HOST $CQLSH_PORT -e "insert into $keyspace.avs_version (creation_date, update_date, avs_release, avs_last_incremental, avs_start_incremental) values (totimestamp(now()), totimestamp(now()), '$avs_release', 0, 0);"

if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully updated avs_version - avs_concurrent_streams" | tee -a "$DIR/install_cassandra.log"
else
	echo "$CURRENT_DATETIME - Not successfully updated avs_version - avs_concurrent_streams" | tee -a "$DIR/install_cassandra.log"
	exit 1
fi

echo "$CURRENT_DATETIME - update_avs_version_cassandra.sh Successfully completed - avs_concurrent_streams" | tee -a "$DIR/install_cassandra.log"


source $DIR/group_definition/init.cfg

export CSQL=$CSQL
export CQLSH_HOST=$CQLSH_HOST
export CQLSH_PORT=$CQLSH_PORT

$CSQL $CQLSH_HOST $CQLSH_PORT -e "TRUNCATE $keyspace.avs_version;"

#insert version
$CSQL $CQLSH_HOST $CQLSH_PORT -e "insert into $keyspace.avs_version (creation_date, update_date, avs_release, avs_last_incremental, avs_start_incremental) values (totimestamp(now()), totimestamp(now()), '$avs_release', 0, 0);"

if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully updated avs_version - group_definition" | tee -a "$DIR/install_cassandra.log"
else
	echo "$CURRENT_DATETIME - Not successfully updated avs_version - group_definition" | tee -a "$DIR/install_cassandra.log"
	exit 1
fi

echo "$CURRENT_DATETIME - update_avs_version_cassandra.sh Successfully completed - group_definition" | tee -a "$DIR/install_cassandra.log"
