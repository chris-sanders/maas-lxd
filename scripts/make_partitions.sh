#!/bin/bash
# Part 1: MBR Boot partition for grub bios boot (see maas preseed)
# Part 2: Partition for base OS (Setup raid on sda/sdb)

MACHINE=$1
# # Clear the partitions
for partid in $(maas maas-root partitions read $MACHINE sda |jq '.[] | .id'); do
  maas maas-root partition delete $MACHINE sda $partid
done

for partid in $(maas maas-root partitions read $MACHINE sdb |jq '.[] | .id'); do
  maas maas-root partition delete $MACHINE sdb $partid
done

# https://bugs.launchpad.net/maas/+bug/1712505
maas maas-root block-device set-boot-disk $MACHINE sdc
maas maas-root partitions create $MACHINE sdc size=5M

# Setup sda
# maas maas-root block-device set-boot-disk $MACHINE sdb
maas maas-root partitions create $MACHINE sda size=5M
maas maas-root partitions create $MACHINE sda size=200G
# maas maas-root block-device update $MACHINE sda partition_table_type=gpt

# Setup sdb
# maas maas-root block-device set-boot-disk $MACHINE sda
maas maas-root partitions create $MACHINE sdb size=5M
maas maas-root partitions create $MACHINE sdb size=200G
# maas maas-root block-device update $MACHINE sdb partition_table_type=gpt
