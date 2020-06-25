--
-- PostgreSQL database dump
--

-- Dumped from database version 12.3
-- Dumped by pg_dump version 12.3

-- Started on 2020-06-25 12:15:37 EDT

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
-- TOC entry 3 (class 2615 OID 19537)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 3269 (class 0 OID 0)
-- Dependencies: 3
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 7 (class 2615 OID 19538)
-- Name: shards; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA shards;


ALTER SCHEMA shards OWNER TO postgres;

--
-- TOC entry 228 (class 1255 OID 19539)
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
-- TOC entry 225 (class 1255 OID 19540)
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
   q := format('CREATE TABLE shards.%I PARTITION OF "comments"', 'comments_' || cast(counter as TEXT));
  q:= q || format(' FOR VALUES IN (%L)', counter);
   RAISE NOTICE 'Creating comments partition: %', q;
   EXECUTE q;
  
  --Making the shards table for posts
     q := format('CREATE TABLE shards.%I PARTITION OF "posts"', 'posts_' || cast(counter as TEXT));
  q:= q || format(' FOR VALUES IN (%L)', counter);
   RAISE NOTICE 'Creating posts partition: %', q;
   EXECUTE q;
  
    --Making the shards table for liked_posts
     q := format('CREATE TABLE shards.%I PARTITION OF "liked_posts"', 'liked_posts_' || cast(counter as TEXT));
  q:= q || format(' FOR VALUES IN (%L)', counter);
   RAISE NOTICE 'Creating liked posts partition: %', q;
   EXECUTE q;
  
    --Making the shards table for liked_comments
     q := format('CREATE TABLE shards.%I PARTITION OF "liked_comments"', 'liked_comments_' || cast(counter as TEXT));
  q:= q || format(' FOR VALUES IN (%L)', counter);
   RAISE NOTICE 'Creating liked comments partition: %', q;
   EXECUTE q;
END;
$_$;


ALTER FUNCTION public.create_user(username_value character varying) OWNER TO postgres;

