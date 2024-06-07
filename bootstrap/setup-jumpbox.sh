#!/bin/bash

set -e

####print color####
function print_color(){

 NC='\033[0m'
 case $1 in
    "green") COLOR='\033[0;32m' ;;
    "red") COLOR='\033[0;31m' ;;
    "*") COLOR='\033[0m' ;;
  esac

  echo -e "${COLOR}$2 ${NC}"
}

print_color green "\n --------------Setting up JumpBox----------------\n"

apt-get -y install wget curl vim openssl git && echo "Installed curl, vim, openssl, git" > logs.txt || \
        { echo "Installation failed curl, vim, openssl, git" > logs.txt ; exit 1 ; }

print_color green "\n --------------Clone Github repo----------------\n"

git clone --depth 1 \
  https://github.com/kelseyhightower/kubernetes-the-hard-way.git && echo "Clone successful" >> logs.txt || \
  { echo "git clone failed" >> logs.txt ; exit 1 ; }