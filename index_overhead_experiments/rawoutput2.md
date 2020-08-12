180000 transactions each for 20 clients over 6 jobs.

The hash variants of the experimental databases were not benchmarked because they were too slow.

#### games

```bash
progress: 5.0 s, 44494.5 tps, lat 0.446 ms stddev 0.211
progress: 10.0 s, 44834.2 tps, lat 0.445 ms stddev 0.241
progress: 15.0 s, 44346.4 tps, lat 0.449 ms stddev 0.284
progress: 20.0 s, 44181.3 tps, lat 0.452 ms stddev 0.255
progress: 25.0 s, 45234.9 tps, lat 0.441 ms stddev 0.258
progress: 30.0 s, 45051.2 tps, lat 0.442 ms stddev 0.169
progress: 35.0 s, 43013.5 tps, lat 0.464 ms stddev 0.186
progress: 40.0 s, 41812.6 tps, lat 0.477 ms stddev 0.206
progress: 45.0 s, 43525.9 tps, lat 0.458 ms stddev 0.273
progress: 50.0 s, 41710.6 tps, lat 0.478 ms stddev 0.361
progress: 55.0 s, 42695.9 tps, lat 0.467 ms stddev 0.162
progress: 60.0 s, 43297.6 tps, lat 0.461 ms stddev 0.505
progress: 65.0 s, 42598.6 tps, lat 0.468 ms stddev 0.203
progress: 70.0 s, 43479.3 tps, lat 0.459 ms stddev 0.291
progress: 75.0 s, 38020.2 tps, lat 0.525 ms stddev 0.384
progress: 80.0 s, 38421.7 tps, lat 0.519 ms stddev 0.461
transaction type: create_game.sql
scaling factor: 1
query mode: simple
number of clients: 20
number of threads: 6
number of transactions per client: 180000
number of transactions actually processed: 3600000/3600000
latency average = 0.466 ms
latency stddev = 0.304 ms
tps = 42605.739257 (including connections establishing)
tps = 42608.244416 (excluding connections establishing)
```



#### games_unique

```bash
progress: 5.0 s, 21535.7 tps, lat 0.920 ms stddev 0.577
progress: 10.0 s, 22049.4 tps, lat 0.905 ms stddev 0.681
progress: 15.0 s, 33643.1 tps, lat 0.593 ms stddev 0.375
progress: 20.0 s, 43499.5 tps, lat 0.458 ms stddev 0.171
progress: 25.0 s, 42564.1 tps, lat 0.469 ms stddev 0.312
progress: 30.0 s, 43693.7 tps, lat 0.456 ms stddev 0.177
progress: 35.0 s, 42297.2 tps, lat 0.471 ms stddev 0.188
progress: 40.0 s, 41321.6 tps, lat 0.483 ms stddev 0.309
progress: 45.0 s, 42649.4 tps, lat 0.468 ms stddev 0.195
progress: 50.0 s, 42210.8 tps, lat 0.472 ms stddev 0.190
progress: 55.0 s, 41975.6 tps, lat 0.475 ms stddev 0.235
progress: 60.0 s, 41873.4 tps, lat 0.476 ms stddev 0.177
progress: 65.0 s, 42233.1 tps, lat 0.472 ms stddev 0.303
progress: 70.0 s, 40961.9 tps, lat 0.487 ms stddev 0.608
progress: 75.0 s, 41519.8 tps, lat 0.480 ms stddev 0.192
progress: 80.0 s, 41399.3 tps, lat 0.482 ms stddev 0.235
progress: 85.0 s, 41902.0 tps, lat 0.476 ms stddev 0.251
progress: 90.0 s, 41225.4 tps, lat 0.484 ms stddev 0.202
transaction type: create_game.sql
scaling factor: 1
query mode: simple
number of clients: 20
number of threads: 6
number of transactions per client: 180000
number of transactions actually processed: 3600000/3600000
latency average = 0.506 ms
latency stddev = 0.327 ms
tps = 39245.640777 (including connections establishing)
tps = 39249.619079 (excluding connections establishing)
```



#### games_1_brin

