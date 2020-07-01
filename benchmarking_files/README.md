Here are the parameters used for...

**Creating users**

`pgbench --file [path to create_users_bench.sql] --jobs 1 --transactions 3000 --client 1 --progress 5 --no-vacuum [db name]`

**Making posts and comments**

`pgbench --file [path to read_write_bench.sql] --jobs 2 --transactions 20000 --client 4 --progress 5 --no-vacuum [db name]` 

**Exporting user shards**

`pgbench --file [path to gdpr_rights_bench.sql] --jobs 2 --transactions 1500 --client 5 --progress 5 --no-vacuum [db name]` 