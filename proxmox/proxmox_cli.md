# Cheat sheet Proxmox CLI commands

## Get status of a cluster

```bash
pvesh get /nodes

pvecm status

pvecm nodes

# Overview of all resources in the cluster:

pvesh get /cluster/resources

# Status for all KVM VMs on a specific node:

pvesh get /nodes/<NODENAME>/qemu

# or a single VM:

pvesh get /nodes/<NODENAME>/qemu/<VMID>/status/current
```

## Get all VM in cluster

```bash
pvesh get /cluster/resources --type vm

# or
cat /etc/pve/.vmlist

# or you simply scan all dirs in /etc/pve/nodes/

## get list VMs
pvesh get /nodes/proxmox1/qemu/ 2>/dev/null | awk '{print $4}' | egrep -v '^$|vmid'
```

## Proxmox and KVM Commands

```bash
# List all your KVM machines
qm list

# See how much memory your machine 101 has: 
qm config 101 | grep ^memory

# List the memory setting of a kvm: 
qm config 101 | grep ^memory

# unlock kvm: 
qm unlock 101

# Restore a QemuServer VM to VM 101: 
qmrestore /mnt/backup/vzdump-qemu-200.vma 101

# Get a quick overview on how fast your system is:
pveperf

#Verify the subscription status of your hardware node: 
pvesubscription get

# Start a backup of machine 101:
vzdump 101 -compress lzo

# PVE Cluster Manager - see "man pvecm" for details.

# Restart every single Proxmox services: 
service pve-cluster restart && service pvedaemon restart && service pvestatd restart && service pveproxy restart

# Proxmox VE version info - Print version information for Proxmox VE packages.: 
pveversion

# Find next free VM ID: 
pvesh get /cluster/nextid

# View sum of memory allocated to VMs and CTs:
grep -R memory /etc/pve/local | awk '{sum += $NF } END {print sum;}'

# View sorted list of VMs like vmid proxmox_host type: 
cat /etc/pve/.vmlist | grep node | tr -d '":,'| awk '{print $1" "$4" "$6 }' | sort -n | column -t

# View sorted list of vmid:
cat /etc/pve/.vmlist | grep node | cut -d '"' -f2 | sort -n
```

## Migrate VMs from proxmox1 to proxmox2 using qm

```bash
# Get VMs' ID
qm list | awk '{print $1}' | grep -v VMID > VMs_"$HOSTNAME"

# Migrate VMs from proxmox1 to proxmox2
cat VMs_"$HOSTNAME" | while read VMID; do sudo qm migrate $VMID proxmox2 -online; done

# Migrate VMs from proxmox2 to proxmox1
# copy file VMs_"$HOSTNAME" from proxmox1 to proxmox2
scp VMs_"$HOSTNAME" proxmox2:~/

cat VMs_"$HOSTNAME" | while read VMID; do sudo qm migrate $VMID proxmox1 -online; done
```

## Migrate VMs from proxmox1 to proxmox2 using pvesh

```bash
# exmaple
pvesh create /nodes/{node}/qemu/{vmid}/migrate

# from proxmox1 to proxmox2 VM 100
pvesh create /nodes/proxmox1/qemu/100/migrate -target proxmox2 -online true

# mass migrate

for vm in `pvesh get /nodes/proxmox1/qemu/ 2>/dev/null | awk '{print $4}' | egrep -v '^$|vmid'`; do pvesh create /nodes/proxmox1/qemu/$vm/migrate -target proxmox2 -online true; done
```

## Create snapshot for VM

```bash
pvesh create /nodes/proxmox1/qemu/100/snapshot -snapname "before_update" -description "before_apply_command" -vmstate true
pvesh create /nodes/proxmox2/qemu/200/snapshot -snapname "before_update" -description "before_apply_command" -vmstate true
pvesh create /nodes/proxmox3/qemu/300/snapshot -snapname "before_update" -description "before_apply_command" -vmstate true
```
