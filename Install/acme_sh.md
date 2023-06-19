# Install acme.sh for Let's Encrypt

## Install

```sh
wget -O - https://get.acme.sh | sh -s email=my@example.com
```

## Get a Standalone Certificate

Set `DOMAIN` to your FQDN.  Assuming `iptables` is running, get a standalone certificate (run as `root`):

```bash
sudo -s
cd ~
/root/.acme.sh/acme.sh --issue -d $DOMAIN --standalone \
  --pre-hook "iptables -I INPUT -p tcp --dport 80 -j ACCEPT" \
  --post-hook "iptables -D INPUT -p tcp  --dport 80 -j ACCEPT"
```

## Install to ProxMox

```bash
/root/.acme.sh/acme.sh  --installcert  -d $DOMAIN \
  --certpath /etc/pve/local/pveproxy-ssl.pem \
  --keypath /etc/pve/local/pveproxy-ssl.key \
  --capath /etc/pve/local/pveproxy-ssl.pem \
  --reloadcmd "systemctl restart pveproxy"
```

See [Using acme.sh with nginx | rmed](https://www.rmedgar.com/blog/using-acme-sh-with-nginx/).
