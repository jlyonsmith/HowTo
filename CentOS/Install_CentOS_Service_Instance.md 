# Install CentOS 7 Service Instance

## General

Install the service instance.  It should have a `centos` user with sudo permissions and the root account should be disabled.

## VI/VIM

Install VIM:

```
yum install vim-enhanced
```

Then add to `~/.bashrc`

```
alias vi=vim
```

Then set defaults in the `~/.vimrc` file:

```
:color desert
:set shiftwidth=2
:set tabstop=2
:set expandtab
```

## Bash

Add to `.bashrc`:

```
export PS1='[\u@\h:\w]\n\$'
```

Now make it so the `centos` user does not have to enter a password:

    cd /etc/sudoers.d
    vi ubuntu

Add the following:

    # Add sudo permission for ubuntu user
    ubuntu ALL=(ALL) NOPASSWD:ALL

Now change the permissions on the file:

    chmod ug=r o= centos

See the [Sudo Manual](http://www.sudo.ws/sudoers.man.html) for more information.

Logon as `centos` and check that you can `sudo`.  If all is well, disable `root` user with:

    sudo passwd -l root

## Hostname

Change the name of the host to something meaningful:

```
sudo -s
vi /etc/hostname
```

Optionally add an entry to:

```
    vi /etc/hosts
```

Reboot the system for the change to take effect:

```
reboot
```

## SSH

### Enable SSH login for `centos`

SSH in again as `centos`.  Create the `.ssh` directory:

```
mkdir ~/.ssh
chmod u=rwx,go= .ssh
cd ~/.ssh
```

Copy your `~/.ssh/id_rsa.pub` file:

```
cat ~/.ssh/id_rsa.pub | pbcopy
```

Concat the `.pub` file to the authorized keys file:

```
touch authorized_keys
chmod u=rw authorized_keys
vi authorized_keys
```

And paste your clipboard to the end of the file.

Add an entry to your local `~/.ssh/config` file:

```
Host <hostname>
  User centos
  HostName <hostname>
  IdentityFile ~/.ssh/id_rsa
```

Close the remote shell and re-connect as `centos`.  You should no longer require a password to connect.

### Disable SSH password login

Once you are able to login to the system with key authentication, disable password SSH login:

```
sudo vi /etc/ssh/sshd_config
```

Ensure the following options:

```
ChallengeResponseAuthentication no
PasswordAuthentication no
```

Then:

```
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


