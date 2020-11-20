# MongoDB Configuration

## macOS

Install with Homebrew:

```bash
brew install mongodb
brew services start mongodb
```

## Ubuntu

The [official way](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/) to download the latest build is:

```
sudo apt-key adv --keyserver-options http-proxy=$http_proxy --keyserver hkp://keyserver.ubuntu.com:80  --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list
sudo apt update
sudo apt install -y mongodb-org
```

If you are behind a proxy, chances are it does not forward the `hkp` protocol. So you must get the key manually, by going to the [Ubuntu Key Server](http://keyserver.ubuntu.com), searching for the key `9DA31620334BD75D9DCB49F368818C72E52529D4` then copying the key into a file and doing:

```bash
sudo apt-key add <key-file>
```

Instead of the first line above.

Replace the `/etc/mongod.conf` file contents with:

```
storage:
  dbPath: /var/lib/mongodb
  journal:
    enabled: true
  engine:
    wiredTiger:

systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongodb/mongod.log

net:
  port: 27017
  bindIp: 127.0.0.1,10.20.1.32

processManagement:
  timeZoneInfo: /usr/share/zoneinfo
```

## Security

Configuring MongoDB for security requires just a few steps. First, disable security by editing `/etc/mongod.conf` to contain:

```
security:
  authorization: disabled
```

Restart MongoDB with:

```
sudo systemctl restart mongod
```

Create an `admin` database, _but not as running under sudo_, and add `admin`, `backup` and `restore` users:

```
mongo
use admin
db.createUser({user:"root",pwd:"...",roles:["userAdminAnyDatabase","readAnyDatabase","clusterAdmin"]})
db.createUser({user:"backup",pwd:"...",roles:["backup"]})
db.createUser({user:"restore",pwd:"...",roles:["restore"]})
```

Now enable security on the MongoDB instance by changing `authorization: enabled` in the `mongod.conf` file, then:

    sudo service mongod restart

Now connect as the `root` user:

    mongo -u root -p "..."

And create your `<database>-v<version>` database, e.g. database-v1:

    use database-v1
    db.createUser({user:"admin",pwd:"...",roles:["readWrite", "dbAdmin", "userAdmin"]})
    db.createUser({user:"user",pwd:"...",roles:["readWrite","dbAdmin"]})
    use admin
    db.system.users.find()

Now, enable security with:

```
security:
  authorization: enabled
```

And do `systemctl restart mongod`.

## Create a Replica Set

Then, create a key for replica set communication:

```
openssl rand -base64 756 > mongo-keyfile
```

Once you’ve generated the key, copy it to each member of your replica set as `~/keyfile`:

```
sudo mkdir /val/lib/mongodb/keyfile
sudo mv ~/keyfile /var/lib/mongodb/keyfile
sudo chown mongodb:mongodb /var/lib/mongodb/keyfile
sudo chmod u=r,go= /var/lib/mongodb/keyfile
```

Configure an `admin` user.

Then update `/etc/mongod.conf`:

```
security:
  keyFile: /opt/mongo/mongo-keyfile

replication:
  replSetName: rs0
```

Restart each node. Then on each node,

```
mongo -u admin -p --authenticationDatabase admin
```

Then:

```
rs.initiate()
rs.add({ host: "<host2>:27017"})
rs.add({ host: "<host3>:27017"})
rs.conf()
rs.status()
```

Configure replicas to allow read-only operations:

```
db.getMongo().setSlaveOk()
```

## Backup & Restore

For small databases, < 75GB, use the [`mongo-bongo`](https://www.npmjs.com/package/mongo-bongo) tool. Do a backup with:

```
bongo backup <db-name>
```

And restore a database with:

```
bongo restore <archive-file>
```

If restoring to a replica set, restore to the primary and it will replicate out to the secondaries.

For larger database, you should backup the database directory on disk and rebuild the replica set as described in [Restore a Replica Set from MongoDB Backups](https://docs.mongodb.com/manual/tutorial/restore-replica-set-from-backup/).

## Checking Replication State

On the PRIMARY, you can type:

```
db.printSlaveReplicationInfo()
```

## Allow Read-Only Operations on Secondaries

On the SECONDARY:

```
rs.slaveOk()
show dbs
```

This allows the current connection to allow read operations to run on SECONDARY members.

## Change Replica Set Config

On the PRIMARY:

1. Run `cfg = rs.conf()`.
2. Edit `cfg` to be what you want
3. Run `rs.reconfig(cfg, {force: true})

This may can data loss if the database is in use.

## Using an Arbiter

If you can only set up two isolated server instances, you can use an _arbiter_ instance that does not write any data, but only participates in replica voting. See [MongoDB Replication](https://docs.mongodb.com/manual/replication/)