# Configure SSH on CentOS 7

Install the SSH packages:

```
yum install openssh openssh-server openssh-clients openssl-libs
```

This will start the SSH daemon automatically.  Should already be installed in CentOS 7.

If using NAT port forwarding from say port 2200 to 22 on the VM, go to the host command line and do:

```
ssh -p2200 127.0.0.1
```

And you should connect.
