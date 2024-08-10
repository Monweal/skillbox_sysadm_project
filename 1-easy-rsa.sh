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

read -p "Enter your CA password: " CA_PASSWORD

# first install easy-rsa
sudo apt update && sudo apt install easy-rsa openvpn -y || print_error "Can't install easy-rsa"
# create PKI dir
mkdir ~/easy-rsa && cd easy-rsa
# make symbolic link to easyrsa
ln -s /usr/share/easy-rsa/easyrsa .
# init PKI
./easyrsa init-pki || print_error "Can't init pki"

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
printf "$CA_PASSWORD\n$CA_PASSWORD\n\n" | ./easyrsa build-ca || print_error "Can't build ca cert"

# generate request and secret key
printf "\n" | ./easyrsa gen-req server nopass || print_error "Can't generate request"
sudo cp -v pki/private/server.key /etc/openvpn/server/

# signing the sertificate
echo "yes" | ./easyrsa sign-req server server || print_error "Can't sign the sertificate"

# copy files to VPN server
sudo cp -v pki/issued/server.crt /etc/openvpn/server
sudo cp -v pki/ca.crt /etc/openvpn/server
