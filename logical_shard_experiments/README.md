This folder contains the files for our logical sharding experiments. Particularly, we were testing the performance of a system that copies user data on write to a special table that contains large JSONs or hstores of each user's data. So, for example, if there is a social media platform with 100k users, then this special table would have 100k records, each record containing 2 records:

- a user's id 
-  all the information the database has on them stored in a single JSON to hstore.

## The dumps
The 'dumps' folder contains the dumps for the protoypes.

**Note**
When running a reddit_hstore dump to recreate the database, make sure that 
you've run `CREATE EXTENSION hstore;` in your target database first.

The 'Not Benched' folder in there contains the original vanilla reddit that was created in the 
physical sharding experiments, along with versions of this database that implement 
logical shrading using [hstores](https://www.postgresql.org/docs/12/hstore.html) and [jsonb](https://www.postgresql.org/docs/12/functions-json.html).

The dumps that aren't in that 'Not Benched' folder are the dumps that were actually benchmarked. 
The only difference between them and the originals is that all foreign keys have been removed (a quick workaround for some concurrency issues).

This doesn't really matter that much anyways, since logical sharding would ideally be used
in a database that doesn't take advantage of FKs.
Also, you'd realize that there's 3 versions for each type of reddit schema. Each of those versions
has a majority of their non-primary-key table indexes using the method in their name. For example, `reddit_jsonb_brin`
is a version of `reddit_jsonb_nofk` that replaced most of it's non-primary-key indexes 
with brin indexes.

## The benchmarking

Early on in the benchmarks, BRIN indexes were crossed out as an inappropriate index type for the 
logical sharding system we are considering becuase of two reasons:

 - They are only fast if the columns they're indexing are sequential, which is pretty limiting (ie, imagine indexing a primary key column where the keys are generated using hashes, or a foreign key column, which will likely not follow any order).
 - Even if the above constraint is initially satisfied (eg, a `serial` column), it is easily broken once columns of the table undergo edits (since that changes that physical order of the rows). This is especially a problem if we are trying to make a `user_shards` table, since that will be edited on every insert and update.

So BRIN indexes are not robust enough for the general system we're trying to make.

## Our findings

In our benchmarks, we observed that both logical benchmarking methods (ie using hstore or json) resulted in about a 
20% decrease in throughput for both their hash index and tree index variants. An excel spreadsheet with our findings has been provided.

 **The pg_bench command we used for benchmarking**

`pgbench --file write_only_transaction.sql --jobs 4 --transactions 23000 --client 10 --progress 5 --no-vacuum [dbname]`

**Cleaning databases inbetween benches**

Use `psql -d [dbname] -a -f clean_db.sql`