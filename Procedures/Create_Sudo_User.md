# Create a Sudo User Debian/Ubuntu

## Steps

Install `sudo` on Debian:

```sh
apt install sudo
export USER=<user>
```

The following must be run as `root`.

Set `USER` to the user name and `PASSWORD` to the desired password.  Add the new user:

```sh
adduser  --disabled-password --gecos "<Full Name>" $USER
chpasswd <<<"$USER:$PASSWORD"
```

Use [Strong Password Generator](https://strongpasswordgenerator.com/).  Add the users full name at a minimum as GECOS (`finger`) information.

Add to the `sudo` group:

```sh
usermod -aG sudo $USER
```

If desired, add an entry to allow the user to use `sudo` (without entering a password):

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

Paste in the public key (`cat ~/.ssh/id_rsa.pub | pbcopy` from macOS)

Set basic `.bash_profile`:

```bash
# The interactive shell start-up file
# You can safely echo stuff to the terminal in here

[[ -r ~/.bashrc ]] && source ~/.bashrc

title $(hostname)
```

and basic `.bashrc`:

```bash
# The individual non-interactive shell startup file
# DO NOT print anything in this script or you will break the SCP protocol

PROMPT_1="[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]"
PROMPT_2="]\n\$"

export PS1="${PROMPT_1}${PROMPT_2}"

unset PROMPT_1
unset PROMPT_2

export EDITOR='vi'
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# History
export HISTCONTROL=ignoredups:erasedups

# Function for setting terminal titles
function title {
  printf "\x1b]0;%s\x7" "$1"
}

#Aliases
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias ll='ls -al'
alias ls='ls --color=auto'
alias ipts="iptables-save"
alias iptr="iptables-restore"
alias sc="systemctl"
alias jc="journalctl"
```

It's also a good idea to set these scripts for the `root` user in the `/root` directory.

## Lock down `root`

If you have a working `sudo` user, another way to increase system security is to disable the password for the `root` user with:

```sh
sudo passwd -l root
```

This will allow people to become root with `sudo` but logging in with `root` account is no longer possible, including through the ProxMox console.  Do this as a _last step_ after IPTables and SSH lock down have been done.  It's really frustrating to be locked out of a system and have to rebuild it from scratch.

## Notes

On Ubuntu 20.04 you may need to do `echo "Set disable_coredump false" >> /etc/sudo.conf` to avoid the message:

```bash
sudo: setrlimit(RLIMIT_CORE): Operation not permitted
```
