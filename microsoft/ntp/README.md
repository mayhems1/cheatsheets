# Cheat Sheet Microsoft NTP Server

## basic commands

```bash
# To check NTP configuration, run:
w32tm /query /configuration

# To check NTP server list, type:
w32tm /query /peers

# To force NTP server synchronization, run:
w32tm /resync /nowait

# Use the command below to show the source of the NTP time:
w32tm /query /source

# To show the status of NTP service, type:
w32tm /query /status
```

## NTP Server

```bash
# Enable NTP Server
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\w32time\TimeProviders\NtpServer" -Name "Enabled" -Value 1

# Create the AnnounceFlags 5
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\services\W32Time\Config" -Name "AnnounceFlags" -Value 5

# Restart NTP Server
Restart-Service w32Time
```

## Sources

- [How to Set NTP Server on Windows Server?](https://operavps.com/docs/set-ntp-server-on-windows-server/)
- [Configure NTP Server in Windows Server 2019/2022](https://computingforgeeks.com/how-to-configure-ntp-server-in-windows-server/)
- [How to configure an authoritative time server in Windows Server](https://learn.microsoft.com/en-us/troubleshoot/windows-server/identity/configure-authoritative-time-server)
