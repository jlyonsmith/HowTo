# Access Postfix Email Server

To access the legacy Postfix server:

1.  Connect to `proxy` with `ssh proxy`.  You can use your *Userify* access for this.
2.  Connect to `seattle-vm-1` tunnel with `ssh root@205.234.70.24 -p 8080`.
3.  Connect to `printproxy` with `ssh root@192.168.0.9`.
4.  Connect to `mail-dal` with `ssh $YOUR_NAME@65.120.146.135`.  Use your non-production FreeIPA password.

The `postfix` configuration is in the `/etc/postfix` directory.  The system is configured to use MySQL to store aliases (email accounts).  To access the MySQL table storing the aliases:

```bash
mysql --user=postfix --password=postfix postfix -B -e "select * from aliases;"
```
