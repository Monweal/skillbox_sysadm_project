#!/bin/bash

. ~/functions

sudo apt install ~/build-ca_1.0-1_all.deb -y || print_error "Can't install build-ca package"

# copy easy-rsa vars file
cp /etc/easyrsa/vars ~/easy-rsa/ && cd ~/easy-rsa

# generate ca.crt
read -s -p "Enter your CA password: " CA_PASSWORD
printf "$CA_PASSWORD\n$CA_PASSWORD\n\n" | ./easyrsa build-ca || print_error "Can't build ca cert"
