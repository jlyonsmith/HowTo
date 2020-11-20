# Create a New Sudo User Debian/Ubuntu

## Setup

Install `sudo` on Debian:

```sh
apt install sudo
```

## Adding the user

The following must be run as `root`.

Set `USER` to the user name.  Add the new user:

```sh
adduser $USER
```

Use [Strong Password Generator](https://strongpasswordgenerator.com/).  Add the users full name at a minimum.

Add to the `sudo` group:

```sh
usermod -aG sudo $USER
```

If desired, add an entry to allow the user to use `sudo` without entering a password:

```sh
export EDITOR=$(which vi)
vi /etc/sudoers.d/$USER
chmod 440 /etc/sudoers.d/$USER
visudo -c
```

And add an entry:

```sudo
$USER ALL=(ALL) NOPASSWD:ALL
```

Instead of the last `ALL` you can add a comma separated list of commands (including args if needed, i.e. `apt install`).

Do some testing:

```sh
getent group sudo
su - john
sudo whoami
```

If `getent` does not return anything, the user was not added to the `sudo` group.  `whoami` should return `root`.

While still impersonating `$USER`:

```bash
mkdir ~/.ssh
chmod u=rwx,go= .ssh
cd ~/.ssh
touch authorized_keys
chmod u=rw authorized_keys
vi authorized_keys
```

Paste in the public key.
