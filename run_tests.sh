#!/bin/zsh
if [ $# -ne 2 ] ; then
    echo Usage: $0 cdrom mountpoint
    exit 1
fi

export CDROM="$1"
export KERNEL=$(find "$2"/boot/ -name linux26)
export INITRD=$(find "$2"/boot/ -name initrd.gz)
export CMDLINE_COMMON="$(awk '/append/ {  $1 = $2 = ""; print }' "$2/boot/isolinux/default.cfg")"


export SERVER_STATUS="$PWD/webserver.py"
export FRAMEWORK="$PWD/framework.sh"
for dir in *(/) ; do
    cd $dir
    ./runit.sh >/dev/null
    cd -
done
