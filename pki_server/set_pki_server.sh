#!/bin/bash

PREFIX="/etc/easyrsa"

# install all needed packages
echo iptables-persistent iptables-persistent/autosave_v4 boolean false | sudo debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean false | sudo debconf-set-selections
sudo apt update && yes | sudo apt install ./pki-server_0.1-1_all.deb ./security-settings_0.1-1_all.deb -y || exit 1

/etc/iptables/security_settings.sh &&
$PREFIX/init-pki.sh &&
$PREFIX/build_ca.sh
