--
-- PostgreSQL database dump
--

-- Dumped from database version 12.3
-- Dumped by pg_dump version 12.3

-- Started on 2020-07-21 12:55:58 EDT

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
-- TOC entry 6 (class 2615 OID 1005638)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 3373 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 283 (class 1255 OID 1005884)
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
-- TOC entry 284 (class 1255 OID 1005885)
-- Name: create_user(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_user(username_value character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
   insert into users ( username , date_of_creation ) values ($1, now());
  	--currval is threadsafe since it's session specific (https://dba.stackexchange.com/questions/3281/how-do-i-use-currval-in-postgresql-to-get-the-last-inserted-id/3284)
   insert into user_shards (user_id , shard ) values (currval('users_id_seq'), hstore(''));
END;
$_$;


ALTER FUNCTION public.create_user(username_value character varying) OWNER TO postgres;

--
-- TOC entry 285 (class 1255 OID 1005886)
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
-- TOC entry 286 (class 1255 OID 1005887)
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
-- TOC entry 287 (class 1255 OID 1005888)
-- Name: get_user_shard(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_user_shard(integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$ begin
	perform * from posts p where p.owner_id  = $1;
	perform * from liked_comments lc where lc.user_id  = $1;
	perform * from liked_posts lp where lp.user_id = $1;
	perform * from "comments" c where c.poster_id = $1;
end;$_$;


ALTER FUNCTION public.get_user_shard(integer) OWNER TO postgres;

--
-- TOC entry 288 (class 1255 OID 1005889)
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
-- TOC entry 289 (class 1255 OID 1005890)
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
-- TOC entry 290 (class 1255 OID 1005891)
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
-- TOC entry 291 (class 1255 OID 1005892)
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
-- TOC entry 292 (class 1255 OID 1005893)
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
-- TOC entry 298 (class 1255 OID 1005894)
-- Name: record_comment(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.record_comment() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare 
	keyname text := '';
	value text := '';
BEGIN
	value := record_to_text(hstore(new));
	keyname := 'comment ' || new.comment_id;
	update user_shards set shard = shard  || hstore(keyname , value) where user_id  = new.poster_id;
	RETURN NEW;
END;
$$;


ALTER FUNCTION public.record_comment() OWNER TO postgres;

--
-- TOC entry 299 (class 1255 OID 1005895)
-- Name: record_liked_comments(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.record_liked_comments() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare 
	keyname text := '';
	value text := '';
BEGIN
	value := record_to_text(hstore(new));
	keyname := 'liked_comment ' || new.user_id || '-' || new.comment_id ;
	update user_shards set shard = shard  || hstore(keyname , value) where user_id  = new.user_id;
	RETURN new;
END;
$$;


ALTER FUNCTION public.record_liked_comments() OWNER TO postgres;

--
-- TOC entry 296 (class 1255 OID 1005896)
-- Name: record_liked_post(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.record_liked_post() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare 
	keyname text := '';
	value text := '';
BEGIN
	value := record_to_text(hstore(new));
	keyname := 'liked_post ' || new.user_id || '-' || new.post_id ;
	update user_shards set shard = shard  || hstore(keyname , value) where user_id  = new.user_id;
	RETURN new;
END;
$$;


ALTER FUNCTION public.record_liked_post() OWNER TO postgres;

--
-- TOC entry 297 (class 1255 OID 1005897)
-- Name: record_post(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.record_post() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare 
	keyname text := '';
	value text := '';
BEGIN
	value := record_to_text(hstore(new));
	keyname := 'post ' || new.id;
	update user_shards set shard = shard  || hstore(keyname , value) where user_id  = new.owner_id;
	RETURN NEW;
END;
$$;


ALTER FUNCTION public.record_post() OWNER TO postgres;

--
-- TOC entry 295 (class 1255 OID 1006083)
-- Name: record_to_text(public.hstore); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.record_to_text(row_hstore public.hstore) RETURNS text
    LANGUAGE plpgsql
    AS $$
begin
	--Stringification to try
	--https://cwestblog.com/2011/07/14/postgresql-converting-rows-into-a-string/
	--https://stackoverflow.com/questions/31754682/postgres-aggregate-row-to-string
	--https://stackoverflow.com/questions/24852311/how-to-convert-a-fetch-row-to-a-single-string-in-postgresql
	
	--This function used to jsut take in the row itself and turn it into an  hstore inhouse,
	--but it ran into this problem:
	--https://dba.stackexchange.com/questions/8119/function-performance/8189#8189
	--About record data type: --https://www.postgresql.org/docs/current/plpgsql-declarations.html#PLPGSQL-DECLARATION-ROWTYPES
	RETURN array_to_string(avals(row_hstore), ', ');
END;
$$;


ALTER FUNCTION public.record_to_text(row_hstore public.hstore) OWNER TO postgres;

--
-- TOC entry 293 (class 1255 OID 1005899)
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
-- TOC entry 294 (class 1255 OID 1005900)
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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 203 (class 1259 OID 1005901)
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
-- TOC entry 204 (class 1259 OID 1005907)
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
-- TOC entry 3374 (class 0 OID 0)
-- Dependencies: 204
-- Name: comments_comment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.comments_comment_id_seq OWNED BY public.comments.comment_id;


--
-- TOC entry 205 (class 1259 OID 1005909)
-- Name: liked_comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.liked_comments (
    user_id integer NOT NULL,
    comment_id integer NOT NULL
);


ALTER TABLE public.liked_comments OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 1005912)
-- Name: liked_posts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.liked_posts (
    user_id integer NOT NULL,
    post_id integer NOT NULL
);


ALTER TABLE public.liked_posts OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 1005915)
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
-- TOC entry 208 (class 1259 OID 1005921)
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
-- TOC entry 3375 (class 0 OID 0)
-- Dependencies: 208
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;


--
-- TOC entry 209 (class 1259 OID 1005923)
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
-- TOC entry 210 (class 1259 OID 1005927)
-- Name: user_shards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_shards (
    user_id integer NOT NULL,
    shard public.hstore
);


ALTER TABLE public.user_shards OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 1005933)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying NOT NULL,
    date_of_creation timestamp without time zone NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 1005939)
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
-- TOC entry 3376 (class 0 OID 0)
-- Dependencies: 212
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 3206 (class 2604 OID 1005941)
-- Name: comments comment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments ALTER COLUMN comment_id SET DEFAULT nextval('public.comments_comment_id_seq'::regclass);


--
-- TOC entry 3207 (class 2604 OID 1005942)
-- Name: posts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);


--
-- TOC entry 3208 (class 2604 OID 1005943)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 3359 (class 0 OID 1005901)
-- Dependencies: 203
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comments (comment_id, content, date_of_creation, likes, post_id, poster_id) FROM stdin;
\.


--
-- TOC entry 3361 (class 0 OID 1005909)
-- Dependencies: 205
-- Data for Name: liked_comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.liked_comments (user_id, comment_id) FROM stdin;
\.


--
-- TOC entry 3362 (class 0 OID 1005912)
-- Dependencies: 206
-- Data for Name: liked_posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.liked_posts (user_id, post_id) FROM stdin;
\.


--
-- TOC entry 3363 (class 0 OID 1005915)
-- Dependencies: 207
-- Data for Name: posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.posts (id, owner_id, content, likes, date_of_creation) FROM stdin;
\.


--
-- TOC entry 3365 (class 0 OID 1005927)
-- Dependencies: 210
-- Data for Name: user_shards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_shards (user_id, shard) FROM stdin;
\.


--
-- TOC entry 3366 (class 0 OID 1005933)
-- Dependencies: 211
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, date_of_creation) FROM stdin;
\.


--
-- TOC entry 3377 (class 0 OID 0)
-- Dependencies: 204
-- Name: comments_comment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comments_comment_id_seq', 1, false);


--
-- TOC entry 3378 (class 0 OID 0)
-- Dependencies: 208
-- Name: posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.posts_id_seq', 1, false);


--
-- TOC entry 3379 (class 0 OID 0)
-- Dependencies: 212
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- TOC entry 3210 (class 2606 OID 1005945)
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (comment_id);


--
-- TOC entry 3214 (class 2606 OID 1005947)
-- Name: liked_comments liked_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.liked_comments
    ADD CONSTRAINT liked_comments_pkey PRIMARY KEY (user_id, comment_id);


--
-- TOC entry 3216 (class 2606 OID 1005949)
-- Name: liked_posts liked_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.liked_posts
    ADD CONSTRAINT liked_posts_pkey PRIMARY KEY (user_id, post_id);


--
-- TOC entry 3220 (class 2606 OID 1005951)
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- TOC entry 3223 (class 2606 OID 1005953)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3211 (class 1259 OID 1006832)
-- Name: comments_post_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX comments_post_id_idx ON public.comments USING brin (post_id);


--
-- TOC entry 3212 (class 1259 OID 1006833)
-- Name: comments_poster_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX comments_poster_id_idx ON public.comments USING brin (poster_id);


--
-- TOC entry 3217 (class 1259 OID 1005956)
-- Name: like_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX like_index ON public.posts USING btree (likes);


--
-- TOC entry 3218 (class 1259 OID 1006834)
-- Name: posts_owner_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX posts_owner_id_idx ON public.posts USING brin (owner_id);


--
-- TOC entry 3221 (class 1259 OID 1006835)
-- Name: user_shards_user_id_idx1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_shards_user_id_idx1 ON public.user_shards USING brin (user_id);


--
-- TOC entry 3225 (class 2620 OID 1005959)
-- Name: liked_comments add_to_comment_like; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER add_to_comment_like AFTER INSERT ON public.liked_comments FOR EACH ROW EXECUTE FUNCTION public.increment_comment_like_counter();


--
-- TOC entry 3228 (class 2620 OID 1005960)
-- Name: liked_posts add_to_post_like; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER add_to_post_like AFTER INSERT ON public.liked_posts FOR EACH ROW EXECUTE FUNCTION public.increment_post_like_counter();


--
-- TOC entry 3224 (class 2620 OID 1005961)
-- Name: comments record_comment_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER record_comment_trigger AFTER INSERT OR UPDATE ON public.comments FOR EACH ROW EXECUTE FUNCTION public.record_comment();


--
-- TOC entry 3226 (class 2620 OID 1005962)
-- Name: liked_comments record_liked_comment_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER record_liked_comment_trigger AFTER INSERT OR UPDATE ON public.liked_comments FOR EACH ROW EXECUTE FUNCTION public.record_liked_comments();


--
-- TOC entry 3229 (class 2620 OID 1005963)
-- Name: liked_posts record_liked_commentt_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER record_liked_commentt_trigger AFTER INSERT OR UPDATE ON public.liked_posts FOR EACH ROW EXECUTE FUNCTION public.record_liked_post();


--
-- TOC entry 3231 (class 2620 OID 1005964)
-- Name: posts record_post_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER record_post_trigger AFTER INSERT OR UPDATE ON public.posts FOR EACH ROW EXECUTE FUNCTION public.record_post();


--
-- TOC entry 3227 (class 2620 OID 1005965)
-- Name: liked_comments subtract_from_comment_like; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER subtract_from_comment_like AFTER DELETE ON public.liked_comments FOR EACH ROW EXECUTE FUNCTION public.decrement_comment_like_counter();


--
-- TOC entry 3230 (class 2620 OID 1005966)
-- Name: liked_posts subtract_from_post_like; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER subtract_from_post_like AFTER DELETE ON public.liked_posts FOR EACH ROW EXECUTE FUNCTION public.decrement_post_like_counter();


-- Completed on 2020-07-21 12:55:59 EDT

--
-- PostgreSQL database dump complete
--

