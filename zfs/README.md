# ZFS cheat sheet

[Status of a pool](#Status of a pool)

## info

### Status of a pool

```bash
zpool status -v 

zpool status -v rpool

# with device name
zpool status -vL rpool
```

### How to add a drive to a ZFS mirror

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

### ZFS Data Scrubbing

```bash
# start
zpool scrub rpool

# stop
zpool scrub -s rpool
```

### Autoextend ZFS pool

```bash
zpool set autoexpand=on rpool
watch zpool status -v
zpool status -v
zpool online -e rpool /dev/sdb2
zpool online -e rpool /dev/sda2
zpool set autoexpand=off rpool
zpool status
```

### Scrub

```bash
zpool scrub rpool
```

### Change disk in ZFS

```bash
#### sda

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

### Links

<https://edmondscommerce.github.io/replacing-failed-drive-in-zfs-zpool-on-proxmox/>