--
-- TOC entry 226 (class 1255 OID 19541)
-- Name: decrement_comment_like_counter(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.decrement_comment_like_counter() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE comments 
    SET likes = coalesce(likes, 0) - 1
    WHERE comment_id = old.comment_id and poster_id = (select owner_id from public.comments_lookup cl where cl.comment_id = old.comment_id);
return new;

END;
$$;


ALTER FUNCTION public.decrement_comment_like_counter() OWNER TO postgres;

--
-- TOC entry 227 (class 1255 OID 19542)
-- Name: decrement_post_like_counter(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.decrement_post_like_counter() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE posts 
    SET likes = coalesce(likes, 0) - 1
    WHERE owner_id = (select owner_id from public.posts_lookup pl where pl.post_id = old.post_id) and id = old.post_id;
return new;

END;
$$;


ALTER FUNCTION public.decrement_post_like_counter() OWNER TO postgres;

--
-- TOC entry 229 (class 1255 OID 19543)
-- Name: increment_comment_like_counter(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.increment_comment_like_counter() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE comments 
    SET likes = coalesce(likes, 0) + 1
    WHERE comment_id = new.comment_id and poster_id = (select owner_id from public.comments_lookup cl where cl.comment_id = new.comment_id);
return new;

END;
$$;


ALTER FUNCTION public.increment_comment_like_counter() OWNER TO postgres;

--
-- TOC entry 230 (class 1255 OID 19544)
-- Name: increment_post_like_counter(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.increment_post_like_counter() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE posts 
    SET likes = coalesce(likes, 0) + 1
    WHERE owner_id = (select owner_id from public.posts_lookup pl where pl.post_id = new.post_id) and id = new.post_id;
return new;

END;
$$;


ALTER FUNCTION public.increment_post_like_counter() OWNER TO postgres;

--
-- TOC entry 231 (class 1255 OID 19545)
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
-- TOC entry 232 (class 1255 OID 19546)
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
-- TOC entry 233 (class 1255 OID 19547)
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
-- TOC entry 234 (class 1255 OID 19548)
-- Name: unlike_comment(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.unlike_comment(user_id integer, comment_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
    delete from liked_comments 
	where liked_comments.comment_id = $2 and liked_comments.user_id = $1;
END;
$_$;


ALTER FUNCTION public.unlike_comment(user_id integer, comment_id integer) OWNER TO postgres;

--
-- TOC entry 235 (class 1255 OID 19549)
-- Name: unlike_post(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.unlike_post(user_id integer, post_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
    delete from liked_posts 
	where  liked_posts.owner_id = (select owner_id from public.posts_lookup p where p.post_id = $2) and liked_posts.post_id = $2 and liked_posts.user_id = $1;
END;
$_$;


ALTER FUNCTION public.unlike_post(user_id integer, post_id integer) OWNER TO postgres;

--
-- TOC entry 236 (class 1255 OID 19550)
-- Name: update_comment_lookup(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_comment_lookup() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    insert into comments_lookup values (new.comment_id, new.poster_id);
return new;

END;
$$;


ALTER FUNCTION public.update_comment_lookup() OWNER TO postgres;

--
-- TOC entry 237 (class 1255 OID 19551)
-- Name: update_posts_lookup(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_posts_lookup() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    insert into public.posts_lookup values (new.id, new.owner_id);
return new;

END;
$$;


ALTER FUNCTION public.update_posts_lookup() OWNER TO postgres;

SET default_tablespace = '';

--
-- TOC entry 203 (class 1259 OID 19552)
-- Name: comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comments (
    comment_id integer NOT NULL,
    content character varying NOT NULL,
    date_of_creation timestamp without time zone NOT NULL,
    likes integer,
    post_id integer,
    poster_id integer NOT NULL
)
PARTITION BY LIST (poster_id);


ALTER TABLE public.comments OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 19555)
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
-- TOC entry 3270 (class 0 OID 0)
-- Dependencies: 204
-- Name: comments_comment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.comments_comment_id_seq OWNED BY public.comments.comment_id;


SET default_table_access_method = heap;

--
-- TOC entry 205 (class 1259 OID 19557)
-- Name: comments_lookup; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comments_lookup (
    comment_id integer,
    owner_id integer
);


ALTER TABLE public.comments_lookup OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 19560)
-- Name: liked_comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.liked_comments (
    user_id integer NOT NULL,
    comment_id integer NOT NULL
)
PARTITION BY LIST (user_id);


ALTER TABLE public.liked_comments OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 19563)
-- Name: liked_posts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.liked_posts (
    user_id integer NOT NULL,
    post_id integer NOT NULL
)
PARTITION BY LIST (user_id);


ALTER TABLE public.liked_posts OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 19566)
-- Name: posts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.posts (
    id integer NOT NULL,
    owner_id integer NOT NULL,
    content character varying NOT NULL,
    likes integer,
    date_of_creation timestamp without time zone NOT NULL
)
PARTITION BY LIST (owner_id);


ALTER TABLE public.posts OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 19569)
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
-- TOC entry 3271 (class 0 OID 0)
-- Dependencies: 209
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;


--
-- TOC entry 210 (class 1259 OID 19571)
-- Name: posts_lookup; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.posts_lookup (
    post_id integer,
    owner_id integer
);


ALTER TABLE public.posts_lookup OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 19574)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying NOT NULL,
    date_of_creation timestamp without time zone NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 19580)
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
-- TOC entry 3272 (class 0 OID 0)
-- Dependencies: 212
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 3102 (class 2604 OID 19582)
-- Name: comments comment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments ALTER COLUMN comment_id SET DEFAULT nextval('public.comments_comment_id_seq'::regclass);


--
-- TOC entry 3103 (class 2604 OID 19583)
-- Name: posts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);


--
-- TOC entry 3104 (class 2604 OID 19584)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 3259 (class 0 OID 19557)
-- Dependencies: 205
-- Data for Name: comments_lookup; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comments_lookup (comment_id, owner_id) FROM stdin;
\.


--
-- TOC entry 3261 (class 0 OID 19571)
-- Dependencies: 210
-- Data for Name: posts_lookup; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.posts_lookup (post_id, owner_id) FROM stdin;
\.


--
-- TOC entry 3262 (class 0 OID 19574)
-- Dependencies: 211
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, date_of_creation) FROM stdin;
\.


--
-- TOC entry 3273 (class 0 OID 0)
-- Dependencies: 204
-- Name: comments_comment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comments_comment_id_seq', 1, false);


--
-- TOC entry 3274 (class 0 OID 0)
-- Dependencies: 209
-- Name: posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.posts_id_seq', 3, true);


--
-- TOC entry 3275 (class 0 OID 0)
-- Dependencies: 212
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 20, true);


