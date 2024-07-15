## Overview

[Bind9](https://www.isc.org/bind/) is a popular DNS server created by the Internet Systems Consortium (ISC)

## Details

Add the PPA for the latest ISC Bind9 package and install `bind9`:

```sh
sudo add-apt-repository ppa:isc/bind
sudo apt update
sudo apt install bind9 bind9utils bind9-doc
```

> If you are only using IPv4 configure that in the environment for the `named` service.  Edit `/etc/default/named` to contain `OPTIONS="-u bind -4"`.

> In version 9.18.11-1 I had to set `Type=forking` and remove the `-f` to get `systemd` to see the service as active.

Record what your ISP assigned "nameservers" are with `cat /etc/resolv.conf`. 

Edit `/etc/bind` and edit `named.conf.options` and edit it to look like:

```conf
acl "trusted" {
  192.168.0.0/24; // Your local IPv4 domain
  fc00::/8; // Your local IPv6 domain
  localhost;
  localnets;
};

options {
  directory "/var/cache/bind";

  recursion yes;
  allow-query { trusted; };
  allow-transfer { none; }; // disable zone transfers

  forwarders { 
    // Any ISP provided nameservers (see above)
    // OR the Cloudflare DNS providers...
    1.1.1.1;
    1.0.0.1;
    2606:4700:4700::1111;
    2606:4700:4700::1001;
  };

  dnssec-validation yes;

  listen-on { any; };
  listen-on-v6 { any; };

  auth-nxdomain no; // conform to RFC1035
};
```

Run `named-checkconf` and ensure there are no errors.  Then restart the service with `sudo systemctl restart named`.

## Testing Configuration

Go to another machine on the local network and run:

```sh
dig @192.168.0.2 google.com a
dig -6 @fc00::1 google.com aaaa
```

and you should get an A and AAAA record for Google from the local server.

## Adding Zones

Let's say that we have a host with an internal IPv4 address of `192.168.1.1/24` and we want it to correspond to the DNS name `host1.local.example.com`.  First we create a _forward zone_ entry for the `local.example.com` domain.

```sh
sudo -Es
cd /etc/bind
touch /etc/bind/db.local.example.com
chown bind:bind /etc/bind/db.local.example.com
```

 Add these contents to the forwarding zone:

```zone
$TTL  3600
$ORIGIN local.example.com.

@     IN SOA host1.local.example.com. admin.local.example.com. (
             1 ; serial
             8h ; refresh
             2h ; retry
             4w ; expire
             1d ) ; minimum
@         IN NS  host1.local.example.com.
host1    60 IN A   192.168.1.1
```

Next, you add a _reverse zone_ for the domain:

```sh
sudo -Es
touch /etc/bind/db.192.168.1
chown bind:bind /etc/bind/db.192.168.1
```

and add these contents:

```zone
$TTL 3600
$ORIGIN 1.168.192.in-addr.arpa.

@     IN SOA host1.local.example.com. admin.example.com. (
             1 ; serial
             8h ; refresh
             2h ; retry
             4w ; expire
             1d ) ; minimum
@     IN NS  host1.local.example.com.
1     IN PTR host1.local.example.com.
```

In both of the above the `@` symbol can be read as the `$ORIGIN` value.  

DNS records are very sensitive to syntax errors while at the same time the supported syntax is somewhat unconventional:

- Blank lines are ignored
- *Use spaces not tabs*; the number of spaces doesn't generally matter.
- `$ORIGIN` is optional and sets the FQDN for the zone; if not used then fully qualify all left side names on each record.
- Terminate all FQDN's with a period `.`
- `$TTL` is the default if new TTL is given on each record.
- Comments start with a semi-colon (`;`) and must be at the end of the line.
- Times without a suffix are in seconds; hours (`h`), minutes (`m`), days (`d`), weeks (`w`) suffixes can be used and are case sensitive.

> **IMPORTANT:** You must increment the `serial` value **every time you update a zone file**, or all downstream cached copies of this record will not be flushed.

Finally, update the `/etc/bind/named.conf.local` file:

```conf
zone "private.example.com" {
  type master;
  file "/etc/bind/zones/db.private.example.com";
};

zone "168.192.in-addr.arpa" {
  type master;
  file "/etc/bind/db.192.168";
};
```

Runs a check on the forward zone file:

```sh
named-checkzone xyz1.example.com zones/db.xyz1.example.com
```

Check the reverse zone file:

```sh
named-checkzone 168.192.in-addr.arpa db.192.168
```

If all is well (no errors are displayed), restart the service with `sudo systemctl restart named`.

### Utilizing the DNS Server Locally

You need to configure the DNS server in DHCP.  To pick up the DNS server on the local DNS server machine, you'll need to update the configured DNS.  

On older Debian systems you may need to update `/etc/resolve.conf`.

## Flush Cache on Linux Server

To dump the cache use:

```bash
rndc dumpdb -cache
```

To flush the cache:

```bash
rndc flush
```

And to reload the service:

```bash
rndc reload
```

## Flush DNS Cache on macOS

```bash
sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
```
