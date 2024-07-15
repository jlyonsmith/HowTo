## General 

> "..a multicast socket is not bound to an address, it only participates in a multicast group (see IP_ADD_MEMBERSHIP). A socket can join multiple different groups on the same interface, or same group on different interfaces"

## Configuration

[radvd-project/radvd: radvd ](https://github.com/radvd-project/radvd) is the Linux IPv6 RAS daemon.  You need to create a configuration file in `/etc/radvd.conf` .  

```conf
interface ens0
{
  MinRtrAdvInterval 3;
  MaxRtrAdvInterval 4;
  AdvSendAdvert on;
  AdvManagedFlag on;
  prefix 2001:db7::/64
    { 
      AdvValidLifetime 14300;
      AdvPreferredLifetime 14200; 
    };
};
```

To use DHCPv6 the M bit must be on (`AdvManagedFlag on`) and the A bit off.  See [Reddit - Dive into anything](https://www.reddit.com/r/sysadmin/comments/13fssjj/kea_dhcp6_shared_networks_dhcp6_not_providing_ipv6) and [router - IPv6 RA flags and various combinations](https://networkengineering.stackexchange.com/questions/35373/ipv6-ra-flags-and-various-combinations)

- https://www.youtube.com/watch?v=6g_DEcwNgp0
- https://www.youtube.com/watch?v=ZGnTd-10q9w&t=1310s
## macOS

Disable IPv6 temporary address assignment:

```sh
sysctl -w net.inet6.ip6.prefer_tempaddr=0
sysctl -w net.inet6.ip6.use_tempaddr=0
```

See https://www.reddit.com/r/ipv6/comments/nnscnk/macos_big_sur_slaac_or_static_dhcpv6/.

## Research Notes

After investigation, I found that there were router advertisement packets coming from the external network interface. I added a firewall rule to block them (using `ip6tables`)

Currently, I can see the router solicitation message hitting the router, and a router advertisement packet being returned. However, the MacBook does not receive an IP address from the DHCP server as it should.

Next steps:

- Turn of DHCPv6 and configure `radvd` to return an IPv6 prefix.  See if that sets the Macbook IP address correctly. If so, the problem is with DHCPv6, either the Macbook does not support it or the server is misconfigured.
## References

- [DHCPv6 - The Absolute Guide &mdash; RapidSeedbox](https://www.rapidseedbox.com/blog/guide-to-dhcpv6)
- https://black.host/hc/vps-hosting/how-to-setup-ipv6-on-ubuntu-20-04-with-netplan/
- [YAML configuration - Netplan documentation](https://netplan.readthedocs.io/en/latest/netplan-yaml)
- [How To Install radvd on Ubuntu 20.04 | Installati.one](https://installati.one/install-radvd-ubuntu-20-04)
- https://necromuralist.github.io/posts/the-linux-ipv6-router-advertisement-daemon-radvd
- [Ubuntu Manpage - radvd.conf](https://manpages.ubuntu.com/manpages/xenial/en/man5/radvd.conf.5.html)
- [DHCPv6 - The Absolute Guide](https://www.rapidseedbox.com/blog/guide-to-dhcpv6)
- [IPv6 address types &#8211; APNIC](https://www.apnic.net/get-ip/faqs/what-is-an-ip-address/ipv6-address-types)
- [How To Install radvd on Ubuntu 20.04](https://installati.one/install-radvd-ubuntu-20-04)
- [14.6. Configuring the radvd daemon for IPv6 routers | Red Hat Product Documentation](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/7/html/networking_guide/sec-configuring_the_radvd_daemon_for_ipv6_routers)
- [Ubuntu Manpage - radvdump](https://manpages.ubuntu.com/manpages/xenial/en/man8/radvdump.8.html)
- [GitHub - jlyonsmith/ipv6toolkit](https://github.com/jlyonsmith/ipv6toolkit)
- https://www.kali.org/tools/ipv6toolkit
- https://www.menandmice.com/blog/ipv6-reference-multicast
- [Why You Must Use ICMPv6 Router Advertisements (RAs)](https://blogs.infoblox.com/ipv6-coe/why-you-must-use-icmpv6-router-advertisements-ras)
- [Router Solicitation (RS) and Router Advertisement (RA) Messages in IPv6](https://www.omnisecu.com/tcpip/ipv6/router-solicitation-and-router-advertisement-messages.php)
- [IPv6 Stateless Address Auto-configuration (SLAAC) | NetworkAcademy.io](https://www.networkacademy.io/ccna/ipv6/stateless-address-autoconfiguration-slaac)
- [linux - listing multicast sockets - Stack Overflow](https://stackoverflow.com/questions/15892675/listing-multicast-sockets)
- [RFC 8415: Dynamic Host Configuration Protocol for IPv6 (DHCPv6)](https://www.rfc-editor.org/rfc/rfc8415.html)
- [Radvd and DHCPd6 Server Configuration for Dynamic DNS - SophieDogg](https://sophiedogg.com/radvd-and-dhcpd6-server-configuration-for-dynamic-dns)/
- [How to: IPv6 Neighbor Discovery | APNIC Blog](https://blog.apnic.net/2019/10/18/how-to-ipv6-neighbor-discovery)/