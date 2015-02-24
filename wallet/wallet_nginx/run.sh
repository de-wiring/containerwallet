#!/bin/bash

# stop and remove running wallet
( docker stop wallet >/dev/null 2>&1; docker rm wallet >/dev/null 2>&1 );

docker run \
	-d \
	-u wallet \
	--name wallet \
	--expose=8443 \
	-P  \
  	-v `pwd`:/wallet/test \
	-v /wallet/tls/wallet:/etc/nginx/certs/ \
	wallet_nginx:latest

