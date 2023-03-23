# Build a Network Router

## Install Ubuntu from a USB Stick

[Download the latest Ubuntu Server ISO](https://releases.ubuntu.com/).  Grab a minimum 2GB USB stick and create a bootable installer.  The [instructions for macOS are here](https://ubuntu.com/tutorials/create-a-usb-stick-on-macos#1-overview)

Different devices have different ways to select the boot device.  Some will do it automatically. Other devices have to be specifically told what device to use.  My [Protectli](https://protectli.com/kb/coreboot-on-the-vp2410/) requires you to push `F11` during the device boot.

The Ubuntu install will have you create an admin user.  You'll finish setting up that user up in the next step.

## Change the Machine Name

Update hostname with `sudo hostnamectl set-hostname $NEW_HOSTNAME` and `sudo reboot now`.

## Create Admin User & Disable Root Login

[Create Sudo User](Procedures/Create_Sudo_User.md)

## Configure `ddclient`

`ddclient` ensures that any public DNS entries for the router are correct.

## Configure Network Interfaces

Assuming a device with 4 network interfaces, you could configure them as follows:

1. WAN
2. LAN
3. Direct (for emergencies)
4. Not used

The `/etc/netplan/` file would be as follows:

```yaml
network:
  ethernets:
    enp1s0:
      dhcp4: false # Start with this set to false
    enp2s0:
      dhcp4: false
      addresses: [192.168.0.1/22]
    enp3s0:
      dhcp4: false
      addresses: [172.16.0.1/24]
      nameservers:
        addresses: [1.1.1.1,1.0.0.1]
    enp4s0:
      optional: true
  version: 2
```

[`optional`](https://manpages.ubuntu.com/manpages/kinetic/en/man5/netplan.5.html) prevents the system from waiting for the interface while booting.

Do `netplan apply` after changing the config and re-connect if necessary.

## Set up Fail2Ban

[fail2ban](Install/Fail2Ban.md)

## Set Time Zone

[Set Timezone](Procedures/Set_Locale_Ubuntu.md)

## Configure IPTables

For the Protectli device mentioned above, place these rules in `/etc/iptables.rules`:

```rules
# Interfaces:
#
# enp1s0: WAN
# enp2s0: 192.168.0.0/22 (LAN)
# enp3s0: 172.16.0.0/24 (Diagnostic LAN)
# enp4s0: Not used

*nat
:PREROUTING ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]

# NAT traffic going out the WAN interface
-A POSTROUTING -o enp1s0 -j MASQUERADE
COMMIT

*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:f2b-sshd - [0:0]

## INPUT rules

# fail2ban rule to avoid lockout when changing rules
-A INPUT -p tcp -m multiport --dports 22 -j f2b-sshd

# Allow in from loopback
-A INPUT -i lo -j ACCEPT

# Allow SSH in from WAN
-A INPUT -i enp1s0 -p tcp -m tcp --dport 22 -j ACCEPT

# Allow in from LAN
-A INPUT -i enp2s0 -j ACCEPT

# Allow in from diagnostic LAN
-A INPUT -i enp3s0 -j ACCEPT

# Allow in established input from WAN
-A INPUT -i enp1s0 -m state --state RELATED,ESTABLISHED -j ACCEPT

# Drop invalid packets from WAN
-A INPUT -i enp1s0 -m state --state INVALID -j DROP

# Allow in unreachable, ping, ttl and bad header ICMP from WAN
-A INPUT -i enp1s0 -p icmp -m icmp --icmp-type 3 -j ACCEPT
-A INPUT -i enp1s0 -p icmp -m icmp --icmp-type 8 -j ACCEPT
-A INPUT -i enp1s0 -p icmp -m icmp --icmp-type 11 -j ACCEPT
-A INPUT -i enp1s0 -p icmp -m icmp --icmp-type 12 -j ACCEPT

# DROP everything else
-A INPUT -j DROP

## FORWARD rules

# Forward all LAN traffic to WAN
-A FORWARD -i enp2s0 -o enp1s0 -j ACCEPT

# Forward WAN traffic to LAN if LAN initiated connection
-A FORWARD -i enp1s0 -o enp2s0 -m state --state RELATED,ESTABLISHED -j ACCEPT

# DROP everything else
-A FORWARD -j DROP

# Other part of fail2ban rules to avoid SSH lockout
-A f2b-sshd -j RETURN

COMMIT
```

## Diagnostic Procedures

In case everything stops working:

- Can you ping? `ping 192.168.0.1`
- If not, can you connect via diagnostic LAN?  Set manual IP of `172.16.0.2` and `ssh user@172.16.0.1`
- Can you SSH in? `ssh 192.168.0.1`
- Is Kea-DHCP running? `systemctl status isc-kea-dhcp4-server`
- Is Bind9 DNS running? `systemctl status named`
- Do you have a public IP address? `ip addr`
- Is external DNS working? `ping www.google.com`

### Comcast Modem

Diagnostic questions for the Comcast modem:

- Can you connect to Comcast cable modem? Set manual IP of `192.168.100.2` and `ping 192.168.100.1` then use browser to connect to `http://192.168.100.1` with modem password.
- Is the Comcast modem responding to `ping 192.168.100.1`? If not, reboot the modem.

The cable modem has a diagnostic IP of `192.168.100.1`  This isn't on the `192.168.0.0/22` subnet (see [CIDR calculator](http://networkcalculator.ca/cidr-calculator.php) for the range), so the router will route it out over the Internet to die.  See `route` on the router.

## Configure `systemd-networkd-wait-online.service`

Edit the service file to only wait for the network interfaces that you expect to come up, e.g.

```conf
ExecStart=/lib/systemd/systemd-networkd-wait-online -i enp2s0 -i enp1s0
```
