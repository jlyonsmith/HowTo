# Redmine 3.1 Install on Ubuntu 14.04

## Summary

These instructions are for installing:

- Redmine 3.1
- on Ubuntu 14.04
- with Ruby 2.2.x
- and PostgreSQL 9.3

### Preparation

Acquire an EC2 instance running Ubuntu 14.04 LTS. SSH on to the system 

Log on to the instance after it has started.  Check the version:

```bash
>lsb_release -a
...
Description:    Ubuntu 14.04.1 LTS
Release:    14.04
Codename:   trusty
```

Now, fix the prompt as follows:

```bash
cd ~
vi .bashrc
find the section containing PS1= and replace with:

if [ "$color_prompt" = yes ]; then
    PS1='[${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]]\n\$'
else
     PS1='[${debian_chroot:+($debian_chroot)}\u@\h:\w]\n\$'
fi
unset color_prompt force_color_prompt
```

Log off and on again.  Save typing by running:

```bash
sudo -s
```
	
Get everything up to date:

```bash
apt-get update
```

### Apache & Curl
	
Install Apache:

```bash
apt-get install apache2 apache2-dev
```

Install Curl (which on AWS is usually a no-op):

```bash
apt-get install curl 
```

### Ruby

You don't need RDoc for your production machine and it slows the installation down _a lot_.  Create a `~/.gemrc` file containing:

```yaml
gem: --no-document
```
	
Install Ruby 2.2.3 (this takes a while):

```bash
apt-get -y install build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev
mkdir ~/tmp
cd ~/tmp
wget https://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.3.tar.gz
tar -xvzf ruby-2.2.3.tar.gz
cd ruby-2.2.3/
./configure --prefix=/usr/local
make
make install
cd ~
ruby --version
rm -rf tmp
```

### ImageMagick

Install ImageMagick and dev libs (takes a while):

```bash
apt-get install imagemagick libmagickwand-dev
```

### Git

Install Git for Redmine sources and SCM integration:

```bash
apt-get install git
```

### PostgreSQL
	
Install PostgreSQL:

```bash
apt-get install postgresql postgresql-contrib
```

