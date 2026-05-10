--
-- PostgreSQL database dump
--

\restrict pqkNaQRRUfrmnNbsn5hdJteOSTGhpQDcdakNykpk5REfJvQjIYDLBosASbiLEBX

-- Dumped from database version 16.10 (Debian 16.10-1.pgdg13+1)
-- Dumped by pg_dump version 16.10 (Debian 16.10-1.pgdg13+1)

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
-- Name: OrderStatuses; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."OrderStatuses" AS ENUM (
    'pending',
    'paid',
    'canceled'
);


ALTER TYPE public."OrderStatuses" OWNER TO postgres;

--
-- Name: TransactionStatuses; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."TransactionStatuses" AS ENUM (
    'pending',
    'finished',
    'canceled'
);


ALTER TYPE public."TransactionStatuses" OWNER TO postgres;

--
-- Name: TransactionTypes; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."TransactionTypes" AS ENUM (
    'add',
    'use',
    'withdraw'
);


ALTER TYPE public."TransactionTypes" OWNER TO postgres;

--
-- Name: UserFlags; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."UserFlags" AS ENUM (
    'ADMIN',
    'BOT',
    'BANNED',
    'VERIFIED'
);


ALTER TYPE public."UserFlags" OWNER TO postgres;

--
-- Name: UserStatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."UserStatus" AS ENUM (
    'offline',
    'online',
    'idle'
);


ALTER TYPE public."UserStatus" OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Carts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Carts" (
    id character varying(255) NOT NULL,
    user_id character varying(255) NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modified_at timestamp(3) without time zone NOT NULL,
    amount double precision DEFAULT 0.0 NOT NULL,
    product_id character varying(255) NOT NULL
);


ALTER TABLE public."Carts" OWNER TO postgres;

--
-- Name: Chats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Chats" (
    id character varying(255) NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modified_at timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Chats" OWNER TO postgres;

--
-- Name: Companies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Companies" (
    id character varying(255) NOT NULL,
    name text NOT NULL,
    address text,
    phone character varying(20),
    email character varying(255),
    website text,
    owned_by character varying(255) NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modified_at timestamp(3) without time zone NOT NULL,
    description text,
    is_active boolean DEFAULT true NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    is_verified boolean DEFAULT false NOT NULL,
    short_name character varying(100),
    tax_id character varying(100),
    international_name character varying(255),
    logo_file_id character varying(255),
    balance double precision DEFAULT 0.0 NOT NULL
);


ALTER TABLE public."Companies" OWNER TO postgres;

--
-- Name: CompanyDeliveries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."CompanyDeliveries" (
    id character varying(255) NOT NULL,
    weight double precision NOT NULL,
    length double precision NOT NULL,
    width double precision NOT NULL,
    height double precision NOT NULL,
    budget double precision NOT NULL,
    created_by character varying(255) NOT NULL,
    company_id character varying(255) NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modified_at timestamp(3) without time zone NOT NULL,
    title text NOT NULL
);


ALTER TABLE public."CompanyDeliveries" OWNER TO postgres;

--
-- Name: CompanyRecruitments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."CompanyRecruitments" (
    id character varying(255) NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    requirements text NOT NULL,
    location text,
    employment_type text,
    created_by character varying(255) NOT NULL,
    company_id character varying(255) NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modified_at timestamp(3) without time zone NOT NULL,
    salary_range_from text,
    salary_range_to text
);


ALTER TABLE public."CompanyRecruitments" OWNER TO postgres;

--
-- Name: CompanyScrapes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."CompanyScrapes" (
    id character varying(255) NOT NULL,
    name text NOT NULL,
    quantity integer NOT NULL,
    unit_type character varying(100) NOT NULL,
    unit_price double precision NOT NULL,
    created_by character varying(255) NOT NULL,
    company_id character varying(255) NOT NULL
);


ALTER TABLE public."CompanyScrapes" OWNER TO postgres;

--
-- Name: Files; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Files" (
    id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    user_id character varying(255) NOT NULL,
    product_id character varying(255),
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modified_at timestamp(3) without time zone NOT NULL,
    "order" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public."Files" OWNER TO postgres;

--
-- Name: Message_reactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Message_reactions" (
    id character varying(255) NOT NULL,
    icon text NOT NULL,
    message_id character varying(255) NOT NULL,
    seen_by_id character varying(255) NOT NULL,
    seen_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Message_reactions" OWNER TO postgres;

--
-- Name: Message_seens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Message_seens" (
    id character varying(255) NOT NULL,
    message_id character varying(255) NOT NULL,
    seen_by_id character varying(255) NOT NULL,
    seen_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Message_seens" OWNER TO postgres;

--
-- Name: Messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Messages" (
    id character varying(255) NOT NULL,
    chat_id character varying(255) NOT NULL,
    sender_id character varying(255) NOT NULL,
    content text NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modified_at timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Messages" OWNER TO postgres;

--
-- Name: Orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Orders" (
    id character varying(255) NOT NULL,
    products jsonb NOT NULL,
    total double precision DEFAULT 0.0 NOT NULL,
    user_id character varying(255) NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modified_at timestamp(3) without time zone NOT NULL,
    status public."OrderStatuses" DEFAULT 'pending'::public."OrderStatuses" NOT NULL
);


ALTER TABLE public."Orders" OWNER TO postgres;

--
-- Name: Places; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Places" (
    id character varying(255) NOT NULL,
    name text NOT NULL,
    address text,
    phone character varying(20),
    latitude double precision,
    longitude double precision,
    company_id character varying(255),
    user_id character varying(255),
    creator_id character varying(255) NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modified_at timestamp(3) without time zone NOT NULL,
    description text
);


ALTER TABLE public."Places" OWNER TO postgres;

--
-- Name: Product_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Product_categories" (
    id character varying(255) NOT NULL,
    name text NOT NULL,
    description text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modified_at timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Product_categories" OWNER TO postgres;

--
-- Name: Products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Products" (
    id character varying(255) NOT NULL,
    name text NOT NULL,
    description text,
    price double precision NOT NULL,
    stock integer NOT NULL,
    unit_type character varying(100) NOT NULL,
    place_id character varying(255) NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modified_at timestamp(3) without time zone NOT NULL,
    category_id character varying(255)
);


ALTER TABLE public."Products" OWNER TO postgres;





--
-- Name: Users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Users" (
    id character varying(255) NOT NULL,
    username text NOT NULL,
    email character varying(255),
    phone_number character varying(20),
    display_name text,
    hashed_password character varying(255),
    google_id character varying(255),
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modified_at timestamp(3) without time zone NOT NULL,
    last_active_at timestamp(3) without time zone,
    status public."UserStatus" DEFAULT 'offline'::public."UserStatus" NOT NULL,
    bot_token character varying(255),
    flags public."UserFlags"[] DEFAULT ARRAY[]::public."UserFlags"[],
    avatar_file_id character varying(255),
    balance double precision DEFAULT 0.0 NOT NULL
);


ALTER TABLE public."Users" OWNER TO postgres;

--
-- Name: _UserChats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."_UserChats" (
    "A" character varying(255) NOT NULL,
    "B" character varying(255) NOT NULL
);


ALTER TABLE public."_UserChats" OWNER TO postgres;

--
-- Data for Name: Carts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Carts" (id, user_id, created_at, modified_at, amount, product_id) FROM stdin;
\.


--
-- Data for Name: Chats; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Chats" (id, created_at, modified_at) FROM stdin;
7331094207852602368	2025-12-29 04:04:45.296	2025-12-29 04:04:45.296
7331128090820602880	2025-12-29 06:19:23.625	2025-12-29 06:19:23.625
7331130830523198464	2025-12-29 06:30:16.821	2025-12-29 06:30:16.821
7331157766770445312	2025-12-29 08:17:18.923	2025-12-29 08:17:18.923
7331239623874149376	2025-12-29 13:42:35.179	2025-12-29 13:42:35.179
7331240024094637056	2025-12-29 13:44:10.598	2025-12-29 13:44:10.598
7331252814869935104	2025-12-29 14:35:00.156	2025-12-29 14:35:00.156
7331385986762845184	2025-12-29 23:24:10.81	2025-12-29 23:24:10.81
7331431806161824768	2025-12-30 02:26:15.006	2025-12-30 02:26:15.006
7331578834649000960	2025-12-30 12:10:29.33	2025-12-30 12:10:29.33
7331579859321662464	2025-12-30 12:14:33.63	2025-12-30 12:14:33.63
7331774791259851776	2025-12-31 01:09:09.025	2025-12-31 01:09:09.025
7331776872867442688	2025-12-31 01:17:25.319	2025-12-31 01:17:25.319
7331778810618087424	2025-12-31 01:25:07.315	2025-12-31 01:25:07.315
7333077400743464960	2026-01-03 15:25:15.328	2026-01-03 15:25:15.328
\.


