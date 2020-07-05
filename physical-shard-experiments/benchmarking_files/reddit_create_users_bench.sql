--BEGIN;
--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

--Make one user

--Credit for random string generation method: https://www.simononsoftware.com/random-string-in-postgresql/
select * from create_user((SELECT array_to_string(ARRAY (SELECT substring('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ' FROM (random() * 36)::int FOR 1) FROM generate_series(1, 20) ), '' )));

--COMMIT;