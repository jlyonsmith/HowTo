# Installing Tengine

These are the instructions for installing [Tengine](http://tengine.taobao.org/), an Nginx fork, which among other things can be used as a forward proxy.

These instructions assume the proxy machine has separate internal and external NIC cards.

The easiest way to build and install Tengine is using the [build-tengine](https://github.com/jlyonsmith/build-tengine) script.

## Forward Proxy

Tengine can be a forward proxy as well as a reverse proxy.  First, replace the default `/etc/nginx/nginx.conf` file with:

```conf
user www-data;
worker_processes auto;
pid /run/nginx.pid;
error_log /var/log/nginx/error.log;

events {
  worker_connections 768;
}

http {
  sendfile on;
  tcp_nopush on;
  tcp_nodelay on;
  keepalive_timeout 65;
  types_hash_max_size 2048;
  include /etc/nginx/mime.types;
  default_type application/octet-stream;
  ssl_protocols TLSv1.2 TLSv1.3;
  ssl_prefer_server_ciphers on;
  gzip on;
  access_log /var/log/nginx/access.log;

  include /etc/nginx/conf.d/*.conf;

  # HTTP Forward proxy
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

# HTTPS passthrough
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

Open the appropriate firewall ports if needed, e.g.:

```sh
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

```bash
npm config set proxy $http_proxy
npm config set https-proxy $https_proxy
```

### APT

`apt` should respect the `http_proxy` environment. You can also add to `/etc/apt/apt.conf`:

```conf
Acquire::http::Proxy "http://<proxy-address>:<proxy-port>";
Acquire::https::Proxy "http://<proxy-address>:<proxy-port>";
```

## References

- [How to Use Git Through a Proxy](http://cms-sw.github.io/tutorial-proxy.html)
- [How to Setup NPM Behind a Proxy](https://jjasonclark.com/how-to-setup-node-behind-web-proxy/)
