This directory contains the database dump and the pg_bench file used for 
investigating the effects of indexes on table writes.

The video game database has a number of tables, all identical in table structure and only differing in the number and types of indexes they have.

Note that before you run this script, you're going to have to replace `tablename` in `create_random_game.sql` with an actual table that's in the videogame database.

From our observations there's how the overhead associated with indexes ranked:
hash >>> btrees > brin

These results should be taken with quite a bit of salt. Particularly, these
benchmarks presented the ideal scenario brin bin databases, but in some scenarios
(like in our first round of logical sharding experiments), they can be as slow as
sequentail searches. More info on that is in the README there. Additionally, in that
same round of experiments, the large detrimental affect of hash indexes wasn't observed.
We are not sure why.

The commands we used for testing:

```
pgbench --file create_game.sql --jobs 4 --transactions 100000 --client 8 --progress 5 --no-vacuum videogames
```
and
```
pgbench --file create_game.sql --jobs 6 --transactions 180000 --client 20 --progress 5 --no-vacuum videogames
```

Our raw results have been provided in the rawoutput1.md and rawoutput2.md files.

**Cleaning videogame database inbetween benches**
`psql -d [dbname] -a -f clean_db.sql`

