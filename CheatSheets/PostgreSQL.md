
## Installation

### Ubuntu

```sh
sudo apt update
sudo apt install postgresql postgresql-common postgresql-contrib
```

These three packages work together to provide a complete database environment:

- **postgresql**: The main meta-package that installs the latest stable version of the PostgreSQL database server and its standard client.
- **postgresql-common**: A critical infrastructure package that provides the framework for managing multiple PostgreSQL clusters and versions on a single machine. It includes essential utilities like:
    - `pg_createcluster`: To set up new database instances.
    - `pg_upgradecluster`: To migrate data between major versions.
    - `pg_lsclusters`: To view the status of all local database instances.
- **postgresql-contrib**: A collection of "contributed" modules that extend PostgreSQL's functionality. Common extensions included are:
    - **hstore**: For storing sets of key/value pairs.
    - **pgcrypto**: For cryptographic functions.
    - **uuid-ossp**: For generating universally unique identifiers.
    - **citext**: For case-insensitive character strings. 

To use `postgres` interactively, run `psql` as the `postgres` superuser user:

```sh
sudo -u postgres psql
```
## Creating Users

To create a PostgreSQL user, you generally use the `CREATE USER` or `CREATE ROLE` SQL command within a database session. In PostgreSQL, a "user" is simply a role that has the `LOGIN` privilege.
### Using SQL (via `psql`)

The most common way to create a user is through the interactive terminal. You must first connect to your server as a superuser (typically the `postgres` user).

Access the PostgreSQL shell `sudo -u postgres psql`
    
1. Run the creation command:
```sql
CREATE USER my_new_user WITH PASSWORD 'secure_password';
```
    
NOTE: By default, a user created this way has no permissions beyond basic login.
### Using the Command Line Utility

PostgreSQL provides a wrapper command called `createuser` that you can run directly from your terminal without entering the SQL shell. 

Standard creation:
```sql
createuser --interactive --pwprompt
```
This will prompt you for the new user's name and whether they should have superuser, database creation, or role creation privileges.
### Managing Privileges

Once a user is created, they need permission to interact with specific databases or tables. 

Grant permission to a database:

```sql
GRANT ALL PRIVILEGES ON DATABASE my_database TO my_new_user;
```

Grant specific table access:
   
```sql
GRANT SELECT, INSERT, UPDATE ON my_table TO my_new_user;
```

 Give "Create Database" permission:

```sql
ALTER USER my_new_user CREATEDB;
```
## Find Database Sizes

Show database sizes with `\l+ <database-name>`.  With a query:
```sql
SELECT pg_database.datname as "database_name", pg_size_pretty(pg_database_size(pg_database.datname)) AS size_in_mb FROM pg_database ORDER by size_in_mb DESC;
```

Show table sizes with `\d+`
