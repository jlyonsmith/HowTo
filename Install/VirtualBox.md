# Install VirtualBox

## On macOS

VirtualBox is a free and open-source hosted hypervisor for x86 computers. It can be installed with Homebrew:

`brew cask install virtualbox`

Or by downloading from the [VirtualBox website](https://www.virtualbox.org/).

## Guest Additions

Guest additions allow VirtualBox to do cool things like mount folders from the guest operating system.

Launch VirtualBox and power on the Ubuntu machine and log on. Once logged in, click on the **Devices** menu (you have to have the VM window selected on macOS).

Select "Insert Guest Additions CD Image". Mount it on the guest system, install dependencies and run the installer:

```bash
sudo -s
mkdir /mnt/cdrom
chown nobody:nogroup /mnt/cdrom
mount /dev/cdrom /mnt/cdrom
cd /mnt/cdrom
apt-get install -y dkms build-essential linux-headers-generic linux-headers-$(uname -r)
./VboxLinuxAdditions.run
shutdown -r now
```

After reboot:

```bash
rm -rf /mnt/cdrom
```

To mount a host folder on the guest system us the VirtualBox UI.  When you share files from the host, add your user to the `vboxsf` group:

```bash
sudo usermod -G vboxsf -a $USER
```

You might need to logout and back in again.
