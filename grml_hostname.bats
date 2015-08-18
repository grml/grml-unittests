#!/usr/bin/env bats

# cmdline: hostname=foobar

# tests
@test "hostname= passed properly to the kernel" {
  grep 'hostname=' /proc/cmdline
}

@test "hostname properly set" {
  [ "$(hostname)" = "foobar" ]
}
