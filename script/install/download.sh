#!/bin/bash
fileName=$1
if [  -z "fileName" ]
  then
    echo "FileName must be supplied. eg: [ ./download.sh admin_service_dev_1.1.zip] "
    exit 1
fi
echo "Downloading file [$fileName]"
wget -c  http://build.educoresystems.com/$fileName -P /opt/build/
