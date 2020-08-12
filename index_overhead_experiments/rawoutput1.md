100000 transactions each for 8 clients over 4 jobs

#### games

```bash
Andersons-MacBook-Pro:SQL files and dumps andersonaddo$ pgbench --file create_game.sql --jobs 4 --transactions 100000 --client 8 --progress 5 --no-vacuum videogames
progress: 5.0 s, 26864.3 tps, lat 0.294 ms stddev 0.090
progress: 10.0 s, 26953.6 tps, lat 0.294 ms stddev 0.086
progress: 15.0 s, 26938.6 tps, lat 0.294 ms stddev 0.143
progress: 20.0 s, 26606.2 tps, lat 0.298 ms stddev 0.136
progress: 25.0 s, 26616.0 tps, lat 0.298 ms stddev 0.145
progress: 30.0 s, 25853.3 tps, lat 0.293 ms stddev 0.153
transaction type: create_game.sql
scaling factor: 1
query mode: simple
number of clients: 8
number of threads: 4
number of transactions per client: 100000
number of transactions actually processed: 800000/800000
latency average = 0.295 ms
latency stddev = 0.128 ms
tps = 26538.884640 (including connections establishing)
tps = 26544.037143 (excluding connections establishing)
```



#### games_unique

```bash
progress: 5.0 s, 25669.6 tps, lat 0.308 ms stddev 0.171
progress: 10.0 s, 26456.8 tps, lat 0.300 ms stddev 0.075
progress: 15.0 s, 25850.4 tps, lat 0.307 ms stddev 0.089
progress: 20.0 s, 25215.3 tps, lat 0.315 ms stddev 0.221
progress: 25.0 s, 26010.8 tps, lat 0.305 ms stddev 0.090
progress: 30.0 s, 25853.3 tps, lat 0.307 ms stddev 0.117
transaction type: create_game.sql
scaling factor: 1
query mode: simple
number of clients: 8
number of threads: 4
number of transactions per client: 100000
number of transactions actually processed: 800000/800000
latency average = 0.306 ms
latency stddev = 0.144 ms
tps = 25610.112230 (including connections establishing)
tps = 25615.240013 (excluding connections establishing)
```



#### games_1_hash

```bash
Andersons-MacBook-Pro:SQL files and dumps andersonaddo$ pgbench --file create_game.sql --jobs 4 --transactions 100000 --client 8 --progress 5 --no-vacuum videogames
progress: 5.0 s, 12138.5 tps, lat 0.653 ms stddev 0.375
progress: 10.0 s, 9567.7 tps, lat 0.833 ms stddev 0.203
progress: 15.0 s, 8344.7 tps, lat 0.956 ms stddev 0.466
progress: 20.0 s, 7635.6 tps, lat 1.045 ms stddev 0.393
progress: 25.0 s, 7193.7 tps, lat 1.110 ms stddev 0.204
progress: 30.0 s, 10632.9 tps, lat 0.751 ms stddev 0.247
progress: 35.0 s, 9092.3 tps, lat 0.878 ms stddev 0.213
progress: 40.0 s, 8116.0 tps, lat 0.984 ms stddev 0.255
progress: 45.0 s, 7834.0 tps, lat 1.019 ms stddev 0.306
progress: 50.0 s, 7649.6 tps, lat 1.044 ms stddev 0.145
progress: 55.0 s, 7125.6 tps, lat 1.121 ms stddev 0.179
progress: 60.0 s, 6704.5 tps, lat 1.192 ms stddev 0.342
progress: 65.0 s, 6363.8 tps, lat 1.255 ms stddev 0.236
progress: 70.0 s, 5765.0 tps, lat 1.386 ms stddev 0.454
progress: 75.0 s, 5850.5 tps, lat 1.366 ms stddev 0.325
progress: 80.0 s, 5663.3 tps, lat 1.411 ms stddev 0.204
progress: 85.0 s, 5483.9 tps, lat 1.457 ms stddev 2.009
progress: 90.0 s, 5101.4 tps, lat 1.567 ms stddev 0.410
progress: 95.0 s, 4677.2 tps, lat 1.709 ms stddev 0.360
progress: 100.0 s, 4578.4 tps, lat 1.746 ms stddev 0.329
progress: 105.0 s, 4323.4 tps, lat 1.849 ms stddev 0.456
progress: 110.0 s, 4159.0 tps, lat 1.921 ms stddev 0.246
progress: 115.0 s, 3831.4 tps, lat 2.086 ms stddev 0.352
transaction type: create_game.sql
scaling factor: 1
query mode: simple
number of clients: 8
number of threads: 4
number of transactions per client: 100000
number of transactions actually processed: 800000/800000
latency average = 1.176 ms
latency stddev = 0.611 ms
tps = 6741.832969 (including connections establishing)
tps = 6742.319920 (excluding connections establishing)
```

