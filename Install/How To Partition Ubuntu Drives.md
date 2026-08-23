## Summary

Use `parted` to create partitions.

Use `wipefs --all --backup /dev/sdX` to clean a previously partitioned drive.

Use `fdisk` to view and delete partitions.

## Ubuntu Logical Volume Manager

An Ubuntu LVM (Logical Volume Manager) drive uses a flexible storage system instead of fixed partitions. It lets you resize storage space while the system is running, combine multiple physical hard drives into one large storage pool, and create quick backup snapshots.

To add `/dev/sdb` to your existing logical volume, you need to turn the new drive into a Physical Volume, add it to your Volume Group, and then extend the Logical Volume and its filesystem.

Before starting, ensure `/dev/sdb` does not contain any important data, as these steps will overwrite it.

Step 1: Find Your Volume Group and Logical Volume Names

Run the following command to find the exact names of your current **VG Name** and **LV Path**:

bash

```
sudo lvdisplay
```

Use code with caution.

_Look for lines like `VG Name (e.g., ubuntu-vg)` and `LV Path (e.g., /dev/ubuntu-vg/ubuntu-lv)`._

Step 2: Initialize the New Drive (Create Physical Volume)

Prepare the new drive for LVM:

bash

```
sudo pvcreate /dev/sdb
```

Use code with caution.

Step 3: Extend Your Volume Group

Add the new physical volume to your existing Volume Group (replace `ubuntu-vg` with your actual VG Name):

bash

```
sudo vgextend ubuntu-vg /dev/sdb
```

Use code with caution.

Step 4: Extend the Logical Volume and Filesystem

Grow your logical volume to use 100% of the newly added free space, and automatically resize the underlying filesystem at the same time (replace `/dev/ubuntu-vg/ubuntu-lv` with your actual LV Path):

bash

```
sudo lvextend -l +100%FREE -r /dev/ubuntu-vg/ubuntu-lv
```

Use code with caution.

Step 5: Verify the New Size

Check that your system now sees the larger storage capacity:

bash

```
df -h
```

Use code with caution.

If you want to make sure everything goes smoothly, tell me:

- What are the exact **VG Name** and **LV Path** from your `sudo lvdisplay` output?
- What **filesystem type** (e.g., ext4, xfs) are you using if the automatic resize command shows an error?
## References

- [Partitioning Linux Drives](https://www.digitalocean.com/community/tutorials/how-to-partition-and-format-storage-devices-in-linux#step-2-identify-the-new-disk-on-the-system)