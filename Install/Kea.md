# Installing Kea DHCP Server

## Build and Installation

Instructions on how to configure Kea DHCP is available [here](https://kb.isc.org/docs/isc-kea-packages).

Install Kea DHCP from Cloudsmith:

```sh
curl -1sLf \
  'https://dl.cloudsmith.io/public/isc/kea-1-7/cfg/setup/bash.deb.sh' \
  | sudo -E bash
```

Then:

```sh
sudo apt install -y isc-kea-dhcp4-server isc-kea-dhcp6-server isc-kea-admin isc-kea-ctrl-agent
```

Then enable:

```sh
systemctl enable isc-kea-dhcp4-server
systemctl start isc-kea-dhcp4-server
```

## Configuration

Configuration is stored in JSON and is separate for DHCPv4 and DHCPv6. See [this](https://ftp.isc.org/isc/kea/cur/doc/kea-guide.html#idm45914470877152) section of the documentation.

For DHCPv4 see `/etc/kea/kea-dhcp4.conf`:

```json
{
  "Dhcp4": {
    "interfaces-config": {
      "interfaces": ["enp2s0"]
    },
    "valid-lifetime": 4000,
    "renew-timer": 1000,
    "rebind-timer": 2000,
    "lease-database": {
      "type": "memfile",
      "persist": true,
      "name": "/var/kea/dhcp4.leases"
    },
    "option-data": [
      {
        "name": "domain-name-servers",
        "data": "1.1.1.1, 1.0.0.1"
      },
      {
        "name": "routers",
        "data": "192.168.1.1"
      }
    ],
    "subnet4": [
      {
        "pools": [{ "pool": "192.168.1.2-192.168.1.250" }],
        "subnet": "192.168.1.0/24"
      }
    ],
    "control-socket": {
      "socket-type": "unix",
      "socket-name": "/tmp/kea-dhcp4-ctrl.sock"
    },
    "loggers": [
      {
        "name": "kea-dhcp4",
        "output_options": [
          {
            "output": "/var/log/kea/kea-dhcp4.log"
          }
        ],
        "severity": "DEBUG"
      }
    ]
  }
}
```

An equivalent file for DHCPv6 in `/etc/kea-dhcp6.conf` is:

```json
{
  "Dhcp6": {
    "valid-lifetime": 4000,
    "renew-timer": 1000,
    "rebind-timer": 2000,

    "interfaces-config": {
      "interfaces": []
    },

    "lease-database": {
      "type": "memfile",
      "persist": true,
      "name": "/var/kea/dhcp6.leases"
    },
    "subnet6": [],
    "control-socket": {
      "socket-type": "unix",
      "socket-name": "/tmp/kea-dhcp6-ctrl.sock"
    },
    "loggers": [
      {
        "name": "kea-dhcp6",
        "output_options": [
          {
            "output": "/var/log/kea/kea-dhcp6.log"
          }
        ],
        "severity": "INFO"
      }
    ]
  }
}
```

Unless you are installing for a large corporation, you do not need to use the PostreSQL or other lease database options.

## Showing Current Leases

Dump the leases file:

```bash
cat /var/kea/dhcp4.leases
```

## Adding Address Reservations

Add a `reservations` array under the subnet:

```json5
  "subnet4": [
    {
      "subnet": "192.168.0.0/24",
      "pools": [{...}],
      "reservations": [
        # My printer
        {
          "hw-address": "f2:dd:ab:ba:77:c9",
          "ip-address": "192.168.0.42"
        }
      ]
    }
```

See [Host Reservation in DHCPv4](https://kea.readthedocs.io/en/latest/arm/dhcp4-srv.html#host-reservation-in-dhcpv4).

## High Availability Configuration

To create a high availability hot standby DHCP cluster, do the following.

Edit the file `/etc/kea/kea-ctrl-agent.conf`. Change the lines:

```json
{
  "http-host": "10.10.1.1",
  "http-port": 8080
}
```

To reflect the system internal IP address. Confirm that the agent API is working with:

```bash
http_proxy= curl -X POST -H "Content-Type: application/json" -d '{ "command": "config-get", "service": [ "dhcp4" ] }' http://10.10.1.1:8080/
```

You should see a dump of the DHCPv4 configuration.

Now add the following configuration to the `/etc/kea/kea-dhcp4.conf` file:

```json5
  "hooks-libraries": [
    {
      "library": "/usr/lib/hooks/libdhcp_lease_cmds.so",
      "parameters": {}
    },
    {
      "library": "/usr/lib/hooks/libdhcp_ha.so",
      "parameters": {
        "high-availability": [
          {
            "this-server-name": "server1",
            "mode": "hot-standby",
            "heartbeat-delay": 10000,
            "max-response-delay": 10000,
            "max-ack-delay": 5000,
            "max-unacked-clients": 5,
            "peers": [
              {
                "name": "server1",
                "url": "http://10.1.1.1:8080/",
                "role": "primary",
                "auto-failover": true
              },
              {
                "name": "server2",
                "url": "http://10.1.1.2:8080/",
                "role": "standby",
                "auto-failover": true
              }
            ]
          }
        ]
      }
    }
  ]
```

Hot standby is used instead of load balancing because it does not require splitting the pool of IP addresses into two groups with different DHCP _classes_, and is simpler to administer. Ensure that `this-server-name` is set to `server1` or `server2` as appropriate.

And of course, update your proxy firewalls:

```bash
sudo ufw allow in proto tcp from $LAN_PROXY_SUBNET to $LAN_IP port 8080
sudo ufw allow out proto tcp from $LAN_IP to $LAN_PROXY_SUBNET port 8080
```

Confirm a hot-standby configuration on each proxy with:

```bash
http_proxy= curl -X POST -H "Content-Type: application/json" -d '{ "command": "ha-heartbeat", "service": [ "dhcp4" ] }' http://10.1.1.1:8080 | python -m json.tool
```

You should see:

```sh
[
    {
        "arguments": {
            "date-time": "Sun, 07 Apr 2019 23:38:45 GMT",
            "state": "hot-standby"
        },
        "result": 0,
        "text": "HA peer status returned."
    }
]
```
