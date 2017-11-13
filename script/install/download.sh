#!/bin/bash
wget -O /dev/null --keep-session-cookies --save-cookies cookies.txt --post-data 'j_username=jenkins&j_password=jenkins' http://192.168.7.200:8080/j_acegi_security_check
wget --load-cookies cookies.txt $1
rm -f cookies.txt
