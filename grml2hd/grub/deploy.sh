#!/bin/zsh

. /etc/grml/autoconfig.functions

STATUS=$(getbootparam status)
COMMON_SRC=$(getbootparam common)

echo 'BOOT_MANAGER="grub"' >> /etc/grml2hd/config

wget $COMMON_SRC -O /tmp/common.sh
chmod +x /tmp/common.sh
/tmp/common.sh
