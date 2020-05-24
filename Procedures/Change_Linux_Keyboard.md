# Changing Keyboard on Ubuntu and CentOS

Install `kbd` package:

```sh
yum install kbd
```

or:

```sh
apt install kbd
```

On CentOS:

```sh
sudo loadkeys us-dvorak
```

On Ubuntu:

```sh
loadkeys dvorak
```

For the of supported key maps, look under `/lib/kbd/keymaps/xkb` on CentOS and `/usr/share/X11/xkb/symbols` on Ubuntu, although to see the full list you will have to grep through all the files because a single file can have multiple key maps in it.