--
-- Data for Name: Companies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Companies" (id, name, address, phone, email, website, owned_by, created_at, modified_at, description, is_active, is_deleted, is_verified, short_name, tax_id, international_name, logo_file_id, balance) FROM stdin;
7326534226503641088	Công Ty TNHH Sơn Hà (May mặc)	79 Đ. Nguyễn Văn A, KP2, P. Trảng Dài, Biên Hòa, Đồng Nai.				7320276851855168512	2025-12-16 14:05:01.022	2025-12-16 14:05:34.303	\N	t	f	f	\N	\N	\N	\N	0
7326532791888095232	Tổng Công Ty May Đồng Nai (Donagamex)	Đường số 2, KCN Biên Hòa 1, P. An Bình, Biên Hòa, Đồng Nai.				7320276851855168512	2025-12-16 13:59:18.983	2026-01-05 14:11:57.86		t	f	f				\N	0
7326534286587045888	Nguyễn Anh Khôi - Công ty dệt dây thun	1240 tổ 35 KP Vườn Dừa, P. Phước Tân, Biên Hòa, Đồng Nai.				7320276851855168512	2025-12-16 14:05:15.347	2025-12-16 14:05:54.235	\N	t	f	f	\N	\N	\N	\N	0
7326534708907321344	Công ty TNHH TOKIN Electronics (Việt Nam)	Lô 230, KCN Loteco, P. Long Bình, Biên Hòa, Đồng Nai.				7320276851855168512	2025-12-16 14:06:56.036	2025-12-16 14:07:48.686	\N	t	f	f	\N	\N	\N	\N	0
7326534764666398720	Công ty TNHH INZI VINA	Lô 220, Đường 10, KCN Amata, P. Long Bình, Biên Hòa, Đồng Nai.				7320276851855168512	2025-12-16 14:07:09.33	2025-12-16 14:08:10.03	\N	t	f	f	\N	\N	\N	\N	0
7326534817845979136	Linh kiện điện tử Biên Hòa (MTV)	Hẻm 547 Xa lộ Hà Nội, P. Long Bình, Biên Hòa, Đồng Nai.				7320276851855168512	2025-12-16 14:07:22.009	2025-12-16 14:08:29.335	\N	t	f	f	\N	\N	\N	\N	0
7320053085020058624	Công ty TNHH Giải pháp Số Softlab	59 Đặng Đại Độ, Trấn Biên, Đồng Nai	0888866548	contact@softlab.vn	https://softlab.vn	7319893232403309568	2025-11-28 16:51:16.48	2026-01-06 01:57:59.44	\N	f	t	f	SOFTLAB.,LTD	3604049476	SOFTLAB DIGITAL SOLUTION COMPANY LIMITED	\N	0
7326535476393650176	Công ty Bao bì Carton Vĩnh Phát	Cụm gốm, P. Tân Hạnh, Biên Hòa, Đồng Nai.				7320276851855168512	2025-12-16 14:09:59.019	2025-12-16 14:10:19.534	\N	t	f	f	\N	\N	\N	\N	0
7326535363994691584	Công Ty CP Bao Bì Thống Nhất Đồng Nai	486 QL15, P. Trảng Dài, Biên Hòa, Đồng Nai.				7320276851855168512	2025-12-16 14:09:32.221	2025-12-16 14:10:50.664	\N	t	f	f	\N	\N	\N	\N	0
7326535312845154304	Công ty TNHH TOKIN Electronics (Việt Nam)	Lô 230, KCN Loteco, P. Long Bình, Biên Hòa, Đồng Nai.	\N	\N	\N	7320276851855168512	2025-12-16 14:09:20.026	2025-12-16 14:13:30.521	\N	f	t	f	\N	\N	\N	\N	0
7326536074404931584	Công Ty TNHH Giấy - Bao Bì Bình Minh	50, KP2, P. Tân Hiệp, Biên Hòa, Đồng Nai.				7320276851855168512	2025-12-16 14:12:21.596	2025-12-16 14:13:49.124	\N	t	f	f	\N	\N	\N	\N	0
7326767216848259072	Công ty TNHH Formosa Taffeta Việt Nam	Đường số 10, KCN Nhơn Trạch 3, Nhơn Trạch, Đồng Nai	\N	\N	\N	7320276851855168512	2025-12-17 05:30:50.249	2025-12-17 05:30:50.249	\N	t	f	f	\N	\N	\N	\N	0
7326767216978282496	Công ty TNHH Nestlé Việt Nam (Nhà máy Trị An)	Đường số 7, KCN Amata, Long Bình, Biên Hòa, Đồng Nai	\N	\N	\N	7320276851855168512	2025-12-17 05:30:50.282	2025-12-17 05:30:50.282	\N	t	f	f	\N	\N	\N	\N	0
7326767217037002752	Công ty TNHH Changshin Việt Nam	Thạnh Phú, Huyện Vĩnh Cửu, Đồng Nai	\N	\N	\N	7320276851855168512	2025-12-17 05:30:50.294	2025-12-17 05:30:50.294	\N	t	f	f	\N	\N	\N	\N	0
7326767217091528704	Công ty TNHH Hwaseung Vina	KCN Nhơn Trạch 1, Huyện Nhơn Trạch, Đồng Nai	\N	\N	\N	7320276851855168512	2025-12-17 05:30:50.307	2025-12-17 05:30:50.307	\N	t	f	f	\N	\N	\N	\N	0
7326767217141860352	Công ty TNHH Ajinomoto Việt Nam	Đường số 1, KCN Biên Hòa 1, An Bình, Biên Hòa, Đồng Nai	\N	\N	\N	7320276851855168512	2025-12-17 05:30:50.318	2025-12-17 05:30:50.318	\N	t	f	f	\N	\N	\N	\N	0
7326767217192192000	Công ty TNHH Hyosung Việt Nam	Đường số 1, KCN Nhơn Trạch 5, Nhơn Trạch, Đồng Nai	\N	\N	\N	7320276851855168512	2025-12-17 05:30:50.331	2025-12-17 05:30:50.331	\N	t	f	f	\N	\N	\N	\N	0
7326767217242523648	Công ty TNHH Texhong Nhơn Trạch	KCN Nhơn Trạch 5, Huyện Nhơn Trạch, Đồng Nai	\N	\N	\N	7320276851855168512	2025-12-17 05:30:50.342	2025-12-17 05:30:50.342	\N	t	f	f	\N	\N	\N	\N	0
7326767217288660992	Công ty TNHH Bosch Việt Nam	Đường số 11, KCN Long Thành, Huyện Long Thành, Đồng Nai	\N	\N	\N	7320276851855168512	2025-12-17 05:30:50.354	2025-12-17 05:30:50.354	\N	t	f	f	\N	\N	\N	\N	0
7326767217338992640	Công ty TNHH Fujitsu Việt Nam	Đường số 1, KCN Biên Hòa 2, Long Bình Đông, Biên Hòa, Đồng Nai	\N	\N	\N	7320276851855168512	2025-12-17 05:30:50.365	2025-12-17 05:30:50.365	\N	t	f	f	\N	\N	\N	\N	0
7326767217393518592	Công ty TNHH Posco VST	Đường số 1, KCN Nhơn Trạch 1, Nhơn Trạch, Đồng Nai	\N	\N	\N	7320276851855168512	2025-12-17 05:30:50.378	2025-12-17 05:30:50.378	\N	t	f	f	\N	\N	\N	\N	0
7326769448943601664	Thép Posco Yamato	KCN Phú Mỹ, Bà Rịa - Vũng Tàu	\N	\N	\N	7320276851855168512	2025-12-17 05:39:42.422	2025-12-17 05:39:42.422	\N	t	f	f	\N	\N	\N	\N	0
7326769449233008640	Gốm sứ Minh Long I	333 Hưng Lộc, Thuận An, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:39:42.491	2025-12-17 05:39:42.491	\N	t	f	f	\N	\N	\N	\N	0
7326769449379809280	Sữa Vinamilk (Nhà máy Thống Nhất)	KCN Thống Nhất, Đồng Nai	\N	\N	\N	7320276851855168512	2025-12-17 05:39:42.526	2025-12-17 05:39:42.526	\N	t	f	f	\N	\N	\N	\N	0
7326769449530804224	Gỗ Đức Thành	KCN Mỹ Phước, Bến Cát, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:39:42.561	2025-12-17 05:39:42.561	\N	t	f	f	\N	\N	\N	\N	0
7326769449673410560	Nhựa Duy Tân	KCN Tân Tạo, Bình Tân, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 05:39:42.595	2025-12-17 05:39:42.595	\N	t	f	f	\N	\N	\N	\N	0
7326769449891514368	Cao su Đồng Nai	Xuân Lập, Long Khánh, Đồng Nai	\N	\N	\N	7320276851855168512	2025-12-17 05:39:42.647	2025-12-17 05:39:42.647	\N	t	f	f	\N	\N	\N	\N	0
7326769450029926400	Dệt may Việt Thắng	Linh Trung, Thủ Đức, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 05:39:42.681	2025-12-17 05:39:42.681	\N	t	f	f	\N	\N	\N	\N	0
7326769450164144128	Giấy Vĩnh Huê	KCN Tân Bình, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 05:39:42.713	2025-12-17 05:39:42.713	\N	t	f	f	\N	\N	\N	\N	0
7326769450298361856	Điện tử Samsung HCMC	Khu Công Nghệ Cao, Quận 9, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 05:39:42.745	2025-12-17 05:39:42.745	\N	t	f	f	\N	\N	\N	\N	0
7326769450436773888	Bánh kẹo Kinh Đô	KCN VSIP 1, Thuận An, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:39:42.778	2025-12-17 05:39:42.778	\N	t	f	f	\N	\N	\N	\N	0
7326769697758103552	Công ty TNHH Vedan Việt Nam	Quốc lộ 51, Phước Thái, Long Thành, Đồng Nai	\N	\N	\N	7320276851855168512	2025-12-17 05:40:41.744	2025-12-17 05:40:41.744	\N	t	f	f	\N	\N	\N	\N	0
7326769698081064960	Công ty Cổ phần TKG Taekwang Vina	KCN Biên Hòa 2, Biên Hòa, Đồng Nai	\N	\N	\N	7320276851855168512	2025-12-17 05:40:41.821	2025-12-17 05:40:41.821	\N	t	f	f	\N	\N	\N	\N	0
7326769698357889024	Công ty TNHH CP Việt Nam	KCN Amata, Long Bình, Biên Hòa, Đồng Nai	\N	\N	\N	7320276851855168512	2025-12-17 05:40:41.887	2025-12-17 05:40:41.887	\N	t	f	f	\N	\N	\N	\N	0
7326769698550827008	Công ty TNHH VPIC Việt Nam	KCN Hố Nai, Trảng Bom, Đồng Nai	\N	\N	\N	7320276851855168512	2025-12-17 05:40:41.933	2025-12-17 05:40:41.933	\N	t	f	f	\N	\N	\N	\N	0
7326769699716843520	Công ty TNHH Texhong Dệt Kim	KCN Nhơn Trạch 6, Nhơn Trạch, Đồng Nai	\N	\N	\N	7320276851855168512	2025-12-17 05:40:42.211	2025-12-17 05:40:42.211	\N	t	f	f	\N	\N	\N	\N	0
7326769699897198592	Công ty TNHH Nhôm Toàn Cầu Việt Nam	KCN Mỹ Xuân B1, Tân Thành (giáp Đồng Nai)	\N	\N	\N	7320276851855168512	2025-12-17 05:40:42.253	2025-12-17 05:40:42.253	\N	t	f	f	\N	\N	\N	\N	0
7326769700140468224	Công ty TNHH Kenda Rubber	KCN Giang Điền, Trảng Bom, Đồng Nai	\N	\N	\N	7320276851855168512	2025-12-17 05:40:42.312	2025-12-17 05:40:42.312	\N	t	f	f	\N	\N	\N	\N	0
7326769700396320768	Công ty TNHH Vacpro Việt Nam	KCN Lộc An - Bình Sơn, Long Thành, Đồng Nai	\N	\N	\N	7320276851855168512	2025-12-17 05:40:42.373	2025-12-17 05:40:42.373	\N	t	f	f	\N	\N	\N	\N	0
7326769700601841664	Công ty TNHH Fleming Việt Nam	KCN Amata, Long Bình, Biên Hòa, Đồng Nai	\N	\N	\N	7320276851855168512	2025-12-17 05:40:42.422	2025-12-17 05:40:42.422	\N	t	f	f	\N	\N	\N	\N	0
7326769700824139776	Công ty TNHH Mabuchi Motor	KCN Biên Hòa 2, Biên Hòa, Đồng Nai	\N	\N	\N	7320276851855168512	2025-12-17 05:40:42.475	2025-12-17 05:40:42.475	\N	t	f	f	\N	\N	\N	\N	0
7326769914280658944	Samsung Electronics Việt Nam (SEV)	KCN Yên Phong, Bắc Ninh	\N	\N	\N	7320276851855168512	2025-12-17 05:41:33.367	2025-12-17 05:41:33.367	\N	t	f	f	\N	\N	\N	\N	0
7326769914565871616	Công ty Than Cửa Ông	Cẩm Phả, Quảng Ninh	\N	\N	\N	7320276851855168512	2025-12-17 05:41:33.435	2025-12-17 05:41:33.435	\N	t	f	f	\N	\N	\N	\N	0
7326769914783975424	Nhà máy thép Hòa Phát Dung Quất	KKT Dung Quất, Bình Sơn, Quảng Ngãi	\N	\N	\N	7320276851855168512	2025-12-17 05:41:33.487	2025-12-17 05:41:33.487	\N	t	f	f	\N	\N	\N	\N	0
7326769914964330496	Công ty May mặc Regina Miracle	KCN VSIP Hải Phòng, Thủy Nguyên, Hải Phòng	\N	\N	\N	7320276851855168512	2025-12-17 05:41:33.53	2025-12-17 05:41:33.53	\N	t	f	f	\N	\N	\N	\N	0
7326769915090159616	Công ty Brother Industries Việt Nam	KCN Phúc Điền, Cẩm Giàng, Hải Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:41:33.56	2025-12-17 05:41:33.56	\N	t	f	f	\N	\N	\N	\N	0
7326769915241154560	Công ty Ô tô Trường Hải (THACO)	KKT Mở Chu Lai, Núi Thành, Quảng Nam	\N	\N	\N	7320276851855168512	2025-12-17 05:41:33.596	2025-12-17 05:41:33.596	\N	t	f	f	\N	\N	\N	\N	0
7326769915366983680	Nhà máy Bia Heineken Việt Nam	KCN Mỹ Xuân A, Phú Mỹ, Bà Rịa - Vũng Tàu	\N	\N	\N	7320276851855168512	2025-12-17 05:41:33.626	2025-12-17 05:41:33.626	\N	t	f	f	\N	\N	\N	\N	0
7326769915576698880	Công ty Giầy Avery Dennison RIS	KCN Long Hậu, Cần Giuộc, Long An	\N	\N	\N	7320276851855168512	2025-12-17 05:41:33.676	2025-12-17 05:41:33.676	\N	t	f	f	\N	\N	\N	\N	0
7326769915706722304	Công ty Intel Products Việt Nam	Khu Công nghệ cao, Thủ Đức, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 05:41:33.706	2025-12-17 05:41:33.706	\N	t	f	f	\N	\N	\N	\N	0
7326769915929020416	Công ty Gốm sứ Viglacera	KCN Yên Phong, Bắc Ninh	\N	\N	\N	7320276851855168512	2025-12-17 05:41:33.76	2025-12-17 05:41:33.76	\N	t	f	f	\N	\N	\N	\N	0
7326770226483677184	Công ty Cao su Sailun Việt Nam	KCN Phước Đông, Gò Dầu, Tây Ninh	\N	\N	\N	7320276851855168512	2025-12-17 05:42:47.802	2025-12-17 05:42:47.802	\N	t	f	f	\N	\N	\N	\N	0
7326770226722752512	Công ty TNHH Hayat Kimya Việt Nam	KCN Becamex Bình Phước, Chơn Thành, Bình Phước	\N	\N	\N	7320276851855168512	2025-12-17 05:42:47.859	2025-12-17 05:42:47.859	\N	t	f	f	\N	\N	\N	\N	0
7326770226877941760	Nhà máy Sợi Brotex Việt Nam	KCN Phước Đông, Tây Ninh	\N	\N	\N	7320276851855168512	2025-12-17 05:42:47.895	2025-12-17 05:42:47.895	\N	t	f	f	\N	\N	\N	\N	0
7326770227037325312	Công ty Sữa Vinamilk (Nhà máy Cần Thơ)	KCN Trà Nóc, Bình Thủy, Cần Thơ	\N	\N	\N	7320276851855168512	2025-12-17 05:42:47.934	2025-12-17 05:42:47.934	\N	t	f	f	\N	\N	\N	\N	0
7326770227251234816	Công ty Cao su Đà Nẵng (DRC)	KCN Liên Chiểu, Đà Nẵng	\N	\N	\N	7320276851855168512	2025-12-17 05:42:47.985	2025-12-17 05:42:47.985	\N	t	f	f	\N	\N	\N	\N	0
7326770227582584832	Công ty TNHH TOTO Việt Nam	KCN Thăng Long 2, Yên Mỹ, Hưng Yên	\N	\N	\N	7320276851855168512	2025-12-17 05:42:48.064	2025-12-17 05:42:48.064	\N	t	f	f	\N	\N	\N	\N	0
7326770227725191168	Công ty Nhựa Tiền Phong (Miền Trung)	KCN Liên Chiểu, Đà Nẵng	\N	\N	\N	7320276851855168512	2025-12-17 05:42:48.098	2025-12-17 05:42:48.098	\N	t	f	f	\N	\N	\N	\N	0
7326770227851020288	Công ty TNHH CP Thủy sản Minh Phú	KCN Sông Hậu, Châu Thành, Hậu Giang	\N	\N	\N	7320276851855168512	2025-12-17 05:42:48.127	2025-12-17 05:42:48.127	\N	t	f	f	\N	\N	\N	\N	0
7326770227972655104	Công ty May 10 (Nhà máy Bỉm Sơn)	KCN Bỉm Sơn, Thanh Hóa	\N	\N	\N	7320276851855168512	2025-12-17 05:42:48.157	2025-12-17 05:42:48.157	\N	t	f	f	\N	\N	\N	\N	0
7326770228140427264	Công ty TNHH Foxconn Việt Nam	KCN Quang Châu, Việt Yên, Bắc Giang	\N	\N	\N	7320276851855168512	2025-12-17 05:42:48.197	2025-12-17 05:42:48.197	\N	t	f	f	\N	\N	\N	\N	0
7326770500761798656	Công ty HanesBrands Việt Nam (Huế)	KCN Phú Bài, Hương Thủy, Thừa Thiên Huế	\N	\N	\N	7320276851855168512	2025-12-17 05:43:53.195	2025-12-17 05:43:53.195	\N	t	f	f	\N	\N	\N	\N	0
7326770500984096768	Nhà máy Đóng tàu Hyundai Việt Nam	Ninh Phước, Ninh Hòa, Khánh Hòa	\N	\N	\N	7320276851855168512	2025-12-17 05:43:53.248	2025-12-17 05:43:53.248	\N	t	f	f	\N	\N	\N	\N	0
7326770501114120192	Công ty Sợi Đà Lạt (Dalat Worsted Spinning)	KCN Phát Chi, Đà Lạt, Lâm Đồng	\N	\N	\N	7320276851855168512	2025-12-17 05:43:53.279	2025-12-17 05:43:53.279	\N	t	f	f	\N	\N	\N	\N	0
7326770501252532224	Công ty TNHH MTV Cao su Lộc Ninh	Lộc Tấn, Lộc Ninh, Bình Phước	\N	\N	\N	7320276851855168512	2025-12-17 05:43:53.312	2025-12-17 05:43:53.312	\N	t	f	f	\N	\N	\N	\N	0
7326770501374167040	Công ty Thủy sản Hùng Vương (Tiền Giang)	KCN Mỹ Tho, Tiền Giang	\N	\N	\N	7320276851855168512	2025-12-17 05:43:53.34	2025-12-17 05:43:53.34	\N	t	f	f	\N	\N	\N	\N	0
7326770501533550592	Công ty TNHH Giày Ching Luh Việt Nam	KCN Thuận Đạo, Bến Lức, Long An	\N	\N	\N	7320276851855168512	2025-12-17 05:43:53.379	2025-12-17 05:43:53.379	\N	t	f	f	\N	\N	\N	\N	0
7326770501701322752	Nhà máy Đường Bourbon Tây Ninh	Tân Châu, Tây Ninh	\N	\N	\N	7320276851855168512	2025-12-17 05:43:53.419	2025-12-17 05:43:53.419	\N	t	f	f	\N	\N	\N	\N	0
7326770501864900608	Công ty May Nhà Bè (Sóc Trăng)	KCN An Nghiệp, Sóc Trăng	\N	\N	\N	7320276851855168512	2025-12-17 05:43:53.458	2025-12-17 05:43:53.458	\N	t	f	f	\N	\N	\N	\N	0
7326770502120753152	Công ty TNHH Yazaki Hải Phòng (Chi nhánh Quảng Ninh)	KCN Đông Mai, Quảng Yên, Quảng Ninh	\N	\N	\N	7320276851855168512	2025-12-17 05:43:53.519	2025-12-17 05:43:53.519	\N	t	f	f	\N	\N	\N	\N	0
7326770502242387968	Công ty TNHH Cargill Việt Nam (Bình Định)	KCN Phú Tài, Quy Nhơn, Bình Định	\N	\N	\N	7320276851855168512	2025-12-17 05:43:53.547	2025-12-17 05:43:53.547	\N	t	f	f	\N	\N	\N	\N	0
7326770599663486976	Khu liên hợp Gang thép Formosa Hà Tĩnh	KKT Vũng Áng, Kỳ Anh, Hà Tĩnh	\N	\N	\N	7320276851855168512	2025-12-17 05:44:16.775	2025-12-17 05:44:16.775	\N	t	f	f	\N	\N	\N	\N	0
7326770599931922432	Công ty Luxshare-ICT Nghệ An	KCN VSIP Nghệ An, Hưng Nguyên, Nghệ An	\N	\N	\N	7320276851855168512	2025-12-17 05:44:16.839	2025-12-17 05:44:16.839	\N	t	f	f	\N	\N	\N	\N	0
7326770600053557248	Công ty Cổ phần Hoàng Anh Gia Lai (HAGL)	Liên Hiệp, Pleiku, Gia Lai	\N	\N	\N	7320276851855168512	2025-12-17 05:44:16.868	2025-12-17 05:44:16.868	\N	t	f	f	\N	\N	\N	\N	0
7326770600162609152	Nhà máy Bia Sài Gòn - Trung Đô	KCN Nam Cấm, Nghi Lộc, Nghệ An	\N	\N	\N	7320276851855168512	2025-12-17 05:44:16.894	2025-12-17 05:44:16.894	\N	t	f	f	\N	\N	\N	\N	0
7326770600275855360	Công ty TNHH MTV Cao su Chư Păh	Hòa Phú, Chư Păh, Gia Lai	\N	\N	\N	7320276851855168512	2025-12-17 05:44:16.921	2025-12-17 05:44:16.921	\N	t	f	f	\N	\N	\N	\N	0
7326770600389101568	Nhà máy Thủy điện Buôn Kuốp	Hòa Phú, Buôn Ma Thuột, Đắk Lắk	\N	\N	\N	7320276851855168512	2025-12-17 05:44:16.948	2025-12-17 05:44:16.948	\N	t	f	f	\N	\N	\N	\N	0
7326770600514930688	Công ty TNHH Goertek Vina	KCN Quế Võ, Bắc Ninh	\N	\N	\N	7320276851855168512	2025-12-17 05:44:16.978	2025-12-17 05:44:16.978	\N	t	f	f	\N	\N	\N	\N	0
7326770600712062976	Trang trại Điện gió Bình Thạnh	Tuy Phong, Bình Thuận	\N	\N	\N	7320276851855168512	2025-12-17 05:44:17.024	2025-12-17 05:44:17.024	\N	t	f	f	\N	\N	\N	\N	0
7326770600905000960	Công ty Xi măng Nghi Sơn	Tĩnh Gia, Thanh Hóa	\N	\N	\N	7320276851855168512	2025-12-17 05:44:17.07	2025-12-17 05:44:17.07	\N	t	f	f	\N	\N	\N	\N	0
7326770601072773120	Công ty Chế biến Thủy sản Út Xi	KCN An Nghiệp, Sóc Trăng	\N	\N	\N	7320276851855168512	2025-12-17 05:44:17.11	2025-12-17 05:44:17.11	\N	t	f	f	\N	\N	\N	\N	0
7326770760649263104	Công ty Samsung Electronics Việt Nam Thái Nguyên (SEVT)	KCN Yên Bình, Phổ Yên, Thái Nguyên	\N	\N	\N	7320276851855168512	2025-12-17 05:44:55.157	2025-12-17 05:44:55.157	\N	t	f	f	\N	\N	\N	\N	0
7326770760959641600	Công ty TNHH Khai thác Chế biến Khoáng sản Núi Pháo	Hùng Sơn, Đại Từ, Thái Nguyên	\N	\N	\N	7320276851855168512	2025-12-17 05:44:55.231	2025-12-17 05:44:55.231	\N	t	f	f	\N	\N	\N	\N	0
7326770761244854272	Nhà máy Đạm Cà Mau (PVCFC)	Xã Khánh An, U Minh, Cà Mau	\N	\N	\N	7320276851855168512	2025-12-17 05:44:55.299	2025-12-17 05:44:55.299	\N	t	f	f	\N	\N	\N	\N	0
7326770761542649856	Công ty Apatit Việt Nam	Cam Đường, TP. Lào Cai	\N	\N	\N	7320276851855168512	2025-12-17 05:44:55.37	2025-12-17 05:44:55.37	\N	t	f	f	\N	\N	\N	\N	0
7326770762675111936	Công ty Nhiệt điện Vĩnh Tân 4	Vĩnh Tân, Tuy Phong, Bình Thuận	\N	\N	\N	7320276851855168512	2025-12-17 05:44:55.64	2025-12-17 05:44:55.64	\N	t	f	f	\N	\N	\N	\N	0
7326770762821912576	Công ty CP Xi măng Vicem Sông Gianh	Tiến Hóa, Tuyên Hóa, Quảng Bình	\N	\N	\N	7320276851855168512	2025-12-17 05:44:55.675	2025-12-17 05:44:55.675	\N	t	f	f	\N	\N	\N	\N	0
7326770762993879040	Công ty TNHH Scavi Huế	KCN Phong Điền, Thừa Thiên Huế	\N	\N	\N	7320276851855168512	2025-12-17 05:44:55.716	2025-12-17 05:44:55.716	\N	t	f	f	\N	\N	\N	\N	0
7326770763211982848	Công ty Nhiệt điện Duyên Hải	Dân Thành, Duyên Hải, Trà Vinh	\N	\N	\N	7320276851855168512	2025-12-17 05:44:55.768	2025-12-17 05:44:55.768	\N	t	f	f	\N	\N	\N	\N	0
7326770763430086656	Công ty Cổ phần Traphaco Sapa	Thị xã Sa Pa, Lào Cai	\N	\N	\N	7320276851855168512	2025-12-17 05:44:55.82	2025-12-17 05:44:55.82	\N	t	f	f	\N	\N	\N	\N	0
7326770763685939200	Công ty Giấy An Hòa	Vĩnh Lợi, Sơn Dương, Tuyên Quang	\N	\N	\N	7320276851855168512	2025-12-17 05:44:55.881	2025-12-17 05:44:55.881	\N	t	f	f	\N	\N	\N	\N	0
7326771439014772736	Lọc hóa dầu Bình Sơn (BSR)	Bình Trị, Bình Sơn, Quảng Ngãi	\N	\N	\N	7320276851855168512	2025-12-17 05:47:36.893	2025-12-17 05:47:36.893	\N	t	f	f	\N	\N	\N	\N	0
7326771439379677184	Nhà máy Giấy Bãi Bằng	Phong Châu, Phù Ninh, Phú Thọ	\N	\N	\N	7320276851855168512	2025-12-17 05:47:36.979	2025-12-17 05:47:36.979	\N	t	f	f	\N	\N	\N	\N	0
7326771439572615168	Sữa TH True Milk	Nghĩa Sơn, Nghĩa Đàn, Nghệ An	\N	\N	\N	7320276851855168512	2025-12-17 05:47:37.025	2025-12-17 05:47:37.025	\N	t	f	f	\N	\N	\N	\N	0
7326771439765553152	Dây cáp điện CADIVI (Miền Trung)	KCN Hòa Cầm, Đà Nẵng	\N	\N	\N	7320276851855168512	2025-12-17 05:47:37.071	2025-12-17 05:47:37.071	\N	t	f	f	\N	\N	\N	\N	0
7326771439950102528	Dệt may Thành Công	KCN Tân Bình, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 05:47:37.114	2025-12-17 05:47:37.114	\N	t	f	f	\N	\N	\N	\N	0
7326771440092708864	Bánh kẹo Hữu Nghị	KCN Tiên Sơn, Bắc Ninh	\N	\N	\N	7320276851855168512	2025-12-17 05:47:37.149	2025-12-17 05:47:37.149	\N	t	f	f	\N	\N	\N	\N	0
7326771440231120896	Ống thép Hòa Phát	KCN Như Quỳnh, Văn Lâm, Hưng Yên	\N	\N	\N	7320276851855168512	2025-12-17 05:47:37.182	2025-12-17 05:47:37.182	\N	t	f	f	\N	\N	\N	\N	0
7326771440373727232	Sợi Thế Kỷ	KCN Tây Bắc Củ Chi, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 05:47:37.216	2025-12-17 05:47:37.216	\N	t	f	f	\N	\N	\N	\N	0
7326771440516333568	Đóng tàu Ba Son	KCN Phú Mỹ II, Bà Rịa - Vũng Tàu	\N	\N	\N	7320276851855168512	2025-12-17 05:47:37.25	2025-12-17 05:47:37.25	\N	t	f	f	\N	\N	\N	\N	0
7326771440642162688	Phân bón Bình Điền	KCN Long Định, Cần Đước, Long An	\N	\N	\N	7320276851855168512	2025-12-17 05:47:37.28	2025-12-17 05:47:37.28	\N	t	f	f	\N	\N	\N	\N	0
7326771440801546240	Thủy sản Sao Ta	KCN An Nghiệp, Sóc Trăng	\N	\N	\N	7320276851855168512	2025-12-17 05:47:37.318	2025-12-17 05:47:37.318	\N	t	f	f	\N	\N	\N	\N	0
7326771440923181056	May Việt Tiến	Quận Tân Bình, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 05:47:37.347	2025-12-17 05:47:37.347	\N	t	f	f	\N	\N	\N	\N	0
7326771441032232960	Dược Hậu Giang	KCN Tân Phú Thạnh, Châu Thành A, Hậu Giang	\N	\N	\N	7320276851855168512	2025-12-17 05:47:37.373	2025-12-17 05:47:37.373	\N	t	f	f	\N	\N	\N	\N	0
7326771441141284864	Nhôm Đô Thành	KCN Phú Nghĩa, Chương Mỹ, Hà Nội	\N	\N	\N	7320276851855168512	2025-12-17 05:47:37.399	2025-12-17 05:47:37.399	\N	t	f	f	\N	\N	\N	\N	0
7326771441262919680	Gạch Đồng Tâm	KCN Thuận Đạo, Bến Lức, Long An	\N	\N	\N	7320276851855168512	2025-12-17 05:47:37.427	2025-12-17 05:47:37.427	\N	t	f	f	\N	\N	\N	\N	0
7326771441376165888	Pin Ắc quy Đồng Nai (PINACO)	KCN Tân Tạo, Bình Tân, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 05:47:37.455	2025-12-17 05:47:37.455	\N	t	f	f	\N	\N	\N	\N	0
7326771441489412096	Bia Hà Nội (HABECO)	Quận Bắc Từ Liêm, Hà Nội	\N	\N	\N	7320276851855168512	2025-12-17 05:47:37.482	2025-12-17 05:47:37.482	\N	t	f	f	\N	\N	\N	\N	0
7326771441606852608	Nhà máy Đạm Hà Bắc	Phường Thọ Xương, Bắc Giang	\N	\N	\N	7320276851855168512	2025-12-17 05:47:37.509	2025-12-17 05:47:37.509	\N	t	f	f	\N	\N	\N	\N	0
7326771441724293120	Giày Thượng Đình	Quận Thanh Xuân, Hà Nội	\N	\N	\N	7320276851855168512	2025-12-17 05:47:37.538	2025-12-17 05:47:37.538	\N	t	f	f	\N	\N	\N	\N	0
7326771441833345024	Tôn Hoa Sen	KCN Phú Mỹ I, Bà Rịa - Vũng Tàu	\N	\N	\N	7320276851855168512	2025-12-17 05:47:37.564	2025-12-17 05:47:37.564	\N	t	f	f	\N	\N	\N	\N	0
7326771677156033536	Honda Việt Nam	Phúc Thắng, Phúc Yên, Vĩnh Phúc	\N	\N	\N	7320276851855168512	2025-12-17 05:48:33.671	2025-12-17 06:01:18.557	\N	f	t	f	\N	\N	\N	\N	0
7326771677416080384	Piaggio Việt Nam	KCN Bình Xuyên, Vĩnh Phúc	\N	\N	\N	7320276851855168512	2025-12-17 05:48:33.732	2025-12-17 06:01:18.597	\N	f	t	f	\N	\N	\N	\N	0
7326771677546103808	Dây cáp điện LS Vina	Sở Dầu, Hồng Bàng, Hải Phòng	\N	\N	\N	7320276851855168512	2025-12-17 05:48:33.763	2025-12-17 06:01:18.624	\N	f	t	f	\N	\N	\N	\N	0
7326771677659350016	Nhựa Tiền Phong (Hải Phòng)	Đặng Cương, An Dương, Hải Phòng	\N	\N	\N	7320276851855168512	2025-12-17 05:48:33.79	2025-12-17 06:01:18.638	\N	f	t	f	\N	\N	\N	\N	0
7326771677785179136	Dệt kim Đông Xuân	Ngô Thì Nhậm, Hai Bà Trưng, Hà Nội	\N	\N	\N	7320276851855168512	2025-12-17 05:48:33.821	2025-12-17 06:01:18.654	\N	f	t	f	\N	\N	\N	\N	0
7326771677952951296	Bánh kẹo Orion (Nhà máy Mỹ Phước)	KCN Mỹ Phước 2, Bến Cát, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:48:33.86	2025-12-17 06:01:18.669	\N	f	t	f	\N	\N	\N	\N	0
7326771678066197504	Nước giải khát Suntory PepsiCo	KCN VSIP 1, Thuận An, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:48:33.887	2025-12-17 06:01:18.686	\N	f	t	f	\N	\N	\N	\N	0
7326771678175249408	Ống nhựa Hoa Sen	KCN Nhơn Hòa, An Nhơn, Bình Định	\N	\N	\N	7320276851855168512	2025-12-17 05:48:33.913	2025-12-17 06:01:18.706	\N	f	t	f	\N	\N	\N	\N	0
7326771678292689920	Thủy sản Vĩnh Hoàn	KCN Thanh Bình, Cao Lãnh, Đồng Tháp	\N	\N	\N	7320276851855168512	2025-12-17 05:48:33.941	2025-12-17 06:01:18.726	\N	f	t	f	\N	\N	\N	\N	0
7326771678410130432	Cao su Miền Nam (CASUMINA)	KCN Tân Uyên, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:48:33.969	2025-12-17 06:01:18.74	\N	f	t	f	\N	\N	\N	\N	0
7326771678510793728	Vang Đà Lạt (Ladofoods)	Phát Chi, Đà Lạt, Lâm Đồng	\N	\N	\N	7320276851855168512	2025-12-17 05:48:33.993	2025-12-17 06:01:18.754	\N	f	t	f	\N	\N	\N	\N	0
7326771678728897536	Bút bi Thiên Long	KCN Tân Tạo, Bình Tân, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 05:48:34.045	2025-12-17 06:01:18.766	\N	f	t	f	\N	\N	\N	\N	0
7326771678837949440	May thêu giày An Lạc	An Lạc, Bình Tân, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 05:48:34.07	2025-12-17 06:01:18.779	\N	f	t	f	\N	\N	\N	\N	0
7326771678942807040	Xi măng Hà Tiên	KCN Phú Hữu, Quận 9, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 05:48:34.096	2025-12-17 06:01:18.793	\N	f	t	f	\N	\N	\N	\N	0
7326771679047664640	Gạch Taicera	KCN Gò Dầu, Long Thành, Đồng Nai	\N	\N	\N	7320276851855168512	2025-12-17 05:48:34.12	2025-12-17 06:01:18.806	\N	f	t	f	\N	\N	\N	\N	0
7326771679177688064	Dầu thực vật Tường An	KCN Vinhomes, Vinh, Nghệ An	\N	\N	\N	7320276851855168512	2025-12-17 05:48:34.152	2025-12-17 06:01:18.818	\N	f	t	f	\N	\N	\N	\N	0
7326771679278351360	Bóng đèn Phích nước Rạng Đông	Thanh Xuân, Hà Nội	\N	\N	\N	7320276851855168512	2025-12-17 05:48:34.176	2025-12-17 06:01:18.832	\N	f	t	f	\N	\N	\N	\N	0
7326771679370626048	Sợi dệt Phú Bài	KCN Phú Bài, Hương Thủy, Huế	\N	\N	\N	7320276851855168512	2025-12-17 05:48:34.198	2025-12-17 06:01:18.845	\N	f	t	f	\N	\N	\N	\N	0
7326771679458706432	Đầu tư Phát triển Gas đô thị (PV Gas City)	Tiền Hải, Thái Bình	\N	\N	\N	7320276851855168512	2025-12-17 05:48:34.219	2025-12-17 06:01:18.858	\N	f	t	f	\N	\N	\N	\N	0
7326771989996585984	Honda Việt Nam	Phúc Thắng, Phúc Yên, Vĩnh Phúc	\N	\N	\N	7320276851855168512	2025-12-17 05:49:48.257	2025-12-17 06:01:18.873	\N	f	t	f	\N	\N	\N	\N	0
7326771990235661312	Piaggio Việt Nam	KCN Bình Xuyên, Vĩnh Phúc	\N	\N	\N	7320276851855168512	2025-12-17 05:49:48.314	2025-12-17 06:01:18.886	\N	f	t	f	\N	\N	\N	\N	0
7326771990374073344	Dây cáp điện LS Vina	Sở Dầu, Hồng Bàng, Hải Phòng	\N	\N	\N	7320276851855168512	2025-12-17 05:49:48.347	2025-12-17 06:01:18.899	\N	f	t	f	\N	\N	\N	\N	0
7326771990499902464	Nhựa Tiền Phong (Hải Phòng)	Đặng Cương, An Dương, Hải Phòng	\N	\N	\N	7320276851855168512	2025-12-17 05:49:48.377	2025-12-17 06:01:18.913	\N	f	t	f	\N	\N	\N	\N	0
7326771990625731584	Dệt kim Đông Xuân	Ngô Thì Nhậm, Hai Bà Trưng, Hà Nội	\N	\N	\N	7320276851855168512	2025-12-17 05:49:48.407	2025-12-17 06:01:18.925	\N	f	t	f	\N	\N	\N	\N	0
7326771990743172096	Bánh kẹo Orion (Nhà máy Mỹ Phước)	KCN Mỹ Phước 2, Bến Cát, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:49:48.435	2025-12-17 06:01:18.938	\N	f	t	f	\N	\N	\N	\N	0
7326771990869001216	Nước giải khát Suntory PepsiCo	KCN VSIP 1, Thuận An, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:49:48.465	2025-12-17 06:01:18.963	\N	f	t	f	\N	\N	\N	\N	0
7326771991003218944	Ống nhựa Hoa Sen	KCN Nhơn Hòa, An Nhơn, Bình Định	\N	\N	\N	7320276851855168512	2025-12-17 05:49:48.497	2025-12-17 06:01:18.987	\N	f	t	f	\N	\N	\N	\N	0
7326771991133242368	Thủy sản Vĩnh Hoàn	KCN Thanh Bình, Cao Lãnh, Đồng Tháp	\N	\N	\N	7320276851855168512	2025-12-17 05:49:48.528	2025-12-17 06:01:19.003	\N	f	t	f	\N	\N	\N	\N	0
7326771991271654400	Cao su Miền Nam (CASUMINA)	KCN Tân Uyên, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:49:48.561	2025-12-17 06:01:19.017	\N	f	t	f	\N	\N	\N	\N	0
7326771991401677824	Vang Đà Lạt (Ladofoods)	Phát Chi, Đà Lạt, Lâm Đồng	\N	\N	\N	7320276851855168512	2025-12-17 05:49:48.592	2025-12-17 06:01:19.03	\N	f	t	f	\N	\N	\N	\N	0
7326771991623975936	Bút bi Thiên Long	KCN Tân Tạo, Bình Tân, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 05:49:48.645	2025-12-17 06:01:19.044	\N	f	t	f	\N	\N	\N	\N	0
7326771991741416448	May thêu giày An Lạc	An Lạc, Bình Tân, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 05:49:48.673	2025-12-17 06:01:19.056	\N	f	t	f	\N	\N	\N	\N	0
7326771991846274048	Xi măng Hà Tiên	KCN Phú Hữu, Quận 9, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 05:49:48.697	2025-12-17 06:01:19.068	\N	f	t	f	\N	\N	\N	\N	0
7326771991963714560	Gạch Taicera	KCN Gò Dầu, Long Thành, Đồng Nai	\N	\N	\N	7320276851855168512	2025-12-17 05:49:48.725	2025-12-17 06:01:19.081	\N	f	t	f	\N	\N	\N	\N	0
7326771992076960768	Dầu thực vật Tường An	KCN Vinhomes, Vinh, Nghệ An	\N	\N	\N	7320276851855168512	2025-12-17 05:49:48.753	2025-12-17 06:01:19.096	\N	f	t	f	\N	\N	\N	\N	0
7326771992202789888	Bóng đèn Phích nước Rạng Đông	Thanh Xuân, Hà Nội	\N	\N	\N	7320276851855168512	2025-12-17 05:49:48.783	2025-12-17 06:01:19.108	\N	f	t	f	\N	\N	\N	\N	0
7326771992324424704	Sợi dệt Phú Bài	KCN Phú Bài, Hương Thủy, Huế	\N	\N	\N	7320276851855168512	2025-12-17 05:49:48.812	2025-12-17 06:01:19.12	\N	f	t	f	\N	\N	\N	\N	0
7326772028483519488	Honda Việt Nam	Phúc Thắng, Phúc Yên, Vĩnh Phúc	\N	\N	\N	7320276851855168512	2025-12-17 05:49:57.433	2025-12-17 06:01:19.147	\N	f	t	f	\N	\N	\N	\N	0
7326772028861006848	Piaggio Việt Nam	KCN Bình Xuyên, Vĩnh Phúc	\N	\N	\N	7320276851855168512	2025-12-17 05:49:57.522	2025-12-17 06:01:19.159	\N	f	t	f	\N	\N	\N	\N	0
7326771992555111424	May mặc Hanosimex	KCN Đồng Văn, Duy Tiên, Hà Nam	\N	\N	\N	7320276851855168512	2025-12-17 05:49:48.867	2025-12-17 06:01:19.171	\N	f	t	f	\N	\N	\N	\N	0
7326772029074916352	Dây cáp điện LS Vina	Sở Dầu, Hồng Bàng, Hải Phòng	\N	\N	\N	7320276851855168512	2025-12-17 05:49:57.574	2025-12-17 06:01:19.184	\N	f	t	f	\N	\N	\N	\N	0
7326772029272048640	Nhựa Tiền Phong (Hải Phòng)	Đặng Cương, An Dương, Hải Phòng	\N	\N	\N	7320276851855168512	2025-12-17 05:49:57.621	2025-12-17 06:01:19.196	\N	f	t	f	\N	\N	\N	\N	0
7326772029448209408	Dệt kim Đông Xuân	Ngô Thì Nhậm, Hai Bà Trưng, Hà Nội	\N	\N	\N	7320276851855168512	2025-12-17 05:49:57.663	2025-12-17 06:01:19.211	\N	f	t	f	\N	\N	\N	\N	0
7326772029569844224	Bánh kẹo Orion (Nhà máy Mỹ Phước)	KCN Mỹ Phước 2, Bến Cát, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:49:57.692	2025-12-17 06:01:19.223	\N	f	t	f	\N	\N	\N	\N	0
7326772029678896128	Nước giải khát Suntory PepsiCo	KCN VSIP 1, Thuận An, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:49:57.718	2025-12-17 06:01:19.236	\N	f	t	f	\N	\N	\N	\N	0
7326772029792142336	Ống nhựa Hoa Sen	KCN Nhơn Hòa, An Nhơn, Bình Định	\N	\N	\N	7320276851855168512	2025-12-17 05:49:57.744	2025-12-17 06:01:19.248	\N	f	t	f	\N	\N	\N	\N	0
7326772029896999936	Thủy sản Vĩnh Hoàn	KCN Thanh Bình, Cao Lãnh, Đồng Tháp	\N	\N	\N	7320276851855168512	2025-12-17 05:49:57.77	2025-12-17 06:01:19.26	\N	f	t	f	\N	\N	\N	\N	0
7326772030010246144	Cao su Miền Nam (CASUMINA)	KCN Tân Uyên, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:49:57.797	2025-12-17 06:01:19.273	\N	f	t	f	\N	\N	\N	\N	0
7326772030136075264	Vang Đà Lạt (Ladofoods)	Phát Chi, Đà Lạt, Lâm Đồng	\N	\N	\N	7320276851855168512	2025-12-17 05:49:57.827	2025-12-17 06:01:19.286	\N	f	t	f	\N	\N	\N	\N	0
7326772030266098688	Bút bi Thiên Long	KCN Tân Tạo, Bình Tân, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 05:49:57.858	2025-12-17 06:01:19.298	\N	f	t	f	\N	\N	\N	\N	0
7326772030563894272	May thêu giày An Lạc	An Lạc, Bình Tân, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 05:49:57.929	2025-12-17 06:01:19.31	\N	f	t	f	\N	\N	\N	\N	0
7326772030819746816	Xi măng Hà Tiên	KCN Phú Hữu, Quận 9, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 05:49:57.99	2025-12-17 06:01:19.323	\N	f	t	f	\N	\N	\N	\N	0
7326772030970741760	Gạch Taicera	KCN Gò Dầu, Long Thành, Đồng Nai	\N	\N	\N	7320276851855168512	2025-12-17 05:49:58.026	2025-12-17 06:01:19.335	\N	f	t	f	\N	\N	\N	\N	0
7326772031079793664	Dầu thực vật Tường An	KCN Vinhomes, Vinh, Nghệ An	\N	\N	\N	7320276851855168512	2025-12-17 05:49:58.052	2025-12-17 06:01:19.348	\N	f	t	f	\N	\N	\N	\N	0
7326772031184651264	Bóng đèn Phích nước Rạng Đông	Thanh Xuân, Hà Nội	\N	\N	\N	7320276851855168512	2025-12-17 05:49:58.077	2025-12-17 06:01:19.359	\N	f	t	f	\N	\N	\N	\N	0
7326772031302091776	Sợi dệt Phú Bài	KCN Phú Bài, Hương Thủy, Huế	\N	\N	\N	7320276851855168512	2025-12-17 05:49:58.105	2025-12-17 06:01:19.373	\N	f	t	f	\N	\N	\N	\N	0
7326772031411143680	Đầu tư Phát triển Gas đô thị (PV Gas City)	Tiền Hải, Thái Bình	\N	\N	\N	7320276851855168512	2025-12-17 05:49:58.13	2025-12-17 06:01:19.385	\N	f	t	f	\N	\N	\N	\N	0
7326772204803671040	Honda Việt Nam	Phúc Thắng, Phúc Yên, Vĩnh Phúc	\N	\N	\N	7320276851855168512	2025-12-17 05:50:39.471	2025-12-17 06:01:19.406	\N	f	t	f	\N	\N	\N	\N	0
7326772205055329280	Piaggio Việt Nam	KCN Bình Xuyên, Vĩnh Phúc	\N	\N	\N	7320276851855168512	2025-12-17 05:50:39.531	2025-12-17 06:01:19.419	\N	f	t	f	\N	\N	\N	\N	0
7326772205160186880	Dây cáp điện LS Vina	Sở Dầu, Hồng Bàng, Hải Phòng	\N	\N	\N	7320276851855168512	2025-12-17 05:50:39.556	2025-12-17 06:01:19.432	\N	f	t	f	\N	\N	\N	\N	0
7326772205277627392	Nhựa Tiền Phong (Hải Phòng)	Đặng Cương, An Dương, Hải Phòng	\N	\N	\N	7320276851855168512	2025-12-17 05:50:39.584	2025-12-17 06:01:19.443	\N	f	t	f	\N	\N	\N	\N	0
7326772205390873600	Dệt kim Đông Xuân	Ngô Thì Nhậm, Hai Bà Trưng, Hà Nội	\N	\N	\N	7320276851855168512	2025-12-17 05:50:39.611	2025-12-17 06:01:19.457	\N	f	t	f	\N	\N	\N	\N	0
7326772205600588800	Nước giải khát Suntory PepsiCo	KCN VSIP 1, Thuận An, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:50:39.661	2025-12-17 06:01:19.481	\N	f	t	f	\N	\N	\N	\N	0
7326772205713835008	Ống nhựa Hoa Sen	KCN Nhơn Hòa, An Nhơn, Bình Định	\N	\N	\N	7320276851855168512	2025-12-17 05:50:39.688	2025-12-17 06:01:19.495	\N	f	t	f	\N	\N	\N	\N	0
7326772205810304000	Thủy sản Vĩnh Hoàn	KCN Thanh Bình, Cao Lãnh, Đồng Tháp	\N	\N	\N	7320276851855168512	2025-12-17 05:50:39.711	2025-12-17 06:01:19.508	\N	f	t	f	\N	\N	\N	\N	0
7326772205936133120	Cao su Miền Nam (CASUMINA)	KCN Tân Uyên, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:50:39.74	2025-12-17 06:01:19.52	\N	f	t	f	\N	\N	\N	\N	0
7326772206057767936	Vang Đà Lạt (Ladofoods)	Phát Chi, Đà Lạt, Lâm Đồng	\N	\N	\N	7320276851855168512	2025-12-17 05:50:39.77	2025-12-17 06:01:19.532	\N	f	t	f	\N	\N	\N	\N	0
7326772206158431232	Bút bi Thiên Long	KCN Tân Tạo, Bình Tân, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 05:50:39.794	2025-12-17 06:01:19.545	\N	f	t	f	\N	\N	\N	\N	0
7326772206263288832	May thêu giày An Lạc	An Lạc, Bình Tân, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 05:50:39.818	2025-12-17 06:01:19.557	\N	f	t	f	\N	\N	\N	\N	0
7326772206359757824	Xi măng Hà Tiên	KCN Phú Hữu, Quận 9, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 05:50:39.842	2025-12-17 06:01:19.57	\N	f	t	f	\N	\N	\N	\N	0
7326772206523335680	Gạch Taicera	KCN Gò Dầu, Long Thành, Đồng Nai	\N	\N	\N	7320276851855168512	2025-12-17 05:50:39.88	2025-12-17 06:01:19.582	\N	f	t	f	\N	\N	\N	\N	0
7326772206661747712	Dầu thực vật Tường An	KCN Vinhomes, Vinh, Nghệ An	\N	\N	\N	7320276851855168512	2025-12-17 05:50:39.914	2025-12-17 06:01:19.596	\N	f	t	f	\N	\N	\N	\N	0
7326772206867268608	Bóng đèn Phích nước Rạng Đông	Thanh Xuân, Hà Nội	\N	\N	\N	7320276851855168512	2025-12-17 05:50:39.963	2025-12-17 06:01:19.607	\N	f	t	f	\N	\N	\N	\N	0
7326772207089566720	Sợi dệt Phú Bài	KCN Phú Bài, Hương Thủy, Huế	\N	\N	\N	7320276851855168512	2025-12-17 05:50:40.016	2025-12-17 06:01:19.619	\N	f	t	f	\N	\N	\N	\N	0
7326772207274116096	Đầu tư Phát triển Gas đô thị (PV Gas City)	Tiền Hải, Thái Bình	\N	\N	\N	7320276851855168512	2025-12-17 05:50:40.06	2025-12-17 06:01:19.631	\N	f	t	f	\N	\N	\N	\N	0
7326772429645232128	Honda Việt Nam	Phúc Thắng, Phúc Yên, Vĩnh Phúc	\N	\N	\N	7320276851855168512	2025-12-17 05:51:33.077	2025-12-17 06:01:19.643	\N	f	t	f	\N	\N	\N	\N	0
7326772429875918848	Piaggio Việt Nam	KCN Bình Xuyên, Vĩnh Phúc	\N	\N	\N	7320276851855168512	2025-12-17 05:51:33.132	2025-12-17 06:01:19.659	\N	f	t	f	\N	\N	\N	\N	0
7326772430001747968	Dây cáp điện LS Vina	Sở Dầu, Hồng Bàng, Hải Phòng	\N	\N	\N	7320276851855168512	2025-12-17 05:51:33.162	2025-12-17 06:01:19.671	\N	f	t	f	\N	\N	\N	\N	0
7326772430135965696	Nhựa Tiền Phong (Hải Phòng)	Đặng Cương, An Dương, Hải Phòng	\N	\N	\N	7320276851855168512	2025-12-17 05:51:33.193	2025-12-17 06:01:19.683	\N	f	t	f	\N	\N	\N	\N	0
7326772430249211904	Dệt kim Đông Xuân	Ngô Thì Nhậm, Hai Bà Trưng, Hà Nội	\N	\N	\N	7320276851855168512	2025-12-17 05:51:33.221	2025-12-17 06:01:19.695	\N	f	t	f	\N	\N	\N	\N	0
7326772207555134464	May mặc Hanosimex	KCN Đồng Văn, Duy Tiên, Hà Nam	\N	\N	\N	7320276851855168512	2025-12-17 05:50:40.127	2025-12-17 06:01:19.712	\N	f	t	f	\N	\N	\N	\N	0
7326773212938904576	Công ty Lego Việt Nam	KCN VSIP III, Tân Uyên, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:54:39.829	2025-12-17 05:54:39.829	\N	t	f	f	\N	\N	\N	\N	0
7326773213169591296	Pin năng lượng mặt trời First Solar	KCN Đông Nam, Củ Chi, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 05:54:39.884	2025-12-17 05:54:39.884	\N	t	f	f	\N	\N	\N	\N	0
7326773213287031808	Nhà máy Coca-Cola Việt Nam	Xã Long Hiệp, Bến Lức, Long An	\N	\N	\N	7320276851855168512	2025-12-17 05:54:39.911	2025-12-17 05:54:39.911	\N	t	f	f	\N	\N	\N	\N	0
7326773213412860928	Tập đoàn Lộc Trời	KCN Vĩnh Lộc, An Giang	\N	\N	\N	7320276851855168512	2025-12-17 05:54:39.942	2025-12-17 05:54:39.942	\N	t	f	f	\N	\N	\N	\N	0
7326773213530301440	Sữa đậu nành Fami (Vinasoy)	KCN Tiên Sơn, Bắc Ninh	\N	\N	\N	7320276851855168512	2025-12-17 05:54:39.97	2025-12-17 05:54:39.97	\N	t	f	f	\N	\N	\N	\N	0
7326773213651936256	Công ty Nhựa Rạng Đông Long An	KCN Tân Đô, Đức Hòa, Long An	\N	\N	\N	7320276851855168512	2025-12-17 05:54:39.999	2025-12-17 05:54:39.999	\N	t	f	f	\N	\N	\N	\N	0
7326772430488287232	Nước giải khát Suntory PepsiCo	KCN VSIP 1, Thuận An, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:51:33.278	2025-12-17 06:01:19.737	\N	f	t	f	\N	\N	\N	\N	0
7326772430626699264	Ống nhựa Hoa Sen	KCN Nhơn Hòa, An Nhơn, Bình Định	\N	\N	\N	7320276851855168512	2025-12-17 05:51:33.311	2025-12-17 06:01:19.749	\N	f	t	f	\N	\N	\N	\N	0
7326772430781888512	Thủy sản Vĩnh Hoàn	KCN Thanh Bình, Cao Lãnh, Đồng Tháp	\N	\N	\N	7320276851855168512	2025-12-17 05:51:33.348	2025-12-17 06:01:19.763	\N	f	t	f	\N	\N	\N	\N	0
7326772430911911936	Cao su Miền Nam (CASUMINA)	KCN Tân Uyên, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:51:33.379	2025-12-17 06:01:19.776	\N	f	t	f	\N	\N	\N	\N	0
7326772431029352448	Vang Đà Lạt (Ladofoods)	Phát Chi, Đà Lạt, Lâm Đồng	\N	\N	\N	7320276851855168512	2025-12-17 05:51:33.407	2025-12-17 06:01:19.788	\N	f	t	f	\N	\N	\N	\N	0
7326772431167764480	Bút bi Thiên Long	KCN Tân Tạo, Bình Tân, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 05:51:33.44	2025-12-17 06:01:19.801	\N	f	t	f	\N	\N	\N	\N	0
7326772431301982208	May thêu giày An Lạc	An Lạc, Bình Tân, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 05:51:33.472	2025-12-17 06:01:19.814	\N	f	t	f	\N	\N	\N	\N	0
7326772431440394240	Xi măng Hà Tiên	KCN Phú Hữu, Quận 9, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 05:51:33.505	2025-12-17 06:01:19.825	\N	f	t	f	\N	\N	\N	\N	0
7326772431557834752	Gạch Taicera	KCN Gò Dầu, Long Thành, Đồng Nai	\N	\N	\N	7320276851855168512	2025-12-17 05:51:33.533	2025-12-17 06:01:19.837	\N	f	t	f	\N	\N	\N	\N	0
7326772431721412608	Dầu thực vật Tường An	KCN Vinhomes, Vinh, Nghệ An	\N	\N	\N	7320276851855168512	2025-12-17 05:51:33.572	2025-12-17 06:01:19.849	\N	f	t	f	\N	\N	\N	\N	0
7326772431868213248	Bóng đèn Phích nước Rạng Đông	Thanh Xuân, Hà Nội	\N	\N	\N	7320276851855168512	2025-12-17 05:51:33.607	2025-12-17 06:01:19.862	\N	f	t	f	\N	\N	\N	\N	0
7326772432044374016	Sợi dệt Phú Bài	KCN Phú Bài, Hương Thủy, Huế	\N	\N	\N	7320276851855168512	2025-12-17 05:51:33.649	2025-12-17 06:01:19.874	\N	f	t	f	\N	\N	\N	\N	0
7326772432207951872	Đầu tư Phát triển Gas đô thị (PV Gas City)	Tiền Hải, Thái Bình	\N	\N	\N	7320276851855168512	2025-12-17 05:51:33.688	2025-12-17 06:01:19.887	\N	f	t	f	\N	\N	\N	\N	0
7326772868724958208	Honda Việt Nam	Phúc Thắng, Phúc Yên, Vĩnh Phúc	\N	\N	\N	7320276851855168512	2025-12-17 05:53:17.762	2025-12-17 06:01:19.9	\N	f	t	f	\N	\N	\N	\N	0
7326772869014365184	Piaggio Việt Nam	KCN Bình Xuyên, Vĩnh Phúc	\N	\N	\N	7320276851855168512	2025-12-17 05:53:17.831	2025-12-17 06:01:19.916	\N	f	t	f	\N	\N	\N	\N	0
7326772869165360128	Dây cáp điện LS Vina	Sở Dầu, Hồng Bàng, Hải Phòng	\N	\N	\N	7320276851855168512	2025-12-17 05:53:17.867	2025-12-17 06:01:19.928	\N	f	t	f	\N	\N	\N	\N	0
7326772869307966464	Nhựa Tiền Phong (Hải Phòng)	Đặng Cương, An Dương, Hải Phòng	\N	\N	\N	7320276851855168512	2025-12-17 05:53:17.901	2025-12-17 06:01:19.943	\N	f	t	f	\N	\N	\N	\N	0
7326772869442184192	Dệt kim Đông Xuân	Ngô Thì Nhậm, Hai Bà Trưng, Hà Nội	\N	\N	\N	7320276851855168512	2025-12-17 05:53:17.933	2025-12-17 06:01:19.955	\N	f	t	f	\N	\N	\N	\N	0
7326772869576401920	Bánh kẹo Orion (Nhà máy Mỹ Phước)	KCN Mỹ Phước 2, Bến Cát, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:53:17.965	2025-12-17 06:01:19.968	\N	f	t	f	\N	\N	\N	\N	0
7326772869719008256	Nước giải khát Suntory PepsiCo	KCN VSIP 1, Thuận An, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:53:17.999	2025-12-17 06:01:19.979	\N	f	t	f	\N	\N	\N	\N	0
7326772869853225984	Ống nhựa Hoa Sen	KCN Nhơn Hòa, An Nhơn, Bình Định	\N	\N	\N	7320276851855168512	2025-12-17 05:53:18.031	2025-12-17 06:01:19.991	\N	f	t	f	\N	\N	\N	\N	0
7326772869983249408	Thủy sản Vĩnh Hoàn	KCN Thanh Bình, Cao Lãnh, Đồng Tháp	\N	\N	\N	7320276851855168512	2025-12-17 05:53:18.062	2025-12-17 06:01:20.002	\N	f	t	f	\N	\N	\N	\N	0
7326772870104884224	Cao su Miền Nam (CASUMINA)	KCN Tân Uyên, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:53:18.091	2025-12-17 06:01:20.02	\N	f	t	f	\N	\N	\N	\N	0
7326772870239101952	Vang Đà Lạt (Ladofoods)	Phát Chi, Đà Lạt, Lâm Đồng	\N	\N	\N	7320276851855168512	2025-12-17 05:53:18.122	2025-12-17 06:01:20.032	\N	f	t	f	\N	\N	\N	\N	0
7326772870369125376	Bút bi Thiên Long	KCN Tân Tạo, Bình Tân, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 05:53:18.154	2025-12-17 06:01:20.043	\N	f	t	f	\N	\N	\N	\N	0
7326772870494954496	May thêu giày An Lạc	An Lạc, Bình Tân, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 05:53:18.184	2025-12-17 06:01:20.055	\N	f	t	f	\N	\N	\N	\N	0
7326772870612395008	Xi măng Hà Tiên	KCN Phú Hữu, Quận 9, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 05:53:18.212	2025-12-17 06:01:20.066	\N	f	t	f	\N	\N	\N	\N	0
7326772870801138688	Gạch Taicera	KCN Gò Dầu, Long Thành, Đồng Nai	\N	\N	\N	7320276851855168512	2025-12-17 05:53:18.257	2025-12-17 06:01:20.089	\N	f	t	f	\N	\N	\N	\N	0
7326772870939550720	Dầu thực vật Tường An	KCN Vinhomes, Vinh, Nghệ An	\N	\N	\N	7320276851855168512	2025-12-17 05:53:18.289	2025-12-17 06:01:20.102	\N	f	t	f	\N	\N	\N	\N	0
7326772871073768448	Bóng đèn Phích nước Rạng Đông	Thanh Xuân, Hà Nội	\N	\N	\N	7320276851855168512	2025-12-17 05:53:18.322	2025-12-17 06:01:20.115	\N	f	t	f	\N	\N	\N	\N	0
7326772871199597568	Sợi dệt Phú Bài	KCN Phú Bài, Hương Thủy, Huế	\N	\N	\N	7320276851855168512	2025-12-17 05:53:18.352	2025-12-17 06:01:20.129	\N	f	t	f	\N	\N	\N	\N	0
7326772871346398208	Đầu tư Phát triển Gas đô thị (PV Gas City)	Tiền Hải, Thái Bình	\N	\N	\N	7320276851855168512	2025-12-17 05:53:18.387	2025-12-17 06:01:20.141	\N	f	t	f	\N	\N	\N	\N	0
7326772871468033024	May mặc Hanosimex	KCN Đồng Văn, Duy Tiên, Hà Nam	\N	\N	\N	7320276851855168512	2025-12-17 05:53:18.416	2025-12-17 06:01:20.153	\N	f	t	f	\N	\N	\N	\N	0
7326771679563564032	May mặc Hanosimex	KCN Đồng Văn, Duy Tiên, Hà Nam	\N	\N	\N	7320276851855168512	2025-12-17 05:48:34.243	2025-12-17 06:01:20.165	\N	f	t	f	\N	\N	\N	\N	0
7326772031507612672	May mặc Hanosimex	KCN Đồng Văn, Duy Tiên, Hà Nam	\N	\N	\N	7320276851855168512	2025-12-17 05:49:58.154	2025-12-17 06:01:20.177	\N	f	t	f	\N	\N	\N	\N	0
7326772432405084160	May mặc Hanosimex	KCN Đồng Văn, Duy Tiên, Hà Nam	\N	\N	\N	7320276851855168512	2025-12-17 05:51:33.735	2025-12-17 06:01:20.189	\N	f	t	f	\N	\N	\N	\N	0
7326773213794542592	Dây cáp điện Taya Việt Nam	KCN Biên Hòa 2, Đồng Nai	\N	\N	\N	7320276851855168512	2025-12-17 05:54:40.033	2025-12-17 05:54:40.033	\N	t	f	f	\N	\N	\N	\N	0
7326773213903594496	Nệm Vạn Thành	KCN Tân Quang, Hóc Môn, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 05:54:40.059	2025-12-17 05:54:40.059	\N	t	f	f	\N	\N	\N	\N	0
7326773214025229312	Công ty Giấy Lee & Man	KCN Sông Hậu, Hậu Giang	\N	\N	\N	7320276851855168512	2025-12-17 05:54:40.088	2025-12-17 05:54:40.088	\N	t	f	f	\N	\N	\N	\N	0
7326773214134281216	Dược phẩm Sanofi Việt Nam	Khu Công nghệ cao, Thủ Đức, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 05:54:40.114	2025-12-17 05:54:40.114	\N	t	f	f	\N	\N	\N	\N	0
7326773214260110336	Sợi dệt Meisheng	KCN Mỹ Xuân A2, Bà Rịa - Vũng Tàu	\N	\N	\N	7320276851855168512	2025-12-17 05:54:40.144	2025-12-17 05:54:40.144	\N	t	f	f	\N	\N	\N	\N	0
7326773214394328064	Công ty Thực phẩm Masan	KCN Tân Đông Hiệp, Dĩ An, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:54:40.176	2025-12-17 05:54:40.176	\N	t	f	f	\N	\N	\N	\N	0
7326773214524351488	Ống thép SeAH Việt Nam	KCN Biên Hòa 2, Đồng Nai	\N	\N	\N	7320276851855168512	2025-12-17 05:54:40.206	2025-12-17 05:54:40.206	\N	t	f	f	\N	\N	\N	\N	0
7326773214641792000	Dệt may Phong Phú	Đường Tăng Nhơn Phú, Thủ Đức, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 05:54:40.235	2025-12-17 05:54:40.235	\N	t	f	f	\N	\N	\N	\N	0
7326773214750843904	Cao su Inoue Việt Nam	Quang Minh, Mê Linh, Hà Nội	\N	\N	\N	7320276851855168512	2025-12-17 05:54:40.261	2025-12-17 05:54:40.261	\N	t	f	f	\N	\N	\N	\N	0
7326773214868284416	Bánh kẹo Bibica	KCN Mỹ Phước 1, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:54:40.288	2025-12-17 05:54:40.288	\N	t	f	f	\N	\N	\N	\N	0
7326773214981530624	Công ty Xi măng Fico	Tân Châu, Tây Ninh	\N	\N	\N	7320276851855168512	2025-12-17 05:54:40.316	2025-12-17 05:54:40.316	\N	t	f	f	\N	\N	\N	\N	0
7326773215111554048	Thủy sản C.P. Bến Tre	KCN An Hiệp, Bến Tre	\N	\N	\N	7320276851855168512	2025-12-17 05:54:40.347	2025-12-17 05:54:40.347	\N	t	f	f	\N	\N	\N	\N	0
7326773215228994560	Công ty Cổ phần Diana Unicharm	KCN Tân Chi, Tiên Du, Bắc Ninh	\N	\N	\N	7320276851855168512	2025-12-17 05:54:40.374	2025-12-17 05:54:40.374	\N	t	f	f	\N	\N	\N	\N	0
7326773215363212288	Nhôm Kim Hằng	KCN Tân Tạo, Bình Tân, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 05:54:40.407	2025-12-17 05:54:40.407	\N	t	f	f	\N	\N	\N	\N	0
7326773402013934592	VinFast Trading & Production	KCN Đình Vũ, Cát Hải, Hải Phòng	\N	\N	\N	7320276851855168512	2025-12-17 05:55:24.908	2025-12-17 05:55:24.908	\N	t	f	f	\N	\N	\N	\N	0
7326773402206872576	Công ty TNHH Hana Micron Vina	KCN Vân Trung, Việt Yên, Bắc Giang	\N	\N	\N	7320276851855168512	2025-12-17 05:55:24.954	2025-12-17 05:55:24.954	\N	t	f	f	\N	\N	\N	\N	0
7326773402328507392	Amkor Technology Việt Nam	KCN Yên Phong II-C, Bắc Ninh	\N	\N	\N	7320276851855168512	2025-12-17 05:55:24.983	2025-12-17 05:55:24.983	\N	t	f	f	\N	\N	\N	\N	0
7326773402437559296	Nước giải khát Coca-Cola (Nhà máy mới)	KCN Phú An Thạnh, Bến Lức, Long An	\N	\N	\N	7320276851855168512	2025-12-17 05:55:25.009	2025-12-17 05:55:25.009	\N	t	f	f	\N	\N	\N	\N	0
7326773402554999808	PepsiCo Foods (Nhà máy mới Hà Nam)	KCN Đồng Văn I, Duy Tiên, Hà Nam	\N	\N	\N	7320276851855168512	2025-12-17 05:55:25.037	2025-12-17 05:55:25.037	\N	t	f	f	\N	\N	\N	\N	0
7326773402672440320	Tập đoàn Deli Việt Nam	KCN Yên Phong, Bắc Ninh	\N	\N	\N	7320276851855168512	2025-12-17 05:55:25.064	2025-12-17 05:55:25.064	\N	t	f	f	\N	\N	\N	\N	0
7326773402785686528	Nhà máy thực phẩm Nestlé Bông Sen	KCN Thăng Long II, Hưng Yên	\N	\N	\N	7320276851855168512	2025-12-17 05:55:25.092	2025-12-17 05:55:25.092	\N	t	f	f	\N	\N	\N	\N	0
7326773402882155520	Công ty Cheng Loong Bình Dương Paper	KCN Quốc tế Protrade, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:55:25.115	2025-12-17 05:55:25.115	\N	t	f	f	\N	\N	\N	\N	0
7326773402995401728	Công ty Sailun (Nhà máy lốp xe cao cấp)	KCN Phước Đông, Tây Ninh	\N	\N	\N	7320276851855168512	2025-12-17 05:55:25.142	2025-12-17 05:55:25.142	\N	t	f	f	\N	\N	\N	\N	0
7326773403104453632	Công ty Cổ phần Thép Pomina 2	KCN Phú Mỹ I, Bà Rịa - Vũng Tàu	\N	\N	\N	7320276851855168512	2025-12-17 05:55:25.168	2025-12-17 05:55:25.168	\N	t	f	f	\N	\N	\N	\N	0
7326773403234477056	Nhà máy bia Heineken (Tiền Giang)	KCN Mỹ Tho, Tiền Giang	\N	\N	\N	7320276851855168512	2025-12-17 05:55:25.199	2025-12-17 05:55:25.199	\N	t	f	f	\N	\N	\N	\N	0
7326773403356111872	Công ty TNHH Polytex Far Eastern	KCN Bàu Bàng, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:55:25.228	2025-12-17 05:55:25.228	\N	t	f	f	\N	\N	\N	\N	0
7326773403477746688	Công ty TNHH Gain Lucky (Việt Nam)	KCN Phước Đông, Tây Ninh	\N	\N	\N	7320276851855168512	2025-12-17 05:55:25.257	2025-12-17 05:55:25.257	\N	t	f	f	\N	\N	\N	\N	0
7326773403628741632	Công ty TNHH First Team Việt Nam	KCN Thành Thành Công, Tây Ninh	\N	\N	\N	7320276851855168512	2025-12-17 05:55:25.293	2025-12-17 05:55:25.293	\N	t	f	f	\N	\N	\N	\N	0
7326773403775542272	Công ty Thực phẩm Cholimex	KCN Vĩnh Lộc, Bình Chánh, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 05:55:25.327	2025-12-17 05:55:25.327	\N	t	f	f	\N	\N	\N	\N	0
7326773403892982784	Công ty Điện tử Meiko Việt Nam	KCN Thạch Thất, Hà Nội	\N	\N	\N	7320276851855168512	2025-12-17 05:55:25.356	2025-12-17 05:55:25.356	\N	t	f	f	\N	\N	\N	\N	0
7326773404039783424	Nhà máy ống thép Nippon Steel	KCN Phú Mỹ II, Bà Rịa - Vũng Tàu	\N	\N	\N	7320276851855168512	2025-12-17 05:55:25.391	2025-12-17 05:55:25.391	\N	t	f	f	\N	\N	\N	\N	0
7326773404144641024	Công ty May mặc Crystal Martin	KCN Quang Châu, Bắc Giang	\N	\N	\N	7320276851855168512	2025-12-17 05:55:25.416	2025-12-17 05:55:25.416	\N	t	f	f	\N	\N	\N	\N	0
7326773404266275840	Công ty TNHH Wacoal Việt Nam	KCN Amata, Đồng Nai	\N	\N	\N	7320276851855168512	2025-12-17 05:55:25.446	2025-12-17 05:55:25.446	\N	t	f	f	\N	\N	\N	\N	0
7326773404400493568	Tập đoàn Sunhouse	KCN Ngọc Liệp, Quốc Oai, Hà Nội	\N	\N	\N	7320276851855168512	2025-12-17 05:55:25.477	2025-12-17 05:55:25.477	\N	t	f	f	\N	\N	\N	\N	0
7326773616686801920	Universal Alloy Corporation (UAC)	Khu công nghệ cao Đà Nẵng	\N	\N	\N	7320276851855168512	2025-12-17 05:56:16.09	2025-12-17 05:56:16.09	\N	t	f	f	\N	\N	\N	\N	0
7326773616904905728	Nhà máy sản xuất lốp xe Kumho Việt Nam	KCN Mỹ Phước 3, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:56:16.142	2025-12-17 05:56:16.142	\N	t	f	f	\N	\N	\N	\N	0
7326773617009763328	Công ty Pegatron Việt Nam	KCN DEEP C 2A, Hải Phòng	\N	\N	\N	7320276851855168512	2025-12-17 05:56:16.167	2025-12-17 05:56:16.167	\N	t	f	f	\N	\N	\N	\N	0
7326773617127203840	Công ty TNHH Compal Việt Nam	KCN Liên Hà Thái, Thái Bình	\N	\N	\N	7320276851855168512	2025-12-17 05:56:16.195	2025-12-17 05:56:16.195	\N	t	f	f	\N	\N	\N	\N	0
7326773617244644352	Tập đoàn Khoa học Kỹ thuật Hồng Hải (Foxconn Quảng Ninh)	KCN Đông Mai, Quảng Ninh	\N	\N	\N	7320276851855168512	2025-12-17 05:56:16.223	2025-12-17 05:56:16.223	\N	t	f	f	\N	\N	\N	\N	0
7326773617362084864	Nhà máy sản xuất linh kiện hàng không Hanwha Aero Engines	Khu CNC Hòa Lạc, Hà Nội	\N	\N	\N	7320276851855168512	2025-12-17 05:56:16.251	2025-12-17 05:56:16.251	\N	t	f	f	\N	\N	\N	\N	0
7326773617483719680	Công ty Cổ phần Thủy sản Minh Phú Hậu Giang	KCN Sông Hậu, Hậu Giang	\N	\N	\N	7320276851855168512	2025-12-17 05:56:16.279	2025-12-17 05:56:16.279	\N	t	f	f	\N	\N	\N	\N	0
7326773617605354496	Nhà máy lọc dầu Nghi Sơn (NSRP)	KKT Nghi Sơn, Thanh Hóa	\N	\N	\N	7320276851855168512	2025-12-17 05:56:16.309	2025-12-17 05:56:16.309	\N	t	f	f	\N	\N	\N	\N	0
7326773617718600704	Công ty TNHH Điện tử Jabil Việt Nam	Khu CNC Thủ Đức, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 05:56:16.336	2025-12-17 05:56:16.336	\N	t	f	f	\N	\N	\N	\N	0
7326773617861207040	Tổng công ty May 10 (Hà Nội)	Gia Lâm, Hà Nội	\N	\N	\N	7320276851855168512	2025-12-17 05:56:16.37	2025-12-17 05:56:16.37	\N	t	f	f	\N	\N	\N	\N	0
7326773617966064640	Công ty TNHH Bosch Global Software (Factory)	KCN Long Thành, Đồng Nai	\N	\N	\N	7320276851855168512	2025-12-17 05:56:16.395	2025-12-17 05:56:16.395	\N	t	f	f	\N	\N	\N	\N	0
7326773618066727936	Công ty Cổ phần Sữa Quốc tế (IDP)	KCN Bàu Bàng, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:56:16.419	2025-12-17 05:56:16.419	\N	t	f	f	\N	\N	\N	\N	0
7326773618171585536	Công ty TNHH Cargill Việt Nam (Hà Nam)	KCN Đồng Văn II, Hà Nam	\N	\N	\N	7320276851855168512	2025-12-17 05:56:16.444	2025-12-17 05:56:16.444	\N	t	f	f	\N	\N	\N	\N	0
7326773618293220352	Công ty TNHH Schneider Electric Việt Nam	Khu CNC Quận 9, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 05:56:16.473	2025-12-17 05:56:16.473	\N	t	f	f	\N	\N	\N	\N	0
7326773618393883648	Công ty Cổ phần Diana Unicharm (Bắc Ninh)	KCN Tân Chi, Bắc Ninh	\N	\N	\N	7320276851855168512	2025-12-17 05:56:16.497	2025-12-17 05:56:16.497	\N	t	f	f	\N	\N	\N	\N	0
7326773618502935552	Công ty TNHH Sanofi (Nhà máy mới)	Khu CNC Thủ Đức, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 05:56:16.523	2025-12-17 05:56:16.523	\N	t	f	f	\N	\N	\N	\N	0
7326773618603598848	Nhà máy Bia Sài Gòn (Sabeco Củ Chi)	KCN Tây Bắc Củ Chi, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 05:56:16.546	2025-12-17 05:56:16.546	\N	t	f	f	\N	\N	\N	\N	0
7326773618695873536	Công ty TNHH LG Electronics Việt Nam	KCN Tràng Duệ, Hải Phòng	\N	\N	\N	7320276851855168512	2025-12-17 05:56:16.569	2025-12-17 05:56:16.569	\N	t	f	f	\N	\N	\N	\N	0
7326773618800731136	Công ty TNHH Youngone Nam Định	KCN Hòa Xá, Nam Định	\N	\N	\N	7320276851855168512	2025-12-17 05:56:16.594	2025-12-17 05:56:16.594	\N	t	f	f	\N	\N	\N	\N	0
7326773618901394432	Công ty TNHH Năng lượng Mặt trời Vina Solar	KCN Vân Trung, Bắc Giang	\N	\N	\N	7320276851855168512	2025-12-17 05:56:16.618	2025-12-17 05:56:16.618	\N	t	f	f	\N	\N	\N	\N	0
7326773823373714432	Trung tâm Logistics BW Thới Hòa	KCN Thới Hòa, Bến Cát, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:57:05.368	2025-12-17 05:57:05.368	\N	t	f	f	\N	\N	\N	\N	0
7326773823604401152	Nhà máy LEGO (Giai đoạn vận hành)	KCN VSIP III, Tân Uyên, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:57:05.423	2025-12-17 05:57:05.423	\N	t	f	f	\N	\N	\N	\N	0
7326773823730230272	Công ty TNHH Sharp Manufacturing Việt Nam	KCN VSIP II-A, Tân Uyên, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:57:05.452	2025-12-17 05:57:05.452	\N	t	f	f	\N	\N	\N	\N	0
7326773823839282176	Công ty TNHH Trina Solar Việt Nam	KCN Vân Trung, Bắc Giang	\N	\N	\N	7320276851855168512	2025-12-17 05:57:05.479	2025-12-17 05:57:05.479	\N	t	f	f	\N	\N	\N	\N	0
7326773823956722688	Nhà máy bia Heineken (Vũng Tàu)	KCN Mỹ Xuân A, Bà Rịa - Vũng Tàu	\N	\N	\N	7320276851855168512	2025-12-17 05:57:05.507	2025-12-17 05:57:05.507	\N	t	f	f	\N	\N	\N	\N	0
7326773824078357504	Công ty TNHH Mitsubishi Motors Việt Nam	An Bình, Dĩ An, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:57:05.536	2025-12-17 05:57:05.536	\N	t	f	f	\N	\N	\N	\N	0
7326773824204186624	Công ty TNHH Foxconn Đình Trám	KCN Đình Trám, Việt Yên, Bắc Giang	\N	\N	\N	7320276851855168512	2025-12-17 05:57:05.566	2025-12-17 05:57:05.566	\N	t	f	f	\N	\N	\N	\N	0
7326773824325821440	Công ty TNHH Nidec Việt Nam Corporation	Khu CNC Thủ Đức, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 05:57:05.595	2025-12-17 05:57:05.595	\N	t	f	f	\N	\N	\N	\N	0
7326773824451650560	Công ty Cổ phần May mặc Bình Dương	Hiệp Thành, Thủ Dầu Một, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:57:05.625	2025-12-17 05:57:05.625	\N	t	f	f	\N	\N	\N	\N	0
7326773824564896768	Công ty TNHH Texhong Hải Hà	KCN Hải Hà, Quảng Ninh	\N	\N	\N	7320276851855168512	2025-12-17 05:57:05.652	2025-12-17 05:57:05.652	\N	t	f	f	\N	\N	\N	\N	0
7326773824678142976	Công ty TNHH Yazaki EDS Việt Nam	Dĩ An, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:57:05.678	2025-12-17 05:57:05.678	\N	t	f	f	\N	\N	\N	\N	0
7326773824791389184	Nhà máy thức ăn chăn nuôi De Heus	KCN Sông Mây, Trảng Bom, Đồng Nai	\N	\N	\N	7320276851855168512	2025-12-17 05:57:05.707	2025-12-17 05:57:05.707	\N	t	f	f	\N	\N	\N	\N	0
7326773824913024000	Công ty TNHH AkzoNobel Việt Nam	KCN Amata, Biên Hòa, Đồng Nai	\N	\N	\N	7320276851855168512	2025-12-17 05:57:05.734	2025-12-17 05:57:05.734	\N	t	f	f	\N	\N	\N	\N	0
7326773825026270208	Công ty TNHH Procter & Gamble (P&G)	KCN Đồng An, Thuận An, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:57:05.761	2025-12-17 05:57:05.761	\N	t	f	f	\N	\N	\N	\N	0
7326773825177265152	Công ty TNHH Kimberly-Clark Việt Nam	KCN VSIP I, Thuận An, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:57:05.798	2025-12-17 05:57:05.798	\N	t	f	f	\N	\N	\N	\N	0
7326773825311482880	Công ty TNHH Sanwa Việt Nam	KCN Quế Võ, Bắc Ninh	\N	\N	\N	7320276851855168512	2025-12-17 05:57:05.829	2025-12-17 05:57:05.829	\N	t	f	f	\N	\N	\N	\N	0
7326773825428923392	Công ty TNHH Kính nổi Viglacera	KCN Yên Phong, Bắc Ninh	\N	\N	\N	7320276851855168512	2025-12-17 05:57:05.857	2025-12-17 05:57:05.857	\N	t	f	f	\N	\N	\N	\N	0
7326773825537975296	Công ty TNHH Avery Dennison RIS (Bắc Ninh)	KCN VSIP Bắc Ninh	\N	\N	\N	7320276851855168512	2025-12-17 05:57:05.883	2025-12-17 05:57:05.883	\N	t	f	f	\N	\N	\N	\N	0
7326773825642832896	Công ty TNHH Brother Việt Nam (Nhà máy mới)	KCN VSIP Hải Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:57:05.909	2025-12-17 05:57:05.909	\N	t	f	f	\N	\N	\N	\N	0
7326773825764467712	Công ty TNHH Sumitomo Wiring System	KCN Nomura, Hải Phòng	\N	\N	\N	7320276851855168512	2025-12-17 05:57:05.938	2025-12-17 05:57:05.938	\N	t	f	f	\N	\N	\N	\N	0
7326773955741754368	Công ty TNHH Foxconn (Nhà máy Nghệ An)	KCN WHA, Nghi Lộc, Nghệ An	\N	\N	\N	7320276851855168512	2025-12-17 05:57:36.926	2025-12-17 05:57:36.926	\N	t	f	f	\N	\N	\N	\N	0
7326773956018578432	Công ty TNHH Luxshare-ICT (Vân Trung)	KCN Vân Trung, Việt Yên, Bắc Giang	\N	\N	\N	7320276851855168512	2025-12-17 05:57:36.993	2025-12-17 05:57:36.993	\N	t	f	f	\N	\N	\N	\N	0
7326773956152796160	Công ty Cổ phần Đường Quảng Ngãi	Quảng Phú, TP. Quảng Ngãi	\N	\N	\N	7320276851855168512	2025-12-17 05:57:37.025	2025-12-17 05:57:37.025	\N	t	f	f	\N	\N	\N	\N	0
7326773956266042368	Nhà máy Bia Sài Gòn - Sông Hậu	KCN Sông Hậu, Châu Thành, Hậu Giang	\N	\N	\N	7320276851855168512	2025-12-17 05:57:37.051	2025-12-17 05:57:37.051	\N	t	f	f	\N	\N	\N	\N	0
7326773956391871488	Công ty TNHH Kingboard Việt Nam	KCN Mỹ Xuân A2, Bà Rịa - Vũng Tàu	\N	\N	\N	7320276851855168512	2025-12-17 05:57:37.081	2025-12-17 05:57:37.081	\N	t	f	f	\N	\N	\N	\N	0
7326773956496729088	Công ty TNHH Cheng Loong (Nhà máy Giấy Hà Nam)	KCN Đồng Văn III, Hà Nam	\N	\N	\N	7320276851855168512	2025-12-17 05:57:37.107	2025-12-17 05:57:37.107	\N	t	f	f	\N	\N	\N	\N	0
7326773956601586688	Công ty TNHH Hansoll Việt Nam	KCN Sóng Thần 1, Dĩ An, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:57:37.132	2025-12-17 05:57:37.132	\N	t	f	f	\N	\N	\N	\N	0
7326773956710638592	Công ty TNHH Nhựa Duy Tân (Long An)	KCN Tân Đô, Đức Hòa, Long An	\N	\N	\N	7320276851855168512	2025-12-17 05:57:37.158	2025-12-17 05:57:37.158	\N	t	f	f	\N	\N	\N	\N	0
7326773956815496192	Công ty TNHH Samsung Display Việt Nam	KCN Yên Phong, Bắc Ninh	\N	\N	\N	7320276851855168512	2025-12-17 05:57:37.183	2025-12-17 05:57:37.183	\N	t	f	f	\N	\N	\N	\N	0
7326773956924548096	Công ty Cổ phần Tôn Đông Á	KCN Đồng An 2, Thủ Dầu Một, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:57:37.209	2025-12-17 05:57:37.209	\N	t	f	f	\N	\N	\N	\N	0
7326773957046182912	Công ty TNHH Texhong Hải Hà (GĐ 2)	Quảng Hà, Hải Hà, Quảng Ninh	\N	\N	\N	7320276851855168512	2025-12-17 05:57:37.238	2025-12-17 05:57:37.238	\N	t	f	f	\N	\N	\N	\N	0
7326773957163623424	Công ty TNHH Giầy Fulgent Sun	KCN Giao Long, Bến Tre	\N	\N	\N	7320276851855168512	2025-12-17 05:57:37.266	2025-12-17 05:57:37.266	\N	t	f	f	\N	\N	\N	\N	0
7326773957281063936	Công ty TNHH Intel Products (Mở rộng)	Khu CNC Thủ Đức, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 05:57:37.294	2025-12-17 05:57:37.294	\N	t	f	f	\N	\N	\N	\N	0
7326773957406893056	Công ty TNHH Shinkong Polytex	KCN Bàu Bàng, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:57:37.323	2025-12-17 05:57:37.323	\N	t	f	f	\N	\N	\N	\N	0
7326773957536916480	Công ty TNHH Hayat Kimya (GĐ 2)	KCN Becamex Bình Phước	\N	\N	\N	7320276851855168512	2025-12-17 05:57:37.355	2025-12-17 05:57:37.355	\N	t	f	f	\N	\N	\N	\N	0
7326773957650162688	Công ty Cổ phần Thép Việt Ý	KCN Phố Nối A, Hưng Yên	\N	\N	\N	7320276851855168512	2025-12-17 05:57:37.382	2025-12-17 05:57:37.382	\N	t	f	f	\N	\N	\N	\N	0
7326773957784380416	Công ty TNHH Nissei Electric Hà Nội	KCN Thăng Long, Đông Anh, Hà Nội	\N	\N	\N	7320276851855168512	2025-12-17 05:57:37.414	2025-12-17 05:57:37.414	\N	t	f	f	\N	\N	\N	\N	0
7326773957901820928	Công ty TNHH Framas Việt Nam	KCN Mỹ Xuân A2, Bà Rịa - Vũng Tàu	\N	\N	\N	7320276851855168512	2025-12-17 05:57:37.442	2025-12-17 05:57:37.442	\N	t	f	f	\N	\N	\N	\N	0
7326773958019261440	Công ty TNHH LG Innotek Việt Nam	KCN Tràng Duệ, Hải Phòng	\N	\N	\N	7320276851855168512	2025-12-17 05:57:37.47	2025-12-17 05:57:37.47	\N	t	f	f	\N	\N	\N	\N	0
7326773958157673472	Công ty TNHH Mitsubishi Heavy Industries	KCN Thăng Long, Hà Nội	\N	\N	\N	7320276851855168512	2025-12-17 05:57:37.503	2025-12-17 05:57:37.503	\N	t	f	f	\N	\N	\N	\N	0
7326774261280023552	Nhà máy Thủy điện Sơn La	Ít Ong, Mường La, Sơn La	\N	\N	\N	7320276851855168512	2025-12-17 05:58:49.773	2025-12-17 05:58:49.773	\N	t	f	f	\N	\N	\N	\N	0
7326774261535876096	Công ty Cao su Điện Biên	Thanh Xương, Điện Biên	\N	\N	\N	7320276851855168512	2025-12-17 05:58:49.834	2025-12-17 05:58:49.834	\N	t	f	f	\N	\N	\N	\N	0
7326774261678482432	Nhà máy Chè Lai Châu	Tam Đường, Lai Châu	\N	\N	\N	7320276851855168512	2025-12-17 05:58:49.868	2025-12-17 05:58:49.868	\N	t	f	f	\N	\N	\N	\N	0
7326774261825283072	Công ty Gang thép Cao Bằng	Chu Trinh, TP. Cao Bằng	\N	\N	\N	7320276851855168512	2025-12-17 05:58:49.902	2025-12-17 05:58:49.902	\N	t	f	f	\N	\N	\N	\N	0
7326774261951112192	Nhà máy sản xuất Ferocrom Chiêm Hóa	Vĩnh Lộc, Chiêm Hóa, Tuyên Quang	\N	\N	\N	7320276851855168512	2025-12-17 05:58:49.932	2025-12-17 05:58:49.932	\N	t	f	f	\N	\N	\N	\N	0
7326774262076941312	Công ty CP Gỗ MDF VRG Dongwha	Chơn Thành, Bình Phước	\N	\N	\N	7320276851855168512	2025-12-17 05:58:49.963	2025-12-17 05:58:49.963	\N	t	f	f	\N	\N	\N	\N	0
7326774262198576128	Công ty Nhôm Đắk Nông - TKV	Nhân Cơ, Đắk R'lấp, Đắk Nông	\N	\N	\N	7320276851855168512	2025-12-17 05:58:49.992	2025-12-17 05:58:49.992	\N	t	f	f	\N	\N	\N	\N	0
7326774262328599552	Công ty Cao su Kon Tum	Quyết Thắng, TP. Kon Tum	\N	\N	\N	7320276851855168512	2025-12-17 05:58:50.023	2025-12-17 05:58:50.023	\N	t	f	f	\N	\N	\N	\N	0
7326774262462817280	Trang trại Điện mặt trời Trung Nam	Thuận Bắc, Ninh Thuận	\N	\N	\N	7320276851855168512	2025-12-17 05:58:50.055	2025-12-17 05:58:50.055	\N	t	f	f	\N	\N	\N	\N	0
7326774262643172352	Công ty Cổ phần Đường Kon Tum	Vinh Quang, TP. Kon Tum	\N	\N	\N	7320276851855168512	2025-12-17 05:58:50.098	2025-12-17 05:58:50.098	\N	t	f	f	\N	\N	\N	\N	0
7326774262781584384	Nhà máy Điện gió Bạc Liêu	Vĩnh Trạch Đông, Bạc Liêu	\N	\N	\N	7320276851855168512	2025-12-17 05:58:50.131	2025-12-17 05:58:50.131	\N	t	f	f	\N	\N	\N	\N	0
7326774262915802112	Công ty Thủy sản Minh Phú (Cà Mau)	Phường 8, TP. Cà Mau	\N	\N	\N	7320276851855168512	2025-12-17 05:58:50.162	2025-12-17 05:58:50.162	\N	t	f	f	\N	\N	\N	\N	0
7326774263029048320	Công ty Bia Sài Gòn - Kiên Giang	KCN Thạnh Lộc, Kiên Giang	\N	\N	\N	7320276851855168512	2025-12-17 05:58:50.19	2025-12-17 05:58:50.19	\N	t	f	f	\N	\N	\N	\N	0
7326774263150683136	Nhà máy Đạm Ninh Bình	KCN Khánh Phú, Ninh Bình	\N	\N	\N	7320276851855168512	2025-12-17 05:58:50.219	2025-12-17 05:58:50.219	\N	t	f	f	\N	\N	\N	\N	0
7326774263301678080	Công ty CP Chăn nuôi C.P (Chi nhánh Bình Định)	KCN Nhơn Hòa, Bình Định	\N	\N	\N	7320276851855168512	2025-12-17 05:58:50.255	2025-12-17 05:58:50.255	\N	t	f	f	\N	\N	\N	\N	0
7326774263431701504	Công ty TNHH MTV Đóng tàu Cam Ranh	Cam Lộc, Cam Ranh, Khánh Hòa	\N	\N	\N	7320276851855168512	2025-12-17 05:58:50.286	2025-12-17 05:58:50.286	\N	t	f	f	\N	\N	\N	\N	0
7326774263574307840	Nhà máy Xi măng Hà Tiên (Kiên Lương)	Kiên Lương, Kiên Giang	\N	\N	\N	7320276851855168512	2025-12-17 05:58:50.32	2025-12-17 05:58:50.32	\N	t	f	f	\N	\N	\N	\N	0
7326774263708525568	Công ty Thủy sản Hùng Vương (Vĩnh Long)	KCN Hòa Phú, Vĩnh Long	\N	\N	\N	7320276851855168512	2025-12-17 05:58:50.352	2025-12-17 05:58:50.352	\N	t	f	f	\N	\N	\N	\N	0
7326774263830160384	Công ty CP May Sông Hồng	Phường Mỹ Xá, TP. Nam Định	\N	\N	\N	7320276851855168512	2025-12-17 05:58:50.381	2025-12-17 05:58:50.381	\N	t	f	f	\N	\N	\N	\N	0
7326774263976961024	Công ty TNHH Giầy Aleron Việt Nam	KCN Hoàng Long, Thanh Hóa	\N	\N	\N	7320276851855168512	2025-12-17 05:58:50.416	2025-12-17 05:58:50.416	\N	t	f	f	\N	\N	\N	\N	0
7326771992446059520	Đầu tư Phát triển Gas đô thị (PV Gas City)	Tiền Hải, Thái Bình	\N	\N	\N	7320276851855168512	2025-12-17 05:49:48.841	2025-12-17 06:01:19.133	\N	f	t	f	\N	\N	\N	\N	0
7326772205495731200	Bánh kẹo Orion (Nhà máy Mỹ Phước)	KCN Mỹ Phước 2, Bến Cát, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:50:39.636	2025-12-17 06:01:19.469	\N	f	t	f	\N	\N	\N	\N	0
7326772430366652416	Bánh kẹo Orion (Nhà máy Mỹ Phước)	KCN Mỹ Phước 2, Bến Cát, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 05:51:33.249	2025-12-17 06:01:19.725	\N	f	t	f	\N	\N	\N	\N	0
7326775028627940352	Honda Việt Nam	Phúc Thắng, Phúc Yên, Vĩnh Phúc	\N	\N	\N	7320276851855168512	2025-12-17 06:01:52.723	2025-12-17 06:01:52.723	\N	t	f	f	\N	\N	\N	\N	0
7326775028867015680	Piaggio Việt Nam	KCN Bình Xuyên, Vĩnh Phúc	\N	\N	\N	7320276851855168512	2025-12-17 06:01:52.78	2025-12-17 06:01:52.78	\N	t	f	f	\N	\N	\N	\N	0
7326775028980261888	Dây cáp điện LS Vina	Sở Dầu, Hồng Bàng, Hải Phòng	\N	\N	\N	7320276851855168512	2025-12-17 06:01:52.807	2025-12-17 06:01:52.807	\N	t	f	f	\N	\N	\N	\N	0
7326775029106091008	Nhựa Tiền Phong (Hải Phòng)	Đặng Cương, An Dương, Hải Phòng	\N	\N	\N	7320276851855168512	2025-12-17 06:01:52.837	2025-12-17 06:01:52.837	\N	t	f	f	\N	\N	\N	\N	0
7326775029236114432	Dệt kim Đông Xuân	Ngô Thì Nhậm, Hai Bà Trưng, Hà Nội	\N	\N	\N	7320276851855168512	2025-12-17 06:01:52.868	2025-12-17 06:01:52.868	\N	t	f	f	\N	\N	\N	\N	0
7326775029403886592	Bánh kẹo Orion (Nhà máy Mỹ Phước)	KCN Mỹ Phước 2, Bến Cát, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 06:01:52.908	2025-12-17 06:01:52.908	\N	t	f	f	\N	\N	\N	\N	0
7326775029525521408	Nước giải khát Suntory PepsiCo	KCN VSIP 1, Thuận An, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 06:01:52.937	2025-12-17 06:01:52.937	\N	t	f	f	\N	\N	\N	\N	0
7326775029659739136	Ống nhựa Hoa Sen	KCN Nhơn Hòa, An Nhơn, Bình Định	\N	\N	\N	7320276851855168512	2025-12-17 06:01:52.968	2025-12-17 06:01:52.968	\N	t	f	f	\N	\N	\N	\N	0
7326775029802345472	Thủy sản Vĩnh Hoàn	KCN Thanh Bình, Cao Lãnh, Đồng Tháp	\N	\N	\N	7320276851855168512	2025-12-17 06:01:53.003	2025-12-17 06:01:53.003	\N	t	f	f	\N	\N	\N	\N	0
7326775029965923328	Cao su Miền Nam (CASUMINA)	KCN Tân Uyên, Bình Dương	\N	\N	\N	7320276851855168512	2025-12-17 06:01:53.042	2025-12-17 06:01:53.042	\N	t	f	f	\N	\N	\N	\N	0
7326775030192415744	Vang Đà Lạt (Ladofoods)	Phát Chi, Đà Lạt, Lâm Đồng	\N	\N	\N	7320276851855168512	2025-12-17 06:01:53.096	2025-12-17 06:01:53.096	\N	t	f	f	\N	\N	\N	\N	0
7326775030309856256	Bút bi Thiên Long	KCN Tân Tạo, Bình Tân, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 06:01:53.124	2025-12-17 06:01:53.124	\N	t	f	f	\N	\N	\N	\N	0
7326775030423102464	May thêu giày An Lạc	An Lạc, Bình Tân, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 06:01:53.151	2025-12-17 06:01:53.151	\N	t	f	f	\N	\N	\N	\N	0
7326775030536348672	Xi măng Hà Tiên	KCN Phú Hữu, Quận 9, TP.HCM	\N	\N	\N	7320276851855168512	2025-12-17 06:01:53.178	2025-12-17 06:01:53.178	\N	t	f	f	\N	\N	\N	\N	0
7326775030683149312	Gạch Taicera	KCN Gò Dầu, Long Thành, Đồng Nai	\N	\N	\N	7320276851855168512	2025-12-17 06:01:53.213	2025-12-17 06:01:53.213	\N	t	f	f	\N	\N	\N	\N	0
7326775030792201216	Dầu thực vật Tường An	KCN Vinhomes, Vinh, Nghệ An	\N	\N	\N	7320276851855168512	2025-12-17 06:01:53.239	2025-12-17 06:01:53.239	\N	t	f	f	\N	\N	\N	\N	0
7326775030909641728	Bóng đèn Phích nước Rạng Đông	Thanh Xuân, Hà Nội	\N	\N	\N	7320276851855168512	2025-12-17 06:01:53.267	2025-12-17 06:01:53.267	\N	t	f	f	\N	\N	\N	\N	0
7326775031027082240	Sợi dệt Phú Bài	KCN Phú Bài, Hương Thủy, Huế	\N	\N	\N	7320276851855168512	2025-12-17 06:01:53.295	2025-12-17 06:01:53.295	\N	t	f	f	\N	\N	\N	\N	0
7326775031144522752	Đầu tư Phát triển Gas đô thị (PV Gas City)	Tiền Hải, Thái Bình	\N	\N	\N	7320276851855168512	2025-12-17 06:01:53.323	2025-12-17 06:01:53.323	\N	t	f	f	\N	\N	\N	\N	0
7326775031257768960	May mặc Hanosimex	KCN Đồng Văn, Duy Tiên, Hà Nam	\N	\N	\N	7320276851855168512	2025-12-17 06:01:53.349	2025-12-17 06:01:53.349	\N	t	f	f	\N	\N	\N	\N	0
7331787098200003584	Quân	SNLH	113	contact@quan.vn	https://quan.vn	7320276851855168512	2025-12-31 01:58:03.229	2025-12-31 01:59:04.806	\N	t	f	f	\N	\N	\N	\N	0
7333044094471024640	hi	\N	\N	\N	\N	7331578479903157248	2026-01-03 13:12:54.494	2026-01-03 13:12:54.494	\N	t	f	f	\N	\N	\N	\N	0
7332973814984415232	tegdyigsydgy	\N	\N	\N	\N	7319893232403309568	2026-01-03 08:33:38.558	2026-01-04 15:20:38.138	\N	f	t	f	\N	\N	\N	\N	0
7333424421834750976	CTy TNHH Sếc Toy VN	\N	\N	\N	\N	7331157438012509184	2026-01-04 14:24:11.603	2026-01-06 01:50:58.273	buôn bán sẹc toy chất lượng cao	f	t	f	\N	\N	\N	\N	0
\.