```bash
progress: 5.0 s, 37629.2 tps, lat 0.527 ms stddev 0.348
progress: 10.0 s, 42604.2 tps, lat 0.468 ms stddev 0.186
progress: 15.0 s, 43073.0 tps, lat 0.463 ms stddev 0.182
progress: 20.0 s, 42866.7 tps, lat 0.465 ms stddev 0.225
progress: 25.0 s, 41981.3 tps, lat 0.475 ms stddev 0.229
progress: 30.0 s, 41286.8 tps, lat 0.483 ms stddev 0.246
progress: 35.0 s, 40388.4 tps, lat 0.494 ms stddev 0.305
progress: 40.0 s, 41970.9 tps, lat 0.475 ms stddev 0.176
progress: 45.0 s, 41024.5 tps, lat 0.486 ms stddev 0.429
progress: 50.0 s, 41582.8 tps, lat 0.480 ms stddev 0.237
progress: 55.0 s, 41301.7 tps, lat 0.483 ms stddev 0.228
progress: 60.0 s, 40428.0 tps, lat 0.493 ms stddev 0.379
progress: 65.0 s, 40151.4 tps, lat 0.496 ms stddev 0.415
progress: 70.0 s, 40597.4 tps, lat 0.492 ms stddev 0.281
progress: 75.0 s, 39785.5 tps, lat 0.501 ms stddev 0.307
progress: 80.0 s, 40822.7 tps, lat 0.489 ms stddev 0.198
progress: 85.0 s, 40418.5 tps, lat 0.493 ms stddev 0.247
transaction type: create_game.sql
scaling factor: 1
query mode: simple
number of clients: 20
number of threads: 6
number of transactions per client: 180000
number of transactions actually processed: 3600000/3600000
latency average = 0.485 ms
latency stddev = 0.281 ms
tps = 40815.115215 (including connections establishing)
tps = 40819.030571 (excluding connections establishing)
```



#### games_1_tree

```bash
progress: 5.0 s, 37895.5 tps, lat 0.525 ms stddev 0.391
progress: 10.0 s, 41051.0 tps, lat 0.486 ms stddev 0.186
progress: 15.0 s, 39757.6 tps, lat 0.502 ms stddev 0.253
progress: 20.0 s, 40827.9 tps, lat 0.489 ms stddev 0.275
progress: 25.0 s, 40271.7 tps, lat 0.495 ms stddev 0.283
progress: 30.0 s, 39942.0 tps, lat 0.499 ms stddev 0.333
progress: 35.0 s, 38540.8 tps, lat 0.518 ms stddev 0.416
progress: 40.0 s, 39634.0 tps, lat 0.503 ms stddev 0.378
progress: 45.0 s, 40075.0 tps, lat 0.498 ms stddev 0.303
progress: 50.0 s, 40382.8 tps, lat 0.494 ms stddev 0.251
progress: 55.0 s, 39460.4 tps, lat 0.506 ms stddev 0.340
progress: 60.0 s, 40159.2 tps, lat 0.497 ms stddev 0.232
progress: 65.0 s, 37792.0 tps, lat 0.528 ms stddev 0.551
progress: 70.0 s, 38803.9 tps, lat 0.514 ms stddev 0.892
progress: 75.0 s, 39487.2 tps, lat 0.505 ms stddev 0.416
progress: 80.0 s, 40501.2 tps, lat 0.493 ms stddev 0.255
progress: 85.0 s, 39848.9 tps, lat 0.501 ms stddev 0.248
progress: 90.0 s, 39338.8 tps, lat 0.507 ms stddev 0.332
transaction type: create_game.sql
scaling factor: 1
query mode: simple
number of clients: 20
number of threads: 6
number of transactions per client: 180000
number of transactions actually processed: 3600000/3600000
latency average = 0.503 ms
latency stddev = 0.383 ms
tps = 39498.129269 (including connections establishing)
tps = 39500.246292 (excluding connections establishing)
```



#### games_2_brin

