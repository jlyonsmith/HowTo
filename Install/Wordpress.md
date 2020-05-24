# Installing Wordpress on Ubuntu 16.04

## Install Apache Web Server

```
sudo apt-get install apache2 apache2-utils 
sudo systemctl enable apache2
sudo systemctl start apache2
```

Hit the `http://<server>` and ensure you get the Apache home page.

## Install MySQL Database

```
sudo apt-get install mysql-client mysql-server
sudo mysql_secure_installation
```

The secure installation tool lets you pick password strength and remove test databases and anonymous users.

## Install PHP

```
sudo apt-get install php7.0 php7.0-mysql libapache2-mod-php7.0 php7.0-cli php7.0-cgi php7.0-gd
```

Test the installation:

```
sudo vi /var/www/html/info.php
```

and paste in:

```
<?php 
phpinfo();
?>
```

Hit `http://<server>/info.php` and ensure that you get a PHP info page.

## Install Wordpress

```
wget -c http://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
sudo rsync -av wordpress/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/
```

## Create a Database

```
mysql -u root -p
```

then

```
CREATE DATABASE <db-name>;
GRANT ALL PRIVILEGES ON <db-name>.* TO 'wp_user'@'localhost' IDENTIFIED BY '<password>';
FLUSH PRIVILEGES;
EXIT;
```

## Configure Wordpress

```
cd /var/www/html
sudo mv wp-config-sample.php wp-config.php
vi wp-config.php
```

Edit the file and set the values that you configured for database, user and password.

## Restart Apache

```
sudo systemctl restart apache2.service
sudo systemctl restart mysql.service 
```

Browse to `http://<site>/wp_admin` and complete the Wordpress installation.
