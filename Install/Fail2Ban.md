# Install Fail2Ban

```bash
apt install fail2ban
systemctl enable fail2ban
systemctl start fail2ban
```

## For ProxMox

Create `/etc/fail2ban/jail.d/proxmox.conf`:

```conf
[proxmox]
enabled = true
port = https,8006
filter = proxmox
logpath = /var/log/daemon.log
maxretry = 3
# 5 mins
bantime = 300
```

Create `/etc/fail2ban/filter.d/proxmox.conf`:

```conf
[Definition]
failregex = pvedaemon\[.*authentication failure; rhost=<HOST> user=.* msg=.*
ignoreregex =
```

Run `fail2ban-regex /var/log/daemon.log /etc/fail2ban/filter.d/proxmox.conf` and ensure at least 1 failure.

Restart with `systemctl restart fail2ban`.
