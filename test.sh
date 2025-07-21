#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
cd $path
source $path/env
c=$(cat rpc | wc -l)

echo "------------------------"
for (( i=1;i<=$c;i++ ))
do
   rpc=$(cat rpc | head -$i | tail -1)
   height=$(curl -sX POST $rpc -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' | jq -r .result)
   printf "%s %-60s %s \n" $i $rpc $height
done

echo "------------------------"
