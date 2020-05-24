# Installing ProxMox

## Install on Existing Debian

See [this article](https://tj.mk/install-proxmox-4-hetzner-debian/)

## Create a Private Network

See [this article](https://blog.jenningsga.com/private-network-with-proxmox/)

## Adding an XFS Drive to an Existing Node

Add a new raw drive to the node in the ProxMox UI.  Log into the system and find out what the device name is:

```bash
sudo -s
fdisk -l
```

Let's say it's `/dev/sdb`.  Next, partition the disk:

```bash
cfdisk /dev/sdb
```

Select `gpt` as the partition type.  Then **New** > **Primary** > **Enter**, **Write**, **Quit**.

Now format the new partition:

```bash
mkfs.xfs /dev/sdb1
```

Mount the drive:

```bash
mkdir /data
mount -t xfs /dev/sdb1 /data
df -T
```

Add it to `/etc/fstab` so that it mounts next time:

```
/dev/sdb1 /data xfs defaults,errors=remount-ro 0 1
```
