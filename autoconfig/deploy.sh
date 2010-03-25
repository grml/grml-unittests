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

TESTS=""
for file in /tmp/tests/*.sh ; do
    PATH=/tmp/tests $file > /tmp/output.log
    RETVAL=$?
    [ "$RETVAL" -ne 0 ] && wget --post-file=/tmp/output.log $STATUS/FAIL
    TESTS="$TESTS $file"

done
wget --post-data="Run $TESTS" $STATUS/DONE

