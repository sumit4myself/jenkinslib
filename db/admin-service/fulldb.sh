#!/bin/bash
source ./init.cfg

releaseType=$1
releaseVersion=$2

if [  -z "$1" ] || [  -z "$2" ]
  then
    echo "ReleaseType and ReleaseVersion must be supplied eg: [ ./fulldb.sh cloud 1.1] "
    exit 1
fi

logDir='./logs'
mkdir -p $logDir

if  [ $1 -eq 'prod' ]
    then
    databseName=$releaseType 
    databseName+='_'
fi

databseName+=$db

logFileName=$logDir
logFileName+='/'
logFileName+=$releaseType
logFileName+='_'
logFileName+=$releaseVersion
logFileName+='.log'

outputFileName=$logDir
outputFileName+='/'
outputFileName+=$releaseType
outputFileName+='_'
outputFileName+=$releaseVersion
outputFileName+='.out'


echo "** Staring full db setup for Database [ Host [$host_name], Database [$databseName] ]  **"
echo "** Writing output [ $outputFileName ]  **"
echo "** Writing log [ $logFileName ]  **"

set -e
set -u

# Set these environmental variables to override them,
# but they have safe defaults.
export PGHOST=${host-localhost}
export PGPORT=${port_number-5432}
export PGDATABASE=${db}
export PGUSER=${db_user_name-postgres}
export PGPASSWORD=${db_password-postgres}

RUN_PSQL="psql -X --set AUTOCOMMIT=on --set ON_ERROR_STOP=on -o $outputFileName"

echo "** Running Tables scripts  **"
$RUN_PSQL -f ./Full/Tables/table.sql 2> $logFileName
$executionResult=$?
if  [ $executionResult -eq 0 ]
    then
        echo "** Configuration scripts sucessfully executed. **"
    else
        echo "** FAILED : Error during script configuration.sql **"					   
    exit 1
fi

echo "** Running Indexes scripts  **"
$RUN_PSQL -f ./Full/Indexes/index.sql 2> $logFileName
$executionResult=$?
if  [ $executionResult -eq 0 ]
    then
        echo "** Configuration scripts sucessfully executed. **"
    else
        echo "** FAILED : Error during script configuration.sql **"					   
    exit 1
fi


echo "** Running Function scripts  **"
$RUN_PSQL -f ./Full/Functions/function.sql 2> $logFileName
$executionResult=$?
if  [ $executionResult -eq 0 ]
    then
        echo "** Configuration scripts sucessfully executed. **"
    else
        echo "** FAILED : Error during script configuration.sql **"					   
    exit 1
fi


echo "** Running Data scripts  **"
$RUN_PSQL -f ./Full/Data/data.sql 2> $logFileName
$executionResult=$?
if  [ $executionResult -eq 0 ]
    then
        echo "** Data scripts sucessfully executed. **"
    else
        echo "** FAILED : Error during script data.sql **"						   
    exit 1
fi

echo "** Running Data scripts  **"
$RUN_PSQL -f ./Full/Data/data.sql 2> $logFileName
$executionResult=$?
if  [ $executionResult -eq 0 ]
    then
        echo "** Data scripts sucessfully executed. **"
    else
        echo "** FAILED : Error during script data.sql **"						   
    exit 1
fi

echo "** Running Permission scripts  **"
$RUN_PSQL -f ./Full/Permission/permission.sql 2> $logFileName
$executionResult=$?
if  [ $executionResult -eq 0 ]
    then
        echo "** Permission scripts sucessfully executed. **"
    else
        echo "** FAILED : Error during script permission.sql **"						   
    exit 1
fi



