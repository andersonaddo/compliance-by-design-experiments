--
-- PostgreSQL database dump
--

-- Dumped from database version 12.3
-- Dumped by pg_dump version 12.3

-- Started on 2020-07-13 15:10:23 EDT

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
-- TOC entry 3344 (class 0 OID 0)
-- Dependencies: 3
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 203 (class 1259 OID 1001940)
-- Name: games; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.games (
    gameid integer NOT NULL,
    gamename character varying,
    publishdate timestamp without time zone DEFAULT now(),
    price integer,
    description character varying,
    supplier character varying
);


ALTER TABLE public.games OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 1002131)
-- Name: games_1_brin; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.games_1_brin (
    gameid integer NOT NULL,
    gamename character varying,
    publishdate timestamp without time zone DEFAULT now(),
    price integer,
    description character varying,
    supplier character varying
);


ALTER TABLE public.games_1_brin OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 1002129)
-- Name: games_1_brin_gameid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.games_1_brin_gameid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.games_1_brin_gameid_seq OWNER TO postgres;

--
-- TOC entry 3345 (class 0 OID 0)
-- Dependencies: 220
-- Name: games_1_brin_gameid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.games_1_brin_gameid_seq OWNED BY public.games_1_brin.gameid;


--
-- TOC entry 207 (class 1259 OID 1001962)
-- Name: games_1_hash; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.games_1_hash (
    gameid integer NOT NULL,
    gamename character varying,
    publishdate timestamp without time zone DEFAULT now(),
    price integer,
    description character varying,
    supplier character varying
);


ALTER TABLE public.games_1_hash OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 1001960)
-- Name: games_1_hash_gameid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.games_1_hash_gameid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.games_1_hash_gameid_seq OWNER TO postgres;

--
-- TOC entry 3346 (class 0 OID 0)
-- Dependencies: 206
-- Name: games_1_hash_gameid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.games_1_hash_gameid_seq OWNED BY public.games_1_hash.gameid;


--
-- TOC entry 213 (class 1259 OID 1002073)
-- Name: games_1_tree; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.games_1_tree (
    gameid integer NOT NULL,
    gamename character varying,
    publishdate timestamp without time zone DEFAULT now(),
    price integer,
    description character varying,
    supplier character varying
);


ALTER TABLE public.games_1_tree OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 1002071)
-- Name: games_1_tree_gameid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.games_1_tree_gameid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.games_1_tree_gameid_seq OWNER TO postgres;

--
-- TOC entry 3347 (class 0 OID 0)
-- Dependencies: 212
-- Name: games_1_tree_gameid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.games_1_tree_gameid_seq OWNED BY public.games_1_tree.gameid;


--
-- TOC entry 223 (class 1259 OID 1002144)
-- Name: games_2_brin; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.games_2_brin (
    gameid integer NOT NULL,
    gamename character varying,
    publishdate timestamp without time zone DEFAULT now(),
    price integer,
    description character varying,
    supplier character varying
);


ALTER TABLE public.games_2_brin OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 1002142)
-- Name: games_2_brin_gameid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.games_2_brin_gameid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.games_2_brin_gameid_seq OWNER TO postgres;

--
-- TOC entry 3348 (class 0 OID 0)
-- Dependencies: 222
-- Name: games_2_brin_gameid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.games_2_brin_gameid_seq OWNED BY public.games_2_brin.gameid;


--
-- TOC entry 209 (class 1259 OID 1001999)
-- Name: games_2_hash; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.games_2_hash (
    gameid integer NOT NULL,
    gamename character varying,
    publishdate timestamp without time zone DEFAULT now(),
    price integer,
    description character varying,
    supplier character varying
);


ALTER TABLE public.games_2_hash OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 1001997)
-- Name: games_2_hash_gameid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.games_2_hash_gameid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.games_2_hash_gameid_seq OWNER TO postgres;

--
-- TOC entry 3349 (class 0 OID 0)
-- Dependencies: 208
-- Name: games_2_hash_gameid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.games_2_hash_gameid_seq OWNED BY public.games_2_hash.gameid;


--
-- TOC entry 215 (class 1259 OID 1002086)
-- Name: games_2_tree; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.games_2_tree (
    gameid integer NOT NULL,
    gamename character varying,
    publishdate timestamp without time zone DEFAULT now(),
    price integer,
    description character varying,
    supplier character varying
);


