#!/bin/bash

PACKAGE_NAME="some.deb"

if [ -z "$1" ]; then
  DEB_PACKAGE_PATH=./$PACKAGE_NAME
else
  DEB_PACKAGE_PATH="$1"/$PACKAGE_NAME
fi
apt install $DEB_PACKAGE_PATH -y

PREFIX="/etc/pki_server"
$PREFIX/security_settings.sh &&
$PREFIX/init-pki.sh &&
$PREFIX/build_ca.sh
