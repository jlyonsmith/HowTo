# Installing Kea DHCP Server

Instructions on how to install and configure Kea DHCP on Ubuntu 18.x. Extensive documentation on Kea is available [here](https://ftp.isc.org/isc/kea/cur/doc/kea-guide.html)

## Installation

On Ubuntu 18.x:

```bash
apt install kea-dhcp4-server kea-ctrl-agent kea-doc
```

## Configuration

Configuration is stored in JSON. See [this](https://ftp.isc.org/isc/kea/cur/doc/kea-guide.html#idm45914470877152) section of the documentation.

```json
{
  "Dhcp4": {
    "interfaces-config": {
      "interfaces": ["eth0"]
    },
    "valid-lifetime": 4000,
    "renew-timer": 1000,
    "rebind-timer": 2000,
    "lease-database": {
      "type": "memfile",
      "persist": true,
      "name": "/var/kea/dhcp4.leases"
    },
    "subnet4": [
      {
        "pools": [{ "pool": "192.0.2.1-192.0.2.200" }],
        "subnet": "192.0.2.0/24"
      }
    ]
  },

  "Logging": {
    "loggers": [
      {
        "name": "*",
        "severity": "DEBUG"
      }
    ]
  }
}
```

[keactrl](https://ftp.isc.org/isc/kea/cur/doc/kea-guide.html#keactrl-overview) has it's own configuration file `/etc/kea/keactrl.conf` which determines which DHCP services are configured.
