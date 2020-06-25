# Compliance by Design Benches
<img src="https://upload.wikimedia.org/wikipedia/en/thumb/3/31/Brown_University_coat_of_arms.svg/1200px-Brown_University_coat_of_arms.svg.png" alt="brown_logo" width="20"/> <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/29/Postgresql_elephant.svg/1200px-Postgresql_elephant.svg.png" alt="postgres_logo" width="30"/>

This repo contains the pg_dumps of some Postgres projects used to benchmark and evaluate some different approaches to making conventional databases GDPR compliant.

The original experiment environment was a combination of [Postgress.app](https://postgresapp.com/) (Using Postgres 12) and [DBeaver Community Edition](https://dbeaver.io/).

##  Restoring these dumps
As stated, this repo contains sql dumps were created using the `pg_dump` command ([docs](https://www.postgresql.org/docs/12/app-pgdump.html)). To restore them into your database, create a new database instance in your postgres server, delete the default `public` schema and run feed the dump to `psql` ([tutorial](https://www.postgresqltutorial.com/postgresql-restore-database/)).

It's also easy to restore in DBeaver using the `Execute Script` feature.

