#!/bin/zsh

TIMEOUT_TIME=60
export URL_PREFIX=http://10.0.2.2
BAILOUT_CMD=""


timeout_handler() {
    wget -q --post-data="Timeout" -O /dev/null http://localhost:$STATUS_PORT//FAIL
    bailout
}

bailout() {
    [ -n "$DEBUG" ] && return 0
    eval $BAILOUT_CMD
    kill -9 $GATLING_PID $KVM_PID $SERVER_PID $TIMEOUT_PID $$ 2>/dev/null
}

run_test()
{
    python -m SimpleHTTPServer $COMMON_PORT >/dev/null 2>&1 &
    GATLING_PID=$!
    kvm -kernel "$KERNEL" -initrd "$INITRD" -append "$CMDLINE"  -vnc :0 -cdrom "$CDROM" -boot d $KVM_PARAMS &
    KVM_PID=$!
    $SERVER_STATUS -p $STATUS_PORT -t "$TEST_NAME" &
    SERVER_PID=$!
    if [ -n "$VNC" -a -n "$VNCVIEWER" ] ; then
        while $VNCSTATUS; do
	  VNCSTATUS=true
	  sleep 1
          if lsof -i -n | grep ':5900' ; then
	    $VNCVIEWER localhost &
	    VNCSTATUS=false
          fi
        done
    fi
}

timeout()
{
    [ -n "$DEBUG" ] && return 0
    ( sleep $TIMEOUT_TIME ; kill -16 $$; )2>/dev/null &
    TIMEOUT_PID=$!
}

trap timeout_handler 16
trap bailout QUIT INT EXIT

COMMON_PORT=0
STATUS_PORT=0

# $RANDOM is not set in dash, make sure a user who doesn't use
# something like /bin/zsh in his test scripts doesn't get obscure
# shell error messages
if [ -z "$RANDOM" ] ; then
    echo "Variable \$RANDOM not set, can not choose random port. Exiting.">&2
    bailout
fi

while [ $COMMON_PORT -lt 1024 ] || [  $STATUS_PORT -lt 1024 ] ; do
    COMMON_PORT=$RANDOM
    STATUS_PORT=$RANDOM
done
