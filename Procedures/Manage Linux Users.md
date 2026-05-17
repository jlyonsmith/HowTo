---
name: "Change User Name"
---
## Create a New Sudo User

As `root` set `NEWUSER=` and `FULLNAME=` then:

```sh
sudo -Es
adduser --disabled-password --gecos "$FULLNAME" $NEWUSER
usermod -aG sudo $NEWUSER
echo "$NEWUSER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$NEWUSER
chmod ug=r,o= /etc/sudoers.d/$NEWUSER
visudo -c
```

Then you need to add an SSH key for them.

```sh
sudo -Es
cd /home/$NEWUSER
mkdir .ssh
chmod u=rwx,go= .ssh
cd .ssh
touch authorized_keys
vi authorized_keys # Add the public key
chmod u=rw,go= authorized_keys
```
## Change the Name of User

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

