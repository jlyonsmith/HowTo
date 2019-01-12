# Install Ubuntu 18.04 LTS Service Instance

### Ubuntu

Acquire a clean system with an `ubuntu` user:

    ssh ubuntu@x.mydomain.com

Then check the version:

    >lsb_release -a
    ...
    Distributor ID:	Ubuntu
    Description:	Ubuntu 18.04.1 LTS
    Release:	    18.04
    Codename:	    bionic

### VIM

Here's a good set of defaults for the `~/.vimrc` file:

```
color desert
set shiftwidth=2 tabstop=2 expandtab
```

### Bash

Improve the `bash` prompt as follows:

    cd ~
    vi .bashrc

Find the section containing `PS1=` and replace with:

    if [ "$color_prompt" = yes ]; then
        PS1='[${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]]\n\$'
    else
         PS1='[${debian_chroot:+($debian_chroot)}\u@\h:\w]\n\$'
    fi
    unset color_prompt force_color_prompt

Log off and on again to activate.

### Hostname

Change the name of the host to something meaningful:

    sudo -s
    vi /etc/hostname
    vi /etc/hosts

Change the default name, e.g. `Ubuntu-xenial-16-04`, to whatever name you desire. Reboot the system for the change to take effect:

    reboot

## Firewall

Use [Uncomplicated Firewall](https://help.ubuntu.com/12.10/serverguide/firewall.html) to enable all ports, e.g.:

    sudu -s
    apt-get install ufw
    ufw allow ssh
    ufw enable

Add additional rules as necessary, e.g.

    ufw allow https
    ufw allow http

Or

    ufw reject http

See [Uncomplicated Firewall](https://wiki.ubuntu.com/UncomplicatedFirewall) for more information.

You can use the `$SSH_CONNECTION` environment variable to find your connection address:

    echo $SSH_CONNECTION

but not from the `sudo` shell.

## Set Up Ubuntu User

If not using a key, change the `root` password using [Strong Password Generator](http://strongpasswordgenerator.com/):

    passwd

We use an `ubuntu` user which has root access, like Amazon does with EC2. First, `ssh` to the system as `root`, logging on with the provided password.

Create the `ubuntu` user:

    adduser  ubuntu

Use [Strong Password Generator](http://strongpasswordgenerator.com/) to generate a password.

Now add the ubuntu user as a sudoer:

    cd /etc/sudoers.d
    vi ubuntu

Add the following:

    # Add sudo permission for ubuntu user
    ubuntu ALL=(ALL) NOPASSWD:ALL

Now change the permissions on the file:

    chmod 440 ubuntu

See the [Sudo Manual](http://www.sudo.ws/sudoers.man.html) for more information.

Logon as `ubuntu`, set the `PS1` prompt and check that you can `sudo`. If all is well, disable `root` user with:

    sudo passwd -l root

## Enable SSH login for `ubuntu`

SSH in again as `ubuntu`. Create the `.ssh` directory:

    mkdir .ssh
    chmod u=rwx,go= .ssh
    cd .ssh

Copy up the `.pub` file:

    scp mydomain.pem.pub ubuntu@10.10.10.10:.ssh/

Concat the `.pub` file to the authorized keys file:

    touch authorized_keys
    chmod u=rw authorized_keys
    cat mydomain.pem.pub >> authorized_keys
    chmod u=r,go= authorized_keys

Add an entry to your local `~/.ssh/config` file:

    Host mydomain-xxx
      User ubuntu
      HostName xxx.mydomain.com
      IdentityFile ~/.ssh/mydomain-xxx.pem

Close the remote shell and re-connect as `ubuntu`. You should no longer require a password. Check you can `sudo` without a password.

    ssh ubuntu@xxx.mydomain.com -i ~/.ssh/mydomain.pem

### Disable SSH password login

Once you are able to login to the system with key authentication, disable password SSH login:

    sudo vi /etc/ssh/sshd_config

Set the following option:

    ChallengeResponseAuthentication no
    PasswordAuthentication no

Then:

    sudo systemctl reload sshd

## Proxy

If using a proxy, configure `apt` to use it by editing `/etc/apt/apt.conf` to contain:

```
Acquire::http::Proxy "http://yourproxyaddress:proxyport";
```

### Screen, Super User and Updates

Firstly, it useful when running multiple installs and messing with global configuration to start a new super-user shell:

    sudo -s

Be careful because any files you create in this shell will owned by `root`, and you will usually want them owned by `ubuntu`. Use `whoami` or watch the prompt.

It's time to update all packages:

    sudo -s
    apt-get update

Note, if you get a `BADSIG 40976EAF437D05B5` or similar error, delete the key shown in the error, e.g.:

    apt-key del 40976EAF437D05B5
    apt-get update

Installs over `ssh` can be a pain if you get disconnected from the network during the installation. For long running operations where you might lose `ssh` connectivity (or you just want to disconnect instead of waiting) you can use `screen` before a long running operation:

    apt-get install screen
    screen

Then, if you get kicked off, just run:

    screen -r

to reconnect and get back to work.

### DNS Utils

    sudo apt-get install dnsutils

### Git Install

Install Git:

    apt-get install git

### Install the AWS CLI

These are really useful for scripting and accessing AWS services from the command line:

    python3 --version

Must be > 3.5. Then:

    apt-get install python3-pip
    pip3 install awscli

### MongoDB Install

Install MongoDB:

    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
    echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list
    sudo apt-get update
    sudo apt-get install -y mongodb-org

Configuring MongoDB for security requires a few steps. First, disable security. Edit `/etc/mongod.conf` to contain:

    security:
      authorization: disabled

Restart MongoDB with:

    sudo systemctl restart mongod

Create an `admin` database, _but not as running under sudo_:

    mongo
    use admin
    db.createUser({user:"root",pwd:"...",roles:["userAdminAnyDatabase","readAnyDatabase","clusterAdmin"]})

Now enable security on the MongoDB instance by changing `authorization: enabled` in the `mongod.conf` file, then:

    sudo service mongod restart

Now connect as the `root` user:

    mongo --port 27017 -u root -p "..." --authenticationDatabase admin

Now create the `whatever-vM-m` database:

    use whatever-vM-m
    db.createUser({user:"admin",pwd:"...",roles:["readWrite", "dbAdmin", "userAdmin"]})
    db.createUser({user:"user",pwd:"...",roles:["readWrite","dbAdmin"]})
    use admin
    db.system.users.find()

For good system security, use a new password for each database version.

### Redis Install

Install Redis:

    apt-get install redis-server

If you want to install a really new build, you can find the official instructions at [Redis Quick Start](http://redis.io/topics/quickstart).

Use:

    redis-cli info

to test the install.

### Install nginx

Install `nginx`:

    apt-get install -y nginx

Check the version:

    nginx -v

Should be at least `1.10.0`. Ensure that nginx is set to start after reboot:

    sudo systemctl status nginx

Note that the site `.conf` files are in the `/etc/nginx/conf.d` directory.

The default `nginx.conf` should look like:

```
user www-data;
worker_processes auto;
pid /run/nginx.pid;

events {
  worker_connections 768;
}

http {
  sendfile on;
  sendfile_max_chunk 1m;
  tcp_nopush on;
  tcp_nodelay on;
  keepalive_timeout 65;
  types_hash_max_size 2048;
  include /etc/nginx/mime.types;
  default_type application/octet-stream;
  ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
  ssl_prefer_server_ciphers on;
  access_log /var/log/nginx/access.log;
  error_log /var/log/nginx/error.log;
  gzip on;
  gzip_disable "msie6";

  include /etc/nginx/conf.d/*;
}
```

_Make sure_ to copy the `default` configuration from `sites-enabled` and set up a redirect to an actual site hosted on the system or you'll get the default `nginx` page.

### Node Install

To install `Node.js`:

    curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
    sudo apt-get install -y build-essential nodejs

Check the version with:

    node --version

Ensure that it's `10.0` or above.

### RabbitMQ Install

Add APT repository public key:

```
wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | sudo apt-key add -
```

Add the repository to the `/etc/apt/sources.list.d` file:

```
echo 'deb http://www.rabbitmq.com/debian/ testing main' | sudo tee /etc/apt/sources.list.d/rabbitmq.list
```

Update and install the newest version of the server:

```
sudo apt-get update
sudo apt-get install rabbitmq-server
```

Test the server is running with:

```
sudo rabbitmqctl status
```

### `systemd` Configuration

Ubuntu 16.04 uses [Systemd](https://www.digitalocean.com/community/tutorials/systemd-essentials-working-with-services-units-and-the-journal) to manage daemons. Configuration files for `systemd` have a `.service` extension and are placed in the `/etc/systemd/system` directory. See also [`systemd` file format](https://www.freedesktop.org/software/systemd/man/systemd.service.html) `systemd` works alongside the existing Unix `/etc/init.d` and Upstart processes on Ubuntu.

A basic `.service` file might contain:

```
[Unit]
Description=An API Service
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu/Xxx/Service
ExecStart=/usr/bin/node server.js
Restart=on-abort

[Install]
WantedBy=multi-user.target
```

Copy the `.service` file into the `/lib/systemd/system` directory:

    sudo cp xxx.service /lib/systemd/system/

Enable and start the service with:

    sudo systemctl --now enable xxx

You can see the status of the service with:

    sudo systemctl status xxx

If the service file changes, reload it with:

    sudo systemctl daemon-reload
