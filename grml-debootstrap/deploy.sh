#!/bin/zsh

. /etc/grml/autoconfig.functions

STATUS=$(getbootparam status)
sfdisk /dev/sda <<EOF
0 88 0x0c
;
EOF

# cat << EOT | setup-storage -X -f -
#disk_config sda
#primary /    0- - -
#primary swap 20 swap rw
#EOT

MIRROR=http://cdn.debian.net/debian
HOSTNAME=unittest
SUITE=stable
TARGET="/dev/sda1"
PASSWORD="grml"

# TODO: --bootoptions="netscript=$STATUS/DONE"

echo 'y' | grml-debootstrap -m $MIRROR \
    -r $SUITE -t $TARGET --hostname $HOSTNAME \
    --password $PASSWORD

# cat << EOT |grml-chroot $TARGET /bin/bash

cat >> $TARGET /etc/rc.local << EOT
echo $STATUS/DONE
EOT

shutdown -h now
