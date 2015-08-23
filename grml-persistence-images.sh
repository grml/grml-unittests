#!/bin/sh

set -e

create_img () {
  local imgname=$1
  local imglabel=$2
  local imgconf="$3"
  local tmpmount=$(mktemp -d)
  local tmploop

  dd if=/dev/zero of=${imgname} bs=1M count=16
  sudo parted -s ${imgname} mklabel msdos
  sudo parted -s ${imgname} mkpart primary ext4 0% 100%
  sudo kpartx -av ${imgname}
  tmploop="/dev/mapper/$(sudo kpartx -l ${imgname} |awk '{print $1}')"
  sleep 1
  sudo mkfs.ext4 -L ${imglabel} ${tmploop}
  sudo mount ${tmploop} ${tmpmount}
  echo ${imgconf} | sudo tee -a ${tmpmount}/persistence.conf
  sudo mkdir -p ${tmpmount}/home/grml/persistence
  sudo mkdir -p ${tmpmount}/rw/grml/persistence
  echo ${imgname} | sudo tee -a ${tmpmount}/home/grml/persistence/testfile
  echo ${imgname} | sudo tee -a ${tmpmount}/rw/grml/persistence/testfile
  sudo umount ${tmpmount}
  sudo kpartx -dv ${imgname}
  rmdir ${tmpmount}
}

create_img grml-persistence-1.img persistence '/home/grml/persistence'
create_img grml-persistence-2.img custompersist '/home/grml/persistence'
create_img grml-persistence-3.img persistence '/home union,source=.'
create_img grml-persistence-4.img persistence '/home bind'
