#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
json=~/logs/report-$folder
source ~/.bash_profile
source $path/env


#get RPC addresses
node_rpc=$(cat ~/0g-da-node/config.toml | grep '^grpc_listen_address =' | tail -1 | awk '{print $3}' | sed 's/"//g')
chain_rpc=$(cat ~/0g-da-node/config.toml | grep '^eth_rpc_endpoint =' | tail -1 | awk '{print $3}' | sed 's/"//g')
disperser_rpc=localhost:51001

#get da node info
cd ~/0g-da-node/target/release
node_version=$(cat /root/logs/da-node-version )
cd ~
node_status=$(./grpcurl --plaintext localhost:51001 grpc.health.v1.Health/Check | jq -r .status )
docker_status=$(docker inspect 0g-da-client | jq -r .[].State.Status)

status="ok"
[ "$node_status" -ne "SERVING" ] && status=error && message="not serving"
[ "$docker_status" -ne "running" ] && status="ok" && message="docker not running ($docker_status)"

cat >$json << EOF
{
  "updated":"$(date --utc +%FT%TZ)",
  "measurement":"report",
  "tags": {
     "id":"$folder-$ID",
     "machine":"$MACHINE",
     "grp":"node",
     "owner":"$OWNER"
  },
  "fields": {
     "network":"testnet",
     "chain":"galileo",
     "status":"$status",
     "message":"$message",
     "url":"$url"
  }
}
EOF
cat $json | jq
