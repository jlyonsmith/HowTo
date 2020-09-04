# Set Locale on Ubuntu

## Steps for US English

First, generate the `en_US` locales:

```sh
sudo locale-gen en_US
sudo locale-gen en_US.UTF-8
```

Edit `/etc/profile` and add:

```sh
# Set en_US locale
export LANG="en_US.UTF8"
export LANGUAGE="en_US.UTF8"
export LC_ALL="en_US.UTF8"
```

To test, run `locale`:

```sh
LANG=en_US.UTF8
LANGUAGE=en_US.UTF8
LC_CTYPE="en_US.UTF8"
LC_NUMERIC="en_US.UTF8"
LC_TIME="en_US.UTF8"
LC_COLLATE="en_US.UTF8"
LC_MONETARY="en_US.UTF8"
LC_MESSAGES="en_US.UTF8"
LC_PAPER="en_US.UTF8"
LC_NAME="en_US.UTF8"
LC_ADDRESS="en_US.UTF8"
LC_TELEPHONE="en_US.UTF8"
LC_MEASUREMENT="en_US.UTF8"
LC_IDENTIFICATION="en_US.UTF8"
LC_ALL=en_US.UTF8
```