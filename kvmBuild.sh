#!/bin/bash
# Author Graham Cleven

name='Mint'
RAM='512'
cores='1'

virt-install --name $name --ram=$RAM --vcpus=$cores --cpu host --hvm --disk path=/var/lib/libvirt/images/mint,size=8 --cdrom /var/lib/libvirt/boot/linuxmint-19-cinnamon-64bit.iso --graphics spice

#spice,port=20001,listen=127.0.0.1
