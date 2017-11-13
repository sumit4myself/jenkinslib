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
#incremental


if [ $cre_data_normalization == "Y" ]; then
	source $DIR/cre_data_normalization/init.cfg
	cd $DIR/cre_data_normalization/Full/Procedures
	./system_utility_procedures.sh $db_name $rootpsw $port_number $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully cre_data_normalization/Full/Procedures/system_utility_procedures" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully cre_data_normalization/Full/Procedures/system_utility_procedures" | tee -a "$DIR/install.log"
		exit 1
	fi
	
	cd $DIR/cre_data_normalization
	./avs_incremental.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully cre_data_normalization/avs_incremental" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully cre_data_normalization/avs_incremental" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip cre_data_normalization schema" | tee -a "$DIR/install.log"
fi


if [ $authentication == "Y" ]; then	
	source $DIR/authentication/init.cfg
	cd $DIR/authentication/Full/Procedures
	./system_utility_procedures.sh $db_avs $rootpsw $port_number $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully authentication/Full/Procedures/system_utility_procedures" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully authentication/Full/Procedures/system_utility_procedures" | tee -a "$DIR/install.log"
		exit 1
	fi
	
	cd $DIR/authentication
	./avs_incremental.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully authentication/avs_incremental" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully authentication/avs_incremental" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip authentication schema" | tee -a "$DIR/install.log"
fi


if [ $csm == "Y" ]; then	
	cd $DIR/csm/Full/Procedures
	source $DIR/csm/init.cfg
	./system_utility_procedures.sh $CSMDB_TENANT $PWD_ROOT $port_number $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully csm/Full/Procedures/system_utility_procedures" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully csm/Full/Procedures/system_utility_procedures" | tee -a "$DIR/install.log"
		exit 1
	fi


	cd $DIR/csm
	./csm_tenant_incremental.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully csm/csm_tenant_incremental" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully csm/csm_tenant_incremental" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip csm schema" | tee -a "$DIR/install.log"
fi

if [ $technical_catalogue == "Y" ]; then
	source $DIR/technical_catalogue/init.cfg
	cd $DIR/technical_catalogue/Full/Procedures
	./system_utility_procedures.sh $db_avs $rootpsw $port_number $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully technical_catalogue/Full/Procedures/system_utility_procedures" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully technical_catalogue/Full/Procedures/system_utility_procedures" | tee -a "$DIR/install.log"
		exit 1
	fi

	cd $DIR/technical_catalogue
	./avs_technical_catalogue_incremental.sh $db_host_ip 
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully technical_catalogue/avs_technical_catalogue_incremental" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully technical_catalogue/avs_technical_catalogue_incremental" | tee -a "$DIR/install.log"
		exit 1
	fi
	
	source $DIR/technical_catalogue/init.cfg
	cd $DIR/technical_catalogue/Full/Procedures
	./business_procedures.sh $db_avs $rootpsw $port_number $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully technical_catalogue/Full/Procedures/business_procedures" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully technical_catalogue/Full/Procedures/business_procedures" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip technical_catalogue schema" | tee -a "$DIR/install.log"
fi

if [ $avs_be == "Y" ]; then
	source $DIR/avs_be/init.cfg
	cd $DIR/avs_be/Full/Procedures
	./system_utility_procedures.sh $db_avs $rootpsw $port_number $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully avs_be/Full/Procedures/system_utility_procedures" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully avs_be/Full/Procedures/system_utility_procedures" | tee -a "$DIR/install.log"
		exit 1
	fi

	cd $DIR/avs_be
	./avs_incremental.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully avs_be/avs_incremental" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully avs_be/avs_incremental" | tee -a "$DIR/install.log"
		exit 1
	fi

	cd $DIR/avs_be/Full/Procedures
	./business_procedures.sh $db_avs $rootpsw $port_number $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully avs_be/Full/Procedures/business_procedures" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully avs_be/Full/Procedures/business_procedures" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip avs_be schema" | tee -a "$DIR/install.log"
fi

