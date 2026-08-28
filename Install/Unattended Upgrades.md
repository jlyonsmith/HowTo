
The `unattended-upgrades` package installs security upgrades on a daily basis and you can configure what packages to upgrade or not upgrade.
## Installation

```bash
apt update && apt install unattended-upgrades apt-listchanges -y
```

Reconfigure the package to activate automatic updates:

```bash
dpkg-reconfigure --priority=low unattended-upgrades
```

Configure email:

```bash
sudo apt install mailutils postfix
```

Run `vi /etc/apt/apt.conf.d/20auto-upgrades` and check that it looks like this:

```conf
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";
```

Run `vi /etc/apt/apt.conf.d/50unattended-upgrades`:

```conf
Unattended-Upgrade::Allowed-Origins {
        "${distro_id}:${distro_codename}";
        "${distro_id}:${distro_codename}-security";
        "${distro_id}ESMApps:${distro_codename}-apps-security";
        "${distro_id}ESM:${distro_codename}-infra-security";
        "${distro_id}:${distro_codename}-updates";
};

Unattended-Upgrade::Package-Blacklist {
};

Unattended-Upgrade::DevRelease "auto";
Unattended-Upgrade::Mail "john@mozayik.net";
Unattended-Upgrade::MailReport "only-on-error";
Unattended-Upgrade::Automatic-Reboot "true";
```

Restart the service `systemctl restart unattended-upgrades`.

Optional settings:

- Set `Unattended-Upgrade::Automatic-Reboot "false";` if you do not want the server to restart automatically when a new kernel installs.
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

## References

- [Configure Unattended Upgrades](https://oneuptime.com/blog/post/2026-03-02-configure-unattended-upgrades-security-patches-ubuntu/view)

