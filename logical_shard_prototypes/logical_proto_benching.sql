--Create a new user
select * from create_user('@randomUserName');

--Make 2 posts
select * from post(floor(random() * (SELECT last_value FROM users_id_seq) + 1)::int, 'TIFU by eating a pie I did not like.');
select * from post(floor(random() * (SELECT last_value FROM users_id_seq) + 1)::int, 'TIL about Mr. Osei Tutu of Ghana. He is a pretty nice man, actaully.');


--Comment in 1 post
SELECT * FROM comment(
    floor(random() * (SELECT last_value FROM users_id_seq) + 1)::int, 
    floor(random() * (SELECT last_value FROM posts_id_seq) + 1)::int,
    '*Enter joke here* Translation: "Give me karma!!"');

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

-- SELECT * from like_post(2, 5);
-- SELECT * from like_comment(2, 5);
