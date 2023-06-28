# Install NTPSec

First `apt install ntpsec -y`.

Configure `/etc/ntpsec/ntp.conf`:

```conf
driftfile /var/lib/ntpsec/ntp.drift
leapfile /usr/share/zoneinfo/leap-seconds.list

# To enable Network Time Security support as a server, obtain a certificate
# (e.g. with Let's Encrypt), configure the paths below, and uncomment:
# nts cert CERT_FILE
# nts key KEY_FILE
# nts enable

# You must create /var/log/ntpsec (owned by ntpsec:ntpsec) to enable logging.
#statsdir /var/log/ntpsec/
#statistics loopstats peerstats clockstats
#filegen loopstats file loopstats type day enable
#filegen peerstats file peerstats type day enable
#filegen clockstats file clockstats type day enable

# This should be maxclock 7, but the pool entries count towards maxclock.
tos maxclock 11

# Comment this out if you have a refclock and want it to be able to discipline
# the clock by itself (e.g. if the system is not connected to the network).
tos minclock 4 minsane 3

# Public NTP servers supporting Network Time Security:
server ntp1.hetzner.de iburst
server ntp2.hetzner.com iburst
server ntp3.hetzner.net iburst

# By default don't exchange time with anyone
restrict default ignore

# Allow some specific interaction with the time servers
restrict ntp1.hetzner.de nomodify notrap nopeer noquery
restrict ntp2.hetzner.com nomodify notrap nopeer noquery
restrict ntp3.hetzner.net nomodify notrap nopeer noquery

# Local users may interrogate the ntp server as needed
restrict 127.0.0.1
restrict ::1
restrict 10.10.0.0/16
restrict fc00::1/7
```

Then `systemctl restart ntpsec`.

## References

- [Welcome to NTPsec](https://www.ntpsec.org/)
- [Install and Configure NTP | Hetzner Community](https://community.hetzner.com/tutorials/install-and-configure-ntp)
- [Debian 12 Bookworm : Configure NTP Server (NTPsec) : Server World](https://www.server-world.info/en/note?os=Debian_12&p=ntp&f=1)
