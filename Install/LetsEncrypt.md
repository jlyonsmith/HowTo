# Installing Let's Encrypt for SSL Certificates

Let's Encrypt is a free SSL certificate authority that supports the ACME verification protocol. You can use any certificate daemon software with it. [EFF's Certbot](https://certbot.eff.org) is recommended.

## Installing Certbot on Ubuntu

Run:

```
sudo apt install software-properties-common
sudo apt-add-repository ppa:certbot/certbot
sudo apt update
sudo apt install certbot
```

## Generating Certificates with Nginx

To install the Nginx verification plugin:

```
sudo apt install python-certbot-nginx
```

Set up an A record in the DNS for `<domain>`.

With the `nginx` service installed and running:

```
certbot certonly --nginx -d <domain>
```

If all is well, the certificate will be in `/etc/letsencrypt/live`. `fullchain.pem` is the the certificate. `privkey.pem` is the key for `nginx` configuration.

## Generating Certificates with Route53

Read about using [AWS Route53 plugin](https://certbot-dns-route53.readthedocs.io/en/stable/) to verify domains.

## Certificate Renewal

To renew all certificates nearing expiration:

```
certbot renew
```

Run this command daily or weekly. Add to `crontab` with:

```
sudo vi /etc/crontab
```

Then add:

```
30 9  * * 1 root  /usr/bin/certbot renew --quiet
```

Check the log at `/var/log/letsencrypt/letsencrypt.log` to see that certificates are being checked and renewed.

## Revoke and Delete a Certificate

When no longer needed:

```
certbot revoke --cert-path /etc/letsencrypt/live/<domain>/cert.pem
certbot delete --cert-name <domain>
```

## Moving Certificates to Another Machine

First, move the files to a holding location and change their permissions and zip:

```
sudo rsync -az --perms --progress /etc/letsencrypt ~/letsencrypt
sudo chown -R $USER:$USER ~/letsencrypt
zip --symlinks -r letsencrypt.zip letsencrypt/*
```

Now, pull it onto your client and push back to new system:

```
scp $OLD_SYSTEM:letsencrypt.zip
scp letsencrypt.zip $NEW_SYSTEM:
```

Unzip on new host, move into new location, set permissions:

```
unzip letsencrypt.zip
sudo mv letsencrypt/ /etc/
sudo chown -R root:root /etc/letsencrypt
```

Test with `sudo certbot certificates` and `sudo certbot --dry-run`.

Note that installing `certbot` installs as `systemd` timer that runs twice a day to renew certificates.
