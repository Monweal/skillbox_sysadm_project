#!/bin/bash

. /etc/functions

# create PKI dir
mkdir ~/easy-rsa && cd easy-rsa
# make symbolic link to easyrsa
ln -s /usr/share/easy-rsa/easyrsa .
# init PKI
./easyrsa init-pki || print_error "Can't init pki"
