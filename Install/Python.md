# Install Python 2.7 on CentOS 6

## System Check

Check CentOS version with `cat /etc/centos-release` and check Python version with `python -V`. [Userify](https://userify.com) requires Python 2.7. You cannot replace the built in Python on CentOS 6. You must install a newer Python without impacting the built in version and then tell the Userify shim to use it.

## Step-by-Step

First, install `gcc` and required libraries:

```bash
sudo yum install gcc openssl-devel bzip2-devel
```

Download Python 2.7:

```bash
sudo -s
cd /usr/src
wget https://www.python.org/ftp/python/2.7.15/Python-2.7.15.tgz
tar xzf Python-2.7.15.tgz
```

Build and install it:

```bash
cd Python-2.7.15
./configure --enable-optimizations
make altinstall
```

Check Python version:

```
/usr/local/bin/python2.7 -V
```

Update Userify `/etc/rc.local` file to run Userify `shim.sh` with the correct Python version:

```
...
PYTHON=/usr/local/bin/python2.7 /opt/userify/shim.sh &
```
