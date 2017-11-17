#!/bin/bash
WORKING_DIR=temp
cd ../
CUR_DIR=$(pwd)

echo "Starting delete dir ${CUR_DIR}/${WORKING_DIR}"
echo "REL:${RELEASE_NUMBER}"

rm -rf "${CUR_DIR}/${WORKING_DIR}"

outputDelet=$?

if [ $outputDelet -ne 0 ]
then
   echo "Command delete ${OLD_DIR}/${WORKING_DIR}  is not properly terminated"
   exit 1
fi


#pwd

CUR_DIR=$(pwd)
echo "CUR_DIR: ${CUR_DIR}"
	  	
if [ -d db ] && [ $(ls db/ | wc -l) -ne 0 ]
then
	echo "Starting zip ${CUR_DIR}/db"		

    	#zip -rq "db_${BUILD_NUMBER}.zip" db/*
	find db/ -type d -name .svn -prune -o -print | zip -uq db_${BUILD_NUMBER}.zip -@
	outputzip=$?
	if [ $outputzip -ne 0 ]
  		then
	     echo "Command zip is not properly terminated"
  		fi
  	
	mkdir -p ${CUR_DIR}/${WORKING_DIR}/db

	echo "Starting move ${CUR_DIR}/db_${BUILD_NUMBER}.zip into ${CUR_DIR}/${WORKING_DIR}/db"	

	mv db_${BUILD_NUMBER}.zip ${CUR_DIR}/${WORKING_DIR}/db
  		outputmove=$?
	if [ $outputmove -ne 0 ]
  		then
 	  	echo "Command move is not properly terminated"
  		fi
fi


if [ -d dist ] && [ $(ls dist/ | wc -l) -ne 0 ]
then
	echo "Starting zip ${CUR_DIR}/dist"

	#zip -rq "dist_${BUILD_NUMBER}.zip" dist/*
	find dist/ -type d -name .svn -prune -o -print | zip -uq dist_${BUILD_NUMBER}.zip -@
  		outputzip=$?
	if [ $outputzip -ne 0 ]
  		then
   		echo "Command zip is not properly terminated"
	fi

	mkdir -p ${CUR_DIR}/${WORKING_DIR}/dist

	echo "Starting move ${CUR_DIR}/dist_${BUILD_NUMBER}.zip into ${CUR_DIR}/${WORKING_DIR}/dist" 

   	mv dist_${BUILD_NUMBER}.zip ${CUR_DIR}/${WORKING_DIR}/dist
   	outputmove=$?
   	if [ $outputmove -ne 0 ]
  	   	then
   		echo "Command move is not properly terminated"
  	   	fi
fi


echo "Starting zip all file in ${CUR_DIR}/${WORKING_DIR}/ naming ${JOB_NAME}"_REL_"${RELEASE_NUMBER}.zip"

zip -rq ${JOB_NAME}"_REL_"${RELEASE_NUMBER}.zip *
  	outputzip=$?
  	if [ $outputzip -ne 0 ]
then
     	echo "Command zip is not properly terminated"
fi	
