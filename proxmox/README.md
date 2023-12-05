# Proxmox cheatsheets

## Proxmox server maintenance tasks

- [Cheat sheet how to replace disk in ZFS pool](./proxmox_replace_disk_zfs.md)
- [Cheat sheet how to use Proxmox cli](./proxmox_cli.md)
- [Cheat sheets update Proxmox certs](./proxmox_update_certs.md)

## Check status corosync

```bash
# get status
corosync-quorumtool -a
corosync-cfgtool -s
corosync-quorumtool -a
corosync-quorumtool -V

# reload corosync.conf do at working node
corosync-cfgtool -R
```

## Update kernel

```bash
apt install pve-kernel-5.19
```

## Import an OVA VM to Proxmox

```bash
tar xvf image.ova
qm image.ova <ID new VM> ./image.ovf <datastore name> --format qcow2

# Example
qm kaspersky.ova 100 ./kaspersky.ovf local --format qcow2
```

## Sources

- [VM stuck/freeze after live migration](https://forum.proxmox.com/threads/vm-stuck-freeze-after-live-migration.114867/)
- [Is issue known? VMs can stuck after live migration](https://forum.proxmox.com/threads/is-issue-known-vms-can-stuck-after-live-migration.116315/#post-503414)
- [Service daemons](https://pve.proxmox.com/wiki/Service_daemons#pvedaemon)
- [Import OVA to Proxmox | An Introduction](https://bobcares.com/blog/proxmox-import-ova/)
- [Importing a Virtual Machine OVA into ProxMox](https://i12bretro.github.io/tutorials/0387.html)
- [Proxmox wiki](https://pve.proxmox.com/wiki/Main_Page)
- [Proxmox VE Documentation](https://pve.proxmox.com/pve-docs/)
- [Host System Administration](https://pve.proxmox.com/wiki/Host_System_Administration)
- [Proxmox VE API](https://pve.proxmox.com/wiki/Proxmox_VE_API)
- [PROXMOX - AUTOMATIC PROVISIONING](http://rustyautopsy.github.io/rabbitholes/2014/10/21/vmcreate/)
- [PveSh examples](http://vasilisc.com/pvesh-examples)
- [Mass storage migration?](https://forum.proxmox.com/threads/mass-storage-migration.34259/)
- [Proxmox API docs](https://pve.proxmox.com/pve-docs/api-viewer/index.html)
- [Reboot in command-line of virtual machine Proxmox VE.](http://vasilisc.com/restart-virtual-machine-proxmox-ve)
- [Moving disk image from one KVM machine to another](https://pve.proxmox.com/wiki/Moving_disk_image_from_one_KVM_machine_to_another)
- [List of Proxmox important configuration files directory](https://www.hungred.com/how-to/list-of-proxmox-important-configuration-files-directory/)
- [Proxmox Cookbook](https://www.packtpub.com/virtualization-and-cloud/proxmox-cookbook)
- [Mastering Proxmox](https://www.packtpub.com/virtualization-and-cloud/mastering-proxmox)
- [Proxmox High Availability](https://www.packtpub.com/virtualization-and-cloud/proxmox-high-availability)
- [Virtualization using Proxmox VE](https://medium.com/btech-engineering/virtualization-using-proxmox-ve-2e69b25f4ecb)
- [PROXMOX VE ADMINISTRATION GUIDE 8](https://pve.proxmox.com/pve-docs/pve-admin-guide.pdf)
- [List of Useful Proxmox Command](https://www.hungred.com/tag/proxmox/)
- [List of Useful Proxmox Command](https://www.hungred.com/how-to/server/list-of-useful-proxmox-command/)
- [Proxmox destroyed one of my SSDs](https://www.reddit.com/r/Proxmox/comments/117jr2s/proxmox_destroyed_one_of_my_ssds/)
