After doing some benchmarks (the physical sharding benchmarks, the index
stress tests, and the logical sharding benchmarks), we started to have other ideas
for sharding mechanisms. A better understanding of how databases are structured in practice is needed to properly inform the design of the hypothetical systems.

This folder contains info on certain schemas of open-source applications that we analyzed.

## The schemas we looked at

- [Lobsters (sql)](https://github.com/mit-pdos/noria/blob/master/applications/lobsters/mysql/db-schema/original.sql)
- [Lobsters (rb)](https://github.com/lobsters/lobsters/blob/a2f6b60b473aea01d69bb5584dfb9038b04ef0ea/db/schema.rb)
- [Socify (rb)](https://github.com/scaffeinate/socify/blob/master/db/schema.rb)
- [GhChat (sql)](https://github.com/aermin/ghChat/blob/master/server/init/sql/ghchat.sql)
- [Instagram Clone (sql)](https://github.com/yTakkar/Instagram-clone/blob/master/instagram.sql)
- [Instagram Clone 2.0 (sql)](https://github.com/yTakkar/React-Instagram-Clone-2.0/blob/master/db.sql)
- [HotCRP Paper review system (sql)](https://github.com/kohler/hotcrp/blob/master/src/schema.sql)
- [Schnack (sql)](https://github.com/schn4ck/schnack/tree/master/migrations)
- [Commento (sql)](https://github.com/adtac/commento/blob/master/db/20180416163802-init-schema.sql)
- [Mouthful (sql in Go)](https://github.com/vkuznecovas/mouthful/blob/master/db/sqlxDriver/postgres/postgres.go)
- [PrestaShop (sql)](https://github.com/PrestaShop/PrestaShop/blob/develop/install-dev/data/db_structure.sql)
- [OpenCart (php)](https://github.com/opencart/opencart/blob/master/upload/system/helper/db_schema.php)
  These guys seem to have GDPR compliance baked into their codebase with a dedicated gdpr table
  and several `gdpr.php` scripts. Potentially worth investigating.


If you'd like to see more schemas for Ecommerce solutions, take a look at [this list](https://www.ecommerceceo.com/open-source-ecommerce/). 



## Schema Visualization And Analysis Tools
We simply just read the source directly, but if you'd like to visualize or further process
these schemas, these tools might come in handy:
- [PgLoader (MySQL to Postgres)](https://github.com/dimitri/pgloader)
- [SQLdm.com (ER diagrams from SQL schemas)](https://app.sqldbm.com/)
- [Railroady (ER diagrams Ruby schemas)](https://github.com/preston/railroady)
