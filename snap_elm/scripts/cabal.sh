#!/bin/bash

function run_cabal {
    cabal $@
    status=$?
    if [ $status -ne 0 ]; then
      echo "$@ failed with $status"
      exit $status
    fi
}

echo Updating cabal...
run_cabal update
run_cabal install cabal-install

echo Installing snap framework...
run_cabal install snap

echo Installing postgresql snaplet...
run_cabal install snaplet-postgresql-simple

echo Installing elm...
run_cabal install elm
