#!/bin/bash
source ./init.cfg
db_host_ip=$1

mysql -uroot -p$rootpsw -h$db_host_ip --port=$port_number  <<EOF
USE $db_avs;

SET FOREIGN_KEY_CHECKS = 0;
USE $db_avs;

SOURCE Configuration/avs_version.sql

SET FOREIGN_KEY_CHECKS = 1;  
EOF
