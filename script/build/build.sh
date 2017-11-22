#!/bin/bash
workspaceDir=$1
gradleModulePath=$2
versionInfo=$3

echo "Build in progress..."	
echo "******************************************************************************************"
echo "Workspace directory  [ $workspaceDir ]"
echo "Gradle Module Path [ $gradleModulePath ]"
echo "Version Info [ $versionInfo ]"

echo "******************************************************************************************"

/usr/local/gradle/bin/gradle -p $workspaceDir $gradleModulePath:build -P PROJECT_VERSION=$versionInfo
