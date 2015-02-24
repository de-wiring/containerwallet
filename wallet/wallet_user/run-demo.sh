#!/bin/bash

# Run our sample container.
# Map wallet-keys from host to /wallet/keys,
# map tls keys/cert from host to /wallet/tls,
# link to wallet and supply object name(s)
docker run \
	-ti \
	-v /var/wallet-keys/Application1:/wallet/keys \
	-v /wallet/tls/Application1:/wallet/tls \
	--link wallet:wallet \
	-e 'OBJECTS=database-password' \
	wallet_user

