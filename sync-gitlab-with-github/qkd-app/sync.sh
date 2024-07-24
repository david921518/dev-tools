#!/bin/sh

# tested on Ubuntu 22.04

rm -rf ./gitlab/*
cp -af ./github/* ./gitlab/

# git commit to github
cd ./gitlab/
git add *
git commit -S -a -m "sync with github repo"
git push origin gitlab
cd ../
