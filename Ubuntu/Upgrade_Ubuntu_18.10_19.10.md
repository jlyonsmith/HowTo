# How to Upgrade Ubuntu 18.10 to 19.10

## Problem

Ubuntu have ceased support for Ubuntu 18.10.  The upgrader will not allow an upgrade to any other release.  Furthermore, intermediate release 19.04 is also no longer supported.

## Solution

The workaround is to force upgrade to 19.04 then upgrade again to 19.10.

Based on this [AskUbuntu](https://askubuntu.com/a/91821/954129) post, you can get the `apt update` command working again by adding the `http://old-releases.ubuntu.com` into the `/etc/apt/sources.list` file.

Run:

```sh
cp /etc/apt/sources.list /etc/apt/sources.list.bak
sudo sed -i -re 's/([a-z]{2}\.)?archive.ubuntu.com|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list
sudo apt update
sudo apt upgrade
sudo apt install ubuntu-release-upgrader-core
```

Overwrite `/etc/cloud/cloud.cfg` with the distribution version if prompted.  This will upgrade all packages on the system and is required for the `do-release-upgrade` to be able to run.

Now the problem is that `do-release-upgrade` will not work because it tries to upgrade directly to 19.10 which is not supported.

This [blog article](https://nelsonslog.wordpress.com/2020/02/21/upgrading-from-an-unsupported-ubuntu/) provides a workaround.

Run `do-release-upgrade` on the 18.10 system. This will give you an error about being unsupported. But behind the scenes, the tool will download some metadata files we want to modify.

Run:

```sh
cd /var/lib/update-manager
cp meta-release meta-release2
```

This file tells the upgrader how to upgrade.

Run `vi meta-release2`. Remove all entries for `eoan` entirely. Modify the `disco` entry so it says `Supported: 1`.

Run `vi /usr/lib/python3/dist-packages/UpdateManager/Core/MetaRelease.py` and change this line of code:

```python
self.metarelease_information = open(self.METARELEASE_FILE, "r")
```

To read:

```python
self.metarelease_information = open(self.METARELEASE_FILE + "2", "r")
```

That will tell the upgrader to use your modified file instead of the original. It will also avoid any redownloads overwriting the changes.

Now run `do-release-upgrade`. It should now be doing an upgrade 18.10 → 19.04. Let that run as normal and reboot.  Ignore the message about the setting `iptables` as the upgrade will destroy the iptables anyway.

Remove the upgrade file you created:

```sh
rm /var/lib/update-manager/meta-release2
```

Since 19.10 is supported, all you have to do to upgrade 19.04 → 19.10 is run:

```sh
sudo apt update
sudo apt upgrade
do-release-upgrade
```

To set the hostname if it has changed, edit `/etc/cloud/cloud.cfg` and change `preserve_hostname: false` to `preserve_hostname: true`.  Then:

```sh
hostnamectl set-hostname <machine-name>
```

Finally iptables back in place immediately after the upgrade.
