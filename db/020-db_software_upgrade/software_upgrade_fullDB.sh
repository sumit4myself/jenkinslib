#!/bin/bash

source ./init.cfg
db_host_ip=$1

mysql -u root -p$rootpsw -h$db_host_ip --port=$port_number  -e "select CONCAT('DROP USER ',GRANTEE,' ;') from information_schema.USER_PRIVILEGES where GRANTEE like '''$db_user_name''@%' " --silent --raw > delete_user_temp.sql

mysql -u root -h$db_host_ip -p$rootpsw --port=$port_number < delete_user_temp.sql

mysql -uroot -h$db_host_ip -p$rootpsw --port=$port_number <<EOF

DROP DATABASE IF EXISTS $db_avs ;

CREATE DATABASE $db_avs CHARACTER SET utf8 COLLATE utf8_bin;

CREATE USER "$db_user_name"@"$host_name" IDENTIFIED BY "$db_password";

GRANT ALL PRIVILEGES ON $db_avs.* TO "$db_user_name"@"$host_name" IDENTIFIED BY "$db_password" ;

GRANT ALL PRIVILEGES ON $db_avs.* TO "$db_user_name"@'$db_host_ip' IDENTIFIED BY "$db_password" ;
use $db_avs;
SOURCE Full/Software_Build_All.sql;
EOF

rm delete_user_temp.sql
