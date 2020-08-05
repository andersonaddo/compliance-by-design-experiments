# Compliance by Design Benches
<img src="https://upload.wikimedia.org/wikipedia/en/thumb/3/31/Brown_University_coat_of_arms.svg/1200px-Brown_University_coat_of_arms.svg.png" alt="brown_logo" width="20"/> <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/29/Postgresql_elephant.svg/1200px-Postgresql_elephant.svg.png" alt="postgres_logo" width="30"/>

This repo contains the pg_dumps of some Postgres projects used to benchmark and evaluate some different approaches to making conventional databases GDPR compliant.
That's not the only thing this repo has, however. There are also some reports and whatnot on related issues.

The original experiment environment was a combination of [Postgress.app](https://postgresapp.com/) (using Postgres 12) and [DBeaver Community Edition](https://dbeaver.io/) on a 2018 Macbook Pro (2.3 GHz Quad-Core Intel Core i5 Processor, 8 GB 2133 MHz LPDDR3 RAM).

### Environment Setup Tips
It might be useful to enable logging in your Postgres installation. More info on that can be found [here](https://www.endpoint.com/blog/2014/11/12/dear-postgresql-where-are-my-logs). Additionally, if you're using postgres.app, your config log will be located in: 
```~/Library/Application Support/Postgres/var-12/```

If you want to use Postgres's CLI tools and you're using Postgres.app, you're gonna have to [follow these steps](https://postgresapp.com/documentation/cli-tools.html
).

If you're running pgbench on Windows, you might want to beware of the order of arguments you pass in. Apparently, [that matters](https://stackoverflow.com/questions/17997070/postgresql-pgbench-tool-running-user-defined-sql-script).

Additionally, since some of the databases on this repo use lots of partitions, you're going to have to increase Postgres's `max_locks_per_transaction` option. More on that can be found [here](https://www.cybertec-postgresql.com/en/postgresql-you-might-need-to-increase-max_locks_per_transaction/).

##  Restoring the dumps
As stated, this repo contains sql dumps that were created using the `pg_dump` command ([docs](https://www.postgresql.org/docs/12/app-pgdump.html)). To restore them into your database, create a new database instance in your postgres server, delete the default `public` schema and feed any dump to `psql` ([tutorial](https://www.postgresqltutorial.com/postgresql-restore-database/)).

It's also easy to restore in DBeaver using the `Execute Script` feature.

## Benchmarking the dumps
Benchmarking was done using pgbench. More information about the parameters can be found in the folder than contains the benchmarking scripts.

This query can use useful in getting the sized of all of a db's tables after the benchmarks:

```
SELECT
     nspname,relname,pg_size_pretty(pg_relation_size(c.oid)) as "relative size", pg_size_pretty(pg_total_relation_size(c.oid)) as "total size"
from pg_class c left join pg_namespace n on ( n.oid=c.relnamespace) 
where nspname not in ('pg_catalog','information_schema', 'pg_toast')
order by pg_total_relation_size(c.oid) desc;
```

I've also made a quick [Google Colab](https://colab.research.google.com) notebook (`pg_bench_to_csv.ipynb`)
that converts pg_bench progress outputs to csv format for easy analysis.

