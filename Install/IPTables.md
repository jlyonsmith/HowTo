# Install `iptables`

`iptables` is the built-in firewall on Ubuntu, Debian and CentOS.

Heres a handy diagram to understand how it works:

![iptables](./IPTables/iptables.png)

Each colored box is a _table_, each gray box is a _chain_.

> When messing with IPTables configuration, it's a good idea to stop the `fail2ban` service if it's running or you may find yourself locked out.

## Ubuntu/Debian

`iptables` is installed by default on Debian. Also, `iptables` do not persist on Ubuntu by default. You **must** add a persistence mechanism as an extra step.

Remove any old mechanism for persistences:

```sh
apt remove iptables-persistent netfilter-persistent
```

Place your rules in `/etc/iptables.rules`, then:

```bash
cat << EOF | sudo tee /etc/systemd/system/iptables-restore.service
[Unit]
Description=Apply iptables rules
After=network.target

[Service]
Type=oneshot
ExecStart=/bin/sh -c 'iptables-restore -w 15 /etc/iptables.rules'
RemainAfterExit=true
ExecStop=/bin/sh -c 'iptables -F; iptables -X'
StandardOutput=journal

[Install]
WantedBy=multi-user.target
EOF
```

Then `systemctl enable iptables-restore` and `systemctl start iptables-restore`.

NOTE: The retry `-w 15` option is useful on systems where other services like `fail2ban` are also setting the IPTables.

## CentOS

`iptables` are persistent by default.

## Debugging

You can use:

```bash
sudo netstat -peanut
```

To see what ports are listening and the network activity that is occurring.

You can check IPTables when changing with:

```sh
iptables-restore --test
```

Debugging IPTables can be tricky.  To see each rule and how many times it has matched, do:

```sh
sudo iptables -L -v
```

## Commands

See [How to List and Delete iptables Rules](https://www.digitalocean.com/community/tutorials/how-to-list-and-delete-iptables-firewall-rules)

### Git Line Numbers

```sh
iptables -L --line-numbers
```

### Delete by Position

```sh
iptables -D $CHAIN $POS
```
