#!/bin/bash

CURRENT_DATETIME=`date +%d%m%y%H%M`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "$CURRENT_DATETIME - SetGrants.sh" | tee "$DIR/SetGrants.log"

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


cd $DIR

source $DIR/init.cfg

mysql -u$username -h$db_host_ip -p$userpass --port=$port_number <<EOF

GRANT USAGE ON *.* TO "report_user"@"$db_host_netmask";
DROP USER "report_user"@"$db_host_netmask";

GRANT USAGE ON *.* TO "report_user"@"$db_host_ip";
DROP USER "report_user"@"$db_host_ip";

GRANT USAGE ON *.* TO "report_user"@"localhost";
DROP USER "report_user"@"localhost";

GRANT USAGE ON *.* TO "report_user"@"";
DROP USER "report_user"@"";

GRANT USAGE ON *.* TO "npvr"@"$db_host_netmask";
DROP USER "npvr"@"$db_host_netmask";

GRANT USAGE ON *.* TO "npvr"@"localhost";
DROP USER "npvr"@"localhost";

GRANT USAGE ON *.* TO "npvr"@"$db_host_ip";
DROP USER "npvr"@"$db_host_ip";

GRANT USAGE ON *.* TO "npvr"@"";
DROP USER "npvr"@"";

GRANT USAGE ON *.* TO "pinboard"@"$db_host_netmask";
DROP USER "pinboard"@"$db_host_netmask";

GRANT USAGE ON *.* TO "pinboard"@"localhost";
DROP USER "pinboard"@"localhost";

GRANT USAGE ON *.* TO "pinboard"@"$db_host_ip";
DROP USER "pinboard"@"$db_host_ip";

GRANT USAGE ON *.* TO "pinboard"@"";
DROP USER "pinboard"@"";

GRANT USAGE ON *.* TO "VodSpring"@"$db_host_netmask";
DROP USER "VodSpring"@"$db_host_netmask";

GRANT USAGE ON *.* TO "VodSpring"@"localhost";
DROP USER "VodSpring"@"localhost";

GRANT USAGE ON *.* TO "VodSpring"@"$db_host_ip";
DROP USER "VodSpring"@"$db_host_ip";

GRANT USAGE ON *.* TO "VodSpring"@"";
DROP USER "VodSpring"@"";

GRANT USAGE ON *.* TO "SEARCH_ENGINE"@"$db_host_netmask";
DROP USER "SEARCH_ENGINE"@"$db_host_netmask";

GRANT USAGE ON *.* TO "SEARCH_ENGINE"@"localhost";
DROP USER "SEARCH_ENGINE"@"localhost";

GRANT USAGE ON *.* TO "SEARCH_ENGINE"@"$db_host_ip";
DROP USER "SEARCH_ENGINE"@"$db_host_ip";

GRANT USAGE ON *.* TO "SEARCH_ENGINE"@"";
DROP USER "SEARCH_ENGINE"@"";

GRANT USAGE ON *.* TO "SDP_READ"@"$db_host_netmask";
DROP USER "SDP_READ"@"$db_host_netmask";

GRANT USAGE ON *.* TO "SDP_READ"@"localhost";
DROP USER "SDP_READ"@"localhost";

GRANT USAGE ON *.* TO "SDP_READ"@"$db_host_ip";
DROP USER "SDP_READ"@"$db_host_ip";

GRANT USAGE ON *.* TO "SDP_READ"@"";
DROP USER "SDP_READ"@"";

GRANT USAGE ON *.* TO "RPGW"@"$db_host_netmask"; 
DROP USER "RPGW"@"$db_host_netmask";

GRANT USAGE ON *.* TO "RPGW"@"localhost"; 
DROP USER "RPGW"@"localhost";

GRANT USAGE ON *.* TO "RPGW"@"$db_host_ip";
DROP USER "RPGW"@"$db_host_ip";

GRANT USAGE ON *.* TO "RPGW"@"";
DROP USER "RPGW"@"";

GRANT USAGE ON *.* TO "LiveSpring"@"$db_host_netmask";
DROP USER "LiveSpring"@"$db_host_netmask";

GRANT USAGE ON *.* TO "LiveSpring"@"localhost";
DROP USER "LiveSpring"@"localhost";

GRANT USAGE ON *.* TO "LiveSpring"@"$db_host_ip";
DROP USER "LiveSpring"@"$db_host_ip";

GRANT USAGE ON *.* TO "LiveSpring"@"";
DROP USER "LiveSpring"@"";

GRANT USAGE ON *.* TO "CSM_USER"@"$db_host_netmask";
DROP USER "CSM_USER"@"$db_host_netmask";

GRANT USAGE ON *.* TO "CSM_USER"@"localhost";
DROP USER "CSM_USER"@"localhost";

GRANT USAGE ON *.* TO "CSM_USER"@"$db_host_ip";
DROP USER "CSM_USER"@"$db_host_ip";

GRANT USAGE ON *.* TO "CSM_USER"@"";
DROP USER "CSM_USER"@"";

GRANT USAGE ON *.* TO "AVS_CRE"@"$db_host_netmask";
DROP USER "AVS_CRE"@"$db_host_netmask";

