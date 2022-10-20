# ZFS cheat sheet

## Table of Contents

* [ZFS Basic Terms](#zfs-basic-terms)
* [Status of a pool](#status-of-a-pool)
* [How to add a drive to a ZFS mirror](#how-to-add-a-drive-to-a-zfs-mirror)
* [How to remove a drive from a pool](#how-to-remove-a-drive-from-a-pool)
* [ZFS Data Scrubbing](#zfs-data-scrubbing)
* [Autoextend ZFS pool](#autoextend-zfs-pool)
* [Change disk in ZFS](#change-disk-in-zfs)
* [Links](#links)

## ZFS Basic Terms

* **Volume** - block device
* **File system** - standard POSIX FS layer
* **Snapshot** - read-only copy of a FS
* **Clone** - read-write copy of a FS
* **Dataset** - any of the 4 terms above
* **Pool** - logical set of vdevs
* **VDev** - block storage (redundancy done here)

Type of raid levels are supported in ZFS

* Striped Vdev’s (RAID0)
* Mirrored Vdev’s (RAID1)
* Striped Mirrored Vdev’s (RAID10)
* RAIDZ (RAID5-Single parity)
* RAIDZ2 (RAID6-Double parity)
* RAIDZ3 (Triple Parity)

## Create a simple zpool

```bash
# Create
zpool create szpool c1t3d0

# To create a mirror zpool:
zpool create mzpool mirror c1t5d0 c1t6d0

# To Create a raidz zpool:
zpool create rzpool raidz c1t2d0 c1t1d0 c1t8d0

# If you want to create dataset with different mount point, use the following command.
zpool create -m /export/zfs home c1t0d0
```

## Status of a pool

```bash
zpool status -v 

zpool status -v rpool

# with device name
zpool status -vL rpool

# List
zpool list rpool
```

## How to add a drive to a ZFS mirror

```bash

zpool attach [poolname] [original drive to be mirrored] [new drive]

# An example
zpool attach rpool /dev/sda /dev/sdb
```

### How to remove a drive from a pool

```bash

zpool offline rpool /dev/sdb
zpool remove rpool /dev/sdb
# or
zpool detach rpool /dev/sdb
```

## ZFS Data Scrubbing

```bash
# start
zpool scrub rpool

# stop
zpool scrub -s rpool
```

## Autoextend ZFS pool

```bash
zpool set autoexpand=on rpool
watch zpool status -v
zpool status -v
zpool online -e rpool /dev/sdb2
zpool online -e rpool /dev/sda2
zpool set autoexpand=off rpool
zpool status
```

## Change disk in ZFS

```bash
# Exmaple name of a disk is sda
# Offline sda
zpool status -v
zpool offline rpool /dev/sda2
smartctl -a /dev/sda
hdparm -I /dev/sda

# Add new sda
sgdisk -R /dev/sda /dev/sdb
sgdisk -G /dev/sda
fdisk -l
dd if=/dev/sdb1 of=/dev/sda1
zpool replace rpool /dev/sda2 /dev/sda2
zpool status -v

# Exmaple name of a disk is sda
# offline sdb
zpool status -v
zpool offline rpool /dev/sdb2

# Add new sdb
sgdisk -R /dev/sdb /dev/sda
sgdisk -G /dev/sdb
fdisk -l
dd if=/dev/sda1 of=/dev/sdb1
zpool replace rpool /dev/sdb2 /dev/sdb2
zpool status -v
```

## Statistics

```bash
arcstat
```

## Tune zfs_arc_min and zfs_arc_max

```bash
# Example for Proxmox

# Runtime 
# 8Gb
echo "$[8 * 1024*1024*1024 - 1]" >/sys/module/zfs/parameters/zfs_arc_min
echo "$[8 * 1024*1024*1024]" >/sys/module/zfs/parameters/zfs_arc_max

# Permanent
cat /etc/modprobe.d/zfs.conf
options zfs zfs_arc_min=8589934591
options zfs zfs_arc_max=8589934592

# Update initramfs images
update-initramfs -u
```

## Links

* [Replacing Failed Drive in Zfs Zpool (on Proxmox)](https://edmondscommerce.github.io/replacing-failed-drive-in-zfs-zpool-on-proxmox/)
* [Replacing ZFS system drives in Proxmox](https://www.oxcrag.net/2018/09/02/replacing-zfs-system-drives-in-proxmox/)
* [ZFS: Tips and Tricks](https://pve.proxmox.com/wiki/ZFS:_Tips_and_Tricks#Replacing_a_failed_disk_in_the_root_pool)
