#!/usr/bin/env bats

grml_cmdline="persistence"
grml_hda="grml-persistence-3.img"

# tests
@test "persistence passed properly to the kernel" {
  grep 'persistence' /proc/cmdline
}

@test "persistent file exists" {
  cat /home/grml/persistence/testfile
}
