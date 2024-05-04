#!/bin/bash

kubeadm join 157.245.102.13:6443 --token kxemso.m9i3b3fhzcepnj85 \
	--discovery-token-ca-cert-hash sha256:e7ac73d583ba476d3ccc8394a36a94472d283bad4388c4f126db4156d4270b6c 

exit 0