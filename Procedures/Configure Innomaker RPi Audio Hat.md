## Overview

These are instructions for setting up an [InnoMaker PCM5122 HiFi DAC HAT for Raspberry Pi 5/4/3B+/Zero](https://www.amazon.com/InnoMaker-Raspberry-Pi-HiFi-DAC/dp/B07D13QWV9)
## Setup

Configure the RPi as normal.  Then edit `/etc/firmware/config.txt` and add:

```conf
dtoverlay=allo-boss-dac-pcm512x-audio
```

to the end of the file in the `[all]` section.

Then `sudo reboot now`.

Run `aplay -l` and find the card number of the devices called `BossDAC`.  Double check with `cat /proc/asound/cards`.

Now edit `/etc/modprobe.d/alsa-base.conf` and add:

```conf
# Set the order of sound cards
options snd_soc_es9038q2m index=3
```

This will fix the index of the device.

Next, set the default device for audio output.  Edit `/etc/asound.conf` (creating it if it does not exist) and add at the end:

```conf
pcm.!default { type hw card 3 } ctl.!default { type hw card 3 }
```

Reboot again.

Now go to `raspi-config`.  Go to *System Options -> Audio* and select *BossDAC*.   This should update the local `~/.asoundrc` file.

Reboot again.

Install `mpg123` or use `aplay` to play a `.mp3` or `.wav` file respectively.
## References

- [InnoMaker HiFi DAC HAT Manual](https://www.inno-maker.com/wp-content/uploads/2017/11/HIFI-DAC-User-Manual-V1.2.pdf)
