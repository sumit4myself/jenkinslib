#!/bin/bash
echo "Running JMeter performance tests"

rm -f $WORKSPACE/jmeter.jtl
rm -f $WORKSPACE/jmeter.log

export PATH=/product/jdk/bin:$PATH

JMX_FILE=$1

shift 1

/product/apache-jmeter/bin/jmeter -n -t $JMX_FILE -l $WORKSPACE/jmeter.jtl "$@"
