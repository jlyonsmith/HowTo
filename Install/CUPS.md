# Installing CUPS

CUPS is the Common Unix Print System

## Ubuntu

```bash
sudo apt update
sudo apt install cups cups-bsd
```

`cups-bsd` get the correct version of the BSD `lpr` command.

## CentOS

```bash
sudo yum install cups
```

## Starting the Service

Start/stop with:

```bash
sudo systemctl start cups
sudo systemctl stop cups
```

The CUPS printer config file is at `/etc/cups/printers.conf`. **You should not change it manually, but if you do, stop the CUPS daemon first.**

## Trouble Shooting

To enable debug logging:

```bash
cupsctl --debug-logging
```

And to disable:

```bash
cupsctl --no-debug-logging
```

The view the log at `/var/log/cups/error_log`.

## Adding Printers

List available printers devices:

```bash
lpinfo -v
```

Enable sharing printers across the network with:

```bash
cupsctl --share-printers
```

Add a shared printer with:

```bash
lpadmin -p <name> -v <network-path> -P <ppd-file> -o printer-is-shared=true -E
```

View a printer queue with:

```bash
lpq -P <name>
```

View all printers with:

```bash
lpstat -a
```

To set the `ErrorPolicy` (See [CUPS Documentation](https://www.cups.org/doc/man-cupsd.conf.html)) for the printer, do:

```bash
lpadmin -p <name> -o printer-error-policy=retry-current-job -E
```

Send a test print job:

```bash
echo "Test<p>" | lpr -P <name>
```

Remove a job from a printer queue with:

```bash
lprm -P <name>
```

To enable a printer again after it is pause:

```bash
cupsenable <printer-name>
```

This is the same as the `-E` argument on `lpadmin`.

To remove a printer:

```sh
lpadmin -x <name>
```

## Example: BOCA Thermal Printers

[Boca Installation Information](https://www.bocasystems.com/tech.html)

For raster printing, you can download the [Boca Printer Drivers](https://tls-bocasystems.com/en/52/linux/) and install with:

```sh
dpkg --install boca.amd64-2.1.0-linux-3.13-amd64.deb
cd /usr/share/cups/model/custom/boca/
gunzip *
```

Then you need to use a serial USB connection:

```sh
lpadmin -p devticket0 -v serial:/dev/usb/lp0 -P /usr/share/cups/model/custom/boca/boca462.ppd
```

## Example: Installing HID HDP5000 Badge printer

Get the driver from [HID FARGO HDP5000 Linux Driver](https://www.hidglobal.com/drivers/14800).  You have to accept some terms, so you need to download it manually.

Then:

```bash
sudo -s
cd /
tar -xvzf HDP5000_Linux-1.0.0.4-1.tgz
```

This printer needs to run a rasterizer program to convert PDF content which needs some 32 bit libraries:

```bash
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install libcups2:i386 libcupsimage2:i386 libstdc++6:i386
```

Then the rasterizer runs with:

```bash
/usr/lib/cups/filter/rastertofargoHDP5000
```

It also uses Ghostscript:

```bash
sudo apt install ghostscript
```

Finally, create the printer queue entry with the PPD driver:

```bash
lpadmin -p <name> -v socket://10.10.10.10:9100 -P /usr/share/cups/model/HDP5000.ppd -E
lpoptions -p <name> -o "Ribbon=PremiumResin"
```

## References

[Friendly Ghost Language (FGL) Primer](http://www.ncsoftware.com/TrakProHelp/FGLPrimer.htm)
[Debugging Ubuntu Printing Problems](https://wiki.ubuntu.com/DebuggingPrintingProblems)
[CUPS](https://www.cups.org/)
[Setting Up a Raw Printer on Ubuntu](https://github.com/qzind/tray/wiki/Setting-Up-A-Raw-Printer-in-Ubuntu-Linux)
[Installing CUPS printer via command line](https://blog.ostermiller.org/ubuntu-printer-install-command-line/)