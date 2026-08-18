
The `unattended-upgrades` package installs security upgrades on a daily basis and you can configure what packages to upgrade or not upgrade.
## Installation

```bash
apt update && apt install unattended-upgrades apt-listchanges -y
```

Reconfigure the package to activate automatic updates:

```bash
dpkg-reconfigure -plow unattended-upgrades
```
    
Edit `/etc/apt/apt.conf.d/50unattended-upgrades` to adjust whether you want security updates only or regular system upgrades.  See the `man unattended-upgrades` help for more information.

