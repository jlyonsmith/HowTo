## Installing MongoDB on macOS

To install MongoDB on macOS using `launchd` follow these steps:

Install with Homebrew:

```bash
brew install mongodb
```

Switch to super user mode:

```bash
sudo -s
```

First we need to create a `_mongodb` user and group:

```bash
dscl
cd /Local/Default
ls Groups gid
```

Find a group id that is not in use under 500, e.g. 300.  Then:

```bash
create Groups/_mongodb
create Groups/_mongodb PrimaryGroupID 300
ls Users uid
```

Find a user id that is available under 500, e.g. 300.  Then:

```bash
create Users/_mongodb UniqueID 300
create Users/_mongodb PrimaryGroupID 300
create Users/_mongodb UserShell /usr/bin/false
create Users/_mongodb NFSHomeDirectory /var/empty
```

This creates a user with no HOME directory and no shell.  Now add the user to the `_mongodb` group:

```bash
append Groups/_mongodb GroupMembership _mongodb
exit
```

Finally, stop the user from showing up on the login screen with:

```bash
dscl . delete /Users/_mongodb AuthenticationAuthority
dscl . create /Users/_mongodb Password "*"
```

Now create the database and log file directories and assign ownership to the `_mongodb` user:

```bash
mkdir -p /var/lib/mongodb
chown _mongodb:_mongodb /var/lib/mongodb
mkdir -p /var/log/mongodb
chown _mongodb:_mongodb /var/log/mongodb
```

Create a `/etc/mongod.conf` file and put the following in it:

```
systemLog:
  destination: file
  path: "/var/log/mongodb/mongodb.log"

storage:
  dbPath: "/var/lib/mongodb"

net:
  bindIp: 127.0.0.1

security:
  authorization: disabled
```

Now create a `/Library/LaunchDaemons/org.mongo.mongod.plist` file and put the following in it:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>org.mongo.mongod</string>
    <key>RunAtLoad</key>
    <true/>
    <key>ProgramArguments</key>
    <array>
      <string>/usr/local/bin/mongod</string>
      <string>--config</string>
      <string>/etc/mongod.conf</string>
    </array>
    <key>UserName</key>
    <string>_mongodb</string>
    <key>GroupName</key>
    <string>_mongodb</string>
    <key>InitGroups</key>
    <true/>
    <key>KeepAlive</key>
    <false/>
    <key>HardResourceLimits</key>
    <dict>
      <key>NumberOfFiles</key>
      <integer>4096</integer>
    </dict>
    <key>SoftResourceLimits</key>
    <dict>
      <key>NumberOfFiles</key>
      <integer>4096</integer>
    </dict>
  </dict>
</plist>
```

Finally, start the `mongod` daemon with:

```bash
launchctl load /Library/LaunchDaemons/org.mongo.mongod.plist
```

You can ensure that MongoDB is running by checking the log in the **Console** app and running the `mongo` command line tool.  [RoboMongo](https://robomongo.org/) is a good GUI tool.
