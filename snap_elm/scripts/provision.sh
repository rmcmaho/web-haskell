#!/usr/bin/env bash

echo Updating...
apt-get update

echo Installing Haskell platform...
apt-get install -y haskell-platform cabal-install

echo Installing PostgreSQL...
apt-get install -y postgresql

echo Updating cabal...
su vagrant && cabal update
su vagrant && cabal install cabal-install
export PATH=/home/vagrant/.cabal/bin:$PATH

echo Installing snap framework...
su vagrant && cabal install snap

