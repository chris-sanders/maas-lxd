#!/bin/bash

CONTAINER=$1

MAJOR=$(lxc version | awk -F. '{print $1}')
MINOR=$(lxc version | awk -F. '{print $2}')

echo "Creating container $CONTAINER"
lxc profile create maas-profile 2> /dev/null
lxc profile edit maas-profile < maas-profile
if [ $MAJOR -eq 2 ] && [ $MINOR -eq 0 ]
then
    lxc launch ubuntu:16.04 $CONTAINER -p maas-profile
else
    lxc profile create root-device 2> /dev/null
    lxc profile edit root-device < root-device
    lxc launch ubuntu:16.04 $CONTAINER -p maas-profile -p root-device
fi

echo "Sleeping to wait for IP"
sleep 5

IPADDRESS=$(lxc info $CONTAINER | awk -F"[: \t]+" '/eth0:.*inet[^6]/ {print $4}')
echo "Setting up pxe redirect for IP $IPADDRESS"
lxc network set lxdbr0 raw.dnsmasq dhcp-boot=pxelinux.0,$CONTAINER,$IPADDRESS && systemctl restart lxd.service

echo "MAAS will become available at: http://$IPADDRESS/MAAS with user/password admin/admin"
