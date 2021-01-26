# Install `nginx` on macOS

Install `nginx`:

```bash
brew install nginx
nginx -?
```

Go into super user mode:

```bash
sudo -s
```

Create a `launchctl` file

```bash
edit /Library/LaunchDaemons/homebrew.mxcl.nginx.plist
```

Paste the following into the file:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>homebrew.mxcl.nginx</string>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <false/>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/local/opt/nginx/bin/nginx</string>
        <string>-g</string>
        <string>daemon off;</string>
    </array>
    <key>WorkingDirectory</key>
    <string>/usr/local</string>
  </dict>
</plist>
```

Create a log file directory:

```bash
mkdir -p /usr/local/var/log/nginx
```

Now you can edit your configurations in the `/usr/local/etc/nginx/` directory.  Typically, place your various websites under the `conf.d/` sub-directory, SSL certificates and keys under `ssl/` and saved default files under `saved/`.

Create a simple `nginx.conf` file in this directory, removing all default websites:

```conf
user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

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
  ssl_protocols TLSv1.2 TLSv1.3; # Dropping SSLv3, ref: POODLE
  ssl_prefer_server_ciphers on;
  access_log /var/log/nginx/access.log;
  error_log /var/log/nginx/error.log;
  gzip on;
  include /etc/nginx/conf.d/*.conf;
  include /etc/nginx/sites-enabled/*;
}
```

Create the log directory:

```bash
mkdir /var/log/nginx
```

Lastly, restart `nginx` through launchctl to confirm all is working:

```bash
launchctl load /Library/LaunchDaemons/homebrew.mxcl.nginx.plist
```

## Debugging Port Usage

To check what process is using a port on macOS (after El Capitan) do:

```conf
lsof -i tcp:3000
```

## Common Nginx Configurations

Here are some common `nginx` configurations.  Place them in the `conf.d` directory under `/usr/local/etc/nginx` or `/etc/nginx`.

### HTTPS, React App, `/api` Endpoint

```conf
server {
  listen 443 ssl;
  server_name xyz.com;
  ssl_certificate /etc/nginx/ssl/xyz_com_chained.crt;
  ssl_certificate_key /etc/nginx/ssl/xyz_com.key;
  ssl_session_cache shared:SSL:1m;
  ssl_session_timeout 5m;
  ssl_ciphers HIGH:!aNULL:!MD5;
  ssl_prefer_server_ciphers on;

  #allow 67.183.189.74; # user1
  #allow 24.18.144.122; # user2
  #allow 24.16.120.178; # user3
  #allow 273.63.121.153; # user4
  #deny all;

  root /home/ubuntu/xyz/website/build;

  # Any route that starts with /api/ is for the backend
  location /api/ {
    proxy_pass http://127.0.0.1:3001/;
    proxy_buffering off;
    proxy_redirect off; # API's shouldn't redirect
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade"; # Support WebSocket upgrading
    proxy_http_version 1.1;
    proxy_set_header X-Forwarded-Host $host;
    proxy_set_header X-Forwarded-Server $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  }

  # Any route containing a file extension just return or fail
  location ~ ^.+\..+$ {
      try_files $uri =404;
  }

  # Any route that doesn't have a file extension is an app route
  location / {
    try_files $uri $uri/ /index.html;
  }
}
```

### Redirect HTTP to HTTPS

```conf
server {
  listen 80;
  server_name <your-domain>

  return 301 https://$host$request_uri;
}
```

### Configure Reverse Proxy

Use the following as a base for setting up reverse proxying:

```conf
server {
  listen 80;
  server_name api.tsonspec.org;
  location /v1/ {
    valid_referers tsonspec.org;

    if ($invalid_referer) {
      return 403;
    }

    proxy_pass http://127.0.0.1:1340/;
    proxy_buffering off;
    proxy_redirect off;
    proxy_set_header X-Forwarded-Host $host;
    proxy_set_header X-Forwarded-Server $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  }
}
```

This sets up a proxy for `http://api.tsonspec.org/v1/` to redirect to a service running on `http://localhost:1340/` and only allows access from the domain `tsonspec.org`.

### Configure SSL/HTTPS Site

Create a `/etc/nginx/ssl` directory.  Copy the `mydomain_com_chained.crt` and `api_mydomain_com.key` files into it.

Use the following file to configure the HTTPS site in `/etc/nginx/conf.d`:

```conf
server {
  listen 443 ssl;
  server_name api.xyz.com;
  ssl_certificate /etc/letsencrypt/live/<domain>/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/<domain>/privkey.pem;

  ssl_session_cache shared:SSL:1m;
  ssl_session_timeout 5m;

  ssl_ciphers HIGH:!aNULL:!MD5;
  ssl_prefer_server_ciphers on;

  location /v1/ {
    proxy_pass http://localhost:1337/;
    proxy_buffering off;
    proxy_redirect off;
    proxy_set_header X-Forwarded-Host $host;
    proxy_set_header X-Forwarded-Server $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  }
}
```

### Configure AngularJS App

A web server for serving AngularJS with # rewriting.

```conf
server {
  server_name admin.xyz.com;
  location / {
    # allow 207.118.87.34;
    # deny all;
    root /home/ubuntu/Admin;
    index index.html;

    # Redirect any non-resource specific requests so that AngularJS can handle them
    rewrite "^(/(?!\#/)[^\.]+?(?!\..+))$" /#$1 redirect;
  }
}
```

### Configure Server Side App

Assuming a web server running on `localhost:2012`.

```conf
server {
  server_name whoami.xyz.com;

  location / {
    proxy_pass http://localhost:2012/;
    proxy_buffering off;
    proxy_redirect off;
    proxy_set_header X-Forwarded-Host $host;
    proxy_set_header X-Forwarded-Server $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  }
}
```
