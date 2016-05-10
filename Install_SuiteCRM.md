# Installing SuiteCRM

Started with an Ubuntu 14.04 micro instance on **AWS EC2**.  Configured DNS CNAME record using **Route 53**.

Installed the following:

    apt-get install apache2
    apt-get install mysql-server
    apt-get install memcached
    apt-get install php5
    apt-get install php5-mysql
    apt-get install php5-memcache
    apt-get install php5-curl
    apt-get install php5-gd
    apt-get install php5-mcrypt
    apt-get install php5-ldap
    apt-get install php-imap    
    apt-get install php-pear
    
Change Apache2 default directory.  Edit `/etc/apache2/sites-available/000-default.conf` and set:

    DocumentRoot /var/www

Edit `/etc/php5/apache2/php.ini` and set the following under `[opcache]`:

	opcache.memory_consumption=128
	opcache.interned_strings_buffer=6
	opcache.max_accelerated_files=2000
	opcache.revalidate_freq=60
	opcache.fast_shutdown=1
	
Then set these in the appropriate places in the `php.ini` file:

	date.timezone = Europe/Paris
	memory_limit = 128M
	file_uploads = On
	upload_max_filesize = 20M
	post_max_size = 20M
	max_execution_time = 300
	extension=/usr/lib/php5/20121212/mcrypt.so
	extension=/usr/lib/php5/20121212/imap.so


Finally, create a file `/var/www/info.php`:

	<?php
	phpinfo();
	?>
	
And ensure that you can browse to it.

Create the MySQL database and user:

	mysql -u root -p
	Enter password:
	> create database redmine character set utf8;
	> create user 'redmine'@'localhost' identified by 'password';
	> grant all privileges on redmine.* to 'redmine'@'localhost';
	> alter database zurmo character set utf8 collate utf8_unicode_ci;
	> show databases;
	> quit;

Copy and install Zurmo:

	wget http://build.zurmo.com/downloads/zurmo-stable-2.7.3.9149ccdd67ff.tar.gz
	tar xvzf *.gz
	find zurmo/ | xargs -n 1 chown root:root

Set permissions on key files & directories:

	echo > app/protected/config/debug.php
	chown www-data:www-data app/protected/config/debug.php
	chown www-data:www-data app/version.php
	chown www-data:www-data app/protected/config/perInstanceDIST.php
	chown www-data:www-data app/protected/config/debugDIST.php
	chown www-data:www-data app/protected/config
	find app/assets | xargs -n 1 chown www-data:www-data
	find app/protected/data | xargs -n 1 chown www-data:www-data
	find app/protected/runtime | xargs -n 1 chown www-data:www-data
	
