#!/bin/bash
workspaceDir=$1
finalName=$2
apacheLocation=$3
echo "Archiving ${finalName} at location [ $apacheLocation ]"

cp  ${workspaceDir}/build/${finalName} $apacheLocation