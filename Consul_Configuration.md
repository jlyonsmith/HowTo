# Consul Configuration

## Basic

Ensure that `consul` is installed and running. The best approach for this is to use Ansible. Ensure that the `/etc/consul/config.json` file contains the line:

```
{
  ...
  "node_name": "<node-name>",
  ...
}
```

If you do not set this specifically, the node will have the same name as the value of `/etc/hostname`.

## DNS

You want to configure an Ubuntu 18.04 system running on EC2 to use consul to resolve `.consul` top level domain names.

If the `consul` process is running on a system, it provides DNS on port `8600`. You can test this as follows:

```
dig @127.0.0.1 -p 8600 <hostname>.node.consul
```

This should resolve with the A record of the localhost. In order to have all DNS lookups use `consul` we need to re-configure the DNS on the Ubuntu system. The approach we take is to use the `dnsmasq` DNS/DHCP software as a bridge to the `consul` DNS server.

First, install `dnsmasq`:

```
sudo apt update
sudo apt install dnsmasq
```

Check that the `dnsmasq` service is running:

```
sudo systemctl status dnsmasq
```

Next, create a `/etc/dnsmasq.conf` file:

```
port=53
domain-needed
no-resolv
no-poll
strict-order
server=/consul/127.0.0.1#8600
server=127.0.0.53
expand-hosts
domain=us-west-2.compute.internal
interface=lo
listen-address=127.0.0.1
no-dhcp-interface=lo
bind-interfaces
#log-queries
```

What this config is doing is setting `dnsmasq` to run on the loopback `lo` interface, at address `127.0.0.1`. Any DNS requests for `.consul` domains will go to the `consul` service running at `127.0.0.1:8600`. All other domain name requests go to the default DNS service configured by DHCP on the system at `127.0.0.53:53`.

Check that `dnsmasq` is running with:

```
ss -ltp
```

This will show all the processes listening and which ports they are listening on.

The final step is to tell Ubuntu's built-in DNS/DHCP service `systemd-resolved` to pass DNS requests first to `dnsmasq` for resolution.
Edit the file `/etc/dhcp/dhclient.conf` to prepend `127.0.0.1:53` into the list of DNS servers it gets back from DHCP. Ensure the following line appears in the file:

```
...
prepend domain-name-servers 127.0.0.1;
...
```

NOTE: On EC2/Ubuntu 18.04 `/etc/resolv.conf` is sym-linked on a clean install. It _may_ update automatically when the `dhclient.conf` file is updated. If _NOT_, you must also include this as a valid nameserver in the _top_ of the file `/etc/resolv.conf`:

```
nameserver 127.0.0.1
...
```

Run `sudo systemctl restart dnsmasq`.

Now check you can resolve both `.consul` names and others:

```
dig <node-name>.node.consul
dig ubuntu.com
```

See the following links for more background:

- [Forwarding DNS to Consul](https://www.consul.io/docs/guides/forwarding.html)
- [Consul DNS Interface](https://www.consul.io/docs/agent/dns.html)
- [Install and Configure Dnsmasq on Ubuntu 18.04](https://computingforgeeks.com/install-and-configure-dnsmasq-on-ubuntu-18-04-lts/)
- [Dnsmasq Ubuntu Documentation](https://help.ubuntu.com/community/Dnsmasq)
- [Dnsmasq Install Script](https://github.com/hashicorp/terraform-aws-consul/tree/master/modules/install-dnsmasq)
