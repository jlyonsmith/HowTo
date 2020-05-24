# Installing Legacy NaviServer
### NOTE: see subfolder: `NaviserverInstall` for scripts


## Start/Restart NaviServer

```bash
systemctl restart aolserver-bpt
```

## Install Source

```bash
git clone https://bptbuild@bitbucket.org/brownpapertickets/official.git git-clone
```

This requires the `bptuser` password.

## Create Links

```bash
cd /httpd/bpt/
ln -s /var/git-clone/source/base/ base
ln -s /var/git-clone/source/db db
ln -s /var/git-clone/source/html html
ln -s /var/git-clone/source/modules/ modules
ln -s /var/git-clone/source/ source
ln -s /var/git-clone/source/tcl tcl
ln -s /var/git-clone/source/tcl_mobile/ tcl_mobile
ln -s /var/git-clone/source/ui ui
ln -s /var/git-clone/source/vendor/ vendor
```

## Database

Database passwords go in `/home/aolserv/.pgpass`:

```
*:*:*:*:<database-password>
```

The password is for the `bpt` user and is only needed for remote access.

## Other

Q: How to restart NaviServer?
