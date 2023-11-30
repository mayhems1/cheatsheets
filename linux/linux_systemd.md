# Examples of systemd unit

## Env

```conf
[Service]
# Client Env Vars
Environment=ETCD_CA_FILE=/path/to/CA.pem
Environment=ETCD_CERT_FILE=/path/to/server.crt
Environment=ETCD_KEY_FILE=/path/to/server.key
```

## Use full commands

```bash
# list units
systemctl list-unit-files
systemctl list-unit-files --state=enabled
systemctl list-unit-files --state=failed

systemctl status <service>
systemctl start <service>
systemctl stop <service>

systemctl enable --now <service>
systemctl disable --now <service>

systemctl cat <service>

systemctl --type=service --state=running
systemctl --type=service --state=failed
```

## Remove systemd service

```bash
systemctl stop [servicename]
systemctl disable [servicename]
rm /etc/systemd/system/[servicename]
rm /etc/systemd/system/[servicename] # and symlinks that might be related
rm /usr/lib/systemd/system/[servicename] 
rm /usr/lib/systemd/system/[servicename] # and symlinks that might be related
systemctl daemon-reload
systemctl reset-failed

# or at an old system
chkconfig [servicename] off
chkconfig [servicename] on

# or
service=YOUR_SERVICE_NAME; systemctl stop $service && systemctl disable $service && rm /etc/systemd/system/$service &&  systemctl daemon-reload && systemctl reset-failed
```

## Sources

- [How to list all enabled services from systemctl?](https://askubuntu.com/questions/795226/how-to-list-all-enabled-services-from-systemctl)
- [How to remove systemd services](https://superuser.com/questions/513159/how-to-remove-systemd-services)
- [How to List Linux Services With systemctl](https://www.howtogeek.com/839285/how-to-list-linux-services-with-systemctl/)
