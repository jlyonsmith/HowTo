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