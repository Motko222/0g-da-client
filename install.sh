#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) 
folder=$(echo $path | awk -F/ '{print $NF}')

cd /root
git clone https://github.com/0glabs/0g-da-client.git
cd 0g-da-client
docker build -t 0g-da-client -f combined.Dockerfile .
