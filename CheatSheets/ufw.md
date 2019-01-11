# Uncomplicated Firewall

`ufw` is a tool that provides a somewhat simpler interface to the Linux `iptables` tool.

## Commands

To allow a port (ex. SSH = 22):

`ufw allow 22`

To allow all http, https traffic over TCP:

`ufw allow proto tcp from any to any port 80,443`

To allow specific access from an IP range or drop the /24 for specific IP:

`ufw allow from 1.2.3.0/24 to any port 3306`

To block a malicious IP:

`ufw deny from 1.2.3.4`

To view the list of open ports:

`ufw status`
