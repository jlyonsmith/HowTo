# Installing Countly

## Installation

Run:

On Ubuntu, follow [Installing the Countly Server](https://support.count.ly/hc/en-us/articles/360036862332-Installing-the-Countly-Server):

```sh
sudo -s
cd /opt
wget -qO- http://c.ly/install | bash
```

Installation and process logs are in `/opt/countly/log`.

Go to the server http://<PUBLIC_IP_ADDRESS>/setup to create first Global Administrator account.

Using the [`acme.sh`](https://github.com/acmesh-official/acme.sh) script is the easiest way to manage certificate generation & renewal.

Use `nginx` as the proxy and use the following config:

```nginx
server {
  listen 80;
  listen [::]:80;
  server_name countly.myserver.com;

  # access_log  off;

  location /.well-known/acme-challenge/ {
    root /var/www/letsencrypt-webroot;
  }

  location / {
    return 301 https://$host$request_uri;
  }
}

server {
  listen 443 ssl http2;
  listen [::]:443 ssl http2;
  server_name countly.myserver.com;

  # access_log off;

  ssl_protocols TLSv1.2;
  ssl_prefer_server_ciphers on;
  ssl_ciphers 'kEECDH+ECDSA+AES128 kEECDH+ECDSA+AES256 kEECDH+AES128 kEECDH+AES256 kEDH+AES128 kEDH+AES256 DES-CBC3-SHA +SHA !aNULL !eNULL !LOW !kECDH !DSS !MD5 !EXP !PSK !SRP !CAMELLIA !SEED';
  ssl_session_cache builtin:1000 shared:SSL:10m;
  ssl_stapling on;
  ssl_certificate /root/.acme.sh/countly.myserver.com_ecc/fullchain.cer;
  ssl_certificate_key /root/.acme.sh/countly.myserver.com_ecc/countly.myserver.com.key;

  location = /i {
    proxy_pass http://localhost:3001;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Real-IP $remote_addr;
  }

  location ^~ /i/ {
    proxy_pass http://localhost:3001;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Real-IP $remote_addr;
  }

  location = /o {
    proxy_pass http://localhost:3001;
  }

  location ^~ /o/ {
    proxy_pass http://localhost:3001;
  }

  location / {
    proxy_pass http://localhost:6001;
    proxy_set_header Host $http_host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Real-IP $remote_addr;
  }
}
```

## Setting Up MongoDB

If you will be using MongoDB on another server:

 1. Setup MongoDB on another server using https://c.ly/install/mongodb
 2. Secure your MongoDB server: https://support.count.ly/hc/en-us/articles/360037445752-Securing-MongoDB
 3. Follow this instruction to point Countly to your MongoDB server https://support.count.ly/hc/en-us/articles/360037814871-Configuring-Countly

Additionally you can:

[Secure your server](https://support.count.ly/hc/en-us/articles/360037816431-Configuring-HTTPS-and-SSL) by configuring HTTPS with your certificate. Or use [Let’s encrypt to generate certificate](https://support.count.ly/hc/en-us/articles/360037816491-Installing-Let-s-Encrypt-for-HTTPS).

Familiarize yourself with [Countly command line](https://support.count.ly/hc/en-us/articles/360037444912-Countly-command-line)

Check out [troubleshooting guide](https://support.count.ly/hc/en-us/articles/360037816811-Troubleshooting) if you run into any problems.

## Upgrading

> You musting upgrade monotonically and without skipping versions.  If you need to upgrade multiple versions run the upgrade scripts for previous versions in sequence.

First, determine the version you are running with `jq .version /opt/countly/package.json`.

Download the current version:

```fish
wget -nv (wget -qO- https://api.github.com/repos/countly/countly-server/releases/latest | grep tarball_url | head -n 1 | cut -d '"' -f 4) -O ./countly.tar.gz
chown -R countly:countly countly.tar.gz
tar zxvf countly.tar.gz -C countly --strip-components 1
rm countly.tar.gz
```

Then run the upgrade script:

```sh
cd /opt/countly/bin/upgrade/$VERSION
bash upgrade.sh
```
