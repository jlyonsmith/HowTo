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

Create a `.pem` file without a password for SSH'ing into your system:

    ssh-keygen -t rsa -b 2048 -f ubuntu 
    mv ubuntu ubuntu.pem

Or, if you already have a .pem file with no public key:

    ssh-keygen -f ubuntu.pem -y > ubuntu.pub

SSH in again as `ubuntu`.  Create the `.ssh` directory:

    mkdir .ssh
    chmod u=rwx,go= .ssh

Copy up the `.pub` file:

    scp ubuntu.pub ubuntu@10.10.10.10:.ssh/

Concat the `.pub` file to the authorized keys file:

    cat ubuntu.pub >> ~/.ssh/authorized_keys
    chmod u=r,go= ~/.ssh/authorized_keys

Exit and re-connect as `ubuntu`.  You should not require a password.  Check you can `sudo` without a password.

### Using Screen

Install over `ssh` can be a pain if you get disconnected from the network during the installation.

For long running operations where you might lose `ssh` connectivity (or you just want to disconnect instead of waiting) you can use `screen`:

	screen
	
After logging on and before running the long running operation, then:

	screen -r
	
After reconnecting.

### Root

It is useful when running multiple installs and messing with global configuration to start a new super-user shell:

	sudo -s

### Git Install

Install Git:

	apt-get install git

### MongoDB Install

Install MongoDB:

	apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
	echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/10gen.list
	apt-get update
	apt-get install mongodb-10gen 
 	
### Redis Install

Install Redis:

    apt-get update
    apt-get upgrade
    apt-get redis-server

### Mono Install

Install Mono build pre-requisites:

	apt-get install vim libperl-dev libgtk2.0-dev autoconf automake libtool g++ gettext mono-gmcs git make apache2 apache2-threaded-dev


Build LibGdiPlus/Mono/XSP/Mod-Mono:

	cd /opt
	
To make `libgdiplus` (needed by `mono`):
	
	git clone git://github.com/mono/libgdiplus.git 
	cd libgdiplus 
	apt-get install libjpeg-dev libexif-dev
	./autogen.sh --prefix=/usr
	make 
	make install 
	make clean 

To make `mono`:	

	git clone git://github.com/mono/mono.git 
	cd mono
	./autogen.sh --prefix=/usr 
	make 
	make install 
	make clean 
	cd ..

To make `xsp`:

	git clone git://github.com/mono/xsp.git 
	cd ../xsp 
	./autogen.sh --prefix=/usr 
	make 
	make install 
	make clean 
	cd ..

To make `mod_mono`:

	git clone git://github.com/mono/mod_mono.git 
	cd mod_mono 
	./autogen.sh --prefix=/usr 
	make 
	make install 
	make clean 
		
### Firewall (EC2)

Set the EC2 security group ensuring that a policy that only allows access to the following ports is in place:

Service | Port
:-- | :--
HTTP | 80
HTTPS | 443
SSH | 22
MongoDB | 27017
Service | 1337 - 1347
ICMP | 0 - 65535

### Firewall (Non-EC2)

Use [Uncomplicated Firewall](https://help.ubuntu.com/10.04/serverguide/firewall.html):

    sudu -s
    ufw allow 22
    ufw enable 
    ufw insert 1 allow 80
    exit

Add additional rules as necessary.

### Redis Install

The service requires Redis to be up and running.  If it is running locally, check it with:

    redis info

and ensure that it returns information about the local instance.

### MongoDB Install

Configuring MongoDB for the first requires setting up an `admin` database.  On newly installed system, MongoDB security should be off by default:

	cat /etc/mongodb.conf` | grep auth

Should contain `noauth true`.  Now create an `admin` database

	mongodb

Then:

	use admin
	db.addUser({user:"root",pwd:"...",roles:["readWrite", "dbAdmin", "userAdminAnyDatabase", "clusterAdmin"]})
	db.system.users.find()
	use capsule-vM-m
	db.addUser({user:"admin",pwd:"...",roles:["readWrite", "dbAdmin", "userAdmin"]})
	db.addUser({user:"user",pwd:"...",roles:["readWrite", "dbAdmin"]})
	db.system.users.find()

For system security, use a new password for each database.

Now enable security on the MongoDB instance by adding `auth true` to the `mongodb.conf` file, then do:

	sudo service mongodb restart

You will require authentication to connect to the database from now on.

### Apache Proxy Configuration

Configure Apache using `mod_http_proxy` for HTTP by enabling it:

	sudo a2enmod http_proxy
	
Create or edit the web site at `/etc/apache2/sites-available/api.mydomain.com`

	ProxyPass service1/v1/ http://127.0.0.1:1338/ retry=0 max=50
	ProxyPassReverse service1/v1.2/ http://127.0.0.1:1338/
	
	ProxyPass service2/v2/ http://127.0.0.1:1337/ retry=0 max=50
	ProxyPassReverse /service2/v2/ http://127.0.0.1:1337/

	# ... more proxied backend services here ...

	ServerName api.mydomain.com

	<VirtualHost *:80>
	  ServerAdmin webmaster@jamoki.com
	  LogLevel warn
	  CustomLog ${APACHE_LOG_DIR}/access.log combined
	</VirtualHost>
	
Ensure that it is enabled:

	sudo a2ensite api.mydomain.com
	sudo service apache2 restart

### Generic Service Install

** This section has not been fully tested! **

Add a new non-interactive user called `service` to run the service as:

	sudo useradd -G service service
	sudo passwd service
	sudo chsh -s /bin/false service

Do **not** give this user `sudo` rights.  

Add the public key for the `service.pem` to the `~/.ssh/authorized_keys` file.

Ubuntu uses [Upstart](http://upstart.ubuntu.com/getting-started.html) to manage daemons.  Configuration files for Upstart daemons are in the `/etc/init.d` directory.  Upstart currently works alongside the existing Unix `init` daemon process on Ubuntu.

Create the following Upstart file in `/etc/init/service-vM.m.conf`:

	kill timeout 300

	description "Jamoki Service vM.m"
	author "Jamoke LLC"

	start on runlevel [2345]
	stop on runlevel [06]
	
	setuid service

	script
	  /home/service/bin/ervice-vM-m.sh
	end script

Passwords are kept in the [Redmine Infrastructure Wiki](http://redmine.jamoki.com/projects/infrastructure/wiki/Passwords).  Genarate new strong 16 character passwords for each instance using [Password Generator](http://www.newpasswordgenerator.com/).

Next, build and deploy the software to the system using the `service` user.

	cd Service
	bin/deploy machine

Where `machine` is a name configured in `~/.ssh/config`:

	Host machine
	  User ubuntu
	  HostName ec2-10-10-10-10.us-west-2.compute.amazonaws.com
	  IdentityFile ~/.ssh/yourprivatekey.pem

Test the service by going to `http://api.artifacttech.com/vM.m/info` in your browser.

Make sure that you configure the database name to have a version number in the `app.config` file (use dashes not dots).

	<?xml version="1.0" encoding="utf-8"?>
	<configuration>
	    <appSettings>
    	    <add key="MongoDbUrl" value="mongodb://admin:fPJH3277uaT115O@localhost:27017/capsule-v1-2" />
	        ...
    	</appSettings>
	</configuration>
