#!/bin/zsh

. /etc/grml/autoconfig.functions

COMMON_SRC=$(getbootparam common)

wget $COMMON_SRC -O /tmp/common.sh
chmod +x /tmp/common.sh
/tmp/common.sh
