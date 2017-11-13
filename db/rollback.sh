#!/bin/bash

CURRENT_DATETIME=`date +%d%m%y%H%M`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "$CURRENT_DATETIME - Starting database rollback" | tee "$DIR/rollback.log"

source $DIR/avs_be/init.cfg

if [ $# -ne 1 ] 
then 
	echo "HOST DEFAULT"
	db_host_ip=127.0.0.1
else
	db_host_ip=$1
fi 

cd $DIR/authentication
./avs_incremental_rollback.sh $db_host_ip
if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully authentication/avs_incremental_rollback" | tee -a "$DIR/rollback.log"
else
	echo "$CURRENT_DATETIME - Not successfully authentication/avs_incremental_rollback" | tee -a "$DIR/rollback.log"
	exit 1
fi

cd $DIR/avs_be
./avs_incremental_rollback.sh $db_host_ip
if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully avs_be/avs_incremental_rollback" | tee -a "$DIR/rollback.log"
else
	echo "$CURRENT_DATETIME - Not successfully avs_be/avs_incremental_rollback" | tee -a "$DIR/rollback.log"
	exit 1
fi

cd $DIR/cre_data_normalization
./avs_incremental_rollback.sh $db_host_ip
if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully cre_data_normalization/avs_incremental_rollback" | tee -a "$DIR/rollback.log"
else
	echo "$CURRENT_DATETIME - Not successfully cre_data_normalization/avs_incremental_rollback" | tee -a "$DIR/rollback.log"
	exit 1
fi

cd $DIR/csm
./csm_tenant_incremental_rollback.sh $db_host_ip
if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully csm/csm_tenant_incremental_rollback.sh" | tee -a "$DIR/rollback.log"
else
	echo "$CURRENT_DATETIME - Not successfully csm/csm_tenant_incremental_rollback.sh" | tee -a "$DIR/rollback.log"
	exit 1
fi

cd $DIR/reporting
./avs_report_incremental_rollback.sh $db_host_ip
if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully reporting/avs_report_incremental_rollback.sh" | tee -a "$DIR/rollback.log"
else
	echo "$CURRENT_DATETIME - Not successfully reporting/avs_report_incremental_rollback.sh" | tee -a "$DIR/rollback.log"
	exit 1
fi

cd $DIR/rpgw
./avs_incremental_rollback.sh $db_host_ip
if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully rpgw/avs_incremental_rollback.sh" | tee -a "$DIR/rollback.log"
else
	echo "$CURRENT_DATETIME - Not successfully rpgw/avs_incremental_rollback.sh" | tee -a "$DIR/rollback.log"
	exit 1
fi

cd $DIR/technical_catalogue
./avs_technical_catalogue_incremental_rollback.sh $db_host_ip
if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully technical_catalogue/avs_technical_catalogue_incremental_rollback.sh" | tee -a "$DIR/rollback.log"
else
	echo "$CURRENT_DATETIME - Not successfully technical_catalogue/avs_technical_catalogue_incremental_rollback.sh" | tee -a "$DIR/rollback.log"
	exit 1
fi


cd $DIR/commerce
./AVS_commerce_incremental_rollback.sh $db_host_ip
if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully commerce/AVS_commerce_incremental_rollback.sh" | tee -a "$DIR/rollback.log"
else
	echo "$CURRENT_DATETIME - Not successfully commerce/AVS_commerce_incremental_rollback.sh" | tee -a "$DIR/rollback.log"
	exit 1
fi

cd $DIR/pgw
./avs_incremental_rollback.sh $db_host_ip
if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully pgw/avs_incremental_rollback.sh" | tee -a "$DIR/rollback.log"
else
	echo "$CURRENT_DATETIME - Not successfully pgw/avs_incremental_rollback.sh" | tee -a "$DIR/rollback.log"
	exit 1
fi

cd $DIR/npvrbe
./npvrbe_incremental_rollback.sh $db_host_ip
if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully npvrbe/npvrbe_incremental_rollback.sh" | tee -a "$DIR/rollback.log"
else
	echo "$CURRENT_DATETIME - Not successfully npvrbe/npvrbe_incremental_rollback.sh" | tee -a "$DIR/rollback.log"
	exit 1
fi

cd $DIR/npvrmediator
./npvrmediator_incremental_rollback.sh $db_host_ip
if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully npvrmediator/npvrmediator_incremental_rollback.sh" | tee -a "$DIR/rollback.log"
else
	echo "$CURRENT_DATETIME - Not successfully npvrmediator/npvrmediator_incremental_rollback.sh" | tee -a "$DIR/rollback.log"
	exit 1
fi

cd $DIR/pinboard
./oneux_incremental_rollback.sh $db_host_ip
if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully pinboard/oneux_incremental_rollback.sh" | tee -a "$DIR/rollback.log"
else
	echo "$CURRENT_DATETIME - Not successfully pinboard/oneux_incremental_rollback.sh" | tee -a "$DIR/rollback.log"
	exit 1
fi

cd $DIR/software_upgrade
./software_upgrade_incremental_rollback.sh $db_host_ip
if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully software_upgrade/software_upgrade_incremental_rollback.sh" | tee -a "$DIR/rollback.log"
else
	echo "$CURRENT_DATETIME - Not successfully software_upgrade/software_upgrade_incremental_rollback.sh" | tee -a "$DIR/rollback.log"
	exit 1
fi

cd $DIR/stb_management
./stb_management_incremental_rollback.sh $db_host_ip
if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully stb_management/stb_management_incremental_rollback.sh" | tee -a "$DIR/rollback.log"
else
	echo "$CURRENT_DATETIME - Not successfully stb_management/stb_management_incremental_rollback.sh" | tee -a "$DIR/rollback.log"
	exit 1
fi

cd $DIR/resource_manager
./resource_manager_incremental_rollback.sh $db_host_ip
if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully resource_manager/resource_manager_incremental_rollback.sh" | tee -a "$DIR/rollback.log"
else
	echo "$CURRENT_DATETIME - Not successfully resource_manager/resource_manager_incremental_rollback.sh" | tee -a "$DIR/rollback.log"
	exit 1
fi