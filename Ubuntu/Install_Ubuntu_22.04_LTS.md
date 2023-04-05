# Install Ubuntu 22.04 LTS

Step-by-step instructions for creating a new Ubuntu 22.04 LTS service instance.

## Initial Steps

Log in to system as root using provided password.  Using SSH:

```sh
ssh root@x.mydomain.com
```

Or using your virtualization systems console functionality.

Then check the version with `lsb_release -a`:

```txt
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 22.04 LTS
Release:        22.04
Codename:       jammy
```

If host name is not correct use `hostnamectl` to change it.

Do an `apt update; apt upgrade -y`.

## Debian Specific

Install `sudo`:

```sh
apt install sudo
```

## VIM

First, `apt install vim`. Then set defaults in `~/.vimrc`:

```vimrc
:set shiftwidth=2
:set tabstop=2
:set expandtab
```

## Create New Sudo User

As `root` add the new `USER` with `FULLNAME` and `PASSWORD`:

```sh
adduser --disabled-password --gecos "$FULLNAME" $USER
```

Set a password for the user, even if you are using PPK's for `ssh`':

```sh
chpasswd <<<"$USER:$PASSWORD"
```

Don't add special characters to the password, just alphanumeric.

Add to the `sudo` group:

```sh
usermod -aG sudo $USER
```

Add an entry to allow the user to use `sudo` without entering a password:

```sh
echo "$USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER
chmod ug=r,o= /etc/sudoers.d/$USER
visudo -c
```

Instead of the last `ALL` you can add a comma separated list of commands (including args if needed, i.e. `apt install`).

Do some testing:

```sh
getent group sudo
su - $USER
whoami
```

If `getent` does not return anything, the user was not added to the `sudo` group.  `whoami` should return `$USER`.

While still impersonating `$USER`:

```bash
mkdir ~/.ssh
chmod u=rwx,go= ~/.ssh
cd ~/.ssh
touch authorized_keys
chmod u=rw authorized_keys
vi authorized_keys
```

Paste in the $USER public key. You can use `cat ~/.ssh/id_rsa.pub | pbcopy` on macOS.

Test that `USER` can `ssh` into the machine.

## Disable SSH Password Login

Once you are able to login to the system with key authentication, disable password SSH login:

```sh
sudo vi /etc/ssh/sshd_config
```

Set the following option:

```sh
PasswordAuthentication no
```

Then:

```sh
sudo systemctl reload sshd
```

## Configure IPTables and SSH

Follow the instructions in [Installing and Configuring SSH](../Install/SSH.md) and also [Installing and Configuring IPTables](../Install/IPTables.md)

## Lock Down `root`

Once you have a working `sudo` user increase system security by disabling the password for the `root` user with:

```sh
sudo passwd -l root
```

This will allow people to become root with `sudo` but logging in with `root` account is no longer possible, including through the ProxMox console.

*Do this as a last step after IPTables and SSH lock down have been done.  It's really frustrating to be locked out of a system and have to rebuild it from scratch.*

Check if the password for an account is locked with `sudo passwd -S $USER`.  There should be an `L` in the resulting listing.

## Snapshot

Now is a good time to take a snapshot of the machine if you are using ProxMox or another virtualization system.
