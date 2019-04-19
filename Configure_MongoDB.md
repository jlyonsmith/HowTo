# MongoDB Configuration

## Install

Install MongoDB:

```
sudo apt-key adv --keyserver-options http-proxy=$http_proxy --keyserver hkp://keyserver.ubuntu.com:80  --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org
```

## Security

Configuring MongoDB for security requires a few steps. First, disable security. Edit `/etc/mongod.conf` to contain:

```
security:
  authorization: disabled
```

Restart MongoDB with:

```
sudo systemctl restart mongod
```

Create an `admin` database, _but not as running under sudo_:

```
mongo
use admin
db.createUser({user:"root",pwd:"...",roles:["userAdminAnyDatabase","readAnyDatabase","clusterAdmin"]})
```

Now enable security on the MongoDB instance by changing `authorization: enabled` in the `mongod.conf` file, then:

    sudo service mongod restart

Now connect as the `root` user:

    mongo --port 27017 -u root -p "..." --authenticationDatabase admin

Now create the `whatever-vM-m` database:

    use whatever-vM-m
    db.createUser({user:"admin",pwd:"...",roles:["readWrite", "dbAdmin", "userAdmin"]})
    db.createUser({user:"user",pwd:"...",roles:["readWrite","dbAdmin"]})
    use admin
    db.system.users.find()

For good system security, use a new password for each database version.

## Backup

MongoDB backup is best performed with `mongodump`. It's got a lot of options. There's a nice wrapper around it called [`mongo-bongo`](https://www.npmjs.com/package/mongo-bongo). Do a backup with:

```
bongo backup <db-name>
```

You can also rename the database when backing it up.

Similarly, you can restore a database with:

```
bongo restore <archive-file>
```

## Restore a Replica Set

You must install the [aws-cli](https://aws.amazon.com/cli/) tools and also the [mongo-bongo]() tool.

You'll need to create a `~/.aws` directory and put the `XxxBackup` user keys in the `credentials` file.

```bash
cd ~
mkdir .aws
chown u=rwx,go=rx .aws
cd .aws
touch config
chmod u=rw,go= config
touch credentials
chmod u=rw,go= credentials
```

First, backup the database:

```
bongo backup <db-name> --host <repl-set-primary>
aws s3 cp <backup-file> s3://com.yourdomain.backups/
rm <backup-file>
```

To restore, ensure the system is entirely shut down and all transactions have completed. Identify all the replicaset machines with `mongo --eval "rs.status()"`. Then do an `rs.remove("...")` for each SECONDARY from the PRIMARY. Check with `rs.config()`

Now, on the PRIMARY instance:

```
mkdir backup
cd backup
aws s3 cp s3://com.yourdomain.backups/<backup-file> .
tar -xf <backup-file>
mongorestore --drop dump/
cd ..
rm -rf backup/
```

Now, using the _initial replication_ approach, reset the SECONDARY's and let them replicate again. On each SECONDARY machine:

```
sudo systemctl stop mongod
sudo rm -rf /var/lib/mongodb/*
sudo systemctl start mongod
```

Then on the PRIMARY, `mongo --eval "rs.add(<replica-set-host-port>, false)"` for each of the SECONDARY's.

The other approach for large amounts of data is to copy the entire contents of the data directory on the PRIMARY to data directoies on the SECONDARY's.

## Checking Replication State

On the SECONDARY:

```
rs.slaveOk()
show dbs
```

This allows the current connection to allow read operations to run on SECONDARY members.

On the PRIMARY, you can also type:

```
db.printSlaveReplicationInfo()
```

## Repair Broken Replica Set

To repair a broken replicate set, you basically need to remove the replica set configuration from all the replicas.

1. One each replica set instance, start `mongod` with a clean config without the the `--replSet` setting.
2. Go in with `mongo`
3. Run `use local; db.dropDatabase(); exit`
4. Restart all `mongod` instances with `--replSet` and do the `rs.initiate(...); rs.reconfig(...)` again.
