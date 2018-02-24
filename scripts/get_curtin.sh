#!/bin/bash
MACHINE=$1

maas maas-root machine get-curtin-config $MACHINE
