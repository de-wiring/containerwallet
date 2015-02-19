#!/bin/bash

docker run \
	-ti \
	-v /var/wallet-keys/Application1:/tmp/keys \
	--link wallet:wallet \
	-e 'OBJECTS=database-password' \
	wallet_user

