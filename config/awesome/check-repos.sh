#!/bin/sh
PREFIX="${HOME}/.config/awesome"

for i in {blingbling,freedesktop.git,utils,vicious,}; do
  echo "*** $i ***"
  cd $PREFIX/$i
  git pull -u
done

cd $PREFIX

# vim: tw=220
