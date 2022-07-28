# These variables are required to install CRI-O container runtime. Version should match the version of k8s being installed.
VERSION=1.24


echo 'Disable swap.'
sudo swapoff -a


echo 'Installing updates and needed base packages.'
sudo dnf update -y
sudo dnf install iproute-tc -y
sudo dnf install git -y
sudo dnf install vim -y
sudo dnf install bash-completion -y


echo 'Installing CRI-O container runtime.'
sudo dnf module enable cri-o:$VERSION -y
sudo dnf install cri-o -y


echo 'Starting CRI-O.'
sudo systemctl daemon-reload
sudo systemctl enable crio
sudo systemctl start crio


echo 'Update cgroup config for CRI-O'
sudo touch /etc/crio/crio.conf.d/02-cgroup-manager.conf
cat <<EOF | /etc/crio/crio.conf.d/02-cgroup-manager.conf
[crio.runtime]
conmon_cgroup = "pod"
cgroup_manager = "cgroupfs"
EOF
sudo systemctl restart crio



echo 'Putting SELinux into permissive mode and ensuring setting persists system reboot.'
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config


echo 'Install kubernetes components.'
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

sudo dnf install kubelet kubeadm kubectl --disableexcludes=kubernetes -y
sudo systemctl enable --now kubelet


echo '=============================================================================================='
echo 'IMPORTANT NOTE: Check if the below log output to confirm that the installation was successful!'
echo '=============================================================================================='
git --version
crio --version
kubeadm version
kubelet --version