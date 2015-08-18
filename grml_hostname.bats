#!/usr/bin/env bats

# tests
@test "hostname= passed properly to the kernel" {
  grep 'hostname=' /proc/cmdline
}

@test "hostname properly set" {
  [ "$(hostname)" = "foobar" ]
}
