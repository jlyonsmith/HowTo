# Restart Debian/Ubuntu Systems

You can restart a system with `sudo reboot -r now`.

One way to tell if a system needs a reboot is with `cat /var/run/reboot-required`.

A better way is with the `needrestart` package.  Install with `sudo apt install needrestart`.  Then run `needrestart` to see if the kernel, services and containers need restarting.
