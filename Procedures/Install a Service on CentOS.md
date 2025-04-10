## General

Install the service instance.  It should have a `centos` user with sudo permissions and the root account should be disabled.

## VI/VIM

Install VIM:

```sh
yum install vim-enhanced
```

Then add to `~/.bashrc`

```sh
alias vi=vim
```

Then set defaults in the `~/.vimrc` file:

```sh
:color desert
:set shiftwidth=2
:set tabstop=2
:set expandtab
```

## Bash

Add to `.bashrc`:

```sh
export PS1='[\u@\h:\w]\n\$'
```

Now make it so the `centos` user does not have to enter a password:

```sh
cd /etc/sudoers.d
vi ubuntu
```

Add the following:

```sh
# Add sudo permission for ubuntu user
ubuntu ALL=(ALL) NOPASSWD:ALL
```

Now change the permissions on the file:

```sh
chmod ug=r o= centos
```

See the [Sudo Manual](http://www.sudo.ws/sudoers.man.html) for more information.

Logon as `centos` and check that you can `sudo`.  If all is well, disable `root` user with:

```sh
sudo passwd -l root
```

## Hostname

Change the name of the host to something meaningful:

```sh
sudo -s
vi /etc/hostname
```

Optionally add an entry to:

```sh
    vi /etc/hosts
```

Reboot the system for the change to take effect:

```sh
reboot
```

## SSH

### Enable SSH login for `centos`

SSH in again as `centos`.  Create the `.ssh` directory:

```sh
mkdir ~/.ssh
chmod u=rwx,go= .ssh
cd ~/.ssh
```

Copy your `~/.ssh/id_rsa.pub` file:

```sh
cat ~/.ssh/id_rsa.pub | pbcopy
```

Concat the `.pub` file to the authorized keys file:

```sh
touch authorized_keys
chmod u=rw authorized_keys
vi authorized_keys
```

And paste your clipboard to the end of the file.

Add an entry to your local `~/.ssh/config` file:

```sh
Host <hostname>
  User centos
  HostName <hostname>
  IdentityFile ~/.ssh/id_rsa
```

Close the remote shell and re-connect as `centos`.  You should no longer require a password to connect.

### Disable SSH password login

Once you are able to login to the system with key authentication, disable password SSH login:

```sh
sudo vi /etc/ssh/sshd_config
```

Ensure the following options:

```sh
ChallengeResponseAuthentication no
PasswordAuthentication no
```

Then:

```sh
sudo systemctl reload sshd
```

### Uncomplicated Firewall

Use [Uncomplicated Firewall](https://help.ubuntu.com/12.10/serverguide/firewall.html) to enable all ports, e.g.:

```
sudu -s
yum install ufw -y
yum remove firewalld -y
systemctl enable ufw
systemctl start ufw
```

Add additional rules as necessary, e.g.

```
ufw allow https
ufw allow http
```

Or

```
ufw reject http
```

See [Uncomplicated Firewall](https://wiki.ubuntu.com/UncomplicatedFirewall) for more information.

You can use the `$SSH_CONNECTION` environment variable to find your connection address:

    echo $SSH_CONNECTION

but not from the `sudo -s` shell.


