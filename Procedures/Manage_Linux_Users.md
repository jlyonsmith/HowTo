# Managing Linux Users

This document describes managing users and groups on Linux.

## Adding System Groups and Users

```bash
sudo groupadd --system <group-name>
sudo useradd -s /sbin/nologin --system -G <group-name> <user-name>
```

## Changing User/Group ID's

```bash
sudo usermod -u 3000 <user-name>
sudo groupmod -u 3000 <group-name>
```

## References

[List Users and Groups](https://www.poftut.com/list-users-groups-linux/)
