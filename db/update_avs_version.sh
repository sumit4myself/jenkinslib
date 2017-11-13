#!/bin/bash

CURRENT_DATETIME=`date +%d%m%y%H%M`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "$CURRENT_DATETIME - update_avs_version.sh" | tee "$DIR/update_avs_version.log"

if [ $# -eq 1 ]
then 
	db_host_ip=$1
else
	echo "HOST DEFAULT"
	db_host_ip=127.0.0.1
fi

echo "db_host_ip = $db_host_ip"

cd $DIR

source $DIR/init.cfg

mysql -u$username -h$db_host_ip -p$userpass --port=$port_number <<EOF

update authentication.avs_version set avs_release = $avs_release, avs_last_incremental = 1, avs_start_incremental = 0 where avs_release = '6.2';
update avs_be.avs_version set avs_release = $avs_release, avs_last_incremental = 8, avs_start_incremental = 0 where avs_release = '6.2';
update commerce.avs_version set avs_release = $avs_release, avs_last_incremental = 4, avs_start_incremental = 0 where avs_release = '6.2';
update cre_data_normalization.avs_version set avs_release = $avs_release, avs_last_incremental = 0, avs_start_incremental = 0 where avs_release = '6.2';
update csmdb_tenant_1.avs_version set avs_release = $avs_release, avs_last_incremental = 0, avs_start_incremental = 0 where avs_release = '6.2';
update npvrbe.avs_version set avs_release = $avs_release, avs_last_incremental = 1, avs_start_incremental = 0 where avs_release = '6.2';
update npvrmediator.avs_version set avs_release = $avs_release, avs_last_incremental = 0, avs_start_incremental = 0 where avs_release = '6.2';
update oneux.avs_version set avs_release = $avs_release, avs_last_incremental = 1, avs_start_incremental = 0 where avs_release = '6.2';
update pgw.avs_version set avs_release = $avs_release, avs_last_incremental = 0, avs_start_incremental = 0 where avs_release = '6.2';
update report.avs_version set avs_release = $avs_release, avs_last_incremental = 0, avs_start_incremental = 0 where avs_release = '6.2';
update rpgw.avs_version set avs_release = $avs_release, avs_last_incremental = 0, avs_start_incremental = 0 where avs_release = '6.2';
update technical_catalogue.avs_version set avs_release = $avs_release, avs_last_incremental = 2, avs_start_incremental = 0 where avs_release = '6.2';

EOF

echo "$CURRENT_DATETIME - update_avs_version.sh Successfully completed" | tee -a "$DIR/update_avs_version.log"