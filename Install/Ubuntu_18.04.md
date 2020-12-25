# Ubuntu 18.04 Bionic

## Check Version

To see the Ubuntu version:

```sh
lsb_release -a
```

To get something like:

```txt
Distributor ID: Ubuntu
Description:    Ubuntu 18.04.1 LTS
Release:        18.04
Codename:       bionic
```

## Rename Host

To make the `hostname` command "stick" you need to do:

1. Set `echo "preserve_hostname true" > /etc/cloud/cloud.cfg`
2. Update hostname with `sudo hostnamectl set-hostname ubuntu-1`
3. `sudo reboot now`

## Lock-down `root`

If not using a key, change the `root` password using [Strong Password Generator](http://strongpasswordgenerator.com/):

```sh
passwd
```

## Add `ubuntu` User

If you want to use an `ubuntu` user which has root access, like Amazon does with EC2, `ssh` to the system as `root` and log in with provided password.

Create the `ubuntu` user:

```sh
adduser ubuntu
```

Use [Strong Password Generator](http://strongpasswordgenerator.com/) to generate a password.

Now add the ubuntu user as a sudoer:

```sh
cd /etc/sudoers.d
vi ubuntu
```

Add the following:

```sudo
# Add sudo permission for ubuntu user
ubuntu ALL=(ALL) NOPASSWD:ALL
```

Now change the permissions on the file:

```sh
chmod 440 ubuntu
```

See the [Sudo Manual](http://www.sudo.ws/sudoers.man.html) for more information.

Logon as `ubuntu`, set the `PS1` prompt and check that you can `sudo`. If all is well, disable `root` user with:

```sh
sudo passwd -l root
```

## Enable SSH Login

SSH in again as `ubuntu`. Create the `.ssh` directory:

```sh
mkdir .ssh
chmod u=rwx,go= .ssh
cd .ssh
```

Copy up the `.pub` file:

```sh
scp mydomain.pem.pub ubuntu@10.10.10.10:.ssh/
```

Concat the `.pub` file to the authorized keys file:

```sh
touch authorized_keys
chmod u=rw authorized_keys
cat mydomain.pem.pub >> authorized_keys
chmod u=r,go= authorized_keys
```

Add an entry to your local `~/.ssh/config` file:

```config
Host mydomain-xxx
  User ubuntu
  HostName xxx.mydomain.com
  IdentityFile ~/.ssh/mydomain-xxx.pem
```

Close the remote shell and re-connect as `ubuntu`. You should no longer require a password. Check you can `sudo` without a password.

```sh
ssh ubuntu@xxx.mydomain.com -i ~/.ssh/mydomain.pem
```

## Proxy

If using a proxy, configure `apt` to use it by editing `/etc/apt/apt.conf` to contain:

```conf
Acquire::http::Proxy "http://yourproxyaddress:proxyport";
```

OR simply specify `proxy=...` in the `/etc/environment` file.