#### games_1_brin

```bash
Andersons-MacBook-Pro:SQL files and dumps andersonaddo$ pgbench --file create_game.sql --jobs 4 --transactions 100000 --client 8 --progress 5 --no-vacuum videogames
progress: 5.0 s, 24896.4 tps, lat 0.318 ms stddev 0.403
progress: 10.0 s, 25592.7 tps, lat 0.310 ms stddev 0.082
progress: 15.0 s, 26196.3 tps, lat 0.303 ms stddev 0.078
progress: 20.0 s, 25915.9 tps, lat 0.306 ms stddev 0.152
progress: 25.0 s, 24695.6 tps, lat 0.321 ms stddev 0.165
progress: 30.0 s, 26254.7 tps, lat 0.302 ms stddev 0.077
transaction type: create_game.sql
scaling factor: 1
query mode: simple
number of clients: 8
number of threads: 4
number of transactions per client: 100000
number of transactions actually processed: 800000/800000
latency average = 0.310 ms
latency stddev = 0.200 ms
tps = 25418.557612 (including connections establishing)
tps = 25422.151106 (excluding connections establishing)


games_one_tree
Andersons-MacBook-Pro:SQL files and dumps andersonaddo$ pgbench --file create_game.sql --jobs 4 --transactions 100000 --client 8 --progress 5 --no-vacuum videogames
progress: 5.0 s, 24154.7 tps, lat 0.328 ms stddev 0.282
progress: 10.0 s, 24975.4 tps, lat 0.318 ms stddev 0.120
progress: 15.0 s, 25278.6 tps, lat 0.314 ms stddev 0.107
progress: 20.0 s, 25308.4 tps, lat 0.314 ms stddev 0.152
progress: 25.0 s, 25316.2 tps, lat 0.314 ms stddev 0.093
progress: 30.0 s, 25040.2 tps, lat 0.317 ms stddev 0.138
transaction type: create_game.sql
scaling factor: 1
query mode: simple
number of clients: 8
number of threads: 4
number of transactions per client: 100000
number of transactions actually processed: 800000/800000
latency average = 0.317 ms
latency stddev = 0.175 ms
tps = 24803.565421 (including connections establishing)
tps = 24806.868176 (excluding connections establishing)


```

#### games_2_brin

```bash
Andersons-MacBook-Pro:SQL files and dumps andersonaddo$ pgbench --file create_game.sql --jobs 4 --transactions 100000 --client 8 --progress 5 --no-vacuum videogames
progress: 5.0 s, 24907.4 tps, lat 0.318 ms stddev 0.189
progress: 10.0 s, 25734.0 tps, lat 0.308 ms stddev 0.079
progress: 15.0 s, 26034.7 tps, lat 0.305 ms stddev 0.074
progress: 20.0 s, 25318.0 tps, lat 0.313 ms stddev 0.211
progress: 25.0 s, 25715.3 tps, lat 0.308 ms stddev 0.087
progress: 30.0 s, 25897.6 tps, lat 0.306 ms stddev 0.082
transaction type: create_game.sql
scaling factor: 1
query mode: simple
number of clients: 8
number of threads: 4
number of transactions per client: 100000
number of transactions actually processed: 800000/800000
latency average = 0.309 ms
latency stddev = 0.131 ms
tps = 25454.306950 (including connections establishing)
tps = 25457.951226 (excluding connections establishing)
```

#### games_2_hash

