#!/bin/bash
MACHINE=$1
maas admin partitions create $MACHINE sda size=200M
maas admin partitions create $MACHINE sdb size=200M
maas admin partitions create $MACHINE sda size=100G
maas admin partitions create $MACHINE sdb size=100G
maas admin partition format $MACHINE sda sda-part2 fstype=ext4
maas admin partition format $MACHINE sdb sdb-part2 fstype=ext4
maas admin partition mount $MACHINE sda sda-part2 mount_point=/
