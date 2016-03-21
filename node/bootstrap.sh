#!/bin/bash

ETHERNODE_A=$1
ETHERNODE_B=$2

ETHERNODE_B_ID=`curl -X POST --data '{"jsonrpc":"2.0","method":"admin_nodeInfo","params":[],"id":74}' http://$ETHERNODE_B:8545 2>>/dev/null | sed -e 's/.*"result":{"id":"//g' - | sed -e 's/","name":".*//g' -`

ETHERNODE_B_IP=`ping -c 1 $ETHERNODE_B 2>>/dev/null | head -1 | sed -re 's/PING [^ ]+ \(//g' - | sed -re 's/\) .+//g' -`
ETHERNODE_B_ENODE="enode://$ETHERNODE_B_ID@$ETHERNODE_B_IP:30303"

curl -X POST --data '{"jsonrpc":"2.0","method":"admin_addPeer","params":["'$ETHERNODE_B_ENODE'"],"id":'$RANDOM'}' http://$ETHERNODE_A:8545

