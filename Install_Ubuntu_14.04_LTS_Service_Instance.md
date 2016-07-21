# Install Ubuntu 1404 LTS Service Instance

### Ubuntu

Acquire an EC2, Hetzner or other instance running Ubuntu 14.04 LTS.  SSH on to the system as `root` using the supplied password:

    ssh root@x.mydomain.com

Then check the version:

    >lsb_release -a
    ...
    Description:    Ubuntu 14.04.1 LTS
    Release:    14.04
    Codename:   trusty

Change the `root` password using [Strong Password Generator](http://strongpasswordgenerator.com/):

    passwd

Now, fix the prompt as follows:

    cd ~
    vi .bashrc

find the section containing `PS1=` and replace with:

    if [ "$color_prompt" = yes ]; then
        PS1='[${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]]\n\$'
    else
         PS1='[${debian_chroot:+($debian_chroot)}\u@\h:\w]\n\$'
    fi
    unset color_prompt force_color_prompt

Log off and on again.

### Hostname

Change the name of the host to something meaningful:

    sudo -s
    vi /etc/hostname
    vi /etc/hosts
    
Change the default name, e.g. `Ubuntu-trusty-14-04`, to something like `mydomain-alfa`.  Reboot the system for the change to take effect:

    reboot

### Firewall (Amazon EC2)

Set the _Amazon EC2_ security groups to only allow access to the following ports:

Service | Port
:-- | :--
HTTP | 80
HTTPS | 443
SSH | 22
MongoDB | 27017
Service | 1337 - 1347
ICMP | 0 - 65535

### Firewall (Other)

Use [Uncomplicated Firewall](https://help.ubuntu.com/12.10/serverguide/firewall.html) to enable all ports, e.g.:

    sudu -s
    ufw allow 22
    ufw enable 

Add additional rules as necessary, e.g.

    ufw allow https
    ufw allow http

Or  
  
    ufw reject http

See [Uncomplicated Firewall](https://wiki.ubuntu.com/UncomplicatedFirewall) for more information.

To allow access to MongoDB from a specific IP address use:

	ufw allow proto tcp from x.x.x.x to any port 27017

You can use the `$SSH_CONNECTION` environment variable to find your connection address:

    echo $SSH_CONNECTION

### Adding 'ubuntu' User (non-EC2)

We use an `ubuntu` user which has root access, like Amazon does with EC2.  First, `ssh` to the system as `root`, logging on with the provided password.

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

Logon as `ubuntu`, set the `PS1` prompt and check that you can `sudo`.

### Adding SSH key authentication

#### Create a `.pem` file for SSH

To create  a new `.pem` file (*do not* set a passphrase):

    ssh-keygen -t rsa -b 2048 -f mydomain
    mv mydomain mydomain.pem
    mv mydomain.pub mydomain.pem.pub

#### Dump Existing `.pem` public key

For an existing a `.pem` file, say from Amazon AWS, you can dump the public key with:

    ssh-keygen -y -f mydomain.pem > mydomain.pem.pub

### Enable SSH login for `ubuntu`

SSH in again as `ubuntu`.  Create the `.ssh` directory:

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

Close the remote shell and re-connect as `ubuntu`.  You should no longer require a password.  Check you can `sudo` without a password.

    ssh ubuntu@xxx.mydomain.com -i ~/.ssh/mydomain.pem

### Disable SSH password login

Once you are able to login to the system with key authentication, disable password SSH login:

    sudo vi /etc/ssh/sshd_config

Set the following option:

    ChallengeResponseAuthentication no
    UsePAM no
    PasswordAuthentication no
    
Then:

    sudo /etc/init.d/ssh restart

Test by doing using the non-SSH alias name to login (because there is no associated `.pem` file):

    ssh ubuntu@xyz.mydomain.com

You should get `Permission denied`.

### Screen, Super User and Updates

Firstly, it useful when running multiple installs and messing with global configuration to start a new super-user shell:

    sudo -s
    
Be careful because any files you create in this shell will owned by `root`, and you will usually want them owned by `ubuntu`.  Use `whoami` or watch the prompt.
 
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

### Git Install

Install Git:

    apt-get install git

### Install the AWS CLI

These are really useful for scripting and accessing AWS services from the command line:

    python --version

Must be > 2.6.3.  Then:

    apt-get install python-pip
    pip install awscli

### MongoDB Install

Install MongoDB from the [official 10gen repo](http://docs.mongodb.org/manual/tutorial/install-mongodb-on-ubuntu/) (not the Ubuntu one):

    apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
    echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/10gen.list
    apt-get update
    apt-get install mongodb-org 

Configuring MongoDB for the first requires setting up an `admin` database.  Edit `/etc/mongod.conf` to contain `noauth true`.  Restart MongoDB with `service mongod restart`.

Now create an `admin` database, _but not as the superuser_:

    mongo

Note, if you get a warning about readahead size, exit and do:

    echo 'ACTION=="add", KERNEL=="md2", ATTR{bdi/read_ahead_kb}="128"' | sudo tee -a /etc/udev/rules.d/85-ebs.rules
    
Reboot and check `RA` value from for the the `mongo` drive:

    df /var/lib/mongo
    sudo blockdev --report

Back in `mongo`, continue with:

    use admin
    db.createUser({user:"root",pwd:"...",roles:["userAdminAnyDatabase","readAnyDatabase","clusterAdmin"]})

Now enable security on the MongoDB instance by adding `auth true` to the `mongod.conf` file, then do:

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

You need to comment out `bind_ip` in the `/etc/mongod.conf` file and allow port 27017 through the firewall in order to access the database remotely.

Connect as `user` for development purposes.  Try to use `admin` only to drop databases and add users.

### Redis Install

Install Redis:

    apt-get install redis-server

If you want to install a really new build, you can find the official instructions at [Redis Quick Start](http://redis.io/topics/quickstart).

Use:

    redis-cli info
    
to test the install.

### Mono Install

Install Mono build pre-requisites:

    sudo apt-get install autoconf libtool automake build-essential mono-devel gettext

Check [Compiling Mono](http://www.mono-project.com/docs/compiling-mono/linux/) for up-to-date instructions.

Go to the `/opt` directory to build Mono bits:

    cd /opt

In the following commands `--prefix=/usr/local` puts everything that builds in the `/usr/local` directory.  This is the standard Unix location for system components that are left alone in a system upgrade, as opposed to `/usr` bits.

To make and install `libgdiplus` (only needed if `System.Drawing.dll` is needed):
    
    git clone git://github.com/mono/libgdiplus.git 
    cd libgdiplus 
    apt-get install libjpeg-dev libexif-dev glib-2.0 libcairo2-dev
    ./autogen.sh --prefix=/usr/local
    make 
    make install 
    make clean 

To make and install the lastest released build of `mono`: 

    git clone git://github.com/mono/mono.git 
    cd mono
    git checkout mono-3.8.0
    ./autogen.sh --prefix=/usr/local
    make 
 
If anything goes wrong, try an older tag, like `mono-3.6.0`.  After mono is built successfully, remove the pre-installed version of mono:

    apt-get purge mono-runtime
    make install 
    make clean 
    cd ..

Logoff and on to get the PATH changes.

### Install Libav

If you need video processing, use `Libav`, a better maintained and documented fork of `FFMpeg`:

    apt-get install libav-tools

### Generic Service Configuration

Ubuntu uses [Upstart](http://upstart.ubuntu.com/getting-started.html) to manage daemons.  Configuration files for Upstart daemons are placed in the `/etc/init` directory.  Upstart currently works alongside the existing Unix `/etc/init.d` daemon process on Ubuntu.

Build and deploy the software to the system using the `deploysvc.sh` script:

    bin/deploysvc.sh ... 

Where `machine` is a name configured in `~/.ssh/config`.

**NOTE:** If this is a clean install, copy the `service-vM-m.conf` then run:

    service service-v1-0 start

Test the service by going to `http://api.mydomain.com/vM/info` in a browser.

### Install nginx

Add the official nginx repository:

    sudo vi /etc/apt/sources.list
  
Add the following _at the top_ of the file:

    deb http://nginx.org/packages/ubuntu/ trusty nginx

Add the public key for the package from the Ubuntu server:

    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ABF5BD827BD9BF62

Update everything, then remove the current nginx install:

    apt-get update
    apt-get remove nginx-full nginx-common

And install the new nginx:

    apt-get install nginx

Check the version:

    nginx -v

Should be at least `1.6.2`.  Ensure that nginx is set to start after reboot:

    update-rc.d nginx defaults    

Note that the site `.conf` files are in the `/etc/nginx/conf.d` directory.

