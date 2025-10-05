## Overview

Caddy is a web server and reverse proxy service with much simpler configuration than `nginx`.  Caddy also manages certificates automatically, and so does not require installing a separate certification agent such as `certbot`.
## Installation

### Ubuntu/Debian 

```sh
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo chmod o+r /usr/share/keyrings/caddy-stable-archive-keyring.gpg
sudo chmod o+r /etc/apt/sources.list.d/caddy-stable.list
sudo apt update
sudo apt install -y caddy
```

Update `/etc/caddy/Caddyfile` with site details.

### Switching From `certbot`

Switching from Certbot to Caddy for certificate management and web serving involves a fundamental shift in how TLS certificates are handled and how your web services are delivered. Caddy's built-in automatic HTTPS and certificate management capabilities eliminate the need for external tools like Certbot and separate web server configurations (like Nginx or Apache for reverse proxying).

Disable `certbot` and `nginx`:

```sh
sudo systemctl stop certbot
sudo systemctl disable certbot.service
sudo systemctl disable certbot.timer
sudo systemctl stop nginx
sudo systemctl disable nginx
```
## References

- https://caddyserver.com/docs/running
- 