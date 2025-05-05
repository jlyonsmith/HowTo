## General 

> "..a multicast socket is not bound to an address, it only participates in a multicast group (see IP_ADD_MEMBERSHIP). A socket can join multiple different groups on the same interface, or same group on different interfaces"
\
## ICMP

Internet Control Message Protocol is used to by underlying Internet mechanisms such as ping, DHCP and IPv6 routing.  

### IPv4

3, 8, 11 and 12 should be allowed in externally for both IPv4.  Everything else can be blocked.

| **Type** | **Description**                                                                                                       |
| -------- | --------------------------------------------------------------------------------------------------------------------- |
| 0        | Echo reply (used to [ping](https://en.wikipedia.org/wiki/Ping_(networking_utility) "Ping (networking utility)"))      |
| 1 - 2    | Reserved                                                                                                              |
| 3        | Destination network unreachable                                                                                       |
| 4        | Source quench (congestion control)                                                                                    |
| 5        | Redirect Datagram for the Network                                                                                     |
| 8        | Echo request (used to ping)                                                                                           |
| 9        | [Router Advertisement](https://en.wikipedia.org/wiki/ICMP_Router_Discovery_Protocol "ICMP Router Discovery Protocol") |
| 10       | [Router Solicitation](https://en.wikipedia.org/wiki/ICMP_Router_Discovery_Protocol "ICMP Router Discovery Protocol")  |
| 11       | [Time Exceeded](https://en.wikipedia.org/wiki/ICMP_Time_Exceeded "ICMP Time Exceeded")                                |
| 12       | Parameter Problem: Bad IP header                                                                                      |
| 13       | Timestamp                                                                                                             |
| 14       | Timestamp reply                                                                                                       |
| 15       | Information Request                                                                                                   |
| 16       | Information Reply                                                                                                     |
| 17       | Address Mask Request                                                                                                  |
| 18       | Address Mask Reply                                                                                                    |
| 19       | Reserved for security                                                                                                 |
| 20 - 29  | Reserved for robustness experiment                                                                                    |
| 30       | [Traceroute](https://en.wikipedia.org/wiki/Traceroute "Traceroute")                                                   |
| 42       | Extended Echo Request                                                                                                 |
| 43       | Extended Echo Reply                                                                                                   |
| 44 - 252 | Reserved                                                                                                              |
### IPv6

Types 1, 2, 3, 4, 128, 141 and 142 should be allowed in from external sources for IPv6.  Everything else can be blocked.

| **Type**  | `ipv6-icmp`             | **Description**                                                                                                                                                                                                                                                              |
| --------- | ----------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1         | destination-unreachable | [Destination unreachable](https://en.wikipedia.org/wiki/Internet_Control_Message_Protocol#Destination_unreachable "Internet Control Message Protocol")                                                                                                                       |
| 2         | packet-too-big          | [Packet too big](https://en.wikipedia.org/wiki/IPv6_packet#Fragmentation "IPv6 packet")                                                                                                                                                                                      |
| 3         | time-exceeded           | [Time exceeded](https://en.wikipedia.org/wiki/Internet_Control_Message_Protocol#Time_exceeded "Internet Control Message Protocol")                                                                                                                                           |
| 4         | parameter-problem       | Parameter problem                                                                                                                                                                                                                                                            |
| 100 - 126 |                         | Private experimentation                                                                                                                                                                                                                                                      |
| 127       |                         | Reserved                                                                                                                                                                                                                                                                     |
| 128       | echo-request            | [Echo Request](https://en.wikipedia.org/wiki/Echo_Request "Echo Request")                                                                                                                                                                                                    |
| 129       | echo-reply              | [Echo Reply](https://en.wikipedia.org/wiki/Echo_Reply "Echo Reply")                                                                                                                                                                                                          |
| 130       |                         | [Multicast Listener Query](https://en.wikipedia.org/w/index.php?title=Multicast_Listener_Query&action=edit&redlink=1 "Multicast Listener Query (page does not exist)") ([MLD](https://en.wikipedia.org/wiki/Multicast_Listener_Discovery "Multicast Listener Discovery"))    |
| 131       |                         | [Multicast Listener Report](https://en.wikipedia.org/w/index.php?title=Multicast_Listener_Report&action=edit&redlink=1 "Multicast Listener Report (page does not exist)") ([MLD](https://en.wikipedia.org/wiki/Multicast_Listener_Discovery "Multicast Listener Discovery")) |
| 132       |                         | [Multicast Listener Done](https://en.wikipedia.org/w/index.php?title=Multicast_Listener_Done&action=edit&redlink=1 "Multicast Listener Done (page does not exist)") ([MLD](https://en.wikipedia.org/wiki/Multicast_Listener_Discovery "Multicast Listener Discovery"))       |
| 133       | router-solicitation     | Router Solicitation ([NDP](https://en.wikipedia.org/wiki/Neighbor_Discovery_Protocol "Neighbor Discovery Protocol"))                                                                                                                                                         |
| 134       | router-advertisement    | Router Advertisement ([NDP](https://en.wikipedia.org/wiki/Neighbor_Discovery_Protocol "Neighbor Discovery Protocol"))                                                                                                                                                        |
| 135       | neighbour-solicitation  | Neighbor Solicitation ([NDP](https://en.wikipedia.org/wiki/Neighbor_Discovery_Protocol "Neighbor Discovery Protocol"))                                                                                                                                                       |
| 136       | neighbour-advertisement | Neighbor Advertisement ([NDP](https://en.wikipedia.org/wiki/Neighbor_Discovery_Protocol "Neighbor Discovery Protocol"))                                                                                                                                                      |
| 137       | redirect                | Redirect Message ([NDP](https://en.wikipedia.org/wiki/Neighbor_Discovery_Protocol "Neighbor Discovery Protocol"))                                                                                                                                                            |
| 138       |                         | Router Renumbering                                                                                                                                                                                                                                                           |
| 255       |                         | Sequence Number Reset                                                                                                                                                                                                                                                        |
| 139       |                         | ICMP Node Information Query                                                                                                                                                                                                                                                  |
| 140       |                         | ICMP Node Information Response                                                                                                                                                                                                                                               |
| 141       |                         | Inverse Neighbor Discovery Solicitation Message                                                                                                                                                                                                                              |
| 142       |                         | Inverse Neighbor Discovery Advertisement Message                                                                                                                                                                                                                             |
| 143       |                         | Multicast Listener Discovery ([MLDv2](https://en.wikipedia.org/wiki/Multicast_Listener_Discovery "Multicast Listener Discovery"))                                                                                                                                            |
| 144       |                         | Home Agent Address Discovery Request Message                                                                                                                                                                                                                                 |
| 145       |                         | Home Agent Address Discovery Reply Message                                                                                                                                                                                                                                   |
| 146       |                         | Mobile Prefix Solicitation                                                                                                                                                                                                                                                   |
| 147       |                         | Mobile Prefix Advertisement                                                                                                                                                                                                                                                  |
| 148       |                         | Certification Path Solicitation ([SEND](https://en.wikipedia.org/wiki/Secure_Neighbor_Discovery_Protocol "Secure Neighbor Discovery Protocol"))                                                                                                                              |
| 149       |                         | Certification Path Advertisement (SEND)                                                                                                                                                                                                                                      |
| 151       |                         | Multicast Router Advertisement ([MRD](https://en.wikipedia.org/wiki/Multicast_router_discovery "Multicast router discovery"))                                                                                                                                                |
| 152       |                         | Multicast Router Solicitation ([MRD](https://en.wikipedia.org/wiki/Multicast_router_discovery "Multicast router discovery"))                                                                                                                                                 |
| 153       |                         | Multicast Router Termination ([MRD](https://en.wikipedia.org/wiki/Multicast_router_discovery "Multicast router discovery"))                                                                                                                                                  |
| 155       |                         | RPL Control Message                                                                                                                                                                                                                                                          |
| 200 - 255 |                         | Private experimentation/future expansion                                                                                                                                                                                                                                     |
For `ipv6-icmp` in `iptables` you can use named values - `ip6tables -p ipv6-icmp -h` which makes the firewall rules a little easier to read.
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

### Testing Router Advertisements

You can use `radvdump` which should be included in the `radvd` package.
## macOS

Disable IPv6 temporary address assignment:

```sh
sysctl -w net.inet6.ip6.prefer_tempaddr=0
sysctl -w net.inet6.ip6.use_tempaddr=0
```

See https://www.reddit.com/r/ipv6/comments/nnscnk/macos_big_sur_slaac_or_static_dhcpv6/.


## Research Notes

### Home Network

After investigation, I found that there were router advertisement packets coming from the external network interface. I added a firewall rule to block them (using `ip6tables`)

Currently, I can see the router solicitation message hitting the router (Ubuntu host), and a router advertisement packet being returned. However, the MacBook does not receive an IP address from the DHCPv6 server as it should.

Next steps:

- Turn of DHCPv6 and configure `radvd` to return an IPv6 prefix.  See if that sets the Macbook IP address correctly. If so, the problem is with DHCPv6, either the Macbook does not support it or the server is misconfigured.

### Debugging

You can use `systemctl install ndisc6` and then run `rdisc6` to check that you have a router responding to RA packets.
## References

- [DHCPv6 - The Absolute Guide](https://www.rapidseedbox.com/blog/guide-to-dhcpv6)
- https://black.host/hc/vps-hosting/how-to-setup-ipv6-on-ubuntu-20-04-with-netplan/
- [YAML configuration - Netplan documentation](https://netplan.readthedocs.io/en/latest/netplan-yaml)
- [How To Install radvd on Ubuntu 20.04 | Installati.one](https://installati.one/install-radvd-ubuntu-20-04)
- https://necromuralist.github.io/posts/the-linux-ipv6-router-advertisement-daemon-radvd
- [Ubuntu Manpage - radvd.conf](https://manpages.ubuntu.com/manpages/xenial/en/man5/radvd.conf.5.html)
- [IPv6 address types](https://www.apnic.net/get-ip/faqs/what-is-an-ip-address/ipv6-address-types)
- [How To Install radvd on Ubuntu 20.04](https://installati.one/install-radvd-ubuntu-20-04)
- [14.6. Configuring the radvd daemon for IPv6 routers](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/7/html/networking_guide/sec-configuring_the_radvd_daemon_for_ipv6_routers)
- [Ubuntu Manpage - radvdump](https://manpages.ubuntu.com/manpages/xenial/en/man8/radvdump.8.html)
- [GitHub - jlyonsmith/ipv6toolkit](https://github.com/jlyonsmith/ipv6toolkit)
- https://www.kali.org/tools/ipv6toolkit
- https://www.menandmice.com/blog/ipv6-reference-multicast
- [Why You Must Use ICMPv6 Router Advertisements (RAs)](https://blogs.infoblox.com/ipv6-coe/why-you-must-use-icmpv6-router-advertisements-ras)
- [Router Solicitation (RS) and Router Advertisement (RA) Messages in IPv6](https://www.omnisecu.com/tcpip/ipv6/router-solicitation-and-router-advertisement-messages.php)
- [IPv6 Stateless Address Auto-configuration (SLAAC) | NetworkAcademy.io](https://www.networkacademy.io/ccna/ipv6/stateless-address-autoconfiguration-slaac)
- [linux - listing multicast sockets - Stack Overflow](https://stackoverflow.com/questions/15892675/listing-multicast-sockets)
- [RFC 8415: Dynamic Host Configuration Protocol for IPv6 (DHCPv6)](https://www.rfc-editor.org/rfc/rfc8415.html)
- [Radvd and DHCPv6 Server Configuration for Dynamic DNS - SophieDogg](https://sophiedogg.com/radvd-and-dhcpd6-server-configuration-for-dynamic-dns)
- [How to: IPv6 Neighbor Discovery | APNIC Blog](https://blog.apnic.net/2019/10/18/how-to-ipv6-neighbor-discovery)
- [DHCPv6 and the Trouble with MAC Addresses (Part 1 of 2)](https://blogs.infoblox.com/ipv6-coe/dhcpv6-and-the-trouble-with-mac-addresses-part-1-of-2)
- [IPv6 - How DHCPv6 works? - YouTube](https://www.youtube.com/watch?v=6g_DEcwNgp0)
- [Example IPv6 configuration for DHCP and Router Advertisement](https://knowledge.broadcom.com/external/article/328201/example-ipv6-configuration-for-dhcp-and.html)
- https://knowledge.broadcom.com/external/article/328201/example-ipv6-configuration-for-dhcp-and.html
- https://www.mattb.nz/w/2011/05/11/linux-ignores-ipv6-router-advertisements-when-forwarding-is-enabled/
- https://forum.proxmox.com/threads/ipv6-dhcpv6-routing-issue.121711
- https://saudiqbal.github.io/Proxmox/proxmox-IPv6-interface-setup-DHCPv6-or-static.html