# Build a Network Router

This assumes an system similar to

Use these IPTables rules:

```rules
# Interfaces:
#
# enp1s0: WAN
# enp2s0: 192.168.1.0/24 (LAN)
# enp3s0: 172.16.0.0/24 (Diagnostic LAN)
# enp4s0: Not used

*nat
:PREROUTING ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]

# NAT traffic going out the WAN interface
-A POSTROUTING -o enp1s0 -j MASQUERADE
COMMIT

*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:f2b-sshd - [0:0]

## INPUT rules

# fail2ban rule to avoid lockout when changing rules
-A INPUT -p tcp -m multiport --dports 22 -j f2b-sshd

# Allow in from loopback
-A INPUT -i lo -j ACCEPT

# Allow in from LAN
-A INPUT -i enp2s0 -j ACCEPT

# Allow in from diagnostic LAN
-A INPUT -i enp3s0 -j ACCEPT

# Allow in established input from WAN
-A INPUT -i enp1s0 -m state --state RELATED,ESTABLISHED -j ACCEPT

# Drop invalid packets from WAN
-A INPUT -i enp1s0 -m state --state INVALID -j DROP

# Allow in unreachable, ping, ttl and bad header ICMP from WAN
-A INPUT -i enp1s0 -p icmp -m icmp --icmp-type 3 -j ACCEPT
-A INPUT -i enp1s0 -p icmp -m icmp --icmp-type 8 -j ACCEPT
-A INPUT -i enp1s0 -p icmp -m icmp --icmp-type 11 -j ACCEPT
-A INPUT -i enp1s0 -p icmp -m icmp --icmp-type 12 -j ACCEPT

# Allow in IPsec VPN from WAN
-A INPUT -i enp1s0 -p udp -m udp --dport 500 -j ACCEPT
-A INPUT -i enp1s0 -p udp -m udp --dport 4500 -j ACCEPT

# SSH from WAN
-A INPUT -i enp1s0 -p tcp -m tcp --dport 22 -j ACCEPT

# DROP everything else
-A INPUT -i enp1s0 -j DROP

## FORWARD rules

# Forward all LAN traffic to WAN
-A FORWARD -i enp2s0 -o enp1s0 -j ACCEPT

# Forward WAN traffic to LAN if LAN initiated connection
-A FORWARD -i enp1s0 -o enp2s0 -m state --state RELATED,ESTABLISHED -j ACCEPT

# DROP everything else
-A FORWARD -j DROP

# Other part of fail2ban rules to avoid SSH lockout
-A f2b-sshd -j RETURN

COMMIT
```

## Diagnostic Procedure

- Can you ping? `ping 192.168.1.1`
- Can you SSH in? `ssh ...`
- Kea-DHCP running? `systemctl status isc-kea-dhcp4-server`
- Bind9 DNS running? `systemctl status named`
- Do you have an public IP address? `ip addr`
- External DNS working? `ping www.google.com`
- Connect via diagnostic LAN?  Set manual IP of `172.16.0.2` and `ssh user@172.16.0.1`
- Cannot connect to cable modem? Set manual IP of `192.168.100.2` and `ping 192.168.100.1` then use browser to connect to `http://192.168.100.1` with modem password.
- Modem not responding to `ping 192.168.100.1`? Reboot the modem.

The cable modem has a diagnostic IP of `192.168.100.1`  Even though this isn't on the `192.168.1.0/24` subnet you can get to it normally because it looks like any other Internet address.  You know it's a private IP, but the routing tables don't care.  It hits the default routing table to the Internet and gets caught on the first hop.

The problem is, when the interface can't get an address from the modem it doesn't add a default route.  You can add one manually with `route add 192.168.100.1 dev enp1s0`.  This will get overwritten when the interface eventually comes up.

## Configure `systemd-networkd-wait-online.service`

Edit the service file to only wait for the network interfaces that you expect to come up, e.g.

```conf
ExecStart=/lib/systemd/systemd-networkd-wait-online -i enp2s0 -i enp1s0
```
