#!/bin/bash -e
which juju || (echo "juju is not installed: snap install --classic juju"; exit 1)
CONTAINER=$1
IPADDRESS=$(lxc info $CONTAINER | awk -F"[: \t]+" '/eth0:.*inet[^6]/ {print $4}')
APIKEY=$(lxc exec $CONTAINER -- maas apikey --username admin)
TMPFILE=$(mktemp)
cat << EOF > $TMPFILE
clouds:         # clouds key is required.
  maas-cloud:   # cloud's name
    type: maas
    auth-types: [oauth1]
    endpoint: http://__IPADDRESS__:5240/MAAS
EOF
sed -i s/__IPADDRESS__/$IPADDRESS/g $TMPFILE
juju add-cloud --local maas-cloud $TMPFILE

cat << EOF > $TMPFILE
credentials:
  maas-cloud:
    admin:
      auth-type: oauth1
      maas-oauth: __APIKEY__
EOF
sed -i s/__APIKEY__/$APIKEY/g $TMPFILE
juju add-credential maas-cloud -f $TMPFILE
rm $TMPFILE
