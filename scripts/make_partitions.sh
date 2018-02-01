#!/bin/bash
# Part 1: MBR Boot partition for grub bios boot
# Part 2: Partition for base OS (Setup raid on sda/sdb)

MACHINE=$1
# # Clear the partitions
for partid in $(maas maas-root partitions read $MACHINE sda |jq '.[] | .id'); do
  maas maas-root partition delete $MACHINE nvme0n1 $partid
done

for partid in $(maas maas-root partitions read $MACHINE sdb |jq '.[] | .id'); do
  maas maas-root partition delete $MACHINE nvme0n1 $partid
done

# Setup sda
maas admin block-device set-boot-disk $MACHINE sdb
maas admin partitions create $MACHINE sda size=5M
maas admin partitions create $MACHINE sda size=100G
maas admin block-device update $MACHINE sda partition_table_type=gpt

# Setup sdb
maas admin block-device set-boot-disk $MACHINE sda
maas admin partitions create $MACHINE sdb size=5M
maas admin partitions create $MACHINE sdb size=100G
maas admin block-device update $MACHINE sdb partition_table_type=gpt
