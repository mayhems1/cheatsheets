# Cheat sheet how to replace disk in ZFS pool

## Replace disk at ZFS rpool

```bash
# For exmaple change sda disk in zfs rpool

# Check disk info
lsscsi -g
zpool status -v

# offline sda
zpool offline rpool /dev/sda3

# copy partion to file and restore
sgdisk --backup=sda_table /dev/sda

# poweroff the server and replace the disk and boot from second disk in zfs rpool

sgdisk --load-backup=sda_table /dev/sda
# or copy from second drive in zfs rpool
sgdisk -R /dev/sda /dev/sdb
sgdisk -G /dev/sda

# check
fdisk -l

# Copy boot partion
dd if=/dev/sda1 of=/dev/sdb1

# Install efi boot
pve-efiboot-tool format /dev/sda2
pve-efiboot-tool init /dev/sda2

# replace disk in zfs rpool
zpool replace rpool /dev/sda3 /dev/sda3

# check status
zpool status -v

# or watching

watch zpool status -v
```
