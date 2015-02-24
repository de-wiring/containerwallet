#!/bin/bash

source '00_functions.sh'

TARGET=/wallet/tls

if [[ ! -d $TARGET ]]; then
	mkdir -p $TARGET
fi

mkdir $TARGET/wallet
mkdir $TARGET/Application1

chmod -R 0777 $TARGET

for k in wallet Application1; do
	cp $CA_PATH/certs/* $CA_PATH/cacert.pem $TARGET/${k}
	cp $CA_PATH/private/${k}-key.pem $TARGET/${k}
	# decrypt key
	openssl rsa \
		-in 	$CA_PATH/private/${k}-key.pem \
		-out 	$TARGET/${k}/${k}.key \	
		-passin file:./passphrase-file
done

# wallet server needs dhparam
cp $CA_PATH/private/dhparam.pem $TARGET/wallet/

