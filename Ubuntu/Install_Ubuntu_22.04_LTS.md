# Install Ubuntu 22.04 LTS

Step-by-step instructions for creating a new Ubuntu 22.04 LTS service instance.

## Initial Steps

Log in using virtualization systems console functionality. Remote SSH login will be disabled for root by default.

Check the version with `lsb_release -a`:

```txt
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 22.04 LTS
Release:        22.04
Codename:       jammy
```

If host name is not correct use `hostnamectl hostname XXX` to change it, then:

```sh
apt update; apt upgrade -y`
```

On Debian, install `sudo`:

```sh
apt install sudo
```

## Create a New Sudo User

As `root` set `NEWUSER=` and `FULLNAME=` then:

```sh
adduser --disabled-password --gecos "$FULLNAME" $NEWUSER
usermod -aG sudo $NEWUSER
echo "$NEWUSER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$NEWUSER
chmod ug=r,o= /etc/sudoers.d/$NEWUSER
visudo -c
```

Instead of the last `ALL` you can add a comma separated list of commands (including args if needed, i.e. `apt install`).

Do some testing:

```sh
getent group sudo
su - $NEWUSER
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

## Lock Down the System

Configure SSH with [Installing and Configuring SSH](../Install/SSH.md)

Configure the IPTables with [Installing and Configuring IPTables](../Install/IPTables.md)

Disable the password for the `root` user with:

```sh
sudo passwd -l root
```

*This will allow people to become root with `sudo` but logging in with `root` account is no longer possible, including through the ProxMox console! Do this as a last step after IPTables and SSH lock down have been done.  It's really frustrating to be locked out of a system and have to rebuild it from scratch.*

Check if the password for an account is locked with `sudo passwd -S $USER`.  There should be an `L` in the resulting listing.

## Snapshot

Now is a good time to take a snapshot of the machine if you are using ProxMox or another virtualization system.
