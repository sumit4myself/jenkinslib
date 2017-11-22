#!/bin/bash
source ./init.cfg

set -e
set -u

BUILD_NUMBER=$1
BUILD_TYPE=$2

if [  -z "$1" ] || [  -z "$2" ]
  then
    echo "Build Number and build type must be supplied eg: [ ./fulldb.sh admin_service_cloud_1.1 dev] "
    exit 1
fi
databseName='';
if  [ $BUILD_TYPE -ne 'prod' ]
    then
    	databseName=$BUILD_TYPE 
    	databseName+='_'
fi
databseName+=$db

echo "** Staring incremental rollback db setup for Database [ Host [$host], Database [$databseName] ]  **"
echo "** Info [ Build Number [$BUILD_NUMBER], Build Type [$BUILD_TYPE] ]  **"

# Set these environmental variables to override them,
# but they have safe defaults.
export PGHOST=${host-localhost}
export PGPORT=${port_number-5432}
export PGDATABASE=${db}
export PGUSER=${db_user_name-postgres}
export PGPASSWORD=${db_password-postgres}


echo "** Getting Version Details **"
read build_nember update_date start_incremental last_incremental <<< $(psql -X --no-align  -t --field-separator ' ' --quiet -c "select build_nember, update_date, start_incremental, last_incremental from version limit 1") 

echo "******************************************************************************************"
echo "Last build number  [ $build_nember ]"
echo "Last build deployed on [ $update_date ]"
echo "Start incremental [ $start_incremental ]"
echo "Last incremental [ $last_incremental ]"
echo "******************************************************************************************"

RUN_PSQL="psql -X --echo-all  --single-transaction --set AUTOCOMMIT=on  --set ON_ERROR_STOP=on"

cd Incremental	
fixfilename=_roll.sql
fixstring=incr.sql
        for i in $( ls -r |grep incr.sql$ ); do
            t=1
        done
        
maxfile=${i:0:3}
maxfilebis=`expr $maxfile + 1`
for (( X=$last_incremental; X>$start_incremental; X-- ))
do
	if 		[ ${#X} -eq 1 ]
			then
			nomefile="00$X"
			nomefile=$nomefile$fixfilename
	elif [ ${#X} -eq 2 ]
			then
			nomefile="0$X"
			nomefile=$nomefile$fixfilename
	elif [ ${#X} -eq 3 ]
			then
			nomefile=$X
			nomefile=$nomefile$fixfilename
	fi
	  for i in $( ls |grep $nomefile ); do	        
               	echo "******************************************************************************************"
			    echo "Executing script $nomefile ..."		
				chmod 755 execute.sh		
				OUTPUT=$(./execute.sh $nomefile)
				$RUN_PSQL --no-align  -c "update version set last_incremental = $X -1"
				$RUN_PSQL --no-align  -c "update version set start_incremental = $X -1" 
				echo "$nomefile successfully                   **"	
				echo "******************************************************************************************"
					
	  done
done  
echo "Complete successfully   "