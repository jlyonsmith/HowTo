## Overview

PERC CLI is a command line tool for accessing information about the hardware RAID controller on Dell R630 systems.

## Installation

For Debian 13, download the tool from the Dell site.  It can be hard to find version with the `.deb` file in it.

```sh
wget https://dl.dell.com/FOLDER07576010M/1/PERCCLI_7.1623.00_A11_Linux.tar.gz
mkdir perc
cd perc
tar -xf PERCCLI_7.1623.00_A11_Linux.tar.gz
dpkg -i perccli_007.1623.0000.0000_all.deb
ln -s /opt/MegaRAID/perccli/perccli64 /usr/sbin/perccli64
```

## Maintenance 

The run `sudo perccli show` to see controller and virtual drive status.

```sh
perccli /c0 /eall /sall show all | grep Onln
```

The result will show `Onln` for healthy drives and `Dgrd` for degraded and `Pdgd` for partially degraded.

```bash
sudo perccli64 /c<x> /e<y> /s<z> set offline
```

Then replace the drive, then:

```bash
sudo perccli64 /c<x> /e<y> /sall show rebuild
```

You can use the tool to replace drives that go bad.
## References

- [Install `perccli64`](https://www.helotu.com/2023/05/22/install-perccli-on-debian-proxmox/)
- [Install and Use Dell `perccli` on Ubuntu](https://cylab.be/blog/422/install-and-use-dell-perccli-on-ubuntu)
- [Dell R630 Drivers](https://www.dell.com/support/product-details/en-us/servicetag/0-TU82dnI4cXlTZU5YOEtMYkxQbldjZz090/drivers)
- 