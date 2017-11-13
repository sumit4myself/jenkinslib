#!/bin/bash

BASE=`dirname $0`

LIB_DIR=$BASE/../lib
CONFIG_DIR=$BASE/../config
MAIN_CLASS=org.springframework.batch.core.launch.support.CommandLineJobRunner

APPLICATION_TENANT=$2

if [ "$APPLICATION_TENANT" = "." ]; then
	echo "USING DEFAULT TENANT"
else
	if [ ! -d $CONFIG_DIR/$APPLICATION_TENANT ]; then
		echo "TENTANT ${APPLICATION_TENANT} DOES NOT EXIST!!"
		exit 1
	fi
fi

LOG_FILE=$BASE/../log/$APPLICATION_TENANT/$1.`date +"%Y%m%d"`.log
echo Redirecting all output to log file $LOG_FILE
exec 3>&1 4>&2 1>>$LOG_FILE 2>&1

source $CONFIG_DIR/commons.env

echo "Environment:"
echo "JAVA_CMD=$JAVA_CMD"
echo "LIB_DIR=$LIB_DIR"
echo "CONFIG_DIR=$CONFIG_DIR/$APPLICATION_TENANT"
echo "MAIN_CLASS=$MAIN_CLASS"

echo "building classpath using JARs contained in: $LIB_DIR"
JARS_LIST=`ls ${LIB_DIR}/*.jar`
for i in ${JARS_LIST} ; do
  CLASSPATH=${CLASSPATH}:${i}
done

echo "adding config directory to the classpath"
CLASSPATH=$CONFIG_DIR/$APPLICATION_TENANT:${CLASSPATH}

JVM_PARAMETERS="-Xms1024m -Xmx1024m -XX:+DisableExplicitGC -XX:+UseConcMarkSweepGC -XX:ParallelGCThreads=2 -DBASE=$BASE"
APP_PARAMETERS="launch-context.xml"

#Retrieve JOB parameters
JOB_NAME=$1
shift 2
JOB_PARAMETERS=$@

if [ "$APPLICATION_TENANT" = "." ]; then
	ALREADY_RUNNING=$(ps -eaf | grep java | grep $MAIN_CLASS | grep $JOB_NAME | grep -v grep | grep -v /bin/sh | wc -l)
else
	ALREADY_RUNNING=$(ps -eaf | grep java | grep $MAIN_CLASS | grep $JOB_NAME | grep $APPLICATION_TENANT | grep -v grep | grep -v /bin/sh | wc -l)
fi

if [ $ALREADY_RUNNING -gt 2 ]; then
  echo "${MAIN_CLASS} already running, aborting..."
  exit -1
else
  #echo "${JAVA_CMD} ${JVM_PARAMETERS} -classpath ${CLASSPATH} ${MAIN_CLASS} ${APP_PARAMETERS} $JOB_NAME $JOB_PARAMETERS"
  ${JAVA_CMD} ${JVM_PARAMETERS} -classpath ${CLASSPATH} ${MAIN_CLASS} ${APP_PARAMETERS} $JOB_NAME $JOB_PARAMETERS
fi

EXIT_CODE=${?}

if [ ${EXIT_CODE} -ne 0 ] ; then
  echo "Error during execution. Program terminated with exit code: $EXIT_CODE"
  exit ${EXIT_CODE};
else
  echo "Execution of ${MAIN_CLASS} completed successfully."
fi
