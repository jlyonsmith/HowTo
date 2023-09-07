# Installing ProxMox

This document describes how to install ProxMox on Debian 12 servers.

## Install on Debian 12

If using Hetzner, [use the Rescue O/S to install Debian](https://docs.hetzner.com/robot/dedicated-server/operating-systems/installimage/) adjusting for the most recent version of Debian.

- [Trajche Kralev](https://tj.mk/install-proxmox-4-hetzner-debian/)
- [Hetzner - Install and Configure Proxmox VE](https://community.hetzner.com/tutorials/install-and-configure-proxmox_ve)
- [How to setup Proxmox on dedicated Hetzner Server](https://www.indivar.com/blog/how-to-setup-proxmox-on-hetzner-dedicated-server/)
- [Install ProxMox VE on Debian 12 Booworm](https://pve.proxmox.com/wiki/Install_Proxmox_VE_on_Debian_12_Bookworm)


Install Google Authenticator for 2FA and [configure it in ProxMox](https://pve.proxmox.com/pve-docs/pve-admin-guide.html#pveum_tfa_auth).

Configure IPTables.

## Configure ProxMox SSL Certificates

ProxMox now comes with a built in ACME client for getting SSH certificates for the web interface. You can configure everything on the command line. We'll use the default authentication mechanism, `http-01` challenge.

Add a `default` ACME account, `pvenode acme account register default {{EMAIL}}` and answer the questions.  *You don't need the `staging` endpoint.*

Set the domain you want a cert for, `pvenode config set --acme domains={{FQDN}}`.

Order the cert, `pvenode acme cert order`.

### SSL References

- [Certificate Management](https://pve.proxmox.com/wiki/Certificate_Management)

## Fail2Ban

Install [fail2ban](https://pve.proxmox.com/wiki/Fail2ban).

Create `/etc/fail2ban/jail.d/proxmox.conf`:

```conf
[proxmox]

enabled = true

# Ports to be banned
port = https,8006

# Filter to use
filter = proxmox

# Ban action
banaction = iptables

# Filter backend
backend = systemd

# Maximum allowed retries
maxretry = 5

# Time to search for max retries
findtime = 30m

# Time to ban for
bantime = 10m
```

Create `/etc/fail2ban/filter.d/proxmox.conf`:

```conf
[Definition]
failregex = pvedaemon\[.*authentication (verification )?failure; rhost=<HOST> user=.* msg=.*
journalmatch = _SYSTEMD_UNIT=pvedaemon.service
```

Test with `fail2ban-regex -v systemd-journal proxmox`.

Then `systemctl restart fail2ban`.

## Create a Private IPv4 Network

### Network References

ProxMox will managed the `/etc/network/interfaces` file.  *After installing ProxMox, reboot to have it take over this file.*

- [Hetzner Network Configuratio Debian/Ubuntu](https://docs.hetzner.com/robot/dedicated-server/network/net-config-debian-ubuntu/)
- [this article](https://blog.jenningsga.com/private-network-with-proxmox/)
- [Proxmox 5 on Hetzner Root-Server with Dual-Stack IPv4/IPv6 for Host and Guests](https://www.sysorchestra.com/proxmox-5-on-hetzner-root-server-with-ipv4/)

Use the `pointopoint` IP address sharing approach not the NATS approach to give access to the public network.

> For LXC containers, networking is configured by ProxMox. You can find the network configuration files in `/etc/systemd/network/eth0.network`, etc..  If you change these files in the ProxMox UI they will change here without requiring a reboot.

Edit to `/etc/sysctl.conf`,

```conf
net.ipv4.ip_forward=1
net.ipv6.conf.all.forwarding=1
```

`sudo sysctl -p /etc/sysctl.conf`

Restart network, `systemctl restart networking` or `ifreload -a`.  Use `ifreload -s -a` to test manual changes.

Add a `vmbr0` (external) and a `vmbr1` (internal) network bridges in the GUI.  Then add the `up route` entries for additional IP addresses to `vmbr0`.  You cannot edit those in the GUI, but ProxMox will preserve them.

## Using Standard HTTPS port

https://p3lim.net/2020/05/22/proxmox-acme

## Adding Users

Note, you can configure 2FA for a PAM user with Google Authenticator and use the same key in ProxMox.  Just paste it into the key field when adding 2FA to the account.  2FA for ProxMox does not use a PAM module like 2FA for SSH does.

Create an `admin` group, `pveum group add admin -comment "Administrators"`.

Give `admin` group the `Administrator` role, `pveum acl modify / -group admin --roles Administrator`.

List the available realms, `pveum realm list`.

Add users to the group, `pveum add user XXX@pam -email XXX@yourdomain.com`.

The password for a user is set through `passwd`.

Disable the `root` PAM user for ProxMox with `pveum user modify root@pam -enable 0`. Ensure `root` account password is disabled with `passwd -l root`.

Configure TFA for the user in the GUI.

- Edit the user, click Advanced and paste the secret token from Google Authenticator under Key ID
- Go to Two Factor and add a TOTP key for the user, pasting the GA token over the PVE one.  Enter one key and password to validate.

Log out and log in to test.  *An X will appear in user info Key ID field. Do not delete it.*

### User Reference

[Adding two factor authentication](https://jonspraggins.com/the-idiot-adds-two-factor-authentication-to-proxmox/)

## Proxy Issues

Use:

```bash
ss -tlpn
```

to see what addresses are being listened too. `*:8006` indicates the proxy is listening on all interfaces.

## Subscriptions

Check your machines socket count with:

```bash
lscpu | grep Socket
```

Then [Purchase a ProxMox subscription](https://www.proxmox.com/en/proxmox-ve/pricing)

Set your subscription key on the machine with, `pvesubscription set {{KEY}}`.

Then update your sources to the paid repository.  Run `pveupgrade` which will run the correct `apt` and other commands to upgrade your system.
****

## Migrate LXC Container

Find the ID with `pct list`.

Create a dump directory, `cd ~; mkdir dump; cd dump`.

Backup the container with `vzdump {{ID}} -dumpdir . -compress lzo -mode stop`.

Grap the config with `cp /etc/pve/nodes/{{NODE_NAME}}/lxc/{{ID}}.conf .`.

Create an SSH key on the source machine with `ssh-keygen -t rsa -b 4096 -C "{{USER_EMAIL}}"`.  Copy the public key over to the target machine.

Copy the `.tar.lzo` file over to the target with `scp *.tar.lzo {{USER}}@{{HOSTNAME}}:`.

`ssh` to the target machine and restore the LXC with the details from the `.conf` file, e.g.:

```sh
pct restore 103 vzdump-lxc-103-2023_06_06-06_06_06.tar.lzo -arch amd64 -cores 2 -cpuunits 2048 -hostname proxy-1 -memory 512 -net0 name=eth1,bridge=vmbr1,firewall=1,ip={{INT_IP4}},ip6={{INT_IP6}},type=veth -net1 name=eth0,bridge=vmbr0,firewall=1,gw={{HOST_IP4}},gw6={{HOST_IP6}},ip={{IP4}},ip6={{IP6}},type=veth -onboot 1 -ostype ubuntu -swap 512 -unprivileged 1
```

NOTE: IPv4 & IPv6 addresses need a CIDR value.

Start the new container.

From host, ensure you can ping the external IP and the internal (you may need to explicitly specify the interface to ping on).

`pct enter {{ID}}`.  Ensure you can ping host internal and external IP's.

Update documentation and add reverse DNS entries.

## QM

To kill a VM from the CLI  `qm list` to get the ID, then `qm shutdown {{VMID}} --forceStop`.

## References

- [Proxmox VE with custom ACME providers](https://p3lim.net/2020/05/22/proxmox-acme)
- [Web Interface Via Nginx Proxy - Proxmox VE](https://pve.proxmox.com/wiki/Web_Interface_Via_Nginx_Proxy)
- [How to set up your first machine](https://forum.proxmox.com/threads/proxmox-beginner-tutorial-how-to-set-up-your-first-virtual-machine-on-a-secondary-hard-disk.59559/)
- The [ProxMox Service Daemons](https://pve.proxmox.com/wiki/Service_daemons) article is useful for when things stop working, such as the web interface.
- [Install Proxmox VE [A Step By Step Guide] - OSTechNix](https://ostechnix.com/install-proxmox-ve/)
- [Package Repositories - Proxmox VE](https://pve.proxmox.com/wiki/Package_Repositories)
- [Network configuration Debian / Ubuntu - Hetzner Docs](https://docs.hetzner.com/robot/dedicated-server/network/net-config-debian-ubuntu/)
- [Moving Proxmox-LXC container - Amol Dighe](https://amoldighe.github.io/2018/07/24/proxmox-move/)
- [Backup and Restore - Proxmox VE](https://pve.proxmox.com/wiki/Backup_and_Restore#vzdump_restore)