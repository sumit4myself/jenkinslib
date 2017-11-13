#!/bin/bash

CURRENT_DATETIME=`date +%d%m%y%H%M`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "$CURRENT_DATETIME - Starting database stb_management installation" | tee "$DIR/install_stb_management.log"

if [ $# -eq 1 ] 
then 
    db_host_ip=$1
else
	echo "HOST DEFAULT"
    db_host_ip=127.0.0.1
fi

source $DIR/stb_management/init.cfg
cd $DIR/stb_management
./stb_management_fullDB.sh $db_host_ip
if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully stb_management/stb_management_fullDB" | tee -a "$DIR/install_stb_management.log"
else
	echo "$CURRENT_DATETIME - Not successfully stb_management/stb_management_fullDB" | tee -a "$DIR/install_stb_management.log"
	exit 1
fi

cd $DIR/stb_management
./stb_management_configuration.sh $db_host_ip
if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully stb_management/stb_management_configuration" | tee -a "$DIR/install_stb_management.log"
else
	echo "$CURRENT_DATETIME - Not successfully stb_management/stb_management_configuration" | tee -a "$DIR/install_stb_management.log"
	exit 1
fi
