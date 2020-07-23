#!/bin/bash
psql -c "TRUNCATE games;"
psql -c "TRUNCATE games_1_brin;"
psql -c "TRUNCATE games_1_hash;"
psql -c "TRUNCATE games_1_tree;"
psql -c "TRUNCATE games_2_brin;"
psql -c "TRUNCATE games_2_hash;"
psql -c "TRUNCATE games_2_tree;"
psql -c "TRUNCATE games_3_hash;"
psql -c "TRUNCATE games_3_tree;"
psql -c "TRUNCATE games_4_tree;"
psql -c "TRUNCATE games_unique;"

