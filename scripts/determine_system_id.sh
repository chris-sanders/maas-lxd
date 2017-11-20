#!/bin/bash
HOSTNAME=$1
SYSTEM_ID=$(maas admin nodes read hostname=$HOSTNAME | grep system_id -m 1 | cut -d '"' -f 4)
echo "$SYSTEM_ID"
