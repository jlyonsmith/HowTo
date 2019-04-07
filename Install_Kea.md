# Installing Kea DHCP Server

## Build and Installation

Instructions on how to configure Kea DHCP is available [here](https://ftp.isc.org/isc/kea/cur/doc/kea-guide.html).

To build the latest version of Kea (1.5 as of this writing), follow the instructions from [Kea build on Ubuntu](https://kb.isc.org/docs/kea-build-on-ubuntu).

```bash
sudo apt -y install automake libtool pkg-config build-essential ccache
sudo apt -y install libboost-dev libboost-system-dev liblog4cplus-dev libssl-dev
```

Then:

```bash
sudo -s
cd /opt
wget https://ftp.isc.org/isc/kea/1.5.0/kea-1.5.0.tar.gz
tar xvfz kea-1.5.0.tar.gz
cd kea-1.5.0
export PKG_CONFIG_PATH=/usr/local/lib64/pkgconfig
declare -x PATH="/usr/lib64/ccache:$PATH"
autoreconf --install
./configure
make -j4
sudo make install
echo "/usr/local/lib/hooks" > /etc/ld.so.conf.d/kea.conf
ldconfig
```

Kea will now be installed in `/usr/local`.  Type `keactrl` to confirm that it is installed an running.

## Configuration

Configuration is stored in JSON and is separate for DHCPv4 and DHCPv6. See [this](https://ftp.isc.org/isc/kea/cur/doc/kea-guide.html#idm45914470877152) section of the documentation.

For DHCPv4 see `/usr/local/etc/kea/kea-dhcp4.conf`:

```json5
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
    ],
    "control-socket": {
      "socket-type": "unix",
      "socket-name": "/tmp/kea-dhcp4-ctrl.sock"
    }
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

An equivalent file for DHCPv6 in `/usr/local/etc/kea-dhcp6.conf` is:

```json5
{
  "Dhcp6": {
    "valid-lifetime": 4000,
      "renew-timer": 1000,
      "rebind-timer": 2000,

      "interfaces-config": {
        "interfaces": [ ]
      },

      "lease-database": {
        "type": "memfile",
        "persist": true,
        "name": "/var/kea/dhcp6.leases"
      },

      "subnet6": [ ],
    "control-socket": {
      "socket-type": "unix",
      "socket-name": "/tmp/kea-dhcp6-ctrl.sock"
    }
  },

  "Logging": {
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

## High Availability Configuration

To create a high availability hot standby DHCP cluster, do the following.

Edit the file `/usr/local/etc/kea/kea-ctrl-agent.conf`.  Change the lines:

```json
{
  "http-host": "10.1.1.1",
  "http-port": 8080,
}
```

To reflect the system internal IP address.  Confirm that the agent API is working with:

```bash
http_proxy= curl -X POST -H "Content-Type: application/json" -d '{ "command": "config-get", "service": [ "dhcp4" ] }' http://10.1.1.1:8080/
```

You should see a dump of the DHCPv4 configuration.

Now add the following configuration to the `/usr/local/etc/kea/kea-dhcp4.conf` file:

```json5
  "hooks-libraries": [
    {
      "library": "/usr/local/lib/hooks/libdhcp_lease_cmds.so",
      "parameters": {}
    },
    {
      "library": "/usr/local/lib/hooks/libdhcp_ha.so",
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

Hot standby is used instead of load balancing because it does not require splitting the pool of IP addresses into two groups with different DHCP *classes*, and is simpler to administer.  Ensure that `this-server-name` is set to `server1` or `server2` as appropriate.

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

```
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