ALTER TABLE public.games_2_tree OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 1002084)
-- Name: games_2_tree_gameid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.games_2_tree_gameid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.games_2_tree_gameid_seq OWNER TO postgres;

--
-- TOC entry 3350 (class 0 OID 0)
-- Dependencies: 214
-- Name: games_2_tree_gameid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.games_2_tree_gameid_seq OWNED BY public.games_2_tree.gameid;


--
-- TOC entry 211 (class 1259 OID 1002013)
-- Name: games_3_hash; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.games_3_hash (
    gameid integer NOT NULL,
    gamename character varying,
    publishdate timestamp without time zone DEFAULT now(),
    price integer,
    description character varying,
    supplier character varying
);


ALTER TABLE public.games_3_hash OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 1002011)
-- Name: games_3_hash_gameid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.games_3_hash_gameid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.games_3_hash_gameid_seq OWNER TO postgres;

--
-- TOC entry 3351 (class 0 OID 0)
-- Dependencies: 210
-- Name: games_3_hash_gameid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.games_3_hash_gameid_seq OWNED BY public.games_3_hash.gameid;


--
-- TOC entry 217 (class 1259 OID 1002100)
-- Name: games_3_tree; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.games_3_tree (
    gameid integer NOT NULL,
    gamename character varying,
    publishdate timestamp without time zone DEFAULT now(),
    price integer,
    description character varying,
    supplier character varying
);


ALTER TABLE public.games_3_tree OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 1002098)
-- Name: games_3_tree_gameid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.games_3_tree_gameid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.games_3_tree_gameid_seq OWNER TO postgres;

--
-- TOC entry 3352 (class 0 OID 0)
-- Dependencies: 216
-- Name: games_3_tree_gameid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.games_3_tree_gameid_seq OWNED BY public.games_3_tree.gameid;


--
-- TOC entry 219 (class 1259 OID 1002115)
-- Name: games_4_tree; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.games_4_tree (
    gameid integer NOT NULL,
    gamename character varying,
    publishdate timestamp without time zone DEFAULT now(),
    price integer,
    description character varying,
    supplier character varying
);


ALTER TABLE public.games_4_tree OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 1002113)
-- Name: games_4_tree_gameid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.games_4_tree_gameid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.games_4_tree_gameid_seq OWNER TO postgres;

--
-- TOC entry 3353 (class 0 OID 0)
-- Dependencies: 218
-- Name: games_4_tree_gameid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.games_4_tree_gameid_seq OWNED BY public.games_4_tree.gameid;


--
-- TOC entry 202 (class 1259 OID 1001938)
-- Name: games_gameid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.games_gameid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.games_gameid_seq OWNER TO postgres;

--
-- TOC entry 3354 (class 0 OID 0)
-- Dependencies: 202
-- Name: games_gameid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.games_gameid_seq OWNED BY public.games.gameid;


--
-- TOC entry 205 (class 1259 OID 1001950)
-- Name: games_unique; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.games_unique (
    gameid integer NOT NULL,
    gamename character varying,
    publishdate timestamp without time zone DEFAULT now(),
    price integer,
    description character varying,
    supplier character varying
);


ALTER TABLE public.games_unique OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 1001948)
-- Name: games_unique_gameid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.games_unique_gameid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.games_unique_gameid_seq OWNER TO postgres;

--
-- TOC entry 3355 (class 0 OID 0)
-- Dependencies: 204
-- Name: games_unique_gameid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.games_unique_gameid_seq OWNED BY public.games_unique.gameid;


--
-- TOC entry 3130 (class 2604 OID 1001943)
-- Name: games gameid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.games ALTER COLUMN gameid SET DEFAULT nextval('public.games_gameid_seq'::regclass);


--
-- TOC entry 3148 (class 2604 OID 1002134)
-- Name: games_1_brin gameid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.games_1_brin ALTER COLUMN gameid SET DEFAULT nextval('public.games_1_brin_gameid_seq'::regclass);


--
-- TOC entry 3134 (class 2604 OID 1001965)
-- Name: games_1_hash gameid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.games_1_hash ALTER COLUMN gameid SET DEFAULT nextval('public.games_1_hash_gameid_seq'::regclass);