```bash
Andersons-MacBook-Pro:SQL files and dumps andersonaddo$ pgbench --file create_game.sql --jobs 4 --transactions 100000 --client 8 --progress 5 --no-vacuum videogames
progress: 5.0 s, 17908.3 tps, lat 0.444 ms stddev 0.214
progress: 10.0 s, 11071.8 tps, lat 0.721 ms stddev 0.192
progress: 15.0 s, 8894.0 tps, lat 0.898 ms stddev 0.244
progress: 20.0 s, 7559.4 tps, lat 1.056 ms stddev 0.343
progress: 25.0 s, 6856.0 tps, lat 1.165 ms stddev 0.183
progress: 30.0 s, 6010.5 tps, lat 1.329 ms stddev 0.209
progress: 35.0 s, 5552.6 tps, lat 1.439 ms stddev 1.240
progress: 40.0 s, 5128.8 tps, lat 1.558 ms stddev 0.231
progress: 45.0 s, 4512.3 tps, lat 1.772 ms stddev 0.518
progress: 50.0 s, 4463.6 tps, lat 1.791 ms stddev 0.483
progress: 55.0 s, 4315.9 tps, lat 1.852 ms stddev 0.267
progress: 60.0 s, 4030.7 tps, lat 1.982 ms stddev 0.264
progress: 65.0 s, 3616.2 tps, lat 2.212 ms stddev 0.852
progress: 70.0 s, 3737.1 tps, lat 2.139 ms stddev 0.276
progress: 75.0 s, 2955.8 tps, lat 2.703 ms stddev 0.555
progress: 80.0 s, 2392.0 tps, lat 3.343 ms stddev 0.700
progress: 85.0 s, 2334.6 tps, lat 3.422 ms stddev 0.415
progress: 90.0 s, 2791.6 tps, lat 2.864 ms stddev 0.346
progress: 95.0 s, 3383.1 tps, lat 2.362 ms stddev 0.476
progress: 100.0 s, 3295.3 tps, lat 2.427 ms stddev 0.299
progress: 105.0 s, 2789.4 tps, lat 2.865 ms stddev 0.429
progress: 110.0 s, 2568.8 tps, lat 3.112 ms stddev 0.651
progress: 115.0 s, 2585.8 tps, lat 3.091 ms stddev 0.398
progress: 120.0 s, 2782.0 tps, lat 2.874 ms stddev 0.428
progress: 125.0 s, 2833.7 tps, lat 2.821 ms stddev 0.505
progress: 130.0 s, 2659.0 tps, lat 3.007 ms stddev 0.424
progress: 135.0 s, 2530.9 tps, lat 3.159 ms stddev 2.959
progress: 140.0 s, 2458.0 tps, lat 3.251 ms stddev 0.717
progress: 145.0 s, 2753.2 tps, lat 2.904 ms stddev 0.406
progress: 150.0 s, 2750.9 tps, lat 2.907 ms stddev 0.458
progress: 155.0 s, 2552.9 tps, lat 3.132 ms stddev 0.548
progress: 160.0 s, 2602.4 tps, lat 3.071 ms stddev 0.377
progress: 165.0 s, 2256.2 tps, lat 3.545 ms stddev 0.422
progress: 170.0 s, 2454.1 tps, lat 3.257 ms stddev 0.649
progress: 175.0 s, 2612.5 tps, lat 3.061 ms stddev 0.397
progress: 180.0 s, 2421.0 tps, lat 3.304 ms stddev 0.443
progress: 185.0 s, 2321.7 tps, lat 3.443 ms stddev 0.575
progress: 190.0 s, 2333.3 tps, lat 3.428 ms stddev 0.632
progress: 195.0 s, 2330.2 tps, lat 3.431 ms stddev 0.536
transaction type: create_game.sql
scaling factor: 1
query mode: simple
number of clients: 8
number of threads: 4
number of transactions per client: 100000
number of transactions actually processed: 800000/800000
latency average = 1.960 ms
latency stddev = 1.183 ms
tps = 4055.673541 (including connections establishing)
tps = 4055.784749 (excluding connections establishing)
```

#### games_2_tree

```bash
Andersons-MacBook-Pro:SQL files and dumps andersonaddo$ pgbench --file create_game.sql --jobs 4 --transactions 100000 --client 8 --progress 5 --no-vacuum videogames
progress: 5.0 s, 23683.9 tps, lat 0.335 ms stddev 0.209
progress: 10.0 s, 24108.0 tps, lat 0.330 ms stddev 0.150
progress: 15.0 s, 23171.0 tps, lat 0.343 ms stddev 0.229
progress: 20.0 s, 23844.2 tps, lat 0.333 ms stddev 0.221
progress: 25.0 s, 24492.9 tps, lat 0.324 ms stddev 0.096
progress: 30.0 s, 24437.9 tps, lat 0.325 ms stddev 0.129
transaction type: create_game.sql
scaling factor: 1
query mode: simple
number of clients: 8
number of threads: 4
number of transactions per client: 100000
number of transactions actually processed: 800000/800000
latency average = 0.331 ms
latency stddev = 0.180 ms
tps = 23842.368117 (including connections establishing)
tps = 23845.999943 (excluding connections establishing)
```

#### games_3_hash