GRANT USAGE ON *.* TO "AVS_CRE"@"localhost";
DROP USER "AVS_CRE"@"localhost";

GRANT USAGE ON *.* TO "AVS_CRE"@"$db_host_ip";
DROP USER "AVS_CRE"@"$db_host_ip";

GRANT USAGE ON *.* TO "AVS_CRE"@"";
DROP USER "AVS_CRE"@"";

GRANT USAGE ON *.* TO "AVS_BE"@"localhost";
DROP USER "AVS_BE"@"localhost";

GRANT USAGE ON *.* TO "AVS_BE"@"$db_host_netmask";
DROP USER "AVS_BE"@"$db_host_netmask";

GRANT USAGE ON *.* TO "AVS_BE"@"$db_host_ip";
DROP USER "AVS_BE"@"$db_host_ip";

GRANT USAGE ON *.* TO "AVS_BE"@"";
DROP USER "AVS_BE"@"";

GRANT USAGE ON *.* TO "software_upgrade"@"$db_host_netmask";
DROP USER "software_upgrade"@"$db_host_netmask";

GRANT USAGE ON *.* TO "software_upgrade"@"localhost";
DROP USER "software_upgrade"@"localhost";

GRANT USAGE ON *.* TO "software_upgrade"@"$db_host_ip";
DROP USER "software_upgrade"@"$db_host_ip";

GRANT USAGE ON *.* TO "software_upgrade"@"";
DROP USER "software_upgrade"@"";

GRANT USAGE ON *.* TO "stbmanager"@"$db_host_netmask";
DROP USER "stbmanager"@"$db_host_netmask";

GRANT USAGE ON *.* TO "stbmanager"@"localhost";
DROP USER "stbmanager"@"localhost";

GRANT USAGE ON *.* TO "stbmanager"@"$db_host_ip";
DROP USER "stbmanager"@"$db_host_ip";

GRANT USAGE ON *.* TO "stbmanager"@"";
DROP USER "stbmanager"@"";

GRANT USAGE ON *.* TO "resource_manager"@"$db_host_netmask";
DROP USER "resource_manager"@"$db_host_netmask";

GRANT USAGE ON *.* TO "resource_manager"@"localhost";
DROP USER "resource_manager"@"localhost";

GRANT USAGE ON *.* TO "resource_manager"@"$db_host_ip";
DROP USER "resource_manager"@"$db_host_ip";

GRANT USAGE ON *.* TO "resource_manager"@"";
DROP USER "resource_manager"@"";

GRANT USAGE ON *.* TO 'AVS_BE'@'$db_host_netmask' IDENTIFIED BY PASSWORD '*CDD3B121E466A92419A2B469E8721C825CEE64B2';

GRANT ALL PRIVILEGES ON technical_catalogue.* TO "AVS_BE"@"localhost" IDENTIFIED BY "$db_password" ;
GRANT ALL PRIVILEGES ON authentication.* TO "AVS_BE"@"localhost" IDENTIFIED BY "$db_password" ;

GRANT ALL PRIVILEGES ON authentication.* TO 'AVS_BE'@'$db_host_netmask';
GRANT ALL PRIVILEGES ON technical_catalogue.* TO 'AVS_BE'@'$db_host_netmask';
GRANT ALL PRIVILEGES ON report.* TO 'AVS_BE'@'$db_host_netmask';
GRANT ALL PRIVILEGES ON csmdb_tenant_1.* TO 'AVS_BE'@'$db_host_netmask';