if [ $rpgw == "Y" ]; then
	source $DIR/rpgw/init.cfg
	cd $DIR/rpgw/Full/Procedures
	./system_utility_procedures.sh $RPGW_DB $PWD_ROOT $port_number $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully rpgw/Full/Procedures/system_utility_procedures" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully rpgw/Full/Procedures/system_utility_procedures" | tee -a "$DIR/install.log"
		exit 1
	fi

	cd $DIR/rpgw
	./avs_incremental.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully rpgw/avs_incremental" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully rpgw/avs_incremental" | tee -a "$DIR/install.log"
		exit 1
	fi

	source $DIR/rpgw/init.cfg
	cd $DIR/rpgw/Full/Procedures
	./business_procedures.sh $RPGW_DB $PWD_ROOT $port_number $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully rpgw/Full/Procedures/business_procedures" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully rpgw/Full/Procedures/business_procedures" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip rpgw schema" | tee -a "$DIR/install.log"
fi

if [ $reporting == "Y" ]; then
	cd $DIR/reporting
	source $DIR/reporting/init.cfg
	./avs_report_incremental.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully reporting/avs_report_incremental.sh" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully reporting/avs_report_incremental.sh" | tee -a "$DIR/install.log"
		exit 1
	fi

	source $DIR/reporting/init.cfg
	cd $DIR/reporting/Full/Procedures
	./business_procedures.sh $db_avs $rootpsw $port_number $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully reporting/Full/Procedures/business_procedures" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully reporting/Full/Procedures/business_procedures" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip reporting schema" | tee -a "$DIR/install.log"
fi

if [ $search_engine == "Y" ]; then
	source $DIR/search_engine/init.cfg
	cd $DIR/search_engine/Full/Procedures
	./system_utility_procedures.sh $search_engine_db $rootpsw $port_number $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully search_engine/Full/Procedures/system_utility_procedures" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully search_engine/Full/Procedures/system_utility_procedures" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip search_engine schema" | tee -a "$DIR/install.log"
fi

if [ $commerce == "Y" ]; then
	source $DIR/commerce/init.cfg
	cd $DIR/commerce/Full/Procedures
	./system_utility_procedures.sh $db_avs $rootpsw $port_number $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully commerce/Full/Procedures/system_utility_procedures" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully commerce/Full/Procedures/system_utility_procedures" | tee -a "$DIR/install.log"
		exit 1
	fi

	cd $DIR/commerce
	./AVS_commerce_incremental.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully commerce/AVS_commerce_incremental" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully commerce/AVS_commerce_incremental" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip commerce schema" | tee -a "$DIR/install.log"
fi

if [ $pgw == "Y" ]; then
	source $DIR/pgw/init.cfg
	cd $DIR/pgw/Full/Procedures
	./system_utility_procedures.sh $db_avs $rootpsw $port_number $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully pgw/Full/Procedures/system_utility_procedures" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully pgw/Full/Procedures/system_utility_procedures" | tee -a "$DIR/install.log"
		exit 1
	fi

	cd $DIR/pgw
	./avs_incremental.sh $db_host_ip 
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully pgw/avs_incremental" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully pgw/avs_incremental" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip pgw schema" | tee -a "$DIR/install.log"
fi

if [ $npvrbe == "Y" ]; then
	source $DIR/npvrbe/init.cfg
	cd $DIR/npvrbe/Full/Procedures
	./system_utility_procedures.sh $db_avs $rootpsw $port_number $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully npvrbe/Full/Procedures/system_utility_procedures" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully npvrbe/Full/Procedures/system_utility_procedures" | tee -a "$DIR/install.log"
		exit 1
	fi
	
	cd $DIR/npvrbe
	./npvrbe_incremental.sh $db_host_ip 
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully npvrbe/npvrbe_incremental" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully npvrbe/npvrbe_incremental" | tee -a "$DIR/install.log"
		exit 1
	fi
	
	cd $DIR/npvrbe/Full/Functions
	./business_functions.sh $db_avs $rootpsw $port_number $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully npvrbe/Full/Functions/business_functions" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully npvrbe/Full/Functions/business_functions" | tee -a "$DIR/install.log"
		exit 1
	fi
	
	cd $DIR/npvrbe/Full/Procedures
	./business_procedures.sh $db_avs $rootpsw $port_number $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully npvrbe/Full/Procedures/business_procedures" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully npvrbe/Full/Procedures/business_procedures" | tee -a "$DIR/install.log"
		exit 1
	fi