```bash
Andersons-MacBook-Pro:SQL files and dumps andersonaddo$ pgbench --file create_game.sql --jobs 4 --transactions 100000 --client 8 --progress 5 --no-vacuum videogames
progress: 5.0 s, 17349.1 tps, lat 0.458 ms stddev 0.196
progress: 10.0 s, 10629.0 tps, lat 0.751 ms stddev 0.265
progress: 15.0 s, 9107.5 tps, lat 0.877 ms stddev 0.247
progress: 20.0 s, 7732.8 tps, lat 1.033 ms stddev 0.164
progress: 25.0 s, 6874.2 tps, lat 1.162 ms stddev 0.175
progress: 30.0 s, 6165.9 tps, lat 1.295 ms stddev 0.299
progress: 35.0 s, 5594.4 tps, lat 1.428 ms stddev 0.243
progress: 40.0 s, 5075.9 tps, lat 1.574 ms stddev 0.485
progress: 45.0 s, 4952.1 tps, lat 1.614 ms stddev 0.401
progress: 50.0 s, 4737.3 tps, lat 1.687 ms stddev 0.214
progress: 55.0 s, 4316.8 tps, lat 1.852 ms stddev 0.259
progress: 60.0 s, 4077.2 tps, lat 1.960 ms stddev 0.433
progress: 65.0 s, 3914.7 tps, lat 2.042 ms stddev 0.349
progress: 70.0 s, 3594.3 tps, lat 2.224 ms stddev 0.563
progress: 75.0 s, 3733.1 tps, lat 2.141 ms stddev 0.416
progress: 80.0 s, 3537.2 tps, lat 2.260 ms stddev 0.363
progress: 85.0 s, 3456.6 tps, lat 2.312 ms stddev 0.317
progress: 90.0 s, 3191.5 tps, lat 2.505 ms stddev 0.508
progress: 95.0 s, 3194.5 tps, lat 2.502 ms stddev 0.406
progress: 100.0 s, 3129.3 tps, lat 2.555 ms stddev 0.474
progress: 105.0 s, 2821.2 tps, lat 2.834 ms stddev 0.589
progress: 110.0 s, 2860.1 tps, lat 2.795 ms stddev 0.373
progress: 115.0 s, 2809.9 tps, lat 2.845 ms stddev 0.398
progress: 120.0 s, 2986.6 tps, lat 2.677 ms stddev 0.727
progress: 125.0 s, 2972.4 tps, lat 2.690 ms stddev 2.496
progress: 130.0 s, 2696.7 tps, lat 2.964 ms stddev 0.597
progress: 135.0 s, 2916.0 tps, lat 2.741 ms stddev 0.614
progress: 140.0 s, 2923.5 tps, lat 2.736 ms stddev 0.334
progress: 145.0 s, 2847.6 tps, lat 2.808 ms stddev 0.344
progress: 150.0 s, 2727.9 tps, lat 2.931 ms stddev 0.506
progress: 155.0 s, 2620.4 tps, lat 3.051 ms stddev 0.380
progress: 160.0 s, 2558.8 tps, lat 3.125 ms stddev 0.399
progress: 165.0 s, 2597.1 tps, lat 3.079 ms stddev 0.614
progress: 170.0 s, 2534.6 tps, lat 3.155 ms stddev 0.422
progress: 175.0 s, 2616.8 tps, lat 3.056 ms stddev 0.336
progress: 180.0 s, 2399.3 tps, lat 3.333 ms stddev 0.595
transaction type: create_game.sql
scaling factor: 1
query mode: simple
number of clients: 8
number of threads: 4
number of transactions per client: 100000
number of transactions actually processed: 800000/800000
latency average = 1.834 ms
latency stddev = 1.029 ms
tps = 4345.992491 (including connections establishing)
tps = 4346.135817 (excluding connections establishing)
```



#### games_3_tree

```bash
progress: 5.0 s, 23561.4 tps, lat 0.337 ms stddev 0.117
progress: 10.0 s, 23932.7 tps, lat 0.332 ms stddev 0.148
progress: 15.0 s, 23779.2 tps, lat 0.334 ms stddev 0.333
progress: 20.0 s, 23786.4 tps, lat 0.334 ms stddev 0.480
progress: 25.0 s, 23098.8 tps, lat 0.344 ms stddev 0.505
progress: 30.0 s, 22873.3 tps, lat 0.347 ms stddev 0.798
transaction type: create_game.sql
scaling factor: 1
query mode: simple
number of clients: 8
number of threads: 4
number of transactions per client: 100000
number of transactions actually processed: 800000/800000
latency average = 0.338 ms
latency stddev = 0.450 ms
tps = 23278.297121 (including connections establishing)
tps = 23281.236867 (excluding connections establishing)
```

#### games_4_tree

```bash
progress: 5.0 s, 22660.1 tps, lat 0.350 ms stddev 0.172
progress: 10.0 s, 23332.4 tps, lat 0.341 ms stddev 0.114
progress: 15.0 s, 22912.7 tps, lat 0.347 ms stddev 0.099
progress: 20.0 s, 23212.3 tps, lat 0.342 ms stddev 0.185
progress: 25.0 s, 21935.2 tps, lat 0.362 ms stddev 0.263
progress: 30.0 s, 23080.2 tps, lat 0.344 ms stddev 0.133
progress: 35.0 s, 22438.1 tps, lat 0.344 ms stddev 0.196
transaction type: create_game.sql
scaling factor: 1
query mode: simple
number of clients: 8
number of threads: 4
number of transactions per client: 100000
number of transactions actually processed: 800000/800000
latency average = 0.347 ms
latency stddev = 0.173 ms
tps = 22702.407627 (including connections establishing)
tps = 22706.094158 (excluding connections establishing)
```

