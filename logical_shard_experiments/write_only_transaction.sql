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
