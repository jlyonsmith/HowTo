# Wordpress Bitnami Servers

## Check Service Status

The [Start Or Stop Services](https://docs.bitnami.com/aws/faq/administration/control-services/) page indicates:

```
sudo /opt/bitnami/ctlscript.sh status
```

to see server statuses.

## Update SSL Certificates

The Apache SSL certificate and key are in the directory `/opt/bitnami/apache2/conf` in the `server.crt` and `server.key` files.

## Certificates

Certificates and keys are often in in `/opt/bitnami/apps/wordpress/conf/certs`.
