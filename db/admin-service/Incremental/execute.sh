#!/bin/bash
source ../init.cfg
set -e
set -u

fileName=$1

echo "** Staring execution of file[ $fileName ] **"

# Set these environmental variables to override them,
# but they have safe defaults.
export PGHOST=${host-localhost}
export PGPORT=${port_number-5432}
export PGDATABASE=${db}
export PGUSER=${db_user_name-postgres}
export PGPASSWORD=${db_password-postgres}
psql -X --echo-all  --single-transaction --set AUTOCOMMIT=off  --set ON_ERROR_STOP=on -f $fileName 

