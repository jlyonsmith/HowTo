# Install `iptables`

`iptables` is the built-in firewall on Ubuntu, Debian and CentOS. `ip6tables` is the IPv6 equivalent.

Heres a handy diagram to understand how it works:

![iptables](./IPTables/iptables.png)

Each colored box is a _table_, each gray box is a _chain_.

> When messing with IPTables configuration, it's a good idea to stop the `fail2ban` service if it's running or you may find yourself locked out.

## Ubuntu/Debian

> Use the scripts in this repo [jlyonsmith/systemd-iptables: Example of a persistent firewall based on systemd for Debian Jessie.](https://gi222665thub.com/jlyonsmith/systemd-iptables) going forward.

`iptables` is installed by default on Debian & Ubuntu. `iptables` do not persist on Ubuntu & Debian by default.  `iptables` are persistent by default on CentOS. You **must** add a persistence mechanism as an extra step.

Remove any old mechanism for persistence before starting:

```sh
apt remove iptables-persistent netfilter-persistent
```

Edit `/etc/iptables/iptables.rules` for IPv4, and `/etc/iptables/ip6tables.rules` for IPv6:

## Debugging

You can use:

```bash
sudo netstat -peanut
```

To see what ports are listening and the network activity that is occurring.

You can check IPTables when changing with:

```sh
iptables-restore --test /etc/iptables.rules
ip6tables-restore --test /etc/ip6tables.rules
```

Debugging IPTables can be tricky.  To see each rule and how many times it has matched, do:

```sh
sudo iptables -L -v
sudo ip6tables -L -v
```

## Example Rules

These are example rules for a router.

### IPv4

```rules
# Interfaces:
#
# eth0: WAN
# eth1: Private LAN

*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]

## INPUT rules

# Allow in from loopback
-A INPUT -i lo -j ACCEPT

# Allow in established input from WAN
-A INPUT -i eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT

# Drop invalid packets from WAN
-A INPUT -i eth0 -m state --state INVALID -j DROP

# Allow in unreachable, ping, ttl and bad header ICMP from WAN
-A INPUT -i eth0 -p icmp -m icmp --icmp-type 3 -j ACCEPT
-A INPUT -i eth0 -p icmp -m icmp --icmp-type 8 -j ACCEPT
-A INPUT -i eth0 -p icmp -m icmp --icmp-type 11 -j ACCEPT
-A INPUT -i eth0 -p icmp -m icmp --icmp-type 12 -j ACCEPT

# SSH from private subnet only
-A INPUT -i eth1 -p tcp -m tcp --dport 22 -j ACCEPT

# HTTP/HTTPS in
-A INPUT -i eth0 -p tcp -m tcp --dport 80 -j ACCEPT
-A INPUT -i eth0 -p tcp -m tcp --dport 443 -j ACCEPT

# DROP everything else from WAN
-A INPUT -i eth0 -j DROP

COMMIT
```

### IPv6

```rules
# Interfaces:
#
# enp1s0: WAN
# enp2s0: LAN
# enp3s0: LAN (Diagnostic)
# enp4s0: OFF

*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]

## INPUT rules

# fail2ban rule to avoid lockout when changing rules
-A INPUT -p tcp -m multiport --dports 22 -j f2b-sshd

# Allow in from loopback
-A INPUT -i lo -j ACCEPT

# Allow input from LAN
-A INPUT -i enp2s0 -j ACCEPT

# Allow input from diagnostic LAN
-A INPUT -i enp3s0 -j ACCEPT

# Allow IPv6 ICMP from WAN
-A INPUT -i enp1s0 -p ipv6-icmp -j ACCEPT

# Allow SSH from WAN
-A INPUT -i eth1 -p tcp -m tcp --dport 22 -j ACCEPT

# Allow in established input from WAN
-A INPUT -i eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT

# Drop invalid packets from WAN
-A INPUT -i eth0 -m state --state INVALID -j DROP

# DROP all other input
-A INPUT -j DROP

# Forward all LAN traffic to the WAN
-A FORWARD -i enp2s0 -o enp1s0 -j ACCEPT

# Forward all WAN traffic to the LAN if established connection
-A FORWARD -i enp1s0 -o enp2s0 -m state --state RELATED,ESTABLISHED -j ACCEPT

# Other part of fail2ban rules to avoid SSH lockout
-A f2b-sshd -j RETURN

COMMIT
```

> Don't forget to allow `ipv6-icmp` on all interfaces or IPv6 SLAAC and other protocols will break.

## Command

See [How to List and Delete iptables Rules](https://www.digitalocean.com/community/tutorials/how-to-list-and-delete-iptables-firewall-rules)

### Show Line Numbers

```sh
iptables -L --line-numbers
```

### Delete by Position

```sh
iptables -D $CHAIN $POS
```

## References

- [Linux Iptables allow or block ICMP ping request](https://www.cyberciti.biz/tips/linux-iptables-9-allow-icmp-ping.html)
