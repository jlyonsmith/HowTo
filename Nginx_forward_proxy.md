# Installing Tengine as a Forward Proxy

These are the instructions for installing `nginx` as a forward proxy.

The machine hosting the forward proxy server must:

- Have access to internet
- Have NIC on internal network

These instructions were tested on Ubuntu.

## Installation

First, to build and install `nginx` follow the instructions at [`nginx` Forward Proxy Build Script](https://github.com/jlyonsmith/nginx-build-fproxy).

Next, replace the default `/etc/nginx/nginx.conf` file with:

```
worker_processes 1;

error_log /var/log/nginx/error.log info;

pid /run/nginx.pid;

events {
  worker_connections 1024;
}

http {
  include mime.types;
  default_type application/octet-stream;
  sendfile on;
  keepalive_timeout 65;

  server {
    listen 3128;
    # DNS Resolver to use - disable i
    resolver 127.0.0.53 ipv6=off;

    # Forward proxy for CONNECT requests
    proxy_connect;
    proxy_connect_allow 443;
    proxy_connect_connect_timeout 10s;
    proxy_connect_read_timeout 10s;
    proxy_connect_send_timeout 10s;

    # Forward proxy for non-CONNECT request
    location / {
      proxy_pass http://$host;
      proxy_set_header Host $host;
    }
  }
}

stream {
  upstream ssh {
    server bitbucket.org:22;
  }

  server {
    listen 1080;
    resolver 127.0.0.53;
    proxy_pass ssh;
  }
}
```

Now, open the appropriate firewall ports:

```

sudo ufw allow in from 192.168.0.0/16 to any port 3128
sudo ufw allow in from 192.168.0.0/16 to any port 1080

```

Start the proxy with `sudo systemctl start nginx` and then `sudo systemctl status nginx`.

## Through the Proxy

### SSH

To use SSH through the proxy you must use the `ProxyCommand` option and the `nc` tool to tunnel through port 1080 on the proxy:

```bash
ssh -v -o ProxyCommand='nc -X connect -x <proxy-ip-and-port> bitbucket.org 22' git@bitbucket.org
```

### NPM

`npm` should work with the `https_proxy` environement set. You can also do:

```
npm config set proxy $http_proxy
npm config set https-proxy $https_proxy
```

### APT

`apt` should respect the `http_proxy` environment. You can also add to `/etc/apt/apt.conf`:

```
Acquire::http::Proxy "http://<proxy-address>:<proxy-port>";
Acquire::https::Proxy "http://<proxy-address>:<proxy-port>";
```

## References

- [How to Use Git Through a Proxy](http://cms-sw.github.io/tutorial-proxy.html)
- [How to Setup NPM Behind a Proxy](https://jjasonclark.com/how-to-setup-node-behind-web-proxy/)
