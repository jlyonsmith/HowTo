# PostgreSQL

## Authentication

PostgreSQL authentication is described full in the documentation - [Authentication Methods](https://www.postgresql.org/docs/current/static/auth-methods.html)

## Find database sizes

Show database sizes with `\l+ <database-name>`.  With a query:

```sql
SELECT pg_database.datname as "database_name", pg_size_pretty(pg_database_size(pg_database.datname)) AS size_in_mb FROM pg_database ORDER by size_in_mb DESC;
```

Show table sizes with `\d+`
