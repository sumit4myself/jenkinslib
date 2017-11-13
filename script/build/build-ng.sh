#!/bin/bash
IFS=',' read -ra OPTIONS <<< "${AVS_BUILDTYPE}"

for i in "${OPTIONS[@]}"; do
    eval export $i=true
done

cd commons-scripts/scripts/

sh build.sh
