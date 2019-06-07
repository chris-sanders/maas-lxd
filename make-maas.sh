#!/bin/bash

CONTAINER=$1

lxc version | grep "Server version" >/dev/null 2>&1

# lxc version > 3 has dififerent output
if [ $? -eq 0 ]
then
    # Find Major/Minor LXC version 3
    VER=$(lxc version | grep Server | awk -F: '{print $2}'i | sed 's/\s\+//g')
    MAJOR=$(echo $VER | awk -F. '{print $1}')
    MINOR=$(echo $VER | awk -F. '{print $2}')
else
    # Find Major/Minor < LXC version 3
    MAJOR=$(lxc version | awk -F. '{print $1}')
    MINOR=$(lxc version | awk -F. '{print $2}')
fi

if [ $MAJOR -eq 3 ]
then
    sed 's/lxc.aa_profile/lxc.apparmor.profile/g' -i maas-profile
fi

# Create container
echo "Creating container $CONTAINER"
lxc profile create maas-profile 2> /dev/null
lxc profile edit maas-profile < maas-profile
if [ $MAJOR -eq 3 ]
then
    # v3 expects pool name, use default
    lxc launch ubuntu:18.04 $CONTAINER -p maas-profile -s default
elif [ $MAJOR -eq 2 && $MINOR -eq 0 ]
then
    lxc launch ubuntu:18.04 $CONTAINER -p maas-profile 
else
    lxc profile create root-device 2> /dev/null
    lxc profile edit root-device < root-device
    lxc launch ubuntu:18.04 $CONTAINER -p maas-profile -p root-device
fi

echo "Sleeping to wait for IP"
sleep 10

# Setup LXD forward for pxe requests
IPADDRESS=$(lxc info $CONTAINER | awk -F"[: \t]+" '/eth0:.*inet[^6]/ {print $4}')

if lxc network set lxdbr0 raw.dnsmasq dhcp-boot=pxelinux.0,$CONTAINER,$IPADDRESS
then
    echo "pxe redirect setup for IP $IPADDRESS"
    
    if snap services | grep -e '^lxd.daemon\s\+enabled\s\+active' > /dev/null 2>&1
    then
        # Snap-based LXD.  This appears to be safe.  (Thanks csanders)
        systemctl reload snap.lxd.daemon
    else
        # Assume non-snap LXD
        systemctl restart lxd.service
    fi
else
    echo "No lxdbr0 found, unable to setup pxe redirect"
    echo "Manual config of raw.dnsmasq for pxe redirect needs to be done"
fi

echo "MAAS will become available at: http://$IPADDRESS:5240/MAAS with user/password admin/admin"
