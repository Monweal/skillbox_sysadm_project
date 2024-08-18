#!/bin/bash

print_error()
{
  echo "Error: $1"
  exit 1
}

read -s -p "Enter your CA password: " CA_PASSWORD
# install all needed packages
echo iptables-persistent iptables-persistent/autosave_v4 boolean false | sudo debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean false | sudo debconf-set-selections
sudo apt update && yes | sudo apt install ~/pki-settings_0.1-1_all.deb -y || print_error "Can't install packages"
# apply iptables settings
sudo iptables-restore < /etc/iptables/rules.v4 || print_error "Can't set up iptables"

# create PKI dir
mkdir ~/easy-rsa && cd easy-rsa
# make symbolic link to easyrsa
ln -s /usr/share/easy-rsa/easyrsa .
# init PKI
./easyrsa init-pki || print_error "Can't init pki"

# copy easy-rsa vars file
cp /etc/easyrsa/vars ~/easy-rsa/

# generate ca.crt
printf "$CA_PASSWORD\n$CA_PASSWORD\n\n" | ./easyrsa build-ca || print_error "Can't build ca cert"
