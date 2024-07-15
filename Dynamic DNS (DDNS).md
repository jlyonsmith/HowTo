
## Installation

Install:

- [[Kea DHCP]]
- [[Bind9]]

Then:

```sh
sudo -Es
cd /etc/bind
tsig-keygen ddns > ddns.key
chmod u=rw,g=r,o= ddns.key
ls -l ddns.key
cat ddns.key
```

Ensure file is owned by `root:bind` and has permissions `-rw-r--r--`.

We need to place dynamic zone files to a directory that is writable, `/var/lib/bind`  and leave static readonly zones in `/etc/bind` 

```sh
cd /var/lib/bind
touch db.sea1.example.com
touch db.192.168
chown -R root:bind *
```

Now save the local zones file:

```sh
cd /etc/bind
cp named.conf.local named.conf.local.old
```

Edit `named.conf.local` to contain:

```conf
include "/etc/bind/ddns.key";

zone "sea1.example.com" {
  type master;
  file "/var/lib/bind/db.sea1.example.com";
  update-policy {
    grant ddns wildcard *.example.com A DHCID;
  };
};

zone "168.192.in-addr.arpa" {
  type master;
  file "/var/lib/bind/db.192.168";
  update-policy {
    grant ddns wildcard *.168.192.in-addr.arpa PTR DHCID;
  };
};
```

We are using `include` for the key file so it can have tighter file security.

Test everything out and restart DNS:

```bash
named-checkconf
named-checkzone sea1.example.com /var/lib/bind/db.sea1.example.com
named-checkzone 168.192.in-addr.arpa /var/lib/bind/db.192.168
systemctl restart named
systemctl status named
```

Install DDNS:

```bash
apt update
apt install isc-kea-dhcp-ddns-server -y
```

Edit `/etc/kea/tsig-keys.json`:

```json
"tsig-keys": [
    {
       "name": "ddns",
       "algorithm": "hmac-sha256",
       "secret": "..."
    }
],
```

Adding the `secret` from the `/etc/bind/dhcp1-n1.key` file.

```bash
chown _kea:root tsig-keys.json
chmod u=rw,g=r,o= tsig-keys.json
```

Now edit `/etc/kea/kea-dhcp-ddns.conf`:

```json
{
  "DhcpDdns": {
    "ip-address": "127.0.0.1",
    "port": 53001,
    "control-socket": {
      "socket-type": "unix",
      "socket-name": "/tmp/kea-ddns-ctrl-socket"
    },

    <?include "/etc/kea/tsig-keys.json"?>

    "forward-ddns": {
      "ddns-domains": [
        {
          "name": "sea1.example.com",
          "key-name": "ddns",
          "dns-servers": [{ "ip-address": "192.168.1.1" }]
        }
      ]
    },

    "reverse-ddns": {
      "ddns-domains": [
        {
          "name": "192.168.in-addr.arpa.",
          "key-name": "ddns",
          "dns-servers": [{ "ip-address": "192.168.1.1" }]
        }
      ]
    },
    "loggers": [
      {
        "name": "kea-dhcp-ddns",
        "output_options": [
          {
            "output": "/var/log/kea/kea-dhcp-ddns.log"
          }
        ],
        "severity": "INFO"
      }
    ]
  }
}
```

Then test and restart:

```bash
kea-dhcp-ddns -t kea-dhcp-ddns.conf
systemctl enable isc-kea-dhcp-ddns-server
systemctl restart isc-kea-dhcp-ddns-server
systemctl status isc-kea-dhcp-ddns-server
```

The final step is to enable DDNS in the DHCP server.  Edit `/etc/kea/kea-dhcp4.conf`:

```json
     "dhcp-ddns": {
        "enable-updates": true
     },
     // These can go in the subnet section if you want
     "ddns-qualifying-suffix": "homelab.lan",
     "ddns-override-client-update": true,
```

Now test and restart:

```bash
kea-dhcp4 -t /etc/kea/kea-dhcp4.conf
systemctl restart isc-kea-dhcp4-server
systemctl status isc-kea-dhcp4-server
```
## References

- [Kea documentation](https://kea.readthedocs.io/en/latest/arm/intro.html)
- [How to Setup Dynamic DNS (DDNS) Using Kea and Bind on Debian or Ubuntu](https://www.techtutorials.tv/sections/linux/how-to-setup-ddns-using-kea-and-bind)
- [Why Doesn't Kea Update My DNS?](https://kb.isc.org/v1/docs/en/why-doesnt-my-dns-get-updated-by-kea)
