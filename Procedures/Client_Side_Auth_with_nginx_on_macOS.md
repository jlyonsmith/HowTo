## Pre-requisites

This how-to is based on [Securing Websites With Nginx And Client-Side Certificate Authentication On Linux](https://arcweb.co/securing-websites-nginx-and-client-side-certificate-authentication-linux/)

Install OpenSSL with [homebrew](http://brew.sh).  Install and configure Nginx (> v1.8.7).

## Configuring OpenSSL

Do the following:

```bash
cd /usr/local/etc/openssl
vi openssl.cnf
```

Change the following line:

```ini
...
[ CA_default ]
dir = /usr/local/etc/ssl		# Where everything is kept
...
```

Then:

```bash
mkdir -p /usr/local/etc/ssl/ca/certs/users && \
mkdir /usr/local/etc/ssl/ca/crl && \
mkdir /usr/local/etc/ssl/ca/private
touch /usr/local/etc/ssl/ca/index.txt && echo ’01’ > /usr/local/etc/ssl/ca/crlnumber
```
