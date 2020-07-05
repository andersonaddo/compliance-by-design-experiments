--BEGIN;
--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

--Credit for random string generation method: https://www.simononsoftware.com/random-string-in-postgresql/
--Make 2 posts
select * from post(floor(random() * (SELECT last_value FROM users_id_seq) + 1)::int, (SELECT array_to_string(ARRAY (SELECT substring('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ' FROM (random() * 36)::int FOR 1) FROM generate_series(1, 200) ), '' )));
select * from post(floor(random() * (SELECT last_value FROM users_id_seq) + 1)::int, (SELECT array_to_string(ARRAY (SELECT substring('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ' FROM (random() * 36)::int FOR 1) FROM generate_series(1, 200) ), '' )));

--Comment in 1 post
SELECT * FROM comment(
    floor(random() * (SELECT last_value FROM users_id_seq) + 1)::int, 
    floor(random() * (SELECT last_value FROM posts_id_seq) + 1)::int,
    (SELECT array_to_string(ARRAY (SELECT substring('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ' FROM (random() * 36)::int FOR 1) FROM generate_series(1, 200) ), '' )));

--Read 10 posts
--I had to use the strange syntax of treating the floor(...) function as a subquery to make it 
--easeir for the query planner to infer that it's safe to use indexes instead of doing 
--sequential scanning
SELECT * from comments where post_id = (select floor(random() * (SELECT last_value FROM posts_id_seq) + 1)) :: int;
SELECT * from comments where post_id = (select floor(random() * (SELECT last_value FROM posts_id_seq) + 1)) :: int;
SELECT * from comments where post_id = (select floor(random() * (SELECT last_value FROM posts_id_seq) + 1)) :: int;
SELECT * from comments where post_id = (select floor(random() * (SELECT last_value FROM posts_id_seq) + 1)) :: int;
SELECT * from comments where post_id = (select floor(random() * (SELECT last_value FROM posts_id_seq) + 1)) :: int;
SELECT * from comments where post_id = (select floor(random() * (SELECT last_value FROM posts_id_seq) + 1)) :: int;
SELECT * from comments where post_id = (select floor(random() * (SELECT last_value FROM posts_id_seq) + 1)) :: int;
SELECT * from comments where post_id = (select floor(random() * (SELECT last_value FROM posts_id_seq) + 1)) :: int;
SELECT * from comments where post_id = (select floor(random() * (SELECT last_value FROM posts_id_seq) + 1)) :: int;
SELECT * from comments where post_id = (select floor(random() * (SELECT last_value FROM posts_id_seq) + 1)) :: int;

--Like the last post you made with a random user
--Using (SELECT last_value FROM seq) can cause concurrency issues with this command.
--currval('seq') vs (select last_value from seq)
--=> https://dba.stackexchange.com/questions/3281/how-do-i-use-currval-in-postgresql-to-get-the-last-inserted-id/3284
SELECT * from like_post(floor(random() * (SELECT last_value FROM users_id_seq) + 1)::int, currval('posts_id_seq')::int);
    
--COMMIT;