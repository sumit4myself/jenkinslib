#!/bin/bash

CURRENT_DATETIME=`date +%d%m%y%H%M`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "$CURRENT_DATETIME - ReplaceWithAnsiblePlaceholder.sh" | tee "$DIR/ReplaceWithAnsiblePlaceholder.log"

if [ $# -eq 2 ]
then
	db_host_netmask=$2
	db_host_ip=$1
elif [ $# -eq 1 ] 
then 
	echo "NETMASK DEFAULT"
    db_host_netmask=10.0.0.%
	db_host_ip=$1
else
	echo "NETMASK DEFAULT"
    db_host_netmask=10.0.0.%
	echo "HOST DEFAULT"
	db_host_ip=127.0.0.1
fi

cd $DIR
echo $DIR

source $DIR/init.cfg
mysql -u$username -h$db_host_ip -p$userpass --port=$port_number <<EOF
# source SqlAnsiblePlaceholder/publisherPointsNPVR.sql;
# source SqlAnsiblePlaceholder/avsbeSysParam_HttpExternalEndpoint.sql;
# source SqlAnsiblePlaceholder/rpgwSysParam_HttpExternalEndpoint.sql;
EOF

echo "$CURRENT_DATETIME - ReplaceWithAnsiblePlaceholder.sh Successfully completed" | tee -a "$DIR/ReplaceWithAnsiblePlaceholder.log"