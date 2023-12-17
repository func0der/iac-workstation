#!/bin/bash

ROOT_CA_LOCATION=$1
ROOT_CA_KEY=$2
CERTIFICATE_KEY_LOCATION=${3:-domain.key}
CERTIFICATE_LOCATION=${4:-domain.crt}
CERTIFICATE_CSR_LOCATION=/tmp/domain.csr

if [[ ! -e $ROOT_CA_LOCATION ]]; then
	echo 'Parameter 1 has to the location of the root certificate.'
	exit 1
fi

if [[ ! -e $ROOT_CA_KEY ]]; then
	echo 'Parameter 2 has to the location of the root key.'
	exit 1
fi

# Generate private key.
openssl genrsa -out $CERTIFICATE_KEY_LOCATION 4096

# Create a certificate signing request.
openssl req -new -key $CERTIFICATE_KEY_LOCATION -out /tmp/domain.csr -sha512

# Self sign a new domain certificate.
openssl x509 \
	-in $CERTIFICATE_CSR_LOCATION \
	-CA $ROOT_CA_LOCATION \
	-CAkey $ROOT_CA_KEY \
	-CAcreateserial \
	-days 365 \
	-sha512 \
	-req \
	-out $CERTIFICATE_LOCATION

# Delete CSR.
unlink $CERTIFICATE_CSR_LOCATION;
