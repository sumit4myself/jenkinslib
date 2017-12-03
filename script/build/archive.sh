#!/bin/bash
workspaceDir=$1
finalName=$1
apacheLocation=$2
echo "Archiving ${finalName} at location [ $apacheLocation ]"

cp  ${workspaceDir}/build/${finalName} $apacheLocation