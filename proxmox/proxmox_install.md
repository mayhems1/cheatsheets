# Cheat sheets info about Proxmox

## Useful Links

- [Proxmox clustering and nested virtualization](https://icicimov.github.io/blog/virtualization/Proxmox-clustering-and-nested-virtualization/)
- [Rootmanual:Proxmox](https://datorhandbok.lysator.liu.se/index.php/Rootmanual:Proxmox)

### Proxmox with Ceph and Storage

- [Ceph Storage on Proxmox](https://www.jamescoyle.net/how-to/1213-ceph-storage-on-proxmox)
- [Small Scale Ceph Replicated Storage](https://www.jamescoyle.net/tag/ha)
- [Proxmox Storage](https://pve.proxmox.com/wiki/Storage)

### Update Proxmox

- [How to upgrade Proxmox Virtual Environment 5.4.x](https://www.yinfor.com/2019/04/how-to-upgrade-proxmox-virtual-environment-5-4-x.html)
- [Proxmox VE 5.4 released!](https://forum.proxmox.com/threads/proxmox-ve-5-4-released.53298/)
- [How to update Proxmox from 5.1 to 5.4?](https://www.reddit.com/r/Proxmox/comments/a615u5/how_to_update_proxmox_from_51_to_54/)
- [PVE CLuster upgrading/updating guide?](https://forum.proxmox.com/threads/pve-cluster-upgrading-updating-guide.6070/)

#### Here is a simple guide to show you how to upgrade Proxmox VE 5.3x to v5.4x

1. Edit /etc/apt/sources.list.d/pve-enterprise.list

Comment or delete the following line.

```conf
deb https://enterprise.proxmox.com/debian/pve stretch pve-enterprise
```

2. Edit /etc/apt/sources.list

Add following line at the end of the file.

```conf
deb http://download.proxmox.com/debian stretch pve-no-subscription
```

3. Now, it is OK to do the update.

```bash
apt update
apt upgrade
apt dist-upgrade
```

### Proxmox config VM path

/etc/pve/nodes/proxmox1/qemu-server/100.conf
