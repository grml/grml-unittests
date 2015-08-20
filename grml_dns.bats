#!/usr/bin/env bats

cmdline="dns=1.1.1.1,2.2.2.2,3.3.3.3"

# tests
@test "dns= passed properly to the kernel" {
  grep 'dns=' /proc/cmdline
}

@test "DNS properly set in /etc/resolv.conf" {
  # only test two nameservers, as QEMU will add one via DHCP and we can have max 3
  grep "^nameserver 1.1.1.1$" /etc/resolv.conf
  grep "^nameserver 2.2.2.2$" /etc/resolv.conf
}

@test "DNS properly set in /etc/resolvconf/resolv.conf.d/base" {
  grep "^nameserver 1.1.1.1$" /etc/resolvconf/resolv.conf.d/base
  grep "^nameserver 2.2.2.2$" /etc/resolvconf/resolv.conf.d/base
  grep "^nameserver 3.3.3.3$" /etc/resolvconf/resolv.conf.d/base
}