else
	echo "$CURRENT_DATETIME - Skip npvrbe schema" | tee -a "$DIR/install.log"
fi

if [ $npvrmediator == "Y" ]; then
	source $DIR/npvrmediator/init.cfg
	
	cd $DIR/npvrmediator/Full/Procedures
	./system_utility_procedures.sh $db_avs $rootpsw $port_number $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully npvrmediator/Full/Procedures/system_utility_procedures" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully npvrmediator/Full/Procedures/system_utility_procedures" | tee -a "$DIR/install.log"
		exit 1
	fi
	
	cd $DIR/npvrmediator
	./npvrmediator_incremental.sh $db_host_ip 
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully npvrmediator/npvrmediator_incremental" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully npvrmediator/npvrmediator_incremental" | tee -a "$DIR/install.log"
		exit 1
	fi
	
	cd $DIR/npvrmediator/Full/Procedures
	./business_procedures.sh $db_avs $rootpsw $port_number $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully npvrmediator/Full/Procedures/business_procedures" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully npvrmediator/Full/Procedures/business_procedures" | tee -a "$DIR/install.log"
		exit 1
	fi

	
else
	echo "$CURRENT_DATETIME - Skip npvrmediator schema" | tee -a "$DIR/install.log"
fi

if [ $pinboard == "Y" ]; then
	source $DIR/pinboard/init.cfg
	cd $DIR/pinboard/Full/Procedures
	./system_utility_procedures.sh $db_avs $rootpsw $port_number $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully pinboard/Full/Procedures/system_utility_procedures" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully pinboard/Full/Procedures/system_utility_procedures" | tee -a "$DIR/install.log"
		exit 1
	fi
 	
	cd $DIR/pinboard
	./oneux_incremental.sh $db_host_ip 
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully pinboard/oneux_incremental" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully pinboard/oneux_incremental" | tee -a "$DIR/install.log"
		exit 1
	fi
	
	cd $DIR/pinboard/Full/Procedures
	./business_procedures.sh $db_avs $rootpsw $port_number $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully pinboard/Full/Procedures/business_procedures" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully pinboard/Full/Procedures/business_procedures" | tee -a "$DIR/install.log"
		exit 1
	fi

else
	echo "$CURRENT_DATETIME - Skip pinboard schema" | tee -a "$DIR/install.log"
fi

if [ $software_upgrade == "Y" ]; then
	source $DIR/software_upgrade/init.cfg
	cd $DIR/software_upgrade/Full/Procedures
	./system_utility_procedures.sh $db_avs $rootpsw $port_number $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully software_upgrade/Full/Procedures/system_utility_procedures" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully software_upgrade/Full/Procedures/system_utility_procedures" | tee -a "$DIR/install.log"
		exit 1
	fi
 	
	cd $DIR/software_upgrade
	./software_upgrade_incremental.sh $db_host_ip 
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully software_upgrade/software_upgrade_incremental" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully software_upgrade/software_upgrade_incremental" | tee -a "$DIR/install.log"
		exit 1
	fi
	
	cd $DIR/software_upgrade/Full/Functions
	./business_functions.sh $db_avs $rootpsw $port_number $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully software_upgrade/Full/Functions/business_functions" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully software_upgrade/Full/Functions/business_functions" | tee -a "$DIR/install.log"
		exit 1
	fi
	
	cd $DIR/software_upgrade/Full/Procedures
	./business_procedures.sh $db_avs $rootpsw $port_number $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully software_upgrade/Full/Procedures/business_procedures" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully software_upgrade/Full/Procedures/business_procedures" | tee -a "$DIR/install.log"
		exit 1
	fi

else
	echo "$CURRENT_DATETIME - Skip software_upgrade schema" | tee -a "$DIR/install.log"
fi