--
-- Data for Name: CompanyDeliveries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."CompanyDeliveries" (id, weight, length, width, height, budget, created_by, company_id, created_at, modified_at, title) FROM stdin;
\.


--
-- Data for Name: CompanyRecruitments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."CompanyRecruitments" (id, title, description, requirements, location, employment_type, created_by, company_id, created_at, modified_at, salary_range_from, salary_range_to) FROM stdin;
\.


--
-- Data for Name: CompanyScrapes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."CompanyScrapes" (id, name, quantity, unit_type, unit_price, created_by, company_id) FROM stdin;
7326769449153316864	Sắt vụn hạng nặng	1000	kg	11500	7320276851855168512	7326769448943601664
7326769449308506112	Gốm sứ vỡ tái chế	200	kg	1500	7320276851855168512	7326769449233008640
7326769449451112448	Vỏ hộp giấy phức hợp	500	kg	3500	7320276851855168512	7326769449379809280
7326769449602107392	Mùn cưa/Dăm gỗ	2000	kg	1200	7320276851855168512	7326769449530804224
7326769449824405504	Nhựa PP dư thừa	300	kg	9500	7320276851855168512	7326769449673410560
7326769449958623232	Mủ cao su tạp	400	kg	18000	7320276851855168512	7326769449891514368
7326769450105423872	Sợi cotton dư	150	kg	5000	7320276851855168512	7326769450029926400
7326769450235447296	Bột giấy phế thải	800	kg	4200	7320276851855168512	7326769450164144128
7326769450365470720	Vỏ máy nhựa ABS	100	kg	12000	7320276851855168512	7326769450298361856
7326769450508077056	Màng nhựa OPP	250	kg	7000	7320276851855168512	7326769450436773888
7326769697976207360	Thùng nhựa đựng hóa chất	120	cái	85000	7320276851855168512	7326769697758103552
7326769698248837120	Vụn cao su tổng hợp	1500	kg	3200	7320276851855168512	7326769698081064960
7326769698454358016	Bao bì thức ăn chăn nuôi (PP)	3000	kg	4500	7320276851855168512	7326769698357889024
7326769698626324480	Mạt sắt tiện/phay	800	kg	9500	7320276851855168512	7326769698550827008
7326769699821701120	Sợi vải cotton phế	600	kg	5200	7320276851855168512	7326769699716843520
7326769700043999232	Bavia nhôm vụn	450	kg	38000	7320276851855168512	7326769699897198592
7326769700253714432	Lốp cao su lỗi/vụn	250	kg	6000	7320276851855168512	7326769700140468224
7326769700501178368	Nhựa kỹ thuật ABS vụn	180	kg	13500	7320276851855168512	7326769700396320768
7326769700740253696	Sáp nến dư thừa	400	kg	15000	7320276851855168512	7326769700601841664
7326769700928997376	Dây đồng quấn motor vụn	45	kg	175000	7320276851855168512	7326769700824139776
7326769914494568448	Khay nhựa định hình định vị linh kiện	1500	kg	15000	7320276851855168512	7326769914280658944
7326769914645563392	Băng tải cao su cũ/hỏng	450	kg	5000	7320276851855168512	7326769914565871616
7326769914846889984	Xỉ thép (tái chế làm vật liệu xây dựng)	5000	kg	800	7320276851855168512	7326769914783975424
7326769915031439360	Vải vụn dệt kim	2000	kg	3500	7320276851855168512	7326769914964330496
7326769915186628608	Vỏ hộp mực in nhựa tái chế	300	kg	25000	7320276851855168512	7326769915090159616
7326769915308263424	Phế liệu tôn tấm/sắt vụn xe	1200	kg	11000	7320276851855168512	7326769915241154560
7326769915471841280	Két nhựa bia hỏng/vỡ	600	kg	9000	7320276851855168512	7326769915366983680
7326769915643807744	Decal và giấy lót thừa	800	kg	2000	7320276851855168512	7326769915576698880
7326769915765442560	Dây cáp mạng/điện cũ	120	kg	45000	7320276851855168512	7326769915706722304
7326769915991934976	Mảnh sành/Gạch men lỗi	3000	kg	500	7320276851855168512	7326769915929020416
7326770226659837952	Cao su lưu hóa phế phẩm	1200	kg	4500	7320276851855168512	7326770226483677184
7326770226806638592	Bao bì nhựa PE mềm	850	kg	7200	7320276851855168512	7326770226722752512
7326770226949244928	Lõi ống giấy cuộn sợi	2000	kg	3800	7320276851855168512	7326770226877941760
7326770227146377216	Thùng carton 5 lớp	600	kg	4200	7320276851855168512	7326770227037325312
7326770227406424064	Tanh thép từ lốp xe cũ	350	kg	8500	7320276851855168512	7326770227251234816
7326770227658082304	Sứ vệ sinh lỗi (nghiền tái chế)	2500	kg	600	7320276851855168512	7326770227582584832
7326770227796494336	Đầu mẩu ống nhựa uPVC	550	kg	11000	7320276851855168512	7326770227725191168
7326770227909740544	Thùng xốp EPS giữ lạnh	150	kg	18000	7320276851855168512	7326770227851020288
7326770228064929792	Vải vụn hỗn hợp	3000	kg	2800	7320276851855168512	7326770227972655104
7326770228215924736	Vỏ máy nhôm/hợp kim vụn	220	kg	32000	7320276851855168512	7326770228140427264
7326770500925376512	Vải vụn thun cotton	2500	kg	3800	7320276851855168512	7326770500761798656
7326770501051205632	Thép tấm đóng tàu vụn	1500	kg	12500	7320276851855168512	7326770500984096768
7326770501189617664	Len/Sợi lông cừu phế phẩm	400	kg	15000	7320276851855168512	7326770501114120192
7326770501319641088	Mủ chén/Mủ dây khô	900	kg	21000	7320276851855168512	7326770501252532224
7326770501466441728	Thùng nhựa đựng cá (HDPE)	200	kg	14000	7320276851855168512	7326770501374167040
7326770501604853760	Phế liệu mút xốp EVA	1100	kg	5500	7320276851855168512	7326770501533550592
7326770501806180352	Bao đựng đường cũ (PP/PE)	1800	kg	4800	7320276851855168512	7326770501701322752
7326770501973952512	Giấy sơ đồ may mặc	700	kg	3200	7320276851855168512	7326770501864900608
7326770502175279104	Đầu cốt đồng/Dây điện vụn	60	kg	165000	7320276851855168512	7326770502120753152
7326770502296913920	Lõi nhựa cuộn màng quấn	300	kg	9000	7320276851855168512	7326770502242387968
7326770599873202176	Sắt vụn và vảy cán thép	10000	kg	10500	7320276851855168512	7326770599663486976
7326770599994836992	Dây cáp sạc và đầu nối lỗi	300	kg	35000	7320276851855168512	7326770599931922432
7326770600112277504	Thùng nhựa đựng trái cây cũ	450	kg	12000	7320276851855168512	7326770600053557248
7326770600229718016	Vỏ lon nhôm phế	1200	kg	36000	7320276851855168512	7326770600162609152
7326770600342964224	Mủ tạp và cao su khối dư	800	kg	19500	7320276851855168512	7326770600275855360
7326523878600287232		1	1	1	7319893232403309568	7320053085020058624
7326768811933681664		12	kg	23	7320276851855168512	7326767217242523648
7326770600452016128	Dầu nhớt công nghiệp thải	500	lít	8000	7320276851855168512	7326770600389101568
7326770600569456640	Màng nhựa bảo vệ linh kiện	600	kg	9500	7320276851855168512	7326770600514930688
7326770600821114880	Mảnh composite cánh quạt hỏng	2000	kg	1500	7320276851855168512	7326770600712062976
7326770601001469952	Vỏ bao xi măng rách (PP)	5000	kg	4200	7320276851855168512	7326770600905000960
7326770601177630720	Khay nhựa đông lạnh (PP)	300	kg	11000	7320276851855168512	7326770601072773120
7326770760854784000	Linh kiện điện thoại lỗi (Lumia/A-Series)	200	kg	280000	7320276851855168512	7326770760649263104
7326770761051916288	Mũi khoan hợp kim cũ (Tungsten)	50	kg	350000	7320276851855168512	7326770760959641600
7326770761425209344	Vỏ bao phân bón (PP dệt)	4000	kg	4300	7320276851855168512	7326770761244854272
7326770761664284672	Lốp xe ben hạng nặng phế thải	15	cái	3500000	7320276851855168512	7326770761542649856
7326770762742220800	Tro bay/Xỉ than (tái chế gạch không nung)	15000	kg	450	7320276851855168512	7326770762675111936
7326770762918381568	Băng chuyền tải cũ rách	300	kg	5500	7320276851855168512	7326770762821912576
7326770763077765120	Vải vụn ren và nội y	1200	kg	4000	7320276851855168512	7326770762993879040
7326770763321034752	Ống đồng bình ngưng cũ	80	kg	178000	7320276851855168512	7326770763211982848
7326770763585275904	Vỏ chai thủy tinh dược phẩm	5000	cái	1500	7320276851855168512	7326770763430086656
7326770763803379712	Cuộn lõi giấy carton cứng	900	kg	3200	7320276851855168512	7326770763685939200
7326771439258042368	Thùng phuy sắt cũ	500	cái	150000	7320276851855168512	7326771439014772736
7326771439459368960	Bã bột giấy phế thải	3000	kg	1200	7320276851855168512	7326771439379677184
7326771439694249984	Màng co nhựa nilon	800	kg	8500	7320276851855168512	7326771439572615168
7326771439845244928	Vỏ nhựa PVC dây điện	450	kg	13000	7320276851855168512	7326771439765553152
7326771440021405696	Vải đầu cây/Vải khúc	1200	kg	18000	7320276851855168512	7326771439950102528
7326771440168206336	Bao bì nhôm phức hợp	350	kg	4000	7320276851855168512	7326771440092708864
7326771440306618368	Đầu mẩu ống thép đen	2500	kg	11000	7320276851855168512	7326771440231120896
7326771440461807616	Sợi Polyester phế	600	kg	6500	7320276851855168512	7326771440373727232
7326771440587636736	Cáp thép cũ rỉ sét	400	kg	9000	7320276851855168512	7326771440516333568
7326771440742825984	Pallet gỗ cũ	150	cái	45000	7320276851855168512	7326771440642162688
7326771440868655104	Thùng nhựa lọt lòng	300	kg	12500	7320276851855168512	7326771440801546240
7326771440981901312	Cúc áo và khóa kéo lỗi	100	kg	5000	7320276851855168512	7326771440923181056
7326771441090953216	Vỉ nhôm thuốc phế liệu	250	kg	22000	7320276851855168512	7326771441032232960
7326771441204199424	Nhôm thanh phế liệu	500	kg	42000	7320276851855168512	7326771441141284864
7326771441321639936	Mảnh gạch men vỡ	5000	kg	400	7320276851855168512	7326771441262919680
7326771441434886144	Vỏ nhựa bình ắc quy cũ	200	kg	16000	7320276851855168512	7326771441376165888
7326771441552326656	Nắp chai kim loại	400	kg	7500	7320276851855168512	7326771441489412096
7326771441665572864	Bao bì đựng đạm cũ	2000	kg	4500	7320276851855168512	7326771441606852608
7326771441787207680	Vải bạt và cao su vụn	600	kg	3500	7320276851855168512	7326771441724293120
7326771441887870976	Lõi sắt cuộn tôn	200	kg	10500	7320276851855168512	7326771441833345024
7326772868934673408	Vỏ động cơ nhôm đúc lỗi	150	kg	48000	7320276851855168512	7326772868724958208
7326772869098251264	Linh kiện nhựa ABS xe máy	300	kg	13000	7320276851855168512	7326772869014365184
7326772869236663296	Lõi đồng đỏ phế liệu	200	kg	195000	7320276851855168512	7326772869165360128
7326772869370881024	Nhựa HDPE phế	800	kg	15500	7320276851855168512	7326772869307966464
7326772869517681664	Vải sợi tự nhiên vụn	1000	kg	6000	7320276851855168512	7326772869442184192
7326772869647705088	Cuộn màng nhựa in lỗi	400	kg	7000	7320276851855168512	7326772869576401920
7326772869790311424	Vỏ chai nhựa PET	1500	kg	9500	7320276851855168512	7326772869719008256
7326772869920334848	Đầu mẩu nhựa PPR	250	kg	18000	7320276851855168512	7326772869853225984
7326772870046163968	Thùng nhựa đựng thực phẩm cũ	120	kg	15000	7320276851855168512	7326772869983249408
7326772870176187392	Bột cao su mài mòn	2000	kg	2500	7320276851855168512	7326772870104884224
7326772870302016512	Vỏ chai thủy tinh xanh	3000	kg	1200	7320276851855168512	7326772870239101952
7326772870436234240	Nhựa màu phế liệu	500	kg	11000	7320276851855168512	7326772870369125376
7326772870557869056	Da bò vụn công nghiệp	400	kg	14000	7320276851855168512	7326772870494954496
7326772870675309568	Sắt thép bảo trì nhà máy	1200	kg	10500	7320276851855168512	7326772870612395008
7326772870880830464	Gạch men lỗi loại 2	4000	kg	600	7320276851855168512	7326772870801138688
7326772871010853888	Can nhựa đựng dầu 20L	100	cái	25000	7320276851855168512	7326772870939550720
7326772871140877312	Vỏ nhựa bóng đèn LED	500	kg	14500	7320276851855168512	7326772871073768448
7326772871270900736	Bụi bông đóng kiện	3000	kg	1500	7320276851855168512	7326772871199597568
7326772871413507072	Van gas đồng cũ	50	kg	145000	7320276851855168512	7326772871346398208
7326772871530947584	Vải vụn dệt thoi	2000	kg	3200	7320276851855168512	7326772871468033024
7326773213106676736	Nhựa ABS phế phẩm màu	100	kg	25000	7320276851855168512	7326773212938904576
7326773213232505856	Kính cường lực quang điện vỡ	1200	kg	3500	7320276851855168512	7326773213169591296
7326773213358334976	Phôi nhựa PET lỗi	600	kg	11000	7320276851855168512	7326773213287031808
7326773213471581184	Bao đựng lúa giống cũ	5000	kg	4500	7320276851855168512	7326773213412860928
7326773213597410304	Bao bì phức hợp (giấy/nhôm/nhựa)	2000	kg	2800	7320276851855168512	7326773213530301440
7326773213710656512	Nhựa PVC tái chế	1500	kg	14500	7320276851855168512	7326773213651936256
7326773213857457152	Vỏ nhựa cách điện PE	400	kg	12000	7320276851855168512	7326773213794542592
7326773213958120448	Mút cao su vụn	900	kg	6500	7320276851855168512	7326773213903594496
7326773214083949568	Lõi giấy cuộn lớn	1200	kg	3500	7320276851855168512	7326773214025229312
7326773214197195776	Vỉ thuốc nhôm/nhựa rỗng	150	kg	24000	7320276851855168512	7326773214134281216
7326773214327219200	Sợi thô lỗi màu	1000	kg	7500	7320276851855168512	7326773214260110336
7326773214461436928	Can nhựa đựng gia vị	400	kg	13500	7320276851855168512	7326773214394328064
7326773214583071744	Phôi thép mạ kẽm vụn	2000	kg	11500	7320276851855168512	7326773214524351488
7326773214700512256	Vải jean vụn	3000	kg	4200	7320276851855168512	7326773214641792000
7326773214813758464	Ruột xe cao su hỏng	500	kg	8500	7320276851855168512	7326773214750843904
7326773214922810368	Vỏ hộp thiếc bánh kẹo	250	kg	7500	7320276851855168512	7326773214868284416
7326773215048639488	Sắt thép bảo trì thiết bị	1500	kg	10200	7320276851855168512	7326773214981530624
7326773215170274304	Thùng nhựa lọt lòng HDPE	350	kg	14500	7320276851855168512	7326773215111554048
7326773215308686336	Màng nhựa nilon PE sạch	700	kg	9000	7320276851855168512	7326773215228994560
7326773215417738240	Nhôm dẻo vụn	400	kg	41000	7320276851855168512	7326773215363212288
7326773402148152320	Cell pin Lithium lỗi	50	kg	150000	7320276851855168512	7326773402013934592
7326773402269787136	Khay nhựa dẫn điện (ESD)	300	kg	18000	7320276851855168512	7326773402206872576
7326773402383033344	Khung dẫn (Leadframe) đồng mạ	120	kg	210000	7320276851855168512	7326773402328507392
7326773402492085248	Vỏ lon nhôm lỗi in	2000	kg	38000	7320276851855168512	7326773402437559296
7326773402609525760	Màng nhựa BOPP phức hợp	500	kg	6500	7320276851855168512	7326773402554999808
7326773402735354880	Vụn nhựa PP màu	800	kg	12500	7320276851855168512	7326773402672440320
7326773402836018176	Thùng carton 3 lớp sạch	1500	kg	4600	7320276851855168512	7326773402785686528
7326773402945070080	Cuộn lõi giấy ép cứng	2500	kg	3200	7320276851855168512	7326773402882155520
7326773403049927680	Cao su chưa lưu hóa	600	kg	11000	7320276851855168512	7326773402995401728
7326773403171562496	Xỉ lò điện (EAF dust)	8000	kg	700	7320276851855168512	7326773403104453632
7326773403301585920	Nắp chai nhôm/thiếc	500	kg	8500	7320276851855168512	7326773403234477056
7326773403414832128	Vụn nhựa tái chế rPET	3000	kg	14000	7320276851855168512	7326773403356111872
7326773403549049856	Vải vụn nhuộm phế	5000	kg	3500	7320276851855168512	7326773403477746688
7326773403691656192	Giấy sơ đồ đục lỗ	1200	kg	4200	7320276851855168512	7326773403628741632
7326773403830068224	Chai thủy tinh tương ớt cũ	4000	cái	1100	7320276851855168512	7326773403775542272
7326773403968480256	Bảng mạch PCB phế	200	kg	85000	7320276851855168512	7326773403892982784
7326773404094309376	Thép ống mẩu thừa	1500	kg	11200	7320276851855168512	7326773404039783424
7326773404215944192	Vải vụn lót nội y	2000	kg	4800	7320276851855168512	7326773404144641024
7326773404324996096	Chun và dây đai dệt phế	300	kg	9000	7320276851855168512	7326773404266275840
7326773404564071424	Nhôm anod phế liệu	400	kg	45000	7320276851855168512	7326773404400493568
7326773616837796864	Nhôm hợp kim hàng không (7075)	150	kg	55000	7320276851855168512	7326773616686801920
7326773616963625984	Dây thép tanh lốp phế	500	kg	9000	7320276851855168512	7326773616904905728
7326773617076872192	Vỏ máy tính bảng nhựa cao cấp	300	kg	18500	7320276851855168512	7326773617009763328
7326773617181729792	Bo mạch máy tính lỗi	100	kg	120000	7320276851855168512	7326773617127203840
7326773617294976000	Dây cáp dữ liệu phế	250	kg	32000	7320276851855168512	7326773617244644352
7326773617416610816	Mạt thép chịu nhiệt cao cấp	80	kg	65000	7320276851855168512	7326773617362084864
7326773617534051328	Bao bì màng nhôm thực phẩm	1200	kg	5500	7320276851855168512	7326773617483719680
7326773617655686144	Pallet nhựa HDPE cũ	200	cái	110000	7320276851855168512	7326773617605354496
7326773617781515264	Khuôn nhôm đúc cũ	60	kg	38000	7320276851855168512	7326773617718600704
7326773617919927296	Vải vụn sơ mi cotton	2000	kg	4500	7320276851855168512	7326773617861207040
7326773618016396288	Thiết bị điện tử kiểm thử hỏng	45	kg	150000	7320276851855168512	7326773617966064640
7326773618117059584	Vỏ hộp giấy tiệt trùng	1000	kg	3800	7320276851855168512	7326773618066727936
7326773618230305792	Bao jumbo cũ (1 tấn)	300	cái	65000	7320276851855168512	7326773618171585536
7326773618347746304	Vỏ nhựa cầu dao điện (PC)	150	kg	14000	7320276851855168512	7326773618293220352
7326773618448409600	Giấy lót bông phế liệu	3000	kg	1500	7320276851855168512	7326773618393883648
7326773618553267200	Vỉ nhôm thuốc ép sẵn	120	kg	26000	7320276851855168512	7326773618502935552
7326773618645541888	Két bia nhựa vỡ	400	kg	8500	7320276851855168512	7326773618603598848
7326773618742010880	Tấm thép vỏ tủ lạnh lỗi	600	kg	11000	7320276851855168512	7326773618695873536
7326773618846868480	Vải vụn áo khoác gió	1500	kg	3200	7320276851855168512	7326773618800731136
7326773618951726080	Khung nhôm pin mặt trời cũ	400	kg	43000	7320276851855168512	7326773618901394432
7326773823528903680	Màng quấn Pallet (Stretch film)	2000	kg	12500	7320276851855168512	7326773823373714432
7326773823671510016	Nhựa ABS phế (Red/Blue/Yellow)	200	kg	28000	7320276851855168512	7326773823604401152
7326773823784756224	Vỏ máy lọc không khí (Nhựa trắng)	500	kg	15500	7320276851855168512	7326773823730230272
7326773823902196736	Kính quang điện vỡ (Solar glass)	3000	kg	4200	7320276851855168512	7326773823839282176
7326773824015442944	Bã hèm bia sấy khô	10000	kg	2500	7320276851855168512	7326773823956722688
7326773824141272064	Linh kiện nhựa cản xe lỗi	150	kg	14000	7320276851855168512	7326773824078357504
7326773824262906880	Dây cáp tín hiệu bọc nhựa	600	kg	34000	7320276851855168512	7326773824204186624
7326773824384541696	Bạc đạn thép phế	300	kg	12000	7320276851855168512	7326773824325821440
7326773824510370816	Vải vụn Denim	4000	kg	5500	7320276851855168512	7326773824451650560
7326773824623617024	Ống nhựa cuộn chỉ cũ	5000	kg	4500	7320276851855168512	7326773824564896768
7326773824732668928	Đầu cốt đồng mạ thiếc	100	kg	185000	7320276851855168512	7326773824678142976
7326773824854303744	Bao bì nhựa PP 25kg	3000	kg	4800	7320276851855168512	7326773824791389184
7326773824971744256	Thùng thiếc sơn hỏng	400	kg	8500	7320276851855168512	7326773824913024000
7326773825084990464	Vỏ chai dầu gội nhựa HDPE	1200	kg	13500	7320276851855168512	7326773825026270208
7326773825248568320	Vụn tã giấy phế thải	2000	kg	1800	7320276851855168512	7326773825177265152
7326773825370203136	Khuôn thép chính xác cũ	50	kg	15500	7320276851855168512	7326773825311482880
7326773825483449344	Kính vụn xây dựng	6000	kg	1400	7320276851855168512	7326773825428923392
7326773825592501248	Nhãn mác vải/giấy thừa	800	kg	2500	7320276851855168512	7326773825537975296
7326773825701553152	Vỏ máy in nhựa trắng	400	kg	16000	7320276851855168512	7326773825642832896
7326773825839965184	Dây điện xe hơi phế	700	kg	45000	7320276851855168512	7326773825764467712
7326773955905332224	Vỏ nhôm máy tính xách tay lỗi	200	kg	45000	7320276851855168512	7326773955741754368
7326773956085687296	Tai nghe nhựa/linh kiện lỗi	150	kg	32000	7320276851855168512	7326773956018578432
7326773956211516416	Bã mía ép khô (làm chất đốt)	5000	kg	1800	7320276851855168512	7326773956152796160
7326773956324762624	Nắp chai thiếc phế liệu	400	kg	8000	7320276851855168512	7326773956266042368
7326773956446397440	Tấm đồng mỏng phế liệu	80	kg	195000	7320276851855168512	7326773956391871488
7326773956547060736	Giấy cuộn carton loại 2	1500	kg	3800	7320276851855168512	7326773956496729088
7326773956656112640	Vải vụn Polyester nhuộm	3000	kg	4200	7320276851855168512	7326773956601586688
7326773956760970240	Bavia nhựa PP/PE	800	kg	12500	7320276851855168512	7326773956710638592
7326773956870022144	Khung thép màn hình OLED lỗi	100	kg	25000	7320276851855168512	7326773956815496192
7326773956983268352	Mạt sắt cán nguội	1200	kg	10500	7320276851855168512	7326773956924548096
7326773957100708864	Sợi cotton chải kỹ phế	2000	kg	5500	7320276851855168512	7326773957046182912
7326773957222343680	Vụn cao su đế giày	600	kg	4500	7320276851855168512	7326773957163623424
7326773957335589888	Dây đồng tráng men phế	45	kg	175000	7320276851855168512	7326773957281063936
7326773957461419008	Xơ sợi nhân tạo phế	1000	kg	6800	7320276851855168512	7326773957406893056
7326773957591442432	Màng nhựa bao bì tã giấy	500	kg	8500	7320276851855168512	7326773957536916480
7326773957717271552	Vẩy sắt cán nóng	4000	kg	9500	7320276851855168512	7326773957650162688
7326773957843100672	Vỏ nhựa silicon dây điện	300	kg	18000	7320276851855168512	7326773957784380416
7326773957960541184	Khuôn nhựa kỹ thuật cũ	120	kg	14000	7320276851855168512	7326773957901820928
7326773958077981696	Linh kiện camera lỗi	50	kg	120000	7320276851855168512	7326773958019261440
7326773958216393728	Phế liệu hợp kim Niken	30	kg	450000	7320276851855168512	7326773958157673472
7326774261464572928	Cáp đồng cao thế cũ	150	kg	185000	7320276851855168512	7326774261280023552
7326774261611373568	Mủ chén đông khô	1200	kg	22000	7320276851855168512	7326774261535876096
7326774261749785600	Bao bì lót thiếc đựng chè	500	kg	7500	7320276851855168512	7326774261678482432
7326774261892391936	Sắt vụn lò cao	5000	kg	10200	7320276851855168512	7326774261825283072
7326774262014026752	Xỉ quặng Crom phế	2000	kg	1200	7320276851855168512	7326774261951112192
7326774262139855872	Vụn gỗ ép/Mạt cưa	10000	kg	800	7320276851855168512	7326774262076941312
7326774262265684992	Nhôm thỏi phế phẩm	300	kg	43000	7320276851855168512	7326774262198576128
7326774262387319808	Thùng phuy nhựa đựng hóa chất	100	cái	150000	7320276851855168512	7326774262328599552
7326774262521537536	Module pin mặt trời nứt vỡ	2500	kg	3800	7320276851855168512	7326774262462817280
7326774262710281216	Bao PP dệt đựng đường cũ	2000	kg	4600	7320276851855168512	7326774262643172352
7326774262844498944	Cáp điện lõi nhôm phế	400	kg	28000	7320276851855168512	7326774262781584384
7326774262974522368	Thùng xốp EPS phế liệu	300	kg	16000	7320276851855168512	7326774262915802112
7326774263087768576	Két nhựa vỡ loại 2	500	kg	9000	7320276851855168512	7326774263029048320
7326774263209403392	Sắt thép bảo trì hệ thống	3000	kg	10500	7320276851855168512	7326774263150683136
7326774263372981248	Bao bì thức ăn gia súc (PP)	4500	kg	4200	7320276851855168512	7326774263301678080
7326774263511393280	Sắt vụn tàu biển	8000	kg	11500	7320276851855168512	7326774263431701504
7326774263637222400	Dây băng tải cao su cũ	600	kg	5200	7320276851855168512	7326774263574307840
7326774263771440128	Khay nhựa đông lạnh xanh	200	kg	14000	7320276851855168512	7326774263708525568
7326774263897269248	Vải vụn chăn ga gối	2500	kg	3800	7320276851855168512	7326774263830160384
7326774264035681280	Vụn da nhân tạo PU	1500	kg	5500	7320276851855168512	7326774263976961024
7326775028799906816	Vỏ động cơ nhôm đúc lỗi	150	kg	48000	7320276851855168512	7326775028627940352
7326775028925735936	Linh kiện nhựa ABS xe máy	300	kg	13000	7320276851855168512	7326775028867015680
7326775029043176448	Lõi đồng đỏ phế liệu	200	kg	195000	7320276851855168512	7326775028980261888
7326775029173199872	Nhựa HDPE phế	800	kg	15500	7320276851855168512	7326775029106091008
7326775029340972032	Vải sợi tự nhiên vụn	1000	kg	6000	7320276851855168512	7326775029236114432
7326775029466801152	Cuộn màng nhựa in lỗi	400	kg	7000	7320276851855168512	7326775029403886592
7326775029592630272	Vỏ chai nhựa PET	1500	kg	9500	7320276851855168512	7326775029525521408
7326775029726848000	Đầu mẩu nhựa PPR	250	kg	18000	7320276851855168512	7326775029659739136
7326775029882037248	Thùng nhựa đựng thực phẩm cũ	120	kg	15000	7320276851855168512	7326775029802345472
7326775030033032192	Bột cao su mài mòn	2000	kg	2500	7320276851855168512	7326775029965923328
7326775030251136000	Vỏ chai thủy tinh xanh	3000	kg	1200	7320276851855168512	7326775030192415744
7326775030368576512	Nhựa màu phế liệu	500	kg	11000	7320276851855168512	7326775030309856256
7326775030477628416	Da bò vụn công nghiệp	400	kg	14000	7320276851855168512	7326775030423102464
7326775030624429056	Sắt thép bảo trì nhà máy	1200	kg	10500	7320276851855168512	7326775030536348672
7326775030741869568	Gạch men lỗi loại 2	4000	kg	600	7320276851855168512	7326775030683149312
7326775030850921472	Can nhựa đựng dầu 20L	100	cái	25000	7320276851855168512	7326775030792201216
7326775030976750592	Vỏ nhựa bóng đèn LED	500	kg	14500	7320276851855168512	7326775030909641728
7326775031094191104	Bụi bông đóng kiện	3000	kg	1500	7320276851855168512	7326775031027082240
7326775031203243008	Van gas đồng cũ	50	kg	145000	7320276851855168512	7326775031144522752
7326775031320683520	Vải vụn dệt thoi	2000	kg	3200	7320276851855168512	7326775031257768960
7331787514325292032	Sắt hộp chữ V	1	tấn	1000000	7320276851855168512	7331787098200003584
\.


