#!/bin/bash
echo '**********************'
echo 'Installing ansible'
echo '**********************'
echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
sudo apt-get update -y
sudo apt-get -y install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt-get -y install ansible
echo '**********************'
echo 'End Installing ansible'
echo '**********************'