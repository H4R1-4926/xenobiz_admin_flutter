--
-- PostgreSQL database dump
--

\restrict vGdXuvaEncOjcbVn5JmRXdk9x0yg135ugExbvp8tvAkQMAglCX9lkx7Yt4imgYd

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admins; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admins (
    id character varying(36) NOT NULL,
    name character varying(150) NOT NULL,
    email character varying(150) NOT NULL,
    login_id character varying(100),
    password_hash text NOT NULL,
    status character varying(20) DEFAULT 'active'::character varying,
    role character varying(20) DEFAULT 'ADMIN'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    last_login_at timestamp without time zone
);


ALTER TABLE public.admins OWNER TO postgres;

--
-- Name: app_configs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.app_configs (
    id character varying(36) NOT NULL,
    category character varying(50) NOT NULL,
    key character varying(100) NOT NULL,
    value jsonb DEFAULT '{}'::jsonb NOT NULL,
    description text,
    updated_by character varying(150),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.app_configs OWNER TO postgres;

--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audit_logs (
    id character varying(36) NOT NULL,
    admin_id character varying(36),
    admin_name character varying(150) NOT NULL,
    action character varying(100) NOT NULL,
    target_type character varying(100),
    target_id character varying(100),
    details jsonb DEFAULT '{}'::jsonb,
    ip_address character varying(50),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.audit_logs OWNER TO postgres;

--
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    id character varying(36) NOT NULL,
    shop_id character varying(36),
    name character varying(150) NOT NULL,
    email character varying(150),
    phone character varying(50),
    city character varying(100),
    state character varying(100),
    country character varying(100) DEFAULT 'India'::character varying,
    status character varying(20) DEFAULT 'active'::character varying,
    total_spent numeric(12,2) DEFAULT 0.00,
    total_purchases integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- Name: feature_flags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.feature_flags (
    id character varying(36) NOT NULL,
    key character varying(100) NOT NULL,
    name character varying(150) NOT NULL,
    description text,
    is_enabled boolean DEFAULT false,
    environment character varying(50) DEFAULT 'production'::character varying,
    updated_by character varying(150),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.feature_flags OWNER TO postgres;

--
-- Name: payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payments (
    id character varying(36) NOT NULL,
    shop_id character varying(36) NOT NULL,
    subscription_id character varying(36),
    plan_id character varying(36),
    amount numeric(12,2) DEFAULT 0.00 NOT NULL,
    currency character varying(10) DEFAULT 'INR'::character varying,
    payment_method character varying(50) DEFAULT 'UPI'::character varying,
    provider character varying(50) DEFAULT 'razorpay'::character varying,
    transaction_id character varying(100),
    provider_payment_id character varying(100),
    status character varying(20) DEFAULT 'successful'::character varying,
    paid_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    failure_reason text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.payments OWNER TO postgres;

--
-- Name: plans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.plans (
    id character varying(36) NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    price numeric(12,2) DEFAULT 0.00 NOT NULL,
    currency character varying(10) DEFAULT 'INR'::character varying,
    billing_cycle character varying(20) DEFAULT 'monthly'::character varying,
    features jsonb DEFAULT '[]'::jsonb,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.plans OWNER TO postgres;

--
-- Name: shops; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shops (
    id character varying(36) NOT NULL,
    shop_name character varying(150) NOT NULL,
    owner_name character varying(150) NOT NULL,
    email character varying(150) NOT NULL,
    phone character varying(50),
    address text,
    city character varying(100),
    state character varying(100),
    country character varying(100) DEFAULT 'India'::character varying,
    postal_code character varying(20),
    gst_number character varying(50),
    business_type character varying(50),
    login_id character varying(100),
    password_hash text NOT NULL,
    status character varying(20) DEFAULT 'active'::character varying,
    is_verified boolean DEFAULT true,
    role character varying(20) DEFAULT 'OWNER'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    last_login_at timestamp without time zone
);


ALTER TABLE public.shops OWNER TO postgres;

--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subscriptions (
    id character varying(36) NOT NULL,
    shop_id character varying(36) NOT NULL,
    plan_id character varying(36) NOT NULL,
    plan_name character varying(100) NOT NULL,
    status character varying(20) DEFAULT 'active'::character varying,
    start_date timestamp without time zone NOT NULL,
    end_date timestamp without time zone NOT NULL,
    renewal_date timestamp without time zone,
    billing_cycle character varying(20) DEFAULT 'monthly'::character varying,
    amount numeric(12,2) DEFAULT 0.00 NOT NULL,
    currency character varying(10) DEFAULT 'INR'::character varying,
    auto_renew boolean DEFAULT true,
    provider character varying(50) DEFAULT 'razorpay'::character varying,
    provider_subscription_id character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.subscriptions OWNER TO postgres;

--
-- Data for Name: admins; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admins (id, name, email, login_id, password_hash, status, role, created_at, updated_at, last_login_at) FROM stdin;
admin_support_01	Support Representative	support@xenobiz.local	support_admin	$2a$10$KHsxvxyXjU07zLdRH.ty6OUgrNHl9sBc.QCEUCjrF1f16HYOxSGPC	active	SUPPORT_ADMIN	2026-08-18 17:46:06.060534	2026-08-18 17:46:06.060534	\N
admin_auditor_01	Audit Inspector	auditor@xenobiz.local	readonly_admin	$2a$10$dWU4Vy0L8TJrQtGKIX2yd..hhQcNWJ1Vasy5NsTRPD7oDMwie3z6y	active	READ_ONLY	2026-08-18 17:46:06.061405	2026-08-18 17:46:06.061405	\N
admin_sys_master	System Administrator	admin@xenobiz.local	admin	$2a$10$bRFHl7obrM6TyRhxHB6BMuuvxOwA1cf.btfu405zy./er0RpboG6S	active	ADMIN	2026-08-18 17:46:05.889841	2026-08-18 18:10:31.40528	2026-08-18 12:40:31.403
\.


--
-- Data for Name: app_configs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.app_configs (id, category, key, value, description, updated_by, updated_at) FROM stdin;
cfg_gen_app	general	app_name	"XenoBiz Business Manager"	Platform branding name	system	2026-08-18 17:46:06.071554
cfg_gen_ver	general	min_app_version	"1.2.0"	Minimum required client app version	system	2026-08-18 17:46:06.075137
cfg_reg_status	registration	allow_new_registrations	true	Allow new shop registrations	system	2026-08-18 17:46:06.075994
cfg_sub_trial	subscription	default_trial_days	14	Default free trial duration in days	system	2026-08-18 17:46:06.076822
cfg_sys_maint	system	maintenance_mode	false	Global platform maintenance mode	system	2026-08-18 17:46:06.077653
\.


--
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audit_logs (id, admin_id, admin_name, action, target_type, target_id, details, ip_address, created_at) FROM stdin;
log_seed_01	admin_sys_master	System Administrator	ADMIN_LOGIN	AUTH	admin_sys_master	{"message": "Initial system admin authentication"}	127.0.0.1	2026-08-18 17:46:06.086823
log_seed_02	admin_sys_master	System Administrator	SYSTEM_INITIALIZED	SYSTEM	xenobiz_db	{"message": "Seeded initial platform schema and master configurations"}	127.0.0.1	2026-08-18 17:46:06.090906
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers (id, shop_id, name, email, phone, city, state, country, status, total_spent, total_purchases, created_at, updated_at) FROM stdin;
cust_01	shop_novatech	Anand Varma	anand.varma@gmail.com	+91 98471 22334	Kochi	Kerala	India	active	12500.00	4	2026-08-18 17:46:06.063054	2026-08-18 17:46:06.063054
cust_02	shop_novatech	Priya Nambiar	priya.nambiar@yahoo.com	+91 98472 33445	Kochi	Kerala	India	active	4500.00	2	2026-08-18 17:46:06.068274	2026-08-18 17:46:06.068274
cust_03	shop_greenleaf	Suresh Kumar	suresh.k@gmail.com	+91 98761 11223	Bengaluru	Karnataka	India	active	8900.00	6	2026-08-18 17:46:06.06907	2026-08-18 17:46:06.06907
cust_04	shop_urbancraft	Kavita Menon	kavita.m@gmail.com	+91 99881 22334	Mumbai	Maharashtra	India	active	35000.00	1	2026-08-18 17:46:06.069853	2026-08-18 17:46:06.069853
\.


--
-- Data for Name: feature_flags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.feature_flags (id, key, name, description, is_enabled, environment, updated_by, updated_at) FROM stdin;
flag_sync	online_sync	Online Real-time Sync	Enable automatic WebSocket & background data sync for shops	t	production	system	2026-08-18 17:46:06.079468
flag_new_inv	new_invoice_ui	New POS Invoice Interface v2	Redesigned billing and invoice printing interface	t	production	system	2026-08-18 17:46:06.082885
flag_ai	ai_insights	AI Business Insights	Smart sales forecasting & inventory recommendations	f	beta	system	2026-08-18 17:46:06.084355
flag_exp	experimental_pos	Experimental Offline POS Engine	Local SQLite offline caching for high-volume cashiers	f	development	system	2026-08-18 17:46:06.085168
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payments (id, shop_id, subscription_id, plan_id, amount, currency, payment_method, provider, transaction_id, provider_payment_id, status, paid_at, failure_reason, created_at, updated_at) FROM stdin;
pay_nova_1	shop_novatech	sub_novatech_pro	plan_pro	999.00	INR	UPI	razorpay	TXN_NOVA_AUG2026	\N	successful	2026-08-17 12:16:05.907	\N	2026-08-18 17:46:05.913698	2026-08-18 17:46:05.913698
pay_nova_2	shop_novatech	sub_novatech_pro	plan_pro	999.00	INR	UPI	razorpay	TXN_NOVA_JUL2026	\N	successful	2026-07-18 12:16:05.907	\N	2026-08-18 17:46:05.920236	2026-08-18 17:46:05.920236
pay_green_1	shop_greenleaf	sub_greenleaf_basic	plan_basic	499.00	INR	Card	razorpay	TXN_GREEN_AUG2026	\N	successful	2026-08-08 12:16:05.907	\N	2026-08-18 17:46:05.92285	2026-08-18 17:46:05.92285
\.


--
-- Data for Name: plans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.plans (id, name, description, price, currency, billing_cycle, features, is_active, created_at, updated_at) FROM stdin;
plan_free	Free	Essential starter plan with basic invoicing and inventory tracking.	0.00	INR	monthly	["Basic Invoicing", "Up to 50 Products", "Single User Access", "14-Day Free Access"]	t	2026-08-18 17:46:05.881441	2026-08-18 17:46:05.881441
plan_basic	Basic	Standard plan for growing retail shops and small businesses.	499.00	INR	monthly	["Unlimited Invoices", "Unlimited Products", "Customer Due Tracking", "WhatsApp Sharing"]	t	2026-08-18 17:46:05.886082	2026-08-18 17:46:05.886082
plan_pro	Pro	Professional suite with advanced analytics, multi-user, and CRM.	999.00	INR	monthly	["All Basic Features", "Advanced POS Reports", "Tax/GST Export", "Priority Support"]	t	2026-08-18 17:46:05.887509	2026-08-18 17:46:05.887509
plan_premium	Premium	Enterprise solution for multi-outlet businesses and franchises.	2499.00	INR	yearly	["All Pro Features", "Multi-Store Sync", "Custom Domain", "Dedicated Account Manager"]	t	2026-08-18 17:46:05.888583	2026-08-18 17:46:05.888583
\.


--
-- Data for Name: shops; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shops (id, shop_name, owner_name, email, phone, address, city, state, country, postal_code, gst_number, business_type, login_id, password_hash, status, is_verified, role, created_at, updated_at, last_login_at) FROM stdin;
shop_greenleaf	GreenLeaf Supermarket	Anita Roy	greenleaf@xenobiz.local	+91 98765 43210	Plot 12, Main Market Road	Bengaluru	Karnataka	India	560001	29ABCDE5678G1Z2	Retail / Grocery	greenleaf_owner	$2a$10$CfYRZQna.DLMTIKnIXvOCOpYt43FfTHY5inSbgI52dtsxb9Hs9Ywu	active	t	OWNER	2026-08-18 17:46:05.902149	2026-08-18 17:46:05.902149	\N
shop_urbancraft	UrbanCraft Furniture	Vikram Mehta	urbancraft@xenobiz.local	+91 99887 76655	88 Industrial Area Phase 2	Mumbai	Maharashtra	India	400013	27XYZAB9876H1Z9	Furniture & Interiors	urbancraft_owner	$2a$10$CfYRZQna.DLMTIKnIXvOCOpYt43FfTHY5inSbgI52dtsxb9Hs9Ywu	inactive	t	OWNER	2026-08-18 17:46:05.903329	2026-08-18 17:46:05.903329	\N
shop_6126b8ba	Test Merchant	Test Merchant	testmerchant@xenobiz.local	+91 90000 11111	\N	\N	\N	India	\N	\N	\N	testmerchant	$2a$10$CfYRZQna.DLMTIKnIXvOCOpYt43FfTHY5inSbgI52dtsxb9Hs9Ywu	active	t	OWNER	2026-08-18 17:46:05.90468	2026-08-18 17:46:05.90468	\N
shop_a1c997ce	Phone Merchant	Phone Merchant	9876543210@xenobiz.local	9876543210	\N	\N	\N	India	\N	\N	\N	phonemerchant	$2a$10$CfYRZQna.DLMTIKnIXvOCOpYt43FfTHY5inSbgI52dtsxb9Hs9Ywu	active	t	OWNER	2026-08-18 17:46:05.905916	2026-08-18 17:46:05.905916	\N
shop_a543d383	hari	hari	hari@gmail.com	+91 91234 56789	\N	\N	\N	India	\N	\N	\N	hari	$2a$10$CfYRZQna.DLMTIKnIXvOCOpYt43FfTHY5inSbgI52dtsxb9Hs9Ywu	active	t	OWNER	2026-08-18 17:46:05.907093	2026-08-18 17:46:05.907093	\N
shop_novatech	NovaTech Electronics	Rahul Sharma	demo@xenobiz.local	+91 98470 11223	Suite 402, Tech Park, MG Road	Kochi	Kerala	India	682016	32AAACN1234F1Z5	Electronics & Gadgets	novatech_owner	$2a$10$CfYRZQna.DLMTIKnIXvOCOpYt43FfTHY5inSbgI52dtsxb9Hs9Ywu	active	t	OWNER	2026-08-18 17:46:05.895992	2026-08-18 17:52:44.378888	2026-08-18 12:22:44.378
shop_b1925bcd	Nivin	Nivin	nivin@gmail.com	\N	\N	\N	\N	India	\N	\N	\N	nivin	$2a$10$Gq6jk62CMnd0yyjuD8J/9.vJjJ.RNnAUMMkX667xPXKdewPIfDdXS	active	t	OWNER	2026-08-18 22:59:07.5542	2026-08-19 16:17:38.7875	2026-08-19 10:47:38.786
\.


--
-- Data for Name: subscriptions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subscriptions (id, shop_id, plan_id, plan_name, status, start_date, end_date, renewal_date, billing_cycle, amount, currency, auto_renew, provider, provider_subscription_id, created_at, updated_at) FROM stdin;
sub_novatech_pro	shop_novatech	plan_pro	Pro	active	2026-06-19 12:16:05.907	2026-09-17 12:16:05.907	2026-09-17 12:16:05.907	monthly	999.00	INR	t	razorpay	\N	2026-08-18 17:46:05.908684	2026-08-18 17:46:05.908684
sub_greenleaf_basic	shop_greenleaf	plan_basic	Basic	active	2026-07-19 12:16:05.907	2026-09-17 12:16:05.907	2026-09-17 12:16:05.907	monthly	499.00	INR	t	razorpay	\N	2026-08-18 17:46:05.921542	2026-08-18 17:46:05.921542
sub_urbancraft_free	shop_urbancraft	plan_free	Free	trial	2026-08-18 12:16:05.907	2026-09-01 12:16:05.907	2026-09-01 12:16:05.907	monthly	0.00	INR	t	system	\N	2026-08-18 17:46:05.923913	2026-08-18 17:46:05.923913
sub_29d86131	shop_b1925bcd	plan_free	Free	trial	2026-08-18 17:29:07.589	2026-09-01 17:29:07.589	2026-09-01 17:29:07.589	monthly	0.00	INR	t	system	\N	2026-08-18 22:59:07.591087	2026-08-18 22:59:07.591087
\.


--
-- Name: admins admins_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_email_key UNIQUE (email);


--
-- Name: admins admins_login_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_login_id_key UNIQUE (login_id);


--
-- Name: admins admins_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- Name: app_configs app_configs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_configs
    ADD CONSTRAINT app_configs_pkey PRIMARY KEY (id);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: feature_flags feature_flags_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feature_flags
    ADD CONSTRAINT feature_flags_key_key UNIQUE (key);


--
-- Name: feature_flags feature_flags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feature_flags
    ADD CONSTRAINT feature_flags_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: plans plans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plans
    ADD CONSTRAINT plans_pkey PRIMARY KEY (id);


--
-- Name: shops shops_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shops
    ADD CONSTRAINT shops_email_key UNIQUE (email);


--
-- Name: shops shops_login_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shops
    ADD CONSTRAINT shops_login_id_key UNIQUE (login_id);


--
-- Name: shops shops_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shops
    ADD CONSTRAINT shops_pkey PRIMARY KEY (id);


--
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- Name: app_configs uq_config_category_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_configs
    ADD CONSTRAINT uq_config_category_key UNIQUE (category, key);


--
-- Name: idx_admins_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_admins_email ON public.admins USING btree (email);


--
-- Name: idx_admins_login_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_admins_login_id ON public.admins USING btree (login_id);


--
-- Name: idx_audit_logs_action; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_audit_logs_action ON public.audit_logs USING btree (action);


--
-- Name: idx_audit_logs_admin; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_audit_logs_admin ON public.audit_logs USING btree (admin_id);


--
-- Name: idx_customers_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_customers_email ON public.customers USING btree (email);


--
-- Name: idx_customers_shop; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_customers_shop ON public.customers USING btree (shop_id);


--
-- Name: idx_payments_plan; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_payments_plan ON public.payments USING btree (plan_id);


--
-- Name: idx_payments_shop; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_payments_shop ON public.payments USING btree (shop_id);


--
-- Name: idx_payments_subscription; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_payments_subscription ON public.payments USING btree (subscription_id);


--
-- Name: idx_payments_transaction; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_payments_transaction ON public.payments USING btree (transaction_id);


--
-- Name: idx_shops_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_shops_email ON public.shops USING btree (email);


--
-- Name: idx_shops_login_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_shops_login_id ON public.shops USING btree (login_id);


--
-- Name: idx_subscriptions_plan; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_subscriptions_plan ON public.subscriptions USING btree (plan_id);


--
-- Name: idx_subscriptions_shop; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_subscriptions_shop ON public.subscriptions USING btree (shop_id);


--
-- Name: customers fk_customer_shop; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT fk_customer_shop FOREIGN KEY (shop_id) REFERENCES public.shops(id) ON DELETE SET NULL;


--
-- Name: payments fk_payment_plan; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT fk_payment_plan FOREIGN KEY (plan_id) REFERENCES public.plans(id) ON DELETE SET NULL;


--
-- Name: payments fk_payment_shop; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT fk_payment_shop FOREIGN KEY (shop_id) REFERENCES public.shops(id) ON DELETE CASCADE;


--
-- Name: payments fk_payment_subscription; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT fk_payment_subscription FOREIGN KEY (subscription_id) REFERENCES public.subscriptions(id) ON DELETE SET NULL;


--
-- Name: subscriptions fk_subscription_plan; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT fk_subscription_plan FOREIGN KEY (plan_id) REFERENCES public.plans(id);


--
-- Name: subscriptions fk_subscription_shop; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT fk_subscription_shop FOREIGN KEY (shop_id) REFERENCES public.shops(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict vGdXuvaEncOjcbVn5JmRXdk9x0yg135ugExbvp8tvAkQMAglCX9lkx7Yt4imgYd