--
-- TOC entry 3106 (class 2606 OID 19586)
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (poster_id, date_of_creation);


--
-- TOC entry 3111 (class 2606 OID 19588)
-- Name: liked_comments liked_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.liked_comments
    ADD CONSTRAINT liked_comments_pkey PRIMARY KEY (user_id, comment_id);


--
-- TOC entry 3113 (class 2606 OID 19590)
-- Name: liked_posts liked_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.liked_posts
    ADD CONSTRAINT liked_posts_pkey PRIMARY KEY (user_id, post_id);


--
-- TOC entry 3116 (class 2606 OID 19592)
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id, owner_id);


--
-- TOC entry 3119 (class 2606 OID 19594)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3108 (class 1259 OID 19595)
-- Name: comment_lookup_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX comment_lookup_index ON public.comments_lookup USING hash (owner_id);


--
-- TOC entry 3107 (class 1259 OID 19596)
-- Name: comments_post_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX comments_post_id ON ONLY public.comments USING btree (post_id);


--
-- TOC entry 3109 (class 1259 OID 19597)
-- Name: liked_comments_comment_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX liked_comments_comment_id ON ONLY public.liked_comments USING btree (comment_id);


--
-- TOC entry 3114 (class 1259 OID 19598)
-- Name: liked_posts_post_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX liked_posts_post_id ON ONLY public.liked_posts USING btree (post_id);


--
-- TOC entry 3117 (class 1259 OID 19599)
-- Name: posts_lookup_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX posts_lookup_index ON public.posts_lookup USING hash (owner_id);


--
-- TOC entry 3127 (class 2620 OID 19600)
-- Name: liked_comments add_to_comment_like; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER add_to_comment_like AFTER INSERT ON public.liked_comments FOR EACH ROW EXECUTE FUNCTION public.increment_comment_like_counter();


--
-- TOC entry 3129 (class 2620 OID 19601)
-- Name: liked_posts add_to_post_like; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER add_to_post_like AFTER INSERT ON public.liked_posts FOR EACH ROW EXECUTE FUNCTION public.increment_post_like_counter();


--
-- TOC entry 3128 (class 2620 OID 19602)
-- Name: liked_comments subtract_from_comment_like; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER subtract_from_comment_like AFTER DELETE ON public.liked_comments FOR EACH ROW EXECUTE FUNCTION public.decrement_comment_like_counter();


--
-- TOC entry 3130 (class 2620 OID 19603)
-- Name: liked_posts subtract_from_post_like; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER subtract_from_post_like AFTER DELETE ON public.liked_posts FOR EACH ROW EXECUTE FUNCTION public.decrement_post_like_counter();


--
-- TOC entry 3126 (class 2620 OID 19604)
-- Name: comments update_comments_lookup_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_comments_lookup_trigger AFTER INSERT ON public.comments FOR EACH ROW EXECUTE FUNCTION public.update_comment_lookup();


--
-- TOC entry 3131 (class 2620 OID 19605)
-- Name: posts update_posts_lookup_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_posts_lookup_trigger AFTER INSERT ON public.posts FOR EACH ROW EXECUTE FUNCTION public.update_posts_lookup();


--
-- TOC entry 3121 (class 2606 OID 19606)
-- Name: comments_lookup comments_lookup_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments_lookup
    ADD CONSTRAINT comments_lookup_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3120 (class 2606 OID 19611)
-- Name: comments comments_poster_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.comments
    ADD CONSTRAINT comments_poster_id_fkey FOREIGN KEY (poster_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3122 (class 2606 OID 19614)
-- Name: liked_comments liked_comments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.liked_comments
    ADD CONSTRAINT liked_comments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3123 (class 2606 OID 19617)
-- Name: liked_posts liked_posts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.liked_posts
    ADD CONSTRAINT liked_posts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3125 (class 2606 OID 19620)
-- Name: posts_lookup posts_lookup_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts_lookup
    ADD CONSTRAINT posts_lookup_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3124 (class 2606 OID 19625)
-- Name: posts posts_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.posts
    ADD CONSTRAINT posts_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2020-06-25 12:15:38 EDT

--
-- PostgreSQL database dump complete
--

