# The MIT License (MIT)
# Copyright (c) 2015 de-wiring.net
#
# EXAMPLE script, NOT READY FOR PRODUCTION USE
# common function(s)

CA_PATH=/wallet/ca

function create_key_req_cert() {
	# (file) name of things to create
	NAME=$1
	# subject
	SERVER_CERT_SUBJECT=$2
	

	# generate key
	( umask o-rwx,g-wx,u=r; \
		openssl genrsa \
		-aes256 \
		-out $CA_PATH/private/${NAME}-key.pem \
		-passout file:./passphrase-file \
		4096
	)
	
	# generate request
	openssl req \
		-subj ''$SERVER_CERT_SUBJECT'' \
		-new \
		-sha256 \
		-config ./openssl.cnf \
		-key $CA_PATH/private/${NAME}-key.pem \
		-passin file:./passphrase-file \
		-out $CA_PATH/csr/${NAME}.csr \
		-batch
	
	( umask o=r,g=r,u=r; \
		openssl ca \
			-verbose -batch \
			-config ./openssl.cnf \
			-extensions v3_req \
		        -passin file:./passphrase_ca-file \
		        -keyfile $CA_PATH/private/cakey.pem \
			-out $CA_PATH/certs/${NAME}.pem \
			-infiles $CA_PATH/csr/${NAME}.csr
	)
}
