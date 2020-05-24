# Creating a bootable disk

If you don't already have a bootable USB of the Ubuntu 19.10 server install, you'll need to create one.

1. Download the "Ubuntu Server 19.10" .iso: from: <https://ubuntu.com/download/server>
2. Connect your USB, open a new terminal shell and get a list of your drives to find your USB's location:

```bash
diskutil list
```

**In this example, we'll assume the flash drive is `disk2`.**

To see a list of available partition types, do:

```bash
diskutil listFileSystems
```

If you need to wipe the disk first, do:

```bash
diskutil eraseDisk ExFAT [name of new disk] disk2
```

Unmount the disk without ejecting it by:

```bash
diskutil unmountDisk disk2
```

Now create your bootable disk with:

```bash
sudo dd if=/Users/[username]/Downloads/filename.iso of=/dev/disk2 bs=8m
```

_Note: You won't see any progress bar - allow it to run until finished. Should take no more than 2-5 minutes._

Depending on your OSx version, it will either show a scary "disk not readible" pop up wtih a button to Eject, or you will need to manually eject.

To manually eject:

```bash
diskutil eject disk2
```

## Ubuntu 19.10 Server Installation

1. Boot into the installation USB and follow/select the obvious prompts within the GUI to complete the installation.
2. Remove USB when prompted, then confirm reboot.
