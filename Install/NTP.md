# Install NTP on Ubuntu

## Background

This document describes how to install and configure the NTP service on Ubuntu 18. This will synchronize the system clock with one of the official high accuracy network time clocks.

Once configured you can server a synchronized clock inside a provide subnet. Unmodified Ubuntu instances typically use `ntpdate`, which should be replaced with the `ntpd` daemon going forward.

You want to use the closest NTP server possible. This is done automatically by using the built in [Ubuntu `pool` servers](https://www.ntppool.org/zone).

## Proxy Configuration

Uninstall `ntpdate` and install `ntpd`:

```bash
sudo apt remove ntpdate
sudo apt install ntp
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
fudge 127.127.1.0 stratum 10

restrict -4 default kod notrap nomodify nopeer noquery limited
restrict -6 default kod notrap nomodify nopeer noquery limited
restrict 127.0.0.1
restrict ::1
restrict source notrap nomodify noquery
```

NOTE: This configuration specifically does _not_ use the `pool` directive or the Ubuntu time servers. The `pool.ntp.org` servers are already pooled.

Also, this does not fallback to the local hardware clock as some StackOverflow answers say.  This can cause the clock never to synchronize when the time is too far off the real time.

On the root time server in your subnet (the one that is connected to the Internet), open up the firewall to allow NTP traffic using the UDP protocol on port 123.

Enable and start the `ntp` service with:

```bash
sudo systemctl enable ntp
sudo systemctl start ntp
```

Now run `ntpq -pn`. You should get output like this:

```none
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

## Bastion, Mail and Internal System Setup

Your bastion, mail and other systems should synchronize with the proxy systems on the internal network.

Install NTP with `sudo apt install ntp`. Then you'll need the following in `/etc/ntp.conf`:

```conf
...
server <internal-system-1> iburst
server <internal-system-2> iburst
...
```

Ideally, you should use an internal `consul` based DNS instead of hard coded IP addresses.

Again, configre the firewall appropriately for port 123 NTP traffic.

For internal NTP servers `ntpq -pn` will return:

```none
      remote           refid      st t when poll reach   delay   offset  jitter
==============================================================================
* 10.10.1.1        .INIT.          16 u    -   64    0    0.000    0.000   0.000
+ 10.10.1.2        .INIT.          16 u    -   64    0    0.000    0.000   0.000
  127.127.1.0     .LOCL.          10 l   44   64    1    0.000    0.000   0.000
```

If times are off by 1000s then NTP will not update the time, otherwise it will slowly move the time to the correct value.

To force an update:

```bash
sudo systemctl stop ntp
sudo ntpd -gq
sudo systemctl start ntp
```
