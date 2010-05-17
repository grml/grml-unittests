#!/bin/zsh
if [ $# -lt 2 ] ; then
    echo "Usage: $0 cdrom mountpoint [tests]">&2
    exit 1
fi

# support VNC=1 for automatically starting up vncviewer while running tests
# if $VNCVIEWER isn't set try to figure out which one could be used
if [ -z "$VNCVIEWER" ] ; then
    for vncviewer in xvnc4viewer Xtightvnc x11vnc vncviewer; do
        [[ -n ${commands[$vncviewer]} ]] && export VNCVIEWER=$vncviewer
    done
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
