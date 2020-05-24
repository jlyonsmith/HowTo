# Create a bootable USB stick on macOS

If you have a Mac with an up-to-date version of macOS (previously OSX), you have everything you need to make bootable Ubuntu USB sticks (drives). Don't bother downloading any of the "make a boot disk" utilities, you don't need 'em.  Here are the simple steps to creating a bootable Ubuntu USB stick on macOS.

First, download the ISO file from [Ubuntu Releases](http://www.releases.ubuntu.com/). In this case we are creating a bootable drive for 18.04, so download file is: `ubuntu-18.04.2-server-amd64.iso`.

Now, insert the USB drive into the Mac and determine it's drive name using `diskutil list` tool:

```sh
diskutil list
```

Which for me outputs:

```text
/dev/disk0 (internal):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      GUID_partition_scheme                         500.3 GB   disk0
   1:                        EFI EFI                     314.6 MB   disk0s1
   2:                 Apple_APFS Container disk1         500.0 GB   disk0s2

/dev/disk1 (synthesized):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      APFS Container Scheme -                      +500.0 GB   disk1
                                 Physical Store disk0s2
   1:                APFS Volume Macintosh HD            163.2 GB   disk1s1
   2:                APFS Volume Preboot                 21.1 MB    disk1s2
   3:                APFS Volume Recovery                515.8 MB   disk1s3
   4:                APFS Volume VM                      4.3 GB     disk1s4

/dev/disk2 (external, physical):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:     Apple_partition_scheme                        *4.0 GB     disk2
   1:        Apple_partition_map                         4.1 KB     disk2s1
   2:                  Apple_HFS                         2.5 MB     disk2s2
```

So in this case it's `/dev/disk2` or just `disk2` for the `partitionDisk` command.

Now we partition the disk which will *erase all data on the disk*.  So make a backup if you need too please.

```sh
sudo diskutil partitionDisk disk2 1 MBR FAT32 UBUNTU 100%
```

After entering your password, you should see something like:

```text
Started partitioning on disk2
Unmounting disk
Creating the partition map
Waiting for partitions to activate
Formatting disk2s1 as MS-DOS (FAT32) with name UBUNTU
512 bytes per physical sector
/dev/rdisk2s1: 30209184 sectors in 1888074 FAT32 clusters (8192 bytes/cluster)
bps=512 spc=16 res=32 nft=2 mid=0xf8 spt=32 hds=255 hid=2048 drv=0x80 bsec=30238720 bspf=14751 rdcl=2 infs=1 bkbs=6
Mounting disk
Finished partitioning on disk2
/dev/disk2 (external, physical):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:     FDisk_partition_scheme                        *15.5 GB    disk2
   1:                 DOS_FAT_32 UBUNTU                  15.5 GB    disk2s1
```

We use Master Boot Record (`MBR`) and `FAT32` as that will have the widest compatability for the different BIOS' that you will encounter on varying hardware when installing Ubuntu.  If you have problems getting your hardare to recognize the drive, it's most likely because of the type of partition scheme.  The other ones you can try are Apple Partition Map (`APM`) and GUID Partition Scheme (`GPT`). Re-run the `diskutil partitionDisk` command with the different partition type and everything else the same.

To confirm everything worked, you should see a disk with the title `UBUNTU` on your desktop.  The final step is to run the `dd` command copy the ISO to the drive, but for this to work must be unmounted, but not ejected.  Essentially, we just want to remove entry for it in your file system so the drive is no longer in use and the `dd` command can work.

```sh
diskutil unmount disk2
```

And now, the last step:

```sh
sudo dd if=ubuntu-18.04.2-server-amd64.iso of=/dev/disk2
```

This will take some time to finish and provides no output while it's working. A 1GB ISO transferring on USB 2.0 at around 25 Mbps might take 5 minutes, as an example. Don't mess with it and when it is done it will output something like:

```text
1808384+0 records in
1808384+0 records out
925892608 bytes transferred in 641.850027 secs (1442537 bytes/sec)
```

And you are done.  You'll get a message that the disk is not readable by macOS, just click the eject button.  Now go forth and install Ubuntu!
