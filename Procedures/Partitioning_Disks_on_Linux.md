# How to Partition Disks on Linux

[7 ways to view drives on Linux](https://www.tecmint.com/find-linux-filesystem-type/)
[Partition Disks on Linux](https://www.howtogeek.com/106873/how-to-use-fdisk-to-manage-partitions-on-linux/)
[Create and Mount an XFS File System](https://linoxide.com/file-system/create-mount-extend-xfs-filesystem/)

## Adding an XFS Drive

[Adding storage](https://nubcakes.net/index.php/2019/03/05/how-to-add-storage-to-proxmox/)

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

```sh
/dev/sdb1 /data xfs defaults,errors=remount-ro 0 1
```
