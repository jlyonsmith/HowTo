# Get Linux Hardware Details

## General

`uname -a` gives quick info on hardware, kernel.

`apt install lshw` then `lshw` gives full details of all attached hardward, including serial numbers.  `lshw -short` is useful for a quick overview.

`lsblk` gives info on block storage devices.

`lscpu` gives CPU stats.

`lsusb` gives information on USB devices.

`lspci` gives PCI device info.

`lsscsi` gives SCSI device info.

`hdparm` can be used to see various h/w parameters for different devices, such as readonly disks, etc..

## SMART Devices

Modern hard and solid state drives have Self-Monitoring, Analysis and Reporting Technology (SMART) embedded in them. It's useful to get early warning of devices failures.  It's not a lot of use once the device has failed.

Run `smartctl --all $DEVICE` to get the device report.  See [Storage Device Health Check](https://www.baeldung.com/linux/storage-device-check-health).  Note that the seeing *Old_age* and *Pre-fail* are indicators that you should be replacing hard drives soon.

Run the short self test with `smartctl -t short $DEVICE`. Results appear in about two minutes.

## References

- [How To Partition and Format Storage Devices in Linux  | DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-partition-and-format-storage-devices-in-linux)
- [How To Create RAID Arrays with mdadm on Ubuntu 22.04  | DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-create-raid-arrays-with-mdadm-on-ubuntu-22-04)