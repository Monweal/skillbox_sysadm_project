#!/bin/bash

. ~/functions

read -p "Enter OpenVPN server IP: " OVPN_IP

# make dir for clients
mkdir -p ~/clients/{keys,keys/ta,files}
scp $OVPN_IP:~/easy-rsa/ta.key ~/clients/keys/ta/ || print_error "Can't remote copy tls-key"
chmod -R 700 ~/clients
scp $OVPN_IP:~/easy-rsa/pki/ca.crt ~/clients/keys/ || print_error "Can't remote copy CA certificate"
sudo chown -R $USER:$(id $USER -gn) ~/clients/keys

# openvpn settings
scp $OVPN_IP:/etc/openvpn/conf/base.conf ~/clients/ || print_error "Can't remote copy client configuration"

# find out openvpn server external IP
if ssh $OVPN_IP "curl --output /dev/null --silent ifconfig.me"; then
  EXTERNAL_OVPN_IP=$(ssh $OVPN_IP "curl ifconfig.me --silent")
else
  read -p "Enter IP of openvpn server: " EXTERNAL_OVPN_IP
fi

sed -i "s/CHANGE_THIS_IP/$EXTERNAL_OVPN_IP/g" ~/clients/base.conf
