## Overview

Raspberry Pi OS networking is managed by the NetworkManager.   The command line interface for this is `nmcli`.  There is a much easier to use character based UI called `nmtui`.

NetworkManager uses *connections* which represent interfaces such as a NIC or WiFi.

To list all connections do `nmcli con show`.

To bounce a connection to renew the DHCP address, for example: 

```sh
nmcli con down wired0
nmcli con up wired0
```

DNS nameservers are in `/etc/resolv.conf`.

To test a specific nameserver, `dig @10.10.0.1 host1.domain.com`.



