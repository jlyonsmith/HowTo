# Upgrade MongoDB

## Overview

To upgrade MongoDB you must upgrade through all intermediate versions.  MongoDB minor release versions are always multiples of 2.  While it is possible to upgrade the databases, it is _much_ less effort to simply dump and restore the database if it is small.

## Upgrading MMAPv1 to WiredTiger Storage

Check the `.conf` file or command line arguments in the service file to see if MongoDB is running using `mmapv1`.  If you so, you have to back up and restore all databases in `wiredTiger` format.

Assuming no authentication and assuming current data directory is `/var/lib/mongodb`:

```sh
mkdir backups
mongodump --out=backups/
systemctl stop mongod
mkdir temp
mv /var/lib/mongodb temp/
mkdir /var/lib/mongodb
chown mongodb:mongodb /var/lib/mongodb
```

Change the `.conf` file to contain:

```conf
  engine: wiredTiger
```

Run `mongo` and check the status.  You may need to rebuild a replicate set. For example:

```mongo
rs.initiate()
rs.add({ host: "<host2>:27017"})
rs.add({ host: "<host3>:27017"})
rs.conf()
rs.status()
```

Then:

```sh
systemctl start mongod
mongorestore backups/
```

See [Change Standalone to WiredTiger](https://docs.mongodb.com/manual/tutorial/change-standalone-wiredtiger/).

## Upgrading 4.x to 4.2

Assuming Ubuntu 20.x (Focal).

```sh
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list
apt install -y mongodb-org mongodb-org-mongos mongodb-org-server mongodb-org-shell mongodb-org-tools
apt update
```

See [Installing MongoDB 4.2 on Ubuntu](https://docs.mongodb.com/v4.2/tutorial/install-mongodb-on-ubuntu/)

## Upgrading 4.2 to 4.4

Assuming Ubuntu 20.x (Focal)

```sh
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
apt update
apt install -y mongodb-org mongodb-org-mongos mongodb-org-server mongodb-org-shell mongodb-org-tools mongodb-org-database-tools-extra
```

See [Installing MongoDB 4.4 on Ubuntu](https://docs.mongodb.com/v4.4/tutorial/install-mongodb-on-ubuntu/)

## Upgrading 4.4 to 5.0

```sh
wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list
apt update
apt install -y mongodb-org mongodb-org-mongos mongodb-org-server mongodb-org-shell mongodb-org-tools mongodb-org-database-tools-extra
```

See [Install MongoDB 5.0 on Ubuntu](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/)
