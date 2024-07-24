#!/bin/sh

# tested on Ubuntu 22.04

rm -rf ./gitlab/*
cp -af ./github/* ./gitlab/

# git commit to github
cd ./gitlab/
git add *
git commit -a -m "merge with main branch"
git push origin gitlab
cd ../
