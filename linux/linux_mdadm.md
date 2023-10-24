# Linux mdadm RAID cheat sheeat

## Create new a RAID

```bash
# mdadm RAID0
sudo mdadm --create --verbose /dev/md0 --level=0 --raid-devices=2 /dev/sda /dev/sdb1

# mdadm RAID1
mdadm --create /dev/md1 --level=mirror --raid-devices=2 /dev/sd[cd]1
mdadm --detail --scan --verbose | tee -a /etc/mdadm/mdadm.conf
wipefs -a -f /dev/md1
mkfs.ext4 /dev/md1

# Create mdadm raid for Proxmox

apt install mdadm
fdisk -l
wipefs -af /dev/sdc1 /dev/sdd1
mdadm --create --verbose /dev/md0 --level=1 --raid-devices=2 /dev/sdc1 /dev/sdd1
pvcreate /dev/md0 -y
vgcreate vg0 /dev/md0 -y
lvcreate -L 500G -n proxmox1 vg0 -y
lvconvert --type thin-pool vg0/proxmox1 -y
lvextend --poolmetadatasize 1G vg0/proxmox1 -y
lvresize -rl +100%FREE /dev/mapper/vg0-proxmox1 -y
cat /proc/mdstat
update-initramfs -u
reboot
```

## Rename mdadm raid

```bash
# Rename mdadm
mdadm --stop /dev/md127
mdadm --remove /dev/md127
mdadm --assemble /dev/md2 /dev/sd[abcdefghijkl]3 --update=name
```

## Backup mdadm configuration

```bash
mdadm --detail --scan | tee -a mdadm.conf
```

## Replace a failed disk at mdadm

```bash
mdadm --manage /dev/md0 --fail /dev/sda1
mdadm --manage /dev/md0 --remove /dev/sda1
mdadm --manage /dev/md0 --add /dev/sda1
mdadm --detail /dev/md0
cat /proc/mdstat
```

### Optional copy mbr

```bash
# copy mbr
dd if=/dev/sdb of=sdb.img bs=512 count=1
```

## Resize mdadm raid

```bash
# Resize mdadm raid1
# resize partions
fdisk /dev/sda
fdisk /dev/sda
# resize mdadm
mdadm --grow /dev/md0 --size=max
# resize filesystem
resize2fs /dev/md0
```

## Import existing RAID devices

```bash
mdadm --assemble --scan
```

I discovered that I first had to remove /etc/mdadm.conf, before running the “assemble” command above, after which my device was successfully discovered.

Then I needed to recreate /etc/mdadm.conf by running

```bash
mdadm --detail --scan >> /etc/mdadm.conf
```

## How to Remove a Drive From a RAID Array

```bash
sudo mdadm --detail /dev/md1

# unmoun mount point
sudo umount /media/myraid

# stop an array
sudo mdadm --stop /dev/md1

# Remove the Drive using mdadm
sudo mdadm --fail /dev/sde --remove /dev/sde

# Zero the Superblock on the Removed Member Drive
sudo mdadm --zero-superblock /dev/sde

# Change the Number of Devices for the RAID Array
sudo mdadm --add /dev/md1 /dev/sdh <--- /dev/sdh is the new drive to add
sudo mdadm --grow --raid-devices=5
```

## Get information about RAID devices

```bash
sudo mdadm -D /dev/md0
```

## Sources

- [How to Remove a Drive From a RAID Array](https://delightlylinux.wordpress.com/2020/12/22/how-to-remove-a-drive-from-a-raid-array/)
- [Importing existing RAID devices into new Linux installation](https://www.funkypenguin.co.nz/note/importing-existing-raid-devices-new-linux-installation/)
- [https://www.digitalocean.com/community/tutorials/how-to-manage-raid-arrays-with-mdadm-on-ubuntu-16-04](How To Manage RAID Arrays with mdadm on Ubuntu 16.04)
- [https://raid.wiki.kernel.org/index.php/RAID_setup](RAID setup)
