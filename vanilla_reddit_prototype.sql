PGDMP     7                    x           vanilla_reddit    12.3    12.3 9    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16786    vanilla_reddit    DATABASE     �   CREATE DATABASE vanilla_reddit WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';
    DROP DATABASE vanilla_reddit;
                postgres    false                        2615    17121    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
                postgres    false            �           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                   postgres    false    6            �            1255    17122 ,   comment(integer, integer, character varying)    FUNCTION       CREATE FUNCTION public.comment(user_id integer, post_id integer, content character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
   insert into "comments" (poster_id , "content", post_id , likes, date_of_creation )
   values ($1, content, $2, 0, now());
END;
$_$;
 [   DROP FUNCTION public.comment(user_id integer, post_id integer, content character varying);
       public          postgres    false    6            �            1255    17123    create_user(character varying)    FUNCTION     �   CREATE FUNCTION public.create_user(username_value character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
   insert into users (username , date_of_creation )
   values ($1, now());
END;
$_$;
 D   DROP FUNCTION public.create_user(username_value character varying);
       public          postgres    false    6            �            1255    17124     decrement_comment_like_counter()    FUNCTION     �   CREATE FUNCTION public.decrement_comment_like_counter() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE comments 
    SET likes = coalesce(likes, 0) - 1
    WHERE comment_id = old.comment_id;
return new;

END;
$$;
 7   DROP FUNCTION public.decrement_comment_like_counter();
       public          postgres    false    6            �            1255    17125    decrement_post_like_counter()    FUNCTION     �   CREATE FUNCTION public.decrement_post_like_counter() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE posts 
    SET likes = coalesce(likes, 0) - 1
    WHERE id = old.post_id;
return new;

END;
$$;
 4   DROP FUNCTION public.decrement_post_like_counter();
       public          postgres    false    6            �            1255    17126     increment_comment_like_counter()    FUNCTION     �   CREATE FUNCTION public.increment_comment_like_counter() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE comments 
    SET likes = coalesce(likes, 0) + 1
    WHERE comment_id = new.comment_id;
return new;

END;
$$;
 7   DROP FUNCTION public.increment_comment_like_counter();
       public          postgres    false    6            �            1255    17127    increment_post_like_counter()    FUNCTION     �   CREATE FUNCTION public.increment_post_like_counter() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE posts 
    SET likes = coalesce(likes, 0) + 1
    WHERE id = new.post_id;
return new;

END;
$$;
 4   DROP FUNCTION public.increment_post_like_counter();
       public          postgres    false    6            �            1255    17128    like_comment(integer, integer)    FUNCTION     �   CREATE FUNCTION public.like_comment(user_id integer, comment_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
    insert into liked_comments values ($1, $2);
END;
$_$;
 H   DROP FUNCTION public.like_comment(user_id integer, comment_id integer);
       public          postgres    false    6            �            1255    17129    like_post(integer, integer)    FUNCTION     �   CREATE FUNCTION public.like_post(user_id integer, post_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
    insert into liked_posts values ($1, $2);
END;
$_$;
 B   DROP FUNCTION public.like_post(user_id integer, post_id integer);
       public          postgres    false    6            �            1255    17130     post(integer, character varying)    FUNCTION     �   CREATE FUNCTION public.post(user_id integer, content character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
   insert into posts (owner_id, "content", date_of_creation, likes )
   values ($1, $2, Now(), 0);
END;
$_$;
 G   DROP FUNCTION public.post(user_id integer, content character varying);
       public          postgres    false    6            �            1255    17131     unlike_comment(integer, integer)    FUNCTION     �   CREATE FUNCTION public.unlike_comment(user_id integer, comment_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
    delete from liked_comments 
	where  liked_comments.comment_id = $2 and liked_comments.user_id = $1;
END;
$_$;
 J   DROP FUNCTION public.unlike_comment(user_id integer, comment_id integer);
       public          postgres    false    6            �            1255    17132    unlike_post(integer, integer)    FUNCTION     �   CREATE FUNCTION public.unlike_post(user_id integer, post_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
    delete from liked_posts 
	where  liked_posts.post_id = $2 and liked_posts.user_id = $1;
END;
$_$;
 D   DROP FUNCTION public.unlike_post(user_id integer, post_id integer);
       public          postgres    false    6            �            1259    17133    comments    TABLE     �   CREATE TABLE public.comments (
    comment_id integer NOT NULL,
    content character varying NOT NULL,
    date_of_creation timestamp without time zone NOT NULL,
    likes integer,
    post_id integer,
    poster_id integer
);
    DROP TABLE public.comments;
       public         heap    postgres    false    6            �            1259    17139    comments_comment_id_seq    SEQUENCE     �   CREATE SEQUENCE public.comments_comment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.comments_comment_id_seq;
       public          postgres    false    202    6            �           0    0    comments_comment_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.comments_comment_id_seq OWNED BY public.comments.comment_id;
          public          postgres    false    203            �            1259    17141    liked_comments    TABLE     f   CREATE TABLE public.liked_comments (
    user_id integer NOT NULL,
    comment_id integer NOT NULL
);
 "   DROP TABLE public.liked_comments;
       public         heap    postgres    false    6            �            1259    17144    liked_posts    TABLE     `   CREATE TABLE public.liked_posts (
    user_id integer NOT NULL,
    post_id integer NOT NULL
);
    DROP TABLE public.liked_posts;
       public         heap    postgres    false    6            �            1259    17147    posts    TABLE     �   CREATE TABLE public.posts (
    id integer NOT NULL,
    owner_id integer NOT NULL,
    content character varying NOT NULL,
    likes integer,
    date_of_creation timestamp without time zone NOT NULL
);
    DROP TABLE public.posts;
       public         heap    postgres    false    6            �            1259    17153    posts_id_seq    SEQUENCE     �   CREATE SEQUENCE public.posts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.posts_id_seq;
       public          postgres    false    6    206            �           0    0    posts_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;
          public          postgres    false    207            �            1259    17155    top_10_posts    VIEW     �   CREATE VIEW public.top_10_posts AS
 SELECT posts.id,
    posts.owner_id,
    posts.content,
    posts.likes,
    posts.date_of_creation
   FROM public.posts
  ORDER BY posts.likes
 LIMIT 10;
    DROP VIEW public.top_10_posts;
       public          postgres    false    206    206    206    206    206    6            �            1259    17159    users    TABLE     �   CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying NOT NULL,
    date_of_creation timestamp without time zone NOT NULL
);
    DROP TABLE public.users;
       public         heap    postgres    false    6            �            1259    17165    users_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          postgres    false    209    6            �           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
          public          postgres    false    210                       2604    17167    comments comment_id    DEFAULT     z   ALTER TABLE ONLY public.comments ALTER COLUMN comment_id SET DEFAULT nextval('public.comments_comment_id_seq'::regclass);
 B   ALTER TABLE public.comments ALTER COLUMN comment_id DROP DEFAULT;
       public          postgres    false    203    202                       2604    17168    posts id    DEFAULT     d   ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);
 7   ALTER TABLE public.posts ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    207    206                       2604    17169    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    210    209            �          0    17133    comments 
   TABLE DATA           d   COPY public.comments (comment_id, content, date_of_creation, likes, post_id, poster_id) FROM stdin;
    public          postgres    false    202            �          0    17141    liked_comments 
   TABLE DATA           =   COPY public.liked_comments (user_id, comment_id) FROM stdin;
    public          postgres    false    204            �          0    17144    liked_posts 
   TABLE DATA           7   COPY public.liked_posts (user_id, post_id) FROM stdin;
    public          postgres    false    205            �          0    17147    posts 
   TABLE DATA           O   COPY public.posts (id, owner_id, content, likes, date_of_creation) FROM stdin;
    public          postgres    false    206            �          0    17159    users 
   TABLE DATA           ?   COPY public.users (id, username, date_of_creation) FROM stdin;
    public          postgres    false    209            �           0    0    comments_comment_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.comments_comment_id_seq', 1, false);
          public          postgres    false    203            �           0    0    posts_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.posts_id_seq', 1, false);
          public          postgres    false    207            �           0    0    users_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.users_id_seq', 1, false);
          public          postgres    false    210                       2606    17171    comments comments_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (comment_id);
 @   ALTER TABLE ONLY public.comments DROP CONSTRAINT comments_pkey;
       public            postgres    false    202                       2606    17173 "   liked_comments liked_comments_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY public.liked_comments
    ADD CONSTRAINT liked_comments_pkey PRIMARY KEY (user_id, comment_id);
 L   ALTER TABLE ONLY public.liked_comments DROP CONSTRAINT liked_comments_pkey;
       public            postgres    false    204    204            !           2606    17175    liked_posts liked_posts_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.liked_posts
    ADD CONSTRAINT liked_posts_pkey PRIMARY KEY (user_id, post_id);
 F   ALTER TABLE ONLY public.liked_posts DROP CONSTRAINT liked_posts_pkey;
       public            postgres    false    205    205            $           2606    17177    posts posts_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.posts DROP CONSTRAINT posts_pkey;
       public            postgres    false    206            &           2606    17179    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    209            "           1259    17180 
   like_index    INDEX     =   CREATE INDEX like_index ON public.posts USING btree (likes);
    DROP INDEX public.like_index;
       public            postgres    false    206            .           2620    17181 "   liked_comments add_to_comment_like    TRIGGER     �   CREATE TRIGGER add_to_comment_like AFTER INSERT ON public.liked_comments FOR EACH ROW EXECUTE FUNCTION public.increment_comment_like_counter();
 ;   DROP TRIGGER add_to_comment_like ON public.liked_comments;
       public          postgres    false    204    215            0           2620    17182    liked_posts add_to_post_like    TRIGGER     �   CREATE TRIGGER add_to_post_like AFTER INSERT ON public.liked_posts FOR EACH ROW EXECUTE FUNCTION public.increment_post_like_counter();
 5   DROP TRIGGER add_to_post_like ON public.liked_posts;
       public          postgres    false    216    205            /           2620    17183 )   liked_comments subtract_from_comment_like    TRIGGER     �   CREATE TRIGGER subtract_from_comment_like AFTER DELETE ON public.liked_comments FOR EACH ROW EXECUTE FUNCTION public.decrement_comment_like_counter();
 B   DROP TRIGGER subtract_from_comment_like ON public.liked_comments;
       public          postgres    false    220    204            1           2620    17184 #   liked_posts subtract_from_post_like    TRIGGER     �   CREATE TRIGGER subtract_from_post_like AFTER DELETE ON public.liked_posts FOR EACH ROW EXECUTE FUNCTION public.decrement_post_like_counter();
 <   DROP TRIGGER subtract_from_post_like ON public.liked_posts;
       public          postgres    false    205    221            '           2606    17185    comments comments_post_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(id) ON UPDATE CASCADE ON DELETE CASCADE;
 H   ALTER TABLE ONLY public.comments DROP CONSTRAINT comments_post_id_fkey;
       public          postgres    false    3108    202    206            (           2606    17190     comments comments_poster_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_poster_id_fkey FOREIGN KEY (poster_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;
 J   ALTER TABLE ONLY public.comments DROP CONSTRAINT comments_poster_id_fkey;
       public          postgres    false    209    202    3110            )           2606    17195 -   liked_comments liked_comments_comment_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.liked_comments
    ADD CONSTRAINT liked_comments_comment_id_fkey FOREIGN KEY (comment_id) REFERENCES public.comments(comment_id) ON UPDATE CASCADE ON DELETE CASCADE;
 W   ALTER TABLE ONLY public.liked_comments DROP CONSTRAINT liked_comments_comment_id_fkey;
       public          postgres    false    202    3101    204            *           2606    17200 *   liked_comments liked_comments_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.liked_comments
    ADD CONSTRAINT liked_comments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;
 T   ALTER TABLE ONLY public.liked_comments DROP CONSTRAINT liked_comments_user_id_fkey;
       public          postgres    false    3110    209    204            +           2606    17205 $   liked_posts liked_posts_post_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.liked_posts
    ADD CONSTRAINT liked_posts_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(id) ON UPDATE CASCADE ON DELETE CASCADE;
 N   ALTER TABLE ONLY public.liked_posts DROP CONSTRAINT liked_posts_post_id_fkey;
       public          postgres    false    205    206    3108            ,           2606    17210 $   liked_posts liked_posts_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.liked_posts
    ADD CONSTRAINT liked_posts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;
 N   ALTER TABLE ONLY public.liked_posts DROP CONSTRAINT liked_posts_user_id_fkey;
       public          postgres    false    209    3110    205            -           2606    17215    posts user_foreign_key    FK CONSTRAINT     �   ALTER TABLE ONLY public.posts
    ADD CONSTRAINT user_foreign_key FOREIGN KEY (owner_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;
 @   ALTER TABLE ONLY public.posts DROP CONSTRAINT user_foreign_key;
       public          postgres    false    206    209    3110            �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �     