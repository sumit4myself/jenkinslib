#!/bin/bash
mv $1 $1.$(date +"%Y%m%d-%H%M")
mkdir -p $1
cd $1
BASEDIR=`pwd`
mkdir tmp
cd tmp
pwd
unzip ${BASEDIR}/../$2

mkdir -p ${BASEDIR}/dist ${BASEDIR}/db ${BASEDIR}/log

if [ -f db/*.zip ]
then
  unzip db/*.zip -d ${BASEDIR}
fi

if [ -f dist/*.zip ]
then
  unzip dist/*.zip -d ${BASEDIR}
  cp -r ${BASEDIR}/dist/* ${BASEDIR}/dist
fi

rm -rf ${BASEDIR}/dist
rm -rf ${BASEDIR}/db

chmod +x ${BASEDIR}/dist/*
