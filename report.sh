#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
json=~/logs/report-$folder
source ~/.bash_profile
source $path/env

cd /root
node_status=$(./grpcurl --plaintext localhost:51001 grpc.health.v1.Health/Check | jq -r .status )
docker_status=$(docker inspect 0g-da-client | jq -r .[].State.Status)
url=$(wget -qO- eth0.me):51001

status="ok"
[ "$node_status" != "SERVING" ] && status="error" && message="not serving"
[ "$docker_status" != "running" ] && status="error" && message="docker not running ($docker_status)"

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
