#!/bin/bash

print_error()
{
  echo "Error: $1"
  exit 1
}

# read -p "Enter client name in one word: " NAME
NAME="$1"
# @TODO check if client exist

# generate client request
cd ~/easy-rsa
printf "\n" | ./easyrsa gen-req $NAME nopass || print_error "Can't create client request" 
cp -v pki/private/$NAME.key ~/clients/keys/

# generate client certificate
printf "yes\n" | ./easyrsa sign-req client $NAME || print_error "Can't generate client certificate"
cp -v ./pki/issued/$NAME.crt ~/clients/keys/

# make client configure file
cd ~ && ./make-config.sh $NAME || print_error "Can't make client configure file"
