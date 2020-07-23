--
-- PostgreSQL database dump
--

-- Dumped from database version 12.3
-- Dumped by pg_dump version 12.3

-- Started on 2020-07-21 13:19:04 EDT

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
-- TOC entry 3 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 3278 (class 0 OID 0)
-- Dependencies: 3
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 224 (class 1255 OID 1007232)
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
-- TOC entry 225 (class 1255 OID 1007233)
-- Name: create_user(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_user(username_value character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
   insert into users ( username , date_of_creation ) values ($1, now());
  	--currval is threadsafe since it's session specific (https://dba.stackexchange.com/questions/3281/how-do-i-use-currval-in-postgresql-to-get-the-last-inserted-id/3284)
   insert into user_shards (user_id ) values (currval('users_id_seq'));
END;
$_$;


ALTER FUNCTION public.create_user(username_value character varying) OWNER TO postgres;

--
-- TOC entry 226 (class 1255 OID 1007234)
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
-- TOC entry 227 (class 1255 OID 1007235)
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
-- TOC entry 228 (class 1255 OID 1007236)
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
-- TOC entry 229 (class 1255 OID 1007237)
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
-- TOC entry 230 (class 1255 OID 1007238)
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
-- TOC entry 231 (class 1255 OID 1007239)
-- Name: insert_record_into_jsonb(text, jsonb, jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insert_record_into_jsonb(keyname text, row_jsonb jsonb, target_jsonb jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $_$
begin
	--This function used to just take in the record itself and turn it into a jsonb inhouse,
	--but it ran into this problem:
	--https://dba.stackexchange.com/questions/8119/function-performance/8189#8189
	--About record data type: --https://www.postgresql.org/docs/current/plpgsql-declarations.html#PLPGSQL-DECLARATION-ROWTYPES
	RETURN jsonb_set($3, string_to_array($1, ',') , row_jsonb ,true);
END;
$_$;


ALTER FUNCTION public.insert_record_into_jsonb(keyname text, row_jsonb jsonb, target_jsonb jsonb) OWNER TO postgres;

--
-- TOC entry 232 (class 1255 OID 1007240)
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
-- TOC entry 233 (class 1255 OID 1007241)
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
-- TOC entry 234 (class 1255 OID 1007242)
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
-- TOC entry 235 (class 1255 OID 1007243)
-- Name: record_comment(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.record_comment() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare 
	keyname text := '';
BEGIN
	keyname := 'comment ' || new.comment_id;
	update user_shards set shard = insert_record_into_jsonb(keyname, to_jsonb(new) , shard) where user_id  = new.poster_id;
	RETURN NEW;
END;
$$;


ALTER FUNCTION public.record_comment() OWNER TO postgres;

--
-- TOC entry 236 (class 1255 OID 1007244)
-- Name: record_liked_comments(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.record_liked_comments() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare 
	keyname text := '';
BEGIN
	keyname := 'liked_comment ' || new.user_id || '-' || new.comment_id ;
	update user_shards set shard = insert_record_into_jsonb(keyname, to_jsonb(new), shard) where user_id  = new.user_id;
	RETURN new;
END;
$$;


ALTER FUNCTION public.record_liked_comments() OWNER TO postgres;

--
-- TOC entry 237 (class 1255 OID 1007245)
-- Name: record_liked_post(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.record_liked_post() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare 
	keyname text := '';
BEGIN
	keyname := 'liked_post ' || new.user_id || '-' || new.post_id ;
	update user_shards set shard = insert_record_into_jsonb(keyname, to_jsonb(new), shard) where user_id  = new.user_id;
	RETURN new;
END;
$$;


ALTER FUNCTION public.record_liked_post() OWNER TO postgres;

--
-- TOC entry 238 (class 1255 OID 1007246)
-- Name: record_post(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.record_post() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare 
	keyname text := '';
BEGIN
	keyname := 'post ' || new.id;
	update user_shards set shard = insert_record_into_jsonb(keyname, to_jsonb(new), shard) where user_id  = new.owner_id;
	RETURN NEW;
END;
$$;


ALTER FUNCTION public.record_post() OWNER TO postgres;

--
-- TOC entry 239 (class 1255 OID 1007247)
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
-- TOC entry 240 (class 1255 OID 1007248)
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
-- TOC entry 202 (class 1259 OID 1007249)
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
-- TOC entry 203 (class 1259 OID 1007255)
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
-- TOC entry 3279 (class 0 OID 0)
-- Dependencies: 203
-- Name: comments_comment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.comments_comment_id_seq OWNED BY public.comments.comment_id;


--
-- TOC entry 204 (class 1259 OID 1007257)
-- Name: liked_comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.liked_comments (
    user_id integer NOT NULL,
    comment_id integer NOT NULL
);


ALTER TABLE public.liked_comments OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 1007260)
-- Name: liked_posts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.liked_posts (
    user_id integer NOT NULL,
    post_id integer NOT NULL
);


ALTER TABLE public.liked_posts OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 1007263)
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
-- TOC entry 207 (class 1259 OID 1007269)
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
-- TOC entry 3280 (class 0 OID 0)
-- Dependencies: 207
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;


--
-- TOC entry 208 (class 1259 OID 1007271)
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
-- TOC entry 209 (class 1259 OID 1007275)
-- Name: user_shards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_shards (
    user_id integer NOT NULL,
    shard jsonb DEFAULT '{}'::jsonb NOT NULL
);


ALTER TABLE public.user_shards OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 1007282)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying NOT NULL,
    date_of_creation timestamp without time zone NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 1007288)
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
-- TOC entry 3281 (class 0 OID 0)
-- Dependencies: 211
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 3108 (class 2604 OID 1007290)
-- Name: comments comment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments ALTER COLUMN comment_id SET DEFAULT nextval('public.comments_comment_id_seq'::regclass);


--
-- TOC entry 3109 (class 2604 OID 1007291)
-- Name: posts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);


--
-- TOC entry 3111 (class 2604 OID 1007292)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 3264 (class 0 OID 1007249)
-- Dependencies: 202
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comments (comment_id, content, date_of_creation, likes, post_id, poster_id) FROM stdin;
\.


--
-- TOC entry 3266 (class 0 OID 1007257)
-- Dependencies: 204
-- Data for Name: liked_comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.liked_comments (user_id, comment_id) FROM stdin;
\.


--
-- TOC entry 3267 (class 0 OID 1007260)
-- Dependencies: 205
-- Data for Name: liked_posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.liked_posts (user_id, post_id) FROM stdin;
\.


--
-- TOC entry 3268 (class 0 OID 1007263)
-- Dependencies: 206
-- Data for Name: posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.posts (id, owner_id, content, likes, date_of_creation) FROM stdin;
\.


--
-- TOC entry 3270 (class 0 OID 1007275)
-- Dependencies: 209
-- Data for Name: user_shards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_shards (user_id, shard) FROM stdin;
\.


--
-- TOC entry 3271 (class 0 OID 1007282)
-- Dependencies: 210
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, date_of_creation) FROM stdin;
\.


--
-- TOC entry 3282 (class 0 OID 0)
-- Dependencies: 203
-- Name: comments_comment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comments_comment_id_seq', 1, false);


--
-- TOC entry 3283 (class 0 OID 0)
-- Dependencies: 207
-- Name: posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.posts_id_seq', 1, false);


--
-- TOC entry 3284 (class 0 OID 0)
-- Dependencies: 211
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- TOC entry 3113 (class 2606 OID 1007294)
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (comment_id);


--
-- TOC entry 3117 (class 2606 OID 1007296)
-- Name: liked_comments liked_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.liked_comments
    ADD CONSTRAINT liked_comments_pkey PRIMARY KEY (user_id, comment_id);


--
-- TOC entry 3119 (class 2606 OID 1007298)
-- Name: liked_posts liked_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.liked_posts
    ADD CONSTRAINT liked_posts_pkey PRIMARY KEY (user_id, post_id);


--
-- TOC entry 3123 (class 2606 OID 1007300)
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- TOC entry 3126 (class 2606 OID 1007302)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3114 (class 1259 OID 1007326)
-- Name: comments_post_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX comments_post_id_idx ON public.comments USING btree (post_id);


--
-- TOC entry 3115 (class 1259 OID 1007327)
-- Name: comments_poster_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX comments_poster_id_idx ON public.comments USING btree (poster_id);


--
-- TOC entry 3120 (class 1259 OID 1007305)
-- Name: like_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX like_index ON public.posts USING btree (likes);


--
-- TOC entry 3121 (class 1259 OID 1007328)
-- Name: posts_owner_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX posts_owner_id_idx ON public.posts USING btree (owner_id);


--
-- TOC entry 3124 (class 1259 OID 1007329)
-- Name: user_shards_user_id_idx1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_shards_user_id_idx1 ON public.user_shards USING btree (user_id);


--
-- TOC entry 3130 (class 2620 OID 1007308)
-- Name: liked_comments add_to_comment_like; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER add_to_comment_like AFTER INSERT ON public.liked_comments FOR EACH ROW EXECUTE FUNCTION public.increment_comment_like_counter();


--
-- TOC entry 3133 (class 2620 OID 1007309)
-- Name: liked_posts add_to_post_like; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER add_to_post_like AFTER INSERT ON public.liked_posts FOR EACH ROW EXECUTE FUNCTION public.increment_post_like_counter();


--
-- TOC entry 3129 (class 2620 OID 1007310)
-- Name: comments record_comment_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER record_comment_trigger AFTER INSERT OR UPDATE ON public.comments FOR EACH ROW EXECUTE FUNCTION public.record_comment();


--
-- TOC entry 3131 (class 2620 OID 1007311)
-- Name: liked_comments record_liked_comment_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER record_liked_comment_trigger AFTER INSERT OR UPDATE ON public.liked_comments FOR EACH ROW EXECUTE FUNCTION public.record_liked_comments();


--
-- TOC entry 3134 (class 2620 OID 1007312)
-- Name: liked_posts record_liked_commentt_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER record_liked_commentt_trigger AFTER INSERT OR UPDATE ON public.liked_posts FOR EACH ROW EXECUTE FUNCTION public.record_liked_post();


--
-- TOC entry 3136 (class 2620 OID 1007313)
-- Name: posts record_post_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER record_post_trigger AFTER INSERT OR UPDATE ON public.posts FOR EACH ROW EXECUTE FUNCTION public.record_post();


--
-- TOC entry 3132 (class 2620 OID 1007314)
-- Name: liked_comments subtract_from_comment_like; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER subtract_from_comment_like AFTER DELETE ON public.liked_comments FOR EACH ROW EXECUTE FUNCTION public.decrement_comment_like_counter();


--
-- TOC entry 3135 (class 2620 OID 1007315)
-- Name: liked_posts subtract_from_post_like; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER subtract_from_post_like AFTER DELETE ON public.liked_posts FOR EACH ROW EXECUTE FUNCTION public.decrement_post_like_counter();


--
-- TOC entry 3127 (class 2606 OID 1007316)
-- Name: liked_posts liked_posts_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.liked_posts
    ADD CONSTRAINT liked_posts_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3128 (class 2606 OID 1007321)
-- Name: liked_posts liked_posts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.liked_posts
    ADD CONSTRAINT liked_posts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2020-07-21 13:19:04 EDT

--
-- PostgreSQL database dump complete
--

