#!/bin/bash
# Automatically create 3 partitions, manually create final partition
# Part 1: MBR Boot partition for grub bios boot
# Part 2: EXT4 Partition for base OS
# Part 3: 1G OSD Journal
# Part 4: Variable size OSD with remainer
# The curtin preseed will set GPT labels on partition 1,3,4

MACHINE=$1
maas admin block-device set-boot-disk $MACHINE sdb
maas admin partitions create $MACHINE sda size=5M
maas admin partitions create $MACHINE sda size=100G
maas admin partitions create $MACHINE sda size=1G
# maas admin partitions create $MACHINE sda size=300T
maas admin block-device update $MACHINE sda partition_table_type=gpt
maas admin partition format $MACHINE sda sda-part2 fstype=ext4
maas admin partition mount $MACHINE sda sda-part2 mount_point=/

maas admin block-device set-boot-disk $MACHINE sda
maas admin partitions create $MACHINE sdb size=5M
maas admin partitions create $MACHINE sdb size=100G
maas admin partitions create $MACHINE sdb size=1G
# maas admin partitions create $MACHINE sdb size=300T
maas admin block-device update $MACHINE sdb partition_table_type=gpt
maas admin partition format $MACHINE sdb sdb-part2 fstype=ext4
