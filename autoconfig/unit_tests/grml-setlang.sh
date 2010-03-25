#!/bin/zsh

setopt shwordsplit
lang() {
    grml-setlang $1
    assertEquals "wrong return value" 0 $?
    grep -q -i "LANG=.*$1" /etc/default/locale
    assertEquals "did not find $1 in default/locale" 0 $?

}
test_setlang() {
    for x in us de pt ; do
        lang $x
    done



}
SHUNIT_PARENT=$0
. /tmp/tests/shunit2
