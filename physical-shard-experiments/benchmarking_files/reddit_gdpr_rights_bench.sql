--BEGIN;
--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

--Get one user's shard
explain analyse select * from get_user_shard( (select floor(random() * (SELECT last_value FROM users_id_seq))) :: int ) ;

--COMMIT;