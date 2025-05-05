## Installation

```bash
apt install dnsmasq
```

## Debugging

Trace all IPv6 packets:

```bash
tcpdump -i eth0 -vv ip6
```

Debug `dnsmasq` queries:

```bash
dnsmasq --log-queries --log-debug -d -C /etc/dnsmasq.conf
```
## References

- [Man Page - dnsmasq - A lightweight DHCP and caching DNS server](https://manpages.ubuntu.com/manpages/trusty/man8/dnsmasq.8.html)
- [Configuring Dnsmasq](https://dnsmasq.org/docs/setup.html) 
- [How to Run a Local Network DHCP Server with Dnsmasq](https://www.howtogeek.com/devops/how-to-run-a-local-network-dhcp-server-with-dnsmasq)
- [DNS and DHCP with Dnsmasq - Linux.com](https://www.linux.com/topic/networking/dns-and-dhcp-dnsmasq)
- [networking - Get dnsmasq to automatically register hostnames in its DHCP network on its DNS - Super User](https://superuser.com/questions/1491765/get-dnsmasq-to-automatically-register-hostnames-in-its-dhcp-network-on-its-dns)
- [Enhance your DNS and DHCP services with dnsmasq - Linux.com](https://www.linux.com/news/enhance-your-dns-and-dhcp-services-dnsmasq)
- [GitHub - nehart/DNSMASQ: DNSMASQ is a lightweight, easy-to-configure DNS forwarder and DHCP server designed to provide DNS and optionally DHCP services to a small-scale network.](https://github.com/nehart/DNSMASQ)
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
