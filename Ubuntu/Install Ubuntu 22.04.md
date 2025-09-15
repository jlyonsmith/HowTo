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
getent group sudo # if this returns nothing, user is not in the sudo group
su - $NEWUSER
whoami # should return $NEWUSER
```

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

## Shell and Prompt

Install the `fish` shell and `starship`.
## Lock Down the System

Configure SSH with [Installing and Configuring SSH](../Install/SSH.md)

Configure the NFTables for Internet facing machines with a public IP address by [Installing and Configuring NFTables](../Install/NFTables.md)
## Snapshot

Now is a good time to take a snapshot of the machine if you are using ProxMox or another virtualization system.
