#!/bin/bash

CURRENT_DATETIME=`date +%d%m%y%H%M`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "$CURRENT_DATETIME - Starting database software_upgrade installation" | tee "$DIR/install_software_upgrade.log"

if [ $# -eq 1 ] 
then 
    db_host_ip=$1
else
	echo "HOST DEFAULT"
    db_host_ip=127.0.0.1
fi

source $DIR/software_upgrade/init.cfg
cd $DIR/software_upgrade
./software_upgrade_fullDB.sh $db_host_ip
if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully software_upgrade/software_upgrade_fullDB" | tee -a "$DIR/install_software_upgrade.log"
else
	echo "$CURRENT_DATETIME - Not successfully software_upgrade/software_upgrade_fullDB" | tee -a "$DIR/install_software_upgrade.log"
	exit 1
fi

cd $DIR/software_upgrade
./software_upgrade_configuration.sh $db_host_ip
if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully software_upgrade/software_upgrade_configuration" | tee -a "$DIR/install_software_upgrade.log"
else
	echo "$CURRENT_DATETIME - Not successfully software_upgrade/software_upgrade_configuration" | tee -a "$DIR/install_software_upgrade.log"
	exit 1
fi