```bash
progress: 5.0 s, 37112.5 tps, lat 0.536 ms stddev 0.420
progress: 10.0 s, 42546.7 tps, lat 0.469 ms stddev 0.169
progress: 15.0 s, 42953.0 tps, lat 0.464 ms stddev 0.174
progress: 20.0 s, 42815.5 tps, lat 0.466 ms stddev 0.227
progress: 25.0 s, 42303.8 tps, lat 0.471 ms stddev 0.208
progress: 30.0 s, 40716.5 tps, lat 0.490 ms stddev 0.265
progress: 35.0 s, 40510.9 tps, lat 0.492 ms stddev 0.351
progress: 40.0 s, 41547.8 tps, lat 0.480 ms stddev 0.198
progress: 45.0 s, 41126.6 tps, lat 0.485 ms stddev 0.266
progress: 50.0 s, 40908.9 tps, lat 0.488 ms stddev 0.301
progress: 55.0 s, 38571.8 tps, lat 0.517 ms stddev 0.253
progress: 60.0 s, 40523.5 tps, lat 0.492 ms stddev 0.573
progress: 65.0 s, 39468.3 tps, lat 0.505 ms stddev 0.419
progress: 70.0 s, 40121.2 tps, lat 0.497 ms stddev 0.302
progress: 75.0 s, 40832.8 tps, lat 0.488 ms stddev 0.174
progress: 80.0 s, 39757.7 tps, lat 0.502 ms stddev 0.976
progress: 85.0 s, 40214.8 tps, lat 0.496 ms stddev 0.263
transaction type: create_game.sql
scaling factor: 1
query mode: simple
number of clients: 20
number of threads: 6
number of transactions per client: 180000
number of transactions actually processed: 3600000/3600000
latency average = 0.490 ms
latency stddev = 0.372 ms
tps = 40561.250956 (including connections establishing)
tps = 40563.793268 (excluding connections establishing)
```



#### games_2_tree

```bash
progress: 5.0 s, 37615.2 tps, lat 0.528 ms stddev 0.270
progress: 10.0 s, 37634.0 tps, lat 0.530 ms stddev 0.361
progress: 15.0 s, 37849.6 tps, lat 0.527 ms stddev 0.505
progress: 20.0 s, 36852.8 tps, lat 0.542 ms stddev 0.473
progress: 25.0 s, 36983.6 tps, lat 0.540 ms stddev 0.550
progress: 30.0 s, 36226.5 tps, lat 0.551 ms stddev 0.369
progress: 35.0 s, 37327.1 tps, lat 0.535 ms stddev 0.338
progress: 40.0 s, 36668.2 tps, lat 0.544 ms stddev 0.395
progress: 45.0 s, 36802.4 tps, lat 0.542 ms stddev 0.698
progress: 50.0 s, 37033.5 tps, lat 0.539 ms stddev 0.328
progress: 55.0 s, 36550.6 tps, lat 0.546 ms stddev 0.613
progress: 60.0 s, 37052.3 tps, lat 0.539 ms stddev 0.367
progress: 65.0 s, 37884.8 tps, lat 0.527 ms stddev 0.221
progress: 70.0 s, 36984.5 tps, lat 0.539 ms stddev 0.429
progress: 75.0 s, 36830.9 tps, lat 0.542 ms stddev 0.638
progress: 80.0 s, 37689.1 tps, lat 0.529 ms stddev 0.285
progress: 85.0 s, 37246.4 tps, lat 0.536 ms stddev 0.535
progress: 90.0 s, 38219.6 tps, lat 0.522 ms stddev 0.278
progress: 95.0 s, 37875.4 tps, lat 0.527 ms stddev 0.323
transaction type: create_game.sql
scaling factor: 1
query mode: simple
number of clients: 20
number of threads: 6
number of transactions per client: 180000
number of transactions actually processed: 3600000/3600000
latency average = 0.535 ms
latency stddev = 0.439 ms
tps = 37125.120463 (including connections establishing)
tps = 37127.892994 (excluding connections establishing)
```



#### games_3_tree

