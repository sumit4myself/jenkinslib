#!/bin/bash
fileName=$1
if [  -z "fileName" ]
  then
    echo "FileName must be supplied. eg: [ ./download.sh admin_service_dev_1.1.zip] "
    exit 1
fi
echo "Downloading file [$fileName]"
cd /opt/jars/
wget -O /dev/null http://build.educoresystems.com/builds/$fileName
