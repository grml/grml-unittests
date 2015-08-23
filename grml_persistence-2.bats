#!/usr/bin/env bats

grml_cmdline="persistence persistence-label=custompersist"
grml_hda="grml-persistence-2.img"

# tests
@test "persistence passed properly to the kernel" {
  grep 'persistence' /proc/cmdline
  grep 'custompersist' /proc/cmdline
}

@test "persistent file exists" {
  cat /home/grml/persistence/testfile
}
