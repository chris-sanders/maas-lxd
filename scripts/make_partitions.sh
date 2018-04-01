#!/bin/bash
# Part 1: MBR Boot partition for grub bios boot (see maas preseed)
# Part 2: Partition for base OS (Setup raid on sda/sdb)

MACHINE=$1
# # Clear the partitions
for partid in $(maas admin partitions read $MACHINE sda |jq '.[] | .id'); do
  maas admin partition delete $MACHINE sda $partid
done

for partid in $(maas admin partitions read $MACHINE sdb |jq '.[] | .id'); do
  maas admin partition delete $MACHINE sdb $partid
done

# https://bugs.launchpad.net/maas/+bug/1712505
maas admin block-device set-boot-disk $MACHINE sdc
maas admin partitions create $MACHINE sdc size=50M

# Setup sda
# maas admin block-device set-boot-disk $MACHINE sdb
maas admin partitions create $MACHINE sda size=5M
maas admin partitions create $MACHINE sda size=500G
# maas admin block-device update $MACHINE sda partition_table_type=gpt

# Setup sdb
# maas admin block-device set-boot-disk $MACHINE sda
maas admin partitions create $MACHINE sdb size=5M
maas admin partitions create $MACHINE sdb size=500G
# maas admin block-device update $MACHINE sdb partition_table_type=gpt
