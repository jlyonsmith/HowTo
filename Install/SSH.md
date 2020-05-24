# Installing SSH

## Server

### Disable SSH password login

Once you are able to login to the system with key authentication, disable password SSH login:

```sh
sudo vi /etc/ssh/sshd_config
```

Set the following option:

```config
ChallengeResponseAuthentication no
PasswordAuthentication no
```

Then:

```sh
sudo systemctl reload sshd
```

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
