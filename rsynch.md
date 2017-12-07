# Using the `rsynch` Tool

To synchronize two directories over `ssh` with `rsynch` do:

```
rsync -avz -e 'ssh' <local-glob> ubuntu@<ssh-name>:<remote-dir>
```
