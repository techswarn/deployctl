#!/bin/bash

while read IP FQDN HOST SUBNET; do
  ssh-copy-id -i ~/.ssh/id_rsa.pub root@${IP}
done < machines.txt
