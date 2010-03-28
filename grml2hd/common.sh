#!/bin/zsh

. /etc/grml/autoconfig.functions

STATUS=$(getbootparam status)
sfdisk /dev/sda <<EOF
1
;
EOF

sed -i "s#^PARTITION=.*#PARTITION=/dev/sda1#" /etc/grml2hd/config
sed -i "s#^BOOT_PARTITION=.*#BOOT_PARTITION=/dev/sda#" /etc/grml2hd/config
echo 'BOOT_MANAGER="grub"' >> /etc/grml2hd/config
echo 'BOOT_APPEND="'netscript=$STATUS/DONE'"' >> /etc/grml2hd/config
echo "GRML2HD_FINALIZE='no'" >> /etc/grml2hd/customization
GRML2HD_NONINTERACTIVE='yes' grml2hd
shutdown -h now
