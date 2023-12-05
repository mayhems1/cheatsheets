# Cheat sheets update Proxmox certs

## Update certs

```bash
pvecm updatecerts --force

systemctl stop pve-cluster
systemctl stop corosync

systemctl restart pve-cluster.service pvestatd.service pveproxy.service pvedaemon.service

# check certs
openssl x509 -text -in /etc/pve/nodes/proxmox1/pve-ssl.pem

pmxcfs -l

# other drafts
rm /etc/pve/corosync.conf
rm -r /etc/corosync/*

killall pmxcfs
systemctl start pve-cluster
```
