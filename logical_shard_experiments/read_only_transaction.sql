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