#!/usr/bin/env bash
ssh-keygen -t rsa -b 4096 -C "freeaion@gmail.com"
git remote add origin git@github.com:freeaion/emacs_setting.git
git push -u origin master
