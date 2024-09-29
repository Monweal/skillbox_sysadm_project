#!/bin/bash

. /etc/functions

# copy easy-rsa vars file
cp /etc/easyrsa/vars ~/easy-rsa/ && cd ~/easy-rsa

# generate ca.crt
read -s -p "Enter your CA password: " CA_PASSWORD
printf "$CA_PASSWORD\n$CA_PASSWORD\n\n" | ./easyrsa build-ca || print_error "Can't build ca cert"
