#!/bin/bash

cd /home/ansible


nodejoin=$(grep -A1 'kubeadm join' init-log.txt | sed -r -e 's/ \\//' -e 's/^\s+/ /' | xargs)
echo "$nodejoin --ignore-preflight-errors=all"
eval "$nodejoin" 

exit 0