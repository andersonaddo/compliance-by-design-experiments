# Compliance by Design Experiments
<img src="https://upload.wikimedia.org/wikipedia/en/thumb/3/31/Brown_University_coat_of_arms.svg/1200px-Brown_University_coat_of_arms.svg.png" alt="brown_logo" height="40"/> <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/29/Postgresql_elephant.svg/1200px-Postgresql_elephant.svg.png" alt="postgres_logo" height="40"/>

This repo contains the work I did for the Compliance by Design research project during the summer of 2020 as my [UTRA](https://www.brown.edu/academics/college/fellowships/utra/).

## What is *Compliance by Design*?

Compliance by Design is a research project started by [Malte Schwarzkopf](https://cs.brown.edu/news/2020/04/29/malte-schwarzkopf-wins-salomon-award-gdpr-compliant-system-design/) of the [Brown University Systems Group](https://systems.cs.brown.edu/). It's aim is to design systems that make it easy to make databases (either pre-existing databases or to-be databases) GDPR compliant.

One large aspect of this is making it easy to reply to [SAR requests](https://www.experian.co.uk/business/glossary/subject-access-request/). At the moment, replying to SARs can be a tedious and error-prone process because the database developer/maintainer will have to manually create all the queries necessary to compile all the data relating to a certain user. This may be trivial in small databases, but quickly becomes a pain in larger setups.

So, one main aim of Compliance by Design is to design a system that can essentially handle this automatically. This has already been approached before by a previous Brown University group; they crated a project called [Odlaw](https://cs.brown.edu/courses/csci2390/2019/assign/project/report/odlaw.pdf). However, one large limitation of Odlaw is that it wholly depends on the explicitly defined foreign keys in the database's schema. We've observed that it's actually not uncommon for production databases to be completely devoid of explicitly defined foreign keys, so we're trying to create a system that can work without them.

We explored two main methods:

### **Physical Sharding**

This attempt is inspired by Professor Malte's [position paper](https://cs.brown.edu/people/malte/pub/papers/2019-poly-gdpr.pdf) on Compliance by Design. Essentially, a system based on physical sharding would segment database tables into smaller sub-tables based on which user each record is about. So, for example, a comments table in a social media platform with 100k users would be segmented into 100k subtables - one for every user. These shards would not be interacted with directly, however. All their records would be coalesced into a materialized view that acts as the front-facing comments table for all queries, and all writes made on that materialized view will be propagated back up to the necessary shards. 

With a system like this, responding to SAR requests would be trivial since the developer only has to send over the user's shard.

I'd definitely suggest reading the position paper to learn more about this approach.

### Logical Sharding

Logical sharding involves finding ways to simplify SAR response without altering the actual database structure and without rearranging any of its data. The approaches  we considered:

1. Automatically duplicating data on write into a separate table that contains JSONs (or something similar) of all of a user's data. We considered this different from physical sharding because it doesn't involve the creation of table partitions.
2. Automatically creating [potentially nested] indexes (and queries needed to obtain useful information from them). Whenever an SAR is sent, the system will be able to respond promptly by queries its custom indexes.
3. Intelligently crawling the database on-demand whenever an SAR is sent.

Both approaches will require the that the system has some way of telling the relationships between tables (since it will be operating under the assumption that the database wouldn't have explicit foreign keys). There are a few different ways of doing this, but each day will require some help from the developer.

## Our Approach and My Role

We decided that the DBMS we will use while conceptualizing and prototyping our system would be [PostgreSQL](https://www.postgresql.org/), since it's very common and extensible.

My role in all of this was to test these approaches experimentally and conceptually with Professor Malte. Naturally, as research goes, it was a pretty windy, round-about, rollercoaster exploration, but we learnt a good amount along the way.

We started off with testing out the physical sharding approach, more on that can be found in the [physical_shard_experiments](physical_shard_experiments/) folder of this repo.

Then, were moved on to logical sharding. 

First, we wanted to understand the overhead that different Postgres indexes have on reading and writing to help inform our design if we choose an index-based one. The can be found in the [index_overhead_experiments](index_overhead_experiments) folder of this repo.

Then, we moved on to looking at the performance of a logical sharding system that's based on the first method mentioned (the JSON based method). More on that can be found in the [logical_shard_experiments](logical_shard_experiments/) folder of this repo.

Finally, we explored (mostly conceptually) the last two logical sharding methods mentioned earlier. More on that can be found in the [schema_analysis](schema_analysis/) section of this repo.

By the time you finish reading the last section, you'd have a good idea of the understanding we had at the end of summer 2020 of the problem and the validity of different solutions.

## Environment Setup 

My experimental environment was a combination of [Postgress.app](https://postgresapp.com/) (using Postgres 12) and [DBeaver Community Edition](https://dbeaver.io/) on a 2018 Macbook Pro (2.3 GHz Quad-Core Intel Core i5 Processor, 8 GB 2133 MHz LPDDR3 RAM).

It might be useful to enable logging in your Postgres installation. More info on that can be found [here](https://www.endpoint.com/blog/2014/11/12/dear-postgresql-where-are-my-logs). Additionally, if you're using postgres.app, your config log will be located in: 
```~/Library/Application Support/Postgres/var-12/```

If you want to use Postgres's CLI tools and you're using Postgres.app, you're gonna have to [follow these steps](https://postgresapp.com/documentation/cli-tools.html
).

If you're running pgbench on Windows, you might want to beware of the order of arguments you pass in. Apparently, [that matters](https://stackoverflow.com/questions/17997070/postgresql-pgbench-tool-running-user-defined-sql-script).

###  Restoring the dumps

A lot of the sections in the repo contain sql dumps that were created using the `pg_dump` command ([docs](https://www.postgresql.org/docs/12/app-pgdump.html)). To restore them into your database, create a new database instance in your postgres server, delete the default `public` schema and feed any dump to `psql` ([tutorial](https://www.postgresqltutorial.com/postgresql-restore-database/)).

It's also easy to restore in DBeaver using the `Execute Script` feature.

### Benchmarking the dumps
Benchmarking was done using pgbench. More information about the parameters used in each experiment can be found in the folder than contains the benchmarking scripts.

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

