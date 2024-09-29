#!/bin/bash

. /etc/functions

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
