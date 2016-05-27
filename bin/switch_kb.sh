#!/bin/bash

INNER_KB=`xinput | grep AT | awk -v N=7 '{print $N}' | cut -d '=' -f 2`
MASTER=`xinput | grep "slave  keyboard" | head -1 | awk -v N=9 '{print $N}' | sed 's/[^0-9]//g'`

if [ ${1} ]
then
    if [ ${1} == 1 ]
    then
	xinput reattach $INNER_KB $MASTER
    elif [ ${1} == 2 ]
    then
	xinput float $INNER_KB
    else
	echo "1: activate inner keyboard - 2: desactivate"	
    fi
else
    echo "1: activate inner keyboard - 2: desactivate"
fi