```bash
progress: 5.0 s, 35732.6 tps, lat 0.556 ms stddev 0.455
progress: 10.0 s, 36531.9 tps, lat 0.546 ms stddev 0.344
progress: 15.0 s, 37213.8 tps, lat 0.536 ms stddev 0.318
progress: 20.0 s, 35697.3 tps, lat 0.559 ms stddev 0.545
progress: 25.0 s, 35982.9 tps, lat 0.555 ms stddev 0.539
progress: 30.0 s, 36553.3 tps, lat 0.546 ms stddev 0.298
progress: 35.0 s, 35966.9 tps, lat 0.555 ms stddev 1.260
progress: 40.0 s, 36358.6 tps, lat 0.549 ms stddev 0.340
progress: 45.0 s, 35938.3 tps, lat 0.555 ms stddev 0.568
progress: 50.0 s, 35663.2 tps, lat 0.560 ms stddev 0.605
progress: 55.0 s, 36214.1 tps, lat 0.551 ms stddev 0.458
progress: 60.0 s, 35472.0 tps, lat 0.563 ms stddev 0.403
progress: 65.0 s, 34569.5 tps, lat 0.577 ms stddev 0.617
progress: 70.0 s, 35946.2 tps, lat 0.555 ms stddev 0.344
progress: 75.0 s, 35671.3 tps, lat 0.559 ms stddev 0.407
progress: 80.0 s, 34908.5 tps, lat 0.572 ms stddev 0.505
progress: 85.0 s, 36191.2 tps, lat 0.551 ms stddev 0.454
progress: 90.0 s, 36661.6 tps, lat 0.544 ms stddev 0.224
progress: 95.0 s, 35505.9 tps, lat 0.562 ms stddev 0.470
progress: 100.0 s, 35422.9 tps, lat 0.547 ms stddev 0.328
transaction type: create_game.sql
scaling factor: 1
query mode: simple
number of clients: 20
number of threads: 6
number of transactions per client: 180000
number of transactions actually processed: 3600000/3600000
latency average = 0.554 ms
latency stddev = 0.517 ms
tps = 35797.037655 (including connections establishing)
tps = 35799.746057 (excluding connections establishing)
```



#### games_4_tree

p

```bash
rogress: 5.0 s, 33393.7 tps, lat 0.594 ms stddev 0.391
progress: 10.0 s, 34967.4 tps, lat 0.571 ms stddev 0.281
progress: 15.0 s, 32766.8 tps, lat 0.609 ms stddev 0.402
progress: 20.0 s, 34353.9 tps, lat 0.581 ms stddev 0.276
progress: 25.0 s, 33560.5 tps, lat 0.595 ms stddev 0.471
progress: 30.0 s, 33085.0 tps, lat 0.603 ms stddev 0.445
progress: 35.0 s, 34659.1 tps, lat 0.576 ms stddev 0.747
progress: 40.0 s, 34610.9 tps, lat 0.577 ms stddev 0.443
progress: 45.0 s, 34428.2 tps, lat 0.580 ms stddev 0.531
progress: 50.0 s, 33953.0 tps, lat 0.588 ms stddev 1.662
progress: 55.0 s, 32588.7 tps, lat 0.612 ms stddev 0.689
progress: 60.0 s, 35019.5 tps, lat 0.570 ms stddev 0.423
progress: 65.0 s, 34466.8 tps, lat 0.579 ms stddev 0.403
progress: 70.0 s, 34296.3 tps, lat 0.582 ms stddev 0.427
progress: 75.0 s, 34933.9 tps, lat 0.571 ms stddev 0.395
progress: 80.0 s, 34048.0 tps, lat 0.586 ms stddev 0.689
progress: 85.0 s, 34131.2 tps, lat 0.585 ms stddev 0.466
progress: 90.0 s, 34700.9 tps, lat 0.575 ms stddev 0.426
progress: 95.0 s, 20010.6 tps, lat 0.998 ms stddev 0.786
progress: 100.0 s, 18833.1 tps, lat 1.058 ms stddev 0.662
progress: 105.0 s, 18615.0 tps, lat 1.074 ms stddev 1.024
progress: 110.0 s, 18314.0 tps, lat 1.090 ms stddev 1.919
progress: 115.0 s, 28425.7 tps, lat 0.681 ms stddev 3.856
transaction type: create_game.sql
scaling factor: 1
query mode: simple
number of clients: 20
number of threads: 6
number of transactions per client: 180000
number of transactions actually processed: 3600000/3600000
latency average = 0.637 ms
latency stddev = 1.037 ms
tps = 31160.730182 (including connections establishing)
tps = 31163.388334 (excluding connections establishing)
```