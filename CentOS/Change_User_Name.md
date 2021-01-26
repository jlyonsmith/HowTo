# Rename Ubuntu

Log in as `root` or a different user and `sudo -s`, then:

```bash
NEWUSER=<new-user>
OLDUSER=<old-user>
usermod -l $NEWUSER $OLDUSER
usermod -d /home/$NEWUSER -m $OLDUSER
cd /home
rm -rf $NEWUSER
mv $OLDUSER $NEWUSER
```

The users UID & GID should be preserved, and so all files will still have the correct ownership.

If the user is a `sudo` user then:

```bash
cd /etc/sudoers.d
mv $OLDUSER $NEWUSER
sed -i "s/$OLDUSER/$NEWUSER/g" $NEWUSER
visudo -c
```