--
-- Data for Name: Files; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Files" (id, name, user_id, product_id, created_at, modified_at, "order") FROM stdin;
5a87e880-2122-45d0-b99a-4070e8501b3b	unnamed.jpg	7319893232403309568	\N	2026-01-04 14:53:22.418	2026-01-04 14:53:22.418	0
37918506-56fe-40bc-b963-484eea52ebcb	876414-bot.png	7319893232403309568	\N	2026-01-04 14:55:29.531	2026-01-04 14:55:29.531	0
6f2e0936-e60e-490c-96b8-529dc479091f	876414-bot.png	7319893232403309568	\N	2026-01-04 14:55:46.111	2026-01-04 14:55:46.111	0
5b55a69f-78f1-4441-b174-64b685450268	876414-bot.png	7319893232403309568	\N	2026-01-04 14:55:55.23	2026-01-04 14:55:55.23	0
b460827d-6126-433b-8451-73979994a5d2	unnamed.jpg	7319893232403309568	\N	2026-01-04 15:14:59.106	2026-01-04 15:14:59.106	0
09771cbe-4c14-412a-89dc-a470f2398b8c	876414-bot.png	7319893232403309568	\N	2026-01-04 15:15:45.063	2026-01-04 15:15:45.063	0
9273b1b7-f2be-400d-a233-b29548495104	01.png	7320276851855168512	\N	2026-01-05 02:37:12.06	2026-01-05 02:37:12.06	0
83f3da04-f5a0-4a00-9de2-e5d0dd7c0c14	lam-giau-tu-vai-vun.jpg	7320276851855168512	7333956887425341440	2026-01-06 01:52:16.465	2026-01-06 01:52:16.472	0
43cb1f51-58f5-4307-b3c8-8d7cc06c3c9a	Se1a0b2295f2b4e73b46d5c95151837d3L.jpg_720x720q80.jpg	7320276851855168512	7333957121375229952	2026-01-06 01:53:22.311	2026-01-06 01:53:22.318	0
5ea61a09-7fe3-468e-b465-a528193a72e4	2021-11-20_101007.jpg	7320276851855168512	7333958349744265216	2026-01-06 01:53:46.843	2026-01-06 01:53:46.851	0
afda4003-f6ec-4be9-b96a-2fda68c12044	boc-nolon-deo.webp	7320276851855168512	7333958565851584512	2026-01-06 01:54:20.525	2026-01-06 01:54:20.532	0
d91d45ad-0773-4614-887e-4bea93a69ce2	gia-thiec-phe-lieu-01.jpg	7320276851855168512	7333958903182678016	2026-01-06 01:54:59.071	2026-01-06 01:54:59.079	0
36dd1ef7-d63e-4aad-af21-c385258eb841	bang-gia-giay-phe-lieu-1.jpg	7320276851855168512	7333959108644853760	2026-01-06 01:55:23.089	2026-01-06 01:55:23.097	0
e3f03739-481e-497a-8366-3b0f26519c91	1649147171_z3317512433232_bb28c593561a0eb9770861879609f7c3.jpg	7320276851855168512	7333959593409599488	2026-01-06 01:55:59.869	2026-01-06 01:55:59.875	0
2e27862f-4153-4b1e-b7c8-e1e92e5ba745	bao-gia-dong-phe-lieu.jpg	7320276851855168512	7333957418759772160	2026-01-06 01:56:33.952	2026-01-06 01:56:33.958	0
5a48a603-7e27-4173-813c-bce95be1a43d	phe-lieu-nhua-co-may-loai.jpg	7320276851855168512	7333957896662964224	2026-01-06 01:57:19.672	2026-01-06 01:57:19.679	0
7e4cf991-069d-40cb-b0bb-79bb6a52965d	thu-mua-phe-lieu-linh-kien-dien-tu.jpeg	7320276851855168512	7333958117690202112	2026-01-06 01:57:45.085	2026-01-06 01:57:45.091	0
e3a863ce-4807-48a0-ab44-af6e76beae76	191911-verified.png	7319893232403309568	\N	2026-01-04 07:25:24.653	2026-01-04 07:25:24.653	0
dce8c519-5437-4287-825e-8fb088050bf2	579518-ban.png	7319893232403309568	\N	2026-01-04 07:25:52.963	2026-01-04 07:25:52.963	0
af7cdf3f-2eee-4a02-b299-37b485406e6e	191911-verified.png	7319893232403309568	\N	2026-01-04 07:26:25.71	2026-01-04 07:26:25.71	0
50b3024b-a160-4bde-a2d3-574eb9542c21	unnamed.jpg	7319893232403309568	\N	2026-01-04 14:53:05.689	2026-01-04 14:53:05.689	0
\.


