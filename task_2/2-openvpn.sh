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

# make dir for clients
mkdir -p ~/clients/{keys,keys/ta,files}
sudo cp -v /etc/openvpn/server/ta.key ~/clients/keys/ta/
chmod -R 700 ~/clients
sudo cp -v /etc/openvpn/server/ca.crt ~/clients/keys/
sudo chown -R $USER:$(id $USER -gn) ~/clients/keys

# openvpn settings
sudo cp -v ~/server.conf /etc/openvpn/server/
cp -v ~/base.conf ~/clients/

# find out server IP
if curl --output /dev/null --silent ifconfig.me; then
  MYIP=$(curl ifconfig.me)
else
  read -p "Enter IP of this server: " MYIP
fi

sed -i "s/CHANGE_THIS_IP/$MYIP/g" ~/clients/base.conf
# @TODO install deb-package
sudo bash -c 'echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf' || print_error "Can't write sysctl config"
sudo sysctl -p || print_error "Can't load new kernel parameters"

# iptables routes settings
sudo ~/iptables.sh eth0 udp 1194 || print_error "Can't write iptables rules"

# start openvpn service
sudo systemctl start openvpn-server@server.service
