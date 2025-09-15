## Installation

Stop and remove `systemd-resolved`:

```sh
sudo systemctl disable systemd-resolved
sudo systemctl stop systemd-resolved
```

Install DNSMasq:

```sh
apt install dnsmasq
```

Now edit `/etc/dnsmasq.conf`:

```conf
# Flags
#
# Never forward names without domain parts
domain-needed
# Reverse lookups for private IP ranges not it /etc/hosts are ignored
bogus-priv
# Don't read resolve.conf; use this conf file
no-resolv
# Filter out Win2K bogus DNS requests
filterwin2k
# Add domain name to simple names (without period) before
expand-hosts
# Call nameservers in the order specified
strict-order
# Increase default DNS cache
cache-size=1500
# Don't cache 'no such domain' answers
no-negcache
# Assume this server is the only DHCP on each interface
dhcp-authoritative

# DNS
#
# The internal interface to listen on
interface=eno2
# The upstream DNS server (via systemd-resolved)
server=192.168.1.1

# DHCP
#
# Tell systems the name of the DNS server
dhcp-option=interface:eno1,6,10.10.0.1
# The range of addresses to serve
dhcp-range=interface:eno1,10.10.0.1,10.10.0.250,12h
# The lease lifetime
dhcp-lease-max=250
```

Set `/etc/default/dnsmasq` to actually ignore the `/etc/resolv.conf` file:

```conf
IGNORE_RESOLVCONF=yes
```
## Debugging

Run `dnsmasq` on the command line to test:

```bash
dnsmasq --no-daemon --log-queries --log-debug -d -C /etc/dnsmasq.conf
```

To show leases:

```
cat /var/lib/misc/dnsmasq.leases
```

For IPv6 issues, you can trace all IPv6 packets like so:

```bash
tcpdump -i eth0 -vv ip6
```

The `/etc/resolv.conf` file can be restored with:

```sh
sudo ln -s ../run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
```

## References

- [Man Page - dnsmasq - A lightweight DHCP and caching DNS server](https://manpages.ubuntu.com/manpages/trusty/man8/dnsmasq.8.html)
- [Configuring Dnsmasq](https://dnsmasq.org/docs/setup.html) 
- [DHCP Options in Plain English](https://www.incognito.com/tutorials/dhcp-options-in-plain-english/)
- [How to Run a Local Network DHCP Server with Dnsmasq](https://www.howtogeek.com/devops/how-to-run-a-local-network-dhcp-server-with-dnsmasq)
- [DNS and DHCP with Dnsmasq - Linux.com](https://www.linux.com/topic/networking/dns-and-dhcp-dnsmasq)
- [networking - Get dnsmasq to automatically register hostnames in its DHCP network on its DNS - Super User](https://superuser.com/questions/1491765/get-dnsmasq-to-automatically-register-hostnames-in-its-dhcp-network-on-its-dns)
- [Enhance your DNS and DHCP services with dnsmasq - Linux.com](https://www.linux.com/news/enhance-your-dns-and-dhcp-services-dnsmasq)
- [Dnsmasq Cheat Sheet](https://etherarp.net/dnsmasq/index.html)
- [Configure and Use Dnsmasq DHCP Server in Proxmox VMs | ComputingForGeeks](https://computingforgeeks.com/using-dnsmasq-dhcp-server-proxmox-vms)
- https://unix.stackexchange.com/questions/28004/how-to-overcome-libc-resolver-limitation-of-maximum-3-nameservers
- https://wiki.debian.org/dnsmasq
- [DHCP Options in Plain English | IPv4 IPv6 | Incognito Software Systems](https://www.incognito.com/tutorials/dhcp-options-in-plain-english)
- [How to force ALL of the DHCP Clients to renew? - Stack Overflow](https://stackoverflow.com/questions/28917135/how-to-force-all-of-the-dhcp-clients-to-renew)
- [How to Run Your Own DNS Server on Your Local Network](https://www.howtogeek.com/devops/how-to-run-your-own-dns-server-on-your-local-network)
- [How to Run a Local Network DHCP Server with Dnsmasq](https://www.howtogeek.com/devops/how-to-run-a-local-network-dhcp-server-with-dnsmasq)
- [Ubuntu 24.04 : Dnsmasq : Install : Server World](https://www.server-world.info/en/note?os=Ubuntu_24.04&p=dnsmasq&f=1)
- [Using dnsmasq for dhcpv6](https://hveem.no/using-dnsmasq-for-dhcpv6)
