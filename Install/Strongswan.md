# Install Strongswan VPN

These instructions are for configuring a VPN connection from the Internet to a secure subnet, e.g. a data center or office network.

## Ubuntu

Install the packages:

```bash
sudo apt update
sudo apt install strongswan strongswan-pki libcharon-extra-plugins
```

The `libcharon-extra-plugins` module is required for the `eap-mschapv2` protocol.

## Server

### Kernel IP Forwarding and Firewall

Enable IPv4 forwarding in `/etc/systctl.conf`:

```conf
# Enable packet forwarding for IPv4
net.ipv4.ip_forward = 1

# Do not accept ICMP redirects (prevent MITM attacks)
net.ipv4.conf.all.accept_redirects = 0
...

# Do not send ICMP redirects (we are not a router)
net.ipv4.conf.all.send_redirects = 0

# Disable Path MTU discovery to prevent packet fragmentation problems
net.ipv4.ip_no_pmtu_disc = 1
```

Then `sysctl -p` to reload.

Add to your `iptables` for an Internet facing network card, `eno1` (which can be found with `ip route | grep default`):

```bash
iptables -A INPUT -i eno1 -p udp -m udp --dport 500 -j ACCEPT
iptables -A INPUT -i eno1 -p udp -m udp --dport 4500 -j ACCEPT
```

We'll configure Strongswan to add the other necessary packet forwarding rules automatically for connections.

### Certificates

```sh
sudo -s
cd /etc/ipsec.d
```

Create a CA key:

```bash
ipsec pki --gen --type rsa --size 4096 --outform pem > private/ca-key.pem
```

Create a CA certificate with the private key:

```bash
ipsec pki --self --ca --lifetime 3650 --in private/ca-key.pem \
    --type rsa --dn "CN=<meaningful-name-here>" --outform pem > cacerts/ca-cert.pem
```

Use a name that is meaningful in your organization for the `CN`, e.g. `My Company VPN`

Now, create a server key:

```bash
ipsec pki --gen --type rsa --size 4096 --outform pem > private/server-key.pem
```

Finally, create a server certificate:

```bash
ipsec pki --pub --in private/server-key.pem --type rsa \
    | ipsec pki --issue --lifetime 1825 \
        --cacert cacerts/ca-cert.pem --cakey private/ca-key.pem \
        --dn "CN=<server-domain>" --san "<server-domain>" \
        --flag serverAuth --flag ikeIntermediate --outform pem \
    >  certs/server-cert.pem
```

If you do `tree` you should see:

```tree
.
├── aacerts
├── acerts
├── cacerts
│   ├── ca-cert.pem
│   └── README
├── certs
│   └── server-cert.pem
├── crls
├── ocspcerts
├── policies
├── private
│   ├── ca-key.pem
│   └── server-key.pem
└── reqs
```

IMPORTANT: Copy the `ca-key.pem` to a safe location and remove it from the server.

### Configuration

`sudo vi /etc/ipsec.conf` and make it look something like:

```conf
config setup
    charondebug="ike 1, knl 1, cfg 0"
    uniqueids=no

conn ikev2-vpn
    auto=add
    compress=no
    type=tunnel
    keyexchange=ikev2
    fragmentation=yes
    forceencaps=yes
    dpdaction=clear
    dpddelay=300s
    rekey=no
    left=<domain-name>
    leftid=@<domain-name>
    leftcert=server-cert.pem
    leftsendcert=always
    leftsubnet=<internal-subnet>
    leftfirewall=yes
    right=%any
    rightid=%any
    rightauth=eap-mschapv2
    rightsourceip=<client-subnet>
    rightdns=<internal-dns>
    rightsendcert=never
    eap_identity=%identity
```

In this file, the `left` refers to the _local_ system, i.e. where the Strongswan service is running, and `right` refers to the the _remote_ system, i.e. the client. The following tables describes the various values in brackets:

| Name                | Description                                                                               |
| ------------------- | ----------------------------------------------------------------------------------------- |
| `<domain-name>`     | The domain name of the system that the Strongswan service is running on, e.g. example.com |
| `<internal-subnet>` | The private subnet behind the Strongswan service                                          |
| `<client-subnet>`   | A range of IP's to allocate clients                                                       |
| `<internal-dns>`    | One or more DNS servers inside the private subnet                                         |

Now, edit the `/etc/ipsec.secrets` file:

```conf
# This file holds shared secrets or RSA private keys for authentication.

# RSA private key for this host, authenticating it to any other host
# which knows the public part.
: RSA "server-key.pem"

<user-name> : EAP "<strong-password>"
```

NOTE: Spaces are important in the above file.

Create a separate `<username>/<password` entry for each user of the system. They will all share the same certificate.

Now start the service with `sudo systemctl start strongswan`.

With the above settings, Strongswan will configure the necessary `iptables` FORWARD rules when each client connects.

## Client

### Connecting macOS

1. Download `cat /etc/ipsec.d/cacerts/ca-cert.pem` to the Mac.
2. Double click to add to your keychain
3. Select the certificate, **Get Info** then **Always Trust**
4. Go to **System Preferences > Network** then click the **+** to add a new network
5. Choose VPN -> IKEv2
6. Enter the VPN system `<domain-name>` for both **Server Address** and **Remote ID**
7. In **Authenticating Settings** enter the `<username>` and `<password>`.
8. Click **Apply** the **Connect**

To configure your Mac to use a private DNS inside the VPN subnet, create a `/etc/resolver/<domain-extension>` file.  For example, to redirect all `.consul` domain requests add a file called `/etc/resolver/consul`:

```conf
nameserver <ip-addr>
timeout 5
```

### Connecting Ubuntu

To install StrongSwan as a client on Ubuntu:

```sh
sudo apt install strongswan libcharon-extra-plugins libstrongswan-extra-plugins
```

Copy the CA certificate from the server to `/etc/ipsec.d/cacerts/`.
vi
Configure the VPN user and password in the `/etc/ipsec.secrets` file on the server.

Edit the `/etc/ipsec.conf` file on the client:

```conf
config setup

conn ikev2-rw
    right=<server_domain_or_IP> # This should match the `leftid` value on your server's configuration
    rightid=<server_domain_or_IP>
    rightsubnet=0.0.0.0/0
    rightauth=pubkey
    leftsourceip=%config
    leftid=<username>
    leftauth=eap-mschapv2
    eap_identity=%identity
    auto=start
```

Enable the StrongSwan service with `systemctl enable strongswan` if you want it to start on reboot and start the service with `systemctl start strongswan`.

To see the full Strongswan log on the client or server use `journalctl -u strongswan -r`

## Documentation

[IPSec with StrongSwan](https://raymii.org/s/tutorials/IPSEC_vpn_with_CentOS_7.html)
[How to Setup an IKEv2 VPN Server with StrongSwan on Ubuntu 18.04](https://www.digitalocean.com/community/tutorials/how-to-set-up-an-ikev2-vpn-server-with-strongswan-on-ubuntu-18-04-2)
[StrongSwan Forwarding and Split Tunneling](https://wiki.strongswan.org/projects/strongswan/wiki/ForwardingAndSplitTunneling)