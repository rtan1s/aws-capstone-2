#!/bin/bash
echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
sudo apt-get -y update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
echo deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get -y update
sudo apt-get -y install terraform
terraform version
