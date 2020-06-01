# Installing SSH

## Server

### Harden the Server

Once you are able to login to the system with key authentication, disable password SSH login:

```sh
sudo vi /etc/ssh/sshd_config
```

Find and set following options:

```conf
ChallengeResponseAuthentication yes
PasswordAuthentication no
PermitRootLogin no
ClientAliveInterval 300
ClientAliveCountMax 2
```

Harden the ciphers and algorithms:

```conf
HostKey /etc/ssh/ssh_host_ed25519_key
HostKey /etc/ssh/ssh_host_rsa_key
KexAlgorithms curve25519-sha256@libssh.org
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com
```

Then:

```sh
sudo systemctl reload sshd
```

### Audit

Download and run [ssh-audit](https://github.com/arthepsy/ssh-audit) to check that your SSH is properly hardened.

### Install `fail2ban`

```sh
sudo apt install fail2ban
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
```

Open `/etc/fail2ban/jail.local` and edit:

```conf
[sshd]
enabled  = true
port    = ssh
logpath = %(sshd_log)s
```

Restart service with `sudo systemctl restart fail2ban`.

### MFA With Google Authenticator

```bash
sudo su - $USER
google-authenticator
```

Then:

```txt
Do you want authentication tokens to be time-based (y/n) y
Disallow multiple uses...(y/n) y
Increase token time window...?(y/n) n
Rate limiting...?(y/n) n
```

Edit `/etc/pam.d/sshd`.  Comment out `@include common-auth`.  Add `auth required pam_google_authenticator.so` at the end of the file.

Edit `/etc/ssh/sshd_config` and add:

```conf
UsePAM yes
ChallengeResponseAuthentication yes
AuthenticationMethods publickey,keyboard-interactive
```

See [How To Set Up Multi-Factor Authentication for SSH on Ubuntu](https://www.digitalocean.com/community/tutorials/how-to-set-up-multi-factor-authentication-for-ssh-on-ubuntu-16-04).

## Client

### Connection Pooling

Add the following to your `~/.ssh/config` under any entry:

```conf
Host bastion1
  ...
  ControlPath ~/.ssh/control-%r@%h:%p
  ControlMaster auto
  ControlPersist 1
```

This will activate [connection sharing](https://tanguy.ortolo.eu/blog/article42/ssh-connection-sharing) for connections to or through that machine. This is particularly useful for bastion machines.
