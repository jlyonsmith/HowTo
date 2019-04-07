# Install NTP on Ubuntu

## Background

This document describes how to install and configure the NTP service on Ubuntu 18.  This will synchronize the system clock with one of the official high accuracy network time clocks.

Once configured you can server a synchronized clock inside a provide subnet.  Unmodified Ubuntu instances typically use `ntpdate`, which should be replaced with the `ntpd` daemon going forward.

You want to use the closest NTP server possible.  This is done automatically by using the built in [Ubuntu `pool` servers](https://www.ntppool.org/zone).

## Configuration

Uninstall `ntpupdate` and install `ntpd`:

```bash
sudo apt remove ntpupdate
sudo apt install ntpd
```

Now edit the `/etc/ntp.conf` file as follows:

```conf
# /etc/ntp.conf, configuration for ntpd; see ntp.conf(5) for help

driftfile /var/lib/ntp/ntp.drift
leapfile /usr/share/zoneinfo/leap-seconds.list
statistics loopstats peerstats clockstats
filegen loopstats file loopstats type day enable
filegen peerstats file peerstats type day enable
filegen clockstats file clockstats type day enable

server 0.pool.ntp.org iburst
server 1.pool.ntp.org iburst
server 2.pool.ntp.org iburst
server 3.pool.ntp.org iburst
server ntp.ubuntu.com
server 127.127.1.0
fudge 127.127.1.0 stratum 10

restrict -4 default kod notrap nomodify nopeer noquery limited
restrict -6 default kod notrap nomodify nopeer noquery limited
restrict 127.0.0.1
restrict ::1
restrict source notrap nomodify noquery
```

NOTE: This configuration specifically does *not* use the `pool` directive or the Ubuntu time servers.  The `pool.ntp.org` servers are already pooled.

On the root time server in your subnet (the one that is connected to the Internet), open up the firewalls as follows:

```
export WAN_IP=...
export LAN_IP=...
export LAN_SUBNET=...
ufw allow out proto udp from $WAN_IP to any port 123
ufw allow in proto udp from any to $WAN_IP port 123
ufw allow out from $LAN_IP to $LAN_SUBNET port 123
ufw allow in from $LAN_SUBNET to $LAN_IP port 123
```

`LAN_SUBNET` is the IP address and subnet mask in CIDR format.

Restart the `ntpd` with:

```bash
sudo systemctl restart ntpd
```

Now run `ntpq -pn`.  You should get output like this:

```
     remote           refid      st t when poll reach   delay   offset  jitter
==============================================================================
 127.127.1.0     .LOCL.          10 l  217   64   10    0.000    0.000   0.000
*50.205.244.20   50.205.244.27    2 u   14   64   17   61.207    0.880   0.699
-69.164.203.231  139.78.97.128    2 u   11   64   17   59.407    2.944   0.827
+38.145.155.206  132.236.56.250   3 u   16   64   17   66.530    1.546   0.844
+74.6.168.72     208.71.46.33     2 u   10   64   17    4.260    1.200   0.721
 91.189.94.4     145.238.203.14   2 u   19   64   17  138.561    1.011   1.050
 ```

As long as one of the lines start with `*` (and it's not the `127.127.1.0` line) you are getting time from the Internet. See [How do I use pool.ntp.org?](https://www.ntppool.org/en/use.html) from more information.
