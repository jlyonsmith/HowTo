# Creating a bootable disk

Create a bootable USB of Ubuntu.

Download the Ubuntu server or desktop .iso: from the [Ubuntu](https://ubuntu.com/download) site.

Connect your USB, open a new terminal shell and get a list of your drives to find your USB's location, `diskutil list`.

To see a list of available partition types, `diskutil listFileSystems`.

If you need to wipe the disk first, `diskutil eraseDisk ExFAT {{NEW_DISK_NAME}} {{DISK_ID}}`.

Unmount the disk without ejecting it, `diskutil unmountDisk {{DISK_ID}}`.

Now create your bootable disk, `sudo dd if=/Users/{{USER_NAME}}/Downloads/{{ISO_FILE_NAME}} of=/dev/{{DISK_ID}} bs=8m`.

*You won't see any progress bar. Allow it to run until finished. It can take 10 minutes or more.*

Depending on your macOS version, it will either show a scary "disk not readible" pop up wtih a button to Eject, or you will need to manually eject, `diskutil eject disk2`