if [ $stbmanager == "Y" ]; then
	source $DIR/stb_management/init.cfg
	cd $DIR/stb_management/Full/Procedures
	./system_utility_procedures.sh $db_avs $rootpsw $port_number $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully stb_management/Full/Procedures/system_utility_procedures" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully stb_management/Full/Procedures/system_utility_procedures" | tee -a "$DIR/install.log"
		exit 1
	fi
 	
	cd $DIR/stb_management
	./stb_management_incremental.sh $db_host_ip 
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully stb_management/stb_management_incremental" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully stb_management/stb_management_incremental" | tee -a "$DIR/install.log"
		exit 1
	fi
	
	cd $DIR/stb_management/Full/Functions
	./business_functions.sh $db_avs $rootpsw $port_number $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully stb_management/Full/Functions/business_functions" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully stb_management/Full/Functions/business_functions" | tee -a "$DIR/install.log"
		exit 1
	fi
	
	cd $DIR/stb_management/Full/Procedures
	./business_procedures.sh $db_avs $rootpsw $port_number $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully stb_management/Full/Procedures/business_procedures" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully stb_management/Full/Procedures/business_procedures" | tee -a "$DIR/install.log"
		exit 1
	fi

else
	echo "$CURRENT_DATETIME - Skip stb_management schema" | tee -a "$DIR/install.log"
fi

if [ $resource_manager == "Y" ]; then
	source $DIR/resource_manager/init.cfg
	cd $DIR/resource_manager/Full/Procedures
	./system_utility_procedures.sh $db_avs $rootpsw $port_number $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully resource_manager/Full/Procedures/system_utility_procedures" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully resource_manager/Full/Procedures/system_utility_procedures" | tee -a "$DIR/install.log"
		exit 1
	fi
 	
	cd $DIR/resource_manager
	./resource_manager_incremental.sh $db_host_ip 
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully resource_manager/resource_manager_incremental" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully resource_manager/resource_manager_incremental" | tee -a "$DIR/install.log"
		exit 1
	fi
	
	cd $DIR/resource_manager/Full/Functions
	./business_functions.sh $db_avs $rootpsw $port_number $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully resource_manager/Full/Functions/business_functions" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully resource_manager/Full/Functions/business_functions" | tee -a "$DIR/install.log"
		exit 1
	fi
	
	cd $DIR/resource_manager/Full/Procedures
	./business_procedures.sh $db_avs $rootpsw $port_number $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully resource_manager/Full/Procedures/business_procedures" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully resource_manager/Full/Procedures/business_procedures" | tee -a "$DIR/install.log"
		exit 1
	fi

else
	echo "$CURRENT_DATETIME - Skip resource_manager schema" | tee -a "$DIR/install.log"
fi

######### VIEWS ########

if [ $csm == "Y" ]; then
	cd $DIR/csm
	source $DIR/csm/init.cfg
	./drop_all_views.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully csm/drop_all_views" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully csm/drop_all_views" | tee -a "$DIR/install.log"
		exit 1
	fi

	cd $DIR/csm
	./csm_tenant_create_views_1.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully csm/metering_db" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully csm/metering_db" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip csm view" | tee -a "$DIR/install.log"

fi

if [ $rpgw == "Y" ]; then
	source $DIR/rpgw/init.cfg
	cd $DIR/rpgw
	./drop_all_views.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully rpgw/drop_all_views" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully rpgw/drop_all_views" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip rpgw view" | tee -a "$DIR/install.log"
fi

if [ $technical_catalogue == "Y" ]; then
	cd $DIR/technical_catalogue
	./drop_all_views.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully technical_catalogue/drop_all_views" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully technical_catalogue/drop_all_views" | tee -a "$DIR/install.log"
		exit 1
	fi

	cd $DIR/technical_catalogue
	./avs_technical_catalogue_views.sh $db_host_ip 
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully technical_catalogue/avs_technical_catalogue_views" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully technical_catalogue/avs_technical_catalogue_views" | tee -a "$DIR/install.log"
		exit 1
	fi

	cd $DIR/technical_catalogue
	./avs_technical_catalogue_sdp_views.sh $db_host_ip 
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully technical_catalogue/avs_technical_catalogue_sdp_views" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully technical_catalogue/avs_technical_catalogue_sdp_views" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip technical_catalogue view" | tee -a "$DIR/install.log"
fi

if [ $avs_be == "Y" ]; then
	source $DIR/avs_be/init.cfg
	cd $DIR/avs_be
	./drop_all_views.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully avs_be/drop_all_views" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully avs_be/drop_all_views" | tee -a "$DIR/install.log"
		exit 1
	fi

	cd $DIR/avs_be
	./integration_avs_sdp.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully avs_be/integration_avs_sdp" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully avs_be/integration_avs_sdp" | tee -a "$DIR/install.log"
		exit 1
	fi


	cd $DIR/avs_be
	./integration_avs_rpgw.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully avs_be/integration_avs_rpgw" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully avs_be/integration_avs_rpgw" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip avs_be view" | tee -a "$DIR/install.log"
