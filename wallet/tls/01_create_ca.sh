#!/bin/bash

# The MIT License (MIT)
# Copyright (c) 2015 de-wiring.net
#
# EXAMPLE script, NOT READY FOR PRODUCTION USE
# create a ca structure, key and cert, self-sign.

# --
# create a ca structure

source '00_functions.sh'

if [[ ! -d $CA_PATH ]]; then
	mkdir -p $CA_PATH
	chmod 0700 $CA_PATH
fi


# create file/dir structure
( umask o-rwx,g-wx,u+rw; \
	mkdir $CA_PATH/certs $CA_PATH/private $CA_PATH/csr >/dev/null 2>&1
	[[ -f $CA_PATH/serial ]] || echo '100001' >$CA_PATH/serial
	touch $CA_PATH/index.txt
)

# generate key, use passphase file
# to encrypt output. self-sign
if [[ ! -f $CA_PATH/private/ca-key.pem ]]; then
	( umask o-rwx,g-rwx,u=r; \
		openssl req -new -sha256 \
			-newkey rsa:4096 \
			-keyout $CA_PATH/private/cakey.pem \
			-passout file:./passphrase_ca-file \
			-out $CA_PATH/careq.pem \
			-config ./openssl.cnf \
			-batch;
	) &&
	( umask o=r,g=r,u=r; \
		openssl ca \
			-create_serial -verbose -batch \
			-out $CA_PATH/cacert.pem \
			-passin file:./passphrase_ca-file \
			-days 365 \
			-keyfile $CA_PATH/private/cakey.pem \
			-selfsign \
			-extensions v3_ca \
			-config ./openssl.cnf \
			-infiles $CA_PATH/careq.pem \
	)

fi

