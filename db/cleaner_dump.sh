#!/bin/bash

CURRENT_DATETIME=`date +%d%m%y%H%M`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "$CURRENT_DATETIME - Starting database clean" | tee -a "$DIR/log/$CURRENT_DATETIME.cleaner_dump.log"

#config
source $DIR/init.cfg
db_host_ip=$1 

mysql -uroot -p$password -h$db_host_ip --port=$port_number  -e "show databases" | grep -v Database | grep -v mysql| grep -v information_schema| grep -v test | grep -v OLD |gawk '{print "drop database " $1 ";"}' | mysql -uroot -p$password -h$db_host_ip --port=$port_number

cd $DIR/log
find . -mtime +7 -delete;

cd $DIR/dump
rm *.sql

cd $DIR/compare
rm *.txt

echo "$CURRENT_DATETIME - End database clean" | tee -a "$DIR/log/$CURRENT_DATETIME.cleaner_dump.log"