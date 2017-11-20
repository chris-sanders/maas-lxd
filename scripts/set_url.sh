#!/bin/bash

CONTAINER=$1

IPADDRESS=$(lxc info $CONTAINER | awk -F"[: \t]+" '/.*br0:.*inet[^6]/ {print $4}')

echo "Setting region and rack to http://$IPADDRESS:5240/MAAS"
lxc exec $CONTAINER -- sudo maas-region local_config_set --maas-url="http://$IPADDRESS:5240/MAAS"
lxc exec $CONTAINER -- sudo maas-rack config --region-url="http://$IPADDRESS:5240/MAAS"
