# Ubiquiti Unifi Controller

## Installation & Upgrade

Got to the [Unifi Downloads Page](https://www.ui.com/download/unifi/) click on the Ubuntu download icon and copy the link.

Then:

```sh
cd /tmp
wget https://dl.ui.com/unifi/6.0.28/unifi_sysvinit_all.deb
sudo dpkg -i unifi_sysvinit_all.deb
```

Unpack over the current version (if any).

Check the controller is running:

```sh
sudo systemctl status unifi
```

## Nginx Proxy

To get rid of the self signed certificate issue, put `nginx` in front of the controller.  NOTE: There are sites that describe how to enable SSL on the controller directly; it does not work.

```conf
map $http_upgrade $connection_upgrade {
    default upgrade;
    ''      close;
}

server {
    listen 192.168.0.1:80;
    # listen [::]:80 ipv6only=on;
    listen 192.168.0.1:443 ssl;
    # listen [::]:443 ipv6only=on ssl;

    server_name your-internal-domain.com;
    client_max_body_size 2G;

    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 5m;
    ssl_ciphers 'EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH';

    location / {
        proxy_pass https://localhost:8443;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
        proxy_buffering off;
    }

    # These are managed by certbot.
    ssl_certificate /etc/nginx/ssl/your-internal-domain.com.chained.crt;
    ssl_certificate_key /etc/nginx/ssl/your-internal-domain.com.key;
}
```

## References

- [UniFi - How to Set Up a UniFi Network Controller](https://help.ui.com/hc/en-us/articles/360012282453-UniFi-How-to-Set-Up-a-UniFi-Network-Controller)
- [User maintained upgrade script](https://get.glennr.nl)
- [Install Nginx proxy in front of UniFi Controller](https://blog.ljdelight.com/nginx-proxy-to-ubiquiti-unifi-controller/)
