#!/bin/bash

CURRENT_DATETIME=`date +%d%m%y%H%M`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "$CURRENT_DATETIME - DropGrants.sh" | tee "$DIR/DropGrants.log"

source $DIR/avs_be/init.cfg

if [ $# -eq 1 ] 
then 
    db_host_ip=$1
else
	echo "HOST DEFAULT"
    db_host_ip=127.0.0.1
fi

mysql -uroot -p$rootpsw -h$db_host_ip --port=$port_number  <<EOF

DROP DATABASE IF EXISTS authentication;
DROP DATABASE IF EXISTS avs_be;
DROP DATABASE IF EXISTS cre_data_normalization;
DROP DATABASE IF EXISTS csmdb_conf;
DROP DATABASE IF EXISTS csmdb_tenant_1;
DROP DATABASE IF EXISTS live_spring_service;
DROP DATABASE IF EXISTS metering_tenant_1;
DROP DATABASE IF EXISTS rpgw;
DROP DATABASE IF EXISTS search_engine;
DROP DATABASE IF EXISTS technical_catalogue;
DROP DATABASE IF EXISTS vod_spring_service;
DROP DATABASE IF EXISTS report;
DROP DATABASE IF EXISTS commerce;
DROP DATABASE IF EXISTS pgw;
DROP DATABASE IF EXISTS npvrbe;
DROP DATABASE IF EXISTS ONEUX;
DROP DATABASE IF EXISTS npvrmediator;
DROP DATABASE IF EXISTS software_upgrade;
DROP DATABASE IF EXISTS stbmanager;
DROP DATABASE IF EXISTS resource_manager;

GRANT USAGE ON *.* TO VodSpring@127.0.0.1;
DROP USER VodSpring@127.0.0.1;

GRANT USAGE ON *.* TO VodSpring@localhost;
DROP USER VodSpring@localhost;

GRANT USAGE ON *.* TO LiveSpring@127.0.0.1;
DROP USER LiveSpring@127.0.0.1;

GRANT USAGE ON *.* TO LiveSpring@localhost;
DROP USER LiveSpring@localhost;

GRANT USAGE ON *.* TO RPGW@127.0.0.1; 
DROP USER RPGW@127.0.0.1;

GRANT USAGE ON *.* TO RPGW@localhost; 
DROP USER RPGW@localhost;

GRANT USAGE ON *.* TO AVS_BE@localhost;
DROP USER AVS_BE@localhost;

GRANT USAGE ON *.* TO AVS_BE@127.0.0.1;
DROP USER AVS_BE@127.0.0.1;

GRANT USAGE ON *.* TO npvr@localhost;
DROP USER npvr@localhost;

GRANT USAGE ON *.* TO npvr@127.0.0.1;
DROP USER npvr@127.0.0.1;

GRANT USAGE ON *.* TO pinboard@localhost;
DROP USER pinboard@localhost;

GRANT USAGE ON *.* TO pinboard@127.0.0.1;
DROP USER pinboard@127.0.0.1;


GRANT USAGE ON *.* TO software_upgrade@localhost;
DROP USER software_upgrade@localhost;

GRANT USAGE ON *.* TO software_upgrade@127.0.0.1;
DROP USER software_upgrade@127.0.0.1;


GRANT USAGE ON *.* TO stbmanager@localhost;
DROP USER stbmanager@localhost;

GRANT USAGE ON *.* TO stbmanager@127.0.0.1;
DROP USER stbmanager@127.0.0.1;

GRANT USAGE ON *.* TO resource_manager@localhost;
DROP USER resource_manager@localhost;

GRANT USAGE ON *.* TO resource_manager@127.0.0.1;
DROP USER resource_manager@127.0.0.1;

EOF