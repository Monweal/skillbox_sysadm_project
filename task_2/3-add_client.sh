#!/bin/bash

print_error()
{
  echo "Error: $1"
  exit 1
}

list_all_users()
{
  # find and print only key names
  OUTPUT=$(find ~/clients/keys -maxdepth 1 -name "*.key" -printf "%f\n" | sed 's/\(.*\)\..*/\1/')
  if [ -z "$OUTPUT" ]; then
    echo "No one user exist"
    return 1
  else
    echo $OUTPUT
  fi
}

add_new_user()
{
  NAME="$1"

  # generate client request
  cd ~/easy-rsa &&
  printf "\n" | ./easyrsa gen-req $NAME nopass || print_error "Can't create client request" 
  cp -v pki/private/$NAME.key ~/clients/keys/

  # generate client certificate
  printf "yes\n" | ./easyrsa sign-req client $NAME || print_error "Can't generate client certificate"
  cp -v ./pki/issued/$NAME.crt ~/clients/keys/

  # make client configure file
  cd ~ && cp -v /etc/openvpn/conf/make-config.sh . && ./make-config.sh $NAME || print_error "Can't make client configure file"
}

remove_existing_user()
{
  NAME="$1"
  rm -f ~/easy-rsa/pki/private/$NAME.key ~/easy-rsa/pki/issued/$NAME.crt ~/clients/keys/$NAME.* ~/clients/files/$NAME.ovpn ~/easy-rsa/pki/reqs/$NAME.req
}

read -p "What do you want? Write command number:
  1) List all users;
  2) Add new user;
  3) Remove existing user.
" \
CHOICE

  case $CHOICE in
    "1") list_all_users ;;
    "2")
      read -p "Enter user name: " USERNAME
      add_new_user $USERNAME;;
    "3")
      list_all_users
      # check if any user exists
      if [ $? -ne 0 ]; then
        exit 0
      fi
      # make options array by list of all users
      IFS=' ' read -ra options <<< $(list_all_users)

      # remove selected user
      select option in "${options[@]}"; do
          remove_existing_user $option
          exit 0
      done ;;
    *) echo "Wrong command number"\
      exit 1 ;;
  esac
