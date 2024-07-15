<<<<<<<< HEAD:Procedures/Configure IPv6 Prefix Delegation on Ubuntu.md
========

>>>>>>>> 2e63673 (vault backup: 2024-07-02 14:33:59):Procedures/Enable IPv6 Prefix Delegation on Ubuntu.md
Run `dhclient -d -6 -P -v -lf /var/lib/dhcp/dhclient6-pd.leases {{EXT_IFACE}}` then Ctrl+C and `cat /var/lib/dhcp/dhclient6-pd.leases` to find out what the IPv6 lease CIDR range is.

On Ubuntu 22 `netplan` controls and dynamically creates `systemd-networkd` configuration.  You can browse the current configuration - `ls -al /run/systemd/network`

You can create override files in the `/etc/systemd/network` directory that will be merged with the default configuration.

Do `mkdir /etc/systemd/network/10-netplan-{{WAN_INTERFACE}}.network.d`.

Edit `/etc/systemd/network/10-netplan-{{WAN_INTERFACE}}.network.d/override.conf` to contain:

```conf
[Match]
Name={{WAN_INTERFACE}}

[DHCPv6]
PrefixDelegationHint=::/64
```

Then `mkdir /etc/systemd/network/10-netplan-{{LAN_INTERFACE}}.network.d`.

Edit `/etc/systemd/network/10-netplan-{{WAN_INTERFACE}}.network.d/override.conf` to contain:

```conf
[Match]
Name={{LAN_INTERFACE}}

[Network]
DHCPv6PrefixDelegation=yes
IPv6SendRA=yes
```

Reload changes with `systemctl daemon-reload` then `networkctl reload`.

Check `journalctl -u systemd-networkd -r` to ensure no errors and that you have a delegated IPv6 range.

## References

- [systemd.network - Network configuration](https://manpages.ubuntu.com/manpages/jammy/man5/systemd.network.5.html)
- [Bug #1771886 “Netplan has no option to enable dhcpv6 prefix dele...” : Bugs : netplan](https://bugs.launchpad.net/netplan/+bug/1771886)
- [DHCPv6 prefix delegation with systemd-networkd · Major Hayden](https://major.io/p/dhcpv6-prefix-delegation-with-systemd-networkd/)
- [IPv6 Prefix Delegation on Spectrum with dhclient](https://www.finnie.org/2021/08/07/ipv6-prefix-delegation-on-spectrum-with-dhclient/)
- [I've tried to run IPv6 on my Comcast connection. Unsurprisingly, Comcast doesn't... | Hacker News](https://news.ycombinator.com/item?id=14151677)
- [dhcp - DHCPv6 prefix delegation server for linux? - Unix & Linux Stack Exchange](https://unix.stackexchange.com/questions/28106/dhcpv6-prefix-delegation-server-for-linux/168337#168337)
