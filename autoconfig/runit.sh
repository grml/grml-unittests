#!/bin/sh

. $FRAMEWORK

CMDLINE="$CMDLINE_COMMON noprompt netscript=$URL_PREFIX:$COMMON_PORT/deploy.sh status=$URL_PREFIX:$STATUS_PORT/ testsrc=$URL_PREFIX:$COMMON_PORT/unit_tests"
TEST_NAME=grml-autoconfig

run_test
timeout

# wait until the status server 
wait $SERVER_PID
