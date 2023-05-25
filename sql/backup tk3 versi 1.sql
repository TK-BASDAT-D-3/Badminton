PGDMP     3                    {            tk3-5    15.2    15.2 �    P           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            Q           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            R           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            S           1262    27288    tk3-5    DATABASE     i   CREATE DATABASE "tk3-5" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C';
    DROP DATABASE "tk3-5";
                postgres    false                        2615    33030    badudu    SCHEMA        CREATE SCHEMA badudu;
    DROP SCHEMA badudu;
                postgres    false                        2615    2200    public    SCHEMA     2   -- *not* creating schema, since initdb creates it
 2   -- *not* dropping schema, since initdb creates it
                postgres    false            T           0    0    SCHEMA public    COMMENT         COMMENT ON SCHEMA public IS '';
                   postgres    false    5            U           0    0    SCHEMA public    ACL     Q   REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;
                   postgres    false    5                       1255    141861    update_point_history()    FUNCTION     �  CREATE FUNCTION public.update_point_history() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.Status_Menang = TRUE THEN
        UPDATE badudu.POINT_HISTORY 
        SET Total_Point = Total_Point + (SELECT points FROM point_map WHERE category = 'Super' AND position = NEW.Jenis_Babak)
        WHERE ID_Atlet = (SELECT ID_Atlet FROM badudu.PESERTA_KOMPETISI WHERE Nomor_Peserta = NEW.Nomor_Peserta);
    END IF;
    RETURN NEW;
END;
$$;
 -   DROP FUNCTION public.update_point_history();
       public          postgres    false    5                       1255    141851    update_world_rank()    FUNCTION     T  CREATE FUNCTION public.update_world_rank() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Calculate new ranks
    WITH ranked AS (
        SELECT ID, ROW_NUMBER() OVER (ORDER BY sum_points DESC) AS rank
        FROM (
            SELECT ID_Atlet AS ID, SUM(Total_Point) as sum_points
            FROM badudu.POINT_HISTORY
            WHERE Tahun = EXTRACT(YEAR FROM CURRENT_DATE)
            GROUP BY ID_Atlet
        ) as subquery
    )
    -- Update the ranks in the ATLET table
    UPDATE badudu.ATLET SET World_Rank = ranked.rank
    FROM ranked
    WHERE ATLET.ID = ranked.ID;

    -- Calculate new ranks
    WITH ranked AS (
        SELECT ID, ROW_NUMBER() OVER (ORDER BY sum_points DESC) AS rank
        FROM (
            SELECT ID_Atlet AS ID, SUM(Total_Point) as sum_points
            FROM badudu.POINT_HISTORY
            WHERE Tahun = EXTRACT(YEAR FROM CURRENT_DATE)
            GROUP BY ID_Atlet
        ) as subquery
    )
    UPDATE badudu.ATLET_KUALIFIKASI SET World_Rank = ranked.rank
    FROM ranked
    WHERE ATLET_KUALIFIKASI.ID_Atlet = ranked.ID;

    RETURN NEW;
END;
$$;
 *   DROP FUNCTION public.update_world_rank();
       public          postgres    false    5            �            1259    27289    atlet    TABLE       CREATE TABLE badudu.atlet (
    id uuid NOT NULL,
    tgl_lahir date NOT NULL,
    negara_asal character varying(50) NOT NULL,
    play_right boolean NOT NULL,
    height integer NOT NULL,
    world_rank integer NOT NULL,
    jenis_kelamin boolean NOT NULL
);
    DROP TABLE badudu.atlet;
       badudu         heap    postgres    false    6            �            1259    27292    atlet_ganda    TABLE     �   CREATE TABLE badudu.atlet_ganda (
    id_atlet_ganda uuid NOT NULL,
    id_atlet_kualifikasi uuid,
    id_atlet_kualifikasi_2 uuid
);
    DROP TABLE badudu.atlet_ganda;
       badudu         heap    postgres    false    6            �            1259    27295    atlet_kualifikasi    TABLE     �   CREATE TABLE badudu.atlet_kualifikasi (
    id_atlet uuid NOT NULL,
    world_rank integer NOT NULL,
    world_tour_rank integer NOT NULL
);
 %   DROP TABLE badudu.atlet_kualifikasi;
       badudu         heap    postgres    false    6            �            1259    27298    atlet_non_kualifikasi    TABLE     J   CREATE TABLE badudu.atlet_non_kualifikasi (
    id_atlet uuid NOT NULL
);
 )   DROP TABLE badudu.atlet_non_kualifikasi;
       badudu         heap    postgres    false    6            �            1259    27301 &   atlet_nonkualifikasi_ujian_kualifikasi    TABLE     �   CREATE TABLE badudu.atlet_nonkualifikasi_ujian_kualifikasi (
    id_atlet uuid NOT NULL,
    tahun integer NOT NULL,
    batch integer NOT NULL,
    tempat character varying(50) NOT NULL,
    tanggal date NOT NULL,
    hasil_lulus boolean NOT NULL
);
 :   DROP TABLE badudu.atlet_nonkualifikasi_ujian_kualifikasi;
       badudu         heap    postgres    false    6            �            1259    27304    atlet_pelatih    TABLE     `   CREATE TABLE badudu.atlet_pelatih (
    id_pelatih uuid NOT NULL,
    id_atlet uuid NOT NULL
);
 !   DROP TABLE badudu.atlet_pelatih;
       badudu         heap    postgres    false    6            �            1259    27307    atlet_sponsor    TABLE     �   CREATE TABLE badudu.atlet_sponsor (
    id_atlet uuid NOT NULL,
    id_sponsor uuid NOT NULL,
    tgl_mulai date NOT NULL,
    tgl_selesai date
);
 !   DROP TABLE badudu.atlet_sponsor;
       badudu         heap    postgres    false    6            �            1259    27310    event    TABLE     I  CREATE TABLE badudu.event (
    nama_event character varying(50) NOT NULL,
    tahun integer NOT NULL,
    nama_stadium character varying(50),
    negara character varying(50) NOT NULL,
    tgl_mulai date NOT NULL,
    tgl_selesai date NOT NULL,
    kategori_superseries character varying(5) NOT NULL,
    total_hadiah bigint
);
    DROP TABLE badudu.event;
       badudu         heap    postgres    false    6            �            1259    27313    game    TABLE     �   CREATE TABLE badudu.game (
    no_game integer NOT NULL,
    durasi integer NOT NULL,
    jenis_babak character varying(20),
    tanggal date,
    waktu_mulai time without time zone
);
    DROP TABLE badudu.game;
       badudu         heap    postgres    false    6            �            1259    27316    match    TABLE       CREATE TABLE badudu.match (
    jenis_babak character varying(20) NOT NULL,
    tanggal date NOT NULL,
    waktu_mulai time without time zone NOT NULL,
    total_durasi integer NOT NULL,
    nama_event character varying(50),
    tahun_event integer,
    id_umpire uuid
);
    DROP TABLE badudu.match;
       badudu         heap    postgres    false    6            �            1259    27319    member    TABLE     �   CREATE TABLE badudu.member (
    id uuid NOT NULL,
    nama character varying(50) NOT NULL,
    email character varying(50) NOT NULL
);
    DROP TABLE badudu.member;
       badudu         heap    postgres    false    6            �            1259    27322    partai_kompetisi    TABLE     �   CREATE TABLE badudu.partai_kompetisi (
    jenis_partai character(2) NOT NULL,
    nama_event character varying(50) NOT NULL,
    tahun_event integer NOT NULL
);
 $   DROP TABLE badudu.partai_kompetisi;
       badudu         heap    postgres    false    6            �            1259    27325    partai_peserta_kompetisi    TABLE     �   CREATE TABLE badudu.partai_peserta_kompetisi (
    jenis_partai character(2) NOT NULL,
    nama_event character varying(50) NOT NULL,
    tahun_event integer NOT NULL,
    nomor_peserta integer NOT NULL
);
 ,   DROP TABLE badudu.partai_peserta_kompetisi;
       badudu         heap    postgres    false    6            �            1259    27328    pelatih    TABLE     W   CREATE TABLE badudu.pelatih (
    id uuid NOT NULL,
    tanggal_mulai date NOT NULL
);
    DROP TABLE badudu.pelatih;
       badudu         heap    postgres    false    6            �            1259    27331    pelatih_spesialisasi    TABLE     n   CREATE TABLE badudu.pelatih_spesialisasi (
    id_pelatih uuid NOT NULL,
    id_spesialisasi uuid NOT NULL
);
 (   DROP TABLE badudu.pelatih_spesialisasi;
       badudu         heap    postgres    false    6            �            1259    27334    peserta_kompetisi    TABLE     �   CREATE TABLE badudu.peserta_kompetisi (
    nomor_peserta integer NOT NULL,
    id_atlet_ganda uuid,
    id_atlet_kualifikasi uuid,
    world_rank integer NOT NULL,
    world_tour_rank integer NOT NULL
);
 %   DROP TABLE badudu.peserta_kompetisi;
       badudu         heap    postgres    false    6            �            1259    27337    peserta_mendaftar_event    TABLE     �   CREATE TABLE badudu.peserta_mendaftar_event (
    nomor_peserta integer NOT NULL,
    nama_event character varying(50) NOT NULL,
    tahun integer NOT NULL
);
 +   DROP TABLE badudu.peserta_mendaftar_event;
       badudu         heap    postgres    false    6            �            1259    27340    peserta_mengikuti_game    TABLE     �   CREATE TABLE badudu.peserta_mengikuti_game (
    nomor_peserta integer NOT NULL,
    no_game integer NOT NULL,
    skor integer NOT NULL
);
 *   DROP TABLE badudu.peserta_mengikuti_game;
       badudu         heap    postgres    false    6            �            1259    27343    peserta_mengikuti_match    TABLE     �   CREATE TABLE badudu.peserta_mengikuti_match (
    jenis_babak character varying(20) NOT NULL,
    tanggal date NOT NULL,
    waktu_mulai time without time zone NOT NULL,
    nomor_peserta integer NOT NULL,
    status_menang boolean NOT NULL
);
 +   DROP TABLE badudu.peserta_mengikuti_match;
       badudu         heap    postgres    false    6            �            1259    27346    point_history    TABLE     �   CREATE TABLE badudu.point_history (
    id_atlet uuid NOT NULL,
    minggu_ke integer NOT NULL,
    bulan character varying(20) NOT NULL,
    tahun integer NOT NULL,
    total_point integer
);
 !   DROP TABLE badudu.point_history;
       badudu         heap    postgres    false    6            �            1259    27349    spesialisasi    TABLE     l   CREATE TABLE badudu.spesialisasi (
    id uuid NOT NULL,
    spesialisasi character varying(20) NOT NULL
);
     DROP TABLE badudu.spesialisasi;
       badudu         heap    postgres    false    6            �            1259    27352    sponsor    TABLE     �   CREATE TABLE badudu.sponsor (
    id uuid NOT NULL,
    nama_brand character varying(50) NOT NULL,
    website character varying(50),
    cp_name character varying(50) NOT NULL,
    cp_email character varying(50) NOT NULL
);
    DROP TABLE badudu.sponsor;
       badudu         heap    postgres    false    6            �            1259    27355    stadium    TABLE       CREATE TABLE badudu.stadium (
    nama character varying(50) NOT NULL,
    alamat character varying(50) NOT NULL,
    kapasitas integer NOT NULL,
    negara character varying(50) NOT NULL,
    CONSTRAINT stadium_kapasitas_check CHECK (((kapasitas % 2) = 0))
);
    DROP TABLE badudu.stadium;
       badudu         heap    postgres    false    6            �            1259    27359    ujian_kualifikasi    TABLE     �   CREATE TABLE badudu.ujian_kualifikasi (
    tahun integer NOT NULL,
    batch integer NOT NULL,
    tempat character varying(50) NOT NULL,
    tanggal date NOT NULL
);
 %   DROP TABLE badudu.ujian_kualifikasi;
       badudu         heap    postgres    false    6            �            1259    27362    umpire    TABLE     `   CREATE TABLE badudu.umpire (
    id uuid NOT NULL,
    negara character varying(50) NOT NULL
);
    DROP TABLE badudu.umpire;
       badudu         heap    postgres    false    6            �            1259    141724 
   auth_group    TABLE     f   CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);
    DROP TABLE public.auth_group;
       public         heap    postgres    false    5            �            1259    141723    auth_group_id_seq    SEQUENCE     �   ALTER TABLE public.auth_group ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    5    247            �            1259    141732    auth_group_permissions    TABLE     �   CREATE TABLE public.auth_group_permissions (
    id bigint NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);
 *   DROP TABLE public.auth_group_permissions;
       public         heap    postgres    false    5            �            1259    141731    auth_group_permissions_id_seq    SEQUENCE     �   ALTER TABLE public.auth_group_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    249    5            �            1259    141718    auth_permission    TABLE     �   CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);
 #   DROP TABLE public.auth_permission;
       public         heap    postgres    false    5            �            1259    141717    auth_permission_id_seq    SEQUENCE     �   ALTER TABLE public.auth_permission ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    5    245            �            1259    141738 	   auth_user    TABLE     �  CREATE TABLE public.auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(150) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);
    DROP TABLE public.auth_user;
       public         heap    postgres    false    5            �            1259    141746    auth_user_groups    TABLE     ~   CREATE TABLE public.auth_user_groups (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);
 $   DROP TABLE public.auth_user_groups;
       public         heap    postgres    false    5            �            1259    141745    auth_user_groups_id_seq    SEQUENCE     �   ALTER TABLE public.auth_user_groups ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    253    5            �            1259    141737    auth_user_id_seq    SEQUENCE     �   ALTER TABLE public.auth_user ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    251    5            �            1259    141752    auth_user_user_permissions    TABLE     �   CREATE TABLE public.auth_user_user_permissions (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);
 .   DROP TABLE public.auth_user_user_permissions;
       public         heap    postgres    false    5            �            1259    141751 !   auth_user_user_permissions_id_seq    SEQUENCE     �   ALTER TABLE public.auth_user_user_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    255    5                       1259    141810    django_admin_log    TABLE     �  CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);
 $   DROP TABLE public.django_admin_log;
       public         heap    postgres    false    5                        1259    141809    django_admin_log_id_seq    SEQUENCE     �   ALTER TABLE public.django_admin_log ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    257    5            �            1259    141710    django_content_type    TABLE     �   CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);
 '   DROP TABLE public.django_content_type;
       public         heap    postgres    false    5            �            1259    141709    django_content_type_id_seq    SEQUENCE     �   ALTER TABLE public.django_content_type ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    5    243            �            1259    141702    django_migrations    TABLE     �   CREATE TABLE public.django_migrations (
    id bigint NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);
 %   DROP TABLE public.django_migrations;
       public         heap    postgres    false    5            �            1259    141701    django_migrations_id_seq    SEQUENCE     �   ALTER TABLE public.django_migrations ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    241    5                       1259    141838    django_session    TABLE     �   CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);
 "   DROP TABLE public.django_session;
       public         heap    postgres    false    5                       1259    141856 	   point_map    TABLE     �   CREATE TABLE public.point_map (
    category character varying(20) NOT NULL,
    "position" character varying(20) NOT NULL,
    points integer
);
    DROP TABLE public.point_map;
       public         heap    postgres    false    5            !          0    27289    atlet 
   TABLE DATA           j   COPY badudu.atlet (id, tgl_lahir, negara_asal, play_right, height, world_rank, jenis_kelamin) FROM stdin;
    badudu          postgres    false    215   F      "          0    27292    atlet_ganda 
   TABLE DATA           c   COPY badudu.atlet_ganda (id_atlet_ganda, id_atlet_kualifikasi, id_atlet_kualifikasi_2) FROM stdin;
    badudu          postgres    false    216   �      #          0    27295    atlet_kualifikasi 
   TABLE DATA           R   COPY badudu.atlet_kualifikasi (id_atlet, world_rank, world_tour_rank) FROM stdin;
    badudu          postgres    false    217   �      $          0    27298    atlet_non_kualifikasi 
   TABLE DATA           9   COPY badudu.atlet_non_kualifikasi (id_atlet) FROM stdin;
    badudu          postgres    false    218   (      %          0    27301 &   atlet_nonkualifikasi_ujian_kualifikasi 
   TABLE DATA           v   COPY badudu.atlet_nonkualifikasi_ujian_kualifikasi (id_atlet, tahun, batch, tempat, tanggal, hasil_lulus) FROM stdin;
    badudu          postgres    false    219   �      &          0    27304    atlet_pelatih 
   TABLE DATA           =   COPY badudu.atlet_pelatih (id_pelatih, id_atlet) FROM stdin;
    badudu          postgres    false    220   �       '          0    27307    atlet_sponsor 
   TABLE DATA           U   COPY badudu.atlet_sponsor (id_atlet, id_sponsor, tgl_mulai, tgl_selesai) FROM stdin;
    badudu          postgres    false    221   �"      (          0    27310    event 
   TABLE DATA           �   COPY badudu.event (nama_event, tahun, nama_stadium, negara, tgl_mulai, tgl_selesai, kategori_superseries, total_hadiah) FROM stdin;
    badudu          postgres    false    222   %      )          0    27313    game 
   TABLE DATA           R   COPY badudu.game (no_game, durasi, jenis_babak, tanggal, waktu_mulai) FROM stdin;
    badudu          postgres    false    223   �%      *          0    27316    match 
   TABLE DATA           t   COPY badudu.match (jenis_babak, tanggal, waktu_mulai, total_durasi, nama_event, tahun_event, id_umpire) FROM stdin;
    badudu          postgres    false    224   �'      +          0    27319    member 
   TABLE DATA           1   COPY badudu.member (id, nama, email) FROM stdin;
    badudu          postgres    false    225   !*      ,          0    27322    partai_kompetisi 
   TABLE DATA           Q   COPY badudu.partai_kompetisi (jenis_partai, nama_event, tahun_event) FROM stdin;
    badudu          postgres    false    226   m1      -          0    27325    partai_peserta_kompetisi 
   TABLE DATA           h   COPY badudu.partai_peserta_kompetisi (jenis_partai, nama_event, tahun_event, nomor_peserta) FROM stdin;
    badudu          postgres    false    227   �1      .          0    27328    pelatih 
   TABLE DATA           4   COPY badudu.pelatih (id, tanggal_mulai) FROM stdin;
    badudu          postgres    false    228   �1      /          0    27331    pelatih_spesialisasi 
   TABLE DATA           K   COPY badudu.pelatih_spesialisasi (id_pelatih, id_spesialisasi) FROM stdin;
    badudu          postgres    false    229   �2      0          0    27334    peserta_kompetisi 
   TABLE DATA           }   COPY badudu.peserta_kompetisi (nomor_peserta, id_atlet_ganda, id_atlet_kualifikasi, world_rank, world_tour_rank) FROM stdin;
    badudu          postgres    false    230   �3      1          0    27337    peserta_mendaftar_event 
   TABLE DATA           S   COPY badudu.peserta_mendaftar_event (nomor_peserta, nama_event, tahun) FROM stdin;
    badudu          postgres    false    231   �5      2          0    27340    peserta_mengikuti_game 
   TABLE DATA           N   COPY badudu.peserta_mengikuti_game (nomor_peserta, no_game, skor) FROM stdin;
    badudu          postgres    false    232   16      3          0    27343    peserta_mengikuti_match 
   TABLE DATA           r   COPY badudu.peserta_mengikuti_match (jenis_babak, tanggal, waktu_mulai, nomor_peserta, status_menang) FROM stdin;
    badudu          postgres    false    233   8      4          0    27346    point_history 
   TABLE DATA           W   COPY badudu.point_history (id_atlet, minggu_ke, bulan, tahun, total_point) FROM stdin;
    badudu          postgres    false    234   �:      5          0    27349    spesialisasi 
   TABLE DATA           8   COPY badudu.spesialisasi (id, spesialisasi) FROM stdin;
    badudu          postgres    false    235   �<      6          0    27352    sponsor 
   TABLE DATA           M   COPY badudu.sponsor (id, nama_brand, website, cp_name, cp_email) FROM stdin;
    badudu          postgres    false    236   �=      7          0    27355    stadium 
   TABLE DATA           B   COPY badudu.stadium (nama, alamat, kapasitas, negara) FROM stdin;
    badudu          postgres    false    237   `?      8          0    27359    ujian_kualifikasi 
   TABLE DATA           J   COPY badudu.ujian_kualifikasi (tahun, batch, tempat, tanggal) FROM stdin;
    badudu          postgres    false    238   F@      9          0    27362    umpire 
   TABLE DATA           ,   COPY badudu.umpire (id, negara) FROM stdin;
    badudu          postgres    false    239   �@      A          0    141724 
   auth_group 
   TABLE DATA           .   COPY public.auth_group (id, name) FROM stdin;
    public          postgres    false    247   �A      C          0    141732    auth_group_permissions 
   TABLE DATA           M   COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
    public          postgres    false    249   �A      ?          0    141718    auth_permission 
   TABLE DATA           N   COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
    public          postgres    false    245   �A      E          0    141738 	   auth_user 
   TABLE DATA           �   COPY public.auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
    public          postgres    false    251   �B      G          0    141746    auth_user_groups 
   TABLE DATA           A   COPY public.auth_user_groups (id, user_id, group_id) FROM stdin;
    public          postgres    false    253   �B      I          0    141752    auth_user_user_permissions 
   TABLE DATA           P   COPY public.auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
    public          postgres    false    255   C      K          0    141810    django_admin_log 
   TABLE DATA           �   COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
    public          postgres    false    257   4C      =          0    141710    django_content_type 
   TABLE DATA           C   COPY public.django_content_type (id, app_label, model) FROM stdin;
    public          postgres    false    243   QC      ;          0    141702    django_migrations 
   TABLE DATA           C   COPY public.django_migrations (id, app, name, applied) FROM stdin;
    public          postgres    false    241   �C      L          0    141838    django_session 
   TABLE DATA           P   COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
    public          postgres    false    258   dE      M          0    141856 	   point_map 
   TABLE DATA           A   COPY public.point_map (category, "position", points) FROM stdin;
    public          postgres    false    259   �E      V           0    0    auth_group_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);
          public          postgres    false    246            W           0    0    auth_group_permissions_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);
          public          postgres    false    248            X           0    0    auth_permission_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.auth_permission_id_seq', 24, true);
          public          postgres    false    244            Y           0    0    auth_user_groups_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 1, false);
          public          postgres    false    252            Z           0    0    auth_user_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.auth_user_id_seq', 1, false);
          public          postgres    false    250            [           0    0 !   auth_user_user_permissions_id_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 1, false);
          public          postgres    false    254            \           0    0    django_admin_log_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.django_admin_log_id_seq', 1, false);
          public          postgres    false    256            ]           0    0    django_content_type_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.django_content_type_id_seq', 6, true);
          public          postgres    false    242            ^           0    0    django_migrations_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.django_migrations_id_seq', 18, true);
          public          postgres    false    240                       2606    27366    atlet_ganda atlet_ganda_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY badudu.atlet_ganda
    ADD CONSTRAINT atlet_ganda_pkey PRIMARY KEY (id_atlet_ganda);
 F   ALTER TABLE ONLY badudu.atlet_ganda DROP CONSTRAINT atlet_ganda_pkey;
       badudu            postgres    false    216                       2606    27368 (   atlet_kualifikasi atlet_kualifikasi_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY badudu.atlet_kualifikasi
    ADD CONSTRAINT atlet_kualifikasi_pkey PRIMARY KEY (id_atlet);
 R   ALTER TABLE ONLY badudu.atlet_kualifikasi DROP CONSTRAINT atlet_kualifikasi_pkey;
       badudu            postgres    false    217                       2606    27370 0   atlet_non_kualifikasi atlet_non_kualifikasi_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY badudu.atlet_non_kualifikasi
    ADD CONSTRAINT atlet_non_kualifikasi_pkey PRIMARY KEY (id_atlet);
 Z   ALTER TABLE ONLY badudu.atlet_non_kualifikasi DROP CONSTRAINT atlet_non_kualifikasi_pkey;
       badudu            postgres    false    218                       2606    27372 R   atlet_nonkualifikasi_ujian_kualifikasi atlet_nonkualifikasi_ujian_kualifikasi_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY badudu.atlet_nonkualifikasi_ujian_kualifikasi
    ADD CONSTRAINT atlet_nonkualifikasi_ujian_kualifikasi_pkey PRIMARY KEY (id_atlet, tahun, batch, tempat, tanggal, hasil_lulus);
 |   ALTER TABLE ONLY badudu.atlet_nonkualifikasi_ujian_kualifikasi DROP CONSTRAINT atlet_nonkualifikasi_ujian_kualifikasi_pkey;
       badudu            postgres    false    219    219    219    219    219    219                       2606    27374     atlet_pelatih atlet_pelatih_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY badudu.atlet_pelatih
    ADD CONSTRAINT atlet_pelatih_pkey PRIMARY KEY (id_pelatih, id_atlet);
 J   ALTER TABLE ONLY badudu.atlet_pelatih DROP CONSTRAINT atlet_pelatih_pkey;
       badudu            postgres    false    220    220            	           2606    27376    atlet atlet_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY badudu.atlet
    ADD CONSTRAINT atlet_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY badudu.atlet DROP CONSTRAINT atlet_pkey;
       badudu            postgres    false    215                       2606    27378     atlet_sponsor atlet_sponsor_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY badudu.atlet_sponsor
    ADD CONSTRAINT atlet_sponsor_pkey PRIMARY KEY (id_atlet, id_sponsor);
 J   ALTER TABLE ONLY badudu.atlet_sponsor DROP CONSTRAINT atlet_sponsor_pkey;
       badudu            postgres    false    221    221                       2606    27380    event event_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY badudu.event
    ADD CONSTRAINT event_pkey PRIMARY KEY (nama_event, tahun);
 :   ALTER TABLE ONLY badudu.event DROP CONSTRAINT event_pkey;
       badudu            postgres    false    222    222                       2606    27382    game game_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY badudu.game
    ADD CONSTRAINT game_pkey PRIMARY KEY (no_game);
 8   ALTER TABLE ONLY badudu.game DROP CONSTRAINT game_pkey;
       badudu            postgres    false    223                       2606    27384    match match_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY badudu.match
    ADD CONSTRAINT match_pkey PRIMARY KEY (jenis_babak, tanggal, waktu_mulai);
 :   ALTER TABLE ONLY badudu.match DROP CONSTRAINT match_pkey;
       badudu            postgres    false    224    224    224                       2606    27386    member member_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY badudu.member
    ADD CONSTRAINT member_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY badudu.member DROP CONSTRAINT member_pkey;
       badudu            postgres    false    225                       2606    27388 &   partai_kompetisi partai_kompetisi_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY badudu.partai_kompetisi
    ADD CONSTRAINT partai_kompetisi_pkey PRIMARY KEY (jenis_partai, nama_event, tahun_event);
 P   ALTER TABLE ONLY badudu.partai_kompetisi DROP CONSTRAINT partai_kompetisi_pkey;
       badudu            postgres    false    226    226    226            !           2606    27390 6   partai_peserta_kompetisi partai_peserta_kompetisi_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY badudu.partai_peserta_kompetisi
    ADD CONSTRAINT partai_peserta_kompetisi_pkey PRIMARY KEY (jenis_partai, nama_event, tahun_event, nomor_peserta);
 `   ALTER TABLE ONLY badudu.partai_peserta_kompetisi DROP CONSTRAINT partai_peserta_kompetisi_pkey;
       badudu            postgres    false    227    227    227    227            #           2606    27392    pelatih pelatih_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY badudu.pelatih
    ADD CONSTRAINT pelatih_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY badudu.pelatih DROP CONSTRAINT pelatih_pkey;
       badudu            postgres    false    228            %           2606    27394 .   pelatih_spesialisasi pelatih_spesialisasi_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY badudu.pelatih_spesialisasi
    ADD CONSTRAINT pelatih_spesialisasi_pkey PRIMARY KEY (id_pelatih, id_spesialisasi);
 X   ALTER TABLE ONLY badudu.pelatih_spesialisasi DROP CONSTRAINT pelatih_spesialisasi_pkey;
       badudu            postgres    false    229    229            '           2606    27396 (   peserta_kompetisi peserta_kompetisi_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY badudu.peserta_kompetisi
    ADD CONSTRAINT peserta_kompetisi_pkey PRIMARY KEY (nomor_peserta);
 R   ALTER TABLE ONLY badudu.peserta_kompetisi DROP CONSTRAINT peserta_kompetisi_pkey;
       badudu            postgres    false    230            )           2606    27398 4   peserta_mendaftar_event peserta_mendaftar_event_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY badudu.peserta_mendaftar_event
    ADD CONSTRAINT peserta_mendaftar_event_pkey PRIMARY KEY (nomor_peserta, nama_event, tahun);
 ^   ALTER TABLE ONLY badudu.peserta_mendaftar_event DROP CONSTRAINT peserta_mendaftar_event_pkey;
       badudu            postgres    false    231    231    231            +           2606    27400 2   peserta_mengikuti_game peserta_mengikuti_game_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY badudu.peserta_mengikuti_game
    ADD CONSTRAINT peserta_mengikuti_game_pkey PRIMARY KEY (nomor_peserta, no_game);
 \   ALTER TABLE ONLY badudu.peserta_mengikuti_game DROP CONSTRAINT peserta_mengikuti_game_pkey;
       badudu            postgres    false    232    232            -           2606    27402 4   peserta_mengikuti_match peserta_mengikuti_match_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY badudu.peserta_mengikuti_match
    ADD CONSTRAINT peserta_mengikuti_match_pkey PRIMARY KEY (jenis_babak, tanggal, waktu_mulai, nomor_peserta);
 ^   ALTER TABLE ONLY badudu.peserta_mengikuti_match DROP CONSTRAINT peserta_mengikuti_match_pkey;
       badudu            postgres    false    233    233    233    233            /           2606    27404     point_history point_history_pkey 
   CONSTRAINT     }   ALTER TABLE ONLY badudu.point_history
    ADD CONSTRAINT point_history_pkey PRIMARY KEY (id_atlet, minggu_ke, bulan, tahun);
 J   ALTER TABLE ONLY badudu.point_history DROP CONSTRAINT point_history_pkey;
       badudu            postgres    false    234    234    234    234            1           2606    27406    spesialisasi spesialisasi_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY badudu.spesialisasi
    ADD CONSTRAINT spesialisasi_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY badudu.spesialisasi DROP CONSTRAINT spesialisasi_pkey;
       badudu            postgres    false    235            3           2606    27408    sponsor sponsor_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY badudu.sponsor
    ADD CONSTRAINT sponsor_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY badudu.sponsor DROP CONSTRAINT sponsor_pkey;
       badudu            postgres    false    236            5           2606    27410    stadium stadium_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY badudu.stadium
    ADD CONSTRAINT stadium_pkey PRIMARY KEY (nama);
 >   ALTER TABLE ONLY badudu.stadium DROP CONSTRAINT stadium_pkey;
       badudu            postgres    false    237            7           2606    27412 (   ujian_kualifikasi ujian_kualifikasi_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY badudu.ujian_kualifikasi
    ADD CONSTRAINT ujian_kualifikasi_pkey PRIMARY KEY (tahun, batch, tempat, tanggal);
 R   ALTER TABLE ONLY badudu.ujian_kualifikasi DROP CONSTRAINT ujian_kualifikasi_pkey;
       badudu            postgres    false    238    238    238    238            9           2606    27414    umpire umpire_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY badudu.umpire
    ADD CONSTRAINT umpire_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY badudu.umpire DROP CONSTRAINT umpire_pkey;
       badudu            postgres    false    239            G           2606    141836    auth_group auth_group_name_key 
   CONSTRAINT     Y   ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);
 H   ALTER TABLE ONLY public.auth_group DROP CONSTRAINT auth_group_name_key;
       public            postgres    false    247            L           2606    141767 R   auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq 
   CONSTRAINT     �   ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);
 |   ALTER TABLE ONLY public.auth_group_permissions DROP CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq;
       public            postgres    false    249    249            O           2606    141736 2   auth_group_permissions auth_group_permissions_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.auth_group_permissions DROP CONSTRAINT auth_group_permissions_pkey;
       public            postgres    false    249            I           2606    141728    auth_group auth_group_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.auth_group DROP CONSTRAINT auth_group_pkey;
       public            postgres    false    247            B           2606    141758 F   auth_permission auth_permission_content_type_id_codename_01ab375a_uniq 
   CONSTRAINT     �   ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);
 p   ALTER TABLE ONLY public.auth_permission DROP CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq;
       public            postgres    false    245    245            D           2606    141722 $   auth_permission auth_permission_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.auth_permission DROP CONSTRAINT auth_permission_pkey;
       public            postgres    false    245            W           2606    141750 &   auth_user_groups auth_user_groups_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.auth_user_groups DROP CONSTRAINT auth_user_groups_pkey;
       public            postgres    false    253            Z           2606    141782 @   auth_user_groups auth_user_groups_user_id_group_id_94350c0c_uniq 
   CONSTRAINT     �   ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);
 j   ALTER TABLE ONLY public.auth_user_groups DROP CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq;
       public            postgres    false    253    253            Q           2606    141742    auth_user auth_user_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.auth_user DROP CONSTRAINT auth_user_pkey;
       public            postgres    false    251            ]           2606    141756 :   auth_user_user_permissions auth_user_user_permissions_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);
 d   ALTER TABLE ONLY public.auth_user_user_permissions DROP CONSTRAINT auth_user_user_permissions_pkey;
       public            postgres    false    255            `           2606    141796 Y   auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_14a6b632_uniq 
   CONSTRAINT     �   ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);
 �   ALTER TABLE ONLY public.auth_user_user_permissions DROP CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq;
       public            postgres    false    255    255            T           2606    141831     auth_user auth_user_username_key 
   CONSTRAINT     _   ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);
 J   ALTER TABLE ONLY public.auth_user DROP CONSTRAINT auth_user_username_key;
       public            postgres    false    251            c           2606    141817 &   django_admin_log django_admin_log_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.django_admin_log DROP CONSTRAINT django_admin_log_pkey;
       public            postgres    false    257            =           2606    141716 E   django_content_type django_content_type_app_label_model_76bd3d3b_uniq 
   CONSTRAINT     �   ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);
 o   ALTER TABLE ONLY public.django_content_type DROP CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq;
       public            postgres    false    243    243            ?           2606    141714 ,   django_content_type django_content_type_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.django_content_type DROP CONSTRAINT django_content_type_pkey;
       public            postgres    false    243            ;           2606    141708 (   django_migrations django_migrations_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.django_migrations DROP CONSTRAINT django_migrations_pkey;
       public            postgres    false    241            g           2606    141844 "   django_session django_session_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);
 L   ALTER TABLE ONLY public.django_session DROP CONSTRAINT django_session_pkey;
       public            postgres    false    258            j           2606    141860    point_map point_map_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.point_map
    ADD CONSTRAINT point_map_pkey PRIMARY KEY (category, "position");
 B   ALTER TABLE ONLY public.point_map DROP CONSTRAINT point_map_pkey;
       public            postgres    false    259    259            E           1259    141837    auth_group_name_a6ea08ec_like    INDEX     h   CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);
 1   DROP INDEX public.auth_group_name_a6ea08ec_like;
       public            postgres    false    247            J           1259    141778 (   auth_group_permissions_group_id_b120cbf9    INDEX     o   CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);
 <   DROP INDEX public.auth_group_permissions_group_id_b120cbf9;
       public            postgres    false    249            M           1259    141779 -   auth_group_permissions_permission_id_84c5c92e    INDEX     y   CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);
 A   DROP INDEX public.auth_group_permissions_permission_id_84c5c92e;
       public            postgres    false    249            @           1259    141764 (   auth_permission_content_type_id_2f476e4b    INDEX     o   CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);
 <   DROP INDEX public.auth_permission_content_type_id_2f476e4b;
       public            postgres    false    245            U           1259    141794 "   auth_user_groups_group_id_97559544    INDEX     c   CREATE INDEX auth_user_groups_group_id_97559544 ON public.auth_user_groups USING btree (group_id);
 6   DROP INDEX public.auth_user_groups_group_id_97559544;
       public            postgres    false    253            X           1259    141793 !   auth_user_groups_user_id_6a12ed8b    INDEX     a   CREATE INDEX auth_user_groups_user_id_6a12ed8b ON public.auth_user_groups USING btree (user_id);
 5   DROP INDEX public.auth_user_groups_user_id_6a12ed8b;
       public            postgres    false    253            [           1259    141808 1   auth_user_user_permissions_permission_id_1fbb5f2c    INDEX     �   CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON public.auth_user_user_permissions USING btree (permission_id);
 E   DROP INDEX public.auth_user_user_permissions_permission_id_1fbb5f2c;
       public            postgres    false    255            ^           1259    141807 +   auth_user_user_permissions_user_id_a95ead1b    INDEX     u   CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON public.auth_user_user_permissions USING btree (user_id);
 ?   DROP INDEX public.auth_user_user_permissions_user_id_a95ead1b;
       public            postgres    false    255            R           1259    141832     auth_user_username_6821ab7c_like    INDEX     n   CREATE INDEX auth_user_username_6821ab7c_like ON public.auth_user USING btree (username varchar_pattern_ops);
 4   DROP INDEX public.auth_user_username_6821ab7c_like;
       public            postgres    false    251            a           1259    141828 )   django_admin_log_content_type_id_c4bce8eb    INDEX     q   CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);
 =   DROP INDEX public.django_admin_log_content_type_id_c4bce8eb;
       public            postgres    false    257            d           1259    141829 !   django_admin_log_user_id_c564eba6    INDEX     a   CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);
 5   DROP INDEX public.django_admin_log_user_id_c564eba6;
       public            postgres    false    257            e           1259    141846 #   django_session_expire_date_a5c62663    INDEX     e   CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);
 7   DROP INDEX public.django_session_expire_date_a5c62663;
       public            postgres    false    258            h           1259    141845 (   django_session_session_key_c0390e0f_like    INDEX     ~   CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);
 <   DROP INDEX public.django_session_session_key_c0390e0f_like;
       public            postgres    false    258            �           2620    141855 '   point_history world_rank_update_trigger    TRIGGER     �   CREATE TRIGGER world_rank_update_trigger AFTER INSERT OR UPDATE ON badudu.point_history FOR EACH ROW EXECUTE FUNCTION public.update_world_rank();
 @   DROP TRIGGER world_rank_update_trigger ON badudu.point_history;
       badudu          postgres    false    234    272            l           2606    27415 3   atlet_ganda atlet_ganda_id_atlet_kualifikasi_2_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY badudu.atlet_ganda
    ADD CONSTRAINT atlet_ganda_id_atlet_kualifikasi_2_fkey FOREIGN KEY (id_atlet_kualifikasi_2) REFERENCES badudu.atlet_kualifikasi(id_atlet);
 ]   ALTER TABLE ONLY badudu.atlet_ganda DROP CONSTRAINT atlet_ganda_id_atlet_kualifikasi_2_fkey;
       badudu          postgres    false    3597    216    217            m           2606    27420 1   atlet_ganda atlet_ganda_id_atlet_kualifikasi_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY badudu.atlet_ganda
    ADD CONSTRAINT atlet_ganda_id_atlet_kualifikasi_fkey FOREIGN KEY (id_atlet_kualifikasi) REFERENCES badudu.atlet_kualifikasi(id_atlet);
 [   ALTER TABLE ONLY badudu.atlet_ganda DROP CONSTRAINT atlet_ganda_id_atlet_kualifikasi_fkey;
       badudu          postgres    false    3597    216    217            k           2606    27425    atlet atlet_id_fkey    FK CONSTRAINT     n   ALTER TABLE ONLY badudu.atlet
    ADD CONSTRAINT atlet_id_fkey FOREIGN KEY (id) REFERENCES badudu.member(id);
 =   ALTER TABLE ONLY badudu.atlet DROP CONSTRAINT atlet_id_fkey;
       badudu          postgres    false    225    215    3613            n           2606    27430 1   atlet_kualifikasi atlet_kualifikasi_id_atlet_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY badudu.atlet_kualifikasi
    ADD CONSTRAINT atlet_kualifikasi_id_atlet_fkey FOREIGN KEY (id_atlet) REFERENCES badudu.atlet(id);
 [   ALTER TABLE ONLY badudu.atlet_kualifikasi DROP CONSTRAINT atlet_kualifikasi_id_atlet_fkey;
       badudu          postgres    false    3593    217    215            o           2606    27435 9   atlet_non_kualifikasi atlet_non_kualifikasi_id_atlet_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY badudu.atlet_non_kualifikasi
    ADD CONSTRAINT atlet_non_kualifikasi_id_atlet_fkey FOREIGN KEY (id_atlet) REFERENCES badudu.atlet(id);
 c   ALTER TABLE ONLY badudu.atlet_non_kualifikasi DROP CONSTRAINT atlet_non_kualifikasi_id_atlet_fkey;
       badudu          postgres    false    215    218    3593            p           2606    27440 f   atlet_nonkualifikasi_ujian_kualifikasi atlet_nonkualifikasi_ujian_kual_tahun_batch_tempat_tanggal_fkey    FK CONSTRAINT       ALTER TABLE ONLY badudu.atlet_nonkualifikasi_ujian_kualifikasi
    ADD CONSTRAINT atlet_nonkualifikasi_ujian_kual_tahun_batch_tempat_tanggal_fkey FOREIGN KEY (tahun, batch, tempat, tanggal) REFERENCES badudu.ujian_kualifikasi(tahun, batch, tempat, tanggal);
 �   ALTER TABLE ONLY badudu.atlet_nonkualifikasi_ujian_kualifikasi DROP CONSTRAINT atlet_nonkualifikasi_ujian_kual_tahun_batch_tempat_tanggal_fkey;
       badudu          postgres    false    238    238    238    238    219    219    219    219    3639            q           2606    27445 [   atlet_nonkualifikasi_ujian_kualifikasi atlet_nonkualifikasi_ujian_kualifikasi_id_atlet_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY badudu.atlet_nonkualifikasi_ujian_kualifikasi
    ADD CONSTRAINT atlet_nonkualifikasi_ujian_kualifikasi_id_atlet_fkey FOREIGN KEY (id_atlet) REFERENCES badudu.atlet_non_kualifikasi(id_atlet);
 �   ALTER TABLE ONLY badudu.atlet_nonkualifikasi_ujian_kualifikasi DROP CONSTRAINT atlet_nonkualifikasi_ujian_kualifikasi_id_atlet_fkey;
       badudu          postgres    false    218    3599    219            r           2606    27450 )   atlet_pelatih atlet_pelatih_id_atlet_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY badudu.atlet_pelatih
    ADD CONSTRAINT atlet_pelatih_id_atlet_fkey FOREIGN KEY (id_atlet) REFERENCES badudu.atlet(id);
 S   ALTER TABLE ONLY badudu.atlet_pelatih DROP CONSTRAINT atlet_pelatih_id_atlet_fkey;
       badudu          postgres    false    3593    215    220            s           2606    27455 +   atlet_pelatih atlet_pelatih_id_pelatih_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY badudu.atlet_pelatih
    ADD CONSTRAINT atlet_pelatih_id_pelatih_fkey FOREIGN KEY (id_pelatih) REFERENCES badudu.pelatih(id);
 U   ALTER TABLE ONLY badudu.atlet_pelatih DROP CONSTRAINT atlet_pelatih_id_pelatih_fkey;
       badudu          postgres    false    3619    220    228            t           2606    27460 )   atlet_sponsor atlet_sponsor_id_atlet_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY badudu.atlet_sponsor
    ADD CONSTRAINT atlet_sponsor_id_atlet_fkey FOREIGN KEY (id_atlet) REFERENCES badudu.atlet(id);
 S   ALTER TABLE ONLY badudu.atlet_sponsor DROP CONSTRAINT atlet_sponsor_id_atlet_fkey;
       badudu          postgres    false    3593    221    215            u           2606    27465 +   atlet_sponsor atlet_sponsor_id_sponsor_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY badudu.atlet_sponsor
    ADD CONSTRAINT atlet_sponsor_id_sponsor_fkey FOREIGN KEY (id_sponsor) REFERENCES badudu.sponsor(id);
 U   ALTER TABLE ONLY badudu.atlet_sponsor DROP CONSTRAINT atlet_sponsor_id_sponsor_fkey;
       badudu          postgres    false    221    236    3635            v           2606    27470 .   game game_jenis_babak_tanggal_waktu_mulai_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY badudu.game
    ADD CONSTRAINT game_jenis_babak_tanggal_waktu_mulai_fkey FOREIGN KEY (jenis_babak, tanggal, waktu_mulai) REFERENCES badudu.match(jenis_babak, tanggal, waktu_mulai);
 X   ALTER TABLE ONLY badudu.game DROP CONSTRAINT game_jenis_babak_tanggal_waktu_mulai_fkey;
       badudu          postgres    false    224    3611    224    224    223    223    223            w           2606    27475    match match_id_umpire_fkey    FK CONSTRAINT     |   ALTER TABLE ONLY badudu.match
    ADD CONSTRAINT match_id_umpire_fkey FOREIGN KEY (id_umpire) REFERENCES badudu.umpire(id);
 D   ALTER TABLE ONLY badudu.match DROP CONSTRAINT match_id_umpire_fkey;
       badudu          postgres    false    224    3641    239            x           2606    27480 '   match match_nama_event_tahun_event_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY badudu.match
    ADD CONSTRAINT match_nama_event_tahun_event_fkey FOREIGN KEY (nama_event, tahun_event) REFERENCES badudu.event(nama_event, tahun);
 Q   ALTER TABLE ONLY badudu.match DROP CONSTRAINT match_nama_event_tahun_event_fkey;
       badudu          postgres    false    222    224    224    3607    222            y           2606    27485 =   partai_kompetisi partai_kompetisi_nama_event_tahun_event_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY badudu.partai_kompetisi
    ADD CONSTRAINT partai_kompetisi_nama_event_tahun_event_fkey FOREIGN KEY (nama_event, tahun_event) REFERENCES badudu.event(nama_event, tahun);
 g   ALTER TABLE ONLY badudu.partai_kompetisi DROP CONSTRAINT partai_kompetisi_nama_event_tahun_event_fkey;
       badudu          postgres    false    226    222    222    3607    226            z           2606    27490 X   partai_peserta_kompetisi partai_peserta_kompetisi_jenis_partai_nama_event_tahun_eve_fkey    FK CONSTRAINT       ALTER TABLE ONLY badudu.partai_peserta_kompetisi
    ADD CONSTRAINT partai_peserta_kompetisi_jenis_partai_nama_event_tahun_eve_fkey FOREIGN KEY (jenis_partai, nama_event, tahun_event) REFERENCES badudu.partai_kompetisi(jenis_partai, nama_event, tahun_event);
 �   ALTER TABLE ONLY badudu.partai_peserta_kompetisi DROP CONSTRAINT partai_peserta_kompetisi_jenis_partai_nama_event_tahun_eve_fkey;
       badudu          postgres    false    226    3615    226    226    227    227    227            {           2606    27495 D   partai_peserta_kompetisi partai_peserta_kompetisi_nomor_peserta_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY badudu.partai_peserta_kompetisi
    ADD CONSTRAINT partai_peserta_kompetisi_nomor_peserta_fkey FOREIGN KEY (nomor_peserta) REFERENCES badudu.peserta_kompetisi(nomor_peserta);
 n   ALTER TABLE ONLY badudu.partai_peserta_kompetisi DROP CONSTRAINT partai_peserta_kompetisi_nomor_peserta_fkey;
       badudu          postgres    false    3623    230    227            |           2606    27500    pelatih pelatih_id_fkey    FK CONSTRAINT     r   ALTER TABLE ONLY badudu.pelatih
    ADD CONSTRAINT pelatih_id_fkey FOREIGN KEY (id) REFERENCES badudu.member(id);
 A   ALTER TABLE ONLY badudu.pelatih DROP CONSTRAINT pelatih_id_fkey;
       badudu          postgres    false    3613    225    228            }           2606    27505 9   pelatih_spesialisasi pelatih_spesialisasi_id_pelatih_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY badudu.pelatih_spesialisasi
    ADD CONSTRAINT pelatih_spesialisasi_id_pelatih_fkey FOREIGN KEY (id_pelatih) REFERENCES badudu.pelatih(id);
 c   ALTER TABLE ONLY badudu.pelatih_spesialisasi DROP CONSTRAINT pelatih_spesialisasi_id_pelatih_fkey;
       badudu          postgres    false    3619    228    229            ~           2606    27510 >   pelatih_spesialisasi pelatih_spesialisasi_id_spesialisasi_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY badudu.pelatih_spesialisasi
    ADD CONSTRAINT pelatih_spesialisasi_id_spesialisasi_fkey FOREIGN KEY (id_spesialisasi) REFERENCES badudu.spesialisasi(id);
 h   ALTER TABLE ONLY badudu.pelatih_spesialisasi DROP CONSTRAINT pelatih_spesialisasi_id_spesialisasi_fkey;
       badudu          postgres    false    229    3633    235                       2606    27515 7   peserta_kompetisi peserta_kompetisi_id_atlet_ganda_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY badudu.peserta_kompetisi
    ADD CONSTRAINT peserta_kompetisi_id_atlet_ganda_fkey FOREIGN KEY (id_atlet_ganda) REFERENCES badudu.atlet_ganda(id_atlet_ganda);
 a   ALTER TABLE ONLY badudu.peserta_kompetisi DROP CONSTRAINT peserta_kompetisi_id_atlet_ganda_fkey;
       badudu          postgres    false    216    230    3595            �           2606    27520 =   peserta_kompetisi peserta_kompetisi_id_atlet_kualifikasi_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY badudu.peserta_kompetisi
    ADD CONSTRAINT peserta_kompetisi_id_atlet_kualifikasi_fkey FOREIGN KEY (id_atlet_kualifikasi) REFERENCES badudu.atlet_kualifikasi(id_atlet);
 g   ALTER TABLE ONLY badudu.peserta_kompetisi DROP CONSTRAINT peserta_kompetisi_id_atlet_kualifikasi_fkey;
       badudu          postgres    false    217    3597    230            �           2606    27525 E   peserta_mendaftar_event peserta_mendaftar_event_nama_event_tahun_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY badudu.peserta_mendaftar_event
    ADD CONSTRAINT peserta_mendaftar_event_nama_event_tahun_fkey FOREIGN KEY (nama_event, tahun) REFERENCES badudu.event(nama_event, tahun);
 o   ALTER TABLE ONLY badudu.peserta_mendaftar_event DROP CONSTRAINT peserta_mendaftar_event_nama_event_tahun_fkey;
       badudu          postgres    false    231    222    3607    231    222            �           2606    27530 B   peserta_mendaftar_event peserta_mendaftar_event_nomor_peserta_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY badudu.peserta_mendaftar_event
    ADD CONSTRAINT peserta_mendaftar_event_nomor_peserta_fkey FOREIGN KEY (nomor_peserta) REFERENCES badudu.peserta_kompetisi(nomor_peserta);
 l   ALTER TABLE ONLY badudu.peserta_mendaftar_event DROP CONSTRAINT peserta_mendaftar_event_nomor_peserta_fkey;
       badudu          postgres    false    3623    231    230            �           2606    27535 :   peserta_mengikuti_game peserta_mengikuti_game_no_game_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY badudu.peserta_mengikuti_game
    ADD CONSTRAINT peserta_mengikuti_game_no_game_fkey FOREIGN KEY (no_game) REFERENCES badudu.game(no_game);
 d   ALTER TABLE ONLY badudu.peserta_mengikuti_game DROP CONSTRAINT peserta_mengikuti_game_no_game_fkey;
       badudu          postgres    false    3609    223    232            �           2606    27540 @   peserta_mengikuti_game peserta_mengikuti_game_nomor_peserta_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY badudu.peserta_mengikuti_game
    ADD CONSTRAINT peserta_mengikuti_game_nomor_peserta_fkey FOREIGN KEY (nomor_peserta) REFERENCES badudu.peserta_kompetisi(nomor_peserta);
 j   ALTER TABLE ONLY badudu.peserta_mengikuti_game DROP CONSTRAINT peserta_mengikuti_game_nomor_peserta_fkey;
       badudu          postgres    false    230    3623    232            �           2606    27545 T   peserta_mengikuti_match peserta_mengikuti_match_jenis_babak_tanggal_waktu_mulai_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY badudu.peserta_mengikuti_match
    ADD CONSTRAINT peserta_mengikuti_match_jenis_babak_tanggal_waktu_mulai_fkey FOREIGN KEY (jenis_babak, tanggal, waktu_mulai) REFERENCES badudu.match(jenis_babak, tanggal, waktu_mulai);
 ~   ALTER TABLE ONLY badudu.peserta_mengikuti_match DROP CONSTRAINT peserta_mengikuti_match_jenis_babak_tanggal_waktu_mulai_fkey;
       badudu          postgres    false    233    3611    224    224    224    233    233            �           2606    27550 B   peserta_mengikuti_match peserta_mengikuti_match_nomor_peserta_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY badudu.peserta_mengikuti_match
    ADD CONSTRAINT peserta_mengikuti_match_nomor_peserta_fkey FOREIGN KEY (nomor_peserta) REFERENCES badudu.peserta_kompetisi(nomor_peserta);
 l   ALTER TABLE ONLY badudu.peserta_mengikuti_match DROP CONSTRAINT peserta_mengikuti_match_nomor_peserta_fkey;
       badudu          postgres    false    233    3623    230            �           2606    27555 )   point_history point_history_id_atlet_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY badudu.point_history
    ADD CONSTRAINT point_history_id_atlet_fkey FOREIGN KEY (id_atlet) REFERENCES badudu.atlet(id);
 S   ALTER TABLE ONLY badudu.point_history DROP CONSTRAINT point_history_id_atlet_fkey;
       badudu          postgres    false    234    3593    215            �           2606    27560    umpire umpire_id_fkey    FK CONSTRAINT     p   ALTER TABLE ONLY badudu.umpire
    ADD CONSTRAINT umpire_id_fkey FOREIGN KEY (id) REFERENCES badudu.member(id);
 ?   ALTER TABLE ONLY badudu.umpire DROP CONSTRAINT umpire_id_fkey;
       badudu          postgres    false    225    239    3613            �           2606    141773 O   auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm    FK CONSTRAINT     �   ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;
 y   ALTER TABLE ONLY public.auth_group_permissions DROP CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm;
       public          postgres    false    245    3652    249            �           2606    141768 P   auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;
 z   ALTER TABLE ONLY public.auth_group_permissions DROP CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id;
       public          postgres    false    249    3657    247            �           2606    141759 E   auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co    FK CONSTRAINT     �   ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;
 o   ALTER TABLE ONLY public.auth_permission DROP CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co;
       public          postgres    false    3647    245    243            �           2606    141788 D   auth_user_groups auth_user_groups_group_id_97559544_fk_auth_group_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;
 n   ALTER TABLE ONLY public.auth_user_groups DROP CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id;
       public          postgres    false    247    253    3657            �           2606    141783 B   auth_user_groups auth_user_groups_user_id_6a12ed8b_fk_auth_user_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;
 l   ALTER TABLE ONLY public.auth_user_groups DROP CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id;
       public          postgres    false    3665    253    251            �           2606    141802 S   auth_user_user_permissions auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm    FK CONSTRAINT     �   ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;
 }   ALTER TABLE ONLY public.auth_user_user_permissions DROP CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm;
       public          postgres    false    245    255    3652            �           2606    141797 V   auth_user_user_permissions auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;
 �   ALTER TABLE ONLY public.auth_user_user_permissions DROP CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id;
       public          postgres    false    3665    251    255            �           2606    141818 G   django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co    FK CONSTRAINT     �   ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;
 q   ALTER TABLE ONLY public.django_admin_log DROP CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co;
       public          postgres    false    3647    243    257            �           2606    141823 B   django_admin_log django_admin_log_user_id_c564eba6_fk_auth_user_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;
 l   ALTER TABLE ONLY public.django_admin_log DROP CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id;
       public          postgres    false    251    257    3665            !   *  x�]U�nTG]���?PQWw�k	(A��"�첩~�7�h<!_��wE�h,1�u�=\�tOΆI2b�2�נ���ZVåX��ؙߏ�y�ۻ��ǳ9�ְ5���6:ʣu�:�J��YS��P&�ɲ���t~�׃���̼�:Cw�SpCH�T�I��Z�{ɶ,G6��oy�������	 �:R
�S�\HDi�|���;��[����q�c�����^@�Yo8���QqP�F:��h�ד�q���ټzy>����.L0���8v��e�[;R)�B��w�A�.��nqּ�N[���Dg"�(��.D�ΒX���B��Uͳ�� �B0�~�*�X�Y�B�L�bc �J5X��>�X`2���q����ǝI���·������E(��+J��8b^ o_���zЫ�eYl5�Sb�E�1Q��P�\xQ��C�_Y�73jQ�^����U�	t촐����%6�7zԾ둲�=jڳK>�Oh!��|j3��b�1/.~�Z2���H�|���hW�+I�@y1JQ����G.d#ykގ�g=~��t���*w���kP��E�S�X��-E��t�c;��k9�m^P6�u�tZ��q�}���^L]ɂ�a]�`�x͖G	T�d�B(�Rk}���׾!9��}�m�5㕈�Z`�Jc��P����?�M��:��yw�÷��+����G���pa�Jkuj�C�e|�5دO��v���8���!�#ɼ���h������D]�5	`���QZUqWmny3e�8<\XE��f}�)W�����������i�R"Og�A`�D�P*.bp�v6V���y�<lG�
��}mf��$#Ƣ�V�g����zq&�l>�<?_W��b�h>̐{�Q�
d���M**�#9�k�r%�|�qZ�����w�3Q���|Q#�2A	����Vau������H𢒑�Zb%?�]��~m�����+�.���=�7 �KL;c�v�Ռx���x�`[����TDü:ݏ�y;~׃W9���)�XK�k�1V �%�Q�:xwd�wk��O��#b��S��nur�^$��{�MZ��ռ���|�U� �4[��j�)���-�0��~��S�Ɨ�z�o?��7=���=���]!�o$��X*Z>�Bވ�*^�����"�e�W�������ǋ8	i�������%�.UpS����Vt���ː�jw7���R;��?�,%�G#0OAlE�g��N����L��|j_�#��ot/����
�7 4<j62n�0���?n������u�VV������_�'�      "     x����y 1��]���]� ��!��Q�IqjɀjV9�Ua�OO\}�5j�L	��*u�H4#�]O���P���`f0$kV_*���Ň��l����''FӬ�j��ӼPn��x�#6:Ϥ�:�g b@���֨��X_�,Ӟ@8�����1��s�|��=� 5
*���3�&}���n#�}!w	��R[R�����}���ODlb��g�����j�[����!7A��S�������y��%���      #   }  x�S�q !��y��'���������O�w�Fa2�}]������T^�u���:S<er�Lf�u��w��Q�μ���}-)�=4�Y��Nw/Q�.^�ll��<�����w�.S�piu�:lк@s�BkO������QD˨W���)�G~;�ޱH��f9t��0����v��u��K��t�b�3�gi%����Ϥ{�)<��n��g�+�����KXh�����%9 ��-�w?��f�<ŕE~�Q|.��v�!����:R�򥐠�\7ʉ7�H��s�YĪ�`�LH%6iN^��w;��)VD��M��5��&�-|�>=�0Ej��}����9`�I�������^���48._C�|J&c���` )ir�;����A�ט���K/2j;�����C�N];��ߖ���W�������_��^��le�s[{-Π��>�4�˺C�$��]���+2EvN��>�z 	O���ٓ�m��ܑlL76hٝ�h���|��u44Ź��w;��"`P7;�!� J���;����4��x��B%@��zpi�;d�9E��B�"hHsd�l�B���Ț���y�A�r$tǣ\��ڹ��DBQj��_
m      $   M  x��A�@1D��.��2"��1;�tu?���lE�^�h��+�V�u������\G@N*xC����>�([���!%��3�6�K��>:}�� KDfJ�>�G��>�w�c��`_�/꯼p=�y�!c�G�A���+?�C/�G䄀�i���k��r��Dr����"Y���<�0��;�8+�y���O��|��u�YM�8��HYG_�������=�I��g��ʱq'�EZ|aٚ
6-���wH~X6����^��\1���\�y|�*mǡiM�����Jߺߴ���sc��gƤ�)�F�����|��o��      %   I  x���;n1E�UdH���5�1��i�� /~�a�?t�{�I���p�P�}��mAw`^1ڔ���`�������m�}���?�����x9�q�$��� �ր��XQk|'����g��Ϸ� �$�ծ6�M�#�f��<��b�صX\ �5����A��*H1�� ���y����!����M�Ѡ�$���V��[,��A��
��֥�T��6�5�au���Δ�&3�M����P|f)q:����2s)%���`Hi�ݕ�.���DoA%�jU�!�J����L����-�%iU�4,?	�T�B�k] ~|=���$�y      &   �  x����� !D�;�����T�a�x������݅d���uAj�)��u��T���!�EL@q�zA:! U�Ƣ��|�ѧ�ϯ&�V��
"[̉O���$?8�.`�5i5)��$J4o~\�i�	�F ���	����)��/=���-����t*x�Cr;zǖx�T���u�ɮ(h-�)���\�o��HO�|/���6D�
�E@�Ow��y�6��-�M2��b�M1�� =�a��р�0O"�����ɓ��Y�`5Z�h���Sp�Ȱ:<IyI��]&rB�ۍNf�U]�|���P�;[)�iA�]���ʓ�HO=��Mj�{
F�L���7B��-�/���X� n�~���k��zL�m2�HO[eMS�~�?e���=^n�6�tx�y���i�]�H\����c��A�������}�+<~*      '   ]  x���I��:D��{����˟���/�*/�V��Q:9��&9��	����:�r�a��i��#�0mRբ���qN�f�ad4��RnI�P���RQ���:���t>��`���)c��[���F�hW����-;�z���c�?E��kq�8K��K�-�,��m����H�]�h�F�v~�_P�oـ�$=��;I�;J�K���)<�|�l��3g^�ZM�	X��8w�������?��9�St.��Z��;PS�uZ������m���X���֠.�`�+����i!̉�H�����uo9Ȇ�z��3~�[#����K����*?U���O��M)p���Wbj�|P�|�d����^[{A������Yo����_��z�רt��5��:N���}ꪋ��`+�/��?���P��Y|P�������I?5�:?|��_���O�ܥC�V2��^�<C&�6�տ|��x���S��@�ʏ��w�8V�~�����{��<h��*��nRS��4�6O��^�4+Ukf��#���:3����c������Vp<Ùl�a\��VwC}C[��[h~�O�P�������y��4�V>      (   �   x�u�M
�0��ur�^`d2��.�?[]	n5	��"ݸ>x�a\��A��rkN//��P���o\������5��.�"5DT�\���?�K��\�� 	p��ԭ���'��
R�Tj��W��oa	5���v�P?C�ї���m�9	      )   '  x���;��0 К<�^@�|�;@���6�0�cS��R^�6DR��yΌDR�����Ç# Z /��J�Bvo����l��廒A�ʞ�Aq܏������M�W[X��iP}0��, -O,,��G�<�$� �pvA' �<J�Mƽc�q�Rb�XG���	q����%�)�*��-��rf�Ƚ/�����S�M���T`MH)l��*. MŹ����$�	1���p9���[Il�l+=[�]��Z
�����:Y�h�FC�\T+M�a>�8z��y����&q��}R5����F'��Ĉ��
6��)a%L�H��}T9�l�a(d?jq���(�B=�/����a��`�o�UYoQh�v�S6��v�k<��ɡ����h�Otr*�h�̃6M	7%S���<Rv=JSi�4�@)�}hjT���
Lr�MMr�"���'0Ja�&@�_��պ�d	���*���	x�o�z��8�G�߇�akt~^iN8�骊^�w�A�
p��k����r�w�^n�4�����-��4i�߼��+M	      *   4  x����n�0 ��y�Hٲn��vY�^w���E������H��@�-�����������w���O4�MH)DC`���؟����S�g�s@�6@K���찅�>�9�i�]=^��:]�hr�$��pXߟ��i����9�G�Ͽ_�ƺ��M>��P�џb�e��zK�[;djl��m� ����m�7a�`���\\�G����	]r�4�|��ߊ]M�\=]g=��~����A�d����Cu��J*l�N)ӭq*t���uh��R� 	%ڧ2/Th�ZQ�)ڣZ�!$�T|L�M<Au�Ф2�T�V��P�4$�[C���)6$�_*�8>_�hG���e��)h$�W�C>��K�s}[M�N<�}�6��-S^�����}>̄�������q��7�����]=؊��|���z�����KG�Sd��w�-M��_��_�;x\�(l��M�zl#>�f� ��m@([F'�
�BgC��8��2���S�L�?PRQ�-e�=�������^l�����u`W�\�U�'�Y�m;�
!���j����0      +   <  x�mW�nI<���?`����ڱw�cX�^�%�%�D6�f�\��'��=nc}0�0����i�C抒�&I�cJ�k�ʹXa����q��v�=�qb��Y���?�?���0�]������N�H'9�SnAg�Jp�}�i>�Th"�?���Lۧ�4��b�ҹ�rYr#��|-<Z����8c����	@Û��4�/�����dΩ9�CS@"���KQ�B+ڲ�����@�Ӽ�2�2��ٰܾ3e�� �������K���J��l<jc�K�$�#�+�f�y��<��@~�i9���i��9�Mռ%I�Oy��qܪ`�n����?��8|BCN�� ���G:Mw����\y\L��&:�x"�yN+�S��w����e&����^��4��H�+YF���B+�CqFyW����O�e|��`m˶�̉�_��X��rA&pS}Ce��!�I㤴5��/n��?�4�k"�V@2�$eP�Jo��A�TPf�A&#T5���#^��ш_��͇��N�L���s�y�
���d"�fc(��l�����?�2�{��zM��A�J<�KI0U��9iK)�q-��{����������_������t�y:�`Q�j��Oţ�?K�aM6!J]({�j�\��M���@s���g+�5WZQ.�j�3�$y��V�ێ��iB+��v��������떤�<̓F#���#��u4Q�P���]�G�b����`�/a�;��Ӽ��n"K[,�" d��kN��lTQe���)��zC��uyZ��i�����S�!'84鹴ƤҬ��?�@�!��w�^L�N>]a���+�

�Rq2�r[��E
K&�?��������uOS��%��n��	�m���%�*�����X[zv�������LsW�rX�U��^j�%A�F�*��*�,����[:�pK�����W��:6�7�����(ς��|�
0(�J��n�Ѹ#HbdOϧ��M�_��WY�WJ��T��+S�a��r����=m�6@+����_I��g�Q�89$���1�W,��W�N��w�d.�0�nO������b�1 �6�D{g$	�H��6�Ǟmoi:���/�[GH	�3�P����5"�ui�gSpa�0<�l��u����>��X4W�B��u�C!2YDN�*bo�ixu���r��wQj�([0=*�(��/S��P�� "�0��f?.[v�㱟V(�UrAD�d�u2��2�f�0�T�!b��n���������S�P$)$ϲ�'�]$�oD+��X֦U�z?W�#��\�q��`<':���ʂ�%�ᄎi����i���:F9_�+$�d!C
�BE��z�R!��\��=�����~�ԏ+MA�P;k��(�g��.�e�4{[��1�p=�:���_>���5�*[i4��@�ɠ=a��?	�j�@�X.���q[��=2z��3�����O!���`�憮�p���JNW���}��a��K��}�z]w5�;IC���X�X�$	��ƞ���
�	v�H>mǥ��r���J"����$,C)�%0��j5�LO�gJu���k��}ׯ+<[��D?���jƣrp7�D˒Td�dD�n�����a��L�\���B�t/"��&�����l=��i����/��r[/y�6��5��ܐx 
�dM�H�Y'��ï;��r��~^{ �q,Js�`(����Jl��@�c�F�*��u��Ȟ������}�8E��n�i,z�
�2И)�����l��.��Ï��%��KAT���aM���P*���"�� ����i�֕�(�]n��e͘0X>u߈a*�]� ����m�Q���lY�(��/����������/f      ,   `   x��-�t��Qp�K�I�KQ�/H��4202��M�!Q�KG9.�$r�9�32�Q�E*�TU���Sh�Kj^nbQ6�����T�cSY�M0F��� �c_       -      x������ � �      .   �   x�%�A�h!�߻���7�r�#�/���R�>g�,F%ȹ?� �b��D�N��f�֩ӗ��R����`8M9s�5&|9�j�<�&E�x��x�"��I�\C��A��(J�g���y�77���H:��!��CEe��?ofzI6�D������g���Z��A;5      /     x�����1��\���"�^��l��np����t ���	���H��V�i�``tǷ �L��*�>=��[Z�m,�%kN�X�%q�lw���Z
�z�/{��iO3�p��~F�B	֪o�+���R8x��1�c��qg礬L��0�I2��/D�SyǴ�s���;NRk�p�+uc��'�rq�@�}���|y,G6�|�t�tuqک"J@�o�� �#A0=3�t�ݝ��~w���}�����b      0   �  x�%��&+�ך��R!��`6����gӋ>V�����s�_Ƒ�o^�6P�=$ۍ�����w�<.~
�� r"�эl���f]>���\����A�c�w0\���lֈ�~��7!�!����M��&F�h����'�A<q]�G�� 3=����1L���}~�t�n�l�@�,���x+��޼����eҳ�^E��8��stʝ�8I�2��~Y�R��b꩘!cׇ*Tr�Q�On~p�2�NV5h;W��xLy�_�����+��gH�!FP�Q]�����*��k[��Jρv�W����|Rqs�
�G�R�lT��q�1��ܤj3�%�	�k��ޤi��}�ȓԊ�n�G��.����t��=2r�]��~�,�J���[�7���F�piN�,�\Q�<˘�]Z�tg�/e��
V��<�O�0���Qy��Ɲ~|1g�r��[�݇���3�,��Qy���{Py�U�S�3�[V�ړ>�5�������l���      1   X   x�uϫ�@a}[�U@�_���	��п���ߨQ�"�o\y��{�x�fރ�#�>�/�+�Q�eѳhZt-�}�����~��{[      2   �  x�M�ɑ%1D�%c&@ȗ�ߎɢ{�$��X�5tΏ�,b.�����'R��8P[E,/�K=E^s[�U�w�Դ�����7Y��>�%�$�YA a�T{X-}3��b��ev�+w �����q����gICƩe���F���f5��@B͋#:���?�5T��U<���"B���8�X@s�{M�k���C��n�^��-\E1W3�_]G�����5��c`\���R��=������0>��U�Q�U��W�^)|ds�=PL$k��3��@X*�FV/m?�w��D���M����/vi�d��uyw�c]���À)]E�ă���6:�RK��wю���!g �eS��߿N��m�Q$El�qv����e�XQ��,�!�ٯ�9�ğF��+�f�3c�s�F���(����#�߯p~�]��2��]!�k��$3��!z!���������C      3   �  x���;n1���S���Y E*�i�l��A`8��H�&
���)j(>�g_��B|t�1�ͻ�/l~��<k, L���ۋn�xE�A���~$K�-���X����������������WYN}��}M��d=�Vt-5~��^5�AKaI4r�Ž��2P:����ӓ��$�<"�Jr2L�yb����'w�\��\���\+�U,M��q���ra�Y�k�3K�d�������FOE��FY�m	j,ّ�.�H�mI����Pc�41$(t,Aqa��
tD`J����w{�=�O_}���
߿�O�v�`���Ku���=a��^�OX6��k��bB��N(5�	�v;�t�����cBi(��i(5��Hu0��&����.8!0������,��h�SVuǢΘqS��~Ø]s���+j�!ž�~*[�7�))j#I�:G���Cm$,(J#a,�X�5G�%2�t�L�L�Wd�v#W
ʵ�P�M��D�)��P�[�V�KE��?:�^	�P���m��①V�J\	*�աܝ�!;�<*�աRdC�b��rg(r�$&O<�
��j�MvXO�!���}�W�\�xS�9nx9�I5u�X"�~;?��W�F<%ɔ�9B������~|����gm��yK�_�.���7K      4   =  x����n[1�g�]X�"E�c��C��C�,�m�I������Ʊ�E-���<<�R4
Ԑ8U-��P,��`��w��~W�����ۛM)=�D	ʠ
��P�ګ�L-Hϒ��X��뱪k�1� _8�4��8 /h�0�ꂺ����Ѿ�l��wF`�W�2���$���������{�c�bku��<��>C��[��C-yv���í���v_v?���&�F�:P7y\�C�� #s�3����%�l��z���c�Y�گ�/6�H�"j�Y|�>K��(��z���43���j4	�م�q>�u8HDք���<�&Qm8����'�9�w�����8�O����/\�"���dn�a0�YTIF)���������Q�����mi�,.8A��j�6��~��>��=�l��c;�������h�R�t����/1�=�D�"S��R��Ϛw�ػ�~�s�$��<�.�����1�x�#���2@�� )kyP@�Q�R�ρa��6\NZ�(Z�X'�+�X�r��8�&����Ϝ&���WYm�Qs�c������}��l~(/�      5   �   x�U�1N�1��90Jb'�gVF��NRU�����C8���ݣ�kgZ�@RL�J�o]���J=��:��v|ߑx�hm0q�E�Ҟ�Z	���c��~\�g|>���#��=I���}P񝹁�M}4^�u;�U�a�w��&4�=FEu�.�.)t�ˮ�<�/�Fȥ������%��.��9���$G�      6   �  x�U��n�0E��W�*?%?�*� ��$�tC���Ԗ�w��r���J\�8<�"qS�����N*l�lj.e^fY�q�h��!�_`�!��цW�z�����'%�����]m��6��z�/v��0}�0]FN��֕��"�mS)�t&�A���-�]�������������x��R*�Ygo�8�@,v�y�����;"S�+�N�A��h@�UmdI�ǌu�v��6�?a�߈�{A���iK�w����_`����h����e�)⒋���vJ"j#���������-�BZ��#\�k�>�}� n��ɂ[�!q���?q�}��nr4��,'�ښ$϶���USt��us��{���pNv�g�_��<O6@�q0|�O�7&��p��w���(��7�9      7   �   x�-��n�0����)�A��,�TB�%BM�n��ŗ��ӗ@��i�="+��G3P���3ѧQ�F�br!5)����2�v�+�-,:3�]���ٔzC������w��}���sp�^l.�|�7�~VU-I�*�I�VO<�Hه��C��X�C�]|pK�,=�����q*�*���8�%�ĥ��I�UU�n��i��gY���R�      8   W   x�3202�4������4202�50�56�2���!�)�E�
ީ�9���y%�����%Ɯ�9��I�y� 9C]c]#�=... �;w      9   �   x���j1D����XZٲ�=B��܋dk��d6I��zN���Md+F��zk�G�$ ��Gz�8��Uאr������T3���Qk=E���~�V=u�No~��e�Y7X�!����R�0b���#9�>����s�zc����!"�e�&I��x:����>�o���3,����ߜ3$*l��5a�>����5|�����Cg      A      x������ � �      C      x������ � �      ?     x�]�K��0��ur
N0j£�z�Q�B�b�:�h�����I�%��o��i�g�f��c�Y����G�<��ЂRq�0G��f�a����[�m��Le���4u}0�x`+� �	{�}�R��NT����v�����֝d�~O]D�l�	�����<,�����ӺB�[ZA)���T���qu�<�͏>��_��� ��m�.2�)H���:x�ޟ8�1WY��'���`:Y��;�LL�vf���x댰j'�k�2�      E      x������ � �      G      x������ � �      I      x������ � �      K      x������ � �      =   W   x�M�K
�0�y����M�P�C�.z{E��LOn�!љ='���\��
K�!'�o�k��JU̴�d�f���)?�~��pM^%�      ;   �  x����n� ������U+·>�J#�P	pռ�qI�:Jn|����o���1���9���7��"��,�`���R�Dh��_$d0k�x���j��4������]®>���x�h��e����N�Fb���ze��cva�woF8~w,�Y�
]Y�.�S�v �f3�}炶�d�G��l#,6N.�ZR��d���y,o��"��UE7Ԛ��N����U+Hw
���G+',���)iz0�~��&�ޕ�Vg�j-w�(v?W�����;.q�_�Sn�|�N&����m�!�dS2��KM)i8�qj��#�J)��u����)T�8H�;�?(�6�ú<�њ]0�c0�KQda���|���~�\��u�䶫w�l�aD�e�Ԑ�v���Z���z8���ZC      L      x������ � �      M   �   x�m�K� @�p
O`ʯ�\ٺa�Ik�j�o�f��:����m���la'%T�u�3��X�����^�)�ʮq��>'<���z�i2ޖ>�S|W����iD�t��FEA98�!��c(�%��%vԗjN�o/��#�� 4e����ת4�&ǒ�t,�@SPcх'Kv���h�YԘQcQ:s���{��}|;�np�A�ĸ���v"�g)��ּ     