
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

To use `postgres` interactively, switch to the `postgres` user:

```sh
sudo -i -u postgres
psql
ALTER USER postgres WITH PASSWORD 'your_secure_password';
```

## Authentication

PostgreSQL authentication is described full in the documentation - [Authentication Methods](https://www.postgresql.org/docs/current/static/auth-methods.html)

## Find database sizes

Show database sizes with `\l+ <database-name>`.  With a query:

```sql
SELECT pg_database.datname as "database_name", pg_size_pretty(pg_database_size(pg_database.datname)) AS size_in_mb FROM pg_database ORDER by size_in_mb DESC;
```

Show table sizes with `\d+`
