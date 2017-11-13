#!/bin/bash

mkdir -p log dump compare

CURRENT_DATETIME=`date +%d%m%y%H%M`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "$CURRENT_DATETIME - Starting database installation" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"

#config
source $DIR/init.cfg

#PARAMETER DB_HOST_IP PASSED BY JOB JENKINS
if [ $# -ne 1 ] 
then 
	echo "PLEASE INSERT THE DB_HOST_IP"
	exit 1;
else
	db_host_ip=$1
fi 

cd $DIR
./cleaner_dump.sh $db_host_ip
if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully cleaner_dump.sh" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
else
	echo "$CURRENT_DATETIME - Not successfully cleaner_dump.sh" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
	exit 1
fi

cd $DIR  

./Drop.sh $db_host_ip
if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully Drop.sh" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
else
	echo "$CURRENT_DATETIME - Not successfully Drop.sh" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
	exit 1
fi


./DropCassandra.sh
  if [ $? -eq 0 ]; then
  	echo "$CURRENT_DATETIME - Successfully DropCassandra.sh" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
  else
  	echo "$CURRENT_DATETIME - Not successfully DropCassandra.sh" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
  	exit 1
  fi


#START INSTALLATION FULL DB 
./install.sh $db_host_ip
if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully install.sh" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
else
	echo "$CURRENT_DATETIME - Not successfully install.sh" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
	exit 1
fi
#END INSTALLATION FULL DB

#START INSTALLATION FULL CASSANDRA DB 
./install_cassandra.sh $db_host_ip
if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully install_cassandra.sh" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
else
	echo "$CURRENT_DATETIME - Not successfully install_cassandra.sh" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
	exit 1
fi
#END INSTALLATION FULL DB


#CREATE ALL SCHEMA TEMP
cd $DIR
databases=`mysql -u root -p$password -h$db_host_ip --port=$port_number -e "SHOW DATABASES;" | tr -d "| " | egrep -v Database`
echo $databases
for db in $databases; do
  if [[ "$db" != "information_schema" ]] && [[ "$db" != "performance_schema" ]] && [[ "$db" != "mysql" ]] && [[ "$db" != "sys"* ]] && [[ "$db" != "test"* ]] && [[ "$db" != *"_temp" ]]  && [[ "$db" != "compare"* ]] && [[ "$db" != "metering"* ]]; then
       
        echo "$CURRENT_DATETIME - Dumping database: $db" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"  
        mysqldump --routines -u root -p$password -h$db_host_ip --port=$port_number $db > $DIR/dump/$db.sql
        
        echo "$CURRENT_DATETIME - Starting sed for ${db}_temp" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
        sed -e "s/$db\./$db\_temp./g" "$DIR/dump/$db.sql" > "$DIR/dump/${db}_temp.sql"
        
        echo "$CURRENT_DATETIME - Starting creation of ${db}_temp" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
        mysqladmin -u root -p$password -h$db_host_ip --port=$port_number create ${db}_temp;  
        
        echo "$CURRENT_DATETIME - Starting creation of dump on ${db}_temp" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log" 
        mysql -u root -p$password -h$db_host_ip --port=$port_number ${db}_temp < $DIR/dump/${db}_temp.sql
      
  fi
done       

#RUN ROLLBACK DB SCHEMA AS-IS
./rollback.sh $db_host_ip
if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully rollback.sh" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
else
	echo "$CURRENT_DATETIME - Not successfully rollback.sh" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
	exit 1
fi

#RUN ROLLBACK DB CASSANDRA
./rollback_cassandra.sh $db_host_ip
if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully rollback_cassandra.sh" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
else
	echo "$CURRENT_DATETIME - Not successfully rollback_cassandra.sh" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
	exit 1
fi

#RUN INCREMENTAL DB SCHEMA AS-IS
./install_incremental.sh $db_host_ip
if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully install_incremental.sh" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
else
	echo "$CURRENT_DATETIME - Not successfully install_incremental.sh" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
	exit 1
fi

#RUN INCREMENTAL DB SCHEMA AS-IS
./install_incremental_cassandra.sh $db_host_ip
if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully install_incremental_cassandra.sh" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
else
	echo "$CURRENT_DATETIME - Not successfully install_incremental_cassandra.sh" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
	exit 1
fi
  
####UPDATE FOR COMPARE
mysql -u root -p$password -h$db_host_ip --port=$port_number <<EOF
SOURCE bonifica.sql;
EOF
if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully bonifica.sh" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
else
	echo "$CURRENT_DATETIME - Not successfully bonifica.sh" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
	exit 1
fi
      ###
source $DIR/authentication/init.cfg
cd $DIR/authentication/Full/Triggers
./create_trigger_AVS_BE.sh ${db_avs}_temp $rootpsw $db_host_ip $port_number
if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully authentication/Full/Triggers/create_trigger_AVS_BE" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
else
	echo "$CURRENT_DATETIME - Not successfully authentication/Full/Triggers/create_trigger_AVS_BE" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
	exit 1
fi
	  
source $DIR/technical_catalogue/init.cfg   
cd $DIR/technical_catalogue/Full/Triggers   
./create_triggers.sh ${db_avs}_temp $rootpsw $port_number $db_host_ip
if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully technical_catalogue/Full/Triggers/create_triggers.sh" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
else
	echo "$CURRENT_DATETIME - Not successfully technical_catalogue/Full/Triggers/create_triggers.sh" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
	exit 1
fi

source $DIR/avs_be/init.cfg
cd $DIR/avs_be/Full/Triggers
./create_trigger_AVS_BE.sh ${db_avs}_temp $rootpsw $port_number $db_host_ip
if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully avs_be/Full/Triggers/create_trigger_AVS_BE" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
else
	echo "$CURRENT_DATETIME - Not successfully avs_be/Full/Triggers/create_trigger_AVS_BE" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
	exit 1
fi

source $DIR/npvrbe/init.cfg
cd $DIR/npvrbe/Full/Triggers
./create_triggers.sh ${db_avs}_temp $rootpsw $port_number $db_host_ip
if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully npvrbe/Full/Triggers/create_triggers.sh" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
else
	echo "$CURRENT_DATETIME - Not successfully npvrbe/Full/Triggers/create_triggers.sh" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
	exit 1
fi  

source $DIR/pinboard/init.cfg
cd $DIR/pinboard/Full/Triggers
./create_triggers.sh ${db_avs}_temp $rootpsw $port_number $db_host_ip
if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully pinboard/Full/Triggers/create_triggers.sh" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
else
	echo "$CURRENT_DATETIME - Not successfully pinboard/Full/Triggers/create_triggers.sh" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
	exit 1
fi

source $DIR/npvrmediator/init.cfg
cd $DIR/npvrmediator/Full/Triggers
./create_triggers.sh ${db_avs}_temp $rootpsw $port_number $db_host_ip
if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully npvrmediator/Full/Triggers/create_triggers.sh" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
else
	echo "$CURRENT_DATETIME - Not successfully npvrmediator/Full/Triggers/create_triggers.sh" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
	exit 1
fi

source $DIR/software_upgrade/init.cfg
cd $DIR/software_upgrade/Full/Triggers
./create_triggers.sh ${db_avs}_temp $rootpsw $port_number $db_host_ip
if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully software_upgrade/Full/Triggers/create_triggers.sh" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
else
	echo "$CURRENT_DATETIME - Not successfully software_upgrade/Full/Triggers/create_triggers.sh" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
	exit 1
fi

source $DIR/stb_management/init.cfg
cd $DIR/stb_management/Full/Triggers
./create_triggers.sh ${db_avs}_temp $rootpsw $port_number $db_host_ip
if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully stb_management/Full/Triggers/create_triggers.sh" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
else
	echo "$CURRENT_DATETIME - Not successfully stb_management/Full/Triggers/create_triggers.sh" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
	exit 1
fi

source $DIR/resource_manager/init.cfg
cd $DIR/resource_manager/Full/Triggers
./create_triggers.sh ${db_avs}_temp $rootpsw $port_number $db_host_ip
if [ $? -eq 0 ]; then
	echo "$CURRENT_DATETIME - Successfully resource_manager/Full/Triggers/create_triggers.sh" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
else
	echo "$CURRENT_DATETIME - Not successfully resource_manager/Full/Triggers/create_triggers.sh" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
	exit 1
fi

cd $DIR  
	  
#RUN MYSQLDBCOMPARE
for db in $databases; do
  if [[ "$db" != "information_schema" ]] && [[ "$db" != "performance_schema" ]] && [[ "$db" != "mysql" ]] && [[ "$db" != "sys"* ]] && [[ "$db" != "test"* ]] && [[ "$db" != *"_temp" ]] && [[ "$db" != "compare"* ]] && [[ "$db" != "metering"* ]]; then 
        echo "$CURRENT_DATETIME - Running mysqldbcompare for database $db and ${db}_temp" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log" 
        mysqldbcompare --skip-checksum-table --run-all-tests  --server1=root:$password@$db_host_ip:$port_number --server2=root:$password@$db_host_ip:$port_number --difftype=sql   $db:${db}_temp  > $DIR/compare/${db}_Vs_${db}_temp.txt &
  fi
done
wait

#CHECK OF MYSQLDBCOMPARE RESULT
grep -l -i -w -E "FAIL|FAILED" $DIR/compare/*.txt > $DIR/compare/grepFailCompare.txt
grepFailCompare=`ls -s "$DIR/compare/grepFailCompare.txt"`
echo "$CURRENT_DATETIME - $grepFailCompare"
  if [[ "$grepFailCompare" != "0 $DIR/compare/grepFailCompare.txt"  ]] ; then
      echo "$CURRENT_DATETIME - Compare Failed. See Details into file grepFailCompare.txt" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"  
      echo "$CURRENT_DATETIME - exit 1" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"    
      exit 1
  else
      echo "$CURRENT_DATETIME - Compare Ok!" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log" 
      echo "$CURRENT_DATETIME - exit 0" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"
      exit 0     
  fi
  
echo "$CURRENT_DATETIME - End database AVS_Database_Automatic_Installation" | tee -a "$DIR/log/$CURRENT_DATETIME.AVS_Database_Automatic_Install.log"