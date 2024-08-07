#!/bin/bash

print_error()
{
  echo "Error: $1"
  exit 1
}

make_easyrsa_vars()
{
  local DIR=~/easy-rsa/vars
  sudo echo "set_var $1 '$2'" >> $DIR
}

# first install easy-rsa
sudo apt update && sudo apt install easy-rsa -y || print_error "Can't install easy-rsa"
# create PKI dir
mkdir ~/easy-rsa && cd easy-rsa
# make symbolic link to easyrsa
ln -s /usr/share/easy-rsa/easyrsa .
# init PKI
./easyrsa init-pki

# make easy-rsa vars file
make_easyrsa_vars EASYRSA_REQ_COUNTRY RUS
make_easyrsa_vars EASYRSA_REQ_PROVINCE "Sverdlovsk district"
make_easyrsa_vars EASYRSA_REQ_CITY Yekaterinburg
make_easyrsa_vars EASYRSA_REQ_ORG "Prosoft Systems"
make_easyrsa_vars EASYRSA_REQ_EMAIL elaldermon495@gmail.com
make_easyrsa_vars EASYRSA_REQ_OU LLC
make_easyrsa_vars EASYRSA_ALGO ec
make_easyrsa_vars EASYRSA_DIGEST sha512

# generate ca.crt
./easyrsa build-ca
