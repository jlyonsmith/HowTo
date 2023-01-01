# Installing ProxMox

This document talks about installing ProxMox both on cloud servers and on physical servers.

## Install on Existing Debian

If using Hetzner, [use the Rescue O/S to install Debian](https://docs.hetzner.com/robot/dedicated-server/operating-systems/installimage/) adjusting for the most recent version of Debian.

- [Trajche Kralev](https://tj.mk/install-proxmox-4-hetzner-debian/)
- [Hetzner - Install and Configure Proxmox VE](https://community.hetzner.com/tutorials/install-and-configure-proxmox_ve)
- [How to setup Proxmox on dedicated Hetzner Server](https://www.indivar.com/blog/how-to-setup-proxmox-on-hetzner-dedicated-server/)

You'll want to use LXC (containers) virtualization instead of KVM where you are using Linux as the hosted O/S.  Use routed networking for machines that need to go on the Internet.

Install [fail2ban](https://pve.proxmox.com/wiki/Fail2ban) to protect against brute force attacks.  Install Google Authenticator for 2FA and [configure it in ProxMox](https://pve.proxmox.com/pve-docs/pve-admin-guide.html#pveum_tfa_auth).

## Create a Private IPv4 Network

See [this article](https://blog.jenningsga.com/private-network-with-proxmox/) and this one [Proxmox 5 on Hetzner Root-Server with Dual-Stack IPv4/IPv6 for Host and Guests](https://www.sysorchestra.com/proxmox-5-on-hetzner-root-server-with-ipv4/)

Use the IP address sharing approach not the NATS approach to give access to the public network.

For LXC containers, networking is configured by ProxMox. You can find the network configuration files in `/etc/systemd/network/eth0.network`, etc..  If you change these files in the ProxMox UI they will change here without requiring a reboot.

## Adding an XFS Drive to an Existing Node

[Adding storage](https://nubcakes.net/index.php/2019/03/05/how-to-add-storage-to-proxmox/)

Add a new raw drive to the node in the ProxMox UI.  Log into the system and find out what the device name is:

```bash
sudo -s
fdisk -l
```

Let's say it's `/dev/sdb`.  Next, partition the disk:

```bash
cfdisk /dev/sdb
```

Select `gpt` as the partition type.  Then **New** > **Primary** > **Enter**, **Write**, **Quit**.

Now format the new partition:

```bash
mkfs.xfs /dev/sdb1
```

Mount the drive:

```bash
mkdir /data
mount -t xfs /dev/sdb1 /data
df -T
```

Add it to `/etc/fstab` so that it mounts next time:

```sh
/dev/sdb1 /data xfs defaults,errors=remount-ro 0 1
```

## Adding Users

Note, you can configure 2FA for a PAM user with Google Authenticator and use the key in ProxMox.  Just paste it into the key field when adding 2FA to the account.  2FA for ProxMox is separate from 2FA for SSH.

[Adding two factor authentication](https://jonspraggins.com/the-idiot-adds-two-factor-authentication-to-proxmox/)

Create an `admin` group, add users to the group, then on the command line make members of that group have the `Administrator` role:

```sh
pveum acl modify / -group admin --roles Administrator
```

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

Set your subscription key on the machine with:

```bash
pvesubscription set <key>
```

## References

- [Web Interface Via Nginx Proxy - Proxmox VE](https://pve.proxmox.com/wiki/Web_Interface_Via_Nginx_Proxy)
- [How to set up your first machine](https://forum.proxmox.com/threads/proxmox-beginner-tutorial-how-to-set-up-your-first-virtual-machine-on-a-secondary-hard-disk.59559/)
- [`pointopoint` network configuration on Hetzner with Debian](https://docs.hetzner.com/robot/dedicated-server/network/net-config-debian)
- The [ProxMox Service Daemons](https://pve.proxmox.com/wiki/Service_daemons) article is useful for when things stop working, such as the web interface.
- [Install Proxmox VE [A Step By Step Guide] - OSTechNix](https://ostechnix.com/install-proxmox-ve/)
- [Package Repositories - Proxmox VE](https://pve.proxmox.com/wiki/Package_Repositories)
