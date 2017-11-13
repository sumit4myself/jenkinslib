#!/bin/bash

CURRENT_DATETIME=`date +%d%m%y%H%M`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "$CURRENT_DATETIME - Starting database installation" | tee "$DIR/install.log"

# AVS-15889 - Skip install/upgrade schema if the flag is N
source $DIR/init.cfg

source $DIR/avs_be/init.cfg

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

echo "db_host_ip = $db_host_ip"
echo "db_host_netmask = $db_host_netmask"

if [ $avs_be == "Y" ]; then
	cd $DIR/avs_be
	./AVS_fullDB.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully avs_be/AVS_fullDB" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully avs_be/AVS_fullDB" | tee -a "$DIR/install.log"
		exit 1
	fi

	cd $DIR/avs_be
	./AVS_configuration.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully avs_be/AVS_configuration" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully avs_be/AVS_configuration" | tee -a "$DIR/install.log"
		exit 1
	fi

	cd $DIR/avs_be
	./avs_refresh_sys_parameters.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully avs_be/avs_refresh_sys_parameters" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully avs_be/avs_refresh_sys_parameters" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip avs_be schema" | tee -a "$DIR/install.log"
fi
	
if [ $technical_catalogue == "Y" ]; then	
	cd $DIR/technical_catalogue
	./AVS_technical_catalogue_fullDB.sh $db_host_ip 
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully technical_catalogue/AVS_technical_catalogue_fullDB" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully technical_catalogue/AVS_technical_catalogue_fullDB" | tee -a "$DIR/install.log"
		exit 1
	fi

	cd $DIR/technical_catalogue
	./AVS_technical_catalogue_configuration.sh $db_host_ip 
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully technical_catalogue/AVS_technical_catalogue_configuration" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully technical_catalogue/AVS_technical_catalogue_configuration" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip technical_catalogue schema" | tee -a "$DIR/install.log"
fi

if [ $authentication == "Y" ]; then
	cd $DIR/authentication
	./AVS_fullDB.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully authentication/AVS_fullDB" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully authentication/AVS_fullDB" | tee -a "$DIR/install.log"
		exit 1
	fi

	cd $DIR/authentication
	./AVS_configuration.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully authentication/AVS_configuration" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully authentication/AVS_configuration" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip authentication schema" | tee -a "$DIR/install.log"
fi

if [ $csm == "Y" ]; then
	cd $DIR/csm
	./csm_fulldb.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully csm/csm_fulldb" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully csm/csm_fulldb" | tee -a "$DIR/install.log"
		exit 1
	fi

	cd $DIR/csm
	./csm_configuration.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully csm/csm_configuration" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully csm/csm_configuration" | tee -a "$DIR/install.log"
		exit 1
	fi

	cd $DIR/csm
	./metering_db.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully csm/metering_db" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully csm/metering_db" | tee -a "$DIR/install.log"
		exit 1
	fi

	cd $DIR/csm
	./customer_tenant.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully csm/customer_tenant" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully csm/customer_tenant" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip csm schema" | tee -a "$DIR/install.log"
fi

if [ $vod_spring_service == "Y" ]; then
	cd $DIR/vod_spring_service/Full
	./vod_spring_fullDB.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully vod_spring_service/Full/vod_spring_fullDB" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully vod_spring_service/Full/vod_spring_fullDB" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip vod_spring_service schema" | tee -a "$DIR/install.log"
fi

if [ $live_spring_service == "Y" ]; then
	cd $DIR/live_spring_service/Full
	./live_spring_fullDB.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully live_spring_service/Full/live_spring_fullDB" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully live_spring_service/Full/live_spring_fullDB" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip live_spring_service schema" | tee -a "$DIR/install.log"
fi

if [ $cre_data_normalization == "Y" ]; then
	cd $DIR/cre_data_normalization
	./AVS_CRE_fullDB.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully cre_data_normalization/AVS_CRE_fullDB" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully cre_data_normalization/AVS_CRE_fullDB" | tee -a "$DIR/install.log"
		exit 1
	fi

	cd $DIR/cre_data_normalization
	./avs_version_configuration.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully cre_data_normalization/avs_version_configuration" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully cre_data_normalization/avs_version_configuration" | tee -a "$DIR/install.log"
		exit 1
	fi

	cd $DIR/cre_data_normalization
	./device_configuration.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully cre_data_normalization/device_configuration" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully cre_data_normalization/device_configuration" | tee -a "$DIR/install.log"
		exit 1
	fi

	cd $DIR/cre_data_normalization
	./system_configuration.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully cre_data_normalization/system_configuration" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully cre_data_normalization/system_configuration" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip cre_data_normalization schema" | tee -a "$DIR/install.log"
fi

if [ $rpgw == "Y" ]; then
	cd $DIR/rpgw
	./run_create_database_and_user.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully rpgw/run_create_database_and_user" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully rpgw/run_create_database_and_user" | tee -a "$DIR/install.log"
		exit 1
	fi

	cd $DIR/rpgw
	./run_create_full_schema.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully rpgw/run_create_full_schema" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully rpgw/run_create_full_schema" | tee -a "$DIR/install.log"
		exit 1
	fi

	cd $DIR/rpgw
	./run_data_fill.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully rpgw/run_data_fill" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully rpgw/run_data_fill" | tee -a "$DIR/install.log"
		exit 1
	fi

	cd $DIR/rpgw
	./run_create_procedure.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully rpgw/run_create_procedure" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully rpgw/run_create_procedure" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip rpgw schema" | tee -a "$DIR/install.log"