--
-- Data for Name: Message_reactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Message_reactions" (id, icon, message_id, seen_by_id, seen_at) FROM stdin;
7331245048595083264	❤️	7331244537513875456	7319893232403309568	2025-12-29 14:04:08.532
7331902679771694080	❤️	7331902679704585216	9999999999999999999	2025-12-31 09:37:20.022
7331245099165806592	❤️	7331244568941795328	7319893232403309568	2025-12-29 14:04:20.589
7331902782964155392	❤️	7331902782754440192	9999999999999999999	2025-12-31 09:37:44.625
7331902795547067392	❤️	7331902782754440192	7319893232403309568	2025-12-31 09:37:49.626
7331903103446729728	👏	7331902787028435968	7319893232403309568	2025-12-31 09:39:01.035
7331903909491295232	❤️	7331903909189305344	9999999999999999999	2025-12-31 09:42:13.211
7332991225634009088	❤️	7332991225382350848	9999999999999999999	2026-01-03 09:42:49.58
7332991240486039552	❤️	7332991240410542080	9999999999999999999	2026-01-03 09:42:53.121
7333077526446755840	❤️	7333077526220263424	9999999999999999999	2026-01-03 15:25:45.298
7333285733475481600	❤️	7333285733253183488	9999999999999999999	2026-01-04 05:13:05.721
7333963424214243328	❤️	7333963407105677312	9999999999999999999	2026-01-06 02:05:59.784
7333963438927861760	❤️	7333963407105677312	7320276851855168512	2026-01-06 02:06:03.292
7333963461946202112	❤️	7333963460553693184	9999999999999999999	2026-01-06 02:06:08.78
7333963512638560256	❤️	7333963512424650752	9999999999999999999	2026-01-06 02:06:20.866
7331244925247920128	😢	7331244556467935232	7319893232403309568	2025-12-29 14:06:03.054
7331245849712243712	👏	7331245824999404544	7331239930557463552	2025-12-29 14:07:25.503
7331246678125032448	❤️	7331246619270558720	7319893232403309568	2025-12-29 14:10:37.042
7331250687644775424	❤️	7331250366201705472	7331157438012509184	2025-12-29 14:26:32.986
7331250699808257024	❤️	7331250681365902336	7331157438012509184	2025-12-29 14:26:35.886
7331250925499560960	❤️	7331250820230919168	7319893232403309568	2025-12-29 14:27:29.695
7331250967794922496	❤️	7331250650596488192	7319893232403309568	2025-12-29 14:27:39.779
7331253048366838784	👍	7331252956092150784	7326530218858752000	2025-12-29 14:35:55.826
7331253062119961600	👍	7331252968012362752	7326530218858752000	2025-12-29 14:36:04.002
7331385843271511040	❤️	7331385811579350016	7326530218858752000	2025-12-29 23:23:36.598
7331385854172507136	👍	7331385740594949120	7326530218858752000	2025-12-29 23:23:39.197
7331385864247225344	😂	7331385811579350016	7319893232403309568	2025-12-29 23:23:43.941
7331393818589572096	❤️	7331393729531915264	7319893232403309568	2025-12-29 23:55:18.063
7331393864684973056	😂	7331393729531915264	7331130523177184256	2025-12-29 23:55:29.053
7331431747101830144	❤️	7331430027437190144	7331130523177184256	2025-12-30 02:26:00.924
7331578974910721024	❤️	7331578943201782784	7319893232403309568	2025-12-30 12:11:02.77
7331578998667258880	❤️	7331578943201782784	7331578479903157248	2025-12-30 12:11:08.434
7331579033702280192	❤️	7331578902076632064	7331578479903157248	2025-12-30 12:11:16.787
7331579178082806784	😂	7331579087037049856	7319893232403309568	2025-12-30 12:11:51.209
7331767127755893760	❤️	7331767053906783232	7319893232403309568	2025-12-31 00:38:41.903
7331773154837721088	❤️	7331773021689540608	7319893232403309568	2025-12-31 01:02:38.872
7331773174152491008	👍	7331773021689540608	7320276851855168512	2025-12-31 01:02:43.476
7331773448145399808	❤️	7331773416126083072	7319893232403309568	2025-12-31 01:03:48.802
7331784686453823488	❤️	7331784667747227648	7319893232403309568	2025-12-31 01:48:28.223
7331786010203163648	😮	7331785986857667584	7320276851855168512	2025-12-31 01:53:43.83
7331786549484692480	❤️	7331786174314725376	7319893232403309568	2025-12-31 01:55:52.405
7331900086387004416	❤️	7331899940693660672	7319893232403309568	2025-12-31 09:27:01.712
7331901221350317056	❤️	7331901221077687296	9999999999999999999	2025-12-31 09:31:32.308
7331901530975003648	❤️	7331901530710762496	9999999999999999999	2025-12-31 09:32:46.128
7331901549815817216	❤️	7331901549731931136	9999999999999999999	2025-12-31 09:32:50.62
7331901683280975872	❤️	7331901681867495424	9999999999999999999	2025-12-31 09:33:22.441
7331901703539464192	❤️	7331901703300388864	9999999999999999999	2025-12-31 09:33:27.271
7331901874502330368	❤️	7331901874212923392	9999999999999999999	2025-12-31 09:34:08.03
7331901884665128960	❤️	7331901884593825792	9999999999999999999	2025-12-31 09:34:10.454
7331901913740044288	❤️	7331901913521940480	9999999999999999999	2025-12-31 09:34:17.386
7331901936095684608	❤️	7331901935890163712	9999999999999999999	2025-12-31 09:34:22.716
7331901947558717440	❤️	7331901913521940480	7319893232403309568	2025-12-31 09:34:25.448
7331901981331253248	❤️	7331901981121538048	9999999999999999999	2025-12-31 09:34:33.501
7331902059924121600	❤️	7331902059714406400	9999999999999999999	2025-12-31 09:34:52.238
7331902547089081344	❤️	7331902546820645888	9999999999999999999	2025-12-31 09:36:48.389
7331902661782324224	❤️	7331902661572609024	9999999999999999999	2025-12-31 09:37:15.734
7331902666064708608	❤️	7331902665997599744	9999999999999999999	2025-12-31 09:37:16.755
7331902669709558784	❤️	7331902669646644224	9999999999999999999	2025-12-31 09:37:17.624
7331902673555735552	❤️	7331902673480238080	9999999999999999999	2025-12-31 09:37:18.541
\.


--
-- Data for Name: Message_seens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Message_seens" (id, message_id, seen_by_id, seen_at) FROM stdin;
7331242517449926656	7331240098216377344	7319893232403309568	2025-12-29 13:54:05.06
7331242517454120960	7331240161030274048	7319893232403309568	2025-12-29 13:54:05.061
7331242517496064000	7331240174674344960	7319893232403309568	2025-12-29 13:54:05.071
7331242517508646912	7331240193171225600	7319893232403309568	2025-12-29 13:54:05.073
7331242567961929728	7331142263686083584	7319893232403309568	2025-12-29 13:54:17.102
7331242567978706944	7331142984418479104	7319893232403309568	2025-12-29 13:54:17.107
7331242568016455680	7331159828168683520	7319893232403309568	2025-12-29 13:54:17.116
7331242568037427200	7331131028364323840	7319893232403309568	2025-12-29 13:54:17.121
7331242568045815808	7331163575456346112	7319893232403309568	2025-12-29 13:54:17.122
7331242568050010112	7331142289040651264	7319893232403309568	2025-12-29 13:54:17.124
7331242568062593024	7331163598831202304	7319893232403309568	2025-12-29 13:54:17.127
7331242568108730368	7331164343177555968	7319893232403309568	2025-12-29 13:54:17.138
7331242568112924672	7331164373707894784	7319893232403309568	2025-12-29 13:54:17.139
7331242568133896192	7331164383950385152	7319893232403309568	2025-12-29 13:54:17.144
7331242568138090496	7331159867414786048	7319893232403309568	2025-12-29 13:54:17.145
7331242568146479104	7331166234779299840	7319893232403309568	2025-12-29 13:54:17.147
7331242568150673408	7331166239376257024	7319893232403309568	2025-12-29 13:54:17.148
7331242568205199360	7331166288697077760	7319893232403309568	2025-12-29 13:54:17.161
7331242568221976576	7331166686942048256	7319893232403309568	2025-12-29 13:54:17.164
7331242568226170880	7331166699621429248	7319893232403309568	2025-12-29 13:54:17.166
7331242793794626560	7331166692591775744	7319893232403309568	2025-12-29 13:55:10.946
7331242793819792384	7331170054691336192	7319893232403309568	2025-12-29 13:55:10.952
7331242793828180992	7331170065898516480	7319893232403309568	2025-12-29 13:55:10.954
7331242793844958208	7331170083141300224	7319893232403309568	2025-12-29 13:55:10.958
7331242968743240704	7331242968659354624	7319893232403309568	2025-12-29 13:55:52.657
7331243012074595328	7331240098216377344	7331239930557463552	2025-12-29 13:56:02.987
d1cdb4d3-005e-40e0-85e9-01663f8f7581	7331240161030274048	7331239930557463552	2025-12-29 13:59:02.772
c539b7d7-20de-4226-b69d-51b5389c503e	7331240174674344960	7331239930557463552	2025-12-29 13:59:02.779
0de978bc-c26d-4f45-90c5-3051400467ed	7331240193171225600	7331239930557463552	2025-12-29 13:59:02.782
3362be85-816e-4bf0-b196-a27188511c70	7331243776105093120	7331239930557463552	2025-12-29 13:59:05.165
e0fa19b2-2703-42c4-baa0-7f5ca0fd6cb7	7331243776105093120	7319893232403309568	2025-12-29 13:59:13.203
c7beca76-c35f-4266-8813-55e23a961cc8	7331243837518092288	7331239930557463552	2025-12-29 13:59:19.809
a38923de-a92e-44d4-a049-1d5bd00925b4	7331243837518092288	7319893232403309568	2025-12-29 13:59:19.811
5e27044b-8fe5-4de2-9450-acb44cd1b0a1	7331244490600585216	7331239930557463552	2025-12-29 14:01:55.53
180ecf75-bd48-4369-a0d4-4f21f3b96294	7331244497122727936	7331239930557463552	2025-12-29 14:01:57.07
42f5659f-27a9-4de7-bc48-65da38fc34da	7331244515284064256	7331239930557463552	2025-12-29 14:02:01.399
3ab02493-b186-4c8e-b5e2-63a6d6758012	7331244531767678976	7331239930557463552	2025-12-29 14:02:05.331
8557beb8-e4f5-444c-8539-cfe08c4590ee	7331244537513875456	7331239930557463552	2025-12-29 14:02:06.701
aa756d96-c80d-4fa2-9495-84cba36522fa	7331157839902329856	7319893232403309568	2025-12-29 14:03:44.628
d2b9e99d-6bc9-43dc-b61f-5138f0606707	7331157928544750592	7319893232403309568	2025-12-29 14:03:44.628
235896e9-5ffb-4462-8d3f-74ac314eb79c	7331094500073956352	7319893232403309568	2025-12-29 14:03:45.423
446c0249-4d65-4a31-96a8-f4090989e5d0	7331117370933543936	7319893232403309568	2025-12-29 14:03:45.428
c9b36be7-009d-4311-b40d-eb76e0a5a56d	7331118476774376448	7319893232403309568	2025-12-29 14:03:45.432
6a0b32f8-ce49-4cf9-9f26-7d1555d681a6	7331118664746304512	7319893232403309568	2025-12-29 14:03:45.433
a995f170-0945-494f-8ebd-5589afe25852	7331118755431351296	7319893232403309568	2025-12-29 14:03:45.444
2160ca83-1e56-4b27-b3b5-3f1c67cc7107	7331118800335569920	7319893232403309568	2025-12-29 14:03:45.447
d983ed03-7b69-42e7-97f2-68c26dc4f4f9	7331119236211835904	7319893232403309568	2025-12-29 14:03:45.451
05b7408e-6c41-4f44-bbf3-cbf81a2c122d	7331119306399319040	7319893232403309568	2025-12-29 14:03:45.452
76958096-f8c6-4966-9f43-4da1e45c207c	7331122312804133888	7319893232403309568	2025-12-29 14:03:45.453
8be04458-3622-499f-997c-6b6a3ea6e305	7331244556467935232	7331239930557463552	2025-12-29 14:06:50.88
b4c1cbad-ec88-453f-9b9e-609970bb16a4	7331244568941795328	7331239930557463552	2025-12-29 14:06:50.882
70ec63fe-7919-4ee2-a8cf-7a4b8b667ff0	7331245791994426368	7319893232403309568	2025-12-29 14:07:05.794
d3e55c7e-7433-4e39-8a9a-d0d81532734c	7331245812634596352	7319893232403309568	2025-12-29 14:07:10.715
9298b21f-fb3e-42c6-b522-2990517a350f	7331245824999404544	7331239930557463552	2025-12-29 14:07:13.662
22faeefe-0ea4-452b-9d8a-d319ba8b6880	7331246619270558720	7319893232403309568	2025-12-29 14:10:28.416
dce69ed4-21ac-4a33-be49-20f18f6b5386	7331247095605081088	7319893232403309568	2025-12-29 14:12:16.597
0ad14a85-ced7-4bda-851e-03b5ecb22462	7331247110410974208	7319893232403309568	2025-12-29 14:12:20.125
5a3e78b3-bf57-43ab-92aa-b399c4c8e9db	7331248382941836288	7331239930557463552	2025-12-29 14:17:23.524
792973d6-e395-4046-93b7-274348e4916b	7331248406794843136	7331239930557463552	2025-12-29 14:20:10.733
0b30cec2-462d-463c-969c-16319d8bc8c3	7331249095650554880	7319893232403309568	2025-12-29 14:20:13.445
d85387c4-1f0b-4080-b1f1-255f838b95f9	7331249124905825280	7319893232403309568	2025-12-29 14:20:20.42
f5218021-8d08-4214-b0d4-c55d15b2197f	7331249152403682304	7319893232403309568	2025-12-29 14:20:31.692
50584254-89ba-4b38-8cf9-cb2ef973c5ec	7331128128498035712	7319893232403309568	2025-12-29 14:24:55.837
6f9c8fe4-e370-4fc5-8979-c8450773f822	7331128145212337152	7319893232403309568	2025-12-29 14:24:55.852
c9ac466a-aeaa-4250-b768-dedb0a0433e6	7331128166716533760	7319893232403309568	2025-12-29 14:24:55.856
70ae795c-0d7d-4d98-8b8e-d041b06b78a3	7331143925175700480	7319893232403309568	2025-12-29 14:24:55.856
c7313359-9673-44ea-81ac-f53280b64038	7331143983493303296	7319893232403309568	2025-12-29 14:24:55.859
c15c1588-2e5d-450a-9e67-e9f2e5bf21b6	7331157861490412544	7331157438012509184	2025-12-29 14:25:36.202
7fa3cf8f-afb8-4427-ac7e-2cfd67c56abe	7331159306539872256	7331157438012509184	2025-12-29 14:25:36.204
efb2e91a-065a-4f50-9734-ffb9b8bd50d1	7331222011699245056	7331157438012509184	2025-12-29 14:25:36.227
21779ddf-e4bd-42cd-b69f-ca2377d3f18a	7331250366201705472	7331157438012509184	2025-12-29 14:25:36.227
75fb7eb4-6f9f-4e66-9449-0b56eb5b6eaf	7331250650596488192	7319893232403309568	2025-12-29 14:26:24.174
ce504e65-83b2-4be3-9115-f1329e47a141	7331250681365902336	7331157438012509184	2025-12-29 14:26:31.529
c1e7feb1-37ba-45f4-a10e-0ee1b6798c52	7331250820230919168	7319893232403309568	2025-12-29 14:27:24.349
2659429b-a874-402f-995d-22c25c7a1d66	7331252870587069440	7319893232403309568	2025-12-29 14:35:16.268
91796646-996e-49df-9e7f-a2c666aa7750	7331252956092150784	7326530218858752000	2025-12-29 14:35:33.854
d246e9e6-d23e-45d8-8e06-146c31d30528	7331252968012362752	7326530218858752000	2025-12-29 14:35:36.745
bd088ca5-3718-47ab-933f-139bc3079d6d	7331253005916288000	7326530218858752000	2025-12-29 14:35:51.207
66c253db-892c-4e1f-9c4e-0a83ef675149	7331253011150779392	7326530218858752000	2025-12-29 14:35:51.209
1a293af0-c7dd-4405-8c7d-7a0cfa0b5c7b	7331253847742460928	7319893232403309568	2025-12-29 14:39:06.431
51f4668f-383d-40c1-bfc5-2a7283e55b5d	7331253869204714496	7319893232403309568	2025-12-29 14:39:11.55
6b7a4b4a-c211-4503-8c0d-7a04dec02c46	7331252956092150784	7319893232403309568	2025-12-29 14:43:35.962
35885261-3c27-4105-a898-96aaa537083e	7331252968012362752	7319893232403309568	2025-12-29 14:43:35.966
c9cb49eb-825c-44b1-9b46-8faa3edcf6d4	7331253005916288000	7319893232403309568	2025-12-29 14:43:35.966
bad6f721-93c3-4967-832c-7f7dd98b474f	7331253011150779392	7319893232403309568	2025-12-29 14:43:35.989
822e9f2a-0785-4538-8ac1-18adc07b2ce7	7331253891002512384	7319893232403309568	2025-12-29 14:43:35.991
4af8444a-6742-4108-a249-a6bf7bdf3376	7331253891002512384	7319893232403309568	2025-12-29 14:43:35.993
c20e49a1-675a-4200-841a-6e45ef9f9d16	7331253908840887296	7319893232403309568	2025-12-29 14:43:35.997
b27bc9d1-ae0f-48e6-9406-f674824e47e1	7331252870587069440	7326530218858752000	2025-12-29 14:45:09.5
cfb1b35d-c1b5-491f-a3dd-1c99aedba50f	7331253847742460928	7326530218858752000	2025-12-29 14:45:09.54
da937034-202e-4aac-b755-17270df84291	7331253891002512384	7326530218858752000	2025-12-29 14:45:09.545
db5c7cc7-a99f-4015-833e-4dd96704698c	7331253908840887296	7326530218858752000	2025-12-29 14:45:09.545
0eca6b09-b7cf-4279-a284-1ccc031ff108	7331254995555693568	7326530218858752000	2025-12-29 14:45:09.548
c8b09625-fa32-4f36-a026-2ef4d2fcebaa	7331253869204714496	7326530218858752000	2025-12-29 14:45:09.54
aa11da44-6076-4418-af28-b80d3edcba7d	7331255377732285440	7326530218858752000	2025-12-29 14:45:11.21
546f2933-785a-49e2-9907-5f0abcb8f593	7331254995555693568	7319893232403309568	2025-12-29 14:45:17.037
5b8ec649-3ab4-457a-b077-aa62f21b121b	7331254995555693568	7319893232403309568	2025-12-29 14:45:17.037
4b18787f-daa2-4346-8f90-90a5aeac5521	7331255377732285440	7319893232403309568	2025-12-29 14:45:17.038
84a47714-6ca6-4c43-b5f8-3f4886183804	7331255611774448640	7326530218858752000	2025-12-29 14:46:07.015
0b1087c6-8079-4133-b411-d7a56a9c5048	7331255611774448640	7319893232403309568	2025-12-29 14:46:09.222
404ee15f-c0c9-4517-a0e1-414063cd8026	7331255751851619328	7326530218858752000	2025-12-29 14:46:40.408
6ef525d5-8e63-41f5-be76-b8b35b53d927	7331255751851619328	7319893232403309568	2025-12-29 14:46:43.691
7a767865-47d5-4bab-937a-c290c350c7ab	7331244490600585216	7319893232403309568	2025-12-29 14:50:09.293
7db01cdf-b41d-4e23-8caa-d6704e1e9acb	7331244497122727936	7319893232403309568	2025-12-29 14:50:09.294
95016e32-5488-4f95-b212-6cbf3bf8432d	7331244515284064256	7319893232403309568	2025-12-29 14:50:09.302
0e1fc7e2-8d1f-4c65-9414-f5a94b728714	7331244531767678976	7319893232403309568	2025-12-29 14:50:09.304
34d4ef48-42d3-4947-bbdc-1aafc9d93cb7	7331244537513875456	7319893232403309568	2025-12-29 14:50:09.312
a54eb1bf-f03e-41d1-8ff0-139bbe3278b8	7331244556467935232	7319893232403309568	2025-12-29 14:50:09.312
93c18008-eaaf-40c2-8d15-5de47da72610	7331244568941795328	7319893232403309568	2025-12-29 14:50:09.317
4b2aaf69-2aef-482f-8062-0569abee6835	7331245824999404544	7319893232403309568	2025-12-29 14:50:09.341
f1c80cd3-84f9-42d8-9ef8-88ea15e324fc	7331248382941836288	7319893232403309568	2025-12-29 14:50:09.365
c4722aa8-3fe4-418c-939a-0087ff8c861d	7331248406794843136	7319893232403309568	2025-12-29 14:50:09.368
56db5231-f4f8-40a6-a0bc-6b50994edba7	7331094329323840512	7319893232403309568	2025-12-29 14:50:10.607
f2277941-ba77-4478-a2bf-7fa6de2bc572	7331094356901389312	7319893232403309568	2025-12-29 14:50:10.61
ac1ab6ea-5e60-4c72-96cf-234ccacf7224	7331094514619802624	7319893232403309568	2025-12-29 14:50:10.613
f52cce70-6343-4c97-af40-f993935fc169	7331094526741341184	7319893232403309568	2025-12-29 14:50:10.627
4958c72d-4de4-433d-98ee-928a831058de	7331094560673260544	7319893232403309568	2025-12-29 14:50:10.631
08001ad2-c42c-4294-be95-0b88feff9ff1	7331115000755064832	7319893232403309568	2025-12-29 14:50:10.632
03d31177-3f23-40a2-80a9-d78275293421	7331115058804232192	7319893232403309568	2025-12-29 14:50:10.632
67921604-3ba1-4488-a9e1-6384d4452411	7331115240908328960	7319893232403309568	2025-12-29 14:50:10.635
ac1312bd-e357-4a79-be64-a74888e3f8c7	7331094520894481408	7319893232403309568	2025-12-29 14:50:10.642
3229b40c-d79f-4361-bea1-855ba6b3b8f9	7331115930113799168	7319893232403309568	2025-12-29 14:50:10.646
574f8316-8461-4c9f-b78d-252a96ae79d7	7331116009641997312	7319893232403309568	2025-12-29 14:50:10.65
fc7e7fa4-e440-4d41-aa6c-62e142ba98e8	7331117121284375552	7319893232403309568	2025-12-29 14:50:10.65
ced03dc1-13b8-4891-be5b-8d40c305b089	7331118520332223488	7319893232403309568	2025-12-29 14:50:10.672
c20c231c-4a41-4c4b-8332-800c8239429b	7331119289802458112	7319893232403309568	2025-12-29 14:50:10.699
0aa5c83b-51c4-41e7-a995-02856d5c432d	7331119919396848640	7319893232403309568	2025-12-29 14:50:10.716
ebf433d0-e052-458a-8af4-c37b5b16ef0a	7331120598530788352	7319893232403309568	2025-12-29 14:50:10.716
9c88b1b0-cc2a-46b7-bc8f-01c6c7412863	7331120961018460160	7319893232403309568	2025-12-29 14:50:10.723
903cf02a-3962-4515-a71d-0a5b2157ae8e	7331170156046692352	7319893232403309568	2025-12-29 14:50:10.729
64e1df4b-c013-4578-9561-6f685bf1bc24	7331170236476665856	7319893232403309568	2025-12-29 14:50:10.733
e86cab28-f149-4b7c-8da1-ad191dea6403	7331190355709898752	7319893232403309568	2025-12-29 14:50:10.733
8d85a509-d07d-41e8-8523-b55859170bdb	7331157861490412544	7319893232403309568	2025-12-29 14:50:11.653
2f885142-94c1-4ec1-80b1-59643d3e3d50	7331159306539872256	7319893232403309568	2025-12-29 14:50:11.657
7d4b3d35-0454-4d54-b9a7-8f3b1457da81	7331222011699245056	7319893232403309568	2025-12-29 14:50:11.667
196b4586-ec5a-418e-a836-6c40118c2c40	7331250366201705472	7319893232403309568	2025-12-29 14:50:11.667
e6602ed5-3b32-40c9-9727-b845f1a96ed6	7331250681365902336	7319893232403309568	2025-12-29 14:50:11.673
63aed34e-8d9d-417f-9071-d10210cf7795	7331143964774124544	7319893232403309568	2025-12-29 14:50:13.745
075f803c-7a39-4179-91b3-cabf5d8a04f1	7331256711571289088	7319893232403309568	2025-12-29 14:50:29.223
02171d4e-7254-44e9-a86c-863428caf8b8	7331256729095091200	7319893232403309568	2025-12-29 14:50:33.4
f49c3e93-fe01-4d2b-b146-8055dd00256e	7331256729095091200	7326530218858752000	2025-12-29 14:50:33.423
54913432-7b22-4e33-992c-deb47cb60a99	7331256729095091200	7326530218858752000	2025-12-29 14:50:33.423
b302c9ba-858f-4580-91a1-0b05537a94cd	7331256745440293888	7326530218858752000	2025-12-29 14:50:37.3
8cf9086d-0afe-40a2-a619-311bd79589c1	7331256745440293888	7319893232403309568	2025-12-29 14:50:37.302
3b3f0356-c4e9-49e9-9f93-eb90674f2f30	7331256812855342080	7326530218858752000	2025-12-29 14:50:53.37
047a5145-a267-4fcf-bde1-2677abe1c63b	7331256812855342080	7319893232403309568	2025-12-29 14:50:53.372
c610f146-12bc-4bcf-b658-4a3a46e87ac4	7331256812855342080	7319893232403309568	2025-12-29 14:50:53.373
ee738b2c-28f1-4119-b61b-1651a78516cc	7331256745440293888	7319893232403309568	2025-12-29 14:50:37.302
6b9154ee-6720-4374-8ed0-82f3de2824ea	7331256820614804480	7326530218858752000	2025-12-29 14:50:55.221
be42bda8-d24c-40f7-b833-35e0ad6e2203	7331256820614804480	7319893232403309568	2025-12-29 14:50:55.221
7bc3965b-ac3d-4b0e-adc2-69da60832b2a	7331256820614804480	7319893232403309568	2025-12-29 14:50:55.224
d1b3c6dc-5990-44c0-be80-f7fc7f5c8a51	7331256824817497088	7326530218858752000	2025-12-29 14:50:56.223
16dd3609-4d1d-40b1-a99a-5c9cab6705ec	7331256824817497088	7319893232403309568	2025-12-29 14:50:56.227
e0ece1d7-e03c-4e5a-ba3c-dd172cacad1e	7331256824817497088	7319893232403309568	2025-12-29 14:50:56.227
a8763f45-b849-4269-a32c-143b5a9a8bbb	7331256828911137792	7326530218858752000	2025-12-29 14:50:57.201
5145fd2e-e972-4c60-a829-62b5a5fd8983	7331256828911137792	7319893232403309568	2025-12-29 14:50:57.204
84192d25-f95c-42f4-a2c7-82df787b6115	7331256828911137792	7319893232403309568	2025-12-29 14:50:57.204
ce5674ff-ca3c-408c-96c2-df1be4ddb953	7331258066597751808	7319893232403309568	2025-12-29 14:55:52.29
0c54c700-24fb-414f-bdd4-6c81a0602f32	7331258099921497088	7319893232403309568	2025-12-29 14:56:00.233
9487be04-2ded-4fec-a313-0c34d89b9f9c	7331258099921497088	7326530218858752000	2025-12-29 14:56:00.235
076eddcc-a919-494c-b513-0ec103dcbc04	7331258099921497088	7326530218858752000	2025-12-29 14:56:00.235
0708e735-b72b-425a-a7cf-cbd588b3e68a	7331258222965599232	7326530218858752000	2025-12-29 14:56:29.57
5e87bc8e-404c-46fd-b760-600f362eeb33	7331258222965599232	7326530218858752000	2025-12-29 14:56:29.572
15d77927-59f3-4f2f-b068-64a25b6c2011	7331258222965599232	7319893232403309568	2025-12-29 14:56:29.572
d2ae3124-c465-4e7e-9e40-6f824550066e	7331258715133619200	7319893232403309568	2025-12-29 14:58:26.914
5d556bb4-de73-41d9-a21a-d219680a60c2	7331258715133619200	7326530218858752000	2025-12-29 14:58:26.928
c8d699b7-c8ff-484f-b19a-39ae8fadbded	7331258715133619200	7326530218858752000	2025-12-29 14:58:26.928
f9aadb76-618e-4d17-87b6-fb3275b3a637	7331259338071649280	7326530218858752000	2025-12-29 15:00:55.43
140688ad-bb07-4bf0-866d-9d1c03d68671	7331259338071649280	7319893232403309568	2025-12-29 15:00:59.993
92463964-d60e-40f2-b536-77fbd3beebc3	7331259338071649280	7319893232403309568	2025-12-29 15:00:59.993
ef12d9ba-6fa6-4c4f-bc83-e9c90e891475	7331259384716504064	7326530218858752000	2025-12-29 15:01:06.551
a27f6eeb-47ca-493d-9f77-a02f9fb75cc6	7331259384716504064	7319893232403309568	2025-12-29 15:01:09.457
843158d7-c9cd-4e74-acf0-6492c5e65fd6	7331259384716504064	7319893232403309568	2025-12-29 15:01:09.458
a4ff5dcd-f561-42f1-a029-2fa483be3b18	7331259486520650752	7319893232403309568	2025-12-29 15:01:30.824
95d95cd6-ca05-4dbc-95b0-bad62f6107f7	7331259486520650752	7326530218858752000	2025-12-29 15:01:30.826
fab0516c-95b5-4414-86c5-b8b02167d9ba	7331259486520650752	7326530218858752000	2025-12-29 15:01:30.827
17a891b9-388d-4bf9-9aa5-6eb3f6e8375c	7331259524227443712	7319893232403309568	2025-12-29 15:01:39.812
c4756043-6796-4cce-990e-c48caf8dc253	7331259552270560256	7319893232403309568	2025-12-29 15:01:46.497
2e269d60-f126-4ea9-a6dc-25ff669283ad	7331259524227443712	7326530218858752000	2025-12-29 23:22:34.349
d73abf2c-aaae-4209-b5f4-80c0fde12eae	7331259552270560256	7326530218858752000	2025-12-29 23:22:34.351
fb4d9b31-3ff6-454b-8856-a08b3430aad8	7331259524227443712	7326530218858752000	2025-12-29 23:22:34.35
e20b3c22-1cd3-4b2a-be65-d4f764ae7243	7331385609694915584	7326530218858752000	2025-12-29 23:22:40.928
e015c89a-70f1-4136-a8a1-9f39971b1e93	7331385609694915584	7319893232403309568	2025-12-29 23:22:57.504
7e2f1d9d-d40e-419c-940e-c438e8b36231	7331385700983942144	7326530218858752000	2025-12-29 23:23:02.696
ff28d9ec-cd75-4088-9d8e-1b5c504c86b5	7331385700983942144	7319893232403309568	2025-12-29 23:23:02.697
d54fff98-6eb8-45ba-a1ec-24e023b34935	7331385700983942144	7319893232403309568	2025-12-29 23:23:02.7
cb0d1bc6-a37a-4ca0-ba79-ff8ed41ac669	7331385708768570368	7319893232403309568	2025-12-29 23:23:04.552
292be2c4-c0a2-477c-8ada-105cdd04e317	7331385708768570368	7326530218858752000	2025-12-29 23:23:04.556
ebbe8c81-5a68-4eab-9188-d583dae6dfee	7331385711767497728	7326530218858752000	2025-12-29 23:23:05.267
cff7bcdb-3285-4937-bd3d-56e94ba18934	7331385711767497728	7319893232403309568	2025-12-29 23:23:05.271
479b3a7d-600e-4d40-ba6a-6fd6d1450047	7331385711767497728	7319893232403309568	2025-12-29 23:23:05.271
9c8b131b-5bd3-4366-9a51-aaf4298ec774	7331385713910787072	7326530218858752000	2025-12-29 23:23:05.777
ece42f29-5367-4ceb-89d4-bfdb687eb034	7331385713910787072	7319893232403309568	2025-12-29 23:23:05.78
83a752a9-2410-4939-bed9-1aff8dfa56a1	7331385713910787072	7319893232403309568	2025-12-29 23:23:05.78
f749b08b-ca58-4cc2-a4fe-90904d1a0cd8	7331385719313050624	7326530218858752000	2025-12-29 23:23:07.065
2f24f8ab-2c8d-4559-8032-41b7137e2443	7331385719313050624	7319893232403309568	2025-12-29 23:23:07.069
69261957-b20b-4cb4-bd56-2c555c40fa27	7331385719313050624	7319893232403309568	2025-12-29 23:23:07.07
df754eff-874a-4582-8e7a-28360e2acef7	7331385728569879552	7326530218858752000	2025-12-29 23:23:09.276
dd101966-06f1-4368-8bda-a98311f19f1b	7331385728569879552	7319893232403309568	2025-12-29 23:23:09.277
d6d8d508-dfae-4f03-9651-6c60abc3e91e	7331385728569879552	7319893232403309568	2025-12-29 23:23:09.277
61489ad0-139c-46ea-bfbe-3a471e0eb5d4	7331385740594949120	7319893232403309568	2025-12-29 23:23:12.14
45c773f2-46c1-4ba1-a258-27be4be6695f	7331385740594949120	7319893232403309568	2025-12-29 23:23:12.142
84cb0e4a-c81e-4067-ad23-8bfb1dc21617	7331385740594949120	7326530218858752000	2025-12-29 23:23:12.143
ef9820e0-596b-4189-ae3f-c79d63ee312d	7331385811579350016	7319893232403309568	2025-12-29 23:23:29.063
99dd5a42-07c5-4936-9146-627c177a316d	7331385811579350016	7326530218858752000	2025-12-29 23:23:29.065
d2c0b50b-1395-46ef-9295-56679ae91640	7331386026608733184	7326530218858752000	2025-12-29 23:24:20.33
34814dfc-badc-4430-9131-b08718732227	7331131028364323840	7331130523177184256	2025-12-29 23:54:35.256
b5dad8bf-3768-4708-8f6b-10e99270fba6	7331142263686083584	7331130523177184256	2025-12-29 23:54:35.258
088c5c15-91d6-4c72-97fa-2287a131495d	7331142289040651264	7331130523177184256	2025-12-29 23:54:35.298
1a08a668-761d-46a7-b07d-75e8c30f1e3e	7331159867414786048	7331130523177184256	2025-12-29 23:54:35.299
fc9ff7da-a7dc-4ed2-9c6e-1a4790e244f6	7331142984418479104	7331130523177184256	2025-12-29 23:54:35.303
a22df2f7-3491-4fc0-a2c4-b47fcc50439f	7331159828168683520	7331130523177184256	2025-12-29 23:54:35.303
809903e0-4f56-4270-8da8-8566929be3e1	7331163575456346112	7331130523177184256	2025-12-29 23:54:35.313
9143c78b-7d96-48cf-beea-2d2fb0111580	7331163598831202304	7331130523177184256	2025-12-29 23:54:35.313
9845afb1-a0b4-4a7e-919d-36c611e31afb	7331164383950385152	7331130523177184256	2025-12-29 23:54:35.38
37b654d4-063e-41e4-b210-305a6f6b2eee	7331164383950385152	7331130523177184256	2025-12-29 23:54:35.383
4e83fc37-f153-4501-85b7-20484981de46	7331164343177555968	7331130523177184256	2025-12-29 23:54:35.383
61223f04-79cc-4947-8c5b-1c6dbdaad68d	7331164343177555968	7331130523177184256	2025-12-29 23:54:35.385
e6c30fa4-acb1-4f0b-a631-4ef161004174	7331164373707894784	7331130523177184256	2025-12-29 23:54:35.386
a8c03926-36f0-4518-af93-a0311ce55e07	7331166239376257024	7331130523177184256	2025-12-29 23:54:35.414
94e474bb-f155-4511-a341-0bca74b77c70	7331170065898516480	7331130523177184256	2025-12-29 23:54:35.478
df4ff6b7-b0be-42ab-b501-b5e9f5d178d7	7331258066597751808	7331130523177184256	2025-12-29 23:54:35.513
a0fc2b81-0079-4d30-8828-739d4ec1bed1	7331166234779299840	7331130523177184256	2025-12-29 23:54:35.403
8af8cd99-378e-4bfc-8ea2-3d4f38c2c0ca	7331166288697077760	7331130523177184256	2025-12-29 23:54:35.432
823e66cb-81e4-46b5-ab9f-d38d412f8c90	7331166686942048256	7331130523177184256	2025-12-29 23:54:35.434
924648e8-7067-46ab-915d-223797264e6e	7331166692591775744	7331130523177184256	2025-12-29 23:54:35.447
693e44dc-4fdf-4dc0-9562-5ff5deb8db4f	7331166699621429248	7331130523177184256	2025-12-29 23:54:35.448
434da9d4-a162-45bc-be48-e7b626569f9d	7331170054691336192	7331130523177184256	2025-12-29 23:54:35.459
ac903ef9-748d-442a-bfea-93db74fe5b46	7331393676587215872	7319893232403309568	2025-12-29 23:54:44.233
6c8db020-38f5-4843-8e5d-a7651d9a3b43	7331393676587215872	7319893232403309568	2025-12-29 23:54:44.235
7ce8e82b-5385-413f-9bc7-a2e7976ae996	7331170065898516480	7331130523177184256	2025-12-29 23:54:35.479
682b0d63-bc2f-47b4-89ac-c8138b5cc932	7331170083141300224	7331130523177184256	2025-12-29 23:54:35.479
ea687cd5-4fd0-4acf-9850-389a2bb14bd5	7331242968659354624	7331130523177184256	2025-12-29 23:54:35.481
59473915-e87d-4201-82c1-82241e62111b	7331256711571289088	7331130523177184256	2025-12-29 23:54:35.495
7f09abf6-6e53-4b3c-83b4-ae7dc2b8c2a2	7331258066597751808	7331130523177184256	2025-12-29 23:54:35.514
0565c9da-f4fd-40c5-9be5-7ca83353aa11	7331393676587215872	7331130523177184256	2025-12-29 23:54:44.232
e2632bc0-0559-459d-b3eb-3e4fb58ce42a	7331393710431054848	7331130523177184256	2025-12-29 23:54:52.3
d2601caf-5a7a-4059-813d-76a7e642737c	7331393729531915264	7331130523177184256	2025-12-29 23:54:56.857
e76ab29d-8bf2-42d3-af38-a0f063fce6cc	7331393710431054848	7319893232403309568	2025-12-29 23:55:00.979
05efc9d7-f8f7-4c6f-a351-277f85cd685b	7331393729531915264	7319893232403309568	2025-12-29 23:55:00.979
8a20dc0f-1aa2-4d02-89b6-4f81f7e83101	7331393710431054848	7319893232403309568	2025-12-29 23:55:00.976
ed5a447d-c408-4d08-90ef-64c34327a019	7331394009438792704	7319893232403309568	2025-12-29 23:56:03.584
adeb7d5d-b780-448a-aba2-31f222f2857c	7331394009438792704	7331130523177184256	2025-12-29 23:56:04.706
c0695ed7-7315-4155-81c1-e03d457ed1ac	7331429933933571072	7319893232403309568	2025-12-30 02:18:49.128
675da6f0-3ffb-4451-b373-d4659c8e4131	7331429948341005312	7319893232403309568	2025-12-30 02:18:58.383
41c6cd1a-cf63-4edb-8828-9d3d25515dcd	7331429998039313408	7331130523177184256	2025-12-30 02:19:04.207
49e3b4b1-c3ba-4f82-9800-29caea87258a	7331386026608733184	7331130523177184256	2025-12-30 02:19:08.09
78f3af05-a345-41c7-acf0-a7335e780f3d	7331430027437190144	7331130523177184256	2025-12-30 02:19:13.526
94fa2ea2-0876-413c-8417-041aed208a52	7331578902076632064	7331578479903157248	2025-12-30 12:10:45.853
ef605abf-ac52-4311-95ef-49a963cfdb74	7331578943201782784	7319893232403309568	2025-12-30 12:10:55.412
af11d062-99cc-4441-a185-7f4948e44c19	7331579087037049856	7319893232403309568	2025-12-30 12:11:39.394
ba47da3b-9ea4-4a3d-b7f9-513b7254a07d	7331579797208214528	7319893232403309568	2025-12-30 12:14:18.958
343edb51-a915-4c3e-8539-2f1ce6f1597b	7331094329323840512	7320276851855168512	2025-12-31 00:33:38.314
92de9d93-534d-4e06-9aa3-75f873a9fd0b	7331094526741341184	7320276851855168512	2025-12-31 00:33:38.326
31c43b68-b7e2-4f43-8bcf-8160ec163f33	7331094560673260544	7320276851855168512	2025-12-31 00:33:38.332
5a1bfcff-204f-4095-8f22-8fa8062c31a0	7331115000755064832	7320276851855168512	2025-12-31 00:33:38.335
18770065-9ff2-4832-b532-e74e735fd9ba	7331094356901389312	7320276851855168512	2025-12-31 00:33:38.343
e48e00e6-b815-4095-bbb3-007b672309b8	7331094514619802624	7320276851855168512	2025-12-31 00:33:38.345
30313d60-78b4-44ab-b9cf-a336a3866b4a	7331094520894481408	7320276851855168512	2025-12-31 00:33:38.349
8c09ebde-505e-48cd-8b7b-463c5241e61b	7331115240908328960	7320276851855168512	2025-12-31 00:33:38.353
e98df5af-cd19-4ea7-8f6c-4be2713bbf1b	7331115058804232192	7320276851855168512	2025-12-31 00:33:38.352
6ed30c2d-f6c1-4314-960c-3a3567183ddb	7331115930113799168	7320276851855168512	2025-12-31 00:33:38.354
0b08c4e9-5b4e-4fb9-a3d1-6d2fef92ced8	7331116009641997312	7320276851855168512	2025-12-31 00:33:38.365
d92ea629-ac5d-4c8e-8d50-c50535f2fc51	7331117121284375552	7320276851855168512	2025-12-31 00:33:38.369
8332a801-4b37-476a-9c61-6a8c8d17b6d3	7331118520332223488	7320276851855168512	2025-12-31 00:33:38.373
5c1f922d-9156-435e-a8b3-01dfc5f010ac	7331119289802458112	7320276851855168512	2025-12-31 00:33:38.373
6ace3b5b-4ed5-4230-b102-771f504bb784	7331119919396848640	7320276851855168512	2025-12-31 00:33:38.376
ba88923f-4989-43da-89d6-9985ff8bf9b0	7331120598530788352	7320276851855168512	2025-12-31 00:33:38.379
f0c27f93-5ddf-4559-82ef-2588539b85d8	7331120961018460160	7320276851855168512	2025-12-31 00:33:38.384
4668bd76-c04d-4327-aafe-172b2ec567bf	7331170156046692352	7320276851855168512	2025-12-31 00:33:38.388
b1463083-e76f-4968-94cc-5b622c662f66	7331170236476665856	7320276851855168512	2025-12-31 00:33:38.394
ed9b8f3b-8223-4bba-9bc3-6bf1b92fa057	7331190355709898752	7320276851855168512	2025-12-31 00:33:38.395
336ef7c5-6284-44db-9392-d6b10a974d7c	7331766574514613248	7320276851855168512	2025-12-31 00:36:30.047
e1aea216-30fd-459c-ac97-1eeb97c45672	7331765873638026240	7319893232403309568	2025-12-31 00:36:30.486
77d4e348-7945-4bad-a36d-6a548c5042ac	7331767053906783232	7320276851855168512	2025-12-31 00:40:51.488
53955b84-b952-4d97-8bb5-e737654c2de8	7331767261680020480	7320276851855168512	2025-12-31 00:40:51.489
b2637333-bc02-4ae2-b3ec-65b555598b94	7331767289031076864	7320276851855168512	2025-12-31 00:40:51.492
68c6086b-0d5a-41f1-b9af-92f1d21f6460	7331771113532878848	7319893232403309568	2025-12-31 00:54:36.055
3427ccac-35ff-4b22-9a55-208058ed6da4	7331771870902546432	7319893232403309568	2025-12-31 00:58:08.765
a678a38b-c652-4153-9936-ce659d5e4de8	7331771922748338176	7319893232403309568	2025-12-31 00:58:08.769
b961d794-716d-4532-81d8-de4c3b51f5fd	7331772420410896384	7319893232403309568	2025-12-31 00:59:43.794
7cbe7de6-4eac-4a7d-9492-3c926039497f	7331772435426504704	7319893232403309568	2025-12-31 00:59:47.37
fa1f7660-945a-45c3-b200-465bf873699d	7331772504787709952	7319893232403309568	2025-12-31 01:01:49.949
0cb77ff0-afd0-4195-a6d2-2b218cd1d83b	7331772529194364928	7319893232403309568	2025-12-31 01:01:49.952
8f557dce-c945-4468-8597-80d501c1aab6	7331772544298053632	7319893232403309568	2025-12-31 01:01:49.956
7850bf48-67e1-4c70-b18b-86466d37f60a	7331772549708705792	7319893232403309568	2025-12-31 01:01:49.966
cc38c218-3209-4e7c-afb6-af79796e9411	7331772554754453504	7319893232403309568	2025-12-31 01:01:49.967
ff818d38-d5be-44c8-93dc-63281acb9a42	7331772913006735360	7319893232403309568	2025-12-31 01:01:50.049
37efa77f-a80c-4bcf-ae71-ad88d63aa88b	7331772813878554624	7319893232403309568	2025-12-31 01:01:50.051
a7bb2615-91be-4e08-94b0-fc239a0a6c77	7331772909336719360	7319893232403309568	2025-12-31 01:01:50.055
834f8c58-5b71-4073-b3de-4150fab66a4b	7331772838897577984	7319893232403309568	2025-12-31 01:01:50.055
defd06f7-1f3e-4064-9d14-8403dad94879	7331772833612754944	7319893232403309568	2025-12-31 01:01:50.073
2aa0d98a-4f14-4e45-afac-641d0f7d3d83	7331772991096287232	7319893232403309568	2025-12-31 01:02:35.912
ebd2ff47-2315-46d6-8314-963c739228ad	7331773018921299968	7319893232403309568	2025-12-31 01:02:35.915
4fb329cf-a97d-49c5-bf94-ce0bfd8bfb19	7331773021689540608	7319893232403309568	2025-12-31 01:02:35.916
1fbb7805-d69d-4931-9a30-760116b22bb9	7331773340527947776	7320276851855168512	2025-12-31 01:03:23.17
4adf3dfa-cfee-4736-9322-f3a618c41027	7331773367421825024	7319893232403309568	2025-12-31 01:03:29.582
7651eb5b-f71f-4edd-8bb5-cd3231e8c855	7331773380596133888	7320276851855168512	2025-12-31 01:03:32.719
60528a8a-cb7f-4aab-841f-45fe00c1399e	7331773416126083072	7319893232403309568	2025-12-31 01:03:44.4
50fa22b6-ef3c-46a7-9fa1-274a4c8c02ec	7331773532115365888	7320276851855168512	2025-12-31 01:04:08.845
b62da876-4cd0-4349-a14d-22cffe52150c	7331774851280826368	7319893232403309568	2025-12-31 01:10:21.787
31df69ca-bbb6-4dee-8694-fe0cbd8b6a5b	7331780721285223424	7320276851855168512	2025-12-31 01:32:42.884
73a105f8-c76c-46b5-a903-f0149ee1ce55	7331780749500306432	7320276851855168512	2025-12-31 01:32:49.607
31dde4ce-8a5f-4419-83f1-aa83831d8f71	7331780761814627328	7320276851855168512	2025-12-31 01:32:55.72
dae6e4b8-6375-44d5-b46b-f431c84677a8	7331781344099235840	7320276851855168512	2025-12-31 01:35:14.099
f83d6857-2aa6-4dae-83bb-5f5675056822	7331781378475751424	7320276851855168512	2025-12-31 01:35:19.568
efec648e-23d8-47cb-a41d-105a2bc5c54c	7331781407286425600	7320276851855168512	2025-12-31 01:35:26.433
261e0f26-ecbb-4615-87b4-255e1fbd4ed1	7331781517772781568	7320276851855168512	2025-12-31 01:35:52.777
32e2de4f-efa9-433e-87af-ccde920e2014	7331783939887954944	7319893232403309568	2025-12-31 01:45:30.253
11837e42-0d56-4b52-a9b9-8c8f65f1318b	7331783962390395904	7319893232403309568	2025-12-31 01:45:35.621
279533ed-052b-4b61-8b3f-e421944bc88f	7331784083177962496	7319893232403309568	2025-12-31 01:46:04.436
70ef469b-c67d-4010-b0d6-487c34759b52	7331782007358074880	7320276851855168512	2025-12-31 01:46:16.205
f0b3c038-958d-452e-8491-4687d240178f	7331784165398903808	7320276851855168512	2025-12-31 01:46:24.047
831a79aa-7de8-4089-9064-d06b456c6054	7331784191571360768	7320276851855168512	2025-12-31 01:46:30.26
05f9c327-e475-4f60-8568-906f566be0d2	7331784224387595264	7320276851855168512	2025-12-31 01:46:38.084
124e4d4a-f49a-426a-92ce-69d0f6368e02	7331784262958414848	7319893232403309568	2025-12-31 01:47:48.434
06c46a37-b40e-488d-93ed-ab647bfcd751	7331784531860166656	7320276851855168512	2025-12-31 01:47:51.399
d7219760-28d4-4fc4-bef7-c2eedf8d9768	7331784541481900032	7320276851855168512	2025-12-31 01:47:53.735
b50bb66e-d347-4401-9b23-e7737c7ae1e1	7331784576718247936	7319893232403309568	2025-12-31 01:48:02.83
794553eb-3b3c-4df5-9220-4d9ac6b934c8	7331784561564227584	7319893232403309568	2025-12-31 01:48:02.83
ead474cd-b1c2-4a23-849f-68f4030bf0d6	7331784604413237248	7319893232403309568	2025-12-31 01:48:20.594
411aa8d5-5ce2-4fb2-8cdc-95a9e9dd626d	7331784609119246336	7319893232403309568	2025-12-31 01:48:20.597
0d90b4f6-2def-4ca6-806f-db3d84eb74af	7331785110354348032	7319893232403309568	2025-12-31 01:50:09.356
a7a12d9d-e236-4141-a010-3e4b42322018	7331785137759930368	7319893232403309568	2025-12-31 01:50:15.883
d78e4c22-1acb-4eb4-a930-557c160aa8da	7331785201984576512	7319893232403309568	2025-12-31 01:50:31.161
23e3c42c-0325-4dbd-961b-2f1eecc87bfa	7331785929840299008	7319893232403309568	2025-12-31 01:53:24.695
c5c0c792-1437-4c03-8a8b-a89daf29ffab	7331785946323913728	7319893232403309568	2025-12-31 01:53:28.657
45d82864-ad29-4a4e-9b91-ec5e959724c3	7331785771729395712	7320276851855168512	2025-12-31 01:53:40.639
bb558893-8cf8-4389-80ef-bbbf4aff310c	7331785986857667584	7320276851855168512	2025-12-31 01:53:41.253
3a291bbd-c1f3-4ead-936d-a31628b53139	7331786072466237440	7319893232403309568	2025-12-31 01:54:04.478
0bfa9f49-cb8c-4c73-9dfa-eb90404b8200	7331786101595678720	7319893232403309568	2025-12-31 01:54:05.749
bd6587a0-4ef7-4ad2-945a-e8e4c9afe022	7331786115554322432	7320276851855168512	2025-12-31 01:54:08.976
de43a1ec-27bd-42bc-b799-3c871eb8d8fc	7331786174314725376	7319893232403309568	2025-12-31 01:54:23.06
3e643098-1d1c-4217-a056-276d1f3a74a3	7331786655807324160	7319893232403309568	2025-12-31 01:56:38.695
38a17a0f-b639-4304-98e1-0ffa38db33dd	7331786749726542848	7319893232403309568	2025-12-31 01:56:40.171
f8f055aa-768b-4480-b657-d265749430fc	7331786848051713024	7319893232403309568	2025-12-31 01:57:03.615
927e19f6-127e-4f85-ba99-a0a9c4d7ded5	7331786927609271296	7320276851855168512	2025-12-31 01:57:22.592
384e062d-ec15-42d2-881c-98283aae0d4b	7331786956147315712	7320276851855168512	2025-12-31 01:57:29.39
6ae513e2-a03a-42fc-8e03-16ee79d2835d	7331790164022318080	7319893232403309568	2025-12-31 02:10:14.364
cf6114bb-658a-42f3-a3f6-d51aabd5ceaa	7331790164022318080	7319893232403309568	2025-12-31 02:10:14.365
a48b5e7a-56ba-4196-9337-0e1e3ad07b04	7331899516574028800	7319893232403309568	2025-12-31 09:24:46.173
679b8377-9255-46a4-b9d4-7b3f189f664b	7331899522114704384	7319893232403309568	2025-12-31 09:24:47.67
25507dd4-a958-4a93-8ea2-5964d8885fb3	7331899542545159168	7319893232403309568	2025-12-31 09:24:52.077
6e9fd33c-4d62-48f7-8299-a89074295ab8	7331899573029360640	7319893232403309568	2025-12-31 09:25:00.305
696c2083-2d1d-4108-8fce-26d2ba732e33	7331899940693660672	7319893232403309568	2025-12-31 09:26:27.967
eb7ad5d1-e654-45d7-8de4-731b3254e7bf	7331901221077687296	9999999999999999999	2025-12-31 09:31:32.306
3d6ee283-281d-48c6-a4e6-4d7f7863e275	7331901221442591744	7319893232403309568	2025-12-31 09:31:32.352
4f3e2332-2f1d-456c-bb03-b4d75d22c529	7331901530710762496	9999999999999999999	2025-12-31 09:32:46.127
e71bfc15-4001-4825-a9e4-3c01086cd2cd	7331901549731931136	9999999999999999999	2025-12-31 09:32:50.619
6d94a536-d96d-4840-9a48-ea7a62f20263	7331901549941646336	7319893232403309568	2025-12-31 09:32:50.67
62921cef-4b03-489e-bb29-a9436f69c165	7331901681867495424	9999999999999999999	2025-12-31 09:33:22.166
3a3a3e3d-e982-4faa-8537-bb5ef9989cf6	7331901686175045632	7319893232403309568	2025-12-31 09:33:25.432
61be3c94-79f3-4c84-9922-cb098812eb64	7331901703300388864	9999999999999999999	2025-12-31 09:33:27.231
9b45432a-7055-48c0-8b3d-f34bc783a32b	7331901707574384640	7319893232403309568	2025-12-31 09:33:28.502
18621ae7-e270-484c-99f6-61817c3110cc	7331901874212923392	9999999999999999999	2025-12-31 09:34:08.027
81303832-1ddb-45c1-b596-e359b47d4872	7331901878545639424	7319893232403309568	2025-12-31 09:34:09.044
309dd80d-9dbd-43f7-9a2d-34c1886282d9	7331901884593825792	9999999999999999999	2025-12-31 09:34:10.453
06e1ab11-62f9-461c-bc56-12fb1117eee4	7331901888867821568	7319893232403309568	2025-12-31 09:34:11.504
86a410be-e846-482d-99b9-2b971729f1c0	7331901913521940480	9999999999999999999	2025-12-31 09:34:17.383
49f90f39-3162-4f31-973c-9c82362c20f4	7331901917833684992	7319893232403309568	2025-12-31 09:34:18.432
65ff962c-f0e4-4aa4-8719-0952605c1a5c	7331901935890163712	9999999999999999999	2025-12-31 09:34:22.683
f493f099-13e7-4d5b-9fdf-f6eb25dbc386	7331901940155770880	7319893232403309568	2025-12-31 09:34:23.706
b94d67a5-b8a9-4bbe-8a72-1bfb345c432c	7331901981121538048	9999999999999999999	2025-12-31 09:34:33.501
6908491f-59f2-41c0-8e5b-e68b12031fdc	7331901985399728128	7319893232403309568	2025-12-31 09:34:34.496
94e69967-e175-4fc5-aa65-c99f14864b90	7331902059714406400	9999999999999999999	2025-12-31 09:34:52.238
9095d28c-7390-403c-805c-3b940d6b8c0d	7331902063984207872	7319893232403309568	2025-12-31 09:34:53.285
1062a7e4-df2e-4064-9bf7-6a91b8b31d62	7331902546820645888	9999999999999999999	2025-12-31 09:36:48.388
c15101e9-23c4-4aaf-a850-bed5553de263	7331902551119807488	7319893232403309568	2025-12-31 09:36:49.406
d5eea050-032e-40d5-96fa-36714b29b1c0	7331902661572609024	9999999999999999999	2025-12-31 09:37:15.731
de5ff25e-bb04-4d51-a42b-d1f7553bd8aa	7331902665997599744	9999999999999999999	2025-12-31 09:37:16.753
f184d5dc-e83c-4a6c-b96e-8b77f6a0cfb2	7331902669646644224	9999999999999999999	2025-12-31 09:37:17.623
43e86e43-f72f-44fc-a7af-e4c8c53581a2	7331902673480238080	9999999999999999999	2025-12-31 09:37:18.54
afe4603d-4df0-496e-81d9-4f156e51563d	7331902679704585216	9999999999999999999	2025-12-31 09:37:20.022
6a28652a-7350-4527-bfb3-202ed5e75966	7331902782754440192	9999999999999999999	2025-12-31 09:37:44.623
744a4c01-171f-4e5b-801f-6571e9de32cb	7331902787028435968	7319893232403309568	2025-12-31 09:37:45.62
d65c159b-24a1-4bfa-aa43-1a5e0b88c1a3	7331903909189305344	9999999999999999999	2025-12-31 09:42:13.201
a32fd1d8-b9cd-4505-9d97-b643dd535ba7	7331903913471689728	7319893232403309568	2025-12-31 09:42:16.156
e76ce371-4daf-4595-80ed-fb9815a676c9	7332991225382350848	9999999999999999999	2026-01-03 09:42:49.578
6b69908b-b28b-465f-ba25-024a64e601f3	7332991229673123840	7319893232403309568	2026-01-03 09:42:50.571
3b80c99f-79dc-4d4d-afff-65e367fca16f	7332991240410542080	9999999999999999999	2026-01-03 09:42:53.119
32357670-0b3b-4d41-9610-f3d51efa93b7	7332991244671954944	7319893232403309568	2026-01-03 09:42:54.142
0a515e9a-d049-42dc-8bb7-18132cc7b051	7331775573012224000	7326530218858752000	2026-01-03 15:24:46.553
4218e7a9-c84f-4ddb-92b6-3d30182e7be9	7333077225891319808	7326530218858752000	2026-01-03 15:24:46.553
e91d596d-af12-4c00-b84a-d0b8ee7dcb1c	7333077310922444800	7319893232403309568	2026-01-03 15:24:53.937
c7567c4a-64ca-4ec9-a10c-336db1740578	7333077319713705984	7319893232403309568	2026-01-03 15:24:56.03
fa780d5e-a954-49cf-bbb1-8f4a391cf8da	7333077323991896064	7319893232403309568	2026-01-03 15:24:57.05
bb827648-a059-4469-bf99-9f271564ff90	7333077328182005760	7319893232403309568	2026-01-03 15:24:58.05
366f1355-fa98-4aaf-b9e7-0f89b0b6d2b4	7333077331755552768	7319893232403309568	2026-01-03 15:24:58.903
1d35b10a-0d56-463b-88b0-5e7acde97c45	7333077335085830144	7319893232403309568	2026-01-03 15:24:59.697
ad642184-deda-4321-8c39-00a5849bc959	7333077344070029312	7319893232403309568	2026-01-03 15:25:01.84
500ed370-76b9-45fe-b9de-62f3801fe74b	7333077530485870592	7319893232403309568	2026-01-03 15:25:46.285
aa5df86c-98e6-49f8-bb05-0960f5866d5e	7333077526220263424	9999999999999999999	2026-01-03 15:25:49.295
7df37ed4-7bba-40be-ae3a-dd7d4fb719fd	7333285733253183488	9999999999999999999	2026-01-04 05:13:05.717
59b12ed1-4078-4500-b6cb-258f3f201996	7333285737535567872	7319893232403309568	2026-01-04 05:13:06.71
2c94d616-8150-4b9d-bc73-36f7fb7241be	7333963407105677312	9999999999999999999	2026-01-06 02:05:55.765
f74fc372-517e-43b1-be1e-4881fc70258f	7333963411430004736	7320276851855168512	2026-01-06 02:05:56.772
c7d4019e-8b5a-4bef-946a-d301af6269b1	7333963460553693184	9999999999999999999	2026-01-06 02:06:08.494
40500aab-b3ec-4ea5-ba92-bc6540d7dbb0	7333963464831883264	7320276851855168512	2026-01-06 02:06:09.985
3e1f2fd3-a1a3-41d8-af19-d35bb1c116ef	7333963512424650752	9999999999999999999	2026-01-06 02:06:20.863
eb18e20a-9500-4aa1-8a65-a6b5cdda113c	7333963516711229440	7320276851855168512	2026-01-06 02:06:21.875
6da1fe30-36a5-4aa5-be0a-4b4388f5da29	7331789812719997952	7320276851855168512	2026-01-06 02:06:45.79
c7e65964-ed60-4e6e-83b4-a30f7b0db24e	7331790264803054592	7320276851855168512	2026-01-06 02:06:45.79
861fe843-4b0d-4209-a31f-30677b456870	7331789869414405120	7320276851855168512	2026-01-06 02:06:45.798
30895024-db1d-477a-8e13-4899b48764de	7331790929705096192	7320276851855168512	2026-01-06 02:06:45.804
75d1cf17-b822-4481-b056-e4094729258d	7331790943810540544	7320276851855168512	2026-01-06 02:06:45.817
7ee906c3-51d6-405e-b931-2e50173e4ca2	7333437587117908992	7320276851855168512	2026-01-06 02:06:45.821
\.


