Reddit clone with logical shards using hstores - complete
Reddit clone with logical shards using jsonb - complete

They're both slow - pretty sure some optimizations can be made in both of them

**Note**
When running the reddit_hstore script to recreate the database, make sure that 
you've run `CREATE EXTENSION hstore;` in your target database first.

**Cleaning databases inbetween benches**
`psql -d [dbname] -a -f clean_db.sql`