fi

if [ $avs_be == "Y" ]; then
	cd $DIR/avs_be
	./AVS_configuration_compatibility_matrix.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully avs_be/AVS_configuration_compatibility_matrix" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully avs_be/AVS_configuration_compatibility_matrix" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip avs_be/AVS_configuration_compatibility_matrix" | tee -a "$DIR/install.log"
fi

if [ $reporting == "Y" ]; then
	source $DIR/reporting/init.cfg
	cd $DIR/reporting
	./AVS_report_fullDB.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully reporting/AVS_report_fullDB.sh" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully reporting/AVS_report_fullDB.sh" | tee -a "$DIR/install.log"
		exit 1
	fi

	cd $DIR/reporting
	./AVS_report_configuration.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully reporting/AVS_report_configuration.sh" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully reporting/AVS_report_configuration.sh" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip reporting schema" | tee -a "$DIR/install.log"
fi

if [ $search_engine == "Y" ]; then
	cd $DIR/search_engine
	./SEARCH__ENGINE_AVS_fullDB.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully search_engine/SEARCH__ENGINE_AVS_fullDB" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully search_engine/SEARCH__ENGINE_AVS_fullDB" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip search_engine schema" | tee -a "$DIR/install.log"
fi

if [ $commerce == "Y" ]; then
	cd $DIR/commerce
	./AVS_commerce_fullDB.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully commerce/AVS_commerce_fullDB" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully commerce/AVS_commerce_fullDB" | tee -a "$DIR/install.log"
		exit 1
	fi

	cd $DIR/commerce
	./AVS_commerce_configuration.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully commerce/AVS_commerce_configuration" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully commerce/AVS_commerce_configuration" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip commerce schema" | tee -a "$DIR/install.log"
fi

if [ $pgw == "Y" ]; then
	cd $DIR/pgw
	./AVS_fullDB.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully pgw/AVS_fullDB" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully pgw/AVS_fullDB" | tee -a "$DIR/install.log"
		exit 1
	fi
	cd $DIR/pgw
	./AVS_configuration.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully pgw/AVS_configuration" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully pgw/AVS_configuration" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip pgw schema" | tee -a "$DIR/install.log"
fi

if [ $npvrbe == "Y" ]; then
	cd $DIR/npvrbe
	./NPVRBE_fullDB.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully npvrbe/NPVRBE_fullDB" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully npvrbe/NPVRBE_fullDB" | tee -a "$DIR/install.log"
		exit 1
	fi
	cd $DIR/npvrbe
	./NPVRBE_configuration.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully npvrbe/NPVRBE_configuration" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully npvrbe/NPVRBE_configuration" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip npvrbe schema" | tee -a "$DIR/install.log"
fi

if [ $npvrmediator == "Y" ]; then
	cd $DIR/npvrmediator
	./NPVRMediator_fullDB.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully npvrmediator/NPVRMediator_fullDB" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully npvrmediator/NPVRMediator_fullDB" | tee -a "$DIR/install.log"
		exit 1
	fi
	cd $DIR/npvrmediator
	./NPVRMediator_configuration.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully npvrmediator/NPVRMediator_configuration" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully npvrmediator/NPVRMediator_configuration" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip npvrmediator schema" | tee -a "$DIR/install.log"
fi

if [ $pinboard == "Y" ]; then
	cd $DIR/pinboard
	./ONEUX_fullDB.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully pinboard/ONEUX_fullDB" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully pinboard/ONEUX_fullDB" | tee -a "$DIR/install.log"
		exit 1
	fi
	cd $DIR/pinboard
	./ONEUX_configuration.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully pinboard/ONEUX_configuration" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully pinboard/ONEUX_configuration" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip pinboard schema" | tee -a "$DIR/install.log"
fi

if [ $software_upgrade == "Y" ]; then
	cd $DIR/software_upgrade
	./software_upgrade_fullDB.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully software_upgrade/software_upgrade_fullDB.sh" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully software_upgrade/software_upgrade_fullDB.sh" | tee -a "$DIR/install.log"
		exit 1
	fi
	cd $DIR/software_upgrade
	./software_upgrade_configuration.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully software_upgrade/software_upgrade_configuration.sh" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully software_upgrade/software_upgrade_configuration.sh" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip software_upgrade schema" | tee -a "$DIR/install.log"
fi

if [ $stb_management == "Y" ]; then
	cd $DIR/stb_management
	./stb_management_fullDB.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully stb_management/stb_management_fullDB.sh" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully stb_management/stb_management_fullDB.sh" | tee -a "$DIR/install.log"
		exit 1
	fi
	cd $DIR/stb_management
	./stb_management_configuration.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully stb_management/stb_management_configuration.sh" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully stb_management/stb_management_configuration.sh" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip stb_management schema" | tee -a "$DIR/install.log"
fi

if [ $resource_manager == "Y" ]; then
	cd $DIR/resource_manager
	./resource_manager_fullDB.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully resource_manager/resource_manager_fullDB.sh" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully resource_manager/resource_manager_fullDB.sh" | tee -a "$DIR/install.log"
		exit 1
	fi
	cd $DIR/resource_manager
	./resource_manager_configuration.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully resource_manager/resource_manager_configuration.sh" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully resource_manager/resource_manager_configuration.sh" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip resource_manager schema" | tee -a "$DIR/install.log"
fi

cd $DIR
./install_incremental.sh $db_host_ip $db_host_netmask

echo "$CURRENT_DATETIME - install.sh Successfully completed" | tee -a "$DIR/install.log"
