# Install NFS

## Ubuntu

### Server

On the machine that is serving the files:

```bash
sudo apt-get update
sudo apt install nfs-kernel-server
```

This guide focuses on NFS v4. We use the `/mnt` directory by convention and make this our NFS v4 root directory. To create a new directory under this root, do:

```bash
sudo mkdir -p /mnt/sharedfolder
sudo chown nobody:nogroup /mnt/sharedfolder
sudo chmod ugo=rwx /mnt/sharedfolder
```

The `nobody` user and `nogroup` group are used by the NFS daemon. When the owner of a file or directory in a mounted NFS share doesn't exist at the local system, it is replaced by the nobody user and its group.

If you want to share an existing directory elsewhere on the file system, then you can bind it this way:

```bash
sudo mkdir /mnt/sharedfolder
sudo mount --bind /other/directory /mnt/sharedfolder
```

Add an entry to the `/etc/fstab` file to re-mount this after a reboot:

```none
/other/directory  /mnt/sharedfolder  none  bind  0  0
```

Test with `sudo mount -fav`. Now define the exports by editing `/etc/exports`.

```none
/mnt                  10.20.0.0/16(rw,fsid=0,no_subtree_check,sync)
/mnt/sharedfolder     10.20.0.0/16(rw,nohide,insecure,no_subtree_check,sync)
```

You add additional shared folders later. You can also specify an subnet or a single IP address.

Process the `exports` file:

```bash
sudo exportfs -a
```

Open the firewall on the server if there is one:

| Port | Direction | Protocol | Reason      |
| ---- | --------- | -------- | ----------- |
| 2049 | in/out    | TCP      | NFS service |

If needed you can restart the NFS service with

```bash
sudo systemctl restart nfs-kernel-server`
```

### Client

Install the bits:

```bash
sudo apt update
sudo apt install -y nfs-common
```

Now, mount the entire exported tree from a server like this:

```bash
sudo mount -t nfs4 -o proto=tcp,port=2049 <serverIP>:/ /mnt
```

You can also mount and exported sub-tree, e.g. `<serverIP>:/sharedfolder /home/user/sharedfolder`.

Test by writing files in one directory or the other and seeing that they appear on the other system(s).

To make the mount point permanent, update `/etc/fstabs`:

```none
<serverIP>:/ /mnt nfs4 _netdev,auto 0 0
```

Test with `sudo mount -fav`.

Open the firewall on the client if needed:

| Port | Direction | Protocol | Reason      |
| ---- | --------- | -------- | ----------- |
| 111  | in/out    | TCP/UDP  | Port mapper |
| 2049 | in/out    | TCP      | NFS service |

To unmount a share:

```bash
umount /mnt/sharedfolder
```

NFS uses user id's and group id's to when mapping files to a remote system.  There *is* an id mapping service that you can set up, but it is *much* easier just to make sure that the UID/GID of groups are the same across all systems if you are just using system security.

### Reference

[Install NFS Server and Client on Ubuntu](https://vitux.com/install-nfs-server-and-client-on-ubuntu/)

[How to Mount and Unmount File Systems](https://linuxize.com/post/how-to-mount-and-unmount-file-systems-in-linux/)