--
-- TOC entry 3140 (class 2604 OID 1002076)
-- Name: games_1_tree gameid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.games_1_tree ALTER COLUMN gameid SET DEFAULT nextval('public.games_1_tree_gameid_seq'::regclass);


--
-- TOC entry 3150 (class 2604 OID 1002147)
-- Name: games_2_brin gameid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.games_2_brin ALTER COLUMN gameid SET DEFAULT nextval('public.games_2_brin_gameid_seq'::regclass);


--
-- TOC entry 3136 (class 2604 OID 1002002)
-- Name: games_2_hash gameid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.games_2_hash ALTER COLUMN gameid SET DEFAULT nextval('public.games_2_hash_gameid_seq'::regclass);


--
-- TOC entry 3142 (class 2604 OID 1002089)
-- Name: games_2_tree gameid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.games_2_tree ALTER COLUMN gameid SET DEFAULT nextval('public.games_2_tree_gameid_seq'::regclass);


--
-- TOC entry 3138 (class 2604 OID 1002016)
-- Name: games_3_hash gameid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.games_3_hash ALTER COLUMN gameid SET DEFAULT nextval('public.games_3_hash_gameid_seq'::regclass);


--
-- TOC entry 3144 (class 2604 OID 1002103)
-- Name: games_3_tree gameid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.games_3_tree ALTER COLUMN gameid SET DEFAULT nextval('public.games_3_tree_gameid_seq'::regclass);


--
-- TOC entry 3146 (class 2604 OID 1002118)
-- Name: games_4_tree gameid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.games_4_tree ALTER COLUMN gameid SET DEFAULT nextval('public.games_4_tree_gameid_seq'::regclass);


--
-- TOC entry 3132 (class 2604 OID 1001953)
-- Name: games_unique gameid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.games_unique ALTER COLUMN gameid SET DEFAULT nextval('public.games_unique_gameid_seq'::regclass);


--
-- TOC entry 3318 (class 0 OID 1001940)
-- Dependencies: 203
-- Data for Name: games; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.games (gameid, gamename, publishdate, price, description, supplier) FROM stdin;
\.


--
-- TOC entry 3336 (class 0 OID 1002131)
-- Dependencies: 221
-- Data for Name: games_1_brin; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.games_1_brin (gameid, gamename, publishdate, price, description, supplier) FROM stdin;
\.


--
-- TOC entry 3322 (class 0 OID 1001962)
-- Dependencies: 207
-- Data for Name: games_1_hash; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.games_1_hash (gameid, gamename, publishdate, price, description, supplier) FROM stdin;
\.


--
-- TOC entry 3328 (class 0 OID 1002073)
-- Dependencies: 213
-- Data for Name: games_1_tree; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.games_1_tree (gameid, gamename, publishdate, price, description, supplier) FROM stdin;
\.


--
-- TOC entry 3338 (class 0 OID 1002144)
-- Dependencies: 223
-- Data for Name: games_2_brin; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.games_2_brin (gameid, gamename, publishdate, price, description, supplier) FROM stdin;
\.


--
-- TOC entry 3324 (class 0 OID 1001999)
-- Dependencies: 209
-- Data for Name: games_2_hash; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.games_2_hash (gameid, gamename, publishdate, price, description, supplier) FROM stdin;
\.


--
-- TOC entry 3330 (class 0 OID 1002086)
-- Dependencies: 215
-- Data for Name: games_2_tree; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.games_2_tree (gameid, gamename, publishdate, price, description, supplier) FROM stdin;
\.


--
-- TOC entry 3326 (class 0 OID 1002013)
-- Dependencies: 211
-- Data for Name: games_3_hash; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.games_3_hash (gameid, gamename, publishdate, price, description, supplier) FROM stdin;
\.


--
-- TOC entry 3332 (class 0 OID 1002100)
-- Dependencies: 217
-- Data for Name: games_3_tree; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.games_3_tree (gameid, gamename, publishdate, price, description, supplier) FROM stdin;
\.


