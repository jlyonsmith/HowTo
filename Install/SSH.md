# Installing and Configuring SSH

## Installing on CentOS

Install the SSH packages:

```sh
yum install openssh openssh-server openssh-clients openssl-libs
```

## Harden the Server

Replace `/etc/ssh/sshd_config` with:

```conf
#Harden the ciphers and algorithms
HostKey /etc/ssh/ssh_host_ed25519_key
HostKey /etc/ssh/ssh_host_rsa_key
KexAlgorithms curve25519-sha256@libssh.org
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com

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

Run `sshd -t` and confirm no errors. Then restart the SSH daemon again with `systemctl restart sshd`.

NOTE: This will change the fingerprint of the host, so you will need to remove it from your local `~/.ssh/known_hosts` file.

See below for changes needed to use Google Authenticator, which is only required on your SSH bastions.

## Debug Connections

To view the SSH log use:

```bash
journalctl -u ssh -f
```

## Audit your Bastion

On a system connected to the Internet (not the server you are trying to configure), download and run [ssh-audit](https://github.com/arthepsy/ssh-audit) to check that the SSH daemon on the server is properly hardened:

```sh
./ssh-audit my-server.my-domain.com
```

## Install MFA With Google Authenticator

Install Googles PAM module:

```sh
sudo apt install libpam-google-authenticator
```

Then for each user:

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

Restart SSH with `systemctl restart sshd`.

Now edit `/etc/ssh/sshd_config` and change the following lines:

```conf
UsePAM yes

ChallengeResponseAuthentication yes

AuthenticationMethods publickey,keyboard-interactive
```

Run `sshd -t` and confirm no errors. Then restart the SSH daemon again with `systemctl restart sshd`.

See [How To Set Up Multi-Factor Authentication for SSH on Ubuntu](https://www.digitalocean.com/community/tutorials/how-to-set-up-multi-factor-authentication-for-ssh-on-ubuntu-16-04).

## Connecting Through a Bastion

Your bastion SSH machines should be used to proxy through to machines on the servers private network:

```conf
Host some-host
  Hostname 10.10.10.2
  User some-user
  ProxyJump bastion.some-domain.com
  IdentityFile ~/.ssh/id_rsa
```

Your bastions should be maximally hardened against SSH attacks.  The private machines should only be allowed SSH access via the private network.

## Connection Pooling on the Client

Add the following to your `~/.ssh/config` under the bastion entry:

```conf
Host bastion1
  ...
  ControlPath ~/.ssh/control-%r@%h:%p
  ControlMaster auto
  ControlPersist 1
```

This will activate [connection sharing](https://tanguy.ortolo.eu/blog/article42/ssh-connection-sharing) for connections to or through that machine, so you don't have to do MFA repeatedly for example.

## Correct Permissions for  SSH Client Directories and Files

Correct permissions for `.ssh` directory & files:

```sh
chmod go-w ~/
chmod u=rwx,go= ~/.ssh
chmod u=rw,go= ~/.ssh/authorized_keys
chmod u=rw,go= ~/.ssh/id_rsa
chmod u=rw,go=r ~/.ssh/id_rsa.pub
```
