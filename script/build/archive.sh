#!/bin/bash
WORKING_DIR=temp
cd ../
CUR_DIR=$(pwd)

ReleaseNumber=$1
apacheLocation=$2
echo "Archiving ${ReleaseNumber}.zip at location [ $apacheLocation ]"

mv  ${CUR_DIR}/${WORKING_DIR}/${ReleaseNumber}.zip $apacheLocation