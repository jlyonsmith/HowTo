
The `unattended-upgrades` package installs security upgrades on a daily basis and you can configure what packages to upgrade or not upgrade.
## Installation

```bash
apt update && apt install unattended-upgrades apt-listchanges -y
```

Reconfigure the package to activate automatic updates:

```bash
dpkg-reconfigure --priority=low unattended-upgrades
```

Run `cat /etc/apt/apt.conf.d/20auto-upgrades` and check that it looks like this:

```conf
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";
```

Edit `/etc/apt/apt.conf.d/50unattended-upgrades` to adjust whether you want security updates only or regular system upgrades.  

- Open the settings file: `sudo nano /etc/apt/apt.conf.d/50unattended-upgrades`.
- Look for `Allowed-Origins` to decide which updates install automatically (security updates are enabled by default).
- Add package names to `Unattended-Upgrade::Package-Blacklist` if you want to skip updates for specific software. 

Optional Settings

- Set `Unattended-Upgrade::Automatic-Reboot "true";` if you want the server to restart automatically when a new kernel installs.
- Set `Unattended-Upgrade::Automatic-Reboot-Time "02:00";` to pick a specific reboot time.

See the `man unattended-upgrades` help for more information.

## Testing

```bash
unattended-upgrade --dry-run -v
```

And see something like:

```
Starting unattended upgrades script
Allowed origins are: o=Ubuntu,a=jammy, o=Ubuntu,a=jammy-security, o=UbuntuESMApps,a=jammy-apps-security, o=UbuntuESM,a=jammy-infra-security, o=Ubuntu,a=jammy-updates
Initial blacklist:
Initial whitelist (not strict):
No packages found that can be upgraded unattended and no pending auto-removals
The list of kept packages can't be calculated in dry-run mode.
```

Check what has been automatically updated:

```bash
# View the unattended-upgrades log 
sudo cat /var/log/unattended-upgrades/unattended-upgrades.log
# Watch it in real time 
sudo tail -f /var/log/unattended-upgrades/unattended-upgrades.log  # Check the dpkg log for all package changes 
sudo tail -100 /var/log/dpkg.log  
# Use journalctl 
sudo journalctl -u unattended-upgrades --since "7 days ago"
```