# Installing and Configuring SSH

## Harden the Server

Replace `/etc/ssh/sshd_config` with:

```conf
# Harden the ciphers and algorithms
HostKey /etc/ssh/ssh_host_ed25519_key
HostKey /etc/ssh/ssh_host_rsa_key
KexAlgorithms curve25519-sha256@libssh.org
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com

# Security best practice
PermitRootLogin no

# Only allow PPK
PasswordAuthentication no
KbdInteractiveAuthentication no

# For 2FA
UsePAM yes

# Timeout after 10 minutes of inactivity
ClientAliveInterval 600
ClientAliveCountMax 0

# Who's using X11?
X11Forwarding no

# For security messages
PrintMotd yes

# Pass in these environment variables
AcceptEnv LANG LC_*

# For remote file transfer on Ubuntu
Subsystem       sftp    /usr/lib/openssh/sftp-server
```

Run `sshd -t` and confirm no errors. Then restart the SSH daemon again with `systemctl restart sshd`.

NOTE: This may change the fingerprint of the host. If so you will need to remove it from your local `~/.ssh/known_hosts` file.

See below for changes needed to use Google Authenticator, which is only required on your SSH bastions.

## Debug Connections

To view the SSH log use:

```bash
journalctl -u ssh -f
```

## Install MFA With Google Authenticator

For your Bastion machine, install the Google Authenticator PAM module:

```sh
sudo apt install libpam-google-authenticator
```

Edit `/etc/pam.d/sshd`.  Comment out `@include common-auth`.  Add `auth required pam_google_authenticator.so` at the end of the file.

Restart SSH with `systemctl restart ssh`.

Now edit `/etc/ssh/sshd_config` and change the following lines:0

```conf
UsePAM yes

# Pre Ubuntu 22.04
# ChallengeResponseAuthentication yes
KbdInteractiveAuthentication yes

AuthenticationMethods publickey,keyboard-interactive
```

Run `sshd -t` and confirm no errors. Then restart the SSH daemon again with `systemctl restart sshd`.

See [How To Set Up Multi-Factor Authentication for SSH on Ubuntu](https://www.digitalocean.com/community/tutorials/how-to-set-up-multi-factor-authentication-for-ssh-on-ubuntu-16-04).

## Adding a New Google Authenticator User

Then for each user:

```bash
sudo su - $USER
google-authenticator
```

With the following responses:

```txt
Do you want authentication tokens to be time-based (y/n) y
```

Copy the code into your password manager, and enter the first code to confirm it.  Then:

```txt
Do you want me to update your "/home/$USER/.google_authenticator" file?(y/n) y
Do you want to disallow multiple uses of the same authentication
token? ...(y/n) y
By default, a new token is generated every 30 seconds by the mobile app. ... (y/n) n
If the computer that you are logging into isn't hardened against brute-force
login attempts, ... (y/n) n
```

Have the user save the key, verification code and emergency codes in their password vault.

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

## Audit your Bastion

On a system connected to the Internet (not the server you are trying to configure), download and run [ssh-audit](https://github.com/arthepsy/ssh-audit) to check that the SSH daemon on the server is properly hardened:

```sh
./ssh-audit my-server.my-domain.com
```

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

## Correct Permissions for SSH Client Directories and Files

Correct permissions for `.ssh` directory & files:

```sh
chmod go-w ~/
mkdir .ssh
chmod u=rwx,go= .ssh
cd .ssh
touch authorized_keys
chmod u=rw,go= authorized_keys
chmod u=rw,go= id_rsa
chmod u=rw,go=r id_rsa.pub
```

## Installing on CentOS

On CentOS you may have to install SSH with:

```sh
yum install openssh openssh-server openssh-clients openssl-libs
```
