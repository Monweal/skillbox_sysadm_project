#!/bin/bash

. ~/functions

add_new_user()
{
  NAME="$1"
  read -p "Enter certification center IP: " CC_IP
  read -s -p "Enter your CA password: " CA_PASSWORD

  # generate client request
  cd ~/easy-rsa &&
  printf "\n" | ./easyrsa gen-req $NAME nopass || print_error "Can't create client request" 
  cp -v pki/private/$NAME.key ~/clients/keys/

  # generate client certificate
  scp pki/reqs/$NAME.req $CC_IP:~/easy-rsa/pki/reqs/
  ssh $CC_IP "cd ~/easy-rsa && printf 'yes\n${CA_PASSWORD}\n' | ./easyrsa sign-req client ${NAME}" || print_error "Can't sign client certificate"
  scp $CC_IP:~/easy-rsa/pki/issued/$NAME.crt ~/clients/keys/

  # make client configure file
  cd ~ && ./make-config.sh $NAME || print_error "Can't make client configure file"
}

read -p "Enter user name: " USERNAME
add_new_user $USERNAME
