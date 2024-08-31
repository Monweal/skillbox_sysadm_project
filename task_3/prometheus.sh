#!/bin/bash

sudo apt update && sudo apt install -y prometheus prometheus-node-exporter prometheus-alertmanager
# @TODO deb-package
sudo cp ~/rules.yml /etc/prometheus/
# добавить rules.yml в конфиг
sudo systemctl restart prometheus
