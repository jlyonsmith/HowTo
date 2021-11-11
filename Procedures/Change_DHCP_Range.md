# How to Change DHCP IP Address Range

## Status Quo

Let's say your network is:

```txt
 Lower IP: 192.168.1.0
 Upper IP: 192.168.255
     CIDR: 192.168.1.0/24
Router IP: 192.168.1.1
```

You want to change it to:

```txt
 Lower IP: 192.168.0.0
 Upper IP: 192.168.3.25
     CIDR: 192.168.0.0/22
Router IP: 192.168.0.1
```

You can use the CIDR calculator at [CIDR.xyz](https://cidr.xyz/) to calculate usable ranges.

Let's assume you have the following running on your router or load balancer:

- Ubuntu system using NetPlan
- Kea DHCP
- Bind9 DNS

On the router machine:

- Update the `/etc/kea/kea-dhcp4`.  Change the router address in the `option-data`, the `subnet4` data and any `reservations`.  Read the [Fine Tuning DHCP4 Host Reservation](https://kea.readthedocs.io/en/latest/arm/dhcp4-srv.html?highlight=reservations#fine-tuning-dhcpv4-host-reservation) section of the Kea manual.
- Update the `/etc/bind/db.*` reverse IP look up files.  Update the `/etc/bind/zones/*` files with the new reservation numbers. Update the server configuration files `/etc/bind/named.conf`, etc..
- Update the `/etc/netplan/*` file with the address of the router.
- Update your local `~/.ssh/config` file with the new address of the router
- Update `/etc/nginx/*` with the new IP address of the router.
- Update an IP addresses in `/etc/iptables.rules`

Then do the following steps:

1. Shut down all devices with reservations
2. Restart the router
3. Check `named`, `isc-kea-dhcp4-server`, `nginx`, etc. all restarted
4. Restart all devices with reservations and ensure they have the desire IP
5. Ensure DNS is working for all reserved addresses
