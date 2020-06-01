#!/bin/bash
CONTAINER=$1
shift
if [ "$#" -eq 0 ]; then
    POD_SPECS="cores=2 memory=2048 storage=20"
else
    POD_SPECS="$@"
fi

IPADDRESS=$(lxc info $CONTAINER | awk -F"[: \t]+" '/eth0:.*inet[^6]/ {print $4}')

APIKEY=$(lxc exec $CONTAINER -- maas apikey --username admin)
echo "Logging into MAAS"
lxc exec $CONTAINER -- maas login admin http://$IPADDRESS:5240/MAAS $APIKEY

echo "Creating POD"
lxc exec $CONTAINER -- maas admin pods create type=virsh power_address=qemu:///system

echo "Creating Machine(s) with specs: $POD_SPECS"
lxc exec $CONTAINER -- maas admin pod compose 1 $POD_SPECS
