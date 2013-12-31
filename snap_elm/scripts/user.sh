#!/bin/bash

if [ "$USER" != 'vagrant' ];
then
    exit 1
fi

bashrc_file=/home/vagrant/.bashrc

cp /etc/skel/.bashrc $bashrc_file
echo 'export PATH=/home/vagrant/.cabal/bin:$PATH' >> $bashrc_file
