After doing some benchmarks (the physical sharding benchmarks, the index
stress tests, and the logical sharding benchmarks), we started to have other ideas
for sharding mechanisms. 

One hypothetical system is one that infers links inbetween rows
 by tracking the of joins and sub-queries.

A better understanding of how databases are structured in practice is needed to properly inform the design of the hypothetical systems.

This folder contains info on certain schemas of open-source applications that we analyzed. The 'permalinks' are future-proof links to the schema files at the state at which we analysed them. Physical copies are also in the `schemas` folder (needless to say, you should check the repo licenses before using these for anything more than educational pursoses).

## The schemas we looked at

- [Lobsters (sql)](https://github.com/mit-pdos/noria/blob/master/applications/lobsters/mysql/db-schema/original.sql) - [permalink](https://github.com/mit-pdos/noria/blob/f54dfcef4057b490ccb43f4a31c6aaf35c923fb7/applications/lobsters/mysql/db-schema/original.sql)
- [Lobsters (rb)](https://github.com/lobsters/lobsters/blob/master/db/schema.rb) - [permalink](https://github.com/lobsters/lobsters/blob/4755cebd9259baebacc14e5d4d98540bf9836b94/db/schema.rb)
- [Socify (rb)](https://github.com/scaffeinate/socify/blob/master/db/schema.rb) - [permalink](https://github.com/scaffeinate/socify/blob/19d02bb72685cfb64d81bd5d2b088177b4086436/db/schema.rb)
- [GhChat (sql)](https://github.com/aermin/ghChat/blob/master/server/init/sql/ghchat.sql) - [permalink](https://github.com/aermin/ghChat/blob/8eb7ed5b484ed9970c10ff6ddf1b795fcd7235f4/server/init/sql/ghchat.sql)
- [Instagram Clone (sql)](https://github.com/yTakkar/Instagram-clone/blob/master/instagram.sql) - [permalink](https://github.com/yTakkar/Instagram-clone/blob/eec6420e47c27f30939515c46f8138aebd38c529/instagram.sql)
- [Instagram Clone 2.0 (sql)](https://github.com/yTakkar/React-Instagram-Clone-2.0/blob/master/db.sql) - [permalink](https://github.com/yTakkar/React-Instagram-Clone-2.0/blob/1128f7fad8df371ec0b7901a150a710396f9f42a/db.sql)
- [HotCRP Paper review system (sql)](https://github.com/kohler/hotcrp/blob/master/src/schema.sql) - [permalink](https://github.com/kohler/hotcrp/blob/a5956110e9eef7dea832a1cd19d8119b512ae897/src/schema.sql)
- [Schnack (sql)](https://github.com/schn4ck/schnack/tree/master/migrations) - [permalink](https://github.com/schn4ck/schnack/tree/71feb6053d9f85385c507fe0166c72119e6bc7c6/migrations)
- [Commento (sql)](https://github.com/adtac/commento/blob/master/db/20180416163802-init-schema.sql) - [permalink](https://github.com/adtac/commento/blob/326601394acd8fface90990fae63236ffa880bc4/db/20180416163802-init-schema.sql)
- [Mouthful (sql in Go)](https://github.com/vkuznecovas/mouthful/blob/master/db/sqlxDriver/postgres/postgres.go) - [permalink](https://github.com/vkuznecovas/mouthful/blob/7a850ecd117e73a701fd56151dc7dbfd45d82139/db/sqlxDriver/postgres/postgres.go)
- [PrestaShop (sql)](https://github.com/PrestaShop/PrestaShop/blob/develop/install-dev/data/db_structure.sql) - [permalink](https://github.com/PrestaShop/PrestaShop/blob/9f71f3294867db49880c0d737bd559f2dd822e78/install-dev/data/db_structure.sql)
- [OpenCart (php)](https://github.com/opencart/opencart/blob/master/upload/system/helper/db_schema.php) - [permalink](https://github.com/opencart/opencart/blob/c4d4f01948d0d75575eb47b44d15b89474f2926b/upload/system/helper/db_schema.php)
  (These guys seem to have GDPR compliance baked into their codebase with a dedicated gdpr table
  and several `gdpr.php` scripts. Potentially worth investigating.)


If you'd like to see more schemas for Ecommerce solutions, take a look at [this list](https://www.ecommerceceo.com/open-source-ecommerce/). 



## Schema Visualization And Analysis Tools
We simply just read the source directly, but if you'd like to visualize or further process
these schemas, these tools might come in handy:
- [PgLoader (MySQL to Postgres)](https://github.com/dimitri/pgloader)
- [SQLdm.com (ER diagrams from SQL schemas)](https://app.sqldbm.com/)
- [Railroady (ER diagrams Ruby schemas)](https://github.com/preston/railroady)
