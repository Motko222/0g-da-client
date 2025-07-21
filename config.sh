#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) 
folder=$(echo $path | awk -F/ '{print $NF}')
cd $path
[ -f envfile.env ] || cp envfile.sample envfile.env

cd $path
nano envfile.env
