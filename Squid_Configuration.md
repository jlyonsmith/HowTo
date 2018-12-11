# Squid Configuration

Squid is a caching proxy. It can be used to allow internal systems behind a firewall to access the Internet. Primarily this will be for the HTTP/HTTPS protocols. You typically want to proxy:

- `apt` installs
- `npm` installs
- The Userify `shim`

## Installing

On Ubuntu 18.04 or above:

```bash
sudo apt install squid
sudo systemctl enable squid
```

#Configuration

Overwrite the file `/etc/squid/squid.conf` with these contents:

```
http_port 127.0.0.1:3128

acl manager proto cache_object
acl localhost src 127.0.0.0/32
acl safe_ports port 80 21 443
acl ssl_ports port 443
acl connect method CONNECT
acl mynetwork src 192.168.0.0/16

http_access allow manager localhost
http_access deny manager
http_access allow safe_ports
http_access deny !safe_ports
http_access deny connect !ssl_ports
http_access allow localhost
http_access allow mynetwork
http_access deny all
```

What this file does:

- Installs a forward proxy at `127.0.0.1` port `3128`. To install a proxy that is visible inside the firewall, use the IP address of the _internal_ NIC.
- Configures a bunch of _access control lists_
- Sets up `http_access` rules for HTTP access to the proxy using the ACL's. These rules are processed top-to-bottom to determine if a give access is allowed.

## Additional Configuration

The above configuration should be all that is needed for most configurations, but it can be extended with:

- Ubuntu IP addresses
- `npm` IP addresses
- Userify addresses

Also, you can configure the `squid` cache to cache things like `npm` packages and get significant performance improvement when installing multiple backend machines.

## Usage With Userify

To configure [Userify](https://userify.com) to use the proxy correctly, after running the shim installation script, edit the file `/etc/rc.local` and modify the line that runs `shim.sh` to read:

```
https_proxy=http://localhost:3128 /opt/userify/shim.sh &
```

This will ensure that both `curl` and the Python script use the proxy. Also, note that use must set the use `https_proxy` environment variable, lower case, and that the proxy must be an `http:` address, _not_ `https:`.

## References

- [Squid HTTPS Configuration](https://wiki.squid-cache.org/Features/HTTPS)
- [How to Configure Squid to Support HTTPS](https://stackoverflow.com/questions/13151192/how-to-configure-https-support-in-squid3)
- [Ubuntu Squid Documentation](https://help.ubuntu.com/community/Squid)
