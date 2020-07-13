This directory contains the database dump and the pg_bench file used for 
investigating the effects of indexes on table writes.
The video game database has a number of tables, all identical in table structure and only differing in the number and types of indexes they have.

The command used for stress testing was:
```
pgbench --file [path to create_random_game.sql] --jobs 2 --transactions 50000 --client 6 --progress 5 --no-vacuum videogame_database

```

Note that before you run this script, you're going to have to replace `dbname` in `create_random_game.sql` with an actual table that's in the videogame database.
