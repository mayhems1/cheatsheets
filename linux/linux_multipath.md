# Multipath

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

## Sources

- [How to setup multipathing on Proxmox VE?](https://forum.proxmox.com/threads/how-to-setup-multipathing-on-proxmox-ve.108418/)
- [Device mapper multipathing - introduction](https://ubuntu.com/server/docs/device-mapper-multipathing-introduction)
- [Installing multipath tools on PVE Cluster with shared storage](https://gist.github.com/mrpeardotnet/547aecb041dbbcfa8334eb7ffb81d784)
- [Proxmox7 and ISCSI Storage + multipath](https://forum.proxmox.com/threads/proxmox7-and-iscsi-storage-multipath.96832/)
- [How To List Disks on Linux](https://devconnected.com/how-to-list-disks-on-linux/)
