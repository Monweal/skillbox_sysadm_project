#!/bin/bash

. ~/functions

OVPN=0
if [ "$1" == "ovpn" ]; then
  OVPN=1
fi

sudo apt update && sudo apt install -y prometheus-node-exporter || print_error "Can't install node exporter"
# @TODO deb-package
if [ $OVPN -eq 1 ]; then
  sudo cp -v ~/rules_ovpn.yml /etc/prometheus/
else
  sudo cp -v ~/rules.yml /etc/prometheus/
fi

sudo systemctl restart prometheus-node-exporter || print_error "Can't restart node exporter"
