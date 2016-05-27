#!/bin/bash


LAY_TYPE=`xmodmap -pke | grep " 24 " | cut -d ' ' -f 5`

if [ "${LAY_TYPE}" == "a" ]
then
    xmodmap ~/.XmodmapQwertee
elif [ "${LAY_TYPE}" == "q" ]
then
    xmodmap ~/.Xmodmap
fi
