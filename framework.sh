#!/bin/sh

TIMEOUT_TIME=60
export URL_PREFIX=http://10.0.2.2
BAILOUT_CMD=""

timeout_handler() {
    wget -q --post-data="Timeout" -O /dev/null http://localhost:$STATUS_PORT//FAIL
    bailout
}

bailout() {
    eval $BAILOUT_CMD
    kill -9 $GATLING_PID $KVM_PID $SERVER_PID $TIMEOUT_PID $$ 2>/dev/null
}

run_test()
{
    gatling -n -p $COMMON_PORT >/dev/null 2>&1 &
    GATLING_PID=$!
    kvm -kernel "$KERNEL" -initrd "$INITRD" -append "$CMDLINE"  -vnc :0 -cdrom "$CDROM" -boot d $KVM_PARAMS &
    KVM_PID=$!
    $SERVER_STATUS -p $STATUS_PORT -t "$TEST_NAME" &
    SERVER_PID=$!
}
timeout()
{
    ( sleep $TIMEOUT_TIME ; kill -16 $$; )2>/dev/null &
    TIMEOUT_PID=$!
}

trap timeout_handler 16
trap bailout QUIT INT EXIT

COMMON_PORT=0
STATUS_PORT=0

while [ $COMMON_PORT -lt 1024 ] || [  $STATUS_PORT -lt 1024 ] ; do
    COMMON_PORT=$RANDOM
    STATUS_PORT=$RANDOM
done
