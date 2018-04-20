# Using Let's Encrypt for SSL Certificates

Let's Encrypt is a free SSL certificate authority that supports the ACME verification protocol. You can use any certificate daemon software with it. [EFF's Certbot](https://certbot.eff.org) is recommended.

## Installing Certbot on Ubuntu 16.04 for nginx

Run:

```
sudo apt-get update
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install python-certbot-nginx 
```

## Generating Certificates

Set up an A record in the DNS for `<domain>`.

With the nginx service installed and running:

```
certbot certonly --nginx -d <domain>
```

If all is well, the certificate will be in `/etc/letsencrypt/live`.  `fullchain.pem` is the the certificate.  `privkey.pem` is the key for `nginx` configuration.

## Certificate Renewal

To renew all certificates nearing expiration:

```
certbot renew
```

Run this command daily or weekly.  Add to `crontab` with:

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