--
-- TOC entry 3334 (class 0 OID 1002115)
-- Dependencies: 219
-- Data for Name: games_4_tree; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.games_4_tree (gameid, gamename, publishdate, price, description, supplier) FROM stdin;
\.


--
-- TOC entry 3320 (class 0 OID 1001950)
-- Dependencies: 205
-- Data for Name: games_unique; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.games_unique (gameid, gamename, publishdate, price, description, supplier) FROM stdin;
\.


--
-- TOC entry 3356 (class 0 OID 0)
-- Dependencies: 220
-- Name: games_1_brin_gameid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.games_1_brin_gameid_seq', 1, false);


--
-- TOC entry 3357 (class 0 OID 0)
-- Dependencies: 206
-- Name: games_1_hash_gameid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.games_1_hash_gameid_seq', 1, false);


--
-- TOC entry 3358 (class 0 OID 0)
-- Dependencies: 212
-- Name: games_1_tree_gameid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.games_1_tree_gameid_seq', 1, false);


--
-- TOC entry 3359 (class 0 OID 0)
-- Dependencies: 222
-- Name: games_2_brin_gameid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.games_2_brin_gameid_seq', 1, false);


--
-- TOC entry 3360 (class 0 OID 0)
-- Dependencies: 208
-- Name: games_2_hash_gameid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.games_2_hash_gameid_seq', 1, false);


--
-- TOC entry 3361 (class 0 OID 0)
-- Dependencies: 214
-- Name: games_2_tree_gameid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.games_2_tree_gameid_seq', 1, false);


--
-- TOC entry 3362 (class 0 OID 0)
-- Dependencies: 210
-- Name: games_3_hash_gameid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.games_3_hash_gameid_seq', 1, false);


--
-- TOC entry 3363 (class 0 OID 0)
-- Dependencies: 216
-- Name: games_3_tree_gameid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.games_3_tree_gameid_seq', 1, false);


--
-- TOC entry 3364 (class 0 OID 0)
-- Dependencies: 218
-- Name: games_4_tree_gameid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.games_4_tree_gameid_seq', 1, false);


--
-- TOC entry 3365 (class 0 OID 0)
-- Dependencies: 202
-- Name: games_gameid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.games_gameid_seq', 1, false);


--
-- TOC entry 3366 (class 0 OID 0)
-- Dependencies: 204
-- Name: games_unique_gameid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.games_unique_gameid_seq', 1, false);


--
-- TOC entry 3185 (class 2606 OID 1002140)
-- Name: games_1_brin games_1_brin_gameid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.games_1_brin
    ADD CONSTRAINT games_1_brin_gameid_key UNIQUE (gameid);


--
-- TOC entry 3156 (class 2606 OID 1001971)
-- Name: games_1_hash games_1_hash_gameid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.games_1_hash
    ADD CONSTRAINT games_1_hash_gameid_key UNIQUE (gameid);


--
-- TOC entry 3167 (class 2606 OID 1002082)
-- Name: games_1_tree games_1_tree_gameid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.games_1_tree
    ADD CONSTRAINT games_1_tree_gameid_key UNIQUE (gameid);


--
-- TOC entry 3188 (class 2606 OID 1002153)
-- Name: games_2_brin games_2_brin_gameid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.games_2_brin
    ADD CONSTRAINT games_2_brin_gameid_key UNIQUE (gameid);


--
-- TOC entry 3158 (class 2606 OID 1002008)
-- Name: games_2_hash games_2_hash_gameid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.games_2_hash
    ADD CONSTRAINT games_2_hash_gameid_key UNIQUE (gameid);


--
-- TOC entry 3170 (class 2606 OID 1002095)
-- Name: games_2_tree games_2_tree_gameid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.games_2_tree
    ADD CONSTRAINT games_2_tree_gameid_key UNIQUE (gameid);


--
-- TOC entry 3163 (class 2606 OID 1002022)
-- Name: games_3_hash games_3_hash_gameid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.games_3_hash
    ADD CONSTRAINT games_3_hash_gameid_key UNIQUE (gameid);


--
-- TOC entry 3174 (class 2606 OID 1002109)
-- Name: games_3_tree games_3_tree_gameid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.games_3_tree
    ADD CONSTRAINT games_3_tree_gameid_key UNIQUE (gameid);


