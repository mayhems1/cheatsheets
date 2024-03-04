# Cheat sheets NTP

## NTPD deamon

/etc/ntp.conf

```conf
# example a server
server ntplocal.example.com prefer
server timeserver.example.org
server ntp2a.example.net

# restrict access
restrict        192.168.0.2     noquery notrap
restrict        192.168.0.5     noquery notrap

restrict 192.168.0.0 mask 255.255.0.0 nomodify notrap
```

LOG NTP - /var/log/ntpstats/ntp

```bash
systemctl status ntp

systemctl restart ntp


```

## Check NTP sync

```bash
ntpq -pn

ntpq -cas

watch ntpq -cpe -cas

# check diff local time and a server
ntpdate -q <IP> <IP> <IP> <IP>

# sync
ntpdate -bs <IP>
```

## Change Time zone

```bash
# SLES11 
cp -p /etc/sysconfig/clock /etc/sysconfig/clock.orig

vi /etc/sysconfig/clock

TIMEZONE="US/Central"
DEFAULT_TIMEZONE="US/Central"

zic -l US/Central

# RHEL/CENTOS/ORACLE LINUX release 6

# List time zones
ls /usr/share/zoneinfo

mv /etc/localtime /etc/localtime.bkp 
ln -s /usr/share/zoneinfo/America/Asuncion /etc/localtime
vim /etc/sysconfig/clock

grep ZONE /etc/sysconfig/clock

date; export TZ="America/Argentina/Ushuaia"

date

# RHEL/CENTOS/ORACLE LINUX release 7
timedatectl list-timezones

timedatectl list-timezones | grep Asia

timedatectl set-timezone Asia/Almaty

zdump -v /etc/localtime | grep 2018
```

## tzdata_2024a Almaty Kazakhstan

- [Ubuntu / Debian](http://archive.ubuntu.com/ubuntu/pool/main/t/tzdata/tzdata_2024a-1ubuntu1_all.deb)
- [Centos/RHEL](http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/tzdata-2024a-1.el8.noarch.rpm)

```bash
# Ubuntu / Debian
wget http://archive.ubuntu.com/ubuntu/pool/main/t/tzdata/tzdata_2024a-1ubuntu1_all.deb
apt install ./tzdata_2024a-1ubuntu1_all.deb

# Centos/RHEL
wget http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/tzdata-2024a-1.el8.noarch.rpm
rpm -i ./tzdata-2024a-1.el8.noarch.rpm
```

## ntpq - output

Select Field tally code:

The first character displayed in the table (Select Field tally code) is a state flag (see Peer Status Word) that follows the sequence " ", "x", "-", "#", "+", "*", "o":

- " " – No state indicated for: non-communicating remote machines, “LOCAL" for this local host, (unutilised) high stratum servers, remote machines that are themselves using this host as their synchronisation reference
- "x" – Out of tolerance, do not use (discarded by intersection algorithm);
- "–" – Out of tolerance, do not use (discarded by the cluster algorithm);
- "#" – Good remote peer or server but not utilised (not among the first six peers sorted by synchronization distance, ready as a backup source);
- "+" – Good and a preferred remote peer or server (included by the combine algorithm);
- "*" – The remote peer or server presently used as the primary reference;
- "o" – PPS peer (when the prefer peer is valid). The actual system synchronization is derived from a pulse-per-second (PPS) signal, either indirectly via the PPS reference clock driver or directly via kernel interface.

The refid can have the status values:

- An IP address – The IP address of a remote peer or server
- .LOCL. – This local host (a place marker at the lowest stratum included in case there are no remote peers or servers available);
- .PPS. – "Pulse Per Second" from a time standard;
- .IRIG. – Inter-Range Instrumentation Group time code;
- .ACTS. – American NIST time standard telephone modem;
- .NIST. – American NIST time standard telephone modem;
- .PTB. – German PTB time standard telephone modem;
- .USNO. – American USNO time standard telephone modem;
- .CHU. – CHU (HF, Ottawa, ON, Canada) time standard radio receiver;
- .DCFa. – DCF77 (LF, Mainflingen, Germany) time standard radio receiver;
- .HBG. – HBG (LF Prangins, Switzerland) time standard radio receiver;
- .JJY. – JJY (LF Fukushima, Japan) time standard radio receiver;
- .LORC. – LORAN-C station (MF) time standard radio receiver. Note, no longer operational (superseded by eLORAN);
- .MSF. – MSF (LF, Anthorn, Great Britain) time standard radio receiver;
- .TDF. – TDF (MF, Allouis, France) time standard radio receiver;
- .WWV. – WWV (HF, Ft. Collins, CO, America) time standard radio receiver;
- .WWVB. – WWVB (LF, Ft. Collins, CO, America) time standard radio receiver;
- .WWVH. – WWVH (HF, Kauai, HI, America) time standard radio receiver;
- .GOES. – American Geosynchronous Orbit Environment Satellite;
- .GPS. – American GPS;
- .GAL. – Galileo European GNSS;
- .ACST. – manycast server;
- .AUTH. – authentication error;
- .AUTO. – Autokey sequence error;
- .BCST. – broadcast server;
- .CRYPT. – Autokey protocol error;
- .DENY. – access denied by server;
- .INIT. – association initialized;
- .XFAC. – association changed (IP address changed or lost);
- .MCST. – multicast server;
- .RATE. – (polling) rate exceeded;
- .TIME. – association timeout;
- .STEP. – step time change, the offset is less than the panic threshold (1000ms) but greater than the step threshold (125ms).

## Sources

- [How to change the timezone (SLES)​](https://support.teradata.com/knowledge?id=kb_article_view&sys_kb_id=dd2baf501b6b881095283112cd4bcb2e)
- [How to change timezone in RHEL based distributions - release 6 and 7](https://shgonzalez.github.io/linux/2017/09/27/How-to-change-Timezone-in-RHEL-Centos.html)
- [How to Change Timezone Linux on RHEL 6/7 and CentOS 6/7](https://webhostinggeeks.com/howto/how-to-change-timezone-linux/)
- [NTP falsetickers](http://serverfault.com/questions/591325/both-my-ntp-servers-are-marked-as-falsetickers-in-the-status)
- ["ntpq -p" output](https://nlug.ml1.co.uk/2012/01/ntpq-p-output/831)
