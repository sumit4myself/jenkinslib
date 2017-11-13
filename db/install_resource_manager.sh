#!/bin/bash

CURRENT_DATETIME=`date +%d%m%y%H%M`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "$CURRENT_DATETIME - Starting database resource_manager installation" | tee "$DIR/install_resource_manager.log"

if [ $# -eq 1 ] 
then 
    db_host_ip=$1
else
	echo "HOST DEFAULT"
    db_host_ip=127.0.0.1
fi

source $DIR/resource_manager/init.cfg
cd $DIR/resource_manager
./resource_manager_fullDB.sh $db_host_ip
if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully resource_manager/resource_manager_fullDB" | tee -a "$DIR/install_resource_manager.log"
else
	echo "$CURRENT_DATETIME - Not successfully resource_manager/resource_manager_fullDB" | tee -a "$DIR/install_resource_manager.log"
	exit 1
fi

cd $DIR/resource_manager
./resource_manager_configuration.sh $db_host_ip
if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully resource_manager/resource_manager_configuration" | tee -a "$DIR/install_resource_manager.log"
else
	echo "$CURRENT_DATETIME - Not successfully resource_manager/resource_manager_configuration" | tee -a "$DIR/install_resource_manager.log"
	exit 1
fi