--
-- TOC entry 3179 (class 2606 OID 1002124)
-- Name: games_4_tree games_4_tree_gameid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.games_4_tree
    ADD CONSTRAINT games_4_tree_gameid_key UNIQUE (gameid);


--
-- TOC entry 3153 (class 2606 OID 1001959)
-- Name: games_unique games_unique_gameid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.games_unique
    ADD CONSTRAINT games_unique_gameid_key UNIQUE (gameid);


--
-- TOC entry 3154 (class 1259 OID 1001972)
-- Name: gamenamehash; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX gamenamehash ON public.games_1_hash USING hash (gamename);


--
-- TOC entry 3186 (class 1259 OID 1002141)
-- Name: games_1_brin_publishdate_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX games_1_brin_publishdate_idx ON public.games_1_brin USING brin (publishdate);


--
-- TOC entry 3168 (class 1259 OID 1002083)
-- Name: games_1_tree_gamename_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX games_1_tree_gamename_idx ON public.games_1_tree USING btree (gamename);


--
-- TOC entry 3189 (class 1259 OID 1002155)
-- Name: games_2_brin_price_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX games_2_brin_price_idx ON public.games_2_brin USING brin (price);


--
-- TOC entry 3190 (class 1259 OID 1002154)
-- Name: games_2_brin_publishdate_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX games_2_brin_publishdate_idx ON public.games_2_brin USING brin (publishdate);


--
-- TOC entry 3159 (class 1259 OID 1002009)
-- Name: games_2_hash_gamename_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX games_2_hash_gamename_idx ON public.games_2_hash USING hash (gamename);


--
-- TOC entry 3160 (class 1259 OID 1002010)
-- Name: games_2_hash_supplier_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX games_2_hash_supplier_idx ON public.games_2_hash USING hash (supplier);


--
-- TOC entry 3171 (class 1259 OID 1002096)
-- Name: games_2_tree_gamename_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX games_2_tree_gamename_idx ON public.games_2_tree USING btree (gamename);


--
-- TOC entry 3172 (class 1259 OID 1002097)
-- Name: games_2_tree_supplier_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX games_2_tree_supplier_idx ON public.games_2_tree USING btree (supplier);


--
-- TOC entry 3161 (class 1259 OID 1002025)
-- Name: games_3_hash_gameid_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX games_3_hash_gameid_idx ON public.games_3_hash USING hash (gameid);


--
-- TOC entry 3164 (class 1259 OID 1002023)
-- Name: games_3_hash_gamename_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX games_3_hash_gamename_idx ON public.games_3_hash USING hash (gamename);


--
-- TOC entry 3165 (class 1259 OID 1002024)
-- Name: games_3_hash_supplier_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX games_3_hash_supplier_idx ON public.games_3_hash USING hash (supplier);


--
-- TOC entry 3175 (class 1259 OID 1002110)
-- Name: games_3_tree_gamename_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX games_3_tree_gamename_idx ON public.games_3_tree USING btree (gamename);


--
-- TOC entry 3176 (class 1259 OID 1002112)
-- Name: games_3_tree_publishdate_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX games_3_tree_publishdate_idx ON public.games_3_tree USING btree (publishdate);


--
-- TOC entry 3177 (class 1259 OID 1002111)
-- Name: games_3_tree_supplier_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX games_3_tree_supplier_idx ON public.games_3_tree USING btree (supplier);


--
-- TOC entry 3180 (class 1259 OID 1002125)
-- Name: games_4_tree_gamename_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX games_4_tree_gamename_idx ON public.games_4_tree USING btree (gamename);


--
-- TOC entry 3181 (class 1259 OID 1002128)
-- Name: games_4_tree_price_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX games_4_tree_price_idx ON public.games_4_tree USING btree (price);


--
-- TOC entry 3182 (class 1259 OID 1002127)
-- Name: games_4_tree_publishdate_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX games_4_tree_publishdate_idx ON public.games_4_tree USING btree (publishdate);


--
-- TOC entry 3183 (class 1259 OID 1002126)
-- Name: games_4_tree_supplier_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX games_4_tree_supplier_idx ON public.games_4_tree USING btree (supplier);


-- Completed on 2020-07-13 15:10:23 EDT

--
-- PostgreSQL database dump complete
--

