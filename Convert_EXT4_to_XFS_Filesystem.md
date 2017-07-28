# Converting EXT4 to XFS Filesystem

[MongoDB Kernel & File Systems](https://docs.mongodb.com/manual/administration/production-notes/#kernel-and-file-systems)

Get the Linux kernel version number with:

```
uname -r
```

Get information on RAID arrays with:

```
mdadm --query /dev/md3
mdadm --detail /dev/md3
```

https://www.digitalocean.com/community/tutorials/how-to-create-raid-arrays-with-mdadm-on-ubuntu-16-04
https://wiki.ubuntu.com/XFS
https://erikugel.wordpress.com/2010/04/11/setting-up-linux-with-raid-faster-slackware-with-mdadm-and-xfs/
http://www.linuxquestions.org/questions/linux-newbie-8/md0-what-is-it-736498/
https://www.tecmint.com/find-linux-filesystem-type/
