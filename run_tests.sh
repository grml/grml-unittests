#!/bin/zsh
if [ $# -le 2 ] ; then
    echo "Usage: $0 cdrom mountpoint [tests]"
    exit 1
fi

export CDROM="$1"
export KERNEL=$(find "$2"/boot/ -name linux26)
export INITRD=$(find "$2"/boot/ -name initrd.gz)
export CMDLINE_COMMON="$(awk '/append/ {  $1 = $2 = ""; print }' "$2/boot/isolinux/default.cfg")"

shift
shift

export SERVER_STATUS="$PWD/webserver.py"
export FRAMEWORK="$PWD/framework.sh"
if [ -n "$1" ] ; then
    TESTS=$*
else
    TESTS=(*(/))
fi
for dir in $TESTS ; do
    [ ! -x $dir ] && continue
    cd $dir
    ./runit.sh >/dev/null
    cd -
done
