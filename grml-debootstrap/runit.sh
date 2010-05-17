#!/bin/zsh

. $FRAMEWORK

CMDLINE="$CMDLINE_COMMON noprompt netscript=$URL_PREFIX:$COMMON_PORT/deploy.sh status=$URL_PREFIX:$STATUS_PORT/"
IMAGE=$(tempfile -d /dev/shm)
KVM_PARAMS="-hda $IMAGE"
TIMEOUT_TIME=180
TEST_NAME=grml-debootstrap
BAILOUT_CMD='rm -f $IMAGE ; kill -9 $TEST_PID 2>/dev/null'

# create sample image file
dd if=/dev/zero of=$IMAGE bs=1024 count=712000 2>/dev/null

# run the test (will create a bootable device
run_test
timeout
wait $KVM_PID

# start second kvm
kvm -vnc :0 -hda $IMAGE  &
TEST_PID=$!


wait $SERVER_PID
kill -9 $TEST_PID
rm -f $IMAGE

