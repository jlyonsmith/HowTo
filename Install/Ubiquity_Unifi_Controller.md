# Ubiquiti Unifi Controller

## Installation & Upgrade

Got to the [Unifi Downloads Page](https://www.ui.com/download/unifi/) click on the Ubuntu download icon and copy the link.

Then:

```sh
cd /tmp
wget https://dl.ui.com/unifi/6.0.28/unifi_sysvinit_all.deb
sudo dpkg -i unifi_sysvinit_all.deb
```

Unpack over the current version (if any).

Check the controller is running:

```sh
sudo systemctl status unifi
```

## References

- [UniFi - How to Set Up a UniFi Network Controller](https://help.ui.com/hc/en-us/articles/360012282453-UniFi-How-to-Set-Up-a-UniFi-Network-Controller)
- [User maintained upgrade script](https://get.glennr.nl/unifi/update/unifi-update.sh)
