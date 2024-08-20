#!/bin/bash

print_error()
{
  echo "Error: $1"
  exit 1
}

read -p "Enter certification center IP: " CC_IP

cd ~/easy-rsa
# install openvpn
sudo apt update && yes | sudo apt install ~/openvpn-config_0.1-1_all.deb -y
# generate request and secret key
printf "\n" | ./easyrsa gen-req server nopass || print_error "Can't generate request"
sudo cp -v pki/private/server.key /etc/openvpn/server/ || print_error "Can't copy server private key"

# signing the sertificate on remote certification center
scp pki/reqs/server.req $CC_IP:~/easy-rsa/pki/reqs/server.req || print_error "Can't copy CSR to certification center on IP: $CC_IP"
read -s -p "Enter your CA password: " CA_PASSWORD
ssh $CC_IP "cd /home/yc-user/easy-rsa/ && printf 'yes\n$CA_PASSWORD\n' | ./easyrsa sign-req server server" || print_error "Can't sign the request"
mkdir pki/issued && scp $CC_IP:~/easy-rsa/pki/issued/server.crt pki/issued/ || print_error "Can't get certificate back"

# copy files to VPN server
sudo cp -v pki/issued/server.crt /etc/openvpn/server || print_error "Can't copy server certificate"
scp $CC_IP:~/easy-rsa/pki/ca.crt pki/ || print_error "Can't copy CA-cert from remote"
sudo cp -v pki/ca.crt /etc/openvpn/server || print_error "Can't copy CA-certificate"

# generate tls-crypt key
openvpn --genkey --secret ta.key || print_error "Can't generate tls-crypt key"
sudo cp -v ta.key /etc/openvpn/server || print_error "Can't copy tls-crypt key"

echo "End!" && exit 0

# @TODO client
#
# make dir for clients
mkdir -p ~/clients/{keys,keys/ta,files}
sudo cp -v /etc/openvpn/server/ta.key ~/clients/keys/ta/
chmod -R 700 ~/clients
sudo cp -v /etc/openvpn/server/ca.crt ~/clients/keys/
sudo chown -R $USER:$(id $USER -gn) ~/clients/keys

# openvpn settings
cp -v /etc/openvpn/conf/base.conf ~/clients/

# @TODO server and client take
# find out server IP
if curl --output /dev/null --silent ifconfig.me; then
  MYIP=$(curl ifconfig.me)
else
  read -p "Enter IP of this server: " MYIP
fi

# @TODO client
sed -i "s/CHANGE_THIS_IP/$MYIP/g" ~/clients/base.conf

# @TODO server
sudo bash -c 'echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf' || print_error "Can't write sysctl config"
sudo sysctl -p || print_error "Can't load new kernel parameters"

# iptables routes settings
sudo /etc/openvpn/conf/iptables.sh eth0 udp 1194 || print_error "Can't write iptables rules"

# start openvpn service
sudo systemctl start openvpn-server@server.service
