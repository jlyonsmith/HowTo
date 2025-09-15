## Overview

Networking on Ubuntu 24.04 is controlled by Netplan.  

## Configure DHCP or Static IP IPv4 Address

Edit `/etc/netplan/50-cloud-init.yaml`:

```yaml
network:
  version: 2
  ethernets:
    eno1:
      dhcp4: true
    eno2:
      dhcp4: false
      addresses:
        - 10.10.0.1/24
      routes:
        - to: default
          via: 192.168.1.53
      nameservers:
        addresses: [192.168.1.53]
```

Test and apply:

```sh
sudo netplan try --debug # Fix errors or Enter to accept
```
## Lock Down Configuration

```sh
sudo chmod u=rw,go= /etc/netplan/50-cloud-init.yaml
```

