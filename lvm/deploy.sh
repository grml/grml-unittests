#!/bin/zsh

. /etc/grml/autoconfig.functions
mkdir -p /tmp/tests

STATUS=$(getbootparam status)
run_command() {
    ERROR_MESSAGE="$1"
    shift
    $* > /tmp/output
    [ "$?" -ne 0 ] && wget --post-file=/tmp/output.log $STATUS/FAIL

}

sfdisk /dev/sda <<EOF
0,10,0x8e
EOF

run_command "pvcreate" pvcreate /dev/sda1
run_command "could not create vg group" vgcreate vg /dev/sda1
run_command "could not create lv" lvcreate -L10M -n 01 /dev/vg
run_command "could not format fs" mkfs.ext3 /dev/vg/01
run_command "could not mount group" mount /dev/vg/01 /mnt/test
run_command "could not resize logical volume" lvresize -L+5M /dev/vg/01
run_command "could not resize filestem" resize2fs /dev/vg/01
wget --post-data="Run $TESTS" $STATUS/DONE
