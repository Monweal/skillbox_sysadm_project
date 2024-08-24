#!/bin/bash

. ~/functions

sudo apt update && sudo apt install easy-rsa -y || print_error "Can't install easy-rsa"

# create PKI dir
mkdir ~/easy-rsa && cd easy-rsa
# make symbolic link to easyrsa
ln -s /usr/share/easy-rsa/easyrsa .
# init PKI
./easyrsa init-pki || print_error "Can't init pki"
