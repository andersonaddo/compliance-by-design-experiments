PGDMP                          x           partition_gdpr_reddit    12.3    12.3 6    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    17223    partition_gdpr_reddit    DATABASE     �   CREATE DATABASE partition_gdpr_reddit WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';
 %   DROP DATABASE partition_gdpr_reddit;
                postgres    false                        2615    18062    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
                postgres    false            �           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                   postgres    false    7                        2615    18063    shards    SCHEMA        CREATE SCHEMA shards;
    DROP SCHEMA shards;
                postgres    false            �            1255    18064 ,   comment(integer, integer, character varying)    FUNCTION       CREATE FUNCTION public.comment(user_id integer, post_id integer, content character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
   insert into "comments" (poster_id , "content", post_id , likes, date_of_creation )
   values ($1, content, $2, 0, now());
END;
$_$;
 [   DROP FUNCTION public.comment(user_id integer, post_id integer, content character varying);
       public          postgres    false    7            �            1255    18065    create_user(character varying)    FUNCTION     a  CREATE FUNCTION public.create_user(username_value character varying) RETURNS void
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
 D   DROP FUNCTION public.create_user(username_value character varying);
       public          postgres    false    7            �            1255    18066     decrement_comment_like_counter()    FUNCTION       CREATE FUNCTION public.decrement_comment_like_counter() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE comments 
    SET likes = coalesce(likes, 0) - 1
    WHERE comment_id = old.comment_id and poster_id = old.commenter_id;
return new;

END;
$$;
 7   DROP FUNCTION public.decrement_comment_like_counter();
       public          postgres    false    7            �            1255    18067    decrement_post_like_counter()    FUNCTION     �   CREATE FUNCTION public.decrement_post_like_counter() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE posts 
    SET likes = coalesce(likes, 0) - 1
    WHERE id = old.post_id and owner_id = old.poster_id;
return new;

END;
$$;
 4   DROP FUNCTION public.decrement_post_like_counter();
       public          postgres    false    7            �            1255    18068     increment_comment_like_counter()    FUNCTION       CREATE FUNCTION public.increment_comment_like_counter() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE comments 
    SET likes = coalesce(likes, 0) + 1
    WHERE comment_id = new.comment_id and poster_id = new.commenter_id;
return new;

END;
$$;
 7   DROP FUNCTION public.increment_comment_like_counter();
       public          postgres    false    7            �            1255    18069    increment_post_like_counter()    FUNCTION     �   CREATE FUNCTION public.increment_post_like_counter() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE posts 
    SET likes = coalesce(likes, 0) + 1
    WHERE owner_id = new.poster_id and id = new.post_id;
return new;

END;
$$;
 4   DROP FUNCTION public.increment_post_like_counter();
       public          postgres    false    7            �            1255    18070 '   like_comment(integer, integer, integer)    FUNCTION     �   CREATE FUNCTION public.like_comment(user_id integer, comment_id integer, commenter_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
    insert into liked_comments values ($1, $2, $3);
END;
$_$;
 ^   DROP FUNCTION public.like_comment(user_id integer, comment_id integer, commenter_id integer);
       public          postgres    false    7            �            1255    18071 $   like_post(integer, integer, integer)    FUNCTION     �   CREATE FUNCTION public.like_post(user_id integer, post_id integer, poster_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
    insert into liked_posts values ($1, $2, $3);
END;
$_$;
 U   DROP FUNCTION public.like_post(user_id integer, post_id integer, poster_id integer);
       public          postgres    false    7            �            1255    18072     post(integer, character varying)    FUNCTION     �   CREATE FUNCTION public.post(user_id integer, content character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
   insert into posts (owner_id, "content", date_of_creation, likes )
   values ($1, $2, Now(), 0);
END;
$_$;
 G   DROP FUNCTION public.post(user_id integer, content character varying);
       public          postgres    false    7            �            1255    18073 )   unlike_comment(integer, integer, integer)    FUNCTION     *  CREATE FUNCTION public.unlike_comment(user_id integer, comment_id integer, commenter_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
    delete from liked_comments 
	where liked_comments.commenter_id = $3 and liked_comments.comment_id = $2 and liked_comments.user_id = $1;
END;
$_$;
 `   DROP FUNCTION public.unlike_comment(user_id integer, comment_id integer, commenter_id integer);
       public          postgres    false    7            �            1255    18074 &   unlike_post(integer, integer, integer)    FUNCTION       CREATE FUNCTION public.unlike_post(user_id integer, post_id integer, poster_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
    delete from liked_posts 
	where  liked_posts.owner_id = $3 and liked_posts.post_id = $2 and liked_posts.user_id = $1;
END;
$_$;
 W   DROP FUNCTION public.unlike_post(user_id integer, post_id integer, poster_id integer);
       public          postgres    false    7            �            1259    18075    comments    TABLE       CREATE TABLE public.comments (
    comment_id integer NOT NULL,
    content character varying NOT NULL,
    date_of_creation timestamp without time zone NOT NULL,
    likes integer,
    post_id integer,
    poster_id integer NOT NULL
)
PARTITION BY LIST (poster_id);
    DROP TABLE public.comments;
       public            postgres    false    7            �            1259    18078    comments_comment_id_seq    SEQUENCE     �   CREATE SEQUENCE public.comments_comment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.comments_comment_id_seq;
       public          postgres    false    7    203            �           0    0    comments_comment_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.comments_comment_id_seq OWNED BY public.comments.comment_id;
          public          postgres    false    204            �            1259    18080    liked_comments    TABLE     �   CREATE TABLE public.liked_comments (
    user_id integer NOT NULL,
    comment_id integer NOT NULL,
    commenter_id integer NOT NULL
)
PARTITION BY LIST (user_id);
 "   DROP TABLE public.liked_comments;
       public            postgres    false    7            �            1259    18083    liked_posts    TABLE     �   CREATE TABLE public.liked_posts (
    user_id integer NOT NULL,
    post_id integer NOT NULL,
    poster_id integer NOT NULL
)
PARTITION BY LIST (user_id);
    DROP TABLE public.liked_posts;
       public            postgres    false    7            �            1259    18086    posts    TABLE     �   CREATE TABLE public.posts (
    id integer NOT NULL,
    owner_id integer NOT NULL,
    content character varying NOT NULL,
    likes integer,
    date_of_creation timestamp without time zone NOT NULL
)
PARTITION BY LIST (owner_id);
    DROP TABLE public.posts;
       public            postgres    false    7            �            1259    18089    posts_id_seq    SEQUENCE     �   CREATE SEQUENCE public.posts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.posts_id_seq;
       public          postgres    false    7    207            �           0    0    posts_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;
          public          postgres    false    208            �            1259    18091    users    TABLE     �   CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying NOT NULL,
    date_of_creation timestamp without time zone NOT NULL
);
    DROP TABLE public.users;
       public         heap    postgres    false    7            �            1259    18097    users_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          postgres    false    209    7            �           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
          public          postgres    false    210                       2604    18099    comments comment_id    DEFAULT     z   ALTER TABLE ONLY public.comments ALTER COLUMN comment_id SET DEFAULT nextval('public.comments_comment_id_seq'::regclass);
 B   ALTER TABLE public.comments ALTER COLUMN comment_id DROP DEFAULT;
       public          postgres    false    204    203                       2604    18100    posts id    DEFAULT     d   ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);
 7   ALTER TABLE public.posts ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    208    207                       2604    18101    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    210    209            �          0    18091    users 
   TABLE DATA           ?   COPY public.users (id, username, date_of_creation) FROM stdin;
    public          postgres    false    209            �           0    0    comments_comment_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.comments_comment_id_seq', 1, false);
          public          postgres    false    204            �           0    0    posts_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.posts_id_seq', 3, true);
          public          postgres    false    208            �           0    0    users_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.users_id_seq', 20, true);
          public          postgres    false    210                       2606    18139    comments comments_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (poster_id, date_of_creation);
 @   ALTER TABLE ONLY public.comments DROP CONSTRAINT comments_pkey;
       public            postgres    false    203    203                       2606    18105 "   liked_comments liked_comments_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY public.liked_comments
    ADD CONSTRAINT liked_comments_pkey PRIMARY KEY (user_id, comment_id);
 L   ALTER TABLE ONLY public.liked_comments DROP CONSTRAINT liked_comments_pkey;
       public            postgres    false    205    205                       2606    18107    liked_posts liked_posts_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.liked_posts
    ADD CONSTRAINT liked_posts_pkey PRIMARY KEY (user_id, post_id);
 F   ALTER TABLE ONLY public.liked_posts DROP CONSTRAINT liked_posts_pkey;
       public            postgres    false    206    206            !           2606    18109    posts posts_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id, owner_id);
 :   ALTER TABLE ONLY public.posts DROP CONSTRAINT posts_pkey;
       public            postgres    false    207    207            #           2606    18111    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    209                       1259    18112    comments_post_id    INDEX     M   CREATE INDEX comments_post_id ON ONLY public.comments USING btree (post_id);
 $   DROP INDEX public.comments_post_id;
       public            postgres    false    203                       1259    18113    liked_comments_comment_id    INDEX     _   CREATE INDEX liked_comments_comment_id ON ONLY public.liked_comments USING btree (comment_id);
 -   DROP INDEX public.liked_comments_comment_id;
       public            postgres    false    205                       1259    18114    liked_posts_post_id    INDEX     S   CREATE INDEX liked_posts_post_id ON ONLY public.liked_posts USING btree (post_id);
 '   DROP INDEX public.liked_posts_post_id;
       public            postgres    false    206            *           2620    18115 "   liked_comments add_to_comment_like    TRIGGER     �   CREATE TRIGGER add_to_comment_like AFTER INSERT ON public.liked_comments FOR EACH ROW EXECUTE FUNCTION public.increment_comment_like_counter();
 ;   DROP TRIGGER add_to_comment_like ON public.liked_comments;
       public          postgres    false    227    205            ,           2620    18116    liked_posts add_to_post_like    TRIGGER     �   CREATE TRIGGER add_to_post_like AFTER INSERT ON public.liked_posts FOR EACH ROW EXECUTE FUNCTION public.increment_post_like_counter();
 5   DROP TRIGGER add_to_post_like ON public.liked_posts;
       public          postgres    false    206    228            +           2620    18117 )   liked_comments subtract_from_comment_like    TRIGGER     �   CREATE TRIGGER subtract_from_comment_like AFTER DELETE ON public.liked_comments FOR EACH ROW EXECUTE FUNCTION public.decrement_comment_like_counter();
 B   DROP TRIGGER subtract_from_comment_like ON public.liked_comments;
       public          postgres    false    225    205            -           2620    18118 #   liked_posts subtract_from_post_like    TRIGGER     �   CREATE TRIGGER subtract_from_post_like AFTER DELETE ON public.liked_posts FOR EACH ROW EXECUTE FUNCTION public.decrement_post_like_counter();
 <   DROP TRIGGER subtract_from_post_like ON public.liked_posts;
       public          postgres    false    226    206            $           2606    18119     comments comments_poster_id_fkey    FK CONSTRAINT     �   ALTER TABLE public.comments
    ADD CONSTRAINT comments_poster_id_fkey FOREIGN KEY (poster_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;
 E   ALTER TABLE public.comments DROP CONSTRAINT comments_poster_id_fkey;
       public          postgres    false    203    209    3107            %           2606    18122 /   liked_comments liked_comments_commenter_id_fkey    FK CONSTRAINT     �   ALTER TABLE public.liked_comments
    ADD CONSTRAINT liked_comments_commenter_id_fkey FOREIGN KEY (commenter_id) REFERENCES public.users(id);
 T   ALTER TABLE public.liked_comments DROP CONSTRAINT liked_comments_commenter_id_fkey;
       public          postgres    false    3107    205    209            &           2606    18125 *   liked_comments liked_comments_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE public.liked_comments
    ADD CONSTRAINT liked_comments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;
 O   ALTER TABLE public.liked_comments DROP CONSTRAINT liked_comments_user_id_fkey;
       public          postgres    false    209    205    3107            '           2606    18128 &   liked_posts liked_posts_poster_id_fkey    FK CONSTRAINT     �   ALTER TABLE public.liked_posts
    ADD CONSTRAINT liked_posts_poster_id_fkey FOREIGN KEY (poster_id) REFERENCES public.users(id);
 K   ALTER TABLE public.liked_posts DROP CONSTRAINT liked_posts_poster_id_fkey;
       public          postgres    false    209    3107    206            (           2606    18131 $   liked_posts liked_posts_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE public.liked_posts
    ADD CONSTRAINT liked_posts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;
 I   ALTER TABLE public.liked_posts DROP CONSTRAINT liked_posts_user_id_fkey;
       public          postgres    false    206    209    3107            )           2606    18134    posts posts_owner_id_fkey    FK CONSTRAINT     �   ALTER TABLE public.posts
    ADD CONSTRAINT posts_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;
 >   ALTER TABLE public.posts DROP CONSTRAINT posts_owner_id_fkey;
       public          postgres    false    209    207    3107            �      x������ � �     