fi

if [ $cre_data_normalization == "Y" ]; then
	cd $DIR/cre_data_normalization
	./AVS_technical_catalogue_Views.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully cre_data_normalization/AVS_technical_catalogue_Views" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully cre_data_normalization/AVS_technical_catalogue_Views" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip cre_data_normalization view" | tee -a "$DIR/install.log"
fi

if [ $search_engine == "Y" ]; then
	cd $DIR/search_engine
	source $DIR/search_engine/init.cfg
	./drop_all_views.sh $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully search_engine/drop_all_views" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully search_engine/drop_all_views" | tee -a "$DIR/install.log"
		exit 1
	fi

	cd $DIR/search_engine
	source $DIR/search_engine/init.cfg
	./Full/Views/all_view.sh $search_engine_db $rootpsw $technical_catalogue_db $avs_be_db $db_host_ip
	if [ $? -eq 0 ]; then
			echo "$CURRENT_DATETIME - Successfully search_engine/Full/Views/all_view.sh" | tee -a "$DIR/install.log"
	else
			echo "$CURRENT_DATETIME - Not successfully search_engine/Full/Views/all_view.sh" | tee -a "$DIR/install.log"
			exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip search_engine view" | tee -a "$DIR/install.log"
fi

if [ $rpgw == "Y" ]; then
	cd $DIR/rpgw
	source $DIR/rpgw/init.cfg
	./Full/Views/all_view.sh $db_host_ip
	if [ $? -eq 0 ]; then
			echo "$CURRENT_DATETIME - Successfully rpgw/Full/Views/all_view.sh" | tee -a "$DIR/install.log"
	else
			echo "$CURRENT_DATETIME - Not successfully rpgw/Full/Views/all_view.sh" | tee -a "$DIR/install.log"
			exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip rpgw view" | tee -a "$DIR/install.log"
fi

if [ $stbmanager == "Y" ]; then
	cd $DIR/stb_management
	source $DIR/stb_management/init.cfg
	./Full/Views/create_views.sh $db_avs $rootpsw $port_number $db_host_ip
	if [ $? -eq 0 ]; then
			echo "$CURRENT_DATETIME - Successfully stb_management/Full/Views/create_views.sh" | tee -a "$DIR/install.log"
	else
			echo "$CURRENT_DATETIME - Not successfully stb_management/Full/Views/create_views.sh" | tee -a "$DIR/install.log"
			exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip stb_management view" | tee -a "$DIR/install.log"
fi

if [ $resource_manager == "Y" ]; then
	cd $DIR/resource_manager
	source $DIR/resource_manager/init.cfg
	./Full/Views/create_views.sh $db_avs $rootpsw $port_number $db_host_ip
	if [ $? -eq 0 ]; then
			echo "$CURRENT_DATETIME - Successfully resource_manager/Full/Views/create_views.sh" | tee -a "$DIR/install.log"
	else
			echo "$CURRENT_DATETIME - Not successfully resource_manager/Full/Views/create_views.sh" | tee -a "$DIR/install.log"
			exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip resource_manager view" | tee -a "$DIR/install.log"
fi

########### TRIGGER #########
if [ $authentication == "Y" ]; then
	source $DIR/authentication/init.cfg
	cd $DIR/authentication/Full/Triggers
	./create_trigger_AVS_BE.sh $db_avs $rootpsw $db_host_ip $port_number
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully authentication/Full/Triggers/create_trigger_AVS_BE" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully authentication/Full/Triggers/create_trigger_AVS_BE" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip authentication trigger" | tee -a "$DIR/install.log"
fi

if [ $technical_catalogue == "Y" ]; then
	source $DIR/technical_catalogue/init.cfg
	cd $DIR/technical_catalogue/Full/Triggers
	./create_triggers.sh $db_avs $rootpsw $port_number $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully technical_catalogue/Full/Triggers/create_triggers" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully technical_catalogue/Full/Triggers/create_triggers" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip technical_catalogue trigger" | tee -a "$DIR/install.log"
fi

if [ $avs_be == "Y" ]; then	
	source $DIR/avs_be/init.cfg
	cd $DIR/avs_be/Full/Triggers
	./create_trigger_AVS_BE.sh $db_avs $rootpsw $port_number $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully avs_be/Full/Triggers/create_trigger_AVS_BE" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully avs_be/Full/Triggers/create_trigger_AVS_BE" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip avs_be trigger" | tee -a "$DIR/install.log"
fi

if [ $npvrbe == "Y" ]; then	
	source $DIR/npvrbe/init.cfg
	cd $DIR/npvrbe/Full/Triggers
	./create_triggers.sh $db_avs $rootpsw $port_number $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully npvrbe/Full/Triggers/create_triggers.sh" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully npvrbe/Full/Triggers/create_triggers.sh" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip npvrbe trigger" | tee -a "$DIR/install.log"
fi

if [ $npvrmediator == "Y" ]; then	
	source $DIR/npvrmediator/init.cfg
	cd $DIR/npvrmediator/Full/Triggers
	./create_triggers.sh $db_avs $rootpsw $port_number $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully npvrmediator/Full/Triggers/create_triggers.sh" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully npvrmediator/Full/Triggers/create_triggers.sh" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip npvrmediator trigger" | tee -a "$DIR/install.log"
fi

if [ $pinboard == "Y" ]; then	
	source $DIR/pinboard/init.cfg
	cd $DIR/pinboard/Full/Triggers
	./create_triggers.sh $db_avs $rootpsw $port_number $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully pinboard/Full/Triggers/create_triggers.sh" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully pinboard/Full/Triggers/create_triggers.sh" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip pinboard trigger" | tee -a "$DIR/install.log"
fi

if [ $software_upgrade == "Y" ]; then	
	source $DIR/software_upgrade/init.cfg
	cd $DIR/software_upgrade/Full/Triggers
	./create_triggers.sh $db_avs $rootpsw $port_number $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully software_upgrade/Full/Triggers/create_triggers.sh" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully software_upgrade/Full/Triggers/create_triggers.sh" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip software_upgrade trigger" | tee -a "$DIR/install.log"
fi

if [ $stbmanager == "Y" ]; then	
	source $DIR/stb_management/init.cfg
	cd $DIR/stb_management/Full/Triggers
	./create_triggers.sh $db_avs $rootpsw $port_number $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully stb_management/Full/Triggers/create_triggers.sh" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully stb_management/Full/Triggers/create_triggers.sh" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip stb_management trigger" | tee -a "$DIR/install.log"
fi

if [ $resource_manager == "Y" ]; then	
	source $DIR/resource_manager/init.cfg
	cd $DIR/resource_manager/Full/Triggers
	./create_triggers.sh $db_avs $rootpsw $port_number $db_host_ip
	if [ $? -eq 0 ]; then
		echo "$CURRENT_DATETIME - Successfully resource_manager/Full/Triggers/create_triggers.sh" | tee -a "$DIR/install.log"
	else
		echo "$CURRENT_DATETIME - Not successfully resource_manager/Full/Triggers/create_triggers.sh" | tee -a "$DIR/install.log"
		exit 1
	fi
else
	echo "$CURRENT_DATETIME - Skip resource_manager trigger" | tee -a "$DIR/install.log"
fi

cd $DIR
./SetGrants.sh $db_host_ip $db_host_netmask
  if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully SetGrants.sh" | tee -a "$DIR/install.log"
else
	echo "$CURRENT_DATETIME - Not successfully SetGrants.sh" | tee -a "$DIR/install.log"
	exit 1
fi

##### AVS-22233, AVS-22185 - NPVR Publisher points management on Ansible scripts. HTTP external endpoint management on Ansible scripts	 #####
cd $DIR
./ReplaceWithAnsiblePlaceholder.sh $db_host_ip $db_host_netmask
if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully ReplaceWithAnsiblePlaceholder.sh" | tee -a "$DIR/ReplaceWithAnsiblePlaceholder.log"
else
	echo "$CURRENT_DATETIME - Not successfully ReplaceWithAnsiblePlaceholder.sh" | tee -a "$DIR/ReplaceWithAnsiblePlaceholder.log"
	exit 1
fi

echo "$CURRENT_DATETIME - install_incremental.sh Successfully completed" | tee -a "$DIR/install.log"
