#!/bin/bash

MAASURL=$1

sudo maas-region local_config_set --maas-url="$MAASURL"
sudo maas-rack config --region-url="$MAASURL"
