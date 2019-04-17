# Changing Keyboard on Ubuntu and CentOS

Install `kbd` package:

```
yum install kbd
```

or:

```
apt install kbd
```

Then:

```
loadkeys us-dvorak
```

and on Ubuntu:

```
loadkeys dvorak
```

Look under `/lib/kbd/keymaps/xkb` for the complete list of key maps on CentOS.
