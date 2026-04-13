## Steps

Run the installation from a USB stick or other mechanism.  Add `ssh` daemon support.
Log in as the user that you created over `ssh`.

1. Add password-less `sudo`.
   
```sh
USER=...
sudo cat "$USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER
chmod 0440 /etc/sudoers.d/$USER
visudo -c
```

2. Ensure `root` user disabled.

```sh
sudo passwd -l root
```

3. Copy your public key for `ssh`:

```sh
# On your laptop
cat ~/.ssh/id_ed25519.pub | pbcopy
```

4. Add your key to the server `~/.ssh/authorized_keys` file and ensure you can connect without a password.
5. Run `apt update && apt -y upgrade && apt -y autoremove`
6. Run `ssh-keygen -t ed25519 -C "$USER$@example.com"` to generate a local SSH key
7. `timedatectl set-timezone America/Los_Angeles`

Now you can run whatever specific installation steps you want.
