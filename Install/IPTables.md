# Install `iptables`

`iptables` is the built-in firewall on Ubuntu, Debian and CentOS. `ip6tables` is the IPv6 equivalent.

Heres a handy diagram to understand how it works:

![iptables](./IPTables/iptables.png)

Each colored box is a _table_, each gray box is a _chain_.

> When messing with IPTables configuration, it's a good idea to stop the `fail2ban` service if it's running or you may find yourself locked out.

## Ubuntu/Debian

> Use the scripts in this repo [jlyonsmith/systemd-iptables: Example of a persistent firewall based on systemd for Debian Jessie.](https://github.com/jlyonsmith/systemd-iptables) going forward.

`iptables` is installed by default on Debian & Ubuntu. `iptables` do not persist on Ubuntu & Debian by default.  `iptables` are persistent by default on CentOS. You **must** add a persistence mechanism as an extra step.

Remove any old mechanism for persistences:

```sh
apt remove iptables-persistent netfilter-persistent
```

Place the your rule in `/etc/iptables.rules` for IPv4, and `/etc/ip6tables.rules` for IPv6:

Then in `/etc/systemd/system/iptables-restore.service` put:

```toml
[Unit]
Description=Apply iptables rules
After=network.target

[Service]
Type=oneshot
ExecStart=/bin/sh -c 'iptables-restore -w 15 /etc/iptables.rules'
RemainAfterExit=true
ExecStop=/bin/sh -c 'iptables -F; iptables -X; iptables -t nat -F; iptables -t nat -X'
StandardOutput=journal

[Install]
WantedBy=multi-user.target
```

and for IPv6, `/etc/systemd/system/ip6tables-restore.service`:

```toml
[Unit]
Description=Apply iptables rules
After=network.target

[Service]
Type=oneshot
ExecStart=/bin/sh -c 'ip6tables-restore -w 15 /etc/ip6tables.rules'
RemainAfterExit=true
ExecStop=/bin/sh -c 'ip6tables -F; ip6tables -X; ip6tables -t nat -F; ip6tables -t nat -X'
StandardOutput=journal

[Install]
WantedBy=multi-user.target
```

NOTE: The retry `-w 15` option is useful on systems where other services like `fail2ban` are also setting the IPTables.

Then `systemctl enable iptables-restore` and `systemctl start iptables-restore`, and `systemctl enable ip6tables-restore` and `systemctl start ip6tables-restore`.

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

## Rules

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

## Commands

See [How to List and Delete iptables Rules](https://www.digitalocean.com/community/tutorials/how-to-list-and-delete-iptables-firewall-rules)

### Git Line Numbers

```sh
iptables -L --line-numbers
```

### Delete by Position

```sh
iptables -D $CHAIN $POS
```
