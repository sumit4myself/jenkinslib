#!/bin/bash

CURRENT_DATETIME=`date +%d%m%y%H%M`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "$CURRENT_DATETIME - Starting database installation Incrementals for Cassandra" | tee "$DIR/install_cassandra.log"

# AVS-15889 - Skip install/upgrade schema if the flag is N
source $DIR/init.cfg

if [ $avs_bookmark == "Y" ]; then
	#Installation of Cassandra incremental - avs_bookmark
	cd $DIR/avs_bookmark
	  ./avs_incremental.sh
	  if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully avs_bookmark/avs_incremental" | tee -a "$DIR/install_cassandra.log"
	  else
		echo "$CURRENT_DATETIME - Not successfully avs_bookmark/avs_incremental" | tee -a "$DIR/install_cassandra.log"
		exit 1
	  fi
else
	echo "$CURRENT_DATETIME - Skip avs_bookmark/avs_incremental" | tee -a "$DIR/install.log"
fi

if [ $avs_concurrent_streams == "Y" ]; then
	#Installation of Cassandra incremental - avs_concurrent_streams
	cd $DIR/avs_concurrent_streams
	  ./avs_incremental.sh
	  if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully avs_concurrent_streams/avs_incremental" | tee -a "$DIR/install_cassandra.log"
	  else
		echo "$CURRENT_DATETIME - Not successfully avs_concurrent_streams/avs_incremental" | tee -a "$DIR/install_cassandra.log"
		exit 1
	  fi
else
	echo "$CURRENT_DATETIME - Skip avs_concurrent_streams/avs_incremental" | tee -a "$DIR/install.log"
fi

if [ $group_definition == "Y" ]; then
	#Installation of Cassandra incremental - group_definition
	cd $DIR/group_definition
	  ./avs_incremental.sh
	  if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully group_definition/avs_incremental" | tee -a "$DIR/install_cassandra.log"
	  else
		echo "$CURRENT_DATETIME - Not successfully group_definition/avs_incremental" | tee -a "$DIR/install_cassandra.log"
		exit 1
	  fi
else
	echo "$CURRENT_DATETIME - Skip group_definition/avs_incremental" | tee -a "$DIR/install.log"
fi
echo "$CURRENT_DATETIME - install_cassandra.sh Successfully completed" | tee -a "$DIR/install_cassandra.log"
