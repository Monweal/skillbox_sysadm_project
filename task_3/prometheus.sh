#!/bin/bash

. ~/functions

sudo apt update && sudo apt install -y prometheus prometheus-node-exporter prometheus-alertmanager || print_error "Can't install prometheus"

# @TODO deb-package
sudo cp -v ~/rules.yml /etc/prometheus/
sudo cp -v ~/prometheus.yml /etc/prometheus

sudo systemctl restart prometheus
