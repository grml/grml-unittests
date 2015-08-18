#!/bin/bash

set -e
set -o pipefail
set -o errtrace
set -o functrace

## validation / checks
[ -f /etc/grml_cd ] || { echo "File /etc/grml_cd doesn't exist, not executing script to avoid data loss." >&2 ; exit 1 ; }

## debugging
# if we notice an error then do NOT immediately return but provide
# user a chance to debug the VM
bailout() {
  echo "* Noticed problem during execution (line ${1}, exit code ${2}), sleeping for 9999 seconds to provide debugging option"
  #sleep 9999
  echo "* Finally exiting with return code 1"
  exit "$2"
}
trap 'bailout ${LINENO} $?' ERR

## helper functions
automated_tests() {
  echo "* Checking for bats"
  if dpkg --list bats >/dev/null 2>&1 ; then
    echo "* bats is already present, nothing to do."
  else
    echo "* Installing bats"
    apt-get update
    apt-get -y install bats
  fi

  echo "* Running tests to verify grml-debootstrap system"
  bats /tmp/grml.bats -t
}

## main execution
automated_tests

echo "* Finished execution of $0"
