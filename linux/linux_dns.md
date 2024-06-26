# Cheat sheets DNS

```bash
while true; do dig <FQDN> @8.8.8.8 +short; done

dig @8.8.8.8 host.example.com +short

# reverse lookup
dig -x <IP address>

host <IP address>

nslookup  <IP address>
```

## Flushing DNS cache

```bash
sudo systemd-resolve --flush-caches

# Ubuntu 22.04 and higher
sudo resolvectl flush-caches

# nscd
nscd -i hosts

# or
systemctl restart nscd.service
```

## Sources

- [Flushing nscd DNS cache](https://coderwall.com/p/4b679a/flushing-nscd-dns-cache)
- [How To Clear NSCD Cache?](https://support.cpanel.net/hc/en-us/articles/1500003144942-How-To-Clear-NSCD-Cache-)
- [Clearing local DNS cache](https://www.icdsoft.com/en/kb/view/1899_clearing_local_dns_cache#nscd)
- [How do I clear the DNS cache?](https://askubuntu.com/questions/2219/how-do-i-clear-the-dns-cache)
- [What's the reverse DNS command line utility?](https://serverfault.com/questions/7056/whats-the-reverse-dns-command-line-utility)
- [DNS SRV Priorities and Weights](https://ccieme.wordpress.com/2017/01/24/dns-srv-priorities-and-weights/)
- [DNS record examples](https://docs.pexip.com/admin/dns_records.htm)
- [A DNS RR for specifying the location of services (DNS SRV)](https://www.ietf.org/rfc/rfc2782.txt)
- [The SRV record](https://www.nslookup.io/learning/dns-record-types/srv/)
