This folder contains the files for our logical sharding experiments.

## The dumps
The 'dumps' folder contains the dumps for the protoypes.

**Note**
When running the reddit_hstore script to recreate the database, make sure that 
you've run `CREATE EXTENSION hstore;` in your target database first.

The 'Not Benched' folder in there contain the original vanilla reddit that was craeted in the 
physical sharding experiments, along with versions of this database that impliment 
"logical" shrading using hstores and jsonb.

The dumps that aren't in that 'Not Benched' folder are the dumps that were actaully benchmarked. 
The only difference between them and the originals is that all foreign keys have been removed (a quick workaround for some concurrency issues).
This doesn't really matter that much anyways, since logical sharding would ideally be used
in a database that doesn't take advantage of FKs.
Also, you'd realize that there's 3 versions for each type of reddit schema. Each of those versions
has a majority of their custom indexes using the method in their name. For example, `reddit_jsonb_brin`
is a version of `reddit_jsonb_nofk` that replaced most of it's non-primary key indexes 
with brin indexes.

## The benchmarking

Early on in the benchmarks, BRIN indexes were crossed out as an inappropriate index type for the 
logical sharding system we are considering becuase of two reasons:
 - They are only fast if the columns they're indexing are sequential, which is pretty limiting (ie, imagine indexing a primary key column where the keys are generated using hashes, or a foreign key column, which will likely not follow any order).
 - Even if the above constraint is initailly satisfied (eg, a `serial` column), it is easily broken once columns of the table undergo edits (since that changes that physical order of the rows). This is especially a problem if we are trying to make a `user_shards` table, since that will be edited on every insert and update.

So BRIN indexes are not robust enough for the general system we're trying to make.

In our benchmarks, we observed that both logical benchmarking methods resulted in about a 
20% decrease in throughput (when using `pgbench --file write_only_transaction.sql --jobs 4 --transactions 23000 --client 10 --progress 5 --no-vacuum [dbname]`)

**Cleaning databases inbetween benches**

Use `psql -d [dbname] -a -f clean_db.sql`