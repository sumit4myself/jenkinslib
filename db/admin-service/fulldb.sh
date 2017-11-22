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

echo "** Staring full db setup for Database [ Host [$host], Database [$databseName] ]  **"
echo "** Info [ Build Number [$BUILD_NUMBER], Build Type [$BUILD_TYPE] ]  **"

# Set these environmental variables to override them,
# but they have safe defaults.
export PGHOST=${host-localhost}
export PGPORT=${port_number-5432}
export PGDATABASE=${db}
export PGUSER=${db_user_name-postgres}
export PGPASSWORD=${db_password-postgres}

RUN_PSQL="psql -X --set AUTOCOMMIT=on --set ON_ERROR_STOP=on --echo-all "

echo "** Running Tables scripts  **"
$RUN_PSQL -f ./Full/Tables/table.sql
executionResult=$?
if  [ $executionResult -eq 0 ]
    then
        echo "** Configuration scripts sucessfully executed. **"
    else
        echo "** FAILED : Error during script configuration.sql **"					   
    exit 1
fi

echo "** Running Indexes scripts  **"
$RUN_PSQL -f ./Full/Indexes/index.sql
executionResult=$?
if  [ $executionResult -eq 0 ]
    then
        echo "** Configuration scripts sucessfully executed. **"
    else
        echo "** FAILED : Error during script index.sql **"					   
    exit 1
fi


echo "** Running Function scripts  **"
$RUN_PSQL -f ./Full/Functions/function.sql
executionResult=$?
if  [ $executionResult -eq 0 ]
    then
        echo "** Configuration scripts sucessfully executed. **"
    else
        echo "** FAILED : Error during script function.sql **"					   
    exit 1
fi


echo "** Running Data scripts  **"
$RUN_PSQL -f ./Full/Data/data.sql
executionResult=$?
if  [ $executionResult -eq 0 ]
    then
        echo "** Data scripts sucessfully executed. **"
    else
        echo "** FAILED : Error during script data.sql **"						   
    exit 1
fi

echo "** Running Data scripts  **"
$RUN_PSQL -f ./Full/Data/data.sql
executionResult=$?
if  [ $executionResult -eq 0 ]
    then
        echo "** Data scripts sucessfully executed. **"
    else
        echo "** FAILED : Error during script data.sql **"						   
    exit 1
fi

echo "** Running Permission scripts  **"
$RUN_PSQL -f ./Full/Permission/permission.sql
executionResult=$?
if  [ $executionResult -eq 0 ]
    then
        echo "** Permission scripts sucessfully executed. **"
    else
        echo "** FAILED : Error during script permission.sql **"						   
    exit 1
fi