GRANT ALL PRIVILEGES ON avs_be.* TO 'AVS_BE'@'$db_host_netmask';
GRANT ALL PRIVILEGES ON commerce.* TO 'AVS_BE'@'$db_host_netmask';
GRANT ALL PRIVILEGES ON csmdb_conf.* TO 'AVS_BE'@'$db_host_netmask';
GRANT USAGE ON *.* TO 'AVS_CRE'@'$db_host_netmask' IDENTIFIED BY PASSWORD '*CDD3B121E466A92419A2B469E8721C825CEE64B2';
GRANT ALL PRIVILEGES ON cre_data_normalization.* TO 'AVS_CRE'@'$db_host_netmask';
GRANT USAGE ON *.* TO 'CSM_USER'@'$db_host_netmask' IDENTIFIED BY PASSWORD '*81F7C50C48F7950F7288ECE1C29D514A41A3D6A4';
GRANT ALL PRIVILEGES ON metering_tenant_1.* TO 'CSM_USER'@'$db_host_netmask';
GRANT ALL PRIVILEGES ON csmdb_tenant_1.* TO 'CSM_USER'@'$db_host_netmask';
GRANT ALL PRIVILEGES ON csmdb_conf.* TO 'CSM_USER'@'$db_host_netmask';
GRANT ALL PRIVILEGES ON commerce.* TO 'CSM_USER'@'$db_host_netmask';
GRANT USAGE ON *.* TO 'LiveSpring'@'$db_host_netmask' IDENTIFIED BY PASSWORD '*229C5FBFFF37190C31771A986073A7719918E14C';
GRANT ALL PRIVILEGES ON live_spring_service.* TO 'LiveSpring'@'$db_host_netmask';
GRANT USAGE ON *.* TO 'RPGW'@'$db_host_netmask' IDENTIFIED BY PASSWORD '*17491D2CC6CA3F6805A0C22C997B98A0899E08A9';
GRANT ALL PRIVILEGES ON rpgw.* TO 'RPGW'@'$db_host_netmask';
GRANT ALL PRIVILEGES ON avs_be.* TO 'RPGW'@'$db_host_netmask';
GRANT USAGE ON *.* TO 'SDP_READ'@'$db_host_netmask' IDENTIFIED BY PASSWORD '*FDFCF622F4DDE1AAAAC55539F4DD852C19776044';
GRANT SELECT ON csmdb_tenant_1.* TO 'SDP_READ'@'$db_host_netmask';
GRANT USAGE ON *.* TO 'SEARCH_ENGINE'@'$db_host_netmask' IDENTIFIED BY PASSWORD '*EA3CBFC0CDD8C857D7898E49571E18DCE8E17403';
GRANT ALL PRIVILEGES ON search_engine.* TO 'SEARCH_ENGINE'@'$db_host_netmask';
GRANT USAGE ON *.* TO 'VodSpring'@'$db_host_netmask' IDENTIFIED BY PASSWORD '*BC3DB756A0AB5DA10E8210472A417727C2E02754';
GRANT ALL PRIVILEGES ON vod_spring_service.* TO 'VodSpring'@'$db_host_netmask';
GRANT USAGE ON *.* TO 'pinboard'@'$db_host_netmask' IDENTIFIED BY PASSWORD '*2F4692BA4608AD6744F7F474BAC128A5AA2DF0EF';
GRANT ALL PRIVILEGES ON oneux.* TO 'pinboard'@'$db_host_netmask';
GRANT ALL PRIVILEGES ON pgw.* TO 'AVS_BE'@'$db_host_netmask';

GRANT USAGE ON *.* TO 'software_upgrade'@'$db_host_netmask' IDENTIFIED BY PASSWORD '*2F4692BA4608AD6744F7F474BAC128A5AA2DF0EF';
GRANT ALL PRIVILEGES ON software_upgrade.* TO 'software_upgrade'@'$db_host_netmask';

GRANT USAGE ON *.* TO 'stbmanager'@'$db_host_netmask' IDENTIFIED BY PASSWORD '*2F4692BA4608AD6744F7F474BAC128A5AA2DF0EF';
GRANT ALL PRIVILEGES ON stbmanager.* TO 'stbmanager'@'$db_host_netmask';

GRANT USAGE ON *.* TO 'resource_manager'@'$db_host_netmask' IDENTIFIED BY PASSWORD '*2F4692BA4608AD6744F7F474BAC128A5AA2DF0EF';
GRANT ALL PRIVILEGES ON resource_manager.* TO 'resource_manager'@'$db_host_netmask';

GRANT USAGE ON *.* TO 'npvr'@'$db_host_netmask' IDENTIFIED BY PASSWORD '*2F4692BA4608AD6744F7F474BAC128A5AA2DF0EF';
GRANT ALL PRIVILEGES ON npvrbe.* TO 'npvr'@'$db_host_netmask';
GRANT ALL PRIVILEGES ON npvrmediator.* TO 'npvr'@'$db_host_netmask';

GRANT USAGE ON *.* TO 'report_user'@'$db_host_netmask' IDENTIFIED BY PASSWORD '*CDD3B121E466A92419A2B469E8721C825CEE64B2';
GRANT ALL PRIVILEGES ON report.* TO 'report_user'@'$db_host_netmask';
GRANT ALL PRIVILEGES ON avs_be.* TO 'report_user'@'$db_host_netmask';
GRANT ALL PRIVILEGES ON technical_catalogue.* TO 'report_user'@'$db_host_netmask';

GRANT ALL PRIVILEGES ON *.* TO 'root'@'127.0.0.1' IDENTIFIED BY PASSWORD '*4A82FDF1D80BA7470BA2E17FEEFD5A53D5D3B762' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY PASSWORD '*4A82FDF1D80BA7470BA2E17FEEFD5A53D5D3B762' WITH GRANT OPTION;

GRANT SELECT ON mysql.proc TO 'AVS_BE'@'$db_host_netmask';
GRANT SELECT ON mysql.proc TO 'npvr'@'$db_host_netmask';
GRANT SELECT ON mysql.proc TO 'pinboard'@'$db_host_netmask';
GRANT SELECT ON mysql.proc TO 'software_upgrade'@'$db_host_netmask';
GRANT SELECT ON mysql.proc TO 'stbmanager'@'$db_host_netmask';
GRANT SELECT ON mysql.proc TO 'resource_manager'@'$db_host_netmask';

UPDATE mysql.user SET File_priv='Y' WHERE Host='$db_host_netmask' AND User='AVS_BE';

flush privileges;
EOF

echo "$CURRENT_DATETIME - SetGrants.sh Successfully completed" | tee -a "$DIR/SetGrants.log"