#!/bin/bash
source ./init.cfg
releaseType=$1
releaseVersion=$2
logDir='./logs'
mkdir -p $logDir

if  [ $1 -eq 'prod' ]
    then
    databseName=$releaseType 
    databseName+='_'
fi

databseName+=$db

logFileName=$logDir
logFileName+='/inc_'
logFileName+=$releaseType
logFileName+='_'
logFileName+=$releaseVersion
logFileName+='.log'

outputFileName=$logDir
outputFileName+='/inc_'
outputFileName+=$releaseType
outputFileName+='_'
outputFileName+=$releaseVersion
outputFileName+='.out'

echo "** Staring Incremental db setup for Database [ Host [$host_name], Database [$databseName] ]  **"
echo "** Writing output [ $outputFileName ]  **"
echo "** Writing log [ $logFileName ]  **"

set -e
set -u

# Set these environmental variables to override them,
# but they have safe defaults.
export PGHOST=${PGHOST-localhost}
export PGPORT=${port_number-5432}
export PGDATABASE=${db}
export PGUSER=${db_user_name-postgres}
export PGPASSWORD=${db_password-postgres}

echo "** Getting Version Details **"
RUN_PSQL="psql -X --set AUTOCOMMIT=off --set ON_ERROR_STOP=on -L $logFileName "
read start_incremental last_incremental <<< $($RUN_PSQL --no-align  -t --field-separator ' ' --quiet -c "select start_incremental, last_incremental from version where id = 1") 2> $logFileName 

echo "The value of last_incremental in table VERSION is $last_incremental"


cd Incremental	
fixstring=incr.sql

for i in $( ls |grep incr.sql$ ); do
		t=1
done
        
maxfile=${i:0:3}
maxfilebis=`expr $maxfile + 1`
for (( X=$maxseq; X<$maxfilebis; X++ ))
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

##echo "il nome del file $nomefile "
	for i in $( ls |grep $nomefile ); do
			echo "** executing script $nomefile ...           **"			
				$RUN_PSQL -f $nomefile 2> $logFileName
					 if  [ $? -eq 0 ]
					  then
							$RUN_PSQL --no-align  -t --field-separator ' ' --quiet -c "update avs_version set last_incremental = $X where avs_release = '$avs_release'" 2> .$logFileName
							$RUN_PSQL --no-align  -t --field-separator ' ' --quiet -c "update avs_version set start_incremental = $maxseq -1 where avs_release = '$avs_release'" 2> .$logFileName
							echo "** $nomefile successfully                   **"	
							echo "**                                             **"
					 else
							echo "** FAILED : Error during script $nomefile   **"
							echo "**                                             **"
							echo "** PROCEDURE ABORTED                           **"
					  		maxseq2=`mysql -uroot -p$rootpsw --host=$db_host_ip --port=$port_number -s -N -e "select avs_last_incremental from $db_avs.avs_version where avs_release = '$avs_release'"  2>/dev/null` 
					  		printf -v filenameok1 "%03d" $maxseq
							printf -v filenameok2 "%03d" $maxseq2

					  ##echo "Are succesfully executed only the files from $filenameok1$fixfilename  to $filenameok2$fixfilename"
					  echo "*************************************************"       
					  exit 1
					 fi
	  done
done  
echo "** Complete successfully                       **"
echo "*************************************************"  