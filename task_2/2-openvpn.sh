#!/bin/bash

print_error()
{
  echo "Error: $1"
  exit 1
}

cd ~/easy-rsa
# install openvpn
sudo apt update && sudo apt install openvpn -y
# generate request and secret key
printf "\n" | ./easyrsa gen-req server nopass || print_error "Can't generate request"
sudo cp -v pki/private/server.key /etc/openvpn/server/ || print_error "Can't copy server private key"

# signing the sertificate
echo "yes" | ./easyrsa sign-req server server || print_error "Can't sign the sertificate"

# copy files to VPN server
sudo cp -v pki/issued/server.crt /etc/openvpn/server || print_error "Can't copy server certificate"
sudo cp -v pki/ca.crt /etc/openvpn/server || print_error "Can't copy CA-certificate"

# generate tls-crypt key
openvpn --genkey --secret ta.key || print_error "Can't generate tls-crypt key"
sudo cp -v ta.key /etc/openvpn/server || print_error "Can't copy tls-crypt key"
