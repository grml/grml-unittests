#!/bin/zsh

for i in grub lilo ; do
    PARENT=$$ $i/runit.sh
done
