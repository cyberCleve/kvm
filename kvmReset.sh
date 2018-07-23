#!/bin/bash
# Author Graham Cleven
# This is for EMERGENCY USE ONLY

if [ $(echo "$1" | wc -c) == 1 ]; then
	echo 'syntax is: ./kvmReset name'
	exit
fi

source=$(virsh dumpxml $1 | grep 'source file' | head -1 | grep -Eo "(/.*)'")
source="${source::-1}"

virsh shutdown $1
virsh destroy $1
virsh undefine $1
rm $source

