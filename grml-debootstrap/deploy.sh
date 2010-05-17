#!/bin/zsh

. /etc/grml/autoconfig.functions

STATUS=$(getbootparam status)
sfdisk /dev/sda <<EOF
0 88 0x0c
;
EOF


yes y | grml2usb --force --fat16 --bootoptions="netscript=$STATUS/DONE" /live/image /dev/sda1
shutdown -h now
