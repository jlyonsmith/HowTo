# Install PostgreSQL

```sh
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql.service
```

## Testing

> Default installation uses *peer authentication* where Postgres roles are associated with Unix users if they exist. With this authentication mode, Postgres looks for a database with the name of the role that is currently logged in.

```sh
sudo -i -u postgres
psql
```

Hit `\q` to exit the `psql` shell.

Or you can just do, `sudo -u postgres psql`.

## Creating Databases

```sh
sudo -u postgres createdb myapp
```

## Creating New Roles

```sh
sudo -u postgres createuser --interactive
```

Then, if you add a new Linux user with `sudo adduser myapp`, you can do:

```sh
sudo -i -u myapp
psql
```

And the default database will be `myapp`.

## References

- [How To Install and Use PostgreSQL on Ubuntu 20.04  | DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-ubuntu-20-04)