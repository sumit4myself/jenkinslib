#!/bin/bash

CURRENT_DATETIME=`date +%d%m%y%H%M`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "$CURRENT_DATETIME - Starting database rollback for Cassandra" | tee "$DIR/rollback_cassandra.log"

#Installation of Cassandra db (roll) - avs_bookmark
cd $DIR/avs_bookmark
  ./avs_incremental_rollback.sh 
  if [ $? -eq 0 ]; then
  	echo "$CURRENT_DATETIME - Successfully avs_bookmark/avs_incremental_rollback.sh" | tee -a "$DIR/rollback_cassandra.log"
  else
  	echo "$CURRENT_DATETIME - Not successfully avs_bookmark/avs_incremental_rollback.sh" | tee -a "$DIR/rollback_cassandra.log"
  	exit 1
  fi    

#Installation of Cassandra db (roll) - avs_concurrent_streams
cd $DIR/avs_concurrent_streams
  ./avs_incremental_rollback.sh 
  if [ $? -eq 0 ]; then
    echo "$CURRENT_DATETIME - Successfully avs_concurrent_streams/avs_incremental_rollback.sh" | tee -a "$DIR/rollback_cassandra.log"
  else
    echo "$CURRENT_DATETIME - Not successfully avs_concurrent_streams/avs_incremental_rollback.sh" | tee -a "$DIR/rollback_cassandra.log"
    exit 1
  fi  

#Installation of Cassandra db (roll) - group_definition
cd $DIR/group_definition
  ./avs_incremental_rollback.sh 
  if [ $? -eq 0 ]; then
    echo "$CURRENT_DATETIME - Successfully group_definition/avs_incremental_rollback.sh" | tee -a "$DIR/rollback_cassandra.log"
  else
    echo "$CURRENT_DATETIME - Not successfully group_definition/avs_incremental_rollback.sh" | tee -a "$DIR/rollback_cassandra.log"
    exit 1
  fi    
  
echo "$CURRENT_DATETIME - avs_incremental_rollback.sh Successfully completed" | tee -a "$DIR/rollback_cassandra.log"
