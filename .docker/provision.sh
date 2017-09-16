#!/bin/sh

echo "Installing git"
apt-get update > /dev/null 2>&1
apt-get install -y git > /dev/null 2>&1