# Multipath cheat sheet

## List storage devices

```bash
lshw -class disk

lshw -class disk | grep <disk_name> -A 5 -B

# or
lsblk -o KNAME,TYPE,SIZE,MODEL
```

## Install

```bash
apt-get install multipath-tools lsscsi
modprobe dm_multipath
```

## configure

```bash
# get wwid of disks
lsscsi --scsi_id
# or
/lib/udev/scsi_id -g -u -d /dev/sdc

# repeat for each wwid found from prev command
multipath -a 35000c500d87d8953

# check
multipath -ll
```

```conf
defaults {
    polling_interval        2
    path_selector           "round-robin 0"
    path_grouping_policy    multibus
    uid_attribute           ID_SERIAL
    rr_min_io               100
    failback                immediate
    no_path_retry           queue
    user_friendly_names     yes
}

blacklist {
    wwid .*
}

blacklist_exceptions {
    # use the same wwid from prev steps
    wwid "35000c500d87d8953"
}
```

### Restart the service

```bash
systemctl restart multipath-tools.service
```

### Show device mapper logical volumes or Debug info

```bash
# Show device mapper logical volumes setup or
dmsetup ls --tree

# Show multipath status (default verbosity):
multipath -v2

# Show multipath debug info:
multipath -v3
```

## How to extend file system when multipathing is used and in case it is possible to grow physical volume on SAN side?

```bash
multipath -ll

echo 1 > /sys/block/sdU/device/rescan
echo 1 > /sys/block/sdV/device/rescan
echo 1 > /sys/block/sdX/device/rescan
echo 1 > /sys/block/sdZ/device/rescan

multipathd -k "resize map mpathX"

pvresize /dev/mapper/mpathX

lvextend -L+20G vg0/lv0

# or

# resize partion

fdisk /dev/mapper/mpathX

resize2fs /dev/mapper/mpathX

# check
df -h
```

## Sources

- [How to setup multipathing on Proxmox VE?](https://forum.proxmox.com/threads/how-to-setup-multipathing-on-proxmox-ve.108418/)
- [Device mapper multipathing - introduction](https://ubuntu.com/server/docs/device-mapper-multipathing-introduction)
- [Installing multipath tools on PVE Cluster with shared storage](https://gist.github.com/mrpeardotnet/547aecb041dbbcfa8334eb7ffb81d784)
- [Proxmox7 and ISCSI Storage + multipath](https://forum.proxmox.com/threads/proxmox7-and-iscsi-storage-multipath.96832/)
- [How To List Disks on Linux](https://devconnected.com/how-to-list-disks-on-linux/)
- [How to extend GFS(2) file system when multipathing is used and in case it is possible to grow physical volume on SAN side?](https://access.redhat.com/solutions/171363)
- [How to Scan Newly added Disks in Linux Easily](https://www.learnitguide.net/2016/02/how-to-scan-newly-added-disks-in-linux.html#google_vignette)
- [Chapter 34. Scanning Storage Interconnects](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/storage_administration_guide/scanning-storage-interconnects)
- [Chapter 31. Adding a Storage Device or Path](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/storage_administration_guide/adding_storage-device-or-path)
- [3.2. Ignoring Local Disks when Generating Multipath Devices](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/dm_multipath/ignore_localdisk_procedure)
- [DM Multipath](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/5/html-single/dm_multipath/index)
- [Chapter 3. Setting Up DM-Multipath](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/dm_multipath/mpio_setup)
- [DM Multipath Configuration and Administration](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/dm_multipath/index)
- [How to configure Device Mapper Multipath in RHEL 6, 7,8 & 9?](https://access.redhat.com/solutions/66281)