--
-- Data for Name: Messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Messages" (id, chat_id, sender_id, content, created_at, modified_at) FROM stdin;
7331094329323840512	7331094207852602368	7319893232403309568	test	2025-12-29 04:05:14.257	2025-12-29 04:05:14.257
7331094356901389312	7331094207852602368	7319893232403309568	téhudbhubdisbd	2025-12-29 04:05:20.832	2025-12-29 04:05:20.832
7331094500073956352	7331094207852602368	7320276851855168512	kkk	2025-12-29 04:05:54.967	2025-12-29 04:05:54.967
7331094514619802624	7331094207852602368	7319893232403309568	sd uabfubdof	2025-12-29 04:05:58.435	2025-12-29 04:05:58.435
7331094520894481408	7331094207852602368	7319893232403309568	knfkldanfjlndFLKNdklfn	2025-12-29 04:05:59.931	2025-12-29 04:05:59.931
7331094526741341184	7331094207852602368	7319893232403309568	lkndajlfnjldnflkdnflkdnf	2025-12-29 04:06:01.325	2025-12-29 04:06:01.325
7331094560673260544	7331094207852602368	7319893232403309568	❤️❤️❤️❤️	2025-12-29 04:06:09.415	2025-12-29 04:06:09.415
7331115000755064832	7331094207852602368	7319893232403309568	dfiif	2025-12-29 05:27:22.712	2025-12-29 05:27:22.712
7331115058804232192	7331094207852602368	7319893232403309568	dsifhiodfhid	2025-12-29 05:27:36.551	2025-12-29 05:27:36.551
7331115240908328960	7331094207852602368	7319893232403309568	ss0adjisjd	2025-12-29 05:28:19.968	2025-12-29 05:28:19.968
7331115930113799168	7331094207852602368	7319893232403309568	sơdkolfd	2025-12-29 05:31:04.287	2025-12-29 05:31:04.287
7331116009641997312	7331094207852602368	7319893232403309568	xấ;s'	2025-12-29 05:31:23.248	2025-12-29 05:31:23.248
7331117121284375552	7331094207852602368	7319893232403309568	l,dm,sld	2025-12-29 05:35:48.284	2025-12-29 05:35:48.284
7331117370933543936	7331094207852602368	7320276851855168512	gay	2025-12-29 05:36:47.805	2025-12-29 05:36:47.805
7331118476774376448	7331094207852602368	7320276851855168512	gay	2025-12-29 05:41:11.458	2025-12-29 05:41:11.458
7331118520332223488	7331094207852602368	7319893232403309568	sfnjdbfjdf	2025-12-29 05:41:21.843	2025-12-29 05:41:21.843
7331118664746304512	7331094207852602368	7320276851855168512	gay	2025-12-29 05:41:56.274	2025-12-29 05:41:56.274
7331118755431351296	7331094207852602368	7320276851855168512	peter	2025-12-29 05:42:17.895	2025-12-29 05:42:17.895
7331118800335569920	7331094207852602368	7320276851855168512	👌	2025-12-29 05:42:28.601	2025-12-29 05:42:28.601
7331119236211835904	7331094207852602368	7320276851855168512	dsdsadas	2025-12-29 05:44:12.522	2025-12-29 05:44:12.522
7331119289802458112	7331094207852602368	7319893232403309568	cjsbfduobfubfuf	2025-12-29 05:44:25.299	2025-12-29 05:44:25.299
7331119306399319040	7331094207852602368	7320276851855168512	dsasda	2025-12-29 05:44:29.256	2025-12-29 05:44:29.256
7331119919396848640	7331094207852602368	7319893232403309568	sdiosndid	2025-12-29 05:46:55.406	2025-12-29 05:46:55.406
7331120598530788352	7331094207852602368	7319893232403309568	ssss	2025-12-29 05:49:37.324	2025-12-29 05:49:37.324
7331120961018460160	7331094207852602368	7319893232403309568	sss	2025-12-29 05:51:03.748	2025-12-29 05:51:03.748
7331122312804133888	7331094207852602368	7320276851855168512	j	2025-12-29 05:56:26.039	2025-12-29 05:56:26.039
7331128128498035712	7331128090820602880	7331127480238992384	gay	2025-12-29 06:19:32.608	2025-12-29 06:19:32.608
7331128145212337152	7331128090820602880	7331127480238992384	?>	2025-12-29 06:19:36.593	2025-12-29 06:19:36.593
7331128166716533760	7331128090820602880	7331127480238992384	..	2025-12-29 06:19:41.72	2025-12-29 06:19:41.72
7331131028364323840	7331130830523198464	7331130523177184256	ssss	2025-12-29 06:31:03.99	2025-12-29 06:31:03.99
7331142263686083584	7331130830523198464	7331130523177184256	heihjughdaoufghduof	2025-12-29 07:15:42.7	2025-12-29 07:15:42.7
7331142289040651264	7331130830523198464	7331130523177184256	sdknsdnisldnlsd	2025-12-29 07:15:48.745	2025-12-29 07:15:48.745
7331142984418479104	7331130830523198464	7331130523177184256	dklsndjlsd	2025-12-29 07:18:34.536	2025-12-29 07:18:34.536
7331143925175700480	7331128090820602880	7331127480238992384	gay	2025-12-29 07:22:18.829	2025-12-29 07:22:18.829
7331143964774124544	7331128090820602880	7319893232403309568	gayyyyyyyyyy	2025-12-29 07:22:28.271	2025-12-29 07:22:28.271
7331157839902329856	7331157766770445312	7331157438012509184	🫶🏻	2025-12-29 08:17:36.359	2025-12-29 08:17:36.359
7331157861490412544	7331157766770445312	7319893232403309568	hé nhooooo	2025-12-29 08:17:41.506	2025-12-29 08:17:41.506
7331157928544750592	7331157766770445312	7331157438012509184	a nhonnnnnnn	2025-12-29 08:17:57.492	2025-12-29 08:17:57.492
7331159306539872256	7331157766770445312	7319893232403309568	❤️❤️❤️	2025-12-29 08:23:26.033	2025-12-29 08:23:26.033
7331159828168683520	7331130830523198464	7331130523177184256	podjsod	2025-12-29 08:25:30.399	2025-12-29 08:25:30.399
7331159867414786048	7331130830523198464	7331130523177184256	dddddddddddd	2025-12-29 08:25:39.756	2025-12-29 08:25:39.756
7331163575456346112	7331130830523198464	7331130523177184256	SDdSDSsdfdsdsd	2025-12-29 08:40:23.821	2025-12-29 08:40:23.821
7331163598831202304	7331130830523198464	7331130523177184256	SDSAD	2025-12-29 08:40:29.395	2025-12-29 08:40:29.395
7331164343177555968	7331130830523198464	7319893232403309568	sdsd	2025-12-29 08:43:26.861	2025-12-29 08:43:26.861
7331164373707894784	7331130830523198464	7319893232403309568	éQƯEWEWEWEWE	2025-12-29 08:43:34.14	2025-12-29 08:43:34.14
7331164383950385152	7331130830523198464	7319893232403309568	DFDSF	2025-12-29 08:43:36.581	2025-12-29 08:43:36.581
7331166234779299840	7331130830523198464	7319893232403309568	sdbjshd	2025-12-29 08:50:57.854	2025-12-29 08:50:57.854
7331166239376257024	7331130830523198464	7319893232403309568	nfklndklfnd	2025-12-29 08:50:58.95	2025-12-29 08:50:58.95
7331166288697077760	7331130830523198464	7331130523177184256	d;dndsknd	2025-12-29 08:51:10.709	2025-12-29 08:51:10.709
7331166686942048256	7331130830523198464	7319893232403309568	sss	2025-12-29 08:52:45.658	2025-12-29 08:52:45.658
7331166692591775744	7331130830523198464	7319893232403309568	ss	2025-12-29 08:52:47.005	2025-12-29 08:52:47.005
7331166699621429248	7331130830523198464	7319893232403309568	sjidjiosdh	2025-12-29 08:52:48.68	2025-12-29 08:52:48.68
7331170054691336192	7331130830523198464	7331130523177184256	hbhhgj gh	2025-12-29 09:06:08.592	2025-12-29 09:06:08.592
7331170065898516480	7331130830523198464	7319893232403309568	iuhuhu	2025-12-29 09:06:11.264	2025-12-29 09:06:11.264
7331170083141300224	7331130830523198464	7331130523177184256	f76ft7ft\\\\	2025-12-29 09:06:15.375	2025-12-29 09:06:15.375
7331170156046692352	7331094207852602368	7319893232403309568	baka béo thúi	2025-12-29 09:06:32.757	2025-12-29 09:06:32.757
7331170236476665856	7331094207852602368	7319893232403309568	chào cậu	2025-12-29 09:06:51.933	2025-12-29 09:06:51.933
7331190355709898752	7331094207852602368	7319893232403309568	Hi	2025-12-29 10:26:48.732	2025-12-29 10:26:48.732
7331222011699245056	7331157766770445312	7319893232403309568	Héeeee nhooooo	2025-12-29 12:32:36.108	2025-12-29 12:32:36.108
7331240098216377344	7331240024094637056	7319893232403309568	adfdfd	2025-12-29 13:44:28.269	2025-12-29 13:44:28.269
7331240161030274048	7331240024094637056	7331239930557463552	sdSDSDSDSD	2025-12-29 13:44:43.246	2025-12-29 13:44:43.246
7331240174674344960	7331240024094637056	7331239930557463552	OK	2025-12-29 13:44:46.499	2025-12-29 13:44:46.499
7331240193171225600	7331240024094637056	7331239930557463552	dsdsdsds	2025-12-29 13:44:50.909	2025-12-29 13:44:50.909
7331242968659354624	7331130830523198464	7319893232403309568	fdf	2025-12-29 13:55:52.637	2025-12-29 13:55:52.637
7331243776105093120	7331240024094637056	7331239930557463552	fdfdaf	2025-12-29 13:59:05.147	2025-12-29 13:59:05.147
7331243837518092288	7331240024094637056	7319893232403309568	dSDSD	2025-12-29 13:59:19.789	2025-12-29 13:59:19.789
7331244490600585216	7331240024094637056	7319893232403309568	rrer\\	2025-12-29 14:01:55.496	2025-12-29 14:01:55.496
7331244497122727936	7331240024094637056	7319893232403309568	dfdf	2025-12-29 14:01:57.051	2025-12-29 14:01:57.051
7331244515284064256	7331240024094637056	7319893232403309568	sdsdsd	2025-12-29 14:02:01.381	2025-12-29 14:02:01.381
7331244531767678976	7331240024094637056	7319893232403309568	fdsfdfgjl	2025-12-29 14:02:05.311	2025-12-29 14:02:05.311
7331244537513875456	7331240024094637056	7319893232403309568	fksdnfojdfg	2025-12-29 14:02:06.681	2025-12-29 14:02:06.681
7331244556467935232	7331240024094637056	7319893232403309568	dfadf	2025-12-29 14:02:11.2	2025-12-29 14:02:11.2
7331244568941795328	7331240024094637056	7319893232403309568	dfdfdfdf	2025-12-29 14:02:14.174	2025-12-29 14:02:14.174
7331245791994426368	7331240024094637056	7331239930557463552	FKSGNMKFLG	2025-12-29 14:07:05.772	2025-12-29 14:07:05.772
7331245812634596352	7331240024094637056	7331239930557463552	'FDL'DFL'DFL'DFL'DFL	2025-12-29 14:07:10.692	2025-12-29 14:07:10.692
7331245824999404544	7331240024094637056	7319893232403309568	FALFKJ;KDFJK	2025-12-29 14:07:13.641	2025-12-29 14:07:13.641
7331246619270558720	7331240024094637056	7331239930557463552	fdafdf	2025-12-29 14:10:23.01	2025-12-29 14:10:23.01
7331247095605081088	7331240024094637056	7331239930557463552	fsadfd	2025-12-29 14:12:16.577	2025-12-29 14:12:16.577
7331247110410974208	7331240024094637056	7331239930557463552	sDSDSDSD	2025-12-29 14:12:20.107	2025-12-29 14:12:20.107
7331248382941836288	7331240024094637056	7319893232403309568	dsdsd	2025-12-29 14:17:23.502	2025-12-29 14:17:23.502
7331248406794843136	7331240024094637056	7319893232403309568	sdsd	2025-12-29 14:17:29.189	2025-12-29 14:17:29.189
7331249095650554880	7331240024094637056	7331239930557463552	jkljfkljdfkdf	2025-12-29 14:20:13.425	2025-12-29 14:20:13.425
7331249124905825280	7331240024094637056	7331239930557463552	dfafidjfihjdf	2025-12-29 14:20:20.4	2025-12-29 14:20:20.4
7331249152403682304	7331240024094637056	7331239930557463552	ssđ	2025-12-29 14:20:26.955	2025-12-29 14:20:26.955
7331250366201705472	7331157766770445312	7319893232403309568	Hé nhooo	2025-12-29 14:25:16.348	2025-12-29 14:25:16.348
7331250650596488192	7331157766770445312	7331157438012509184	héee nhoooo	2025-12-29 14:26:24.153	2025-12-29 14:26:24.153
7331250681365902336	7331157766770445312	7319893232403309568	Héee nhoooo	2025-12-29 14:26:31.489	2025-12-29 14:26:31.489
7331250820230919168	7331157766770445312	7331157438012509184	aiu có iuu em hongg	2025-12-29 14:27:04.597	2025-12-29 14:27:04.597
7331252870587069440	7331252814869935104	7326530218858752000	dmsjodhjsd	2025-12-29 14:35:13.44	2025-12-29 14:35:13.44
7331252956092150784	7331252814869935104	7319893232403309568	fdfasdfdfdf	2025-12-29 14:35:33.826	2025-12-29 14:35:33.826
7331252968012362752	7331252814869935104	7319893232403309568	sdsdfoujihhfuidhbfjkd	2025-12-29 14:35:36.668	2025-12-29 14:35:36.668
7331253005916288000	7331252814869935104	7319893232403309568	sdSKDJSKD	2025-12-29 14:35:45.705	2025-12-29 14:35:45.705
7331253011150779392	7331252814869935104	7319893232403309568	SIPDKSNMDK	2025-12-29 14:35:46.953	2025-12-29 14:35:46.953
7331253847742460928	7331252814869935104	7326530218858752000	dfhufhd]\\	2025-12-29 14:39:06.412	2025-12-29 14:39:06.412
7331253869204714496	7331252814869935104	7326530218858752000	dfdfdf	2025-12-29 14:39:11.529	2025-12-29 14:39:11.529
7331253891002512384	7331252814869935104	7326530218858752000	sdsđ	2025-12-29 14:39:16.726	2025-12-29 14:39:16.726
7331253908840887296	7331252814869935104	7326530218858752000	dsdsuifdghufd	2025-12-29 14:39:20.978	2025-12-29 14:39:20.978
7331254995555693568	7331252814869935104	7326530218858752000	dsđ	2025-12-29 14:43:40.072	2025-12-29 14:43:40.072
7331255377732285440	7331252814869935104	7326530218858752000	dd	2025-12-29 14:45:11.189	2025-12-29 14:45:11.189
7331255611774448640	7331252814869935104	7326530218858752000	document.getElementById("newMessageSound").play();	2025-12-29 14:46:06.99	2025-12-29 14:46:06.99
7331255751851619328	7331252814869935104	7326530218858752000	dsdsd	2025-12-29 14:46:40.387	2025-12-29 14:46:40.387
7331256711571289088	7331130830523198464	7319893232403309568	fdsdfifjifd	2025-12-29 14:50:29.202	2025-12-29 14:50:29.202
7331256729095091200	7331252814869935104	7319893232403309568	dffdff	2025-12-29 14:50:33.38	2025-12-29 14:50:33.38
7331256745440293888	7331252814869935104	7326530218858752000	dsdsđ	2025-12-29 14:50:37.277	2025-12-29 14:50:37.277
7331256812855342080	7331252814869935104	7326530218858752000	dsdsdd	2025-12-29 14:50:53.35	2025-12-29 14:50:53.35
7331256820614804480	7331252814869935104	7326530218858752000	ghgg	2025-12-29 14:50:55.199	2025-12-29 14:50:55.199
7331256824817497088	7331252814869935104	7326530218858752000	gfg	2025-12-29 14:50:56.202	2025-12-29 14:50:56.202
7331256828911137792	7331252814869935104	7326530218858752000	gfgg	2025-12-29 14:50:57.178	2025-12-29 14:50:57.178
7331258066597751808	7331130830523198464	7319893232403309568	ssss	2025-12-29 14:55:52.266	2025-12-29 14:55:52.266
7331258099921497088	7331252814869935104	7319893232403309568	sssss	2025-12-29 14:56:00.211	2025-12-29 14:56:00.211
7331258222965599232	7331252814869935104	7319893232403309568	sss	2025-12-29 14:56:29.547	2025-12-29 14:56:29.547
7331258715133619200	7331252814869935104	7319893232403309568	fdokf	2025-12-29 14:58:26.889	2025-12-29 14:58:26.889
7331259338071649280	7331252814869935104	7326530218858752000	fff	2025-12-29 15:00:55.409	2025-12-29 15:00:55.409
7331259384716504064	7331252814869935104	7326530218858752000	dddd	2025-12-29 15:01:06.529	2025-12-29 15:01:06.529
7331259486520650752	7331252814869935104	7319893232403309568	dđ	2025-12-29 15:01:30.802	2025-12-29 15:01:30.802
7331259524227443712	7331252814869935104	7319893232403309568	ddddd	2025-12-29 15:01:39.792	2025-12-29 15:01:39.792
7331259552270560256	7331252814869935104	7319893232403309568	dddddd	2025-12-29 15:01:46.478	2025-12-29 15:01:46.478
7331385609694915584	7331252814869935104	7326530218858752000	dd	2025-12-29 23:22:40.91	2025-12-29 23:22:40.91
7331385700983942144	7331252814869935104	7326530218858752000	dfdfdf	2025-12-29 23:23:02.675	2025-12-29 23:23:02.675
7331385708768570368	7331252814869935104	7326530218858752000	df'df;lf	2025-12-29 23:23:04.531	2025-12-29 23:23:04.531
7331385711767497728	7331252814869935104	7326530218858752000	f	2025-12-29 23:23:05.246	2025-12-29 23:23:05.246
7331385713910787072	7331252814869935104	7326530218858752000	dl;fd	2025-12-29 23:23:05.757	2025-12-29 23:23:05.757
7331385719313050624	7331252814869935104	7326530218858752000	f	2025-12-29 23:23:07.045	2025-12-29 23:23:07.045
7331385728569879552	7331252814869935104	7326530218858752000	ffffffff	2025-12-29 23:23:09.251	2025-12-29 23:23:09.251
7331385740594949120	7331252814869935104	7326530218858752000	fdfdf	2025-12-29 23:23:12.119	2025-12-29 23:23:12.119
7331385811579350016	7331252814869935104	7326530218858752000	dfhjdjhf	2025-12-29 23:23:29.043	2025-12-29 23:23:29.043
7331386026608733184	7331385986762845184	7326530218858752000	dsdsd	2025-12-29 23:24:20.31	2025-12-29 23:24:20.31
7331393676587215872	7331130830523198464	7331130523177184256	ftvgutv	2025-12-29 23:54:44.207	2025-12-29 23:54:44.207
7331393710431054848	7331130830523198464	7331130523177184256	oiuhuohuj	2025-12-29 23:54:52.276	2025-12-29 23:54:52.276
7331393729531915264	7331130830523198464	7331130523177184256	nuobu	2025-12-29 23:54:56.83	2025-12-29 23:54:56.83
7331394009438792704	7331130830523198464	7319893232403309568	buhbhkv	2025-12-29 23:56:03.564	2025-12-29 23:56:03.564
7331429933933571072	7331130830523198464	7331130523177184256	skjdiohds	2025-12-30 02:18:48.632	2025-12-30 02:18:48.632
7331429948341005312	7331130830523198464	7331130523177184256	sass	2025-12-30 02:18:52.067	2025-12-30 02:18:52.067
7331429998039313408	7331130830523198464	7319893232403309568	smksajas	2025-12-30 02:19:03.916	2025-12-30 02:19:03.916
7331430027437190144	7331130830523198464	7319893232403309568	saoishi	2025-12-30 02:19:10.925	2025-12-30 02:19:10.925
7331430259977792512	7331157766770445312	7319893232403309568	Anhhhh yeuuuuu emmmmmmm <333	2025-12-30 02:20:06.367	2025-12-30 02:20:06.367
7331578902076632064	7331578834649000960	7319893232403309568	Hi	2025-12-30 12:10:45.405	2025-12-30 12:10:45.405
7331578943201782784	7331578834649000960	7331578479903157248	Hi	2025-12-30 12:10:55.21	2025-12-30 12:10:55.21
7331579087037049856	7331578834649000960	7331578479903157248	Hi	2025-12-30 12:11:29.503	2025-12-30 12:11:29.503
7331579797208214528	7331578834649000960	7331578479903157248	:)))	2025-12-30 12:14:18.821	2025-12-30 12:14:18.821
7331765873638026240	7331094207852602368	7320276851855168512	hi	2025-12-31 00:33:42.898	2025-12-31 00:33:42.898
7331766004936518656	7331431806161824768	7320276851855168512	Xin chào Tổng Công Ty May Đồng Nai (Donagamex)! Tôi muốn liên hệ với công ty của bạn.	2025-12-31 00:34:14.203	2025-12-31 00:34:14.203
7331766574514613248	7331094207852602368	7319893232403309568	Xin chào Công ty CP Xi măng Vicem Sông Gianh! Tôi muốn liên hệ với công ty của bạn.	2025-12-31 00:36:30	2025-12-31 00:36:30
7331766692299058176	7331431806161824768	7320276851855168512	Xin chào Tổng Công Ty May Đồng Nai (Donagamex)! Tôi muốn liên hệ với công ty của bạn.	2025-12-31 00:36:58.083	2025-12-31 00:36:58.083
7331767053906783232	7331094207852602368	7319893232403309568	Xin chào Công ty CP Xi măng Vicem Sông Gianh! Tôi muốn liên hệ với công ty của bạn.	2025-12-31 00:38:24.297	2025-12-31 00:38:24.297
7331767261680020480	7331094207852602368	7319893232403309568	Xin chào Công ty CP Xi măng Vicem Sông Gianh! Tôi muốn liên hệ với công ty của bạn.	2025-12-31 00:39:13.834	2025-12-31 00:39:13.834
7331767289031076864	7331094207852602368	7319893232403309568	Xin chào Công ty CP Xi măng Vicem Sông Gianh! Tôi muốn liên hệ với công ty của bạn.	2025-12-31 00:39:20.355	2025-12-31 00:39:20.355
7331771113532878848	7331094207852602368	7320276851855168512	...	2025-12-31 00:54:32.187	2025-12-31 00:54:32.187
7331771870902546432	7331094207852602368	7320276851855168512	hi	2025-12-31 00:57:32.758	2025-12-31 00:57:32.758
7331771922748338176	7331094207852602368	7320276851855168512	hi	2025-12-31 00:57:45.119	2025-12-31 00:57:45.119
7331772420410896384	7331094207852602368	7320276851855168512	hi	2025-12-31 00:59:43.771	2025-12-31 00:59:43.771
7331772435426504704	7331094207852602368	7320276851855168512	ff	2025-12-31 00:59:47.351	2025-12-31 00:59:47.351
7331772504787709952	7331094207852602368	7320276851855168512	ff	2025-12-31 01:00:03.888	2025-12-31 01:00:03.888
7331772529194364928	7331094207852602368	7320276851855168512	alo	2025-12-31 01:00:09.707	2025-12-31 01:00:09.707
7331772544298053632	7331094207852602368	7320276851855168512	alo'ss	2025-12-31 01:00:13.308	2025-12-31 01:00:13.308
7331772549708705792	7331094207852602368	7320276851855168512	ss	2025-12-31 01:00:14.598	2025-12-31 01:00:14.598
7331772554754453504	7331094207852602368	7320276851855168512	ss	2025-12-31 01:00:15.801	2025-12-31 01:00:15.801
7331772813878554624	7331094207852602368	7320276851855168512	khjk,	2025-12-31 01:01:17.581	2025-12-31 01:01:17.581
7331772833612754944	7331094207852602368	7320276851855168512	kk	2025-12-31 01:01:22.286	2025-12-31 01:01:22.286
7331772838897577984	7331094207852602368	7320276851855168512	kk	2025-12-31 01:01:23.546	2025-12-31 01:01:23.546
7331772909336719360	7331094207852602368	7320276851855168512	kokokoko	2025-12-31 01:01:40.339	2025-12-31 01:01:40.339
7331772913006735360	7331094207852602368	7320276851855168512	koko	2025-12-31 01:01:41.215	2025-12-31 01:01:41.215
7331772991096287232	7331094207852602368	7320276851855168512	,,mm	2025-12-31 01:01:59.832	2025-12-31 01:01:59.832
7331773018921299968	7331094207852602368	7320276851855168512	mm	2025-12-31 01:02:06.467	2025-12-31 01:02:06.467
7331773021689540608	7331094207852602368	7320276851855168512	mm	2025-12-31 01:02:07.127	2025-12-31 01:02:07.127
7331773340527947776	7331094207852602368	7319893232403309568	Xin chào Công ty Cao su Điện Biên! Tôi muốn liên hệ với công ty của bạn.	2025-12-31 01:03:23.144	2025-12-31 01:03:23.144
7331773367421825024	7331094207852602368	7320276851855168512	chào	2025-12-31 01:03:29.556	2025-12-31 01:03:29.556
7331773380596133888	7331094207852602368	7319893232403309568	ok	2025-12-31 01:03:32.697	2025-12-31 01:03:32.697
7331773416126083072	7331094207852602368	7320276851855168512	mm	2025-12-31 01:03:41.168	2025-12-31 01:03:41.168
7331773532115365888	7331094207852602368	7319893232403309568	Xin chào Công ty Cổ phần Đường Quảng Ngãi! Tôi muốn liên hệ với công ty của bạn.	2025-12-31 01:04:08.822	2025-12-31 01:04:08.822
7331774803763556352	7331774791259851776	7320276851855168512	hi	2025-12-31 01:09:12.007	2025-12-31 01:09:12.007
7331774815474053120	7331774791259851776	7320276851855168512	hi	2025-12-31 01:09:14.798	2025-12-31 01:09:14.798
7331774831605346304	7331774791259851776	7320276851855168512	bn ghmgfhmf	2025-12-31 01:09:18.644	2025-12-31 01:09:18.644
7331774851280826368	7331094207852602368	7320276851855168512	dsa	2025-12-31 01:09:23.335	2025-12-31 01:09:23.335
7331775573012224000	7331252814869935104	7319893232403309568	sss	2025-12-31 01:12:15.41	2025-12-31 01:12:15.41
7331776777047564288	7331774791259851776	7320276851855168512	hi	2025-12-31 01:17:02.474	2025-12-31 01:17:02.474
7331776894849789952	7331776872867442688	7320276851855168512	alo	2025-12-31 01:17:30.56	2025-12-31 01:17:30.56
7331778233728263168	7331776872867442688	7320276851855168512	wow]]	2025-12-31 01:22:49.774	2025-12-31 01:22:49.774
7331778428933966848	7331776872867442688	7320276851855168512	dc	2025-12-31 01:23:36.314	2025-12-31 01:23:36.314
7331778433962937344	7331776872867442688	7320276851855168512	dc	2025-12-31 01:23:37.514	2025-12-31 01:23:37.514
7331778451105057792	7331776872867442688	7320276851855168512	dc	2025-12-31 01:23:41.6	2025-12-31 01:23:41.6
7331778451188943872	7331776872867442688	7320276851855168512	dc	2025-12-31 01:23:41.62	2025-12-31 01:23:41.62
7331778469446749184	7331776872867442688	7320276851855168512	ss	2025-12-31 01:23:45.973	2025-12-31 01:23:45.973
7331778473192262656	7331776872867442688	7320276851855168512	ss	2025-12-31 01:23:46.866	2025-12-31 01:23:46.866
7331778821229676544	7331778810618087424	7319893232403309568	saksjihs	2025-12-31 01:25:09.845	2025-12-31 01:25:09.845
7331779092163473408	7331778810618087424	7319893232403309568	sss	2025-12-31 01:26:14.441	2025-12-31 01:26:14.441
7331779147122284544	7331778810618087424	7319893232403309568	ss;mskns	2025-12-31 01:26:27.545	2025-12-31 01:26:27.545
7331779168530012160	7331778810618087424	7319893232403309568	mđsđ	2025-12-31 01:26:32.648	2025-12-31 01:26:32.648
7331779615740479488	7331776872867442688	7320276851855168512	hi	2025-12-31 01:28:19.271	2025-12-31 01:28:19.271
7331779686150260736	7331776872867442688	7320276851855168512	/help	2025-12-31 01:28:36.058	2025-12-31 01:28:36.058
7331779779286367232	7331776872867442688	7320276851855168512	hi	2025-12-31 01:28:58.264	2025-12-31 01:28:58.264
7331779855513648128	7331776872867442688	7320276851855168512	hello	2025-12-31 01:29:16.438	2025-12-31 01:29:16.438
7331779871695272960	7331776872867442688	7320276851855168512	Hello	2025-12-31 01:29:20.296	2025-12-31 01:29:20.296
7331780192011932672	7331776872867442688	7320276851855168512	hi	2025-12-31 01:30:36.665	2025-12-31 01:30:36.665
7331780338906873856	7331776872867442688	7320276851855168512	wow	2025-12-31 01:31:11.687	2025-12-31 01:31:11.687
7331780355403071488	7331776872867442688	7320276851855168512	/hello	2025-12-31 01:31:15.619	2025-12-31 01:31:15.619
7331780361870688256	7331776872867442688	7320276851855168512	/help	2025-12-31 01:31:17.162	2025-12-31 01:31:17.162
7331780396452724736	7331776872867442688	7320276851855168512	hello	2025-12-31 01:31:25.407	2025-12-31 01:31:25.407
7331780469438516224	7331776872867442688	7320276851855168512	hello	2025-12-31 01:31:42.809	2025-12-31 01:31:42.809
7331780485095853056	7331776872867442688	7320276851855168512	/hello	2025-12-31 01:31:46.541	2025-12-31 01:31:46.541
7331780515517782016	7331776872867442688	7320276851855168512	hello	2025-12-31 01:31:53.795	2025-12-31 01:31:53.795
7331780544655611904	7331776872867442688	7320276851855168512	/hello	2025-12-31 01:32:00.742	2025-12-31 01:32:00.742
7331780554164099072	7331776872867442688	7320276851855168512	/help	2025-12-31 01:32:03.009	2025-12-31 01:32:03.009
7331780590620989440	7331776872867442688	7320276851855168512	hello	2025-12-31 01:32:11.701	2025-12-31 01:32:11.701
7331780682913420288	7331776872867442688	7320276851855168512	hello	2025-12-31 01:32:33.706	2025-12-31 01:32:33.706
7331780691239113728	7331776872867442688	7320276851855168512	gello	2025-12-31 01:32:35.69	2025-12-31 01:32:35.69
7331780721008399360	7331776872867442688	7320276851855168512	hello	2025-12-31 01:32:42.788	2025-12-31 01:32:42.788
7331780721285223424	7331776872867442688	9999999999999999999	Hello @khangfc162! How can I assist you today?	2025-12-31 01:32:42.854	2025-12-31 01:32:42.854
7331780735474553856	7331776872867442688	7320276851855168512	nothing	2025-12-31 01:32:46.237	2025-12-31 01:32:46.237
7331780749303174144	7331776872867442688	7320276851855168512	hello	2025-12-31 01:32:49.534	2025-12-31 01:32:49.534
7331780749500306432	7331776872867442688	9999999999999999999	Hello @khangfc162! How can I assist you today?	2025-12-31 01:32:49.581	2025-12-31 01:32:49.581
7331780761562969088	7331776872867442688	7320276851855168512	hello	2025-12-31 01:32:52.457	2025-12-31 01:32:52.457
7331780761814627328	7331776872867442688	9999999999999999999	Hello @khangfc162! How can I assist you today?	2025-12-31 01:32:52.517	2025-12-31 01:32:52.517
7331781343864354816	7331776872867442688	7320276851855168512	/help	2025-12-31 01:35:11.288	2025-12-31 01:35:11.288
7331781344099235840	7331776872867442688	9999999999999999999	Danh sách lệnh:\n/help – xem trợ giúp\n/hello – chào bot\n/company <id/mst> – thông tin công ty	2025-12-31 01:35:11.344	2025-12-31 01:35:11.344
7331781378266036224	7331776872867442688	7320276851855168512	/company	2025-12-31 01:35:19.49	2025-12-31 01:35:19.49
7331781378475751424	7331776872867442688	9999999999999999999	Vui lòng cung cấp ID hoặc Mã số thuế của công ty. Ví dụ: /company 123456789	2025-12-31 01:35:19.54	2025-12-31 01:35:19.54
7331781407076710400	7331776872867442688	7320276851855168512	/company 1122233	2025-12-31 01:35:26.359	2025-12-31 01:35:26.359
7331781407286425600	7331776872867442688	9999999999999999999	Không tìm thấy công ty với ID hoặc Mã số thuế đã cung cấp.	2025-12-31 01:35:26.409	2025-12-31 01:35:26.409
7331781517579843584	7331776872867442688	7320276851855168512	/company 7326774261535876096	2025-12-31 01:35:52.705	2025-12-31 01:35:52.705
7331781517772781568	7331776872867442688	9999999999999999999	Thông tin công ty:\nTên: Công ty Cao su Điện Biên\nMã số thuế: undefined\nĐịa chỉ: Thanh Xương, Điện Biên	2025-12-31 01:35:52.751	2025-12-31 01:35:52.751
7331781529596524544	7331776872867442688	7320276851855168512	wow	2025-12-31 01:35:55.57	2025-12-31 01:35:55.57
7331782007358074880	7331094207852602368	7319893232403309568	/company	2025-12-31 01:37:49.477	2025-12-31 01:37:49.477
7331782042116272128	7331778810618087424	7319893232403309568	/company	2025-12-31 01:37:57.764	2025-12-31 01:37:57.764
7331782458837151744	7331776872867442688	7320276851855168512	Xin chào Công ty TNHH Polytex Far Eastern! Tôi muốn liên hệ với công ty của bạn.	2025-12-31 01:39:37.118	2025-12-31 01:39:37.118
7331783120878678016	7331776872867442688	7320276851855168512	Xin chào Công ty TNHH Polytex Far Eastern! Tôi muốn liên hệ với công ty của bạn.	2025-12-31 01:42:14.961	2025-12-31 01:42:14.961
7331783209999249408	7331776872867442688	7320276851855168512	Xin chào Cao su Đồng Nai! Tôi muốn liên hệ với công ty của bạn.	2025-12-31 01:42:36.209	2025-12-31 01:42:36.209
7331783939644685312	7331778810618087424	7319893232403309568	/help	2025-12-31 01:45:30.17	2025-12-31 01:45:30.17
7331783939887954944	7331778810618087424	9999999999999999999	📌 Danh sách lệnh:\n-------------------------------------\n/help – Xem trợ giúp\n/company <id> – Thông tin công ty\n/recruit <company_id> – Danh sách tuyển dụng\n/delivery <company_id> – Danh sách giao hàng\n/scrape <company_id> – Danh sách phế liệu\n/mycompany – Công ty bạn sở hữu\n/myrecruit – Tin tuyển dụng bạn đã đăng\n-------------------------------------	2025-12-31 01:45:30.227	2025-12-31 01:45:30.227
7331783962193263616	7331778810618087424	7319893232403309568	/company	2025-12-31 01:45:35.546	2025-12-31 01:45:35.546
7331783962390395904	7331778810618087424	9999999999999999999	❗ Vui lòng cung cấp ID công ty.\nVí dụ: `/company 123456`	2025-12-31 01:45:35.593	2025-12-31 01:45:35.593
7331784082980830208	7331778810618087424	7319893232403309568	/mycompany	2025-12-31 01:46:04.343	2025-12-31 01:46:04.343
7331784083177962496	7331778810618087424	9999999999999999999	🏢 **Công ty của bạn**\nTên: Công ty TNHH Giải pháp Số Softlab\nMST: 7320053085020058624\nĐịa chỉ: 59 Đặng Đại Độ, Trấn Biên, Đồng Nai\n	2025-12-31 01:46:04.391	2025-12-31 01:46:04.391
7331784165193382912	7331776872867442688	7320276851855168512	/mycompany	2025-12-31 01:46:23.945	2025-12-31 01:46:23.945
7331784165398903808	7331776872867442688	9999999999999999999	🏢 **Công ty của bạn**\nTên: Tổng Công Ty May Đồng Nai (Donagamex)\nMST: 7326532791888095232\nĐịa chỉ: Đường số 2, KCN Biên Hòa 1, P. An Bình, Biên Hòa, Đồng Nai.\n	2025-12-31 01:46:23.994	2025-12-31 01:46:23.994
7331784191365839872	7331776872867442688	7320276851855168512	/mycompanyu	2025-12-31 01:46:30.185	2025-12-31 01:46:30.185
7331784191571360768	7331776872867442688	9999999999999999999	🏢 **Công ty của bạn**\nTên: Tổng Công Ty May Đồng Nai (Donagamex)\nMST: 7326532791888095232\nĐịa chỉ: Đường số 2, KCN Biên Hòa 1, P. An Bình, Biên Hòa, Đồng Nai.\n	2025-12-31 01:46:30.234	2025-12-31 01:46:30.234
7331784224186268672	7331776872867442688	7320276851855168512	/mycompany	2025-12-31 01:46:38.01	2025-12-31 01:46:38.01
7331784224387595264	7331776872867442688	9999999999999999999	🏢 **Công ty của bạn**\nTên: Tổng Công Ty May Đồng Nai (Donagamex)\nMST: 7326532791888095232\nĐịa chỉ: Đường số 2, KCN Biên Hòa 1, P. An Bình, Biên Hòa, Đồng Nai.\n	2025-12-31 01:46:38.058	2025-12-31 01:46:38.058
7331784262958414848	7331094207852602368	7320276851855168512	Vui lòng cung cấp ID hoặc Mã số thuế của công ty. Ví dụ: /company 123456789	2025-12-31 01:46:47.254	2025-12-31 01:46:47.254
7331784495575242752	7331778810618087424	7319893232403309568	hello	2025-12-31 01:47:42.715	2025-12-31 01:47:42.715
7331784531860166656	7331094207852602368	7319893232403309568	/hello	2025-12-31 01:47:51.364	2025-12-31 01:47:51.364
7331784541481900032	7331094207852602368	7319893232403309568	/help	2025-12-31 01:47:53.659	2025-12-31 01:47:53.659
7331784558955370496	7331778810618087424	7319893232403309568	/help	2025-12-31 01:47:57.825	2025-12-31 01:47:57.825
7331784561564227584	7331094207852602368	7320276851855168512	help	2025-12-31 01:47:58.447	2025-12-31 01:47:58.447
7331784576718247936	7331094207852602368	7320276851855168512	alo	2025-12-31 01:48:02.06	2025-12-31 01:48:02.06
7331784604413237248	7331094207852602368	7320276851855168512	alo	2025-12-31 01:48:08.663	2025-12-31 01:48:08.663
7331784609119246336	7331094207852602368	7320276851855168512	alo	2025-12-31 01:48:09.785	2025-12-31 01:48:09.785
7331784667747227648	7331778810618087424	7319893232403309568	/company	2025-12-31 01:48:23.762	2025-12-31 01:48:23.762
7331784759678342144	7331778810618087424	7319893232403309568	/company	2025-12-31 01:48:45.683	2025-12-31 01:48:45.683
7331784856400264192	7331778810618087424	7319893232403309568	/company	2025-12-31 01:49:08.742	2025-12-31 01:49:08.742
7331784904165694464	7331778810618087424	7319893232403309568	/company	2025-12-31 01:49:20.13	2025-12-31 01:49:20.13
7331784913741290496	7331778810618087424	7319893232403309568	/company	2025-12-31 01:49:22.413	2025-12-31 01:49:22.413
7331784927276309504	7331778810618087424	7319893232403309568	/help	2025-12-31 01:49:25.639	2025-12-31 01:49:25.639
7331784958327234560	7331778810618087424	7319893232403309568	/company	2025-12-31 01:49:33.043	2025-12-31 01:49:33.043
7331784990594015232	7331778810618087424	7319893232403309568	/company	2025-12-31 01:49:40.736	2025-12-31 01:49:40.736
7331785011745890304	7331778810618087424	7319893232403309568	sdpisdjids	2025-12-31 01:49:45.778	2025-12-31 01:49:45.778
7331785066804889600	7331778810618087424	7319893232403309568	ss	2025-12-31 01:49:58.906	2025-12-31 01:49:58.906
7331785110119467008	7331778810618087424	7319893232403309568	/help	2025-12-31 01:50:09.233	2025-12-31 01:50:09.233
7331785110354348032	7331778810618087424	9999999999999999999	Danh sách lệnh:\n/help – xem trợ giúp\n/hello – chào bot\n/company <id/mst> – thông tin công ty	2025-12-31 01:50:09.288	2025-12-31 01:50:09.288
7331785137562798080	7331778810618087424	7319893232403309568	/company ;osjdo	2025-12-31 01:50:15.776	2025-12-31 01:50:15.776
7331785137759930368	7331778810618087424	9999999999999999999	Không tìm thấy công ty với ID hoặc Mã số thuế đã cung cấp.	2025-12-31 01:50:15.823	2025-12-31 01:50:15.823
7331785201728723968	7331778810618087424	7319893232403309568	/company ;osjdo	2025-12-31 01:50:31.075	2025-12-31 01:50:31.075
7331785201984576512	7331778810618087424	9999999999999999999	Không tìm thấy công ty với ID hoặc Mã số thuế đã cung cấp.	2025-12-31 01:50:31.136	2025-12-31 01:50:31.136
7331785495249181696	7331778810618087424	7319893232403309568	/company s	2025-12-31 01:51:41.055	2025-12-31 01:51:41.055
7331785596639978496	7331778810618087424	7319893232403309568	/company s	2025-12-31 01:52:05.229	2025-12-31 01:52:05.229
7331785614075700224	7331778810618087424	7319893232403309568	/company s	2025-12-31 01:52:09.386	2025-12-31 01:52:09.386
7331785627677828096	7331778810618087424	7319893232403309568	/company s	2025-12-31 01:52:12.629	2025-12-31 01:52:12.629
7331785634933974016	7331778810618087424	7319893232403309568	/help	2025-12-31 01:52:14.358	2025-12-31 01:52:14.358
7331785692814332928	7331778810618087424	7319893232403309568	/company s	2025-12-31 01:52:28.158	2025-12-31 01:52:28.158
7331785744629997568	7331778810618087424	7319893232403309568	/company s	2025-12-31 01:52:40.512	2025-12-31 01:52:40.512
7331785747133997056	7331776872867442688	7320276851855168512	hello	2025-12-31 01:52:41.108	2025-12-31 01:52:41.108
7331785754524360704	7331778810618087424	7319893232403309568	dsmdijs	2025-12-31 01:52:42.871	2025-12-31 01:52:42.871
7331785754671161344	7331776872867442688	7320276851855168512	/hello	2025-12-31 01:52:42.906	2025-12-31 01:52:42.906
7331785759586885632	7331776872867442688	7320276851855168512	/help	2025-12-31 01:52:44.078	2025-12-31 01:52:44.078
7331785771729395712	7331094207852602368	7319893232403309568	skdnksd	2025-12-31 01:52:46.972	2025-12-31 01:52:46.972
7331785786057138176	7331778810618087424	7319893232403309568	dsnidh	2025-12-31 01:52:50.389	2025-12-31 01:52:50.389
7331785795871809536	7331778810618087424	7319893232403309568	/company s	2025-12-31 01:52:52.729	2025-12-31 01:52:52.729
7331785929605417984	7331778810618087424	7319893232403309568	/help	2025-12-31 01:53:24.614	2025-12-31 01:53:24.614
7331785929840299008	7331778810618087424	9999999999999999999	Danh sách lệnh:\n/help – xem trợ giúp\n/hello – chào bot\n/company <id/mst> – thông tin công ty	2025-12-31 01:53:24.67	2025-12-31 01:53:24.67
7331785946223250432	7331778810618087424	7319893232403309568	/company s	2025-12-31 01:53:28.576	2025-12-31 01:53:28.576
7331785946323913728	7331778810618087424	9999999999999999999	Đã xảy ra lỗi khi tìm kiếm công ty. Vui lòng thử lại sau.	2025-12-31 01:53:28.6	2025-12-31 01:53:28.6
7331785986656340992	7331776872867442688	7320276851855168512	/company s	2025-12-31 01:53:38.216	2025-12-31 01:53:38.216
7331785986857667584	7331776872867442688	9999999999999999999	Đã xảy ra lỗi khi tìm kiếm công ty. Vui lòng thử lại sau.	2025-12-31 01:53:38.264	2025-12-31 01:53:38.264
7331786072172636160	7331778810618087424	7319893232403309568	/company s	2025-12-31 01:53:58.605	2025-12-31 01:53:58.605
7331786072466237440	7331778810618087424	9999999999999999999	Đã xảy ra lỗi khi tìm kiếm công ty. Vui lòng thử lại sau.	2025-12-31 01:53:58.675	2025-12-31 01:53:58.675
7331786101369186304	7331778810618087424	7319893232403309568	/company s	2025-12-31 01:54:05.566	2025-12-31 01:54:05.566
7331786101595678720	7331778810618087424	9999999999999999999	Đã xảy ra lỗi khi tìm kiếm công ty. Vui lòng thử lại sau.	2025-12-31 01:54:05.62	2025-12-31 01:54:05.62
7331786115499796480	7331776872867442688	7320276851855168512	/company s	2025-12-31 01:54:08.935	2025-12-31 01:54:08.935
7331786115554322432	7331776872867442688	9999999999999999999	Đã xảy ra lỗi khi tìm kiếm công ty. Vui lòng thử lại sau.	2025-12-31 01:54:08.948	2025-12-31 01:54:08.948
7331786174067261440	7331778810618087424	7319893232403309568	/company s	2025-12-31 01:54:22.898	2025-12-31 01:54:22.898
7331786174314725376	7331778810618087424	9999999999999999999	Thông tin công ty:\nTên: dsa\nMã số thuế: undefined\nĐịa chỉ: Chưa cập nhật	2025-12-31 01:54:22.957	2025-12-31 01:54:22.957
7331786583609549824	7331778810618087424	7319893232403309568	/company s	2025-12-31 01:56:00.541	2025-12-31 01:56:00.541
7331786655543083008	7331778810618087424	7319893232403309568	/company s	2025-12-31 01:56:17.691	2025-12-31 01:56:17.691
7331786655807324160	7331778810618087424	9999999999999999999	🔍 Tìm thấy **5** công ty:\n\n**1. test**\n• ID: 7320052714910479360\n• MST: Chưa có\n• Địa chỉ: Chưa cập nhật\n\n**2. Công ty TNHH Giải pháp Số Softlab**\n• ID: 7320053085020058624\n• MST: Chưa có\n• Địa chỉ: 59 Đặng Đại Độ, Trấn Biên, Đồng Nai\n\n**3. jdbbuidbius**\n• ID: 7326511626757306368\n• MST: Chưa có\n• Địa chỉ: Chưa cập nhật\n\n**4. jdbbuidbius**\n• ID: 7326511647384893440\n• MST: Chưa có\n• Địa chỉ: Chưa cập nhật\n\n**5. ss**\n• ID: 7326511805996693504\n• MST: Chưa có\n• Địa chỉ: sss\n\n	2025-12-31 01:56:17.756	2025-12-31 01:56:17.756
7331786697872362496	7331778810618087424	7319893232403309568	/company s	2025-12-31 01:56:27.783	2025-12-31 01:56:27.783
7331786726645287936	7331776872867442688	7320276851855168512	Xin chào Trung tâm Logistics BW Thới Hòa! Tôi muốn liên hệ với công ty của bạn.	2025-12-31 01:56:34.643	2025-12-31 01:56:34.643
7331786749466496000	7331778810618087424	7319893232403309568	/company s	2025-12-31 01:56:40.084	2025-12-31 01:56:40.084
7331786749726542848	7331778810618087424	9999999999999999999	🔍 Tìm thấy **5** công ty:\n\n**1. test**\n• ID: 7320052714910479360\n• Địa chỉ: Chưa cập nhật\n\n**2. Công ty TNHH Giải pháp Số Softlab**\n• ID: 7320053085020058624\n• Địa chỉ: 59 Đặng Đại Độ, Trấn Biên, Đồng Nai\n\n**3. jdbbuidbius**\n• ID: 7326511626757306368\n• Địa chỉ: Chưa cập nhật\n\n**4. jdbbuidbius**\n• ID: 7326511647384893440\n• Địa chỉ: Chưa cập nhật\n\n**5. ss**\n• ID: 7326511805996693504\n• Địa chỉ: sss\n\n	2025-12-31 01:56:40.146	2025-12-31 01:56:40.146
7331786847783277568	7331778810618087424	7319893232403309568	/company s	2025-12-31 01:57:03.525	2025-12-31 01:57:03.525
7331786848051713024	7331778810618087424	9999999999999999999	🔍 Tìm thấy **5** công ty:\n\n**1. test**\n• ID: 7320052714910479360\n• MST: Chưa có\n• Địa chỉ: Chưa cập nhật\n\n**2. Công ty TNHH Giải pháp Số Softlab**\n• ID: 7320053085020058624\n• MST: Chưa có\n• Địa chỉ: 59 Đặng Đại Độ, Trấn Biên, Đồng Nai\n\n**3. jdbbuidbius**\n• ID: 7326511626757306368\n• MST: Chưa có\n• Địa chỉ: Chưa cập nhật\n\n**4. jdbbuidbius**\n• ID: 7326511647384893440\n• MST: Chưa có\n• Địa chỉ: Chưa cập nhật\n\n**5. ss**\n• ID: 7326511805996693504\n• MST: Chưa có\n• Địa chỉ: sss\n\n	2025-12-31 01:57:03.589	2025-12-31 01:57:03.589
7331786898165257216	7331776872867442688	7320276851855168512	Xin chào Công ty TNHH AkzoNobel Việt Nam! Tôi muốn liên hệ với công ty của bạn.	2025-12-31 01:57:15.537	2025-12-31 01:57:15.537
7331786927407944704	7331776872867442688	7320276851855168512	/help	2025-12-31 01:57:22.509	2025-12-31 01:57:22.509
7331786927609271296	7331776872867442688	9999999999999999999	Danh sách lệnh:\n/help – xem trợ giúp\n/hello – chào bot\n/company <id/mst> – thông tin công ty	2025-12-31 01:57:22.557	2025-12-31 01:57:22.557
7331786955933406208	7331776872867442688	7320276851855168512	/company s	2025-12-31 01:57:29.31	2025-12-31 01:57:29.31
7331786956147315712	7331776872867442688	9999999999999999999	🔍 Tìm thấy **5** công ty:\n\n**1. test**\n• ID: 7320052714910479360\n• MST: Chưa có\n• Địa chỉ: Chưa cập nhật\n\n**2. Công ty TNHH Giải pháp Số Softlab**\n• ID: 7320053085020058624\n• MST: Chưa có\n• Địa chỉ: 59 Đặng Đại Độ, Trấn Biên, Đồng Nai\n\n**3. jdbbuidbius**\n• ID: 7326511626757306368\n• MST: Chưa có\n• Địa chỉ: Chưa cập nhật\n\n**4. jdbbuidbius**\n• ID: 7326511647384893440\n• MST: Chưa có\n• Địa chỉ: Chưa cập nhật\n\n**5. ss**\n• ID: 7326511805996693504\n• MST: Chưa có\n• Địa chỉ: sss\n\n	2025-12-31 01:57:29.361	2025-12-31 01:57:29.361
7331787953011741696	7331776872867442688	7320276851855168512	Xin chào Quân! Tôi muốn liên hệ với công ty của bạn.	2025-12-31 02:01:27.031	2025-12-31 02:01:27.031
7331788709257335808	7331776872867442688	7320276851855168512	Xin chào Tổng Công Ty May Đồng Nai (Donagamex)! Tôi muốn liên hệ với công ty của bạn.	2025-12-31 02:04:27.335	2025-12-31 02:04:27.335
7331789812719997952	7331094207852602368	7319893232403309568	Xin chào Công ty CP Xi măng Vicem Sông Gianh! Tôi muốn liên hệ với công ty của bạn.	2025-12-31 02:08:50.421	2025-12-31 02:08:50.421
7331789869414405120	7331094207852602368	7319893232403309568	Xin chào Công ty Cao su Điện Biên! Tôi muốn liên hệ với công ty của bạn.	2025-12-31 02:09:03.937	2025-12-31 02:09:03.937
7331790163812602880	7331778810618087424	7319893232403309568	/company 7320053085020058624	2025-12-31 02:10:14.128	2025-12-31 02:10:14.128
7331790164022318080	7331778810618087424	9999999999999999999	🔍 Tìm thấy **1** công ty:\n\n**1. Công ty TNHH Giải pháp Số Softlab**\n• ID: 7320053085020058624\n• MST: Chưa có\n• Địa chỉ: 59 Đặng Đại Độ, Trấn Biên, Đồng Nai\n\n	2025-12-31 02:10:14.178	2025-12-31 02:10:14.178
7331790264803054592	7331094207852602368	7319893232403309568	Xin chào Công ty Cao su Điện Biên! Tôi muốn liên hệ với công ty của bạn.	2025-12-31 02:10:38.206	2025-12-31 02:10:38.206
7331790929705096192	7331094207852602368	7319893232403309568	Xin chào Linh kiện điện tử Biên Hòa (MTV)! Tôi muốn liên hệ với công ty của bạn.	2025-12-31 02:13:16.731	2025-12-31 02:13:16.731
7331790943810540544	7331094207852602368	7319893232403309568	ibguyvyuvb	2025-12-31 02:13:20.094	2025-12-31 02:13:20.094
7331803933804909568	7331776872867442688	7320276851855168512	Xin chào Nguyễn Anh Khôi - Công ty dệt dây thun! Tôi muốn liên hệ với công ty của bạn.	2025-12-31 03:04:57.15	2025-12-31 03:04:57.15
7331899506172154880	7331778810618087424	7319893232403309568	/help	2025-12-31 09:24:43.377	2025-12-31 09:24:43.377
7331899506352509952	7331778810618087424	7319893232403309568	/help	2025-12-31 09:24:43.421	2025-12-31 09:24:43.421
7331899516574028800	7331778810618087424	9999999999999999999	Danh sách lệnh:\n/help – xem trợ giúp\n/hello – chào bot\n/company <id/mst> – thông tin công ty	2025-12-31 09:24:45.858	2025-12-31 09:24:45.858
7331899522114704384	7331778810618087424	9999999999999999999	Danh sách lệnh:\n/help – xem trợ giúp\n/hello – chào bot\n/company <id/mst> – thông tin công ty	2025-12-31 09:24:47.179	2025-12-31 09:24:47.179
7331899542507410432	7331778810618087424	7319893232403309568	/help	2025-12-31 09:24:52.041	2025-12-31 09:24:52.041
7331899542545159168	7331778810618087424	9999999999999999999	Danh sách lệnh:\n/help – xem trợ giúp\n/hello – chào bot\n/company <id/mst> – thông tin công ty	2025-12-31 09:24:52.05	2025-12-31 09:24:52.05
7331899571691377664	7331778810618087424	7319893232403309568	/hello	2025-12-31 09:24:58.999	2025-12-31 09:24:58.999
7331899573029360640	7331778810618087424	9999999999999999999	Hello @petertuananh! How can I assist you today?	2025-12-31 09:24:59.318	2025-12-31 09:24:59.318
7331899919474676736	7331778810618087424	7319893232403309568	/company a	2025-12-31 09:26:21.917	2025-12-31 09:26:21.917
7331899940693660672	7331778810618087424	9999999999999999999	🔍 Tìm thấy **5** công ty:\n\n**1. Công ty TNHH Giải pháp Số Softlab**\n• ID: 7320053085020058624\n• MST: Chưa có\n• Địa chỉ: 59 Đặng Đại Độ, Trấn Biên, Đồng Nai\n\n**2. Test cty A**\n• ID: 7326528470773508096\n• MST: Chưa có\n• Địa chỉ: Chân trời tím\n\n**3. Tổng Công Ty May Đồng Nai (Donagamex)**\n• ID: 7326532604268488704\n• MST: Chưa có\n• Địa chỉ: 10.919622, 106.858808\n\n**4. Tổng Công Ty May Đồng Nai (Donagamex)**\n• ID: 7326532629862131712\n• MST: Chưa có\n• Địa chỉ: Chưa cập nhật\n\n**5. Tổng Công Ty May Đồng Nai (Donagamex)**\n• ID: 7326532646865840128\n• MST: Chưa có\n• Địa chỉ: gay\n\n	2025-12-31 09:26:26.976	2025-12-31 09:26:26.976
7331901221077687296	7331778810618087424	7319893232403309568	/help	2025-12-31 09:31:32.243	2025-12-31 09:31:32.243
7331901221442591744	7331778810618087424	9999999999999999999	Danh sách lệnh:\n/help – xem trợ giúp\n/hello – chào bot\n/company <id/mst> – thông tin công ty	2025-12-31 09:31:32.33	2025-12-31 09:31:32.33
7331901530710762496	7331778810618087424	7319893232403309568	shsiu	2025-12-31 09:32:46.065	2025-12-31 09:32:46.065
7331901549731931136	7331778810618087424	7319893232403309568	/help	2025-12-31 09:32:50.599	2025-12-31 09:32:50.599
7331901549941646336	7331778810618087424	9999999999999999999	Danh sách lệnh:\n/help – xem trợ giúp\n/hello – chào bot\n/company <id/mst> – thông tin công ty	2025-12-31 09:32:50.65	2025-12-31 09:32:50.65
7331901681867495424	7331778810618087424	7319893232403309568	/help	2025-12-31 09:33:22.104	2025-12-31 09:33:22.104
7331901686175045632	7331778810618087424	9999999999999999999	Danh sách lệnh:\n/help – xem trợ giúp\n/hello – chào bot\n/company <id/mst> – thông tin công ty	2025-12-31 09:33:23.131	2025-12-31 09:33:23.131
7331901703300388864	7331778810618087424	7319893232403309568	/help	2025-12-31 09:33:27.213	2025-12-31 09:33:27.213
7331901707574384640	7331778810618087424	9999999999999999999	Danh sách lệnh:\n/help – xem trợ giúp\n/hello – chào bot\n/company <id/mst> – thông tin công ty	2025-12-31 09:33:28.233	2025-12-31 09:33:28.233
7331901854885570560	7331778810618087424	7319893232403309568	/help	2025-12-31 09:34:03.354	2025-12-31 09:34:03.354
7331901874212923392	7331778810618087424	7319893232403309568	/help	2025-12-31 09:34:07.962	2025-12-31 09:34:07.962
7331901878545639424	7331778810618087424	9999999999999999999	Danh sách lệnh:\n/help – xem trợ giúp\n/hello – chào bot\n/company <id/mst> – thông tin công ty	2025-12-31 09:34:08.995	2025-12-31 09:34:08.995
7331901884593825792	7331778810618087424	7319893232403309568	/help	2025-12-31 09:34:10.438	2025-12-31 09:34:10.438
7331901888867821568	7331778810618087424	9999999999999999999	Danh sách lệnh:\n/help – xem trợ giúp\n/hello – chào bot\n/company <id/mst> – thông tin công ty	2025-12-31 09:34:11.455	2025-12-31 09:34:11.455
7331901913521940480	7331778810618087424	7319893232403309568	/company s	2025-12-31 09:34:17.333	2025-12-31 09:34:17.333
7331901917833684992	7331778810618087424	9999999999999999999	🔍 Tìm thấy **5** công ty:\n\n**1. test**\n• ID: 7320052714910479360\n• MST: Chưa có\n• Địa chỉ: Chưa cập nhật\n\n**2. Công ty TNHH Giải pháp Số Softlab**\n• ID: 7320053085020058624\n• MST: Chưa có\n• Địa chỉ: 59 Đặng Đại Độ, Trấn Biên, Đồng Nai\n\n**3. jdbbuidbius**\n• ID: 7326511626757306368\n• MST: Chưa có\n• Địa chỉ: Chưa cập nhật\n\n**4. jdbbuidbius**\n• ID: 7326511647384893440\n• MST: Chưa có\n• Địa chỉ: Chưa cập nhật\n\n**5. ss**\n• ID: 7326511805996693504\n• MST: Chưa có\n• Địa chỉ: sss\n\n	2025-12-31 09:34:18.362	2025-12-31 09:34:18.362
7331901935890163712	7331778810618087424	7319893232403309568	/help	2025-12-31 09:34:22.667	2025-12-31 09:34:22.667
7331901940155770880	7331778810618087424	9999999999999999999	Danh sách lệnh:\n/help – xem trợ giúp\n/hello – chào bot\n/company <id/mst> – thông tin công ty	2025-12-31 09:34:23.684	2025-12-31 09:34:23.684
7331901981121538048	7331778810618087424	7319893232403309568	/help	2025-12-31 09:34:33.451	2025-12-31 09:34:33.451
7331901985399728128	7331778810618087424	9999999999999999999	Danh sách lệnh:\n/help – xem trợ giúp\n/hello – chào bot\n/company <id/mst> – thông tin công ty	2025-12-31 09:34:34.471	2025-12-31 09:34:34.471
7331902059714406400	7331778810618087424	7319893232403309568	/hello	2025-12-31 09:34:52.189	2025-12-31 09:34:52.189
7331902063984207872	7331778810618087424	9999999999999999999	Hello @petertuananh! How can I assist you today?	2025-12-31 09:34:53.207	2025-12-31 09:34:53.207
7331902546820645888	7331778810618087424	7319893232403309568	/help	2025-12-31 09:36:48.325	2025-12-31 09:36:48.325
7331902551119807488	7331778810618087424	9999999999999999999	Danh sách lệnh:\n/help – xem trợ giúp\n/hello – chào bot\n/company <id/mst> – thông tin công ty	2025-12-31 09:36:49.35	2025-12-31 09:36:49.35
7331902661572609024	7331778810618087424	7319893232403309568	sidsdi	2025-12-31 09:37:15.684	2025-12-31 09:37:15.684
7331902665997599744	7331778810618087424	7319893232403309568	dnsojdnsd	2025-12-31 09:37:16.739	2025-12-31 09:37:16.739
7331902669646644224	7331778810618087424	7319893232403309568	dnsjdhnsd	2025-12-31 09:37:17.608	2025-12-31 09:37:17.608
7331902673480238080	7331778810618087424	7319893232403309568	lkfnidofpijdf	2025-12-31 09:37:18.523	2025-12-31 09:37:18.523
7331902679704585216	7331778810618087424	7319893232403309568	óko[aksas	2025-12-31 09:37:20.007	2025-12-31 09:37:20.007
7331902782754440192	7331778810618087424	7319893232403309568	/help	2025-12-31 09:37:44.576	2025-12-31 09:37:44.576
7331902787028435968	7331778810618087424	9999999999999999999	Danh sách lệnh:\n/help – xem trợ giúp\n/hello – chào bot\n/company <id/mst> – thông tin công ty	2025-12-31 09:37:45.595	2025-12-31 09:37:45.595
7331903909189305344	7331778810618087424	7319893232403309568	/help	2025-12-31 09:42:13.139	2025-12-31 09:42:13.139
7331903913471689728	7331778810618087424	9999999999999999999	Danh sách lệnh:\n/help – xem trợ giúp\n/hello – chào bot\n/company <id/mst> – thông tin công ty	2025-12-31 09:42:14.16	2025-12-31 09:42:14.16
7332991225382350848	7331778810618087424	7319893232403309568	/help	2026-01-03 09:42:49.52	2026-01-03 09:42:49.52
7332991229673123840	7331778810618087424	9999999999999999999	Danh sách lệnh:\n/help – xem trợ giúp\n/hello – chào bot\n/company <id/mst> – thông tin công ty	2026-01-03 09:42:50.543	2026-01-03 09:42:50.543
7332991240410542080	7331778810618087424	7319893232403309568	/help	2026-01-03 09:42:53.103	2026-01-03 09:42:53.103
7332991244671954944	7331778810618087424	9999999999999999999	Danh sách lệnh:\n/help – xem trợ giúp\n/hello – chào bot\n/company <id/mst> – thông tin công ty	2026-01-03 09:42:54.119	2026-01-03 09:42:54.119
7333077225891319808	7331252814869935104	7319893232403309568	skask;á	2026-01-03 15:24:33.64	2026-01-03 15:24:33.64
7333077310922444800	7331252814869935104	7326530218858752000	ihdis	2026-01-03 15:24:53.912	2026-01-03 15:24:53.912
7333077319713705984	7331252814869935104	7326530218858752000	sdksndksndlknsfdf	2026-01-03 15:24:56.009	2026-01-03 15:24:56.009
7333077323991896064	7331252814869935104	7326530218858752000	ljspifjdipfjdf	2026-01-03 15:24:57.029	2026-01-03 15:24:57.029
7333077328182005760	7331252814869935104	7326530218858752000	djsipdjsoipdjse	2026-01-03 15:24:58.028	2026-01-03 15:24:58.028
7333077331755552768	7331252814869935104	7326530218858752000	;'psDKOSPJDOPJSD	2026-01-03 15:24:58.88	2026-01-03 15:24:58.88
7333077335085830144	7331252814869935104	7326530218858752000	SE;S'O JOSJKDA'	2026-01-03 15:24:59.674	2026-01-03 15:24:59.674
7333077344070029312	7331252814869935104	7326530218858752000	hELLO	2026-01-03 15:25:01.816	2026-01-03 15:25:01.816
7333077416346275840	7333077400743464960	7326530218858752000	/help	2026-01-03 15:25:19.048	2026-01-03 15:25:19.048
7333077442283851776	7333077400743464960	7326530218858752000	/help	2026-01-03 15:25:25.232	2026-01-03 15:25:25.232
7333077526220263424	7331778810618087424	7319893232403309568	/help	2026-01-03 15:25:45.243	2026-01-03 15:25:45.243
7333077530485870592	7331778810618087424	9999999999999999999	Danh sách lệnh:\n/help – xem trợ giúp\n/hello – chào bot\n/company <id/mst> – thông tin công ty	2026-01-03 15:25:46.261	2026-01-03 15:25:46.261
7333285733253183488	7331778810618087424	7319893232403309568	/help	2026-01-04 05:13:05.668	2026-01-04 05:13:05.668
7333285737535567872	7331778810618087424	9999999999999999999	Danh sách lệnh:\n/help – xem trợ giúp\n/hello – chào bot\n/company <id/mst> – thông tin công ty	2026-01-04 05:13:06.689	2026-01-04 05:13:06.689
7333437587117908992	7331094207852602368	7319893232403309568	/help	2026-01-04 15:16:30.451	2026-01-04 15:16:30.451
7331143983493303296	7331128090820602880	7331127480238992384	...	2025-12-29 07:22:32.733	2026-01-05 02:55:59.187
7333963407105677312	7331776872867442688	7320276851855168512	/help	2026-01-06 02:05:55.706	2026-01-06 02:05:55.706
7333963411430004736	7331776872867442688	9999999999999999999	Danh sách lệnh:\n/help – xem trợ giúp\n/hello – chào bot\n/company <id/mst> – thông tin công ty	2026-01-06 02:05:56.736	2026-01-06 02:05:56.736
7333963460553693184	7331776872867442688	7320276851855168512	/hello	2026-01-06 02:06:08.448	2026-01-06 02:06:08.448
7333963464831883264	7331776872867442688	9999999999999999999	Hello @khangfc162! How can I assist you today?	2026-01-06 02:06:09.468	2026-01-06 02:06:09.468
7333963512424650752	7331776872867442688	7320276851855168512	/company	2026-01-06 02:06:20.815	2026-01-06 02:06:20.815
7333963516711229440	7331776872867442688	9999999999999999999	❗ Vui lòng cung cấp thông tin để tìm công ty.\nVí dụ: `/company 123456` hoặc `/company công ty ABC`	2026-01-06 02:06:21.837	2026-01-06 02:06:21.837
\.


--
-- Data for Name: Orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Orders" (id, products, total, user_id, created_at, modified_at, status) FROM stdin;
e9b956d1-31c4-4e41-a0cc-013c36375ef5	[{"id": "0c4f636d-9198-4995-aea0-efb6876eed8a", "amount": 5, "product": {"id": "1", "name": "Sản phẩm 1", "price": 10000, "stock": 10, "place_id": "2", "unit_type": "tấn", "created_at": "2026-01-03T00:42:30.786Z", "category_id": "7333088317388022784", "description": "test nha", "modified_at": "2026-01-04T06:11:59.897Z"}, "user_id": "7319893232403309568", "created_at": "2026-01-04T12:44:35.889Z", "product_id": "1", "modified_at": "2026-01-04T12:50:15.319Z"}]	50000	7319893232403309568	2026-01-04 14:19:53.072	2026-01-04 14:19:53.072	paid
7728851c-5504-4428-8709-47cf3733e553	[{"id": "872711f0-a897-453c-a6a5-70f08a65420f", "amount": 1, "product": {"id": "1", "name": "Sản phẩm 1", "price": 10000, "stock": 5, "place_id": "2", "unit_type": "tấn", "created_at": "2026-01-03T00:42:30.786Z", "category_id": "7333088317388022784", "description": "test nha", "modified_at": "2026-01-04T14:19:53.079Z"}, "user_id": "7319893232403309568", "created_at": "2026-01-04T15:16:58.244Z", "product_id": "1", "modified_at": "2026-01-04T15:16:58.244Z"}]	10000	7319893232403309568	2026-01-04 15:17:06.998	2026-01-04 15:17:06.998	paid
eba9a00f-deba-4a66-938d-aef232115282	[{"id": "85c0ef29-f218-45bf-820d-6954fa539ed1", "amount": 1, "product": {"id": "7333426622021528576", "name": "Đèn pin 7 chế độ", "price": 1000000, "stock": 999999999, "place_id": "7333426136056884224", "unit_type": "cái", "created_at": "2026-01-04T14:32:56.168Z", "category_id": null, "description": "Nhìn r còn hỏi ?", "modified_at": "2026-01-05T13:32:20.094Z"}, "user_id": "7319893232403309568", "created_at": "2026-01-05T02:08:00.245Z", "product_id": "7333426622021528576", "modified_at": "2026-01-05T13:32:38.270Z"}]	1000000	7319893232403309568	2026-01-05 13:32:44.678	2026-01-05 13:32:44.678	paid
64b8e01b-eb17-45c0-b9a6-0a0ab05937c5	[{"id": "45fa6807-0aa2-48ce-9bf9-36daf24a0748", "amount": 1, "product": {"id": "2", "name": "Sản phẩm 2", "price": 12000, "stock": 1007, "place_id": "1", "unit_type": "kg", "created_at": "2026-01-03T00:43:11.132Z", "category_id": null, "description": "test luôn nha", "modified_at": "2026-01-03T16:18:46.724Z"}, "user_id": "7319893232403309568", "created_at": "2026-01-06T01:34:50.092Z", "product_id": "2", "modified_at": "2026-01-06T01:34:50.092Z"}]	12000	7319893232403309568	2026-01-06 01:35:56.131	2026-01-06 01:35:56.131	paid
\.


--
-- Data for Name: Places; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Places" (id, name, address, phone, latitude, longitude, company_id, user_id, creator_id, created_at, modified_at, description) FROM stdin;
7332983705255325696	2	2	\N	\N	\N	7320053085020058624	\N	7319893232403309568	2026-01-03 09:12:56.582	2026-01-03 09:12:56.582	\N
7333782595395934208	Bao bì Carton Vĩnh Phát	Cụm gốm, P. Tân Hạnh, Biên Hòa	\N	10.9339675	106.7999634	7326535476393650176	\N	7320276851855168512	2026-01-05 14:07:26.835	2026-01-05 14:07:37.575	\N
7333782692338882560	Bao Bì Thống Nhất Đồng Nai	486 QL15 (Bùi Trọng Nghĩa), P. Trảng Dài, Biên Hòa	\N	10.9974985	106.8615175	7326535363994691584	\N	7320276851855168512	2026-01-05 14:07:49.947	2026-01-05 14:08:08.956	\N
7333782856692684800	TOKIN Electronics (VN)	Lô 230, KCN Loteco (Trùng khớp mục số 3)	\N	10.9294591	106.8890128	7326535312845154304	\N	7320276851855168512	2026-01-05 14:08:29.133	2026-01-05 14:08:40.399	\N
2	Test 2	59 Đặng Đại Độ, Trấn Biên, Đồng Nai	0845656869	10.924914	106.84687	\N	7319893232403309568	7319893232403309568	2026-01-03 08:52:10.486	2026-01-04 06:42:18.388	\N
7333782967774631936	Bao Bì Bình Minh	50, KP2, P. Tân Hiệp, Biên Hòa	\N	10.9671832	106.8608579	7326536074404931584	\N	7320276851855168512	2026-01-05 14:08:55.617	2026-01-05 14:09:06.55	\N
1	Test	59 Đặng Đại Độ, Trấn Biên, Đồng Nai	0888866548	10.92203	106.838242	7320053085020058624	\N	7319893232403309568	2026-01-03 00:23:20.345	2026-01-05 00:07:48.482	Test th nha
7333783089338144768	Formosa Taffeta Việt Nam	Đường số 10, KCN Nhơn Trạch 3, Nhơn Trạch	\N	10.7199812	106.931799	7326767216848259072	\N	7320276851855168512	2026-01-05 14:09:24.6	2026-01-05 14:09:35.23	\N
7333415226550540288	cơ sở 1	Đường số 2, KCN Biên Hòa 1, P. An Bình, Biên Hòa, Đồng Nai	\N	10.922259	106.849806	7326532791888095232	\N	7320276851855168512	2026-01-04 13:47:39.276	2026-01-05 02:33:50.08	\N
7333426136056884224	Của hàng sếc 1	59 Đặng Đại Độ, Trấn Biên, Đồng Nai	\N	10.920712	106.834881	7333424421834750976	\N	7319893232403309568	2026-01-04 14:31:00.306	2026-01-05 02:54:28.307	\N
7333609228498183168	Công Ty TNHH Sơn Hà (May mặc)	79 Đ. Nguyễn Văn A, P. Trảng Dài, Biên Hòa	\N	10.9649443	106.8576049	7326534226503641088	\N	7320276851855168512	2026-01-05 02:38:32.945	2026-01-05 14:04:54.024	\N
7333782068771706880	Dệt dây thun Nguyễn Anh Khôi	1240 tổ 35 KP Vườn Dừa, P. Phước Tân, Biên Hòa	\N	10.9009885	106.9041755	7326534286587045888	\N	7320276851855168512	2026-01-05 14:05:21.278	2026-01-05 14:05:33.893	\N
7333782233435887616	TOKIN Electronics (VN)	Lô 230, KCN Loteco, P. Long Bình, Biên Hòa	\N	10.9294591	106.8890128	7326534708907321344	\N	7320276851855168512	2026-01-05 14:06:00.537	2026-01-05 14:06:09.159	\N
7333782326192920576	Công ty TNHH INZI VINA	Lô 220, Đường 10, KCN Amata, Biên Hòa	\N	10.9491223	106.8930191	7326534764666398720	\N	7320276851855168512	2026-01-05 14:06:22.652	2026-01-05 14:06:33.56	\N
7333782460163184640	Linh kiện điện tử Biên Hòa (MTV)	Hẻm 547 Xa lộ Hà Nội, P. Long Bình, Biên Hòa	\N	10.9564381	106.8771287	7326534817845979136	\N	7320276851855168512	2026-01-05 14:06:54.593	2026-01-05 14:07:13.323	\N
\.


--
-- Data for Name: Product_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Product_categories" (id, name, description, created_at, modified_at) FROM stdin;
7333962783433644032	Dệt may và phụ liệu	Các loại phế thải sử dụng để dệt may.	2026-01-06 02:03:27.01	2026-01-06 02:03:27.01
7333962683982501888	Nhựa và polymer	Các loại nhựa và polymer dùng để sản xuất trong công nghiệp.	2026-01-06 02:03:03.298	2026-01-06 02:03:31.008
7333962542168889344	Giấy và các loại bao bì	Các phế thải giấy và bao bì có thể tái sử dụng.	2026-01-06 02:02:29.488	2026-01-06 02:03:34.029
7333962265558734848	Kim loại	Các kim loại có thể tái sử dụng ( Đồng, Sắt, Nhôm, ...).	2026-01-06 02:01:23.539	2026-01-06 02:03:37.174
7333961786602772480	Linh kiện điện tử	Các linh kiện điện tử.	2026-01-06 01:59:29.347	2026-01-06 02:03:40.84
\.


--
-- Data for Name: Products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Products" (id, name, description, price, stock, unit_type, place_id, created_at, modified_at, category_id) FROM stdin;
7333958117690202112	Bo mạch cũ (PCB)	Bo mạch từ những thiết bị điện tử	100000	2500	kg	7333782460163184640	2026-01-06 01:44:54.611	2026-01-06 02:01:02.124	7333961786602772480
7333958349744265216	Giấy Carton phế liệu	Giấy carton thừa	4000	25000	kg	7333782595395934208	2026-01-06 01:45:49.937	2026-01-06 02:03:55.406	7333962542168889344
7333958903182678016	Thiếc hàn, dây dẫn	Thiếc hàn và dây dẫn từ các thiết bị điện tử ( Độ mới: 90%)	400000	800	kg	7333782856692684800	2026-01-06 01:48:01.887	2026-01-06 02:04:11.279	7333962265558734848
7333959108644853760	Giấy lề, giấy vụn	Giấy loại mỏng ( Độ mới: 80%)	4000	22000	kg	7333782967774631936	2026-01-06 01:48:50.873	2026-01-06 02:04:20.397	7333962542168889344
7333958565851584512	Nhựa PE, màng nilon	Phế thải nhựa trong công nghiệp	12000	10000	kg	7333782692338882560	2026-01-06 01:46:41.461	2026-01-06 02:04:27.137	7333962683982501888
7333959593409599488	Vải sợi dư, nhựa PP	Vải sợi và nhựa PP dư ( Độ mới : 80%)	3500	40000	kg	7333783089338144768	2026-01-06 01:50:46.45	2026-01-06 02:04:37.07	7333962683982501888
7333956887425341440	Vải vụn	Vải sử dụng trong công nghiệp	4000	6000	kg	7333609228498183168	2026-01-06 01:40:01.293	2026-01-06 02:04:46.006	7333962783433644032
7333957121375229952	Sợi thun, dây thun vụn	Sợi thun có thể tái sử dụng	3000	4000	kg	7333782068771706880	2026-01-06 01:40:57.071	2026-01-06 02:04:53.524	7333962683982501888
7333957418759772160	Phế liệu Đồng	Đồng dư từ việc sản xuất các linh kiện, thiết bị điện tử	180000	1000	kg	7333782233435887616	2026-01-06 01:42:07.973	2026-01-06 02:05:02.215	7333962265558734848
7333957896662964224	Nhôm đúc, Nhựa ABS	Phế thải trong công nghiệp	35000	13000	kg	7333782326192920576	2026-01-06 01:44:01.914	2026-01-06 02:05:09.796	7333962683982501888
\.



--
-- Data for Name: Users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Users" (id, username, email, phone_number, display_name, hashed_password, google_id, created_at, modified_at, last_active_at, status, bot_token, flags, avatar_file_id, balance) FROM stdin;
9999999999999999999	KHKT2025_bot	admin@khkt.itlhbs.io.vn	\N	KHKT2025_bot	\N	\N	2025-12-31 01:16:40.447	2026-01-06 01:49:57.466	\N	online	76325468364792489	{ADMIN,BOT,VERIFIED}	09771cbe-4c14-412a-89dc-a470f2398b8c	0
7320276851855168512	khangfc162	khangfc162@gmail.com	\N	Khang Bach	\N	101057151223263414247	2025-11-29 07:40:26.651	2026-01-06 02:07:03.665	2026-01-06 02:05:15.31	idle	\N	{ADMIN}	9273b1b7-f2be-400d-a233-b29548495104	0
7331239930557463552	nhubbcc2012	nhubbcc2012@gmail.com	\N	Quynh Nhu Tran	\N	113150586725515484473	2025-12-29 13:43:48.297	2025-12-29 14:24:51.483	2025-12-29 14:24:51.482	offline	\N	{}	\N	0
7319893232403309568	petertuananh	petertuananh@hotmail.com	0845656869	Peter Tuan Anh	\N	106780849531555915733	2025-11-28 06:16:04.646	2026-01-06 02:01:09.375	\N	idle	\N	{ADMIN,VERIFIED}	b460827d-6126-433b-8451-73979994a5d2	98000
7331157438012509184	ngohaivy2k8	ngohaivy2k8@gmail.com	\N	Hải Vy	\N	113767191763195498693	2025-12-29 08:16:00.541	2026-01-04 14:28:52.756	2026-01-04 14:28:52.755	offline	\N	{}	\N	0
7326530218858752000	phananh2583	phananh2583@gmail.com	\N	Anh Phan	\N	106468114549192732139	2025-12-16 13:49:05.525	2026-01-04 05:59:34.756	2026-01-04 05:59:34.755	offline	\N	{ADMIN}	\N	0
7331578479903157248	wendyquynhgiang	wendyquynhgiang@gmail.com	\N	Quỳnh Giang Wendy	\N	106303575163996590030	2025-12-30 12:09:04.752	2026-01-03 13:16:25.44	2026-01-03 13:16:25.438	offline	\N	{}	\N	0
7331127480238992384	trangiahuydo	trangiahuydo@gmail.com	\N	Gia Huy Trần	\N	109936061407008359290	2025-12-29 06:16:58.052	2025-12-29 07:23:21.542	2025-12-29 07:23:21.541	offline	\N	{}	\N	0
7333615893448565760	taikhoancaythit2	taikhoancaythit2@gmail.com	\N	Tai Khoan Cay Thit 2	\N	107070325366710307735	2026-01-05 03:05:01.993	2026-01-05 03:06:46.677	\N	online	\N	{}	\N	0
7327880760584709120	thamnt_tt	thamnt_tt@lhbs.vn	\N	Thắm Nguyễn Thị	\N	110974848865165823849	2025-12-20 07:15:39.765	2025-12-20 07:15:39.765	\N	offline	\N	{}	\N	0
7331130523177184256	itchannels2008	itchannels2008@gmail.com	\N	Hello World	\N	103672451071339750309	2025-12-29 06:29:03.544	2025-12-30 04:00:07.106	2025-12-30 04:00:07.105	offline	\N	{}	\N	0
\.


--
-- Data for Name: _UserChats; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_UserChats" ("A", "B") FROM stdin;
7331094207852602368	7319893232403309568
7331094207852602368	7320276851855168512
7331128090820602880	7319893232403309568
7331128090820602880	7331127480238992384
7331130830523198464	7331130523177184256
7331130830523198464	7319893232403309568
7331157766770445312	7331157438012509184
7331157766770445312	7319893232403309568
7331239623874149376	7319893232403309568
7331239623874149376	7327880760584709120
7331240024094637056	7331239930557463552
7331240024094637056	7319893232403309568
7331252814869935104	7319893232403309568
7331252814869935104	7326530218858752000
7331385986762845184	7331130523177184256
7331385986762845184	7326530218858752000
7331431806161824768	7320276851855168512
7331431806161824768	7331130523177184256
7331578834649000960	7319893232403309568
7331578834649000960	7331578479903157248
7331579859321662464	7331239930557463552
7331579859321662464	7331578479903157248
7331774791259851776	7326530218858752000
7331774791259851776	7320276851855168512
7331776872867442688	9999999999999999999
7331776872867442688	7320276851855168512
7331778810618087424	9999999999999999999
7331778810618087424	7319893232403309568
7333077400743464960	9999999999999999999
7333077400743464960	7326530218858752000
\.


--
-- Name: Carts Carts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Carts"
    ADD CONSTRAINT "Carts_pkey" PRIMARY KEY (id);


--
-- Name: Chats Chats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Chats"
    ADD CONSTRAINT "Chats_pkey" PRIMARY KEY (id);


--
-- Name: Companies Companies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Companies"
    ADD CONSTRAINT "Companies_pkey" PRIMARY KEY (id);


--
-- Name: CompanyDeliveries CompanyDeliveries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CompanyDeliveries"
    ADD CONSTRAINT "CompanyDeliveries_pkey" PRIMARY KEY (id);


--
-- Name: CompanyRecruitments CompanyRecruitments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CompanyRecruitments"
    ADD CONSTRAINT "CompanyRecruitments_pkey" PRIMARY KEY (id);


--
-- Name: CompanyScrapes CompanyScrapes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CompanyScrapes"
    ADD CONSTRAINT "CompanyScrapes_pkey" PRIMARY KEY (id);


--
-- Name: Files Files_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Files"
    ADD CONSTRAINT "Files_pkey" PRIMARY KEY (id);


--
-- Name: Message_reactions Message_reactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Message_reactions"
    ADD CONSTRAINT "Message_reactions_pkey" PRIMARY KEY (id);


--
-- Name: Message_seens Message_seens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Message_seens"
    ADD CONSTRAINT "Message_seens_pkey" PRIMARY KEY (id);


--
-- Name: Messages Messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Messages"
    ADD CONSTRAINT "Messages_pkey" PRIMARY KEY (id);


--
-- Name: Orders Orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Orders"
    ADD CONSTRAINT "Orders_pkey" PRIMARY KEY (id);


--
-- Name: Places Places_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Places"
    ADD CONSTRAINT "Places_pkey" PRIMARY KEY (id);


--
-- Name: Product_categories Product_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Product_categories"
    ADD CONSTRAINT "Product_categories_pkey" PRIMARY KEY (id);


--
-- Name: Products Products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Products"
    ADD CONSTRAINT "Products_pkey" PRIMARY KEY (id);



--
-- Name: Users Users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_pkey" PRIMARY KEY (id);


--
-- Name: _UserChats _UserChats_AB_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_UserChats"
    ADD CONSTRAINT "_UserChats_AB_pkey" PRIMARY KEY ("A", "B");


--
-- Name: Users_username_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Users_username_key" ON public."Users" USING btree (username);


--
-- Name: _UserChats_B_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "_UserChats_B_index" ON public."_UserChats" USING btree ("B");


--
-- Name: email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX email ON public."Users" USING btree (email);


--
-- Name: google_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX google_id ON public."Users" USING btree (google_id);


--
-- Name: phone_number; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX phone_number ON public."Users" USING btree (phone_number);


--
-- Name: Carts Carts_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Carts"
    ADD CONSTRAINT "Carts_product_id_fkey" FOREIGN KEY (product_id) REFERENCES public."Products"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Carts Carts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Carts"
    ADD CONSTRAINT "Carts_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Companies Companies_owned_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Companies"
    ADD CONSTRAINT "Companies_owned_by_fkey" FOREIGN KEY (owned_by) REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: CompanyDeliveries CompanyDeliveries_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CompanyDeliveries"
    ADD CONSTRAINT "CompanyDeliveries_company_id_fkey" FOREIGN KEY (company_id) REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: CompanyDeliveries CompanyDeliveries_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CompanyDeliveries"
    ADD CONSTRAINT "CompanyDeliveries_created_by_fkey" FOREIGN KEY (created_by) REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: CompanyRecruitments CompanyRecruitments_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CompanyRecruitments"
    ADD CONSTRAINT "CompanyRecruitments_company_id_fkey" FOREIGN KEY (company_id) REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: CompanyRecruitments CompanyRecruitments_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CompanyRecruitments"
    ADD CONSTRAINT "CompanyRecruitments_created_by_fkey" FOREIGN KEY (created_by) REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: CompanyScrapes CompanyScrapes_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CompanyScrapes"
    ADD CONSTRAINT "CompanyScrapes_company_id_fkey" FOREIGN KEY (company_id) REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: CompanyScrapes CompanyScrapes_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CompanyScrapes"
    ADD CONSTRAINT "CompanyScrapes_created_by_fkey" FOREIGN KEY (created_by) REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Files Files_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Files"
    ADD CONSTRAINT "Files_product_id_fkey" FOREIGN KEY (product_id) REFERENCES public."Products"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Files Files_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Files"
    ADD CONSTRAINT "Files_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Message_reactions Message_reactions_message_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Message_reactions"
    ADD CONSTRAINT "Message_reactions_message_id_fkey" FOREIGN KEY (message_id) REFERENCES public."Messages"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Message_reactions Message_reactions_seen_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Message_reactions"
    ADD CONSTRAINT "Message_reactions_seen_by_id_fkey" FOREIGN KEY (seen_by_id) REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Message_seens Message_seens_message_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Message_seens"
    ADD CONSTRAINT "Message_seens_message_id_fkey" FOREIGN KEY (message_id) REFERENCES public."Messages"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Message_seens Message_seens_seen_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Message_seens"
    ADD CONSTRAINT "Message_seens_seen_by_id_fkey" FOREIGN KEY (seen_by_id) REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Messages Messages_chat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Messages"
    ADD CONSTRAINT "Messages_chat_id_fkey" FOREIGN KEY (chat_id) REFERENCES public."Chats"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Messages Messages_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Messages"
    ADD CONSTRAINT "Messages_sender_id_fkey" FOREIGN KEY (sender_id) REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Orders Orders_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Orders"
    ADD CONSTRAINT "Orders_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Places Places_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Places"
    ADD CONSTRAINT "Places_company_id_fkey" FOREIGN KEY (company_id) REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Places Places_creator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Places"
    ADD CONSTRAINT "Places_creator_id_fkey" FOREIGN KEY (creator_id) REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Places Places_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Places"
    ADD CONSTRAINT "Places_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Products Products_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Products"
    ADD CONSTRAINT "Products_category_id_fkey" FOREIGN KEY (category_id) REFERENCES public."Product_categories"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Products Products_place_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Products"
    ADD CONSTRAINT "Products_place_id_fkey" FOREIGN KEY (place_id) REFERENCES public."Places"(id) ON UPDATE CASCADE ON DELETE CASCADE;



--
-- Name: _UserChats _UserChats_A_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_UserChats"
    ADD CONSTRAINT "_UserChats_A_fkey" FOREIGN KEY ("A") REFERENCES public."Chats"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _UserChats _UserChats_B_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_UserChats"
    ADD CONSTRAINT "_UserChats_B_fkey" FOREIGN KEY ("B") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict pqkNaQRRUfrmnNbsn5hdJteOSTGhpQDcdakNykpk5REfJvQjIYDLBosASbiLEBX

