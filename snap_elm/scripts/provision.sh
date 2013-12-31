#!/usr/bin/env bash

echo Updating...
apt-get update

echo Installing Haskell platform...
apt-get install -y haskell-platform cabal-install

echo Installing git...
apt-get install -y git

echo Install emacs...
apt-get install -y emacs

echo Installing PostgreSQL...
apt-get install -y postgresql postgresql-server-dev-9.1 libghc-postgresql-libpq-dev

echo apt-get cleanup...
apt-get -y autoremove

su vagrant -c '/vagrant_scripts/user.sh'
su vagrant -c '/vagrant_scripts/cabal.sh'

