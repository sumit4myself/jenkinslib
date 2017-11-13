#!/bin/bash

CURRENT_DATETIME=`date +%d%m%y%H%M`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "$CURRENT_DATETIME - Starting database installation" | tee "$DIR/install_cassandra.log"

# AVS-15889 - Skip install/upgrade schema if the flag is N
source $DIR/init.cfg

if [ $avs_bookmark == "Y" ]; then
	#Installation of Cassandra db (full) - avs_bookmark
	  cd $DIR/avs_bookmark
	  ./install.sh
	  if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully avs_bookmark/install.sh" | tee -a "$DIR/install_cassandra.log"
	  else
		echo "$CURRENT_DATETIME - Not successfully avs_bookmark/install.sh" | tee -a "$DIR/install_cassandra.log"
		exit 1
	  fi
else
	echo "$CURRENT_DATETIME - Skip avs_bookmark/install.sh" | tee -a "$DIR/install.log"
fi

if [ $avs_concurrent_streams == "Y" ]; then
	#Installation of Cassandra db (full) - avs_concurrent_streams
	  cd $DIR/avs_concurrent_streams
	  ./install.sh
	  if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully avs_concurrent_streams/install.sh" | tee -a "$DIR/install_cassandra.log"
	  else
		echo "$CURRENT_DATETIME - Not successfully avs_concurrent_streams/install.sh" | tee -a "$DIR/install_cassandra.log"
		exit 1
	  fi
else
	echo "$CURRENT_DATETIME - Skip avs_concurrent_streams/install.sh" | tee -a "$DIR/install.log"
fi

if [ $group_definition == "Y" ]; then
	#Installation of Cassandra db (full) - group_definition
	  cd $DIR/group_definition
	  ./install.sh
	  if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully group_definition/install.sh" | tee -a "$DIR/install_cassandra.log"
	  else
		echo "$CURRENT_DATETIME - Not successfully group_definition/install.sh" | tee -a "$DIR/install_cassandra.log"
		exit 1
	  fi
else
	echo "$CURRENT_DATETIME - Skip group_definition/install.sh" | tee -a "$DIR/install.log"
fi

echo "$CURRENT_DATETIME - install_cassandra.sh Successfully completed" | tee -a "$DIR/install_cassandra.log"
