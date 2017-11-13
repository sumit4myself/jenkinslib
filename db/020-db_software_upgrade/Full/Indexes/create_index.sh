#!/bin/sh
mysql -uroot -p$2 -h$4 --port=$3 <<EOF
use $1;

EOF