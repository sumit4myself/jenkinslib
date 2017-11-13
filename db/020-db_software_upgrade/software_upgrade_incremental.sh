#!/bin/bash


##echo -n "Enter root password: " ; read rootpsw
##
##echo -n "Enter AVS database name: " ; read db_avs
##
##echo -n "Enter CSMDB database name: " ; read db_csmdb
##rootpsw=new-password
source ./init.cfg
db_host_ip=$1

fixfilename=_incr.sql
mkdir -p ./Incremental_logs

echo "*************************************************"  


checkversion=`mysql -uroot -p$rootpsw --host=$db_host_ip --port=$port_number -s -N -e "select count(1) from information_schema.tables where table_schema = '$db_avs' and table_name ='avs_version'"  2> ./Incremental_logs/log-incremental.log `

	if [ $checkversion -eq 0 ]
  then
    echo "** ERROR : Table $db_avs.avs_version doesn't exist **"
    echo "** PROCEDURE ABORTED                           **"
    echo "*************************************************"  
  	    exit 1
	fi

checkconf=`mysql -uroot -p$rootpsw --host=$db_host_ip --port=$port_number -s -N -e "select count(1) from $db_avs.avs_version where avs_release = '$avs_release' and avs_last_incremental >= 0"  2> ./Incremental_logs/log-incremental.log `

	if [ $checkconf -eq 0 ]
  then
    echo "** ERROR : Table $db_avs.avs_version doesn't configurated **"
    echo "** PROCEDURE ABORTED                           **"
    echo "*************************************************"  
  	    exit 1
	fi
  
maxseq=`mysql -uroot -p$rootpsw --host=$db_host_ip --port=$port_number -s -N -e "select avs_last_incremental +1 from $db_avs.avs_version where avs_release = '$avs_release'"  2> ./Incremental_logs/log-incremental.log` 

	if [ $maxseq -lt 0 ]
		then
	    echo "The value of avs_last_incremental in table AVS_VERSION must be > 0"
	    echo "Actual value for avs_last_incremental is $maxseq"
	    echo "Operation aborted"
	    exit 1
	fi


cd Incremental	
fixstring=incr.sql


        for i in $( ls |grep incr.sql$ ); do

					ssss=1
   
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
					mysql --user=root --password=$rootpsw --port=$port_number --host=$db_host_ip $db_avs --batch < $nomefile 2> ../Incremental_logs/log-incremental.log
					 
					 if  [ $? -eq 0 ]
					  then
					  mysql -u root -p$rootpsw --host=$db_host_ip --port=$port_number -e "update $db_avs.avs_version set avs_last_incremental = $X where avs_release = '$avs_release'" 2> ../Incremental_logs/log-incremental.log 
					  mysql -u root -p$rootpsw --host=$db_host_ip --port=$port_number -e "update $db_avs.avs_version set avs_start_incremental = $maxseq -1 where avs_release = '$avs_release'" 2> ../Incremental_logs/log-incremental.log
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
    
