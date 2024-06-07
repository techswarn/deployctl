#!/bin/bash

while read IP FQDN HOST SUBNET; do
  echo ${IP}
  ssh -n -i ~/.ssh/k8deploy root@${IP} uname -o -m
done < machines.txt
