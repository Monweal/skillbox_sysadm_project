#!/bin/bash

. ~/functions

# install all needed packages
echo iptables-persistent iptables-persistent/autosave_v4 boolean false | sudo debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean false | sudo debconf-set-selections
sudo apt update && yes | sudo apt install ~/security-settings_1.0-1_all.deb -y || print_error "Can't install packages"
# apply iptables settings
sudo iptables-restore < /etc/iptables/rules.v4 || print_error "Can't set up iptables"
