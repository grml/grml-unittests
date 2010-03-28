#!/bin/sh

for i in grub lilo ; do
    PARENT=$$ $i/runit.sh
done
