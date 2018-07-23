#!/bin/bash
# Author Graham Cleven

# set RAM usage
maxmem=24000

#check for KVM 
if [ `egrep -c '(vmx|svm)' /proc/cpuinfo` == 0 ]; then 
	echo 'Hardware not supported'
	exit
fi

# check processor
if [ `egrep -c ' lm ' /proc/cpuinfo` == 0 ]; then
	maxmem=2000
fi

# check kernel and limit hypervisor memory use
if [ `uname -m | grep x86_64 | wc -c` == 0 ]; then
	maxmem=2000 
fi

# install required packages
installedPackages=`dpkg-query -l`
require=(qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils)

for package in ${require[@]}; do
	if [ `echo "$installedPackages" | grep $package | wc -c` == 0 ]; then
		apt-get install $package; fi
done;

# add user into libvirtd group 
if [ $(cat /etc/group | grep libvirtd | grep `id -un` | wc -c) == 0 ]; then
	adduser `id -un` libvirtd
fi

# test virsh package setup
if [ `virsh list --all | grep error | wc -c` -gt 0 ]; then
	echo 'are you root?'
fi

# test socket perms
if [ `stat -c '%A %a %n' /var/run/libvirt/libvirt-sock | grep 770 | wc -c` == 0 ]; then
	echo 'socket perms must be set to 770'
	exit
fi

# test group ownership of kvm
if [ `ls -l /dev/kvm  | grep 'root kvm' | wc -c` == 0 ]; then
	chown root:kvm /dev/kvm
fi

# restart kernel modules
rmmod kvm
modprobe -a kvm


