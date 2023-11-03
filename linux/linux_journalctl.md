# Journalctl

## Use full commands

```bash
# Permitting a user to view the system logs
sudo usermod -a -G systemd-journal <user>

# journalctl with grep, awk, sed and etc.
journalctl --no-pager

# last 10
journalctl -n 10

# incoming log messages in real-time
journalctl -f
journalctl -f -n 50

# json
journalctl -o json -n 10 --no-pager
journalctl -o json-pretty -n 10 --no-pager

# Filtering the journal by boot session
journalctl -b
journalctl --list-boots

# same as journalctl -b
journalctl -b 0

# output logs from the previous boot session
journalctl -b -1

# Showing logs within a time range
journalctl --since 'today'
journalctl --since '2023-10-15 21:00:00' --until '2023-10-15 22:00:00'

# Filtering journal entries by service
journalctl -u sshd.service -n 10 -f

```

## How to clear Journalctl

```bash
# Cleaning up old journal entries
journalctl --disk-usage

# Retain only the past two days:

journalctl --vacuum-time=2d

# Retain only the past 500 MB:

journalctl --vacuum-size=500M
```

## Keep system journals after a reboot

```bash
sudo mkdir /var/log/journal

sudo vim /etc/systemd/journald.conf

# [Journal]
# Storage=persistent

systemctl restart systemd-journald

ls /var/log/journal
```

## Links

- [How to clear journalctl](https://unix.stackexchange.com/questions/139513/how-to-clear-journalctl)
- [How to View and Manage Systemd Logs with Journalctl](https://betterstack.com/community/guides/logging/how-to-control-journald-with-journalctl/)
- [How to configure your system to preserve system logs after a reboot](https://www.redhat.com/sysadmin/store-linux-system-journals)
- [Enable persistent storage for the systemd journal log](https://gist.github.com/JPvRiel/b7c185833da32631fa6ce65b40836887)
