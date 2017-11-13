#!/bin/bash
mv $1 $1.$(date +"%Y%m%d-%H%M")
mkdir -p $1
cd $1
BASEDIR=`pwd`
mkdir tmp
cd tmp
pwd
unzip ${BASEDIR}/../$2

mkdir -p ${BASEDIR}/config ${BASEDIR}/executable ${BASEDIR}/lib ${BASEDIR}/log

if [ -f lib/*.zip ]
then
  unzip lib/*.zip -d ${BASEDIR}
fi

if [ -f exe/*.zip ]
then
  unzip exe/*.zip -d ${BASEDIR}
  cp -r ${BASEDIR}/exe/* ${BASEDIR}/executable
fi

if [ -f conf/*.zip ]
then
  unzip conf/*.zip -d ${BASEDIR}
  cp -r ${BASEDIR}/conf/* ${BASEDIR}/config
fi

if [ -f dist/*.zip ]
then
  unzip dist/*.zip -d ${BASEDIR}
  cp -r ${BASEDIR}/dist/* ${BASEDIR}/lib
fi

rm -rf ${BASEDIR}/dist
rm -rf ${BASEDIR}/conf
rm -rf ${BASEDIR}/exe
rm -rf ${BASEDIR}/tmp

chmod +x ${BASEDIR}/executable/*
