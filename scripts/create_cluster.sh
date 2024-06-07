#!bin/sh

#Assign variable names to IPs

#Install Necessary packages
#sudo apt install net-tools -y

MASTER='134.209.154.94'
WORKER1='139.59.94.245'
WORKER2='139.59.94.198'


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

print_color green "\n----------------------------------Script starting... wait\n"

{
  PRIMARY_IP="$(ip route get 1 | awk '{print $(NF-2);exit}')"
  echo ${PRIMARY_IP}
}
#open port 6443
ufw allow 6443/tcp
nc 127.0.0.1 6443 -v

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system


#Verify that the br_netfilter, overlay modules are loaded by running the following
lsmod | grep br_netfilter
lsmod | grep overlay

sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward

#Install containerd

# Add Docker's official GPG key:
sudo apt-get update -y
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y

sudo apt-get install containerd.io -y

#Configure Cgroups 
cd /etc/containerd
echo $(pwd)

ls -al

if test -f /etc/containerd/config.toml; then
echo "File exists."
cat /etc/containerd/config.toml

cat << "EOF" > config.toml 
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
  [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
    SystemdCgroup = true
EOF

fi

cd /
sudo systemctl restart containerd
systemctl enable containerd

sudo swapoff -a

sudo apt-get update
# apt-transport-https may be a dummy package; if so, you can skip that package
sudo apt-get install -y apt-transport-https ca-certificates curl gpg 

# If the directory `/etc/apt/keyrings` does not exist, it should be created before the curl command, read the note below.
# sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update -y && sudo apt-get install -y kubelet kubeadm kubectl && \
 sudo apt-mark hold kubelet kubeadm kubectl && \
 sudo systemctl enable --now kubelet && echo "Install - OK" > /home/ansible/logs.txt

exit 0

# if [ "$IP" != "$MASTER" ] ; then 
#     echo "yes"
# else 
#     echo "Init Kubemdm"
# fi


