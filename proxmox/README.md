# Proxmox cheatsheets

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
