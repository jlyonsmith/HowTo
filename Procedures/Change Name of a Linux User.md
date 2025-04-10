---
name: "Change User Name"
---

You cannot rename the user you are logged in as.  So either login as root or create a temporary user and use that to rename:

```bash
sudo -Es
NEWUSER=<new-user>
OLDUSER=<old-user>
usermod -l $NEWUSER $OLDUSER
usermod -d /home/$NEWUSER -m $NEWUSER
```

The users UID & GID should be preserved, and so all files will still have the correct ownership.  

If the user is a `sudo` user then:

```bash
cd /etc/sudoers.d
mv $OLDUSER $NEWUSER
sed -i "s/$OLDUSER/$NEWUSER/g" $NEWUSER
visudo -c
```

To create a temporary user for the above:

```bash
sudo -Es
adduser temp # follow prompts to set password
usermod -aG sudo temp # to allow user to sudo with password
# exit, login as new user, rename user as above
deluser temp
rm -r /home/temp
```

