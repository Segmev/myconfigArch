# !/usr/bin/bash

scrot /tmp/screen.png
convert /tmp/screen.png -blur 15x9 -gravity center  /tmp/screen.png
i3lock -i /tmp/screen.png
# while [ "true" ]
# do
#     xset dpms force off
#     sleep 15
# done
