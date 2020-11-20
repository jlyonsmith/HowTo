# Lockdown SSH on Debian/Ubuntu

## Server

Replace `/etc/ssh/sshd_config` with:

```ssh
# Security best practice
PermitRootLogin no

# Only allow PPK
PasswordAuthentication no
ChallengeResponseAuthentication no

# For 2FA
UsePAM yes

# Timeout after 10 minutes of inactivity
ClientAliveInterval 600
ClientAliveCountMax 0

# Who's using X11?
X11Forwarding no

# For security message
PrintMotd yes

# Pass in these environment variables
AcceptEnv LANG LC_*

# For remote file transfer on Ubuntu
Subsystem       sftp    /usr/lib/openssh/sftp-server
```

Test for errors with `sshd -t` and then `systemctl restart sshd`.

## Client

Correct permissions for `.ssh` directory & files:

```sh
chmod go-w ~/
chmod u=rwx,go= ~/.ssh
chmod u=rw,go= ~/.ssh/authorized_keys
chmod u=rw,go= ~/.ssh/id_rsa
chmod u=rw,go=r ~/.ssh/id_rsa.pub
```
