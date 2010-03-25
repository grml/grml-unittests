#!/bin/zsh

setopt shwordsplit

oneTimeSetUp() {
    OLDPATH=$PATH
    mkdir -p /cdrom/bootparams
    echo ssh > /cdrom/bootparams/enable-ssh
    . /etc/grml/autoconfig.functions
    PATH=$OLDPATH
    config_ssh
}

oneTimeTearDown() {
    rm -rf /cdrom/bootparams
    /etc/init.d/ssh stop
}

test_runing_ssh() {
    SSH_PID=$(pidof sshd)
    assertNotNull "No running sshd found" "$SSH_PID"
}
test_grml_password() {
    getent shadow grml | grep -q "grml:*:"
    assertEquals "Wrong password for user grml!" 0 $?
}

SHUNIT_PARENT=$0
. /tmp/tests/shunit2
