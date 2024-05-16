#!/bin/bash
echo "=================KUBEADM INIT===================="
# MASTER='134.209.154.94'
# WORKER1='139.59.94.245'
# WORKER2='139.59.94.198'
kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=128.199.18.207 > /home/ansible/init-log.txt

ufw allow 6783
ufw allow 6784

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

#kubectl apply -f https://reweave.azurewebsites.net/k8s/v1.29/net.yaml 
#https://github.com/weaveworks/weave/blob/master/site/kubernetes/kube-addon.md#-installation
#grep -A1 'kubeadm join' init-log.txt | sed -r -e 's/ \\//' -e 's/^\s+/ /' | xargs
exit 0