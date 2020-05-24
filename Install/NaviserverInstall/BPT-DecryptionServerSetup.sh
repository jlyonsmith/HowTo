#!/bin/bash

################################################
################################################
##                                            ##
## BPT | Decryption Server Installation Steps ##
##                                            ##
################################################
################################################
#
# In addition to the standard Naviserver installation process, please also run the following commands on the Decryption server(s):
#
#########################################

#############################
# Install PostgreSQL Server #
#############################

yum -y install postgresql-server
/usr/bin/postgresql-setup initdb
sed -i 's| peer| trust|' /var/lib/pgsql/data/pg_hba.conf
sed -i 's| ident| trust|' /var/lib/pgsql/data/pg_hba.conf
systemctl start postgresql
systemctl enable postgresql
/usr/bin/createuser -U postgres -s aolserv
/usr/bin/createdb -E UTF8 -U aolserv -O aolserv -e KEYSERVER


########################
# Create the DB Schema #
########################

/usr/bin/psql -U aolserv -c 'CREATE TABLE decryption_keys (
decryption_key_id       serial    PRIMARY KEY, 
c_id                    int       UNIQUE NOT NULL, 
entry_date              timestamp DEFAULT now(), 
encrypted_private_key   text
)' KEYSERVER

/usr/bin/psql -U aolserv -c 'CREATE TABLE decryption_requests (
decryption_request_id   bigserial PRIMARY KEY, 
c_id                    int, 
entry_date              timestamp DEFAULT now(), 
public_key              text, 
private_key             text
)' KEYSERVER

/usr/bin/psql -U aolserv -c 'CREATE INDEX decryption_requests_c_id_idx ON decryption_requests(c_id)' KEYSERVER
/usr/bin/psql -U aolserv -c 'CREATE INDEX decryption_requests_entry_date_idx ON decryption_requests(entry_date)' KEYSERVER


########################
# Configure Naviserver #
########################

mkdir /httpd/decryption
mkdir /httpd/decryption/tcl
chown aolserv.aolserv -R /httpd
