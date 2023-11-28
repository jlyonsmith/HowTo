# Installing OctoPrint

[OctoPrint](https://octoprint.org/) is a web interface for 3D printers.  There are mobile apps and a range of plug-ins that allow you to control and observe a 3D printer remotely while it prints.

## Installing OctoPi

[OctoPi](https://github.com/guysoft/OctoPi) is a pre-built OctoPrint image for Raspberry Pi hardware and is the easy way to install OctoPrint.

1. Download the [Raspberry Pi Imager](https://www.raspberrypi.com/software/) software.  Plug in the SD card.  Flash the OctoPi image onto it.
2. Configure your WiFi by editing octopi-wpa-supplicant.txt on the root of the flashed card when using it like a thumb drive
3. Boot the Pi from the card.  Log into your Pi via SSH (it is located at octopi.local if your computer supports bonjour or the IP address assigned by your router), default username is "pi", default password is "raspberry". Run sudo raspi-config. Once that is open:
   - Change the password via "Change User Password"
   - Optionally, change the configured timezone via "Localization Options" > "Timezone"
   - Optionally, change the hostname via "Network Options" > "Hostname". Your OctoPi instance will then no longer be reachable under `octopi.local` but rather the hostname you chose postfixed with `.local`, so keep that in mind.
4. As `sudo` do `chmod u=rw /etc/sudoers.d/010_pi-nopasswd`, edit the file to uncomment the line, save and then `chmod u=r` again.
5. In `/etc/ssh/sshd_config` change set `PasswordAuthentication no` to disable password login.
6. Optionally, change the password for user `pi` with `passwd`.
7. Hit OctoPrint server and run through the wizard.

## Backup Settings

[Backup existing settings](https://docs.octoprint.org/en/master/bundledplugins/backup.html) in case you lose your Raspberry Pi for some reason.

## Restart Webcam

Restart the webcam service if you unplug the camera with:

```sh
sudo systemctl restart webcamd
```

For newer OctoPrint systems:

```sh
libcamera-hello
libcamera-jpeg -o test.jpg
```

If there is a `test.jpg` file, then:

```sh
vi /boot/camera-streamer/libcamera.conf
```

Edit the file to contain the correct parameters.

```sh
systemctl enable camera-streamer
systemctl start camera-streamer
```

## Upgrading the Raspberry Pi Distro

Run `sudo apt update && sudo apt dist-upgrade && sudo apt-get autoremove && sudo apt clean && sudo reboot now`

## Install an SSL Certificate

Upgrade the distro (see above). Run `haproxy -v` to check the proxy software is installed.  Create a certificate and a private key using whatever method you wish and copy them locally with `scp`.

```sh
sudo -s
cd /etc/ssl
cat octopi.domain.org.crt octopi.domain.org.key > snakeoil.pem
```

Edit `/etc/haproxy/haproxy.cfg`.  Update as follows:

```yaml
frontend public
  ...
  option forwardfor except 127.0.0.1
  redirect scheme https if !{ hdr(Host) -i 127.0.0.1 } !{ ssl_fc }
  ...
```

Run `haproxy -c -- /etc/haproxy/haproxy.cfg` to check you did not make a typo, then `systemctl restart haproxy`.  The OctoPi web interface will kick out if you are logged, but you should now be using HTTPS to connect in your browser.

## References

[Setting Up Your Raspberry Pi](https://www.raspberrypi.com/documentation/computers/getting-started.html#using-raspberry-pi-imager)
