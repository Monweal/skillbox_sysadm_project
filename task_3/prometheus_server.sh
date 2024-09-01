#!/bin/bash

. ~/functions

sudo apt update && sudo apt install -y prometheus prometheus-node-exporter prometheus-alertmanager || print_error "Can't install prometheus"

# @TODO deb-package
~/add_exporter.sh || print_error "Can't add exporter"

# config alertmanager mail address
read -p "Enter your gmail address: " EMAIL
sed -i "s/<GMAIL>/$EMAIL/g" ~/alertmanager.yml
read -s -p "Enter your gmail password: " PASSWORD
sed -i "s/<PASSWORD>/$PASSWORD/g" ~/alertmanager.yml
sudo cp -v ~/alertmanager.yml /etc/prometheus/
sudo systemctl restart prometheus-alertmanager

# config metric's IPs
read -p "Enter OVPN-server IP: " OVPN_IP
sed -i "s/<OVPN_SERVER_IP>/$OVPN_IP/g" ~/prometheus.yml
read -p "Enter CA-server IP: " CA_IP
sed -i "s/<CA_SERVER_IP>/$CA_IP/g" ~/prometheus.yml
sudo cp -v ~/prometheus.yml /etc/prometheus/

sudo systemctl restart prometheus
