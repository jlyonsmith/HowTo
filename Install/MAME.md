# Install MAME on macOS

[MAME](https://www.mamedev.org/index.php)

1. Download build from [sdlmame.lngn.net](https://sdlmame.lngn.net/).  Unpack and put in `/Applications`, renaming the folder to just `mame`.
2. Download [SDL2](http://www.libsdl.org/download-2.0.php), unpack and put into `/Library/Frameworks`
3. Download [M64](https://github.com/bamf2048/bamf2048.github.io/releases/download/M64/M64.app.zip) and put in `/Applications`

Right click on `M64`, Show Contents, edit the `Resources/script` file with a text editor:

```sh
#!/bin/sh

cd ../../../mame
./mame
```

Run `spctl --disable`, run `M64`, deal with all the warnings.  Go to System Preferences to allow `mame` and `SDL2.framework` to run.

## ROMS

Download a batch of ROMS from a torrent link listed on [The Pirate Bay](https://thepiratebay.org/index.html).

List of sites for downloading individual games:

- [CoolRom](https://coolrom.com.au/roms/mame/)
- [ROMNation](https://www.romnation.net/srv/roms/mame.html)

Remember that some ROM's are shared between games, or cloned. There's an [explanation](https://wiki.mamedev.org/index.php/FAQ:ROMs) on the MAME site. Use the `mame -listclones` file to see which games are clones of other games.  Make sure you download the file in the right-hand column.

Download the `history.xml` file from [Gaming Histor](https://www.arcade-history.com/) and place it in the `history` directory and delete any existing `.db` file.

## Cheats

Go to [Pugsy's Cheats](http://cheat.retrogames.com/mame_downloads.htm) and download the latest file.

Create a `mame/cheat` directory. Run `./mame -createconfig` to create a default `mame.ini`.  Edit and change `cheat` to `1`.  Copy in the downloaded cheat files to the `cheat` directory.

## References

- [Running MAME on macOS](http://bamf2048.github.io/sdl_mame_tut/)
- [Running MAME arcade emulator on Mac OS X](https://retrogamesultra.com/2019/02/24/running-the-mame-arcade-emulator-on-mac-os-x/)
