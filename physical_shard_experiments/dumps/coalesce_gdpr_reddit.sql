--
-- PostgreSQL database dump
--

-- Dumped from database version 12.3
-- Dumped by pg_dump version 12.3

-- Started on 2020-07-01 13:44:06 EDT

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 6 (class 2615 OID 617179)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 3317 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 8 (class 2615 OID 617180)
-- Name: shards; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA shards;


ALTER SCHEMA shards OWNER TO postgres;

--
-- TOC entry 230 (class 1255 OID 617181)
-- Name: comment(integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.comment(user_id integer, post_id integer, content character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
   insert into "comments" (poster_id , "content", post_id , likes, date_of_creation )
   values ($1, content, $2, 0, now());
END;
$_$;


ALTER FUNCTION public.comment(user_id integer, post_id integer, content character varying) OWNER TO postgres;

--
-- TOC entry 249 (class 1255 OID 617182)
-- Name: create_user(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_user(username_value character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
declare 
	counter integer := nextval('users_id_seq');
	q text := '';
BEGIN
   insert into users (id, username , date_of_creation ) values (counter, $1, now());
  
  --Making the comments shard table
   q := format('CREATE TABLE shards.%I PARTITION OF "sharded_comments"', 'comments_' || cast(counter as TEXT));
  q:= q || format(' FOR VALUES IN (%L)', counter);
   --RAISE NOTICE 'Creating comments partition: %', q;
   EXECUTE q;
  
  --Making the shards table for posts
     q := format('CREATE TABLE shards.%I PARTITION OF "sharded_posts"', 'posts_' || cast(counter as TEXT));
  q:= q || format(' FOR VALUES IN (%L)', counter);
   --RAISE NOTICE 'Creating posts partition: %', q;
   EXECUTE q;
  
    --Making the shards table for liked_posts
     q := format('CREATE TABLE shards.%I PARTITION OF "sharded_liked_posts"', 'liked_posts_' || cast(counter as TEXT));
  q:= q || format(' FOR VALUES IN (%L)', counter);
   --RAISE NOTICE 'Creating liked posts partition: %', q;
   EXECUTE q;
  
    --Making the shards table for liked_comments
     q := format('CREATE TABLE shards.%I PARTITION OF "sharded_liked_comments"', 'liked_comments_' || cast(counter as TEXT));
  q:= q || format(' FOR VALUES IN (%L)', counter);
   --RAISE NOTICE 'Creating liked comments partition: %', q;
   EXECUTE q;
END;
$_$;


ALTER FUNCTION public.create_user(username_value character varying) OWNER TO postgres;

--
-- TOC entry 231 (class 1255 OID 617183)
-- Name: decrement_comment_like_counter(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.decrement_comment_like_counter() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE comments 
    SET likes = coalesce(likes, 0) - 1
    WHERE comment_id = old.comment_id;
return new;

END;
$$;


ALTER FUNCTION public.decrement_comment_like_counter() OWNER TO postgres;

--
-- TOC entry 232 (class 1255 OID 617184)
-- Name: decrement_post_like_counter(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.decrement_post_like_counter() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE posts 
    SET likes = coalesce(likes, 0) - 1
    WHERE id = old.post_id;
return new;

END;
$$;


ALTER FUNCTION public.decrement_post_like_counter() OWNER TO postgres;

--
-- TOC entry 233 (class 1255 OID 617185)
-- Name: del_update_sharded_comments(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.del_update_sharded_comments() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    delete from sharded_comments where comment_id  = old.comment_id and poster_id  = old.poster_id; 
	return old;

END;
$$;


ALTER FUNCTION public.del_update_sharded_comments() OWNER TO postgres;

--
-- TOC entry 234 (class 1255 OID 617186)
-- Name: del_update_sharded_liked_comments(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.del_update_sharded_liked_comments() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    delete from sharded_liked_comments where user_id = old.user_id and comment_id = old.comment_id;
   return old;
END;
$$;


ALTER FUNCTION public.del_update_sharded_liked_comments() OWNER TO postgres;

--
-- TOC entry 235 (class 1255 OID 617187)
-- Name: del_update_sharded_liked_posts(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.del_update_sharded_liked_posts() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    delete from sharded_liked_posts where user_id = old.user_id and post_id = old.post_id;
   return old;
END;
$$;


ALTER FUNCTION public.del_update_sharded_liked_posts() OWNER TO postgres;

--
-- TOC entry 236 (class 1255 OID 617188)
-- Name: del_update_sharded_posts(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.del_update_sharded_posts() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    delete from sharded_posts where id = old.id and owner_id  = old.owner_id;
   return old;
END;
$$;


ALTER FUNCTION public.del_update_sharded_posts() OWNER TO postgres;

--
-- TOC entry 237 (class 1255 OID 617189)
-- Name: get_user_shard(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_user_shard(integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$ begin
	perform * from sharded_posts p where p.owner_id  = $1;
	perform * from sharded_liked_comments lc where lc.user_id  = $1;
	perform * from sharded_liked_posts lp where lp.user_id = $1;
	perform * from "sharded_comments" c where c.poster_id = $1;
end;$_$;


ALTER FUNCTION public.get_user_shard(integer) OWNER TO postgres;

--
-- TOC entry 238 (class 1255 OID 617190)
-- Name: increment_comment_like_counter(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.increment_comment_like_counter() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE comments 
    SET likes = coalesce(likes, 0) + 1
    WHERE comment_id = new.comment_id;
return new;

END;
$$;


ALTER FUNCTION public.increment_comment_like_counter() OWNER TO postgres;

--
-- TOC entry 239 (class 1255 OID 617191)
-- Name: increment_post_like_counter(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.increment_post_like_counter() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE posts 
    SET likes = coalesce(likes, 0) + 1
    WHERE id = new.post_id;
return new;

END;
$$;


ALTER FUNCTION public.increment_post_like_counter() OWNER TO postgres;

--
-- TOC entry 240 (class 1255 OID 617192)
-- Name: like_comment(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.like_comment(user_id integer, comment_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
    insert into liked_comments values ($1, $2);
END;
$_$;


ALTER FUNCTION public.like_comment(user_id integer, comment_id integer) OWNER TO postgres;

--
-- TOC entry 241 (class 1255 OID 617193)
-- Name: like_post(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.like_post(user_id integer, post_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
    insert into liked_posts values ($1, $2);
END;
$_$;


ALTER FUNCTION public.like_post(user_id integer, post_id integer) OWNER TO postgres;

--
-- TOC entry 242 (class 1255 OID 617194)
-- Name: post(integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.post(user_id integer, content character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
   insert into posts (owner_id, "content", date_of_creation, likes )
   values ($1, $2, Now(), 0);
END;
$_$;


ALTER FUNCTION public.post(user_id integer, content character varying) OWNER TO postgres;

--
-- TOC entry 243 (class 1255 OID 617195)
-- Name: unlike_comment(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.unlike_comment(user_id integer, comment_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
    delete from liked_comments 
	where  liked_comments.comment_id = $2 and liked_comments.user_id = $1;
END;
$_$;


ALTER FUNCTION public.unlike_comment(user_id integer, comment_id integer) OWNER TO postgres;

--
-- TOC entry 244 (class 1255 OID 617196)
-- Name: unlike_post(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.unlike_post(user_id integer, post_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
    delete from liked_posts 
	where  liked_posts.post_id = $2 and liked_posts.user_id = $1;
END;
$_$;


ALTER FUNCTION public.unlike_post(user_id integer, post_id integer) OWNER TO postgres;

--
-- TOC entry 245 (class 1255 OID 617197)
-- Name: update_sharded_comments(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_sharded_comments() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    insert into sharded_comments as c values (new.comment_id, new.content, new.date_of_creation, new.likes, new.post_id, new.poster_id) 
   	on conflict (poster_id , date_of_creation ) do update 
   	set content = new.content, likes = new.likes;
return new;

END;
$$;


ALTER FUNCTION public.update_sharded_comments() OWNER TO postgres;

--
-- TOC entry 246 (class 1255 OID 617198)
-- Name: update_sharded_liked_comments(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_sharded_liked_comments() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    insert into sharded_liked_comments values (new.user_id, new.comment_id);
return new;

END;
$$;


ALTER FUNCTION public.update_sharded_liked_comments() OWNER TO postgres;

--
-- TOC entry 247 (class 1255 OID 617199)
-- Name: update_sharded_liked_posts(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_sharded_liked_posts() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    insert into sharded_liked_posts values (new.user_id, new.post_id);
return new;

END;
$$;


ALTER FUNCTION public.update_sharded_liked_posts() OWNER TO postgres;

--
-- TOC entry 248 (class 1255 OID 617200)
-- Name: update_sharded_posts(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_sharded_posts() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    insert into sharded_posts as p values (new.id, new.owner_id, new.content, new.likes, new.date_of_creation) 
   	on conflict (id, owner_id) do update 
   	set content = new.content, likes = new.likes;
return new;

END;
$$;


ALTER FUNCTION public.update_sharded_posts() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 203 (class 1259 OID 617201)
-- Name: comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comments (
    comment_id integer NOT NULL,
    content character varying NOT NULL,
    date_of_creation timestamp without time zone NOT NULL,
    likes integer,
    post_id integer,
    poster_id integer
);


ALTER TABLE public.comments OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 617207)
-- Name: comments_comment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.comments_comment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.comments_comment_id_seq OWNER TO postgres;

--
-- TOC entry 3318 (class 0 OID 0)
-- Dependencies: 204
-- Name: comments_comment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.comments_comment_id_seq OWNED BY public.comments.comment_id;


--
-- TOC entry 205 (class 1259 OID 617209)
-- Name: liked_comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.liked_comments (
    user_id integer NOT NULL,
    comment_id integer NOT NULL
);


ALTER TABLE public.liked_comments OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 617212)
-- Name: liked_posts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.liked_posts (
    user_id integer NOT NULL,
    post_id integer NOT NULL
);


ALTER TABLE public.liked_posts OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 617215)
-- Name: posts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.posts (
    id integer NOT NULL,
    owner_id integer NOT NULL,
    content character varying NOT NULL,
    likes integer,
    date_of_creation timestamp without time zone NOT NULL
);


ALTER TABLE public.posts OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 617221)
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.posts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.posts_id_seq OWNER TO postgres;

--
-- TOC entry 3319 (class 0 OID 0)
-- Dependencies: 208
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;


--
-- TOC entry 209 (class 1259 OID 617223)
-- Name: sharded_comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sharded_comments (
    comment_id integer NOT NULL,
    content character varying NOT NULL,
    date_of_creation timestamp without time zone NOT NULL,
    likes integer,
    post_id integer,
    poster_id integer NOT NULL
)
PARTITION BY LIST (poster_id);


ALTER TABLE public.sharded_comments OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 617226)
-- Name: sharded_comments_comment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sharded_comments_comment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sharded_comments_comment_id_seq OWNER TO postgres;

--
-- TOC entry 3320 (class 0 OID 0)
-- Dependencies: 210
-- Name: sharded_comments_comment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sharded_comments_comment_id_seq OWNED BY public.sharded_comments.comment_id;


--
-- TOC entry 211 (class 1259 OID 617228)
-- Name: sharded_liked_comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sharded_liked_comments (
    user_id integer NOT NULL,
    comment_id integer NOT NULL
)
PARTITION BY LIST (user_id);


ALTER TABLE public.sharded_liked_comments OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 617231)
-- Name: sharded_liked_posts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sharded_liked_posts (
    user_id integer NOT NULL,
    post_id integer NOT NULL
)
PARTITION BY LIST (user_id);


ALTER TABLE public.sharded_liked_posts OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 617234)
-- Name: sharded_posts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sharded_posts (
    id integer NOT NULL,
    owner_id integer NOT NULL,
    content character varying NOT NULL,
    likes integer,
    date_of_creation timestamp without time zone NOT NULL
)
PARTITION BY LIST (owner_id);


ALTER TABLE public.sharded_posts OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 617237)
-- Name: sharded_posts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sharded_posts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sharded_posts_id_seq OWNER TO postgres;

--
-- TOC entry 3321 (class 0 OID 0)
-- Dependencies: 214
-- Name: sharded_posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sharded_posts_id_seq OWNED BY public.sharded_posts.id;


--
-- TOC entry 215 (class 1259 OID 617239)
-- Name: top_10_posts; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.top_10_posts AS
 SELECT posts.id,
    posts.owner_id,
    posts.content,
    posts.likes,
    posts.date_of_creation
   FROM public.posts
  ORDER BY posts.likes
 LIMIT 10;


ALTER TABLE public.top_10_posts OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 617243)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying NOT NULL,
    date_of_creation timestamp without time zone NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 617249)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 3322 (class 0 OID 0)
-- Dependencies: 217
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 3127 (class 2604 OID 617251)
-- Name: comments comment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments ALTER COLUMN comment_id SET DEFAULT nextval('public.comments_comment_id_seq'::regclass);


--
-- TOC entry 3128 (class 2604 OID 617252)
-- Name: posts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);


--
-- TOC entry 3129 (class 2604 OID 617253)
-- Name: sharded_comments comment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sharded_comments ALTER COLUMN comment_id SET DEFAULT nextval('public.sharded_comments_comment_id_seq'::regclass);


--
-- TOC entry 3130 (class 2604 OID 617254)
-- Name: sharded_posts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sharded_posts ALTER COLUMN id SET DEFAULT nextval('public.sharded_posts_id_seq'::regclass);


--
-- TOC entry 3131 (class 2604 OID 617255)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 3302 (class 0 OID 617201)
-- Dependencies: 203
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comments (comment_id, content, date_of_creation, likes, post_id, poster_id) FROM stdin;
\.


--
-- TOC entry 3304 (class 0 OID 617209)
-- Dependencies: 205
-- Data for Name: liked_comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.liked_comments (user_id, comment_id) FROM stdin;
\.


--
-- TOC entry 3305 (class 0 OID 617212)
-- Dependencies: 206
-- Data for Name: liked_posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.liked_posts (user_id, post_id) FROM stdin;
\.


--
-- TOC entry 3306 (class 0 OID 617215)
-- Dependencies: 207
-- Data for Name: posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.posts (id, owner_id, content, likes, date_of_creation) FROM stdin;
\.


--
-- TOC entry 3310 (class 0 OID 617243)
-- Dependencies: 216
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, date_of_creation) FROM stdin;
\.


--
-- TOC entry 3323 (class 0 OID 0)
-- Dependencies: 204
-- Name: comments_comment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comments_comment_id_seq', 1, false);


--
-- TOC entry 3324 (class 0 OID 0)
-- Dependencies: 208
-- Name: posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.posts_id_seq', 1, false);


--
-- TOC entry 3325 (class 0 OID 0)
-- Dependencies: 210
-- Name: sharded_comments_comment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sharded_comments_comment_id_seq', 1, false);


--
-- TOC entry 3326 (class 0 OID 0)
-- Dependencies: 214
-- Name: sharded_posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sharded_posts_id_seq', 1, false);


--
-- TOC entry 3327 (class 0 OID 0)
-- Dependencies: 217
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- TOC entry 3133 (class 2606 OID 617257)
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (comment_id);


--
-- TOC entry 3136 (class 2606 OID 617259)
-- Name: liked_comments liked_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.liked_comments
    ADD CONSTRAINT liked_comments_pkey PRIMARY KEY (user_id, comment_id);


--
-- TOC entry 3138 (class 2606 OID 617261)
-- Name: liked_posts liked_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.liked_posts
    ADD CONSTRAINT liked_posts_pkey PRIMARY KEY (user_id, post_id);


--
-- TOC entry 3141 (class 2606 OID 617263)
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- TOC entry 3143 (class 2606 OID 617265)
-- Name: sharded_comments sharded_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sharded_comments
    ADD CONSTRAINT sharded_comments_pkey PRIMARY KEY (poster_id, date_of_creation);


--
-- TOC entry 3145 (class 2606 OID 617267)
-- Name: sharded_liked_comments sharded_liked_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sharded_liked_comments
    ADD CONSTRAINT sharded_liked_comments_pkey PRIMARY KEY (user_id, comment_id);


--
-- TOC entry 3147 (class 2606 OID 617269)
-- Name: sharded_liked_posts sharded_liked_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sharded_liked_posts
    ADD CONSTRAINT sharded_liked_posts_pkey PRIMARY KEY (user_id, post_id);


--
-- TOC entry 3149 (class 2606 OID 617271)
-- Name: sharded_posts sharded_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sharded_posts
    ADD CONSTRAINT sharded_posts_pkey PRIMARY KEY (id, owner_id);


--
-- TOC entry 3151 (class 2606 OID 617273)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3134 (class 1259 OID 617274)
-- Name: comments_post_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX comments_post_id_idx ON public.comments USING hash (post_id);


--
-- TOC entry 3139 (class 1259 OID 617275)
-- Name: like_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX like_index ON public.posts USING btree (likes);


--
-- TOC entry 3165 (class 2620 OID 617276)
-- Name: liked_comments add_to_comment_like; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER add_to_comment_like AFTER INSERT ON public.liked_comments FOR EACH ROW EXECUTE FUNCTION public.increment_comment_like_counter();


--
-- TOC entry 3169 (class 2620 OID 617277)
-- Name: liked_posts add_to_post_like; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER add_to_post_like AFTER INSERT ON public.liked_posts FOR EACH ROW EXECUTE FUNCTION public.increment_post_like_counter();


--
-- TOC entry 3163 (class 2620 OID 617278)
-- Name: comments del_update_sharded_comments; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER del_update_sharded_comments AFTER DELETE ON public.comments FOR EACH ROW EXECUTE FUNCTION public.del_update_sharded_comments();


--
-- TOC entry 3166 (class 2620 OID 617279)
-- Name: liked_comments del_update_sharded_liked_comments; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER del_update_sharded_liked_comments AFTER DELETE ON public.liked_comments FOR EACH ROW EXECUTE FUNCTION public.del_update_sharded_liked_comments();


--
-- TOC entry 3170 (class 2620 OID 617280)
-- Name: liked_posts del_update_sharded_liked_posts; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER del_update_sharded_liked_posts AFTER DELETE ON public.liked_posts FOR EACH ROW EXECUTE FUNCTION public.del_update_sharded_liked_posts();


--
-- TOC entry 3173 (class 2620 OID 617281)
-- Name: posts del_update_sharded_posts; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER del_update_sharded_posts AFTER DELETE ON public.posts FOR EACH ROW EXECUTE FUNCTION public.del_update_sharded_posts();


--
-- TOC entry 3167 (class 2620 OID 617282)
-- Name: liked_comments subtract_from_comment_like; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER subtract_from_comment_like AFTER DELETE ON public.liked_comments FOR EACH ROW EXECUTE FUNCTION public.decrement_comment_like_counter();


--
-- TOC entry 3171 (class 2620 OID 617283)
-- Name: liked_posts subtract_from_post_like; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER subtract_from_post_like AFTER DELETE ON public.liked_posts FOR EACH ROW EXECUTE FUNCTION public.decrement_post_like_counter();


--
-- TOC entry 3164 (class 2620 OID 617284)
-- Name: comments update_sharded_comments; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_sharded_comments AFTER INSERT OR UPDATE ON public.comments FOR EACH ROW EXECUTE FUNCTION public.update_sharded_comments();


--
-- TOC entry 3168 (class 2620 OID 617285)
-- Name: liked_comments update_sharded_liked_comments; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_sharded_liked_comments AFTER INSERT ON public.liked_comments FOR EACH ROW EXECUTE FUNCTION public.update_sharded_liked_comments();


--
-- TOC entry 3172 (class 2620 OID 617286)
-- Name: liked_posts update_sharded_liked_posts; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_sharded_liked_posts AFTER INSERT ON public.liked_posts FOR EACH ROW EXECUTE FUNCTION public.update_sharded_liked_posts();


--
-- TOC entry 3174 (class 2620 OID 617287)
-- Name: posts update_sharded_posts; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_sharded_posts AFTER INSERT OR UPDATE ON public.posts FOR EACH ROW EXECUTE FUNCTION public.update_sharded_posts();


--
-- TOC entry 3152 (class 2606 OID 617288)
-- Name: comments comments_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3153 (class 2606 OID 617293)
-- Name: comments comments_poster_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_poster_id_fkey FOREIGN KEY (poster_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3154 (class 2606 OID 617298)
-- Name: liked_comments liked_comments_comment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.liked_comments
    ADD CONSTRAINT liked_comments_comment_id_fkey FOREIGN KEY (comment_id) REFERENCES public.comments(comment_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3155 (class 2606 OID 617303)
-- Name: liked_comments liked_comments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.liked_comments
    ADD CONSTRAINT liked_comments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3156 (class 2606 OID 617308)
-- Name: liked_posts liked_posts_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.liked_posts
    ADD CONSTRAINT liked_posts_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3157 (class 2606 OID 617313)
-- Name: liked_posts liked_posts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.liked_posts
    ADD CONSTRAINT liked_posts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3159 (class 2606 OID 617318)
-- Name: sharded_comments sharded_comments_poster_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.sharded_comments
    ADD CONSTRAINT sharded_comments_poster_id_fkey FOREIGN KEY (poster_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3160 (class 2606 OID 617321)
-- Name: sharded_liked_comments sharded_liked_comments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.sharded_liked_comments
    ADD CONSTRAINT sharded_liked_comments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3161 (class 2606 OID 617324)
-- Name: sharded_liked_posts sharded_liked_posts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.sharded_liked_posts
    ADD CONSTRAINT sharded_liked_posts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3162 (class 2606 OID 617327)
-- Name: sharded_posts sharded_posts_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.sharded_posts
    ADD CONSTRAINT sharded_posts_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3158 (class 2606 OID 617330)
-- Name: posts user_foreign_key; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT user_foreign_key FOREIGN KEY (owner_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2020-07-01 13:44:06 EDT

--
-- PostgreSQL database dump complete
--

