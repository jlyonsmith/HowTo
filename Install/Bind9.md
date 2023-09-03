# Bind9 Installation

## Overview

[Bind9](https://www.isc.org/bind/) is a popular DNS server created by the Internet Systems Consortium (ISC)

## Details

Add the PPA for the latest ISC Bind9 package and install `bind9`:

```sh
sudo add-apt-repository ppa:isc/bind
sudo apt update
sudo apt install bind9 bind9utils bind9-doc
```

If you are only using IPv4 configure that in the environment for the `named` service.  Edit `/etc/default/named`:

```sh
#
# run resolvconf?
RESOLVCONF=no

# startup options for the server
OPTIONS="-u bind -4"
```

Here we are adding the `-4` to the `OPTIONS` environment variable.

> NOTE: In version 9.18.11-1 I had to set `Type=forking` and remove the `-f` to get `systemd` to see the service as active.

Now go to `/etc/bind` and edit `named.conf.options` and make it look like:

```conf
acl "trusted" {
  192.168.0.0/24; # Your local IPv4 domain
  2a02:842b:8ce6:2001::/64; # Your local IPv6 domain
  localhost;
  localnets;
};

options {
  directory "/var/cache/bind";

  recursion yes;
  allow-query { trusted; };
  allow-transfer { none; }; # disable zone transfers

  forwarders { # These are the Cloudflare IP addresses
    1.1.1.1;
    1.0.0.1;
    2606:4700:4700::1111;
    2606:4700:4700::1001;
  };

  dnssec-validation yes;

  listen-on { any; };
  listen-on-v6 { any; };

  auth-nxdomain no; # conform to RFC1035
};
```

Run `named-checkconf` and ensure there are no errors.  Then restart the service with `sudo systemctl restart named`.

## Testing Configuration

Go to another machine and run:

```sh
dig @192.168.0.2 linuxfoundation.org
dig -6 @192.168.0.2 linuxfoundation.org
```

and you should get an A record for the domain name from the local server.

## Adding Zones

Let's say that our internal network address is `192.168.1.1` and we want it to correspond to the domain `private.example.com`.  Let's say that our DNS server is on the machine `ns1`.  First we create a _forward zone_ entry.

```sh
sudo mkdir /etc/bind/zones
sudo vi /etc/bind/zones/db.private.example.com
```

Check the permissions on the directory & file to ensure that `root` is owner and `bind` is the group.  Add these contents to the forwarding zone:

```zone
$TTL  3600
$ORIGIN private.example.com.

@     IN SOA ns1.private.example.com. admin.private.example.com. (
             1 ; serial
             8h ; refresh
             2h ; retry
             4w ; expire
             1d ) ; minimum
@         IN NS  ns1.private.example.com.
ns1    60 IN A   192.168.1.1
```

Next, you can chose to add a _reverse zone_ for the domain. Create and edit a file for the zone, e.g.

```sh
sudo vi /etc/bind/db.192.168.1
```

and add these contents:

```zone
$TTL 3600
$ORIGIN 1.168.192.in-addr.arpa.

@     IN SOA ns1.private.example.com. admin.example.com. (
             2 ; serial
             8h ; refresh
             2h ; retry
             4w ; expire
             1d ) ; minimum
@     IN NS  ns1.private.example.com.
1     IN PTR ns1.private.example.com.
```

In both of the above the `@` symbol can be read as the `$ORIGIN` value.  DNS records are _very_ sensitive to syntax errors, and at the same time somewhat loose.

- Blank lines are ignored
- Use spaces not tabs, but the number of spaces doesn't generally matter.
- **IMPORTANT:** You must increment the _serial_ value **every time you update a zone file**, or all downstream cached copies of this record will not be flushed.
- `$ORIGIN` is optional and sets the FQDN for the zone; if not used then fully qualify all left side names on each record.
- Be sure to terminate all FQDN's with a period.
- `$TTL` is the default if new TTL is given on each record.
- Comments noted with semi-colon (`;`) must be at the end of the line.
- By default times are in seconds. Hours (`h`), minutes (`m`), days (`d`), weeks (`w`) suffixes can be used and are case sensitive.

Runs a check on the forward zone file:

```sh
named-checkzone xyz1.example.com zones/db.xyz1.example.com
```

Check the reverse zone file:

```sh
named-checkzone 168.192.in-addr.arpa db.192.168
```

If all is well (no errors are displayed), restart the service with `sudo systemctl restart named`.

## Flush Cache on Server

To dump the cach use:

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
