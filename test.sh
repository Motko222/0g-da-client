#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
cd $path
source $path/env
c=$(cat test-rpc | wc -l)

echo "------------------------"
for (( i=1;i<=$c;i++ ))
do
   rpc=$(cat test-rpc | head -$i | tail -1)
   printf "%s %-40s" $i $rpc
   status=$(/root/grpcurl --plaintext $rpc grpc.health.v1.Health/Check | jq -r .status)
   printf "%s \n" $status
done

echo "------------------------"
