#!/bin/zsh

. /etc/grml/autoconfig.functions

mkdir -p /tmp/tests

TESTS_SRC=$(getbootparam testsrc)
STATUS=$(getbootparam status)

if [ -n "$TESTS_SRC" ] ; then
    cd /tmp/tests
    wget -m -np -nd $TESTS_SRC/
    cd -
fi
chmod +x /tmp/tests/*.sh

for file in /tmp/tests/*.sh ; do
    PATH=/tmp/tests $file
    RETVAL=$?
    [ "$RETVAL" -ne 0 ] && wget $STATUS/FAIL

done
wget $STATUS/DONE

