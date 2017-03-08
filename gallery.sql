--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.1
-- Dumped by pg_dump version 9.6.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track execution statistics of all SQL statements executed';


SET search_path = public, pg_catalog;

--
-- Name: application_designed_for; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE application_designed_for AS ENUM (
    'patients',
    'clinicians',
    'clinicians & patients',
    'IT'
);


ALTER TYPE application_designed_for OWNER TO postgres;

--
-- Name: application_states; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE application_states AS ENUM (
    'draft',
    'submitted',
    'published',
    'rejected'
);


ALTER TYPE application_states OWNER TO postgres;

--
-- Name: app_tsidx(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION app_tsidx() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    NEW.tsv :=
       setweight(to_tsvector('pg_catalog.english', coalesce(new.name,'')), 'A') ||
       setweight(to_tsvector('pg_catalog.english', coalesce(new.description,'')), 'B') ||
       setweight(to_tsvector('pg_catalog.english', coalesce(new.description_short,'') || ' ' || coalesce(new.org_name, '') ), 'C') ||
       setweight(to_tsvector('pg_catalog.english', coalesce(new.org_description, '') || ' ' || coalesce(new.pricing_description, '')), 'D');
    return new;
  END
$$;


ALTER FUNCTION public.app_tsidx() OWNER TO postgres;

--
-- Name: updated_at(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    IF (NEW != OLD) THEN
      NEW.updated_at = CURRENT_TIMESTAMP;
      RETURN NEW;
    END IF;
    RETURN OLD;
  END;
$$;


ALTER FUNCTION public.updated_at() OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: applications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE applications (
    id integer NOT NULL,
    name text NOT NULL,
    icon jsonb,
    description_short text,
    description text,
    url text,
    email text,
    sales_contact text,
    designed_for application_designed_for,
    screenshot_1 jsonb,
    screenshot_2 jsonb,
    screenshot_3 jsonb,
    video_urls text,
    pricing_description text,
    suggested_category text,
    suggested_ehr text,
    suggested_specialty text,
    org_name text,
    org_description text,
    org_url text,
    demo_type text,
    demo_launch_url text,
    demo_redirect_url text,
    demo_requires_patient boolean,
    demo_patient_ids text,
    tsv tsvector,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    CONSTRAINT applications_name_check CHECK ((name <> ''::text))
);


ALTER TABLE applications OWNER TO postgres;

--
-- Name: applications_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE applications_categories (
    id integer NOT NULL,
    application_id integer,
    category_id integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone
);


ALTER TABLE applications_categories OWNER TO postgres;

--
-- Name: applications_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE applications_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE applications_categories_id_seq OWNER TO postgres;

--
-- Name: applications_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE applications_categories_id_seq OWNED BY applications_categories.id;


--
-- Name: applications_ehr; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE applications_ehr (
    id integer NOT NULL,
    application_id integer,
    url text,
    ehr_id integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone
);


ALTER TABLE applications_ehr OWNER TO postgres;

--
-- Name: applications_ehr_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE applications_ehr_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE applications_ehr_id_seq OWNER TO postgres;

--
-- Name: applications_ehr_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE applications_ehr_id_seq OWNED BY applications_ehr.id;


--
-- Name: applications_fhir; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE applications_fhir (
    id integer NOT NULL,
    application_id integer,
    fhir_id integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone
);


ALTER TABLE applications_fhir OWNER TO postgres;

--
-- Name: applications_fhir_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE applications_fhir_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE applications_fhir_id_seq OWNER TO postgres;

--
-- Name: applications_fhir_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE applications_fhir_id_seq OWNED BY applications_fhir.id;


--
-- Name: applications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE applications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE applications_id_seq OWNER TO postgres;

--
-- Name: applications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE applications_id_seq OWNED BY applications.id;


--
-- Name: applications_operating_systems; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE applications_operating_systems (
    id integer NOT NULL,
    application_id integer,
    url text,
    operating_system_id integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone
);


ALTER TABLE applications_operating_systems OWNER TO postgres;

--
-- Name: applications_operating_systems_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE applications_operating_systems_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE applications_operating_systems_id_seq OWNER TO postgres;

--
-- Name: applications_operating_systems_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE applications_operating_systems_id_seq OWNED BY applications_operating_systems.id;


--
-- Name: applications_pricing; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE applications_pricing (
    id integer NOT NULL,
    application_id integer,
    url text,
    pricing_id integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone
);


ALTER TABLE applications_pricing OWNER TO postgres;

--
-- Name: applications_pricing_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE applications_pricing_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE applications_pricing_id_seq OWNER TO postgres;

--
-- Name: applications_pricing_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE applications_pricing_id_seq OWNED BY applications_pricing.id;


--
-- Name: applications_specialties; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE applications_specialties (
    id integer NOT NULL,
    application_id integer,
    specialty_id integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone
);


ALTER TABLE applications_specialties OWNER TO postgres;

--
-- Name: applications_specialties_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE applications_specialties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE applications_specialties_id_seq OWNER TO postgres;

--
-- Name: applications_specialties_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE applications_specialties_id_seq OWNED BY applications_specialties.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE categories (
    id integer NOT NULL,
    name text NOT NULL,
    slug text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    CONSTRAINT categories_name_check CHECK ((name <> ''::text)),
    CONSTRAINT categories_slug_check CHECK ((slug <> ''::text))
);


ALTER TABLE categories OWNER TO postgres;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE categories_id_seq OWNER TO postgres;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE categories_id_seq OWNED BY categories.id;


--
-- Name: ehr; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE ehr (
    id integer NOT NULL,
    name text NOT NULL,
    slug text NOT NULL,
    url_pattern text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    CONSTRAINT ehr_name_check CHECK ((name <> ''::text)),
    CONSTRAINT ehr_slug_check CHECK ((slug <> ''::text))
);


ALTER TABLE ehr OWNER TO postgres;

--
-- Name: ehr_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ehr_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ehr_id_seq OWNER TO postgres;

--
-- Name: ehr_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ehr_id_seq OWNED BY ehr.id;


--
-- Name: fhir; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE fhir (
    id integer NOT NULL,
    name text NOT NULL,
    slug text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    CONSTRAINT fhir_name_check CHECK ((name <> ''::text)),
    CONSTRAINT fhir_slug_check CHECK ((slug <> ''::text))
);


ALTER TABLE fhir OWNER TO postgres;

--
-- Name: fhir_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE fhir_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE fhir_id_seq OWNER TO postgres;

--
-- Name: fhir_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE fhir_id_seq OWNED BY fhir.id;


--
-- Name: listings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE listings (
    id integer NOT NULL,
    application_id integer,
    status application_states DEFAULT 'draft'::application_states,
    is_featured boolean DEFAULT false NOT NULL,
    slug text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    CONSTRAINT listings_slug_check CHECK ((slug <> ''::text))
);


ALTER TABLE listings OWNER TO postgres;

--
-- Name: listings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE listings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE listings_id_seq OWNER TO postgres;

--
-- Name: listings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE listings_id_seq OWNED BY listings.id;


--
-- Name: operating_systems; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE operating_systems (
    id integer NOT NULL,
    name text NOT NULL,
    slug text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    CONSTRAINT operating_systems_name_check CHECK ((name <> ''::text)),
    CONSTRAINT operating_systems_slug_check CHECK ((slug <> ''::text))
);


ALTER TABLE operating_systems OWNER TO postgres;

--
-- Name: operating_systems_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE operating_systems_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE operating_systems_id_seq OWNER TO postgres;

--
-- Name: operating_systems_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE operating_systems_id_seq OWNED BY operating_systems.id;


--
-- Name: pricing; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE pricing (
    id integer NOT NULL,
    name text NOT NULL,
    slug text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    CONSTRAINT pricing_name_check CHECK ((name <> ''::text)),
    CONSTRAINT pricing_slug_check CHECK ((slug <> ''::text))
);


ALTER TABLE pricing OWNER TO postgres;

--
-- Name: pricing_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE pricing_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pricing_id_seq OWNER TO postgres;

--
-- Name: pricing_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE pricing_id_seq OWNED BY pricing.id;


--
-- Name: specialties; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE specialties (
    id integer NOT NULL,
    name text NOT NULL,
    slug text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    CONSTRAINT specialties_name_check CHECK ((name <> ''::text)),
    CONSTRAINT specialties_slug_check CHECK ((slug <> ''::text))
);


ALTER TABLE specialties OWNER TO postgres;

--
-- Name: specialties_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE specialties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE specialties_id_seq OWNER TO postgres;

--
-- Name: specialties_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE specialties_id_seq OWNED BY specialties.id;


--
-- Name: applications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY applications ALTER COLUMN id SET DEFAULT nextval('applications_id_seq'::regclass);


--
-- Name: applications_categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY applications_categories ALTER COLUMN id SET DEFAULT nextval('applications_categories_id_seq'::regclass);


--
-- Name: applications_ehr id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY applications_ehr ALTER COLUMN id SET DEFAULT nextval('applications_ehr_id_seq'::regclass);


--
-- Name: applications_fhir id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY applications_fhir ALTER COLUMN id SET DEFAULT nextval('applications_fhir_id_seq'::regclass);


--
-- Name: applications_operating_systems id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY applications_operating_systems ALTER COLUMN id SET DEFAULT nextval('applications_operating_systems_id_seq'::regclass);


--
-- Name: applications_pricing id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY applications_pricing ALTER COLUMN id SET DEFAULT nextval('applications_pricing_id_seq'::regclass);


--
-- Name: applications_specialties id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY applications_specialties ALTER COLUMN id SET DEFAULT nextval('applications_specialties_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY categories ALTER COLUMN id SET DEFAULT nextval('categories_id_seq'::regclass);


--
-- Name: ehr id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ehr ALTER COLUMN id SET DEFAULT nextval('ehr_id_seq'::regclass);


--
-- Name: fhir id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY fhir ALTER COLUMN id SET DEFAULT nextval('fhir_id_seq'::regclass);


--
-- Name: listings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY listings ALTER COLUMN id SET DEFAULT nextval('listings_id_seq'::regclass);


--
-- Name: operating_systems id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY operating_systems ALTER COLUMN id SET DEFAULT nextval('operating_systems_id_seq'::regclass);


--
-- Name: pricing id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pricing ALTER COLUMN id SET DEFAULT nextval('pricing_id_seq'::regclass);


--
-- Name: specialties id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY specialties ALTER COLUMN id SET DEFAULT nextval('specialties_id_seq'::regclass);


--
-- Data for Name: applications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY applications (id, name, icon, description_short, description, url, email, sales_contact, designed_for, screenshot_1, screenshot_2, screenshot_3, video_urls, pricing_description, suggested_category, suggested_ehr, suggested_specialty, org_name, org_description, org_url, demo_type, demo_launch_url, demo_redirect_url, demo_requires_patient, demo_patient_ids, tsv, created_at, updated_at) FROM stdin;
3	Cardiac Risk	{"url": "http://res.cloudinary.com/hvhxvnxtg/image/upload/v1485968486/hrmkhyspg4vwptt5frzp.png", "width": 256, "format": "png", "height": 256, "service": "cloudinary", "secure_url": "https://res.cloudinary.com/hvhxvnxtg/image/upload/v1485968486/hrmkhyspg4vwptt5frzp.png", "external_id": "hrmkhyspg4vwptt5frzp"}	Estimate a patient's 10-year risk of heart attack or stroke (Reynolds Risk Score) with an intuitive interactive display.	The widely-used Reynolds Risk Score is used to estimate the 10-year cardiovascular risk of an individual. For patients and clinicians alike, this calculation is often reported in an esoteric, hard-to-read lab report.\n\nFor our model of an improved Reynolds Risk Score reporting SMART App, we took an inspired Creative Commons design, the work of designer David McCandless, whose “Blood Work Cardiology Result” appeared in the Wired Magazine article “The Blood Test Gets a Makeover” (Wired 18.12, December 2010) and was published under a Creative Commons license. The resulting SMART Cardiac Risk app presents relevant patient vitals and lab measurements and the calculated Reynolds Risk Score, along with a succinct, patient-friendly explanation for each result. The app’s presentation produces a highly attractive document to hand to a patient. Furthermore, the SMART Cardiac Risk app also offers simulation: the clinician (or patient) can make changes to one or more of the patient’s vitals or lab results to see how the patient’s current Reynolds Risk Score could be improved.	http://smarthealthit.org	info@smartplatforms.org	\N	clinicians & patients	{"url": "http://res.cloudinary.com/hvhxvnxtg/image/upload/v1485968394/idhkhwzirbjvkokeubtp.png", "width": 1444, "format": "png", "height": 1083, "service": "cloudinary", "secure_url": "https://res.cloudinary.com/hvhxvnxtg/image/upload/v1485968394/idhkhwzirbjvkokeubtp.png", "external_id": "idhkhwzirbjvkokeubtp"}	{}	{}	https://www.youtube.com/watch?v=GWG92PkUcDw	Open source code at: https://github.com/smart-on-fhir/cardiac-risk-app				Boston Children's Hospital		http://website.com	DSTU-2	https://apps-dstu2.smarthealthit.org/cardiac-risk/launch.html	https://apps-dstu2.smarthealthit.org/cardiac-risk/	t	1768562,1577780,1627321,1520204,1551992,1272431,2347217	'/smart-on-fhir/cardiac-risk-app':210 '10':15B,184C '18.12':84B '2010':86B 'alik':26B 'along':114B 'also':145B 'app':52B,100B,126B,144B 'appear':71B 'articl':76B 'attack':189C 'attract':132B 'blood':67B,78B 'boston':200C 'calcul':28B,110B 'cardiac':1A,98B,142B 'cardiolog':69B 'cardiovascular':17B 'chang':154B 'children':201C 'clinician':25B,149B 'code':206 'common':58B,93B 'could':177B 'creativ':57B,92B 'current':173B 'david':64B 'decemb':85B 'design':59B,63B 'display':199C 'document':133B 'esoter':34B 'estim':13B,180C 'explan':121B 'friend':120B 'furthermor':139B 'get':80B 'github.com':209 'github.com/smart-on-fhir/cardiac-risk-app':208 'hand':135B 'hard':36B 'hard-to-read':35B 'heart':188C 'high':131B 'hospit':203C 'improv':46B,179B 'individu':21B 'inspir':56B 'interact':198C 'intuit':197C 'lab':39B,106B,165B 'licens':94B 'magazin':75B 'make':153B 'makeov':82B 'mccandless':65B 'measur':107B 'model':43B 'offer':146B 'often':30B 'one':156B 'open':204 'patient':23B,103B,119B,138B,151B,161B,171B,182C 'patient-friend':118B 'present':101B,128B 'produc':129B 'publish':89B 'read':38B 'relev':102B 'report':31B,40B,50B 'result':70B,96B,124B,166B 'reynold':7B,47B,111B,174B,192C 'risk':2A,8B,18B,48B,99B,112B,143B,175B,186C,193C 'score':9B,49B,113B,176B,194C 'see':168B 'simul':147B 'smart':51B,97B,141B 'sourc':205 'stroke':191C 'succinct':117B 'test':79B 'took':54B 'use':6B,11B 'vital':104B,163B 'whose':66B 'wide':5B 'widely-us':4B 'wire':74B,83B 'work':61B,68B 'year':16B,185C	2017-02-01 13:23:15.472453+00	2017-02-05 21:26:28.167621+00
4	BP Centiles v1 (Open Source)	{"url": "http://res.cloudinary.com/hvhxvnxtg/image/upload/v1485970056/oometxjop0pijm4zajga.png", "width": 256, "format": "png", "height": 256, "service": "cloudinary", "secure_url": "https://res.cloudinary.com/hvhxvnxtg/image/upload/v1485970056/oometxjop0pijm4zajga.png", "external_id": "oometxjop0pijm4zajga"}	Calculate a child's blood pressure percentiles, normalized by age, sex, and height.	Interpreting blood pressure measurements for children is complicated by the need to account for a constantly changing body size. It is time-consuming to calculate and/or do data entry, yet assessment of blood pressure percentiles is medically recommended from the age of 3 onward because 75% of cases of pediatric hypertension and 90% of cases of prehypertension in children from 3 to 18 years of age go undetected.\n\nThe BP Centiles app reads a child’s relevant vitals and calculates systolic and diastolic blood pressure percentiles normalized by age, sex, and height The app also includes a pop-up calculator and a graphical history of the child's blood pressure percentile, enabling full screening at each visit.\n\nColor coding reveals at a glance whether individual readings are normal (green), prehypertensive (yellow), hypertensive (red) or hypotensive (blue). Users can zoom in on a group of readings for more information and apply various filters to help them interpret the measurements—such as looking only at BPs measured in the legs, sitting down or by machine.\n\nBP Centiles was developed in collaboration with MedAppTech.	http://smarthealthit.org	gallery@smarthealthit.org	\N	clinicians	{"url": "http://res.cloudinary.com/hvhxvnxtg/image/upload/v1485970013/mgwmnppkax6acnuhkgdm.png", "width": 1444, "format": "png", "height": 1083, "service": "cloudinary", "secure_url": "https://res.cloudinary.com/hvhxvnxtg/image/upload/v1485970013/mgwmnppkax6acnuhkgdm.png", "external_id": "mgwmnppkax6acnuhkgdm"}	{}	{}	https://www.youtube.com/watch?v=WaKHG1ViLds	Open source code at: https://github.com/smart-on-fhir/bp-centiles-app				Boston Children's Hospital		http://website.com	DSTU-2	https://apps-dstu2.smarthealthit.org/bp-centiles/launch.html	https://apps-dstu2.smarthealthit.org/bp-centiles/	t	99912345,9995679,1551992	'/smart-on-fhir/bp-centiles-app':212 '18':69B '3':49B,67B '75':52B '90':59B 'account':18B 'age':47B,72B,95B,198C 'also':101B 'and/or':32B 'app':78B,100B 'appli':157B 'assess':37B 'blood':7B,39B,90B,116B,193C 'blue':143B 'bodi':23B 'boston':202C 'bp':1A,76B,181B 'bps':171B 'calcul':31B,86B,107B,189C 'case':54B,61B 'centil':2A,77B,182B 'chang':22B 'child':81B,114B,191C 'children':11B,65B,203C 'code':126B,208 'collabor':186B 'color':125B 'complic':13B 'constant':21B 'consum':29B 'data':34B 'develop':184B 'diastol':89B 'enabl':119B 'entri':35B 'filter':159B 'full':120B 'github.com':211 'github.com/smart-on-fhir/bp-centiles-app':210 'glanc':130B 'go':73B 'graphic':110B 'green':136B 'group':150B 'height':98B,201C 'help':161B 'histori':111B 'hospit':205C 'hypertens':57B,139B 'hypotens':142B 'includ':102B 'individu':132B 'inform':155B 'interpret':6B,163B 'leg':175B 'look':168B 'machin':180B 'measur':9B,165B,172B 'medapptech':188B 'medic':43B 'need':16B 'normal':93B,135B,196C 'onward':50B 'open':4A,206 'pediatr':56B 'percentil':41B,92B,118B,195C 'pop':105B 'pop-up':104B 'prehypertens':63B,137B 'pressur':8B,40B,91B,117B,194C 'read':79B,133B,152B 'recommend':44B 'red':140B 'relev':83B 'reveal':127B 'screen':121B 'sex':96B,199C 'sit':176B 'size':24B 'sourc':5A,207 'systol':87B 'time':28B 'time-consum':27B 'undetect':74B 'user':144B 'v1':3A 'various':158B 'visit':124B 'vital':84B 'whether':131B 'year':70B 'yellow':138B 'yet':36B 'zoom':146B	2017-02-01 17:29:55.972201+00	2017-02-19 00:41:14.692477+00
2	Growth Chart	{"url": "http://res.cloudinary.com/hvhxvnxtg/image/upload/v1485896561/ywqghaezona4svfhiauq.png", "width": 256, "format": "png", "height": 256, "service": "cloudinary", "secure_url": "https://res.cloudinary.com/hvhxvnxtg/image/upload/v1485896561/ywqghaezona4svfhiauq.png", "external_id": "ywqghaezona4svfhiauq"}	Concise, interactive view of a child’s growth over time.	The Growth Chart app was developed from a unique collaboration among SMART, Fjord service design consultancy, MedAppTech  software development group, and clinicians. This App demonstrates a high-performance, concise, minimal-click presentation of a child’s growth over time.\n\n Interactive Graphs, Data Table, Parent View:\n- Chart Auto-select\n- CDC-like vertical format\n- Plot against two charts\n- Annotations\n- Percentile/bone-age/mid-parental height estimates\n- CDC/WHO/Fenton charts (expandable)\n\n\nSupport for Ambulatory and NICU uses with:\n- Gestation corrections\n- Bone Age presentation\n- Growth point comparison with velocity\n- Print-out formats for Graphs, Data Table, and Parent View	http://smarthealthit.org	gallery@smarthealthit.org	\N	clinicians	{"url": "http://res.cloudinary.com/hvhxvnxtg/image/upload/v1485896584/wm9f9tzucmojow68evrs.png", "width": 1444, "format": "png", "height": 1083, "service": "cloudinary", "secure_url": "https://res.cloudinary.com/hvhxvnxtg/image/upload/v1485896584/wm9f9tzucmojow68evrs.png", "external_id": "wm9f9tzucmojow68evrs"}	{"url": "http://res.cloudinary.com/hvhxvnxtg/image/upload/v1485896595/qoqg04pamvnbx3c8trsc.png", "width": 1418, "format": "png", "height": 1083, "service": "cloudinary", "secure_url": "https://res.cloudinary.com/hvhxvnxtg/image/upload/v1485896595/qoqg04pamvnbx3c8trsc.png", "external_id": "qoqg04pamvnbx3c8trsc"}	{"url": "http://res.cloudinary.com/hvhxvnxtg/image/upload/v1485896604/ciezehjlqv8yrrbjsu7m.png", "width": 1417, "format": "png", "height": 1083, "service": "cloudinary", "secure_url": "https://res.cloudinary.com/hvhxvnxtg/image/upload/v1485896604/ciezehjlqv8yrrbjsu7m.png", "external_id": "ciezehjlqv8yrrbjsu7m"}		Open source code at: \nhttps://github.com/smart-on-fhir/growth-chart-app				Boston Children's Hospital		http://website.com	DSTU-2	https://apps-dstu2.smarthealthit.org/growth-chart/launch.html	https://apps-dstu2.smarthealthit.org/growth-chart/	t	1482713,7777703,7777705,7777701,7777704,99912345,7777702	'/smart-on-fhir/growth-chart-app':118 'age':80B 'ambulatori':72B 'among':13B 'annot':63B 'app':6B,26B 'auto':52B 'auto-select':51B 'bone':79B 'boston':108C 'cdc':55B 'cdc-like':54B 'cdc/who/fenton':67B 'chart':2A,5B,50B,62B,68B 'child':39B,103C 'children':109C 'click':35B 'clinician':24B 'code':114 'collabor':12B 'comparison':84B 'concis':32B,98C 'consult':18B 'correct':78B 'data':46B,93B 'demonstr':27B 'design':17B 'develop':8B,21B 'estim':66B 'expand':69B 'fjord':15B 'format':58B,90B 'gestat':77B 'github.com':117 'github.com/smart-on-fhir/growth-chart-app':116 'graph':45B,92B 'group':22B 'growth':1A,4B,41B,82B,105C 'height':65B 'high':30B 'high-perform':29B 'hospit':111C 'interact':44B,99C 'like':56B 'medapptech':19B 'minim':34B 'minimal-click':33B 'nicu':74B 'open':112 'parent':48B,96B 'percentile/bone-age/mid-parental':64B 'perform':31B 'plot':59B 'point':83B 'present':36B,81B 'print':88B 'print-out':87B 'select':53B 'servic':16B 'smart':14B 'softwar':20B 'sourc':113 'support':70B 'tabl':47B,94B 'time':43B,107C 'two':61B 'uniqu':11B 'use':75B 'veloc':86B 'vertic':57B 'view':49B,97B,100C	2017-01-31 21:03:31.847651+00	2017-02-19 00:42:06.377562+00
\.


--
-- Data for Name: applications_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY applications_categories (id, application_id, category_id, created_at, updated_at) FROM stdin;
9	4	9	2017-02-01 17:29:55.972201+00	\N
7	3	9	2017-02-01 13:23:15.472453+00	\N
6	3	8	2017-02-01 13:23:15.472453+00	\N
8	4	3	2017-02-01 17:29:55.972201+00	\N
5	3	3	2017-02-01 13:23:15.472453+00	\N
4	2	8	2017-01-31 21:03:31.847651+00	\N
3	2	3	2017-01-31 21:03:31.847651+00	\N
\.


--
-- Name: applications_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('applications_categories_id_seq', 127, true);


--
-- Data for Name: applications_ehr; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY applications_ehr (id, application_id, url, ehr_id, created_at, updated_at) FROM stdin;
2	3	https://code.cerner.com/app/cardiac-risk	3	2017-02-01 17:30:17.424192+00	\N
19	4	\N	3	2017-02-14 15:09:00.298204+00	\N
1	2	https://code.cerner.com/app/pediatric-growth-chart	3	2017-01-31 21:03:31.847651+00	\N
3	2	\N	4	2017-02-01 18:26:04.420689+00	\N
\.


--
-- Name: applications_ehr_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('applications_ehr_id_seq', 30, true);


--
-- Data for Name: applications_fhir; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY applications_fhir (id, application_id, fhir_id, created_at, updated_at) FROM stdin;
3	3	2	2017-02-01 13:23:15.472453+00	\N
4	4	2	2017-02-01 17:29:55.972201+00	\N
2	2	2	2017-01-31 21:03:31.847651+00	\N
\.


--
-- Name: applications_fhir_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('applications_fhir_id_seq', 54, true);


--
-- Name: applications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('applications_id_seq', 53, true);


--
-- Data for Name: applications_operating_systems; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY applications_operating_systems (id, application_id, url, operating_system_id, created_at, updated_at) FROM stdin;
3	3	\N	3	2017-02-01 13:23:15.472453+00	\N
4	4	\N	3	2017-02-01 17:29:55.972201+00	\N
2	2	\N	3	2017-01-31 21:03:31.847651+00	\N
\.


--
-- Name: applications_operating_systems_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('applications_operating_systems_id_seq', 59, true);


--
-- Data for Name: applications_pricing; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY applications_pricing (id, application_id, url, pricing_id, created_at, updated_at) FROM stdin;
5	3	\N	1	2017-02-01 13:23:15.472453+00	\N
4	3	\N	2	2017-02-01 13:23:15.472453+00	\N
7	4	\N	1	2017-02-01 17:29:55.972201+00	\N
6	4	\N	2	2017-02-01 17:29:55.972201+00	\N
3	2	\N	1	2017-01-31 21:03:31.847651+00	\N
2	2	\N	2	2017-01-31 21:03:31.847651+00	\N
\.


--
-- Name: applications_pricing_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('applications_pricing_id_seq', 55, true);


--
-- Data for Name: applications_specialties; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY applications_specialties (id, application_id, specialty_id, created_at, updated_at) FROM stdin;
3	3	2	2017-02-01 13:23:15.472453+00	\N
4	4	2	2017-02-01 17:29:55.972201+00	\N
5	4	8	2017-02-01 17:29:55.972201+00	\N
2	2	8	2017-01-31 21:03:31.847651+00	\N
\.


--
-- Name: applications_specialties_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('applications_specialties_id_seq', 27, true);


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY categories (id, name, slug, created_at, updated_at) FROM stdin;
1	Care Coordination	care-coordination	2017-01-31 18:53:09.600017+00	\N
2	Clinical Research	clinical-research	2017-01-31 18:53:09.600017+00	\N
3	Data Visualization	data-visualization	2017-01-31 18:53:09.600017+00	\N
4	Disease Management	disease-management	2017-01-31 18:53:09.600017+00	\N
5	Genomics	genomics	2017-01-31 18:53:09.600017+00	\N
6	Medication	medication	2017-01-31 18:53:09.600017+00	\N
7	Patient Engagement	patient-engagement	2017-01-31 18:53:09.600017+00	\N
8	Population Health	population-health	2017-01-31 18:53:09.600017+00	\N
9	Risk Calculation	risk-calculation	2017-01-31 18:53:09.600017+00	\N
10	FHIR Tools	fhir-tools	2017-01-31 18:53:09.600017+00	\N
\.


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('categories_id_seq', 10, true);


--
-- Data for Name: ehr; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ehr (id, name, slug, url_pattern, created_at, updated_at) FROM stdin;
1	Allscripts	allscripts	https://allscripts-store.prod.iapps.com/	2017-01-31 18:53:09.600017+00	\N
2	Athena Health	athena-health	http://www.athenahealth.com/healthcare-technology-partners	2017-01-31 18:53:09.600017+00	\N
3	Cerner	cerner	https://code.cerner.com/app/	2017-01-31 18:53:09.600017+00	\N
4	Epic	epic		2017-01-31 18:53:09.600017+00	\N
\.


--
-- Name: ehr_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ehr_id_seq', 1, false);


--
-- Data for Name: fhir; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY fhir (id, name, slug, created_at, updated_at) FROM stdin;
1	DSTU 1	dstu-1	2017-01-31 18:53:09.600017+00	\N
2	DSTU 2	dstu-2	2017-01-31 18:53:09.600017+00	\N
3	STU 3	stu-3	2017-01-31 18:53:09.600017+00	\N
\.


--
-- Name: fhir_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('fhir_id_seq', 3, true);


--
-- Data for Name: listings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY listings (id, application_id, status, is_featured, slug, created_at, updated_at) FROM stdin;
2	2	published	t	growth-chart	2017-01-31 21:03:31.847651+00	2017-02-01 17:30:39.457688+00
3	3	published	t	cardiac-risk	2017-02-01 13:23:15.472453+00	2017-02-01 17:30:56.074556+00
4	4	published	t	bp-centiles	2017-02-01 17:29:55.972201+00	2017-02-01 17:32:05.165602+00
\.


--
-- Name: listings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('listings_id_seq', 53, true);


--
-- Data for Name: operating_systems; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY operating_systems (id, name, slug, created_at, updated_at) FROM stdin;
1	iOS	ios	2017-01-31 18:53:09.600017+00	\N
2	Android	android	2017-01-31 18:53:09.600017+00	\N
3	Web	web	2017-01-31 18:53:09.600017+00	\N
4	Mac	mac	2017-01-31 18:53:09.600017+00	\N
5	Windows	windows	2017-01-31 18:53:09.600017+00	\N
6	Linux	linux	2017-01-31 18:53:09.600017+00	\N
\.


--
-- Name: operating_systems_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('operating_systems_id_seq', 6, true);


--
-- Data for Name: pricing; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY pricing (id, name, slug, created_at, updated_at) FROM stdin;
1	Open Source	open-source	2017-01-31 18:53:09.600017+00	\N
2	Free	free	2017-01-31 18:53:09.600017+00	\N
3	Per User	per-user	2017-01-31 18:53:09.600017+00	\N
4	Site-Based	site-based	2017-01-31 18:53:09.600017+00	\N
5	Other	other	2017-01-31 18:53:09.600017+00	\N
\.


--
-- Name: pricing_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('pricing_id_seq', 5, true);


--
-- Data for Name: specialties; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY specialties (id, name, slug, created_at, updated_at) FROM stdin;
1	Anesthesiology	anesthesiology	2017-01-31 18:53:09.600017+00	\N
2	Cardiology	cardiology	2017-01-31 18:53:09.600017+00	\N
3	Gastrointestinal	gastrointestinal	2017-01-31 18:53:09.600017+00	\N
4	Infectious Disease	infectious-disease	2017-01-31 18:53:09.600017+00	\N
5	Neurology	neurology	2017-01-31 18:53:09.600017+00	\N
6	Obstetrics	obstetrics	2017-01-31 18:53:09.600017+00	\N
7	Oncology	oncology	2017-01-31 18:53:09.600017+00	\N
8	Pediatrics	pediatrics	2017-01-31 18:53:09.600017+00	\N
9	Pulmonary	pulmonary	2017-01-31 18:53:09.600017+00	\N
10	Renal	renal	2017-01-31 18:53:09.600017+00	\N
11	Rheumatology	rheumatology	2017-01-31 18:53:09.600017+00	\N
12	Trauma	trauma	2017-01-31 18:53:09.600017+00	\N
\.


--
-- Name: specialties_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('specialties_id_seq', 12, true);


--
-- Name: applications_categories applications_categories_application_id_category_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY applications_categories
    ADD CONSTRAINT applications_categories_application_id_category_id_key UNIQUE (application_id, category_id);


--
-- Name: applications_categories applications_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY applications_categories
    ADD CONSTRAINT applications_categories_pkey PRIMARY KEY (id);


--
-- Name: applications_ehr applications_ehr_application_id_ehr_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY applications_ehr
    ADD CONSTRAINT applications_ehr_application_id_ehr_id_key UNIQUE (application_id, ehr_id);


--
-- Name: applications_ehr applications_ehr_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY applications_ehr
    ADD CONSTRAINT applications_ehr_pkey PRIMARY KEY (id);


--
-- Name: applications_fhir applications_fhir_application_id_fhir_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY applications_fhir
    ADD CONSTRAINT applications_fhir_application_id_fhir_id_key UNIQUE (application_id, fhir_id);


--
-- Name: applications_fhir applications_fhir_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY applications_fhir
    ADD CONSTRAINT applications_fhir_pkey PRIMARY KEY (id);


--
-- Name: applications applications_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY applications
    ADD CONSTRAINT applications_name_key UNIQUE (name);


--
-- Name: applications_operating_systems applications_operating_system_application_id_operating_syst_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY applications_operating_systems
    ADD CONSTRAINT applications_operating_system_application_id_operating_syst_key UNIQUE (application_id, operating_system_id);


--
-- Name: applications_operating_systems applications_operating_systems_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY applications_operating_systems
    ADD CONSTRAINT applications_operating_systems_pkey PRIMARY KEY (id);


--
-- Name: applications applications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY applications
    ADD CONSTRAINT applications_pkey PRIMARY KEY (id);


--
-- Name: applications_pricing applications_pricing_application_id_pricing_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY applications_pricing
    ADD CONSTRAINT applications_pricing_application_id_pricing_id_key UNIQUE (application_id, pricing_id);


--
-- Name: applications_pricing applications_pricing_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY applications_pricing
    ADD CONSTRAINT applications_pricing_pkey PRIMARY KEY (id);


--
-- Name: applications_specialties applications_specialties_application_id_specialty_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY applications_specialties
    ADD CONSTRAINT applications_specialties_application_id_specialty_id_key UNIQUE (application_id, specialty_id);


--
-- Name: applications_specialties applications_specialties_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY applications_specialties
    ADD CONSTRAINT applications_specialties_pkey PRIMARY KEY (id);


--
-- Name: categories categories_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_name_key UNIQUE (name);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: categories categories_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_slug_key UNIQUE (slug);


--
-- Name: ehr ehr_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ehr
    ADD CONSTRAINT ehr_name_key UNIQUE (name);


--
-- Name: ehr ehr_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ehr
    ADD CONSTRAINT ehr_pkey PRIMARY KEY (id);


--
-- Name: ehr ehr_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ehr
    ADD CONSTRAINT ehr_slug_key UNIQUE (slug);


--
-- Name: fhir fhir_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY fhir
    ADD CONSTRAINT fhir_name_key UNIQUE (name);


--
-- Name: fhir fhir_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY fhir
    ADD CONSTRAINT fhir_pkey PRIMARY KEY (id);


--
-- Name: fhir fhir_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY fhir
    ADD CONSTRAINT fhir_slug_key UNIQUE (slug);


--
-- Name: listings listings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY listings
    ADD CONSTRAINT listings_pkey PRIMARY KEY (id);


--
-- Name: listings listings_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY listings
    ADD CONSTRAINT listings_slug_key UNIQUE (slug);


--
-- Name: operating_systems operating_systems_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY operating_systems
    ADD CONSTRAINT operating_systems_name_key UNIQUE (name);


--
-- Name: operating_systems operating_systems_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY operating_systems
    ADD CONSTRAINT operating_systems_pkey PRIMARY KEY (id);


--
-- Name: operating_systems operating_systems_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY operating_systems
    ADD CONSTRAINT operating_systems_slug_key UNIQUE (slug);


--
-- Name: pricing pricing_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pricing
    ADD CONSTRAINT pricing_name_key UNIQUE (name);


--
-- Name: pricing pricing_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pricing
    ADD CONSTRAINT pricing_pkey PRIMARY KEY (id);


--
-- Name: pricing pricing_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pricing
    ADD CONSTRAINT pricing_slug_key UNIQUE (slug);


--
-- Name: specialties specialties_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY specialties
    ADD CONSTRAINT specialties_name_key UNIQUE (name);


--
-- Name: specialties specialties_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY specialties
    ADD CONSTRAINT specialties_pkey PRIMARY KEY (id);


--
-- Name: specialties specialties_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY specialties
    ADD CONSTRAINT specialties_slug_key UNIQUE (slug);


--
-- Name: applications tsvectorupdate; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE ON applications FOR EACH ROW EXECUTE PROCEDURE app_tsidx();


--
-- Name: applications updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER updated_at BEFORE UPDATE ON applications FOR EACH ROW EXECUTE PROCEDURE updated_at();


--
-- Name: categories updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER updated_at BEFORE UPDATE ON categories FOR EACH ROW EXECUTE PROCEDURE updated_at();


--
-- Name: applications_categories updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER updated_at BEFORE UPDATE ON applications_categories FOR EACH ROW EXECUTE PROCEDURE updated_at();


--
-- Name: specialties updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER updated_at BEFORE UPDATE ON specialties FOR EACH ROW EXECUTE PROCEDURE updated_at();


--
-- Name: applications_specialties updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER updated_at BEFORE UPDATE ON applications_specialties FOR EACH ROW EXECUTE PROCEDURE updated_at();


--
-- Name: listings updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER updated_at BEFORE UPDATE ON listings FOR EACH ROW EXECUTE PROCEDURE updated_at();


--
-- Name: applications_categories applications_categories_application_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY applications_categories
    ADD CONSTRAINT applications_categories_application_id_fkey FOREIGN KEY (application_id) REFERENCES applications(id) ON DELETE CASCADE;


--
-- Name: applications_categories applications_categories_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY applications_categories
    ADD CONSTRAINT applications_categories_category_id_fkey FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE;


--
-- Name: applications_ehr applications_ehr_application_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY applications_ehr
    ADD CONSTRAINT applications_ehr_application_id_fkey FOREIGN KEY (application_id) REFERENCES applications(id) ON DELETE CASCADE;


--
-- Name: applications_ehr applications_ehr_ehr_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY applications_ehr
    ADD CONSTRAINT applications_ehr_ehr_id_fkey FOREIGN KEY (ehr_id) REFERENCES ehr(id) ON DELETE CASCADE;


--
-- Name: applications_fhir applications_fhir_application_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY applications_fhir
    ADD CONSTRAINT applications_fhir_application_id_fkey FOREIGN KEY (application_id) REFERENCES applications(id) ON DELETE CASCADE;


--
-- Name: applications_fhir applications_fhir_fhir_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY applications_fhir
    ADD CONSTRAINT applications_fhir_fhir_id_fkey FOREIGN KEY (fhir_id) REFERENCES fhir(id) ON DELETE CASCADE;


--
-- Name: applications_operating_systems applications_operating_systems_application_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY applications_operating_systems
    ADD CONSTRAINT applications_operating_systems_application_id_fkey FOREIGN KEY (application_id) REFERENCES applications(id) ON DELETE CASCADE;


--
-- Name: applications_operating_systems applications_operating_systems_operating_system_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY applications_operating_systems
    ADD CONSTRAINT applications_operating_systems_operating_system_id_fkey FOREIGN KEY (operating_system_id) REFERENCES operating_systems(id) ON DELETE CASCADE;


--
-- Name: applications_pricing applications_pricing_application_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY applications_pricing
    ADD CONSTRAINT applications_pricing_application_id_fkey FOREIGN KEY (application_id) REFERENCES applications(id) ON DELETE CASCADE;


--
-- Name: applications_pricing applications_pricing_pricing_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY applications_pricing
    ADD CONSTRAINT applications_pricing_pricing_id_fkey FOREIGN KEY (pricing_id) REFERENCES pricing(id) ON DELETE CASCADE;


--
-- Name: applications_specialties applications_specialties_application_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY applications_specialties
    ADD CONSTRAINT applications_specialties_application_id_fkey FOREIGN KEY (application_id) REFERENCES applications(id) ON DELETE CASCADE;


--
-- Name: applications_specialties applications_specialties_specialty_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY applications_specialties
    ADD CONSTRAINT applications_specialties_specialty_id_fkey FOREIGN KEY (specialty_id) REFERENCES specialties(id) ON DELETE CASCADE;


--
-- Name: listings listings_application_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY listings
    ADD CONSTRAINT listings_application_id_fkey FOREIGN KEY (application_id) REFERENCES applications(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

