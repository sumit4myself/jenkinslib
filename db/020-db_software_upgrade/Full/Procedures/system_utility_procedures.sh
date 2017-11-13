#!/bin/sh
mysql -uroot -p$2 -h$4 --port=$3 <<EOF
USE $1;

SOURCE PROC_DROP_FOREIGN_KEY.sql;
SOURCE PROC_DROP_INDEX_KEY.sql;
SOURCE drop_column_if_exists.sql;
SOURCE PROC_DROP_PRIMARY_KEY.sql;

EOF