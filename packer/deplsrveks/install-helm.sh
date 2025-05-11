#!/bin/bash
echo '**********************'
echo 'Installing helm'
echo '**********************'
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
echo '**********************'
echo 'End Installing helm'
echo '**********************'