Set `postgres` user password.  Use [Strong Password Generator](http://strongpasswordgenerator.com/) to generate.  Run:

```bash
sudo -u postgres psql
# \password postgres
# \q
```

Edit the file `edit /etc/postgresql/9.3/main/pg_hba.conf` and change the lines:

```
local   all             postgres                                peer
local   all             all                                     peer
```

to:

```
local   all             postgres                                md5
local   all             all                                     md5
```

Then:

```bash
service postgresql restart
```

Generate a password for the `redmine` database, then create it with:

```bash
psql -U root -W
Password for user postgres: _____
> create role redmine login encrypted password '____' noinherit valid until 'infinity';
> create database redmine with encoding='UTF8' owner=redmine;
> \list
> \q
```

### Redmine

Clone the Redmine 3.1 Git repository:

```bash
cd /usr/share
git clone https://github.com/redmine/redmine.git redmine
git checkout 3.1.0
cd redmine

Copy database config:	

```bash
cd config
cp database.yml.example database.yml
```
	
Edit the file as follows:

```yaml
production:
  adapter: postgresql
  database: redmine
  host: localhost
  username: redmine
  password: password
```

Install Bundler and all the required Gems:

```bash	
cd /usr/share/redmine
gem install bundler
bundle install --without development test
```

Ignore warning about installing as `root`. 

Create a secret token for Redmine:

```bash
bundle exec rake generate_secret_token
```

Create/upgrade the database (same command):

```bash
RAILS_ENV=production bundle exec rake db:migrate
```

If it's a new database, add default data:

```bash
RAILS_ENV=production bundle exec rake redmine:load_default_data 
```
	
Set directory permissions

```bash
mkdir -p tmp tmp/pdf public/plugin_assets
chown -R www-data:www-data files log tmp public/plugin_assets
chmod -R 755 files log tmp public/plugin_assets
chown www-data:www-data Gemfile.lock
```
	
Clear cache and existing sessions:

```bash
bundle exec rake tmp:cache:clear
bundle exec rake tmp:sessions:clear
```
	
Backup the Redmine database:

```bash
mkdir ~/backup
PGPASSWORD=____ pg_dump --username=redmine redmine | gzip > ~/backup/redmine_`date +%y_%m_%d`.gz
```
	
Set log file to rotate with:

```bash
cd config/environments
vi production.rb
```

Then add the lines:

```bash
config.logger = Logger.new('log/production.log', 7, 1048576)
config.logger.level = Logger::INFO
```
	
### Passenger

Install Phusion Passenger:

```bash
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7
apt-get install apt-transport-https ca-certificates
vi /etc/apt/sources.list.d/passenger.list
```

Insert:

```
deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main
```
	
Secure the `passenger.list` file:

```bash
chown root: /etc/apt/sources.list.d/passenger.list
chmod 600 /etc/apt/sources.list.d/passenger.list
apt-get update
```
		
Install the Apache2 Passenger module:
	
```bash
apt-get install passenger
passenger-install-apache2-module
```
	
Set `/etc/apache2/mods-available/passenger.conf` to:

```xml
<IfModule mod_passenger.c>
  PassengerUser www-data
  PassengerDefaultUser www-data
  PassengerRoot /usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini
  PassengerDefaultRuby /usr/local/bin/ruby
  PassengerStartTimeout 240	
</IfModule>
```
	
Enable access to native support cache directory (otherwise native support won't work):

```bash
mkdir /var/www/.passenger
chown www-data:www-data /var/www/.passenger
```
	
### Apache (Part 2)

Enable Apache Rewrite module:

```bash
a2enmod rewrite
service apache2 restart
```

Create a new Apache2 virtual site from the current default:

```bash
cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/redmine.mydomain.com.conf
```
	
Edit `redmine.yourdomain.com.conf` to contain just:

```xml
<VirtualHost *:80>
  ServerName redmine.yourdomain.com
  DocumentRoot /usr/share/redmine/public
  <Directory /usr/share/redmine/public>
    AllowOverride all
    Options -MultiViews
    Require all granted
  </Directory>
  RailsEnv production
</VirtualHost>
```
	
Disable the default site and enable the new one:

```bash
a2dissite 000-default
a2ensite redmine.yourdomain.com
service apache2 restart
```
	
Test out the site by browsing to <a>http://redmine.yourdomain.com</a>.  The default `admin` user password is `admin`.  Add a your first user, make them an administrator and delete the `admin` account.

## And the rest...

### Themes

Apply the GitMike theme:

```bash
cd /usr/shared/redmine/public/themes
git clone https://github.com/makotokw/redmine-theme-gitmike.git gitmike
```
	
Go to _Administration -> Settings -> Display -> Theme_ and select _GitMike_.

### Logo

To set your company logo in the GitMike theme, go to:

```bash
cd /usr/shared/redmine/public/themes/gitmike/stylesheets
vi application.css
```
	
Search for the `#header > h1` style, and change to something like:

```css
 #header > h1 { background: url(../images/logo.png) no-repeat; display: table-cell; vertical-align: middle; height: 50px; width: 300px; padding: 5px 150px; color: #393939; }
```

Upload your logo to `../images/logo.png` and adjust the CSS to get everything looking decent.  You can just refresh your browser after each change, no need to restart Apache.
	
### Markdown

Configure text formatting in _Administration -> Settings -> General -> Text formatting_ and select _Markdown_. 

### Backups

Assuming Python 2.7 or above is already installed, install Python Pip:

```bash
apt-get install python-pip
```
	
Then install AWS CLI tools:

```bash
pip install awscli
```
	
Here are the steps that you can take to backup the database regularly to S3:

1. Create a `xxx-redmine-backups` bucket for the backups.
1. Create a `RedmineBackup` user and assign this [custom IAM user policy](https://gist.github.com/jlyonsmith/9353413#file-iam_backup_user_policy-json).
1. Create an an `EMailSender` group, and assign this [custom IAM group policy](https://gist.github.com/jlyonsmith/9353413#file-iam_mailsender_group_policy-json) and put the `RedmineBackup` user in the group.
1. Create a [backup script](https://gist.github.com/jlyonsmith/9353413) for the Redmine MySQL database and install to `redmine/script/redmine-backup.sh`.  Don't forget to `chmod u+x redmide-backup.sh`.
1. Create the [backup-message.json](https://gist.github.com/jlyonsmith/9353413#file-backup-message-json) and the [backup-destination.json](https://gist.github.com/jlyonsmith/9353413#file-backup-destination-json) files.
1. Edit `/etc/crontab` to run the script nightly:

```
0  0    * * *   root    cd /usr/share/redmine/script/ && ./redmine-backup.sh 
```

### E-mail

To set up e-mail for Redmine using Amazon SES, first go to the SES control panel and create a new `RedmineEmail` user.  Save the `SMTP Username` and `SMTP Password`.  The username is the same as an *Amazon Access Key ID*.  The password is derived from the *Amazon Secret Access Key* for the user, and can only be used for logging on via SMTP to SES.

Copy the `configuration.yml` from the `.example` and create a section under `default:`:

```yaml
default:
...
	email_delivery:
		delivery_method: :smtp
		smtp_settings:
  			enable_starttls_auto: true
			address: email-smtp.us-east-1.amazonaws.com
  			port: 587
  			domain: <yourdomain>
  			authentication: :login
  			user_name: "<SMTPUserName>"
  			password: "<SMTPPassword>"
```
      				
Go to the _Administration -> Settings -> E-mail Notifications_ tab and try sending a test e-mail.  If your user account e-mail is filled in you should receive a test e-mail.

### Installation Backup

Lastly, it is a good idea to tar and backup the entire Redmine installation in case you need to rebuild the machine:

```bash
tar -cvzf xxx-redmine-install.tar.gz redmine/.
aws s3 cp xxx-redmine-install.tar.gz s3://xxx-redmine-backups/ --profile your-profile
rm *.gz
```
    
See [AWS Command Line Interface](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html) for details on setting up the `--profile` argument with `aws-cli`.

---

[How to upgrade Redmine](http://www.redmine.org/projects/redmine/wiki/RedmineUpgrade)

[General Redmine How To's](http://www.redmine.org/projects/redmine/wiki/HowTos)

[Phusion Passenger](http://www.modrails.com/documentation/Users%20guide%20Apache.html)
