#!/bin/bash

( docker stop wallet >/dev/null 2>&1; docker rm wallet >/dev/null 2>&1 );

docker run \
	-tdi \
	-u wallet \
	--name wallet \
	--expose=8443 \
  	-v `pwd`:/wallet/test \
	wallet_nginx:latest

