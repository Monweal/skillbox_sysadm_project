#!/bin/bash

. ~/functions

# install all needed packages
echo iptables-persistent iptables-persistent/autosave_v4 boolean false | sudo debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean false | sudo debconf-set-selections
sudo apt update && yes | sudo apt install ~/security-settings_1.0-1_all.deb -y || print_error "Can't install packages"
# apply iptables settings
sudo iptables-restore < /etc/iptables/rules.v4 || print_error "Can't set up iptables"

# allow input to prometheus-server
read -p "Is this prometheus server? y/n: " yn
if [ "$yn" == "y" ]; then
  # allow connect to prometheus web
  sudo iptables -A INPUT -p tcp --dport 9090 -j ACCEPT || print_error "Can't set iptables"
else
  # allow prometheus-server connect to my port 9100 (node-exporter)
  read -p "Enter prometheus server IP: " PROMETHEUS_IP
  sudo iptables -A INPUT -p tcp -s $PROMETHEUS_IP --dport 9100 -j ACCEPT || print_error "Can't set iptables"
fi
sudo service netfilter-persistent save || print_error "Can't save iptables rules"
