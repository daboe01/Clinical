--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: dblink_pkey_results; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE dblink_pkey_results AS (
	"position" integer,
	colname text
);


ALTER TYPE public.dblink_pkey_results OWNER TO postgres;

--
-- Name: tablefunc_crosstab_2; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE tablefunc_crosstab_2 AS (
	row_name text,
	category_1 text,
	category_2 text
);


ALTER TYPE public.tablefunc_crosstab_2 OWNER TO postgres;

--
-- Name: tablefunc_crosstab_3; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE tablefunc_crosstab_3 AS (
	row_name text,
	category_1 text,
	category_2 text,
	category_3 text
);


ALTER TYPE public.tablefunc_crosstab_3 OWNER TO postgres;

--
-- Name: tablefunc_crosstab_4; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE tablefunc_crosstab_4 AS (
	row_name text,
	category_1 text,
	category_2 text,
	category_3 text,
	category_4 text
);


ALTER TYPE public.tablefunc_crosstab_4 OWNER TO postgres;

--
-- Name: calendar_function(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION calendar_function(integer, integer) RETURNS TABLE(day date, weekday integer)
    LANGUAGE sql ROWS 35
    AS $_$

select day, wd from (
select day::date, to_char(day,'D')::integer as wd, to_char(day,'IW')::integer as kw   from (
select generate_series( ($2::text||'-12-31')::timestamp-'14 months'::interval , (($2+1)::text||'-1-31')::timestamp, '1 day') as day) a order by 1) a where 
((kw  between to_char( ($2::text||'-'|| $1::text ||'-1')::date,'IW')::integer and to_char( ($2::text||'-'|| $1::text ||'-1')::date+'1 month'::interval,'IW')::integer)
or $1=12 and (kw>=48 or kw=1))

 and ( abs(day - ($2::text||'-'|| $1::text ||'-1')::date) < 60)
 -- and (abs(date_part('month', day)-$1)<2 or date_part('year', day)<$2 )
  order by 1 ; 
$_$;


ALTER FUNCTION public.calendar_function(integer, integer) OWNER TO postgres;

--
-- Name: commacat(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION commacat(acc text, instr text) RETURNS text
    LANGUAGE plpgsql
    AS $$
  BEGIN
    IF acc IS NULL OR acc = '' THEN
      RETURN instr;
    ELSE
      RETURN acc || ', ' || instr;
    END IF;
  END;
$$;


ALTER FUNCTION public.commacat(acc text, instr text) OWNER TO postgres;

--
-- Name: commacat2(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION commacat2(acc text, instr text) RETURNS text
    LANGUAGE plpgsql
    AS $$
  BEGIN
    IF acc IS NULL OR acc = '' THEN
      RETURN instr;
    ELSE
      RETURN acc || ',' || instr;
    END IF;
  END;
$$;


ALTER FUNCTION public.commacat2(acc text, instr text) OWNER TO postgres;

--
-- Name: connectby(text, text, text, text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION connectby(text, text, text, text, integer) RETURNS SETOF record
    LANGUAGE c STABLE STRICT
    AS '$libdir/tablefunc', 'connectby_text';


ALTER FUNCTION public.connectby(text, text, text, text, integer) OWNER TO postgres;

--
-- Name: connectby(text, text, text, text, integer, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION connectby(text, text, text, text, integer, text) RETURNS SETOF record
    LANGUAGE c STABLE STRICT
    AS '$libdir/tablefunc', 'connectby_text';


ALTER FUNCTION public.connectby(text, text, text, text, integer, text) OWNER TO postgres;

--
-- Name: connectby(text, text, text, text, text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION connectby(text, text, text, text, text, integer) RETURNS SETOF record
    LANGUAGE c STABLE STRICT
    AS '$libdir/tablefunc', 'connectby_text_serial';


ALTER FUNCTION public.connectby(text, text, text, text, text, integer) OWNER TO postgres;

--
-- Name: connectby(text, text, text, text, text, integer, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION connectby(text, text, text, text, text, integer, text) RETURNS SETOF record
    LANGUAGE c STABLE STRICT
    AS '$libdir/tablefunc', 'connectby_text_serial';


ALTER FUNCTION public.connectby(text, text, text, text, text, integer, text) OWNER TO postgres;

--
-- Name: crosstab(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION crosstab(text) RETURNS SETOF record
    LANGUAGE c STABLE STRICT
    AS '$libdir/tablefunc', 'crosstab';


ALTER FUNCTION public.crosstab(text) OWNER TO postgres;

--
-- Name: crosstab(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION crosstab(text, integer) RETURNS SETOF record
    LANGUAGE c STABLE STRICT
    AS '$libdir/tablefunc', 'crosstab';


ALTER FUNCTION public.crosstab(text, integer) OWNER TO postgres;

--
-- Name: crosstab(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION crosstab(text, text) RETURNS SETOF record
    LANGUAGE c STABLE STRICT
    AS '$libdir/tablefunc', 'crosstab_hash';


ALTER FUNCTION public.crosstab(text, text) OWNER TO postgres;

--
-- Name: crosstab2(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION crosstab2(text) RETURNS SETOF tablefunc_crosstab_2
    LANGUAGE c STABLE STRICT
    AS '$libdir/tablefunc', 'crosstab';


ALTER FUNCTION public.crosstab2(text) OWNER TO postgres;

--
-- Name: crosstab3(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION crosstab3(text) RETURNS SETOF tablefunc_crosstab_3
    LANGUAGE c STABLE STRICT
    AS '$libdir/tablefunc', 'crosstab';


ALTER FUNCTION public.crosstab3(text) OWNER TO postgres;

--
-- Name: crosstab4(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION crosstab4(text) RETURNS SETOF tablefunc_crosstab_4
    LANGUAGE c STABLE STRICT
    AS '$libdir/tablefunc', 'crosstab';


ALTER FUNCTION public.crosstab4(text) OWNER TO postgres;

--
-- Name: dblink(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink(text) RETURNS SETOF record
    LANGUAGE c STRICT
    AS '$libdir/dblink', 'dblink_record';


ALTER FUNCTION public.dblink(text) OWNER TO postgres;

--
-- Name: dblink(text, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink(text, boolean) RETURNS SETOF record
    LANGUAGE c STRICT
    AS '$libdir/dblink', 'dblink_record';


ALTER FUNCTION public.dblink(text, boolean) OWNER TO postgres;

--
-- Name: dblink(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink(text, text) RETURNS SETOF record
    LANGUAGE c STRICT
    AS '$libdir/dblink', 'dblink_record';


ALTER FUNCTION public.dblink(text, text) OWNER TO postgres;

--
-- Name: dblink(text, text, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink(text, text, boolean) RETURNS SETOF record
    LANGUAGE c STRICT
    AS '$libdir/dblink', 'dblink_record';


ALTER FUNCTION public.dblink(text, text, boolean) OWNER TO postgres;

--
-- Name: dblink_build_sql_delete(text, int2vector, integer, text[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_build_sql_delete(text, int2vector, integer, text[]) RETURNS text
    LANGUAGE c STRICT
    AS '$libdir/dblink', 'dblink_build_sql_delete';


ALTER FUNCTION public.dblink_build_sql_delete(text, int2vector, integer, text[]) OWNER TO postgres;

--
-- Name: dblink_build_sql_insert(text, int2vector, integer, text[], text[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_build_sql_insert(text, int2vector, integer, text[], text[]) RETURNS text
    LANGUAGE c STRICT
    AS '$libdir/dblink', 'dblink_build_sql_insert';


ALTER FUNCTION public.dblink_build_sql_insert(text, int2vector, integer, text[], text[]) OWNER TO postgres;

--
-- Name: dblink_build_sql_update(text, int2vector, integer, text[], text[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_build_sql_update(text, int2vector, integer, text[], text[]) RETURNS text
    LANGUAGE c STRICT
    AS '$libdir/dblink', 'dblink_build_sql_update';


ALTER FUNCTION public.dblink_build_sql_update(text, int2vector, integer, text[], text[]) OWNER TO postgres;

--
-- Name: dblink_cancel_query(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_cancel_query(text) RETURNS text
    LANGUAGE c STRICT
    AS '$libdir/dblink', 'dblink_cancel_query';


ALTER FUNCTION public.dblink_cancel_query(text) OWNER TO postgres;

--
-- Name: dblink_close(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_close(text) RETURNS text
    LANGUAGE c STRICT
    AS '$libdir/dblink', 'dblink_close';


ALTER FUNCTION public.dblink_close(text) OWNER TO postgres;

--
-- Name: dblink_close(text, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_close(text, boolean) RETURNS text
    LANGUAGE c STRICT
    AS '$libdir/dblink', 'dblink_close';


ALTER FUNCTION public.dblink_close(text, boolean) OWNER TO postgres;

--
-- Name: dblink_close(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_close(text, text) RETURNS text
    LANGUAGE c STRICT
    AS '$libdir/dblink', 'dblink_close';


ALTER FUNCTION public.dblink_close(text, text) OWNER TO postgres;

--
-- Name: dblink_close(text, text, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_close(text, text, boolean) RETURNS text
    LANGUAGE c STRICT
    AS '$libdir/dblink', 'dblink_close';


ALTER FUNCTION public.dblink_close(text, text, boolean) OWNER TO postgres;

--
-- Name: dblink_connect(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_connect(text) RETURNS text
    LANGUAGE c STRICT
    AS '$libdir/dblink', 'dblink_connect';


ALTER FUNCTION public.dblink_connect(text) OWNER TO postgres;

--
-- Name: dblink_connect(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_connect(text, text) RETURNS text
    LANGUAGE c STRICT
    AS '$libdir/dblink', 'dblink_connect';


ALTER FUNCTION public.dblink_connect(text, text) OWNER TO postgres;

--
-- Name: dblink_connect_u(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_connect_u(text) RETURNS text
    LANGUAGE c STRICT SECURITY DEFINER
    AS '$libdir/dblink', 'dblink_connect';


ALTER FUNCTION public.dblink_connect_u(text) OWNER TO postgres;

--
-- Name: dblink_connect_u(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_connect_u(text, text) RETURNS text
    LANGUAGE c STRICT SECURITY DEFINER
    AS '$libdir/dblink', 'dblink_connect';


ALTER FUNCTION public.dblink_connect_u(text, text) OWNER TO postgres;

--
-- Name: dblink_current_query(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_current_query() RETURNS text
    LANGUAGE c
    AS '$libdir/dblink', 'dblink_current_query';


ALTER FUNCTION public.dblink_current_query() OWNER TO postgres;

--
-- Name: dblink_disconnect(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_disconnect() RETURNS text
    LANGUAGE c STRICT
    AS '$libdir/dblink', 'dblink_disconnect';


ALTER FUNCTION public.dblink_disconnect() OWNER TO postgres;

--
-- Name: dblink_disconnect(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_disconnect(text) RETURNS text
    LANGUAGE c STRICT
    AS '$libdir/dblink', 'dblink_disconnect';


ALTER FUNCTION public.dblink_disconnect(text) OWNER TO postgres;

--
-- Name: dblink_error_message(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_error_message(text) RETURNS text
    LANGUAGE c STRICT
    AS '$libdir/dblink', 'dblink_error_message';


ALTER FUNCTION public.dblink_error_message(text) OWNER TO postgres;

--
-- Name: dblink_exec(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_exec(text) RETURNS text
    LANGUAGE c STRICT
    AS '$libdir/dblink', 'dblink_exec';


ALTER FUNCTION public.dblink_exec(text) OWNER TO postgres;

--
-- Name: dblink_exec(text, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_exec(text, boolean) RETURNS text
    LANGUAGE c STRICT
    AS '$libdir/dblink', 'dblink_exec';


ALTER FUNCTION public.dblink_exec(text, boolean) OWNER TO postgres;

--
-- Name: dblink_exec(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_exec(text, text) RETURNS text
    LANGUAGE c STRICT
    AS '$libdir/dblink', 'dblink_exec';


ALTER FUNCTION public.dblink_exec(text, text) OWNER TO postgres;

--
-- Name: dblink_exec(text, text, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_exec(text, text, boolean) RETURNS text
    LANGUAGE c STRICT
    AS '$libdir/dblink', 'dblink_exec';


ALTER FUNCTION public.dblink_exec(text, text, boolean) OWNER TO postgres;

--
-- Name: dblink_fetch(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_fetch(text, integer) RETURNS SETOF record
    LANGUAGE c STRICT
    AS '$libdir/dblink', 'dblink_fetch';


ALTER FUNCTION public.dblink_fetch(text, integer) OWNER TO postgres;

--
-- Name: dblink_fetch(text, integer, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_fetch(text, integer, boolean) RETURNS SETOF record
    LANGUAGE c STRICT
    AS '$libdir/dblink', 'dblink_fetch';


ALTER FUNCTION public.dblink_fetch(text, integer, boolean) OWNER TO postgres;

--
-- Name: dblink_fetch(text, text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_fetch(text, text, integer) RETURNS SETOF record
    LANGUAGE c STRICT
    AS '$libdir/dblink', 'dblink_fetch';


ALTER FUNCTION public.dblink_fetch(text, text, integer) OWNER TO postgres;

--
-- Name: dblink_fetch(text, text, integer, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_fetch(text, text, integer, boolean) RETURNS SETOF record
    LANGUAGE c STRICT
    AS '$libdir/dblink', 'dblink_fetch';


ALTER FUNCTION public.dblink_fetch(text, text, integer, boolean) OWNER TO postgres;

--
-- Name: dblink_get_connections(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_get_connections() RETURNS text[]
    LANGUAGE c
    AS '$libdir/dblink', 'dblink_get_connections';


ALTER FUNCTION public.dblink_get_connections() OWNER TO postgres;

--
-- Name: dblink_get_pkey(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_get_pkey(text) RETURNS SETOF dblink_pkey_results
    LANGUAGE c STRICT
    AS '$libdir/dblink', 'dblink_get_pkey';


ALTER FUNCTION public.dblink_get_pkey(text) OWNER TO postgres;

--
-- Name: dblink_get_result(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_get_result(text) RETURNS SETOF record
    LANGUAGE c STRICT
    AS '$libdir/dblink', 'dblink_get_result';


ALTER FUNCTION public.dblink_get_result(text) OWNER TO postgres;

--
-- Name: dblink_get_result(text, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_get_result(text, boolean) RETURNS SETOF record
    LANGUAGE c STRICT
    AS '$libdir/dblink', 'dblink_get_result';


ALTER FUNCTION public.dblink_get_result(text, boolean) OWNER TO postgres;

--
-- Name: dblink_is_busy(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_is_busy(text) RETURNS integer
    LANGUAGE c STRICT
    AS '$libdir/dblink', 'dblink_is_busy';


ALTER FUNCTION public.dblink_is_busy(text) OWNER TO postgres;

--
-- Name: dblink_open(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_open(text, text) RETURNS text
    LANGUAGE c STRICT
    AS '$libdir/dblink', 'dblink_open';


ALTER FUNCTION public.dblink_open(text, text) OWNER TO postgres;

--
-- Name: dblink_open(text, text, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_open(text, text, boolean) RETURNS text
    LANGUAGE c STRICT
    AS '$libdir/dblink', 'dblink_open';


ALTER FUNCTION public.dblink_open(text, text, boolean) OWNER TO postgres;

--
-- Name: dblink_open(text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_open(text, text, text) RETURNS text
    LANGUAGE c STRICT
    AS '$libdir/dblink', 'dblink_open';


ALTER FUNCTION public.dblink_open(text, text, text) OWNER TO postgres;

--
-- Name: dblink_open(text, text, text, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_open(text, text, text, boolean) RETURNS text
    LANGUAGE c STRICT
    AS '$libdir/dblink', 'dblink_open';


ALTER FUNCTION public.dblink_open(text, text, text, boolean) OWNER TO postgres;

--
-- Name: dblink_send_query(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_send_query(text, text) RETURNS integer
    LANGUAGE c STRICT
    AS '$libdir/dblink', 'dblink_send_query';


ALTER FUNCTION public.dblink_send_query(text, text) OWNER TO postgres;

--
-- Name: get_trial_property_field(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_trial_property_field(myfield text, myid integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
  BEGIN
return (SELECT  trial_properties.value
         FROM trial_properties
    JOIN trial_properties_catalogue ON trial_properties.idproperty = trial_properties_catalogue.id
   WHERE trial_properties_catalogue.name ~* myfield::text AND trial_properties.idtrial = myid
  LIMIT 1);  END;
$$;


ALTER FUNCTION public.get_trial_property_field(myfield text, myid integer) OWNER TO postgres;

--
-- Name: normal_rand(integer, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION normal_rand(integer, double precision, double precision) RETURNS SETOF double precision
    LANGUAGE c STRICT
    AS '$libdir/tablefunc', 'normal_rand';


ALTER FUNCTION public.normal_rand(integer, double precision, double precision) OWNER TO postgres;

--
-- Name: textcat_all(text); Type: AGGREGATE; Schema: public; Owner: root
--

CREATE AGGREGATE textcat_all(text) (
    SFUNC = commacat,
    STYPE = text,
    INITCOND = ''
);


ALTER AGGREGATE public.textcat_all(text) OWNER TO root;

--
-- Name: textcat_all2(text); Type: AGGREGATE; Schema: public; Owner: root
--

CREATE AGGREGATE textcat_all2(text) (
    SFUNC = commacat2,
    STYPE = text,
    INITCOND = ''
);


ALTER AGGREGATE public.textcat_all2(text) OWNER TO root;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: all_trials; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE all_trials (
    id integer NOT NULL,
    idgroup integer,
    name text,
    codename text,
    infotext text
);


ALTER TABLE public.all_trials OWNER TO postgres;

--
-- Name: patients; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE patients (
    id integer NOT NULL,
    idtrial integer,
    piz integer,
    code1 text,
    code2 text,
    comment text,
    state integer,
    name text,
    givenname text,
    birthdate date,
    street text,
    zip text,
    town text,
    telephone text,
    insertion_date date DEFAULT now(),
    female boolean,
    iban text,
    bic text,
    bank text,
    travel_distance numeric
);


ALTER TABLE public.patients OWNER TO root;

--
-- Name: process_steps_catalogue; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE process_steps_catalogue (
    id integer NOT NULL,
    type integer,
    name text NOT NULL
);


ALTER TABLE public.process_steps_catalogue OWNER TO postgres;

--
-- Name: trial_process_step; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE trial_process_step (
    id integer NOT NULL,
    idtrial integer,
    type integer,
    start_date date DEFAULT now(),
    end_date date,
    deadline date,
    idpersonnel integer,
    title text
);


ALTER TABLE public.trial_process_step OWNER TO postgres;

--
-- Name: trial_properties; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE trial_properties (
    id integer NOT NULL,
    idtrial integer,
    idproperty integer,
    value text
);


ALTER TABLE public.trial_properties OWNER TO postgres;

--
-- Name: trial_properties_catalogue; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE trial_properties_catalogue (
    id integer NOT NULL,
    type integer,
    name text NOT NULL,
    ordering integer,
    default_value text
);


ALTER TABLE public.trial_properties_catalogue OWNER TO postgres;

--
-- Name: full_text_search; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW full_text_search AS
 SELECT a.idtrial,
    lower(textcat_all(a.value)) AS fulltext
   FROM ( SELECT a_1.idtrial,
            a_1.name,
            a_1.value
           FROM ( SELECT all_trials.id AS idtrial,
                    'name'::text AS name,
                    all_trials.name AS value
                   FROM all_trials
                UNION ALL
                 SELECT trial_properties.idtrial,
                    trial_properties_catalogue.name,
                    trial_properties.value
                   FROM (trial_properties
                     JOIN trial_properties_catalogue ON ((trial_properties.idproperty = trial_properties_catalogue.id)))
                UNION ALL
                 SELECT trial_process_step.idtrial,
                    (process_steps_catalogue.name || ' (Start)'::text) AS name,
                    (trial_process_step.start_date)::text AS value
                   FROM (trial_process_step
                     JOIN process_steps_catalogue ON ((trial_process_step.type = process_steps_catalogue.id)))
                UNION ALL
                 SELECT trial_process_step.idtrial,
                    (process_steps_catalogue.name || ' (End)'::text),
                    (trial_process_step.end_date)::text AS value
                   FROM (trial_process_step
                     JOIN process_steps_catalogue ON ((trial_process_step.type = process_steps_catalogue.id)))
                UNION ALL
                 SELECT patients.idtrial,
                    'piz'::text AS name,
                    ((((patients.piz)::text || '('::text) || patients.name) || ')'::text) AS value
                   FROM patients
          ORDER BY 1) a_1
          WHERE (a_1.value IS NOT NULL)) a
  GROUP BY a.idtrial;


ALTER TABLE public.full_text_search OWNER TO root;

--
-- Name: __study_count_per_indication; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW __study_count_per_indication AS
 WITH indications_time_course AS (
         SELECT trial_process_step.idtrial,
            trial_process_step.start_date,
            trial_process_step.end_date,
                CASE
                    WHEN (full_text_search.fulltext ~* 'uveitis|iritis'::text) THEN 'Uveitis'::text
                    WHEN (full_text_search.fulltext ~* 'netzhaut|retin|macu|maku|diabe|hansen|agostini'::text) THEN 'Retina'::text
                    WHEN (full_text_search.fulltext ~* 'glauc|glauk|iop|augentruck'::text) THEN 'Glaucoma'::text
                    WHEN (full_text_search.fulltext ~* 'kera|kata|cata|dry|sicca|conjun|konjun|iol|refrac|multif|toric'::text) THEN 'Anterior segment'::text
                    WHEN (full_text_search.fulltext ~* 'neuritis|aion'::text) THEN 'Neuro'::text
                    ELSE 'Other'::text
                END AS indication
           FROM ((trial_process_step
             JOIN process_steps_catalogue ON ((process_steps_catalogue.id = trial_process_step.type)))
             JOIN full_text_search ON ((full_text_search.idtrial = trial_process_step.idtrial)))
          WHERE (process_steps_catalogue.name ~* '^gesamtlauf'::text)
        )
 SELECT a.date,
    count(*) AS count,
    indications_time_course.indication
   FROM (( SELECT DISTINCT COALESCE(indications_time_course_1.start_date, indications_time_course_1.end_date) AS date
           FROM indications_time_course indications_time_course_1) a
     JOIN indications_time_course ON (((a.date >= indications_time_course.start_date) AND (a.date <= COALESCE(indications_time_course.end_date, (now())::date)))))
  GROUP BY a.date, indications_time_course.indication;


ALTER TABLE public.__study_count_per_indication OWNER TO root;

--
-- Name: account_transaction; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE account_transaction (
    id integer NOT NULL,
    idaccount integer,
    date_transaction date DEFAULT now(),
    type integer,
    amount_change double precision,
    description text
);


ALTER TABLE public.account_transaction OWNER TO root;

--
-- Name: account_transaction_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE account_transaction_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_transaction_id_seq OWNER TO root;

--
-- Name: account_transaction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE account_transaction_id_seq OWNED BY account_transaction.id;


--
-- Name: billings; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE billings (
    id integer NOT NULL,
    idtrial integer,
    creation_date timestamp without time zone DEFAULT now(),
    start_date timestamp without time zone DEFAULT (now() + '3 mons'::interval),
    end_date timestamp without time zone,
    comment text,
    visit_ids text,
    amount double precision,
    visit_ids_travel_costs text
);


ALTER TABLE public.billings OWNER TO root;

--
-- Name: personnel_costs; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE personnel_costs (
    id integer NOT NULL,
    date_active date,
    idpersonnel integer,
    idaccount integer,
    amount double precision,
    comment text
);


ALTER TABLE public.personnel_costs OWNER TO postgres;

--
-- Name: personnel_costs_projected; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW personnel_costs_projected AS
 WITH avg_salary AS (
         SELECT max(personnel_costs.date_active) AS date_active,
            personnel_costs.idpersonnel,
            personnel_costs.idaccount,
            avg(personnel_costs.amount) AS amount
           FROM ( SELECT personnel_costs_1.date_active,
                    personnel_costs_1.idpersonnel,
                    personnel_costs_1.idaccount,
                    sum(personnel_costs_1.amount) AS amount
                   FROM personnel_costs personnel_costs_1
                  GROUP BY personnel_costs_1.date_active, personnel_costs_1.idpersonnel, personnel_costs_1.idaccount) personnel_costs
          GROUP BY personnel_costs.idpersonnel, personnel_costs.idaccount
        )
 SELECT (future_date.future_date)::timestamp without time zone AS date_active,
    avg_salary.idpersonnel,
    avg_salary.idaccount,
    avg_salary.amount,
    ''::text AS comment
   FROM (avg_salary
     JOIN generate_series(((now())::timestamp without time zone)::timestamp with time zone, (now() + '1 year'::interval), '1 mon'::interval) future_date(future_date) ON (true));


ALTER TABLE public.personnel_costs_projected OWNER TO root;

--
-- Name: shadow_accounts; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE shadow_accounts (
    id integer NOT NULL,
    account_number text,
    idgroup integer,
    name text
);


ALTER TABLE public.shadow_accounts OWNER TO root;

--
-- Name: all_transactions; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW all_transactions AS
 SELECT account_transaction.idaccount,
    account_transaction.date_transaction,
    account_transaction.type,
    account_transaction.description,
    account_transaction.amount_change
   FROM account_transaction
UNION ALL
 SELECT shadow_accounts.id AS idaccount,
    (billings.start_date)::date AS date_transaction,
    1 AS type,
    billings.visit_ids AS description,
    billings.amount AS amount_change
   FROM (((trial_properties
     JOIN trial_properties_catalogue ON ((trial_properties.idproperty = trial_properties_catalogue.id)))
     JOIN billings ON ((((billings.idtrial = trial_properties.idtrial) AND (billings.end_date IS NULL)) AND (billings.start_date > now()))))
     JOIN shadow_accounts ON ((shadow_accounts.account_number = trial_properties.value)))
  WHERE ((trial_properties_catalogue.name ~* 'drittmittelnu'::text) AND (trial_properties.value IS NOT NULL))
UNION ALL
 SELECT personnel_costs.idaccount,
    personnel_costs.date_active AS date_transaction,
    2 AS type,
    personnel_costs.comment AS description,
    (personnel_costs.amount * ((-1))::double precision) AS amount_change
   FROM personnel_costs
UNION ALL
 SELECT personnel_costs_projected.idaccount,
    (personnel_costs_projected.date_active)::date AS date_transaction,
    3 AS type,
    personnel_costs_projected.comment AS description,
    (personnel_costs_projected.amount * ((-1))::double precision) AS amount_change
   FROM personnel_costs_projected
  WHERE ((personnel_costs_projected.date_active - '1 mon'::interval) > ( SELECT max(personnel_costs.date_active) AS max
           FROM personnel_costs
          WHERE (personnel_costs_projected.idpersonnel = personnel_costs.idpersonnel)));


ALTER TABLE public.all_transactions OWNER TO root;

--
-- Name: accounts_balanced; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW accounts_balanced AS
 SELECT all_transactions.idaccount,
    all_transactions.date_transaction,
    all_transactions.type,
    all_transactions.description,
    all_transactions.amount_change,
    sum(all_transactions.amount_change) OVER (PARTITION BY all_transactions.idaccount ORDER BY all_transactions.date_transaction) AS balance
   FROM all_transactions
  WHERE (all_transactions.amount_change IS NOT NULL);


ALTER TABLE public.accounts_balanced OWNER TO postgres;

--
-- Name: group_assignments; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE group_assignments (
    id integer NOT NULL,
    idgroup integer,
    idpersonnel integer
);


ALTER TABLE public.group_assignments OWNER TO postgres;

--
-- Name: personnel_catalogue; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE personnel_catalogue (
    id integer NOT NULL,
    name text NOT NULL,
    ldap text,
    email text,
    function text,
    tel text,
    level integer,
    abrechnungsname text
);


ALTER TABLE public.personnel_catalogue OWNER TO postgres;

--
-- Name: accounts_balanced_ldap; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW accounts_balanced_ldap AS
 SELECT accounts_balanced.idaccount,
    accounts_balanced.date_transaction,
    accounts_balanced.type,
    accounts_balanced.description,
    accounts_balanced.amount_change,
    accounts_balanced.balance,
    personnel_catalogue.ldap,
    personnel_catalogue.level
   FROM (((accounts_balanced
     JOIN shadow_accounts ON ((shadow_accounts.id = accounts_balanced.idaccount)))
     JOIN group_assignments ON ((group_assignments.idgroup = shadow_accounts.idgroup)))
     JOIN personnel_catalogue ON ((personnel_catalogue.id = group_assignments.idpersonnel)))
  WHERE (personnel_catalogue.level > 0);


ALTER TABLE public.accounts_balanced_ldap OWNER TO root;

--
-- Name: all_trials_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE all_trials_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.all_trials_id_seq OWNER TO postgres;

--
-- Name: all_trials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE all_trials_id_seq OWNED BY all_trials.id;


--
-- Name: bic_catalogue; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE bic_catalogue (
    "row.names" text,
    blz integer,
    name text,
    bic text
);


ALTER TABLE public.bic_catalogue OWNER TO root;

--
-- Name: patient_visits; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE patient_visits (
    id integer NOT NULL,
    idpatient integer,
    idvisit integer,
    visit_date timestamp without time zone,
    state integer,
    travel_costs numeric,
    date_reimbursed timestamp without time zone,
    travel_comment text,
    travel_additional_costs numeric,
    actual_costs numeric
);


ALTER TABLE public.patient_visits OWNER TO root;

--
-- Name: trial_visits; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE trial_visits (
    id integer NOT NULL,
    name text,
    idtrial integer,
    idreference_visit integer,
    visit_interval interval,
    lower_margin interval,
    upper_margin interval,
    reimbursement numeric,
    additional_docscal_booking_name text,
    ordering integer,
    comment text
);


ALTER TABLE public.trial_visits OWNER TO root;

--
-- Name: billing_print; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW billing_print AS
 SELECT a.idbilling,
    patients.idtrial,
    patient_visits.visit_date,
    patients.code1,
    patients.code2,
    trial_visits.name AS visit,
    trial_visits.reimbursement,
    patient_visits.id
   FROM ((((patient_visits
     JOIN patients ON ((patient_visits.idpatient = patients.id)))
     JOIN all_trials ON ((patients.idtrial = all_trials.id)))
     JOIN trial_visits ON ((patient_visits.idvisit = trial_visits.id)))
     JOIN ( SELECT billings.id AS idbilling,
            unnest(regexp_split_to_array(billings.visit_ids, '[, ]+'::text)) AS visit_id
           FROM billings) a ON (((patient_visits.id)::text = a.visit_id)))
  WHERE (trial_visits.reimbursement > (0)::numeric)
  ORDER BY patients.idtrial, patient_visits.visit_date;


ALTER TABLE public.billing_print OWNER TO root;

--
-- Name: billings_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE billings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.billings_id_seq OWNER TO root;

--
-- Name: billings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE billings_id_seq OWNED BY billings.id;


--
-- Name: calendar; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW calendar AS
 SELECT NULL::text AS source,
    NULL::timestamp without time zone AS startdate,
    NULL::date AS caldate,
    NULL::integer AS dcid,
    NULL::integer AS id;


ALTER TABLE public.calendar OWNER TO root;

--
-- Name: global_state; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW global_state AS
 SELECT a.idtrial,
    COALESCE(a.global_state, '0_Startup'::text) AS global_state
   FROM ( SELECT a_1.idtrial,
            max(a_1.global_state) AS global_state
           FROM ( SELECT a_2.idtrial,
                    a_2.name,
                    a_2.inbetween,
                    a_2.past,
                    a_2.upcoming,
                        CASE
                            WHEN ((a_2.name ~* '^rekru'::text) AND a_2.inbetween) THEN '1_Recruiting'::text
                            WHEN ((a_2.name ~* '^rekru'::text) AND a_2.past) THEN '2_Follow-Up'::text
                            WHEN ((a_2.name ~* '^gesamtlauf'::text) AND a_2.past) THEN '4_Finished'::text
                            WHEN ((a_2.name ~* '^vertra'::text) AND ((NOT a_2.past) OR (a_2.past IS NULL))) THEN '0_Contracting'::text
                            WHEN ((a_2.name ~* '^gesamtlaufzeit'::text) AND a_2.upcoming) THEN '3_Upcoming'::text
                            ELSE NULL::text
                        END AS global_state
                   FROM ( SELECT trial_process_step.idtrial,
                            process_steps_catalogue.name,
                            ((now() >= trial_process_step.start_date) AND ((now() <= trial_process_step.end_date) OR (trial_process_step.end_date IS NULL))) AS inbetween,
                            (now() > trial_process_step.end_date) AS past,
                            (now() < trial_process_step.start_date) AS upcoming
                           FROM (trial_process_step
                             JOIN process_steps_catalogue ON ((process_steps_catalogue.id = trial_process_step.type)))) a_2) a_1
          GROUP BY a_1.idtrial
          ORDER BY a_1.idtrial) a;


ALTER TABLE public.global_state OWNER TO root;

--
-- Name: trials; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW trials AS
 SELECT all_trials.id,
    all_trials.idgroup,
    all_trials.name,
    all_trials.codename,
    all_trials.infotext,
    personnel_catalogue.ldap,
    global_state.global_state,
    full_text_search.fulltext,
    a.phase,
    a.sponsor,
    a.indikation
   FROM (((((all_trials
     JOIN group_assignments ON ((group_assignments.idgroup = all_trials.idgroup)))
     JOIN personnel_catalogue ON ((group_assignments.idpersonnel = personnel_catalogue.id)))
     LEFT JOIN global_state ON ((global_state.idtrial = all_trials.id)))
     LEFT JOIN full_text_search ON ((full_text_search.idtrial = all_trials.id)))
     LEFT JOIN ( SELECT all_trials_1.id,
            get_trial_property_field('phase'::text, all_trials_1.id) AS phase,
            get_trial_property_field('sponsor'::text, all_trials_1.id) AS sponsor,
            get_trial_property_field('indikation'::text, all_trials_1.id) AS indikation
           FROM all_trials all_trials_1) a ON ((a.id = all_trials.id)));


ALTER TABLE public.trials OWNER TO postgres;

--
-- Name: due_billings_list; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW due_billings_list AS
 SELECT billings.id,
    billings.idtrial,
    trials.name AS trial,
    billings.creation_date,
    billings.start_date AS due_date,
    (((billings.comment || ' ('::text) || billings.visit_ids) || ')'::text) AS comment,
    billings.amount,
    trials.ldap
   FROM (billings
     JOIN trials ON ((trials.id = billings.idtrial)))
  WHERE ((billings.end_date IS NULL) AND (billings.start_date < now()));


ALTER TABLE public.due_billings_list OWNER TO root;

--
-- Name: personnel_event; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE personnel_event (
    id integer NOT NULL,
    idpersonnel integer,
    type integer,
    start_time timestamp without time zone DEFAULT now(),
    end_time timestamp without time zone,
    comment text
);


ALTER TABLE public.personnel_event OWNER TO postgres;

--
-- Name: procedures_personnel; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE procedures_personnel (
    id integer NOT NULL,
    idpersonnel integer,
    idprocedure integer
);


ALTER TABLE public.procedures_personnel OWNER TO postgres;

--
-- Name: visit_procedures; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE visit_procedures (
    id integer NOT NULL,
    idvisit integer,
    idprocedure integer,
    actual_cost double precision
);


ALTER TABLE public.visit_procedures OWNER TO root;

--
-- Name: event_overview; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW event_overview AS
 SELECT DISTINCT a.name,
    a.event_date,
    COALESCE(a.ldap, personnel_catalogue.ldap) AS ldap,
    a.type,
    a.piz,
    a.tooltip
   FROM (((( SELECT a_1.idtrial,
            a_1.name,
            a_1.event_date,
            1 AS type,
            a_1.piz,
            a_1.tooltip,
            a_1.ldap
           FROM ( SELECT patients.idtrial,
                    ((trial_visits.name || ' '::text) || all_trials_1.name) AS name,
                    patient_visits.visit_date AS event_date,
                    patients.piz,
                    ((((patients.name || ', '::text) || patients.givenname) || ', *'::text) || patients.birthdate) AS tooltip,
                    personnel_catalogue_1.ldap
                   FROM ((((((patient_visits
                     JOIN patients ON ((patient_visits.idpatient = patients.id)))
                     JOIN all_trials all_trials_1 ON ((patients.idtrial = all_trials_1.id)))
                     JOIN trial_visits ON ((patient_visits.idvisit = trial_visits.id)))
                     LEFT JOIN visit_procedures ON ((visit_procedures.idvisit = trial_visits.id)))
                     LEFT JOIN procedures_personnel ON ((procedures_personnel.idprocedure = visit_procedures.id)))
                     LEFT JOIN personnel_catalogue personnel_catalogue_1 ON ((personnel_catalogue_1.id = procedures_personnel.idpersonnel)))) a_1
        UNION
         SELECT trial_process_step.idtrial,
            ((COALESCE(process_steps_catalogue.name, ''::text) || ' '::text) || COALESCE(trial_process_step.title, ''::text)),
            trial_process_step.start_date AS event_date,
            2 AS type,
            NULL::integer AS piz,
            NULL::text AS tooltip,
            NULL::text AS ldap
           FROM (trial_process_step
             JOIN process_steps_catalogue ON ((trial_process_step.type = process_steps_catalogue.id)))
        UNION
         SELECT ( SELECT min(all_trials_1.id) AS min
                   FROM (all_trials all_trials_1
                     JOIN group_assignments group_assignments_1 ON ((group_assignments_1.idgroup = all_trials_1.idgroup)))
                  WHERE (group_assignments_1.idpersonnel = personnel_catalogue_1.id)) AS idtrial,
            ('Urlaub: '::text || personnel_catalogue_1.ldap),
            a_1.day AS event_date,
            3 AS type,
            NULL::integer AS piz,
            personnel_event.comment AS tooltip,
            NULL::text AS ldap
           FROM ((personnel_event
             JOIN ( SELECT day.day
                   FROM generate_series(((now())::date - '1 year'::interval), ((now())::date + '1 year'::interval), '1 day'::interval) day(day)) a_1 ON (((a_1.day >= (personnel_event.start_time)::date) AND (a_1.day <= (personnel_event.end_time)::date))))
             JOIN personnel_catalogue personnel_catalogue_1 ON ((personnel_catalogue_1.id = personnel_event.idpersonnel)))
          WHERE (personnel_event.type = 1)
        UNION
         SELECT trial_process_step.idtrial,
            ((COALESCE(process_steps_catalogue.name, ''::text) || ' '::text) || COALESCE(trial_process_step.title, ''::text)),
            trial_process_step.end_date AS event_date,
            2 AS type,
            NULL::integer AS piz,
            NULL::text AS tooltip,
            NULL::text AS ldap
           FROM (trial_process_step
             JOIN process_steps_catalogue ON ((trial_process_step.type = process_steps_catalogue.id)))) a
     LEFT JOIN all_trials ON ((a.idtrial = all_trials.id)))
     LEFT JOIN group_assignments ON ((group_assignments.idgroup = all_trials.idgroup)))
     LEFT JOIN personnel_catalogue ON ((personnel_catalogue.id = group_assignments.idpersonnel)))
  WHERE ((a.name IS NOT NULL) AND (a.event_date IS NOT NULL))
  ORDER BY a.type DESC;


ALTER TABLE public.event_overview OWNER TO root;

--
-- Name: full_billing_list; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW full_billing_list AS
 SELECT patients.idtrial,
    patient_visits.visit_date,
    patients.code1,
    patients.code2,
    trial_visits.name AS visit,
    trial_visits.reimbursement,
    patient_visits.id,
    patient_visits.idpatient
   FROM (((patient_visits
     JOIN patients ON ((patient_visits.idpatient = patients.id)))
     JOIN all_trials ON ((patients.idtrial = all_trials.id)))
     JOIN trial_visits ON ((patient_visits.idvisit = trial_visits.id)))
  ORDER BY patients.idtrial, patient_visits.visit_date;


ALTER TABLE public.full_billing_list OWNER TO root;

--
-- Name: full_travelbilling_list; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW full_travelbilling_list AS
 SELECT patients.idtrial,
    patient_visits.visit_date,
    patients.code1,
    patients.code2,
    trial_visits.name AS visit,
    patient_visits.actual_costs AS reimbursement,
    patient_visits.id,
    patient_visits.idpatient
   FROM (((patient_visits
     JOIN patients ON ((patient_visits.idpatient = patients.id)))
     JOIN all_trials ON ((patients.idtrial = all_trials.id)))
     JOIN trial_visits ON ((patient_visits.idvisit = trial_visits.id)))
  WHERE ((patient_visits.actual_costs > (0)::numeric) AND (patient_visits.date_reimbursed IS NOT NULL))
  ORDER BY patients.idtrial, patient_visits.visit_date;


ALTER TABLE public.full_travelbilling_list OWNER TO root;

--
-- Name: group_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE group_assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.group_assignments_id_seq OWNER TO postgres;

--
-- Name: group_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE group_assignments_id_seq OWNED BY group_assignments.id;


--
-- Name: group_assignments_name; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW group_assignments_name AS
 SELECT group_assignments.id,
    group_assignments.idgroup,
    group_assignments.idpersonnel,
    personnel_catalogue.name
   FROM (group_assignments
     JOIN personnel_catalogue ON ((personnel_catalogue.id = group_assignments.idpersonnel)))
  ORDER BY personnel_catalogue.name;


ALTER TABLE public.group_assignments_name OWNER TO root;

--
-- Name: groups_catalogue; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE groups_catalogue (
    id integer NOT NULL,
    name text NOT NULL,
    sprechstunde text,
    websitename text,
    telephone text
);


ALTER TABLE public.groups_catalogue OWNER TO postgres;

--
-- Name: groups_catalogue_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE groups_catalogue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.groups_catalogue_id_seq OWNER TO postgres;

--
-- Name: groups_catalogue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE groups_catalogue_id_seq OWNED BY groups_catalogue.id;


--
-- Name: list_for_billing; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW list_for_billing AS
 SELECT full_billing_list.idtrial,
    full_billing_list.visit_date,
    full_billing_list.code1,
    full_billing_list.code2,
    full_billing_list.visit,
    full_billing_list.reimbursement,
    full_billing_list.id,
    full_billing_list.idpatient
   FROM full_billing_list
  WHERE (NOT ((full_billing_list.id)::text IN ( SELECT unnest(regexp_split_to_array(( SELECT textcat_all(COALESCE(billings.visit_ids, ''::text)) AS ids
                   FROM billings
                  WHERE (billings.idtrial = full_billing_list.idtrial)), '[, ]+'::text)) AS unnest)));


ALTER TABLE public.list_for_billing OWNER TO root;

--
-- Name: list_for_travelbilling; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW list_for_travelbilling AS
 SELECT full_travelbilling_list.idtrial,
    full_travelbilling_list.visit_date,
    full_travelbilling_list.code1,
    full_travelbilling_list.code2,
    full_travelbilling_list.visit,
    full_travelbilling_list.reimbursement,
    full_travelbilling_list.id,
    full_travelbilling_list.idpatient
   FROM full_travelbilling_list
  WHERE (NOT ((full_travelbilling_list.id)::text IN ( SELECT unnest(regexp_split_to_array(( SELECT textcat_all(COALESCE(billings.visit_ids_travel_costs, ''::text)) AS ids
                   FROM billings
                  WHERE (billings.idtrial = full_travelbilling_list.idtrial)), '[, ]+'::text)) AS unnest)));


ALTER TABLE public.list_for_travelbilling OWNER TO root;

--
-- Name: visit_calculator; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW visit_calculator AS
 SELECT a.id AS idvisit,
    (((b.visit_date + trial_visits.visit_interval) - trial_visits.lower_margin))::date AS lower_margin,
    ((b.visit_date + trial_visits.visit_interval))::date AS center_margin,
    (((b.visit_date + trial_visits.visit_interval) + trial_visits.upper_margin))::date AS upper_margin,
    patients.id AS idpatient,
    a.idvisit AS _idvisit
   FROM (((patient_visits a
     JOIN patients ON ((a.idpatient = patients.id)))
     JOIN trial_visits ON (((patients.idtrial = trial_visits.idtrial) AND (a.idvisit = trial_visits.id))))
     JOIN patient_visits b ON (((b.idvisit = trial_visits.idreference_visit) AND (a.idpatient = b.idpatient))));


ALTER TABLE public.visit_calculator OWNER TO root;

--
-- Name: missing_service; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW missing_service AS
 SELECT a.id,
        CASE
            WHEN (a.sum = 0) THEN 'alert'::text
            ELSE NULL::text
        END AS missing_service
   FROM ( SELECT a_1.id,
            sum(a_1.available) AS sum
           FROM ( SELECT patient_visits.id,
                        CASE
                            WHEN (calendar.dcid IS NULL) THEN 0
                            ELSE 1
                        END AS available
                   FROM (((((visit_calculator
                     JOIN patient_visits ON ((patient_visits.id = visit_calculator.idvisit)))
                     JOIN patients ON ((patient_visits.idpatient = patients.id)))
                     JOIN all_trials ON ((all_trials.id = patients.idtrial)))
                     JOIN groups_catalogue ON ((groups_catalogue.id = all_trials.idgroup)))
                     LEFT JOIN calendar ON ((((calendar.source = groups_catalogue.sprechstunde) AND (calendar.caldate >= visit_calculator.lower_margin)) AND (calendar.caldate <= visit_calculator.upper_margin))))) a_1
          GROUP BY a_1.id) a;


ALTER TABLE public.missing_service OWNER TO postgres;

--
-- Name: status_catalogue; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE status_catalogue (
    id integer NOT NULL,
    idtrial integer,
    name text,
    alerting integer DEFAULT 1
);


ALTER TABLE public.status_catalogue OWNER TO root;

--
-- Name: patient_identification_log; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW patient_identification_log AS
 SELECT a.idtrial,
    a.code1,
    a.code2,
    a.piz,
    a.name,
    a.givenname,
    a.birthdate,
    status_catalogue.name AS state,
    personnel_catalogue.ldap,
    a.street,
    a.zip,
    a.town,
    a.telephone,
    a.insertion_date,
    a.female,
        CASE
            WHEN (a.female IS TRUE) THEN 'Frau'::text
            ELSE 'Herrn'::text
        END AS anrede1,
        CASE
            WHEN (a.female IS TRUE) THEN ' Frau'::text
            ELSE 'r Herr'::text
        END AS anrede2,
    a.comment
   FROM ((((patients a
     JOIN all_trials ON ((a.idtrial = all_trials.id)))
     JOIN group_assignments ON ((group_assignments.idgroup = all_trials.idgroup)))
     JOIN personnel_catalogue ON ((personnel_catalogue.id = group_assignments.idpersonnel)))
     LEFT JOIN status_catalogue ON ((a.state = status_catalogue.id)))
  ORDER BY personnel_catalogue.ldap;


ALTER TABLE public.patient_identification_log OWNER TO root;

--
-- Name: patient_visits_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE patient_visits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.patient_visits_id_seq OWNER TO root;

--
-- Name: patient_visits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE patient_visits_id_seq OWNED BY patient_visits.id;


--
-- Name: patient_visits_rich; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW patient_visits_rich AS
 WITH visit_conflicts AS (
         SELECT a.id
           FROM (( SELECT a_1.id,
                    count(*) AS count
                   FROM ( SELECT DISTINCT patient_visits_1.id,
                            personnel_catalogue_1.ldap
                           FROM (((((((patient_visits patient_visits_1
                             JOIN patients ON ((patient_visits_1.idpatient = patients.id)))
                             JOIN all_trials all_trials_1 ON ((patients.idtrial = all_trials_1.id)))
                             JOIN trial_visits trial_visits_1 ON ((patient_visits_1.idvisit = trial_visits_1.id)))
                             LEFT JOIN visit_procedures ON ((visit_procedures.idvisit = trial_visits_1.id)))
                             LEFT JOIN procedures_personnel ON ((procedures_personnel.idprocedure = visit_procedures.id)))
                             LEFT JOIN personnel_catalogue personnel_catalogue_1 ON ((personnel_catalogue_1.id = procedures_personnel.idpersonnel)))
                             JOIN ( SELECT a_1_1.day,
                                    personnel_catalogue_1_1.ldap,
                                    personnel_event.comment
                                   FROM ((personnel_event
                                     JOIN ( SELECT day.day
   FROM generate_series(((now())::date - '1 year'::interval), ((now())::date + '1 year'::interval), '1 day'::interval) day(day)) a_1_1 ON (((a_1_1.day >= (personnel_event.start_time)::date) AND (a_1_1.day <= (personnel_event.end_time)::date))))
                                     JOIN personnel_catalogue personnel_catalogue_1_1 ON ((personnel_catalogue_1_1.id = personnel_event.idpersonnel)))
                                  WHERE (personnel_event.type = 1)) a_2 ON (((a_2.ldap = personnel_catalogue_1.ldap) AND ((a_2.day)::date = (patient_visits_1.visit_date)::date))))) a_1
                  GROUP BY a_1.id) a
             JOIN ( SELECT b_1.id,
                    count(*) AS count
                   FROM ( SELECT DISTINCT patient_visits_1.id,
                            patient_visits_1.idvisit,
                            personnel_catalogue_1.ldap
                           FROM ((((((patient_visits patient_visits_1
                             JOIN patients ON ((patient_visits_1.idpatient = patients.id)))
                             JOIN all_trials all_trials_1 ON ((patients.idtrial = all_trials_1.id)))
                             JOIN trial_visits trial_visits_1 ON ((patient_visits_1.idvisit = trial_visits_1.id)))
                             LEFT JOIN visit_procedures ON ((visit_procedures.idvisit = trial_visits_1.id)))
                             LEFT JOIN procedures_personnel ON ((procedures_personnel.idprocedure = visit_procedures.id)))
                             LEFT JOIN personnel_catalogue personnel_catalogue_1 ON ((personnel_catalogue_1.id = procedures_personnel.idpersonnel)))
                          WHERE (personnel_catalogue_1.ldap IS NOT NULL)) b_1
                  GROUP BY b_1.id, b_1.idvisit) b ON (((a.id = b.id) AND (a.count >= b.count))))
        )
 SELECT DISTINCT patient_visits.id,
    patient_visits.idpatient,
    patient_visits.idvisit,
    patient_visits.visit_date,
    patient_visits.state,
    visit_calculator.lower_margin,
    visit_calculator.center_margin,
    visit_calculator.upper_margin,
        CASE
            WHEN (visit_conflicts.id IS NOT NULL) THEN 'alert'::text
            ELSE NULL::text
        END AS missing_service,
    trial_visits.ordering,
    trial_visits.comment,
    patient_visits.travel_costs,
    patient_visits.date_reimbursed,
    patient_visits.travel_comment,
    patient_visits.travel_additional_costs,
    patient_visits.actual_costs
   FROM (((patient_visits
     LEFT JOIN visit_calculator ON ((patient_visits.id = visit_calculator.idvisit)))
     LEFT JOIN trial_visits ON ((patient_visits.idvisit = trial_visits.id)))
     LEFT JOIN visit_conflicts ON ((visit_conflicts.id = patient_visits.id)));


ALTER TABLE public.patient_visits_rich OWNER TO root;

--
-- Name: patients_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE patients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.patients_id_seq OWNER TO root;

--
-- Name: patients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE patients_id_seq OWNED BY patients.id;


--
-- Name: personnel; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW personnel AS
 SELECT personnel_catalogue.id,
    personnel_catalogue.name,
    personnel_catalogue.ldap,
    personnel_catalogue.email
   FROM personnel_catalogue;


ALTER TABLE public.personnel OWNER TO root;

--
-- Name: personnel_catalogue_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE personnel_catalogue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.personnel_catalogue_id_seq OWNER TO postgres;

--
-- Name: personnel_catalogue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE personnel_catalogue_id_seq OWNED BY personnel_catalogue.id;


--
-- Name: personnel_costs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE personnel_costs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.personnel_costs_id_seq OWNER TO postgres;

--
-- Name: personnel_costs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE personnel_costs_id_seq OWNED BY personnel_costs.id;


--
-- Name: personnel_costs_ldap; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW personnel_costs_ldap AS
 SELECT personnel_costs.id,
    personnel_costs.date_active,
    personnel_costs.idpersonnel,
    personnel_costs.idaccount,
    personnel_costs.amount,
    personnel_costs.comment,
    personnel_catalogue.ldap
   FROM (personnel_costs
     JOIN personnel_catalogue ON ((personnel_catalogue.id = personnel_costs.idpersonnel)))
  WHERE (personnel_catalogue.level > 0);


ALTER TABLE public.personnel_costs_ldap OWNER TO root;

--
-- Name: personnel_event_catalogue; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE personnel_event_catalogue (
    id integer NOT NULL,
    description text
);


ALTER TABLE public.personnel_event_catalogue OWNER TO postgres;

--
-- Name: personnel_event_catalogue_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE personnel_event_catalogue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.personnel_event_catalogue_id_seq OWNER TO postgres;

--
-- Name: personnel_event_catalogue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE personnel_event_catalogue_id_seq OWNED BY personnel_event_catalogue.id;


--
-- Name: personnel_event_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE personnel_event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.personnel_event_id_seq OWNER TO postgres;

--
-- Name: personnel_event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE personnel_event_id_seq OWNED BY personnel_event.id;


--
-- Name: personnel_properties; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE personnel_properties (
    id integer NOT NULL,
    propertydate timestamp without time zone,
    idpersonnel integer,
    idproperty integer,
    value text
);


ALTER TABLE public.personnel_properties OWNER TO root;

--
-- Name: personnel_properties_catalogue; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE personnel_properties_catalogue (
    id integer NOT NULL,
    type integer,
    name text NOT NULL,
    expires interval,
    ordering integer
);


ALTER TABLE public.personnel_properties_catalogue OWNER TO root;

--
-- Name: personnel_properties_catalogue_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE personnel_properties_catalogue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.personnel_properties_catalogue_id_seq OWNER TO root;

--
-- Name: personnel_properties_catalogue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE personnel_properties_catalogue_id_seq OWNED BY personnel_properties_catalogue.id;


--
-- Name: personnel_properties_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE personnel_properties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.personnel_properties_id_seq OWNER TO root;

--
-- Name: personnel_properties_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE personnel_properties_id_seq OWNED BY personnel_properties.id;


--
-- Name: procedures_catalogue; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE procedures_catalogue (
    id integer NOT NULL,
    name text,
    type integer,
    base_cost double precision
);


ALTER TABLE public.procedures_catalogue OWNER TO root;

--
-- Name: procedure_statistics; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW procedure_statistics AS
 SELECT a.idprocedure AS id,
    avg(a.base_cost) AS base_cost,
    min(a.actual_cost) AS min_cost,
    max(a.actual_cost) AS max_cost,
    avg(a.actual_cost) AS avg_cost,
    min(a.name) AS name
   FROM ( SELECT DISTINCT visit_procedures.idprocedure,
            procedures_catalogue.base_cost,
            visit_procedures.actual_cost,
            procedures_catalogue.name
           FROM (visit_procedures
             JOIN procedures_catalogue ON ((procedures_catalogue.id = visit_procedures.idprocedure)))) a
  GROUP BY a.idprocedure;


ALTER TABLE public.procedure_statistics OWNER TO root;

--
-- Name: procedures_catalogue_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE procedures_catalogue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.procedures_catalogue_id_seq OWNER TO root;

--
-- Name: procedures_catalogue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE procedures_catalogue_id_seq OWNED BY procedures_catalogue.id;


--
-- Name: procedures_personnel_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE procedures_personnel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.procedures_personnel_id_seq OWNER TO postgres;

--
-- Name: procedures_personnel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE procedures_personnel_id_seq OWNED BY procedures_personnel.id;


--
-- Name: procedures_personnel_responsible; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW procedures_personnel_responsible AS
 WITH summary AS (
         SELECT p.id,
            p.idpersonnel,
            p.idprocedure,
            row_number() OVER (PARTITION BY p.idprocedure ORDER BY p.id DESC) AS rk
           FROM procedures_personnel p
        )
 SELECT s.id,
    s.idpersonnel,
    s.idprocedure
   FROM summary s
  WHERE (s.rk = 1);


ALTER TABLE public.procedures_personnel_responsible OWNER TO postgres;

--
-- Name: process_steps_catalogue_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE process_steps_catalogue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.process_steps_catalogue_id_seq OWNER TO postgres;

--
-- Name: process_steps_catalogue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE process_steps_catalogue_id_seq OWNED BY process_steps_catalogue.id;


--
-- Name: recruiting_overview; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW recruiting_overview AS
 SELECT a."group",
    ((a.indikation || ' '::text) || a.nct) AS indikation,
    a.name
   FROM ( SELECT groups_catalogue.websitename AS "group",
            ( SELECT trial_properties.value
                   FROM (trial_properties
                     JOIN trial_properties_catalogue ON ((trial_properties.idproperty = trial_properties_catalogue.id)))
                  WHERE ((trial_properties_catalogue.name ~* 'indikation'::text) AND (trial_properties.idtrial = all_trials.id))
                 LIMIT 1) AS indikation,
            ( SELECT
                        CASE
                            WHEN ((trial_properties.value IS NOT NULL) AND (trial_properties.value <> ''::text)) THEN COALESCE((('<a target="_parent" href="http://www.clinicaltrials.gov/ct2/results?term='::text || trial_properties.value) || '"> &#187;Details </a>'::text), ''::text)
                            ELSE ''::text
                        END AS value
                   FROM (trial_properties
                     JOIN trial_properties_catalogue ON ((trial_properties.idproperty = trial_properties_catalogue.id)))
                  WHERE ((trial_properties_catalogue.name ~* 'nct'::text) AND (trial_properties.idtrial = all_trials.id))
                 LIMIT 1) AS nct,
            all_trials.name
           FROM ((all_trials
             JOIN groups_catalogue ON ((all_trials.idgroup = groups_catalogue.id)))
             JOIN global_state ON ((global_state.idtrial = all_trials.id)))
          WHERE (global_state.global_state ~* 'recruiting'::text)
          ORDER BY groups_catalogue.name, ( SELECT trial_properties.value
                   FROM (trial_properties
                     JOIN trial_properties_catalogue ON ((trial_properties.idproperty = trial_properties_catalogue.id)))
                  WHERE ((trial_properties_catalogue.name ~* 'indikation'::text) AND (trial_properties.idtrial = all_trials.id))
                 LIMIT 1), all_trials.name) a;


ALTER TABLE public.recruiting_overview OWNER TO root;

--
-- Name: roles_catalogue; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE roles_catalogue (
    id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.roles_catalogue OWNER TO postgres;

--
-- Name: roles_catalogue_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE roles_catalogue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.roles_catalogue_id_seq OWNER TO postgres;

--
-- Name: roles_catalogue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE roles_catalogue_id_seq OWNED BY roles_catalogue.id;


--
-- Name: shadow_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE shadow_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shadow_accounts_id_seq OWNER TO root;

--
-- Name: shadow_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE shadow_accounts_id_seq OWNED BY shadow_accounts.id;


--
-- Name: shadow_accounts_ldap; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW shadow_accounts_ldap AS
 SELECT shadow_accounts.id,
    shadow_accounts.account_number,
    shadow_accounts.idgroup,
    shadow_accounts.name,
    personnel_catalogue.ldap,
    personnel_catalogue.level,
    a.balance
   FROM (((shadow_accounts
     JOIN group_assignments ON ((group_assignments.idgroup = shadow_accounts.idgroup)))
     JOIN personnel_catalogue ON ((personnel_catalogue.id = group_assignments.idpersonnel)))
     LEFT JOIN ( SELECT all_transactions.idaccount,
            sum(all_transactions.amount_change) AS balance
           FROM all_transactions
          WHERE ((all_transactions.date_transaction < now()) AND ((all_transactions.type < 3) OR (all_transactions.type IS NULL)))
          GROUP BY all_transactions.idaccount) a ON ((a.idaccount = shadow_accounts.id)))
  WHERE (personnel_catalogue.level > 0);


ALTER TABLE public.shadow_accounts_ldap OWNER TO root;

--
-- Name: status_catalogue_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE status_catalogue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.status_catalogue_id_seq OWNER TO root;

--
-- Name: status_catalogue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE status_catalogue_id_seq OWNED BY status_catalogue.id;


--
-- Name: tagesinfos; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW tagesinfos AS
 SELECT t1.source,
    t1.caldate,
    t1.summary
   FROM dblink('dbname=ical_joe'::text, 'select source, date_trunc(''day'',startdate) as startdate, summary from data where source =''Abwesenheiten'''::text) t1(source text, caldate date, summary text);


ALTER TABLE public.tagesinfos OWNER TO root;

--
-- Name: travel_billing_print; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW travel_billing_print AS
 SELECT a.idbilling,
    patients.idtrial,
    patient_visits.visit_date,
    patients.code1,
    patients.code2,
    ('Fahrtkosten: '::text || trial_visits.name) AS visit,
    patient_visits.actual_costs AS reimbursement,
    patient_visits.id
   FROM ((((patient_visits
     JOIN patients ON ((patient_visits.idpatient = patients.id)))
     JOIN all_trials ON ((patients.idtrial = all_trials.id)))
     JOIN trial_visits ON ((patient_visits.idvisit = trial_visits.id)))
     JOIN ( SELECT billings.id AS idbilling,
            unnest(regexp_split_to_array(billings.visit_ids_travel_costs, '[, ]+'::text)) AS visit_id
           FROM billings) a ON (((patient_visits.id)::text = a.visit_id)))
  WHERE (patient_visits.actual_costs > (0)::numeric)
  ORDER BY patients.idtrial, patient_visits.visit_date;


ALTER TABLE public.travel_billing_print OWNER TO root;

--
-- Name: trial_personnel; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE trial_personnel (
    id integer NOT NULL,
    idtrial integer,
    idpersonnel integer,
    role integer
);


ALTER TABLE public.trial_personnel OWNER TO postgres;

--
-- Name: trial_personnel_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE trial_personnel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.trial_personnel_id_seq OWNER TO postgres;

--
-- Name: trial_personnel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE trial_personnel_id_seq OWNED BY trial_personnel.id;


--
-- Name: trial_process_step_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE trial_process_step_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.trial_process_step_id_seq OWNER TO postgres;

--
-- Name: trial_process_step_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE trial_process_step_id_seq OWNED BY trial_process_step.id;


--
-- Name: trial_properties_catalogue_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE trial_properties_catalogue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.trial_properties_catalogue_id_seq OWNER TO postgres;

--
-- Name: trial_properties_catalogue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE trial_properties_catalogue_id_seq OWNED BY trial_properties_catalogue.id;


--
-- Name: trial_properties_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE trial_properties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.trial_properties_id_seq OWNER TO postgres;

--
-- Name: trial_properties_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE trial_properties_id_seq OWNED BY trial_properties.id;


--
-- Name: trial_property_annotations; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE trial_property_annotations (
    id integer NOT NULL,
    ldap text,
    idfield integer,
    key text,
    value text
);


ALTER TABLE public.trial_property_annotations OWNER TO root;

--
-- Name: trial_property_annotations_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE trial_property_annotations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.trial_property_annotations_id_seq OWNER TO root;

--
-- Name: trial_property_annotations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE trial_property_annotations_id_seq OWNED BY trial_property_annotations.id;


--
-- Name: trial_visits_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE trial_visits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.trial_visits_id_seq OWNER TO root;

--
-- Name: trial_visits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE trial_visits_id_seq OWNED BY trial_visits.id;


--
-- Name: visit_dates; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW visit_dates AS
 WITH absent_intervals AS (
         SELECT a_1.idvisit,
            a_1.start_time,
            a_1.end_time
           FROM ( SELECT DISTINCT visit_calculator.idvisit,
                    a_2.start_time,
                    (a_2.end_time)::date AS end_time
                   FROM (((((((visit_calculator
                     JOIN patients ON ((visit_calculator.idpatient = patients.id)))
                     JOIN all_trials all_trials_1 ON ((patients.idtrial = all_trials_1.id)))
                     JOIN trial_visits ON ((visit_calculator._idvisit = trial_visits.id)))
                     LEFT JOIN visit_procedures ON ((visit_procedures.idvisit = trial_visits.id)))
                     LEFT JOIN procedures_personnel_responsible procedures_personnel ON ((procedures_personnel.idprocedure = visit_procedures.id)))
                     LEFT JOIN personnel_catalogue personnel_catalogue_1 ON ((personnel_catalogue_1.id = procedures_personnel.idpersonnel)))
                     JOIN ( SELECT personnel_event.idpersonnel,
                            (personnel_event.start_time)::date AS start_time,
                            personnel_event.end_time,
                            personnel_event.comment
                           FROM personnel_event
                          WHERE (personnel_event.type = 1)) a_2 ON ((personnel_catalogue_1.id = a_2.idpersonnel)))
                  WHERE (((a_2.start_time >= visit_calculator.lower_margin) AND (a_2.start_time <= visit_calculator.upper_margin)) OR ((a_2.end_time >= visit_calculator.lower_margin) AND (a_2.end_time <= visit_calculator.upper_margin)))) a_1
        )
 SELECT a.dcid,
    min(a.idvisit) AS idvisit,
    min(a.caldate) AS caldate,
    min(a.startdate) AS startdate,
    max(a.missing_service) AS missing_service
   FROM ( SELECT a_1.idvisit,
            a_1.caldate,
            a_1.startdate,
            a_1.dcid,
                CASE
                    WHEN (a_1.idvisit IS NOT NULL) THEN 'alert'::text
                    ELSE ''::text
                END AS missing_service
           FROM ( SELECT visit_intervals.idvisit,
                    calendar.caldate,
                    calendar.startdate,
                    calendar.dcid
                   FROM ((( SELECT visit_calculator.idvisit,
                            visit_calculator.upper_margin,
                            visit_calculator.lower_margin,
                            groups_catalogue.sprechstunde
                           FROM (((visit_calculator
                             JOIN patients ON ((visit_calculator.idpatient = patients.id)))
                             JOIN all_trials ON ((all_trials.id = patients.idtrial)))
                             JOIN groups_catalogue ON ((groups_catalogue.id = all_trials.idgroup)))) visit_intervals
                     JOIN calendar ON ((((calendar.caldate >= visit_intervals.lower_margin) AND (calendar.caldate <= visit_intervals.upper_margin)) AND (calendar.source = visit_intervals.sprechstunde))))
                     LEFT JOIN absent_intervals ON (((visit_intervals.idvisit = absent_intervals.idvisit) AND ((calendar.caldate >= absent_intervals.start_time) AND (calendar.caldate <= absent_intervals.end_time)))))
                  ORDER BY calendar.caldate) a_1) a
  GROUP BY a.dcid;


ALTER TABLE public.visit_dates OWNER TO postgres;

--
-- Name: visit_procedures_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE visit_procedures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.visit_procedures_id_seq OWNER TO root;

--
-- Name: visit_procedures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE visit_procedures_id_seq OWNED BY visit_procedures.id;


--
-- Name: visit_procedures_name; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW visit_procedures_name AS
 SELECT visit_procedures.id,
    visit_procedures.idvisit,
    visit_procedures.idprocedure,
    visit_procedures.actual_cost,
    procedures_catalogue.name AS procedure_name
   FROM (visit_procedures
     LEFT JOIN procedures_catalogue ON ((procedures_catalogue.id = visit_procedures.idprocedure)));


ALTER TABLE public.visit_procedures_name OWNER TO postgres;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY account_transaction ALTER COLUMN id SET DEFAULT nextval('account_transaction_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY all_trials ALTER COLUMN id SET DEFAULT nextval('all_trials_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY billings ALTER COLUMN id SET DEFAULT nextval('billings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY group_assignments ALTER COLUMN id SET DEFAULT nextval('group_assignments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY groups_catalogue ALTER COLUMN id SET DEFAULT nextval('groups_catalogue_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY patient_visits ALTER COLUMN id SET DEFAULT nextval('patient_visits_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY patients ALTER COLUMN id SET DEFAULT nextval('patients_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY personnel_catalogue ALTER COLUMN id SET DEFAULT nextval('personnel_catalogue_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY personnel_costs ALTER COLUMN id SET DEFAULT nextval('personnel_costs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY personnel_event ALTER COLUMN id SET DEFAULT nextval('personnel_event_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY personnel_event_catalogue ALTER COLUMN id SET DEFAULT nextval('personnel_event_catalogue_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY personnel_properties ALTER COLUMN id SET DEFAULT nextval('personnel_properties_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY personnel_properties_catalogue ALTER COLUMN id SET DEFAULT nextval('personnel_properties_catalogue_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY procedures_catalogue ALTER COLUMN id SET DEFAULT nextval('procedures_catalogue_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY procedures_personnel ALTER COLUMN id SET DEFAULT nextval('procedures_personnel_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY process_steps_catalogue ALTER COLUMN id SET DEFAULT nextval('process_steps_catalogue_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY roles_catalogue ALTER COLUMN id SET DEFAULT nextval('roles_catalogue_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY shadow_accounts ALTER COLUMN id SET DEFAULT nextval('shadow_accounts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY status_catalogue ALTER COLUMN id SET DEFAULT nextval('status_catalogue_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trial_personnel ALTER COLUMN id SET DEFAULT nextval('trial_personnel_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trial_process_step ALTER COLUMN id SET DEFAULT nextval('trial_process_step_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trial_properties ALTER COLUMN id SET DEFAULT nextval('trial_properties_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trial_properties_catalogue ALTER COLUMN id SET DEFAULT nextval('trial_properties_catalogue_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY trial_property_annotations ALTER COLUMN id SET DEFAULT nextval('trial_property_annotations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY trial_visits ALTER COLUMN id SET DEFAULT nextval('trial_visits_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY visit_procedures ALTER COLUMN id SET DEFAULT nextval('visit_procedures_id_seq'::regclass);


--
-- Data for Name: account_transaction; Type: TABLE DATA; Schema: public; Owner: root
--

COPY account_transaction (id, idaccount, date_transaction, type, amount_change, description) FROM stdin;
\.


--
-- Name: account_transaction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('account_transaction_id_seq', 610, true);


--
-- Data for Name: all_trials; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY all_trials (id, idgroup, name, codename, infotext) FROM stdin;
195	100	New trial 2	\N	\N
196	19	New trial 3	\N	\N
25	1	Demo 11001X	\N	\N
197	1	Demo 11002X	\N	\N
194	1	Demo 11003X	\N	\N
\.


--
-- Name: all_trials_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('all_trials_id_seq', 197, true);


--
-- Data for Name: bic_catalogue; Type: TABLE DATA; Schema: public; Owner: root
--

COPY bic_catalogue ("row.names", blz, name, bic) FROM stdin;
1	39020000	Aachener Bauspk Aachen	AABSDE31XXX
2	39050000	Sparkasse Aachen	AACSDE33XXX
3	10010424	Aareal Bank	AARBDE5W100
4	51010800	Aareal Bank Zw L Wiesbaden	AARBDE5W108
5	20010424	Aareal Bank	AARBDE5W200
6	25010424	Aareal Bank	AARBDE5W250
7	36010424	Aareal Bank Essen	AARBDE5W360
8	50010424	Aareal Bank	AARBDE5W500
9	55010424	Aareal Bank	AARBDE5W550
10	60010424	Aareal Bank	AARBDE5W600
11	70010424	Aareal Bank	AARBDE5W700
12	86010424	Aareal Bank	AARBDE5W860
13	55010625	Aareal Clearing Wiesbaden	AARBDE5WCLE
14	55010400	Aareal Bank GF - BK01 -	AARBDE5WDOM
15	51010400	Aareal Bank	AARBDE5WXXX
16	50230000	ABC International Bank Ffm	ABCADEFFXXX
17	52420600	Piraeus Bank Frankfurt	ABGRDEFFXXX
18	10030400	ABK-Kreditbank Berlin	ABKBDEB1XXX
19	51230400	RBS Deutschland FFM	ABNADE55FRA
20	50230400	RBS NDL Frankfurt	ABNADEFFFRA
21	50038800	Agricultural Bank China FRA	ABOCDEFFXXX
22	50020900	COREALCREDIT BANK	AHYBDEFFXXX
23	60030700	AKTIVBANK Pforzheim	AKBADES1XXX
24	37020600	Santander Consumer Bk Köln	AKBCDE31XXX
25	50010200	AKBANK	AKBKDEFFXXX
26	33020000	akf bank Wuppertal	AKFBDE31XXX
27	50012800	ALTE LEIPZIGER Bauspar	ALTEDEFAXXX
28	72030227	Bankhaus Anton Hafner	ANHODE77XXX
29	51230600	Europe ARAB Bank Frankfurt	ARABDEFFXXX
30	27020001	Audi Bank Braunschweig	AUDFDE21XXX
31	72020700	Augsburger Aktienbank	AUGBDE77XXX
32	72050000	St Spk Augsburg	AUGSDE77XXX
33	50110400	AKA Ausfuhrkredit Frankfurt	AUSKDEFFXXX
34	70011300	Autobank Oberhaching	AUZDDEM1XXX
35	37020200	AXA Bank Köln	AXABDE31XXX
36	50023400	Bank of Beirut Frankfurt	BABEDEFFXXX
37	51420300	Bank Julius Bär Frankfurt	BAERDEF1XXX
38	30120500	KBC Bank Düsseldorf	BANVDEHB300
39	50020300	KBC Bank Frankfurt	BANVDEHB500
40	29020100	KBC Bank Bremen	BANVDEHBXXX
41	50310455	Reiseschecks - Barclays Ffm	BARCDEF1TCS
42	50310400	Barclays Bank Frankfurt	BARCDEFFXXX
43	20130600	Barclaycard	BARCDEHAXXX
44	60350130	Kr Spk Böblingen	BBKRDE6BXXX
45	50810900	DBS Badenia eh. DBS Bauspar	BBSPDE6KXXX
46	66010200	Deutsche Bauspk Badenia	BBSPDE6KXXX
47	50330500	CHAABI BANK FRANKFURT	BCDMDEF1XXX
48	70020800	INTESA SANPAOLO München	BCITDEFFMUC
49	50020800	Intesa Sanpaolo Frankfurt	BCITDEFFXXX
50	27032500	Seeligerbank Wolfenbüttel	BCLSDE21XXX
51	50320600	Attijariwafa bank Frankfurt	BCMADEFFXXX
52	70033100	Baaderbank Unterschleißheim	BDWBDEMMXXX
53	20120000	Berenberg, Hamburg	BEGODEHHXXX
54	10050005	Landesbank Berlin - E 1 -	BELADEB1DB5
55	10050006	Landesbank Berlin - E 2 -	BELADEB1DB6
56	10050007	Landesbank Berlin - E 3 -	BELADEB1DB7
57	10050008	Landesbank Berlin - E 4 -	BELADEB1DB8
58	10050000	LBB - Berliner Sparkasse	BELADEBEXXX
59	70110600	UBI BANCA INT München	BEPODEMMXXX
60	10090000	Berliner VB Berlin	BEVODEBBXXX
61	51091711	Bk f Orden u Mission Idstn	BFOMDE51XXX
62	10020500	Bank für Sozialwirtschaft	BFSWDE33BER
63	85020500	Bank für Sozialwirtschaft	BFSWDE33DRE
64	25120510	Bank für Sozialwirtschaft	BFSWDE33HAN
65	66020500	Bank für Sozialwirtschaft	BFSWDE33KRL
66	86020500	Bank für Sozialwirtschaft	BFSWDE33LPZ
67	81020500	Bank für Sozialwirtschaft	BFSWDE33MAG
68	55020500	Bank für Sozialwirtschaft	BFSWDE33MNZ
69	70020500	Bank für Sozialwirtschaft	BFSWDE33MUE
70	60120500	Bank für Sozialwirtschaft	BFSWDE33STG
71	37020500	Bank für Sozialwirtschaft	BFSWDE33XXX
72	70011400	BfW-Bank	BFWODE71XXX
73	60030100	Bankhaus Bauer, Stuttgart	BHBADES1XXX
74	10020200	BHF-BANK Berlin	BHFBDEFF100
75	20120200	BHF-BANK Hamburg	BHFBDEFF200
76	25020200	BHF-BANK Hannover	BHFBDEFF250
77	30020500	BHF-BANK Düsseldorf	BHFBDEFF300
78	50020200	BHF-BANK Frankfurt Main	BHFBDEFF500
79	51020000	BHF-BANK Wiesbaden	BHFBDEFF510
80	55020000	BHF-BANK Mainz	BHFBDEFF550
81	60120200	BHF-BANK Stuttgart	BHFBDEFF600
82	70220200	BHF-BANK München	BHFBDEFF700
83	70031000	Bankhaus Sperrer Freising	BHLSDEM1XXX
84	25410200	BHW Bauspk Hameln	BHWBDE2HXXX
85	10030200	Berlin Hyp	BHYPDEB2XXX
86	56250030	Kr Spk Birkenfeld	BILADE55XXX
87	30330800	BIW Bank	BIWBDE33303
88	76030800	BIW Bank	BIWBDE33760
89	10130800	BIW Bank	BIWBDE33XXX
90	20110800	Bank of China Hamburg	BKCHDEFFHMB
91	51410700	Bank of China Frankfurt	BKCHDEFFXXX
92	68030000	Bankhaus E Mayer Freiburg B	BKMADE61XXX
93	55020100	Bausparkasse Mainz	BKMZDE51XXX
94	70220300	BMW Bank München	BMWBDEMUXXX
95	51210600	BNP PARIBAS Frankfurt, Main	BNPADEFFXXX
96	51210699	BNP PARIBAS Frankfurt, Main	BNPADEFFXXX
97	50334400	BNY Mellon NL FFM	BNYMDEF1XXX
98	50010910	Bank of America	BOFADEFXVAM
99	50010900	Bankamerica	BOFADEFXXXX
100	10220500	Bank of Scotland Berlin	BOFSDEB1XXX
101	50220500	Bank of Scotland	BOFSDEF1XXX
102	30010700	BTMU Düsseldorf	BOTKDEDXXXX
103	20110700	BTMU Hamburg	BOTKDEH1XXX
104	51410800	OnVista Bank Frankfurt/Main	BOURDEFFXXX
105	50030010	Banque PSA Finance	BPNDDE52XXX
106	51220800	Banco do Brasil Frankfurt	BRASDEFFXXX
107	28350000	Spk Aurich-Norden	BRLADE21ANO
108	29250150	Kr Spk Wesermünde-Hadeln	BRLADE21BRK
109	29250000	Spk Bremerhaven	BRLADE21BRS
110	24150001	St Spk Cuxhaven	BRLADE21CUX
111	25651325	Kr Spk Diepholz	BRLADE21DHZ
112	28450000	Sparkasse Emden	BRLADE21EMD
113	28550000	Sparkasse LeerWittmund	BRLADE21LER
114	28050100	Landessparkasse Oldenburg	BRLADE21LZO
115	29152300	Kr Spk Osterholz	BRLADE21OHZ
116	24151235	Spk Rotenburg-Bremervörde	BRLADE21ROB
117	29152550	Spk Scheeßel	BRLADE21SHL
118	29151700	Kreissparkasse Syke	BRLADE21SYK
119	29152670	Kr Spk Verden	BRLADE21VER
120	28250110	Sparkasse Wilhelmshaven	BRLADE21WHV
121	28252760	Kr Spk Wittmund	BRLADE21WTM
122	29050000	Bremer Landesbank Oldenburg	BRLADE22OLD
123	29050000	Bremer Landesbank Bremen	BRLADE22XXX
124	66350036	Spk Kraichgau	BRUSDE66XXX
125	50320500	Banco Santander Ffm	BSCHDEFFXXX
126	79032038	Bank Schilling Hammelburg	BSHADE71XXX
127	62220000	Bauspk Schwäbisch Hall	BSHHDE61XXX
128	52420000	Credit Agricole Deutschland	BSUIDEFFXXX
129	60033000	Wüstenrot Bausparkasse	BSWLDE61XXX
130	72012300	BTV Zndl Deutschland	BTVADE61XXX
131	70011700	Bankhaus von der Heydt	BVDHDEMMXXX
132	70013155	net-m privatbk 1891 TRAXPAY	BVWBDE2TRAX
133	70013100	net-m privatbank 1891	BVWBDE2WXXX
134	70013199	net-m privatbank 1891	BVWBDE2WXXX
135	12030000	Deutsche Kreditbank Berlin	BYLADEM1001
136	75250000	Sparkasse Amberg-Sulzbach	BYLADEM1ABG
137	72051210	Spk Aichach-Schrobenhausen	BYLADEM1AIC
138	73350000	Sparkasse Allgäu	BYLADEM1ALG
139	73351635	Sparkasse Riezlern	BYLADEM1ALR
140	76550000	Ver Spk Ansbach	BYLADEM1ANS
141	71051010	Kr Spk Altötting-Burgh-alt-	BYLADEM1AOE
142	79550000	Spk Aschaffenburg Alzenau	BYLADEM1ASA
143	72050101	Kr Spk Augsburg	BYLADEM1AUG
144	71151240	Kr Spk Bad Aibling -alt-	BYLADEM1BAB
145	71050000	Spk Berchtesgadener Land	BYLADEM1BGL
146	74251020	Spk im Landkreis Cham	BYLADEM1CHM
147	78350000	Spk Coburg-Lichtenfels	BYLADEM1COB
148	70051540	Sparkasse Dachau	BYLADEM1DAH
149	74150000	Spk Deggendorf	BYLADEM1DEG
150	74351310	Spk Dingolfing-Landau -alt-	BYLADEM1DGF
151	76551020	Kr u St Spk Dinkelsbühl	BYLADEM1DKB
152	72251520	Kr u St Spk Dillingen	BYLADEM1DLG
153	72250160	Spk Donauwörth	BYLADEM1DON
154	70051805	Kr Spk München Starnbg Ebbg	BYLADEM1EBE
155	74351430	Spk Rottal-Inn Eggenfelden	BYLADEM1EGF
156	72151340	Sparkasse Eichstätt	BYLADEM1EIS
157	70051995	Spk Erding-Dorfen	BYLADEM1ERD
158	76350000	St u Kr Spk Erlangen	BYLADEM1ERH
159	75351960	Ver Spk Eschenbach	BYLADEM1ESB
160	70053070	Spk Fürstenfeldbruck	BYLADEM1FFB
161	78055050	Spk Hochfranken -alt-	BYLADEM1FIG
162	76351040	Sparkasse Forchheim	BYLADEM1FOR
163	74051230	Spk Freyung-Grafenau	BYLADEM1FRG
164	70051003	Sparkasse Freising	BYLADEM1FSI
165	70350000	Kr Spk Garmisch-Partenkirch	BYLADEM1GAP
166	76551540	Ver Spk Gunzenhausen	BYLADEM1GUN
167	72051840	Spk Günzburg-Krumbach	BYLADEM1GZK
168	79351730	Spk Ostunterfranken	BYLADEM1HAS
169	78050000	Spk Hochfranken	BYLADEM1HOF
170	76351560	Kr Spk Höchstadt	BYLADEM1HOS
171	72150000	Sparkasse Ingolstadt	BYLADEM1ING
172	75051565	Kreissparkasse Kelheim	BYLADEM1KEH
173	73450000	Kr u St Spk Kaufbeuren	BYLADEM1KFB
174	79351010	Spk Bad Kissingen	BYLADEM1KIS
175	70250150	Kr Spk München Starnbg Ebbg	BYLADEM1KMS
176	79350101	Sparkasse Schweinfurt	BYLADEM1KSW
177	77150000	Spk Kulmbach-Kronach	BYLADEM1KUB
178	74350000	Spk Landshut	BYLADEM1LAH
179	70052060	Spk Landsberg-Dießen	BYLADEM1LLD
180	71151020	Spk Altötting-Mühldorf	BYLADEM1MDF
181	71152570	Kr Spk Miesbach-Tegernsee	BYLADEM1MIB
182	79650000	Spk Miltenberg-Obernburg	BYLADEM1MIL
183	73150000	Spk Memmingen-Lindau-Mindel	BYLADEM1MLM
184	74351740	St u Kr Spk Moosburg	BYLADEM1MSB
185	76251020	Spk i Landkreis Neustadt	BYLADEM1NEA
186	72152070	Spk Neuburg-Rain	BYLADEM1NEB
187	79353090	Spk Bad Neustadt a d Saale	BYLADEM1NES
188	72250000	Sparkasse Nördlingen	BYLADEM1NLG
189	76052080	Spk Neumarkt i d OPf-Parsbg	BYLADEM1NMA
190	73050000	Spk Neu-Ulm Illertissen	BYLADEM1NUL
191	72151650	Spk Pfaffenhofen	BYLADEM1PAF
192	74050000	Spk Passau	BYLADEM1PAS
193	75050000	Spk Regensburg	BYLADEM1RBG
194	74151450	Sparkasse Regen-Viechtach	BYLADEM1REG
195	71150000	Spk Rosenheim-Bad Aibling	BYLADEM1ROS
196	76551860	St u Kr Spk Rothenburg	BYLADEM1ROT
197	75051040	Spk im Landkreis Schwandorf	BYLADEM1SAD
198	77350110	Sparkasse Bayreuth	BYLADEM1SBT
199	76250000	Spk Fürth	BYLADEM1SFU
200	77050000	Spk Bamberg	BYLADEM1SKB
201	73451450	Kr Spk Schongau	BYLADEM1SOG
202	74250000	Spk Niederbayern-Mitte	BYLADEM1SRG
203	76450000	Spk Mittelfranken-Süd	BYLADEM1SRS
204	72151880	Spk Aichach-Schrobenhausen	BYLADEM1SSH
205	79350000	Städt.Spk Schweinfurt -alt-	BYLADEM1SSW
206	79050000	Spk Mainfranken Würzburg	BYLADEM1SWU
207	71052050	Kr Spk Traunstein-Trostberg	BYLADEM1TST
208	75350000	Spk Oberpfalz Nord	BYLADEM1WEN
209	70351030	Ver Spk Weilheim	BYLADEM1WHM
210	70054306	Spk Bad Tölz-Wolfratshausen	BYLADEM1WOR
211	71152680	Kr u St Spk Wasserburg	BYLADEM1WSB
212	70050000	BayernLB München	BYLADEMMXXX
213	76050000	BayernLB Nürnberg	BYLADEMMXXX
214	52411010	Cash Express Gf2 Frankfurt	CAGBDEF1CMI
215	52411000	Cash Express Frankfurt	CAGBDEF1XXX
216	74290100	CB Bank Straubing	CBSRDE71XXX
217	31010833	Santander Consumer Bank MG	CCBADE31XXX
218	50110801	J.P. Morgan, IR, Ffm	CHASDEFXVR1
219	50110800	J.P. Morgan Frankfurt	CHASDEFXXXX
220	20030300	DONNER & REUSCHEL	CHDBDEHHXXX
221	70030300	Bankhaus Reuschel & Co -alt	CHDBDEHHXXX
222	87050000	Sparkasse Chemnitz	CHEKDE81GLA
223	87050000	Sparkasse Chemnitz	CHEKDE81HOT
224	87050000	Sparkasse Chemnitz	CHEKDE81LIM
225	87050000	Sparkasse Chemnitz	CHEKDE81LTS
226	87050000	Sparkasse Chemnitz	CHEKDE81MRN
227	87050000	Sparkasse Chemnitz	CHEKDE81OLW
228	87050000	Sparkasse Chemnitz	CHEKDE81XXX
229	50210900	Citigroup GM Frankfurt	CITIDEFFXXX
230	25010900	Calenbg Kreditver Hannover	CKVHDE21XXX
231	70012000	UCFin München	CLABDEMMXXX
232	30020900	TARGOBANK Düsseldorf	CMCIDEDDXXX
233	52430000	Credit Mutuel - BECM	CMCIDEF1XXX
234	52430100	BFCM Ndl Deutschland	CMCIDEFFXXX
235	12040000	Commerzbank Fil. Berlin 2	COBADEBB120
236	10040000	Commerzbank Fil. Berlin 1	COBADEBBXXX
237	30040000	Commerzbank Düsseldorf	COBADEDDXXX
238	33040310	Commerzbank Zw 117	COBADEDHXXX
239	50040033	Commerzbank Gf BRS Ffm	COBADEF1BRS
240	10040010	Commerzbank CC SP, Berlin	COBADEFFXXX
241	10040048	Commerzbank BER GF-B48	COBADEFFXXX
242	10040060	Commerzbank Gf 160 Berlin	COBADEFFXXX
243	10040061	Commerzbank Gf 161 Berlin	COBADEFFXXX
244	10040062	Commerzbank CC Berlin	COBADEFFXXX
245	10040063	Commerzbank CC Berlin	COBADEFFXXX
246	10040085	Commerzbank Gf WK, Berlin	COBADEFFXXX
247	10045050	Commerzbank Service-BZ	COBADEFFXXX
248	13040000	Commerzbank Rostock	COBADEFFXXX
249	14040000	Commerzbank Schwerin	COBADEFFXXX
250	15040068	Commerzbank Neubrandenburg	COBADEFFXXX
251	16040000	Commerzbank Potsdam	COBADEFFXXX
252	17040000	Commerzbank Frankfurt Oder	COBADEFFXXX
253	18040000	Commerzbank Cottbus	COBADEFFXXX
254	20040020	Commerzbank CC SP, Hamburg	COBADEFFXXX
255	20040040	Commerzbank GF RME, Hamburg	COBADEFFXXX
256	20040048	Commerzbank HBG GF-H48	COBADEFFXXX
257	20040050	Commerzbank GF COC	COBADEFFXXX
258	20040060	Commerzbank Gf 260 Hamburg	COBADEFFXXX
259	20040061	Commerzbank Gf 261 Hamburg	COBADEFFXXX
260	20040062	Commerzbank CC Hamburg	COBADEFFXXX
261	20040063	Commerzbank CC Hamburg	COBADEFFXXX
262	21040010	Commerzbank Kiel	COBADEFFXXX
263	21042076	Commerzbank Eckernförde	COBADEFFXXX
264	21240040	Commerzbank Neumünster	COBADEFFXXX
265	21241540	Commerzbank Bad Bramstedt	COBADEFFXXX
266	21340010	Commerzbank Neustadt Holst	COBADEFFXXX
267	21440045	Commerzbank Rendsburg	COBADEFFXXX
268	21540060	Commerzbank Flensburg	COBADEFFXXX
269	21740043	Commerzbank Husum Nordsee	COBADEFFXXX
270	21741674	Commerzbank Niebüll	COBADEFFXXX
271	21741825	Commerzbank Westerland	COBADEFFXXX
272	21840078	Commerzbank Heide Holst	COBADEFFXXX
273	21841328	Commerzbank Brunsbüttel	COBADEFFXXX
274	22140028	Commerzbank Elmshorn	COBADEFFXXX
275	22141028	Commerzbank Kaltenkirchen	COBADEFFXXX
276	22141428	Commerzbank Pinneberg	COBADEFFXXX
277	22141628	Commerzbank Uetersen	COBADEFFXXX
278	22240073	Commerzbank Itzehoe	COBADEFFXXX
279	23040022	Commerzbank Lübeck	COBADEFFXXX
280	24040000	Commerzbank Lüneburg	COBADEFFXXX
281	24140041	Commerzbank Cuxhaven	COBADEFFXXX
282	25040060	Commerzbank CC Hannover	COBADEFFXXX
283	25040061	Commerzbank CC Hannover	COBADEFFXXX
284	25040066	Commerzbank Hannover	COBADEFFXXX
285	25440047	Commerzbank Hameln	COBADEFFXXX
286	25541426	Commerzbank Bückeburg	COBADEFFXXX
287	25641302	Commerzbank Diepholz	COBADEFFXXX
288	25740061	Commerzbank Celle	COBADEFFXXX
289	25840048	Commerzbank Uelzen	COBADEFFXXX
290	25841403	Commerzbank Lüchow	COBADEFFXXX
291	25841708	Commerzbank Schneverdingen	COBADEFFXXX
292	25940033	Commerzbank Hildesheim	COBADEFFXXX
293	26040030	Commerzbank Göttingen	COBADEFFXXX
294	26240039	Commerzbank Northeim Han	COBADEFFXXX
295	26340056	Commerzbank Osterode Harz	COBADEFFXXX
296	26341072	Commerzbank Herzberg Harz	COBADEFFXXX
297	26540070	Commerzbank Osnabrück	COBADEFFXXX
298	26640049	Commerzbank Lingen Ems	COBADEFFXXX
299	26740044	Commerzbank Nordhorn	COBADEFFXXX
300	26840032	Commerzbank Goslar	COBADEFFXXX
301	26941053	Commerzbank Wolfsburg	COBADEFFXXX
302	27040080	Commerzbank Braunschweig	COBADEFFXXX
303	27240004	Commerzbank Holzminden	COBADEFFXXX
304	28040046	Commerzbank Oldenburg	COBADEFFXXX
305	28042865	Commerzbank Vechta	COBADEFFXXX
306	28240023	Commerzbank Wilhelmshaven	COBADEFFXXX
307	28440037	Commerzbank Emden	COBADEFFXXX
308	28540034	Commerzbank Leer Ostfriesld	COBADEFFXXX
309	29040060	Commerzbank CC Bremen	COBADEFFXXX
310	29040061	Commerzbank CC Bremen	COBADEFFXXX
311	29040090	Commerzbank Bremen	COBADEFFXXX
312	29240024	Commerzbank Bremerhaven	COBADEFFXXX
313	30040048	Commerzbank DDF GF-D48	COBADEFFXXX
314	30040060	Commerzbank Gf 660 Düsseldf	COBADEFFXXX
315	30040061	Commerzbank Gf 661 Düsseldf	COBADEFFXXX
316	30040062	Commerzbank CC Düsseldorf	COBADEFFXXX
317	30040063	Commerzbank CC Düsseldorf	COBADEFFXXX
318	31040015	Commerzbank Mönchengladbach	COBADEFFXXX
319	31040060	Commerzbank CC Mgladbach	COBADEFFXXX
320	31040061	Commerzbank CC Mgladbach	COBADEFFXXX
321	32040024	Commerzbank Krefeld	COBADEFFXXX
322	32440023	Commerzbank Kleve Niederrh	COBADEFFXXX
323	33040001	Commerzbank Wuppertal	COBADEFFXXX
324	33440035	Commerzbank Velbert	COBADEFFXXX
325	34040049	Commerzbank Remscheid	COBADEFFXXX
326	34240050	Commerzbank Solingen	COBADEFFXXX
327	35040038	Commerzbank Duisburg	COBADEFFXXX
328	35040085	Commerzbank Gf WK, Duisburg	COBADEFFXXX
329	35640064	Commerzbank Wesel	COBADEFFXXX
330	36040039	Commerzbank Essen	COBADEFFXXX
331	36040060	Commerzbank CC Essen	COBADEFFXXX
332	36040061	Commerzbank CC Essen	COBADEFFXXX
333	36040085	Commerzbank Gf WK, Essen	COBADEFFXXX
334	36240045	Commerzbank Mülheim Ruhr	COBADEFFXXX
335	36540046	Commerzbank Oberhausen	COBADEFFXXX
336	37040037	Commerzbank CC SP, Köln	COBADEFFXXX
337	37040044	Commerzbank Köln	COBADEFFXXX
338	37040048	Commerzbank KOE GF-K48	COBADEFFXXX
339	37040060	Commerzbank CC Köln	COBADEFFXXX
340	37040061	Commerzbank CC Köln	COBADEFFXXX
341	37540050	Commerzbank Leverkusen	COBADEFFXXX
342	38040007	Commerzbank Bonn	COBADEFFXXX
343	38440016	Commerzbank Gummersbach	COBADEFFXXX
344	39040013	Commerzbank Aachen	COBADEFFXXX
345	39540052	Commerzbank Düren	COBADEFFXXX
346	40040028	Commerzbank Münster Westf	COBADEFFXXX
347	40340030	Commerzbank Rheine Westf	COBADEFFXXX
348	41040018	Commerzbank Hamm Westf	COBADEFFXXX
349	41041000	ZTB der Commerzbank	COBADEFFXXX
350	41240048	Commerzbank BE F-B48	COBADEFFXXX
351	41440018	Commerzbank Soest Westf	COBADEFFXXX
352	42040040	Commerzbank Gelsenkirchen	COBADEFFXXX
353	42640048	Commerzbank Recklinghausen	COBADEFFXXX
354	42840005	Commerzbank Bocholt	COBADEFFXXX
355	43040036	Commerzbank Bochum	COBADEFFXXX
356	44040037	Commerzbank Dortmund	COBADEFFXXX
357	44040060	Commerzbank CC Dortmund	COBADEFFXXX
358	44040061	Commerzbank CC Dortmund	COBADEFFXXX
359	44040085	Commerzbank Gf WK, Dortmund	COBADEFFXXX
360	44340037	Commerzbank Unna	COBADEFFXXX
361	44540022	Commerzbank Iserlohn	COBADEFFXXX
362	45040042	Commerzbank Hagen Westf	COBADEFFXXX
363	45240056	Commerzbank Witten	COBADEFFXXX
364	45840026	Commerzbank Lüdenscheid	COBADEFFXXX
365	45841031	Commerzbank Plettenberg	COBADEFFXXX
366	46040033	Commerzbank Siegen Westf	COBADEFFXXX
367	46240016	Commerzbank Olpe Biggesee	COBADEFFXXX
368	46441003	Commerzbank Meschede	COBADEFFXXX
369	46640018	Commerzbank Arnsberg-Neheim	COBADEFFXXX
370	47240047	Commerzbank Paderborn	COBADEFFXXX
371	47640051	Commerzbank Detmold	COBADEFFXXX
372	47840065	Commerzbank Gütersloh	COBADEFFXXX
373	47840080	Commerzbank Zw 80	COBADEFFXXX
374	48040035	Commerzbank Bielefeld	COBADEFFXXX
375	48040060	Commerzbank CC Bielefeld	COBADEFFXXX
376	48040061	Commerzbank CC Bielefeld	COBADEFFXXX
377	49040043	Commerzbank Minden Westf	COBADEFFXXX
378	49240096	Commerzbank Bünde Westf	COBADEFFXXX
379	49440043	Commerzbank Herford	COBADEFFXXX
380	50040000	Commerzbank Frankfurt Main	COBADEFFXXX
381	50040038	Commerzbank MBP, Frankfurt	COBADEFFXXX
382	50040040	Commerzbank ZRK Frankfurt	COBADEFFXXX
383	50040048	Commerzbank FFM GF-F48	COBADEFFXXX
384	50040050	Commerzbank CC SP, Ffm	COBADEFFXXX
385	50040051	Commerzbank FFM GM-F A 51	COBADEFFXXX
386	50040052	Commerzbank Service - BZ	COBADEFFXXX
387	50040060	Commerzbank Gf 460 Ffm	COBADEFFXXX
388	50040061	Commerzbank Gf 461 Ffm	COBADEFFXXX
389	50040062	Commerzbank CC Ffm	COBADEFFXXX
390	50040063	Commerzbank CC Ffm	COBADEFFXXX
391	50040075	Commerzbank Gf ZCM Ffm	COBADEFFXXX
392	50040085	Commerzbank Gf WK, Ffm	COBADEFFXXX
393	50040086	Commerzbank GF WK CMTS, FFM	COBADEFFXXX
394	50040088	Commerzbank INT 1 Ffm	COBADEFFXXX
395	50040099	Commerzbank INT Ffm	COBADEFFXXX
396	50042500	Commerzbank Frankfurt	COBADEFFXXX
397	50044444	Commerzbank Vermverw Ffm	COBADEFFXXX
398	50047010	Commerzbank Service - BZ	COBADEFFXXX
399	50540028	Commerzbank Offenbach Main	COBADEFFXXX
400	50640015	Commerzbank Hanau Main	COBADEFFXXX
401	50740048	Commerzbank GH F-G48	COBADEFFXXX
402	50840005	Commerzbank Darmstadt	COBADEFFXXX
403	51040038	Commerzbank Wiesbaden	COBADEFFXXX
404	51140029	Commerzbank Limburg Lahn	COBADEFFXXX
405	51340013	Commerzbank Gießen	COBADEFFXXX
406	51343224	Commerzbank Alsfeld	COBADEFFXXX
407	51540037	Commerzbank Wetzlar	COBADEFFXXX
408	51640043	Commerzbank Dillenburg	COBADEFFXXX
409	52040021	Commerzbank Kassel	COBADEFFXXX
410	52240006	Commerzbank Eschwege	COBADEFFXXX
411	53040012	Commerzbank Fulda	COBADEFFXXX
412	53240048	Commerzbank Bad Hersfeld	COBADEFFXXX
413	53340024	Commerzbank Marburg Lahn	COBADEFFXXX
414	54040042	Commerzbank Kaiserslautern	COBADEFFXXX
415	54240032	Commerzbank Pirmasens	COBADEFFXXX
416	54540033	Commerzbank Ludwigshafen Rh	COBADEFFXXX
417	54640035	Commerzbank Neustadt Weinst	COBADEFFXXX
418	55040022	Commerzbank Mainz	COBADEFFXXX
419	55040060	Commerzbank CC Mainz	COBADEFFXXX
420	55040061	Commerzbank CC Mainz	COBADEFFXXX
421	55080044	CommerzBk TF MZ 1, Mainz	COBADEFFXXX
422	55340041	Commerzbank Worms	COBADEFFXXX
423	56240050	Commerzbank Idar-Oberstein	COBADEFFXXX
424	57040044	Commerzbank Koblenz	COBADEFFXXX
425	58540035	Commerzbank Trier	COBADEFFXXX
426	59040000	Commerzbank Saarbrücken	COBADEFFXXX
427	60040060	Commerzbank CC Stuttgart	COBADEFFXXX
428	60040061	Commerzbank CC Stuttgart	COBADEFFXXX
429	60040071	Commerzbank Stuttgart	COBADEFFXXX
430	60241074	Commerzbank Backnang	COBADEFFXXX
431	60340071	Commerzbank Sindelfingen	COBADEFFXXX
432	60440073	Commerzbank Ludwigsburg	COBADEFFXXX
433	61040014	Commerzbank Göppingen	COBADEFFXXX
434	61140071	Commerzbank Esslingen	COBADEFFXXX
435	61240048	Commerzbank NT F-N48	COBADEFFXXX
436	61340079	Commerzbank Schwäb Gmünd	COBADEFFXXX
437	61440086	Commerzbank Aalen Württ	COBADEFFXXX
438	62040060	Commerzbank Heilbronn	COBADEFFXXX
439	62240048	Commerzbank SH F-S48	COBADEFFXXX
440	63040053	Commerzbank Ulm Donau	COBADEFFXXX
441	63240016	Commerzbank Heidenheim	COBADEFFXXX
442	64040033	Commerzbank Reutlingen	COBADEFFXXX
443	64040045	Commerzbank Metzingen Würt	COBADEFFXXX
444	64140036	Commerzbank Tübingen	COBADEFFXXX
445	64240048	Commerzbank TR F-T48	COBADEFFXXX
446	64240071	Commerzbank Rottweil	COBADEFFXXX
447	65040073	Commerzbank Ravensburg	COBADEFFXXX
448	65140072	Commerzbank Friedrichshafen	COBADEFFXXX
449	65340004	Commerzbank Albstadt	COBADEFFXXX
450	65341204	Commerzbank Balingen	COBADEFFXXX
451	65440087	Commerzbank Biberach Riß	COBADEFFXXX
452	66040018	Commerzbank Karlsruhe	COBADEFFXXX
453	66040026	Commerzbank Karlsruhe	COBADEFFXXX
454	66240002	Commerzbank Baden-Baden	COBADEFFXXX
455	66340018	Commerzbank Bruchsal	COBADEFFXXX
456	66440084	Commerzbank Offenburg	COBADEFFXXX
457	66640035	Commerzbank Pforzheim	COBADEFFXXX
458	67040031	Commerzbank Mannheim	COBADEFFXXX
459	67040060	Commerzbank CC Mannheim	COBADEFFXXX
460	67040061	Commerzbank CC Mannheim	COBADEFFXXX
461	67040085	Commerzbank Gf WK, Mannheim	COBADEFFXXX
462	67240039	Commerzbank Heidelberg	COBADEFFXXX
463	68040007	Commerzbank Freiburg i Br	COBADEFFXXX
464	68340058	Commerzbank Lörrach	COBADEFFXXX
465	69040045	Commerzbank Konstanz	COBADEFFXXX
466	69240075	Commerzbank Singen Hohentw	COBADEFFXXX
467	69440007	Commerzbank Villingen-Schw	COBADEFFXXX
468	69440060	Commerzbank CC Villingen	COBADEFFXXX
469	70040041	Commerzbank München	COBADEFFXXX
470	70040048	Commerzbank MUE GF-M48	COBADEFFXXX
471	70040060	Commerzbank Gf 860 München	COBADEFFXXX
472	70040061	Commerzbank Gf 861 München	COBADEFFXXX
473	70040062	Commerzbank CC München	COBADEFFXXX
474	70040063	Commerzbank CC München	COBADEFFXXX
475	70040070	Commerzbank CC SP, München	COBADEFFXXX
476	70045050	Commerzbank Service-BZ	COBADEFFXXX
477	71140041	Commerzbank Rosenheim	COBADEFFXXX
478	71141041	Commerzbank Mühldorf Inn	COBADEFFXXX
479	71142041	Commerzbank Waldkraiburg	COBADEFFXXX
480	72040046	Commerzbank Augsburg	COBADEFFXXX
481	72140052	Commerzbank Ingolstadt	COBADEFFXXX
482	73140046	Commerzbank Memmingen	COBADEFFXXX
483	73340046	Commerzbank Kempten Allgäu	COBADEFFXXX
484	73440048	Commerzbank KB F-K48	COBADEFFXXX
485	74040082	Commerzbank Passau	COBADEFFXXX
486	74140048	Commerzbank DE F-D48	COBADEFFXXX
487	74240062	Commerzbank Straubing	COBADEFFXXX
488	74340077	Commerzbank Landshut	COBADEFFXXX
489	75040062	Commerzbank Regensburg	COBADEFFXXX
490	75240000	Commerzbank Amberg Oberpf	COBADEFFXXX
491	75340090	Commerzbank Weiden Oberpf	COBADEFFXXX
492	76040060	Commerzbank CC Nürnberg	COBADEFFXXX
493	76040061	Commerzbank Nürnberg	COBADEFFXXX
494	76040062	Commerzbank CC Nürnberg	COBADEFFXXX
495	76240011	Commerzbank Fürth Bayern	COBADEFFXXX
496	76340061	Commerzbank Erlangen	COBADEFFXXX
497	77040080	Commerzbank Bamberg	COBADEFFXXX
498	77140061	Commerzbank Kulmbach	COBADEFFXXX
499	77340076	Commerzbank Bayreuth	COBADEFFXXX
500	78040081	Commerzbank Hof Saale	COBADEFFXXX
501	78140000	Commerzbank Tirschenreuth	COBADEFFXXX
502	78340091	Commerzbank Coburg	COBADEFFXXX
503	79040047	Commerzbank Würzburg	COBADEFFXXX
504	79340054	Commerzbank Schweinfurt	COBADEFFXXX
505	79540049	Commerzbank Aschaffenburg	COBADEFFXXX
506	80040000	Commerzbank Halle	COBADEFFXXX
507	81040000	Commerzbank Magdeburg	COBADEFFXXX
508	82040000	Commerzbank Erfurt	COBADEFFXXX
509	82040085	Commerzbank Gf WK, Erfurt	COBADEFFXXX
510	83040000	Commerzbank Gera	COBADEFFXXX
511	84040000	Commerzbank Meiningen	COBADEFFXXX
512	85040000	Commerzbank Dresden	COBADEFFXXX
513	85040060	Commerzbank CC Dresden	COBADEFFXXX
514	85040061	Commerzbank CC Dresden	COBADEFFXXX
515	86040000	Commerzbank Leipzig	COBADEFFXXX
516	86040060	Commerzbank CC Leipzig	COBADEFFXXX
517	86040061	Commerzbank CC Leipzig	COBADEFFXXX
518	87040000	Commerzbank Chemnitz	COBADEFFXXX
519	20041133	comdirect bank Quickborn	COBADEHD001
520	20041144	comdirect bank Quickborn	COBADEHD044
521	20041155	comdirect bank	COBADEHD055
522	20041111	comdirect bank Quickborn	COBADEHDXXX
523	20040000	Commerzbank Hamburg	COBADEHHXXX
524	70013000	ebase Aschheim	COBADEMXXXX
525	37050299	Kreissparkasse Köln	COKSDE33XXX
526	38050000	Sparkasse Bonn -alt-	COLSDE33BON
527	37050198	Sparkasse KölnBonn	COLSDE33XXX
528	50120600	Bank of Communications	COMMDEFFXXX
529	55030533	GE Capital Direkt	CPDIDE51XXX
530	55030500	GE Capital Bank Mainz	CPLADE55XXX
531	60030666	CreditPlus Bank	CPLUDES1666
532	60030600	CreditPlus Bank	CPLUDES1XXX
533	50120500	CSD Frankfurt Main	CRESDE55XXX
534	76030080	Cortal Consors	CSDBDE71XXX
535	30030500	Bank11direkt Neuss	CUABDED1XXX
536	20090602	apoBank Hamburg	DAAEDED1002
537	10090603	apoBank Berlin	DAAEDED1003
538	44060604	apoBank Dortmund	DAAEDED1004
539	29090605	apoBank Bremen	DAAEDED1005
540	70090606	apoBank München	DAAEDED1006
541	50090607	apoBank Frankfurt Main	DAAEDED1007
542	25090608	apoBank Hannover	DAAEDED1008
543	60090609	apoBank Stuttgart	DAAEDED1009
544	36060610	apoBank Essen	DAAEDED1010
545	52090611	apoBank Kassel	DAAEDED1011
546	57060612	apoBank Koblenz	DAAEDED1012
547	76090613	apoBank Nürnberg	DAAEDED1013
548	40060614	apoBank Münster	DAAEDED1014
549	37060615	apoBank Köln	DAAEDED1015
550	33060616	apoBank Wuppertal	DAAEDED1016
551	67090617	apoBank Mannheim	DAAEDED1017
552	27090618	apoBank Braunschweig	DAAEDED1018
553	21090619	apoBank Kiel	DAAEDED1019
554	23092620	apoBank Lübeck	DAAEDED1020
555	66090621	apoBank Karlsruhe	DAAEDED1021
556	68090622	apoBank Freiburg	DAAEDED1022
557	54690623	apoBank Neustadt, Weinstr	DAAEDED1023
558	79090624	apoBank Würzburg	DAAEDED1024
559	26560625	apoBank Osnabrück	DAAEDED1025
560	59090626	apoBank Saarbrücken	DAAEDED1026
561	70090606	apoBank Augsburg	DAAEDED1027
562	77390628	apoBank Bayreuth	DAAEDED1028
563	75090629	apoBank Regensburg	DAAEDED1029
564	39060630	apoBank Aachen	DAAEDED1030
565	55060831	apoBank Mainz	DAAEDED1031
566	35060632	apoBank Duisburg	DAAEDED1032
567	28090633	apoBank Oldenburg	DAAEDED1033
568	50890634	apoBank Darmstadt	DAAEDED1034
569	53390635	apoBank Gießen	DAAEDED1035
570	51090636	apoBank Wiesbaden	DAAEDED1036
571	25090608	apoBank Göttingen	DAAEDED1037
572	12090640	apoBank -ZV-Ost- Berlin	DAAEDED1040
573	10090603	apoBank Leipzig	DAAEDED1041
574	10090603	apoBank Schwerin	DAAEDED1042
575	10090603	apoBank Dresden	DAAEDED1043
576	57060612	apoBank Trier	DAAEDED1044
577	10090603	apoBank Erfurt	DAAEDED1045
578	10090603	apoBank Magdeburg	DAAEDED1046
579	10090603	apoBank Potsdam	DAAEDED1048
580	10090603	apoBank Chemnitz	DAAEDED1049
581	30060601	apoBank Düsseldorf	DAAEDEDDXXX
582	20320500	Danske Bank Hamburg	DABADEHHXXX
583	70120400	DAB bank München	DABBDEMMXXX
584	57020600	Debeka Bauspk Koblenz	DEBKDE51XXX
585	50010700	Degussa Bank Frankfurt Main	DEGUDEFFXXX
586	25010600	Deuhypo Hannover	DEHYDE2HXXX
587	70011100	Deutsche Kontor Grünwald	DEKTDE71001
588	70011110	Kontor Sofort Bank Grünwald	DEKTDE71002
589	50120383	Bethmann Bank Frankfurt	DELBDE33XXX
590	50130100	BethmannMaffei Bank Ffm-alt	DELBDE33XXX
591	50220200	Bethmann Bank (LGT Ffm)	DELBDE33XXX
592	70030800	Bethmann Bank	DELBDE33XXX
593	29010400	Deutsche Schiffsbank Bremen	DESBDE22XXX
594	24070075	Deutsche Bank Lüneburg	DEUTDE2H240
595	24070075	Deutsche Bank Uelzen	DEUTDE2H241
596	25070070	Deutsche Bank Barsinghausen	DEUTDE2H250
597	25070086	Deutsche Bank Holzminden	DEUTDE2H251
598	25070070	Deutsche Bank Burgdorf Hann	DEUTDE2H252
599	25971071	Deutsche Bank Alfeld Leine	DEUTDE2H253
600	25470073	Deutsche Bank Hameln	DEUTDE2H254
601	25070077	Deutsche Bank Nienburg	DEUTDE2H256
602	25770069	Deutsche Bank Celle	DEUTDE2H257
603	25070084	Deutsche Bank Soltau	DEUTDE2H258
604	25970074	Deutsche Bank Hildesheim	DEUTDE2H259
605	26070072	Deutsche Bank Göttingen	DEUTDE2H260
606	25971071	Deutsche Bank Gronau Leine	DEUTDE2H261
607	26271471	Deutsche Bank Einbeck	DEUTDE2H262
608	26070072	Deutsche Bank Northeim Han	DEUTDE2H263
609	25471073	Deutsche Bank Rinteln	DEUTDE2H264
610	25070066	Deutsche Bank Stadthagen	DEUTDE2H265
611	26870032	Deutsche Bank Goslar	DEUTDE2H268
612	26971038	Deutsche Bank Wolfsburg	DEUTDE2H269
613	27070030	Deutsche Bank Braunschweig	DEUTDE2H270
614	27070031	Deutsche Bank Gifhorn	DEUTDE2H271
615	27070042	Deutsche Bank Bad Harzburg	DEUTDE2H272
616	27070043	Deutsche Bank Helmstedt	DEUTDE2H273
617	27070034	Deutsche Bank Osterode Harz	DEUTDE2H274
618	27070079	Deutsche Bank Peine	DEUTDE2H275
619	27072736	Deutsche Bank Salzgitter	DEUTDE2H276
620	27072537	Deutsche Bank Wolfenbüttel	DEUTDE2H277
621	27070034	Deutsche Bank Bad Lauterber	DEUTDE2H278
622	27070041	Deutsche Bank Bad Sachsa	DEUTDE2H279
623	26870032	Deutsche Bank Clausthal-Zel	DEUTDE2H280
624	27070034	Deutsche Bank Herzberg Harz	DEUTDE2H281
625	25070070	Deutsche Bank Laatzen	DEUTDE2H282
626	25070070	Deutsche Bank Langenhagen	DEUTDE2H283
627	25070084	Deutsche Bank Munster	DEUTDE2H284
628	26870032	Deutsche Bank Seesen	DEUTDE2H285
629	25070070	Deutsche Bank Hannover	DEUTDE2HXXX
630	26570090	Deutsche Bank Osnabrück	DEUTDE3B265
631	26570090	Deutsche Bank Melle	DEUTDE3B266
632	26770095	Deutsche Bank Nordhorn	DEUTDE3B267
633	26570090	Deutsche Bank Bad Iburg	DEUTDE3B268
634	26570090	Deutsche Bank Bramsche Hase	DEUTDE3B269
635	26570090	Deutsche Bank Georgsmarienh	DEUTDE3B270
636	26570090	Deutsche Bank Lengerich Wes	DEUTDE3B271
637	26570090	Deutsche Bank Quakenbrück	DEUTDE3B272
638	26770095	Deutsche Bank Lingen Ems	DEUTDE3B273
639	26770095	Deutsche Bank Meppen	DEUTDE3B274
640	26770095	Deutsche Bank Schüttorf	DEUTDE3B275
641	40070080	Deutsche Bank Münster Westf	DEUTDE3B400
642	40370079	Deutsche Bank Gronau Westf	DEUTDE3B401
643	40370079	Deutsche Bank Rheine, Westf	DEUTDE3B403
644	40070080	Deutsche Bank Warendorf	DEUTDE3B404
645	40370079	Deutsche Bank Ahaus	DEUTDE3B405
646	40370079	Deutsche Bank Emsdetten	DEUTDE3B406
647	40370079	Deutsche Bank Ibbenbüren	DEUTDE3B407
648	40370079	Deutsche Bank Stadtlohn	DEUTDE3B408
649	40370079	Deutsche Bank Vreden	DEUTDE3B409
650	48070045	Deutsche Bank Beckum Westf	DEUTDE3B413
651	41670029	Deutsche Bank Soest Westf	DEUTDE3B414
652	41670027	Deutsche Bank Lippstadt	DEUTDE3B416
653	41670028	Deutsche Bank Brilon	DEUTDE3B417
654	41670030	Deutsche Bank Werl	DEUTDE3B418
655	42870077	Deutsche Bank Bocholt	DEUTDE3B428
656	42870077	Deutsche Bank Borken Westf	DEUTDE3B429
657	40070080	Deutsche Bank Coesfeld	DEUTDE3B440
658	40070080	Deutsche Bank Dülmen	DEUTDE3B441
659	40070080	Deutsche Bank Greven Westf	DEUTDE3B442
660	40070080	Deutsche Bank Steinfurt	DEUTDE3B443
661	47670023	Deutsche Bank Blomberg Lipp	DEUTDE3B450
662	47270029	Deutsche Bank Höxter	DEUTDE3B451
663	47670023	Deutsche Bank Horn-Bad Mein	DEUTDE3B452
664	47670023	Deutsche Bank Lage Lippe	DEUTDE3B453
665	47270029	Deutsche Bank Paderborn	DEUTDE3B472
666	47270029	Deutsche Bank Bad Driburg	DEUTDE3B473
667	47270029	Deutsche Bank Bad Lippsprin	DEUTDE3B474
668	47270029	Deutsche Bank Geseke Westf	DEUTDE3B475
669	47670023	Deutsche Bank Detmold	DEUTDE3B476
670	47670023	Deutsche Bank Bad Salzuflen	DEUTDE3B477
671	47670023	Deutsche Bank Lemgo	DEUTDE3B478
672	48070040	Deutsche Bank Gütersloh	DEUTDE3B480
673	48070050	Deutsche Bank Herford	DEUTDE3B481
674	48070020	Deutsche Bank Halle Westf	DEUTDE3B483
675	48070042	Deutsche Bank Harsewinkel	DEUTDE3B484
676	48070020	Deutsche Bank Oerlinghausen	DEUTDE3B486
677	48070044	Deutsche Bank Rheda-Wiedenb	DEUTDE3B487
678	48070043	Deutsche Bank Verl	DEUTDE3B489
679	49070028	Deutsche Bank Minden, Westf	DEUTDE3B490
680	49070028	Deutsche Bank Bad Oeynhause	DEUTDE3B491
681	48070052	Deutsche Bank Bünde Westf	DEUTDE3B492
682	49070028	Deutsche Bank Espelkamp	DEUTDE3B493
683	49070028	Deutsche Bank Löhne Westf	DEUTDE3B494
684	49070028	Deutsche Bank Lübbecke	DEUTDE3B495
685	48070020	Deutsche Bank Bielefeld	DEUTDE3BXXX
686	55070040	Deutsche Bank Ginsheim-Gust	DEUTDE5M550
687	55070040	Deutsche Bank Ingelheim Rhe	DEUTDE5M551
688	55070040	Deutsche Bank Bingen Rhein	DEUTDE5M552
689	59070000	Deutsche Bank Saarbruecken	DEUTDE5M555
690	56070040	Deutsche Bank Bad Kreuznach	DEUTDE5M560
691	56270044	Deutsche Bank Idar-Oberst	DEUTDE5M562
692	57070045	Deutsche Bank Koblenz	DEUTDE5M570
693	57070045	Deutsche Bank Boppard	DEUTDE5M571
694	57070045	Deutsche Bank Bendorf Rhein	DEUTDE5M572
695	57070045	Deutsche Bank Lahnstein	DEUTDE5M573
696	57470047	Deutsche Bank Neuwied	DEUTDE5M574
697	57470047	Deutsche Bank Andernach	DEUTDE5M575
698	57470047	Deutsche Bank Mayen	DEUTDE5M576
699	57070045	Deutsche Bank Höhr-Grenzhau	DEUTDE5M577
700	57070045	Deutsche Bank Montabaur	DEUTDE5M578
701	57470047	Deutsche Bank Weißenthurm	DEUTDE5M579
702	58570048	Deutsche Bank Trier	DEUTDE5M585
703	58570048	Deutsche Bank Wittlich	DEUTDE5M586
704	58771242	Deutsche Bank Bernkast-Kues	DEUTDE5M587
705	58771242	Deutsche Bank Zell Mosel	DEUTDE5M588
706	58771242	Deutsche Bank Traben-Trarb	DEUTDE5M589
707	58570048	Deutsche Bank Konz	DEUTDE5M590
708	55070040	Deutsche Bank Mainz	DEUTDE5MXXX
709	50073081	DB Europe	DEUTDE5XXXX
710	69470039	Deutsche Bank Rottweil	DEUTDE6F642
711	69470039	Deutsche Bank Spaichingen	DEUTDE6F644
712	66470035	Deutsche Bank Offenburg	DEUTDE6F664
713	66470035	Deutsche Bank Kehl	DEUTDE6F665
714	66470035	Deutsche Bank Haslach Kinzi	DEUTDE6F666
715	66470035	Deutsche Bank Oberkirch Bad	DEUTDE6F667
716	68370034	Deutsche Bank Wehr Baden	DEUTDE6F678
717	68370034	Deutsche Bank Weil Rhein	DEUTDE6F679
718	68070030	Deutsche Bank Emmendingen	DEUTDE6F681
719	68270033	Deutsche Bank Lahr Schwarzw	DEUTDE6F682
720	68370034	Deutsche Bank Lörrach	DEUTDE6F683
721	68370034	Deutsche Bank Bad Säckingen	DEUTDE6F684
722	68070030	Deutsche Bank Müllheim Bad	DEUTDE6F685
723	68370034	Deutsche Bank Rheinfelden B	DEUTDE6F686
724	68070030	Deutsche Bank Waldkirch Bre	DEUTDE6F687
725	68370034	Deutsche Bank Grenzach-Wyhl	DEUTDE6F688
726	68070030	Deutsche Bank Titisee-Neust	DEUTDE6F689
727	69070032	Deutsche Bank Konstanz	DEUTDE6F690
728	69070032	Deutsche Bank Überlingen	DEUTDE6F691
729	69270038	Deutsche Bank Singen Hohent	DEUTDE6F692
730	68370034	Deutsche Bank Schopfheim	DEUTDE6F693
731	69470039	Deutsche Bank Villingen Sch	DEUTDE6F694
732	69270038	Deutsche Bank Radolfzell	DEUTDE6F696
733	69470039	Deutsche Bank Triberg	DEUTDE6F697
734	69470039	Deutsche Bank Donaueschinge	DEUTDE6F698
735	69470039	Deutsche Bank Sankt Georgen	DEUTDE6F699
736	68070030	Deutsche Bank Freiburg	DEUTDE6FXXX
737	87070000	Deutsche Bank Dresden	DEUTDE8C870
738	87070000	Deutsche Bank Annabg-Buchhz	DEUTDE8C871
739	87070000	Deutsche Bank Aue Sachs	DEUTDE8C872
740	87070000	Deutsche Bank Auerbach	DEUTDE8C873
741	87070000	Deutsche Bank Bautzen	DEUTDE8C874
742	87070000	Deutsche Bank Burgstädt	DEUTDE8C875
743	87070000	Deutsche Bank Coswig	DEUTDE8C876
744	87070000	Deutsche Bank Crimmitschau	DEUTDE8C877
745	87070000	Deutsche Bank Frankenberg	DEUTDE8C878
746	87070000	Deutsche Bank Freibg Sachs	DEUTDE8C879
747	87070000	Deutsche Bank Freital	DEUTDE8C880
748	87070000	Deutsche Bank Glauchau	DEUTDE8C881
749	87070000	Deutsche Bank Görlitz	DEUTDE8C882
750	87070000	Deutsche Bank Großenhain	DEUTDE8C883
751	87070000	Deutsche Bank Heidenau	DEUTDE8C884
752	87070000	Deutsche Bank Hohenst-Ernst	DEUTDE8C885
753	87070000	Deutsche Bank Hoyerswerda	DEUTDE8C886
754	87070000	Deutsche Bank Kamenz	DEUTDE8C887
755	87070000	Deutsche Bank Klingenthal	DEUTDE8C888
756	87070000	Deutsche Bank Lichtenstein	DEUTDE8C889
757	87070000	Deutsche Bank Limbach-Obrfr	DEUTDE8C890
758	87070000	Deutsche Bank Löbau	DEUTDE8C891
759	87070000	Deutsche Bank Marienberg	DEUTDE8C892
760	87070000	Deutsche Bank Meerane	DEUTDE8C893
761	87070000	Deutsche Bank Meißen	DEUTDE8C894
762	87070000	Deutsche Bank Mittweida	DEUTDE8C895
763	87070000	Deutsche Bank Niesky	DEUTDE8C896
764	87070000	Deutsche Bank Oberwiesenth	DEUTDE8C897
765	87070000	Deutsche Bank Pirna	DEUTDE8C898
766	87070000	Deutsche Bank Plauen	DEUTDE8C899
767	87070000	Deutsche Bank Radeberg	DEUTDE8C900
768	87070000	Deutsche Bank Radebeul	DEUTDE8C901
769	87070000	Deutsche Bank Reichenbach V	DEUTDE8C902
770	87070000	Deutsche Bank Riesa	DEUTDE8C903
771	87070000	Deutsche Bank Schneeberg	DEUTDE8C905
772	87070000	Deutsche Bank Schwarzenberg	DEUTDE8C906
773	87070000	Deutsche Bank Stollbg	DEUTDE8C907
774	87070000	Deutsche Bank Werdau	DEUTDE8C908
775	87070000	Deutsche Bank Zittau	DEUTDE8C909
776	87070000	Deutsche Bank Zwickau	DEUTDE8C910
777	87070000	Deutsche Bank Chemnitz	DEUTDE8CXXX
778	82070000	Deutsche Bank Weimar	DEUTDE8E820
779	82070000	Deutsche Bank Worbis	DEUTDE8E821
780	82070000	Deutsche Bank Sondershausen	DEUTDE8E822
781	82070000	Deutsche Bank Sömmerda	DEUTDE8E823
782	82070000	Deutsche Bank Nordhausen	DEUTDE8E824
783	82070000	Deutsche Bank Mühlhausen	DEUTDE8E825
784	82070000	Deutsche Bank Leinefelde	DEUTDE8E826
785	82070000	Deutsche Bank Gotha	DEUTDE8E827
786	82070000	Deutsche Bank Apolda	DEUTDE8E828
787	82070000	Deutsche Bank Bad Langenslz	DEUTDE8E829
788	82070000	Deutsche Bank Gera	DEUTDE8E830
789	82070000	Deutsche Bank Jena	DEUTDE8E831
790	82070000	Deutsche Bank Eisenberg	DEUTDE8E832
791	82070000	Deutsche Bank Greiz	DEUTDE8E833
792	82070000	Deutsche Bank Pößneck	DEUTDE8E835
793	82070000	Deutsche Bank Zeulenroda	DEUTDE8E836
794	82070000	Deutsche Bank Suhl	DEUTDE8E840
795	82070000	Deutsche Bank Arnstadt	DEUTDE8E841
796	82070000	Deutsche Bank Bad Salzungen	DEUTDE8E842
797	82070000	Deutsche Bank Eisenach	DEUTDE8E843
798	82070000	Deutsche Bank Ilmenau	DEUTDE8E844
799	82070000	Deutsche Bank Meiningen	DEUTDE8E845
800	82070000	Deutsche Bank Ohrdruf	DEUTDE8E846
801	82070000	Deutsche Bank Rudolstadt	DEUTDE8E847
802	82070000	Deutsche Bank Saalfeld	DEUTDE8E848
803	82070000	Deutsche Bank Schmalkalden	DEUTDE8E849
804	82070000	Deutsche Bank Sonneberg Thü	DEUTDE8E850
805	82070000	Deutsche Bank Waltershausen	DEUTDE8E851
806	82070000	Deutsche Bank Erfurt	DEUTDE8EXXX
807	86070000	Deutsche Bank Halle	DEUTDE8L860
808	86070000	Deutsche Bank Altenburg	DEUTDE8L861
809	86070000	Deutsche Bank Aschersleben	DEUTDE8L862
810	86070000	Deutsche Bank Bernburg	DEUTDE8L863
811	86070000	Deutsche Bank Bitterfeld	DEUTDE8L864
812	86070000	Deutsche Bank Borna	DEUTDE8L865
813	86070000	Deutsche Bank Delitzsch	DEUTDE8L866
814	86070000	Deutsche Bank Dessau	DEUTDE8L867
815	86070000	Deutsche Bank Döbeln	DEUTDE8L868
816	86070000	Deutsche Bank Eilenburg	DEUTDE8L869
817	86070000	Deutsche Bank Eisleben	DEUTDE8L870
818	86070000	Deutsche Bank Grimma	DEUTDE8L871
819	86070000	Deutsche Bank Hettstedt	DEUTDE8L872
820	86070000	Deutsche Bank Köthen	DEUTDE8L873
821	86070000	Deutsche Bank Markkleeberg	DEUTDE8L874
822	86070000	Deutsche Bank Merseburg	DEUTDE8L875
823	86070000	Deutsche Bank Naumburg	DEUTDE8L877
824	86070000	Deutsche Bank Oschatz	DEUTDE8L878
825	86070000	Deutsche Bank Quedlinburg	DEUTDE8L879
826	86070000	Deutsche Bank Sangerhausen	DEUTDE8L880
827	86070000	Deutsche Bank Schkeuditz	DEUTDE8L881
828	86070000	Deutsche Bank Taucha	DEUTDE8L882
829	86070000	Deutsche Bank Torgau	DEUTDE8L883
830	86070000	Deutsche Bank Weißenfels	DEUTDE8L884
831	86070000	Deutsche Bank Wittenbg Luth	DEUTDE8L885
832	86070000	Deutsche Bank Wurzen	DEUTDE8L887
833	86070000	Deutsche Bank Zeitz	DEUTDE8L888
834	86070000	Deutsche Bank Leipzig	DEUTDE8LXXX
835	81070000	Deutsche Bank Gardelegen	DEUTDE8M811
836	81070000	Deutsche Bank Genthin	DEUTDE8M812
837	81070000	Deutsche Bank Burg Magdebg	DEUTDE8M814
838	81070000	Deutsche Bank Blankenburg	DEUTDE8M815
839	81070000	Deutsche Bank Halberstadt	DEUTDE8M816
840	81070000	Deutsche Bank Haldensleben	DEUTDE8M817
841	81070000	Deutsche Bank Oschersleben	DEUTDE8M818
842	81070000	Deutsche Bank Salzwedel	DEUTDE8M819
843	81070000	Deutsche Bank Schönebeck	DEUTDE8M820
844	81070000	Deutsche Bank Staßfurt	DEUTDE8M821
845	81070000	Deutsche Bank Stendal	DEUTDE8M822
846	81070000	Deutsche Bank Wernigerode	DEUTDE8M823
847	81070000	Deutsche Bank Zerbst	DEUTDE8M825
848	81070000	Deutsche Bank Magdeburg	DEUTDE8MXXX
849	10070100	Deutsche Bank Fil Berlin II	DEUTDEBB101
850	12070000	Deutsche Bank Oranienburg	DEUTDEBB120
851	12070000	Deutsche Bank Königs Wuster	DEUTDEBB121
852	12070000	Deutsche Bank Bernau	DEUTDEBB122
853	12070000	Deutsche Bank Neuruppin	DEUTDEBB123
854	12070000	Deutsche Bank Zossen	DEUTDEBB124
855	12070000	Deutsche Bank Hennigsdorf	DEUTDEBB125
856	12070000	Deutsche Bank Schwarzheide	DEUTDEBB126
857	12070000	Deutsche Bank Teltow	DEUTDEBB127
858	13070000	Deutsche Bank Bützow	DEUTDEBB130
859	13070000	Deutsche Bank Demmin	DEUTDEBB131
860	13070000	Deutsche Bank Gadebusch	DEUTDEBB132
861	13070000	Deutsche Bank Schwerin	DEUTDEBB140
862	13070000	Deutsche Bank Güstrow	DEUTDEBB141
863	13070000	Deutsche Bank Hagenow	DEUTDEBB142
864	13070000	Deutsche Bank Ludwigslust	DEUTDEBB143
865	13070000	Deutsche Bank Lübz	DEUTDEBB144
866	13070000	Deutsche Bank Parchim	DEUTDEBB145
867	13070000	Deutsche Bank Perleberg	DEUTDEBB146
868	13070000	Deutsche Bank Plau	DEUTDEBB147
869	13070000	Deutsche Bank Wismar	DEUTDEBB148
870	13070000	Deutsche Bank Wittenberge	DEUTDEBB149
871	13070000	Deutsche Bank Neubrandenbg	DEUTDEBB150
872	13070000	Deutsche Bank Anklam	DEUTDEBB151
873	13070000	Deutsche Bank Malchin	DEUTDEBB152
874	13070000	Deutsche Bank Neustrelitz	DEUTDEBB153
875	13070000	Deutsche Bank Prenzlau	DEUTDEBB154
876	13070000	Deutsche Bank Templin	DEUTDEBB155
877	13070000	Deutsche Bank Teterow	DEUTDEBB156
878	13070000	Deutsche Bank Ueckermünde	DEUTDEBB157
879	13070000	Deutsche Bank Waren	DEUTDEBB158
880	13070000	Deutsche Bank Wolgast	DEUTDEBB159
881	12070000	Deutsche Bank Ld Brandenbg	DEUTDEBB160
882	12070000	Deutsche Bank Brandenburg	DEUTDEBB161
883	12070000	Deutsche Bank Falkensee	DEUTDEBB162
884	12070000	Deutsche Bank Kyritz	DEUTDEBB163
885	12070000	Deutsche Bank Ludwigsfelde	DEUTDEBB164
886	12070000	Deutsche Bank Nauen	DEUTDEBB165
887	12070000	Deutsche Bank Pritzwalk	DEUTDEBB166
888	12070000	Deutsche Bank Rathenow	DEUTDEBB167
889	12070000	Deutsche Bank Werder Havel	DEUTDEBB168
890	12070000	Deutsche Bank Wittstock	DEUTDEBB169
891	12070000	Deutsche Bank Frankfurt Od	DEUTDEBB170
892	12070000	Deutsche Bank Angermünde	DEUTDEBB171
893	12070000	Deutsche Bank Bad Freienwde	DEUTDEBB172
894	12070000	Deutsche Bank Eberswalde	DEUTDEBB173
895	12070000	Deutsche Bank Eisenhüttenst	DEUTDEBB174
896	12070000	Deutsche Bank Fürstenwalde	DEUTDEBB175
897	12070000	Deutsche Bank Schwedt	DEUTDEBB176
898	12070000	Deutsche Bank Seelow	DEUTDEBB177
899	12070000	Deutsche Bank Strausberg	DEUTDEBB178
900	13070000	Deutsche Bank Torgelow	DEUTDEBB179
901	12070000	Deutsche Bank Cottbus	DEUTDEBB180
902	12070000	Deutsche Bank Forst	DEUTDEBB181
903	12070000	Deutsche Bank Finsterwalde	DEUTDEBB182
904	12070000	Deutsche Bank Guben	DEUTDEBB183
905	12070000	Deutsche Bank Lübben	DEUTDEBB184
906	12070000	Deutsche Bank Senftenberg	DEUTDEBB185
907	12070000	Deutsche Bank Spremberg	DEUTDEBB186
908	12070000	Deutsche Bank Jüterbog	DEUTDEBB187
909	12070000	Deutsche Bank Luckenwalde	DEUTDEBB188
910	12070000	Deutsche Bank Weißwasser	DEUTDEBB189
911	10070000	Deutsche Bank Fil Berlin	DEUTDEBBXXX
912	13070000	Deutsche Bank Bad Doberan	DEUTDEBR131
913	13070000	Deutsche Bank Barth	DEUTDEBR132
914	13070000	Deutsche Bank Bergen Rügen	DEUTDEBR133
915	13070000	Deutsche Bank Greifswald	DEUTDEBR134
916	13070000	Deutsche Bank Grimmen	DEUTDEBR135
917	13070000	Deutsche Bank Ribnitz-Damgt	DEUTDEBR136
918	13070000	Deutsche Bank Sassnitz	DEUTDEBR137
919	13070000	Deutsche Bank Stralsund	DEUTDEBR138
920	13070000	Deutsche Bank Rostock	DEUTDEBRXXX
921	10070124	Deutsche Bank PGK Berlin II	DEUTDEDB101
922	10070848	Berliner Bk Ndl Deutsche Bk	DEUTDEDB110
923	12070024	Deutsche Bank PGK Oranienbg	DEUTDEDB120
924	12070024	Deutsche Bank PGK Königs-Wu	DEUTDEDB121
925	12070024	Deutsche Bank PGK Bernau	DEUTDEDB122
926	12070024	Deutsche Bank PGK Neuruppin	DEUTDEDB123
927	12070024	Deutsche Bank PGK Zossen	DEUTDEDB124
928	12070024	Deutsche Bank PGK Hennigsdo	DEUTDEDB125
929	12070024	Deutsche Bank PGK Schwarzhe	DEUTDEDB126
930	12070024	Deutsche Bank PGK Teltow	DEUTDEDB127
931	13070024	Deutsche Bank PGK Demmin	DEUTDEDB128
932	13070024	Deutsche Bank PGK Bützow	DEUTDEDB130
933	13070024	Deutsche Bank PGK Bad Dober	DEUTDEDB131
934	13070024	Deutsche Bank PGK Gadebusch	DEUTDEDB132
935	13070024	Deutsche Bank PGK Bergen Rü	DEUTDEDB133
936	13070024	Deutsche Bank PGK Greifswal	DEUTDEDB134
937	13070024	Deutsche Bank PGK Grimmen	DEUTDEDB135
938	13070024	Deutsche Bank PGK Ribnitz-D	DEUTDEDB136
939	13070024	Deutsche Bank PGK Sassnitz	DEUTDEDB137
940	13070024	Deutsche Bank PGK Stralsund	DEUTDEDB138
941	13070024	Deutsche Bank PGK Schwerin	DEUTDEDB140
942	13070024	Deutsche Bank PGK Güstrow	DEUTDEDB141
943	13070024	Deutsche Bank PGK Hagenow	DEUTDEDB142
944	13070024	Deutsche Bank PGK Ludwigslu	DEUTDEDB143
945	13070024	Deutsche Bank PGK Lübz	DEUTDEDB144
946	13070024	Deutsche Bank PGK Parchim	DEUTDEDB145
947	13070024	Deutsche Bank PGK Perleberg	DEUTDEDB146
948	13070024	Deutsche Bank PGK Plau	DEUTDEDB147
949	13070024	Deutsche Bank PGK Wismar	DEUTDEDB148
950	13070024	Deutsche Bank PGK Wittenber	DEUTDEDB149
951	13070024	Deutsche Bank PGK Neubrande	DEUTDEDB150
952	13070024	Deutsche Bank PGK Anklam	DEUTDEDB151
953	13070024	Deutsche Bank PGK Malchin	DEUTDEDB152
954	13070024	Deutsche Bank PGK Neustreli	DEUTDEDB153
955	13070024	Deutsche Bank PGK Prenzlau	DEUTDEDB154
956	13070024	Deutsche Bank PGK Templin	DEUTDEDB155
957	13070024	Deutsche Bank PGK Teterow	DEUTDEDB156
958	13070024	Deutsche Bank PGK Ueckermün	DEUTDEDB157
959	13070024	Deutsche Bank PGK Waren	DEUTDEDB158
960	13070024	Deutsche Bank PGK Wolgast	DEUTDEDB159
961	12070024	Deutsche Bank PGK Brandenbg	DEUTDEDB160
962	12070024	Deutsche Bank PGK Brandenbu	DEUTDEDB161
963	12070024	Deutsche Bank PGK Falkensee	DEUTDEDB162
964	12070024	Deutsche Bank PGK Kyritz	DEUTDEDB163
965	12070024	Deutsche Bank PGK Ludwigsfe	DEUTDEDB164
966	12070024	Deutsche Bank PGK Nauen	DEUTDEDB165
967	12070024	Deutsche Bank PGK Pritzwalk	DEUTDEDB166
968	12070024	Deutsche Bank PGK Rathenow	DEUTDEDB167
969	12070024	Deutsche Bank PGK Werder	DEUTDEDB168
970	12070024	Deutsche Bank PGK Wittstock	DEUTDEDB169
971	12070024	Deutsche Bank PGK Frankfurt	DEUTDEDB170
972	12070024	Deutsche Bank PGK Angermün	DEUTDEDB171
973	12070024	Deutsche Bank PGK Bad Freie	DEUTDEDB172
974	12070024	Deutsche Bank PGK Eberswald	DEUTDEDB173
975	12070024	Deutsche Bank PGK Eisenhütt	DEUTDEDB174
976	12070024	Deutsche Bank PGK Fürstenw	DEUTDEDB175
977	12070024	Deutsche Bank PGK Schwedt	DEUTDEDB176
978	12070024	Deutsche Bank PGK Seelow	DEUTDEDB177
979	12070024	Deutsche Bank PGK Strausber	DEUTDEDB178
980	13070024	Deutsche Bank PGK Torgelow	DEUTDEDB179
981	12070024	Deutsche Bank PGK Cottbus	DEUTDEDB180
982	12070024	Deutsche Bank PGK Forst	DEUTDEDB181
983	12070024	Deutsche Bank PGK Finsterwa	DEUTDEDB182
984	12070024	Deutsche Bank PGK Guben	DEUTDEDB183
985	12070024	Deutsche Bank PGK Lübben	DEUTDEDB184
986	12070024	Deutsche Bank PGK Senftenbe	DEUTDEDB185
987	12070024	Deutsche Bank PGK Spremberg	DEUTDEDB186
988	12070024	Deutsche Bank PGK Jüterbog	DEUTDEDB187
989	12070024	Deutsche Bank PGK Luckenwal	DEUTDEDB188
990	12070024	Deutsche Bank PGK Weißwass	DEUTDEDB189
991	20070024	Deutsche Bank PGK Itzehoe	DEUTDEDB200
992	20070024	Deutsche Bank PGK Ahrensbur	DEUTDEDB201
993	20070024	Deutsche Bank PGK Norderste	DEUTDEDB202
994	20070024	Deutsche Bank PGK Lauenburg	DEUTDEDB203
995	20070024	Deutsche Bank PGK Wedel	DEUTDEDB204
996	20070024	Deutsche Bank PGK Geesthach	DEUTDEDB205
997	20070024	Deutsche Bank PGK Pinneberg	DEUTDEDB206
998	20070024	Deutsche Bank PGK Buchholz	DEUTDEDB207
999	20070024	Deutsche Bank PGK Stade	DEUTDEDB209
1000	21070024	Deutsche Bank PGK Kiel	DEUTDEDB210
1001	20070024	Deutsche Bank PGK Buxtehude	DEUTDEDB211
1002	21270024	Deutsche Bank PGK Neumünste	DEUTDEDB212
1003	20070024	Deutsche Bank PGK Reinbek	DEUTDEDB213
1004	21070024	Deutsche Bank PGK Rendsburg	DEUTDEDB214
1005	21570024	Deutsche Bank PGK Flensburg	DEUTDEDB215
1006	21570024	Deutsche Bank PGK Westerlan	DEUTDEDB216
1007	21770024	Deutsche Bank PGK Husum	DEUTDEDB217
1008	20070024	Deutsche Bank PGK Brunsbütt	DEUTDEDB219
1009	20070024	Deutsche Bank PGK Elmshorn	DEUTDEDB221
1010	23070700	Deutsche Bank PGK Lübeck	DEUTDEDB237
1011	24070024	Deutsche Bank PGK Lüneburg	DEUTDEDB240
1012	20070024	Deutsche Bank PGK Cuxhaven	DEUTDEDB241
1013	24070024	Deutsche Bank PGK Uelzen	DEUTDEDB242
1014	25070024	Deutsche Bank PGK Stadthage	DEUTDEDB243
1015	25070024	Deutsche Bank PGK Barsingha	DEUTDEDB250
1016	25070024	Deutsche Bank PGK Holzminde	DEUTDEDB251
1017	25070024	Deutsche Bank PGK Burgdorf	DEUTDEDB252
1018	25971024	Deutsche Bank PGK Alfeld	DEUTDEDB253
1019	25470024	Deutsche Bank PGK Hameln	DEUTDEDB254
1020	25470024	Deutsche Bank PGK Bad Pyrmo	DEUTDEDB255
1021	25070024	Deutsche Bank PGK Nienburg	DEUTDEDB256
1022	25770024	Deutsche Bank PGK Celle	DEUTDEDB257
1023	25070024	Deutsche Bank PGK Soltau	DEUTDEDB258
1024	25970024	Deutsche Bank PGK Hildeshei	DEUTDEDB259
1025	26070024	Deutsche Bank PGK Göttingen	DEUTDEDB260
1026	25971024	Deutsche Bank PGK Gronau	DEUTDEDB261
1027	26271424	Deutsche Bank PGK Einbeck	DEUTDEDB262
1028	26070024	Deutsche Bank PGK Northeim	DEUTDEDB263
1029	25471024	Deutsche Bank PGK Rinteln	DEUTDEDB264
1030	26570024	Deutsche Bank PGK Osnabrück	DEUTDEDB265
1031	26570024	Deutsche Bank PGK Melle	DEUTDEDB266
1032	26770024	Deutsche Bank PGK Nordhorn	DEUTDEDB267
1033	26870024	Deutsche Bank PGK Goslar	DEUTDEDB268
1034	26971024	Deutsche Bank PGK Wolfsburg	DEUTDEDB269
1035	27070024	Deutsche Bank PGK Braunschw	DEUTDEDB270
1036	27070024	Deutsche Bank PGK Gifhorn	DEUTDEDB271
1037	27070024	Deutsche Bank PGK Bad Harzb	DEUTDEDB272
1038	27070024	Deutsche Bank PGK Helmstedt	DEUTDEDB273
1039	27070024	Deutsche Bank PGK Osterode	DEUTDEDB274
1040	27070024	Deutsche Bank PGK Peine	DEUTDEDB275
1041	27072724	Deutsche Bank PGK Salzgitte	DEUTDEDB276
1042	27072524	Deutsche Bank PGK Wolfenbüt	DEUTDEDB277
1043	27070024	Deutsche Bank PGK Bad Laute	DEUTDEDB278
1044	27070024	Deutsche Bank PGK Bad Sachs	DEUTDEDB279
1045	28070024	Deutsche Bank PGK Oldenburg	DEUTDEDB280
1046	28070024	Deutsche Bank PGK Bad Zwisc	DEUTDEDB281
1047	28270024	Deutsche Bank PGK Wilhelmsh	DEUTDEDB282
1048	28270024	Deutsche Bank PGK Jever	DEUTDEDB283
1049	28470024	Deutsche Bank PGK Emden	DEUTDEDB284
1050	28570024	Deutsche Bank PGK Leer	DEUTDEDB285
1051	28470024	Deutsche Bank PGK Norden	DEUTDEDB286
1052	28570024	Deutsche Bank PGK Papenburg	DEUTDEDB287
1053	28570024	Deutsche Bank PGK Weener	DEUTDEDB288
1054	28470024	Deutsche Bank PGK Aurich	DEUTDEDB289
1055	29070024	Deutsche Bank PGK Vechta	DEUTDEDB290
1056	29172624	Deutsche Bank PGK Verden	DEUTDEDB291
1057	29070024	Deutsche Bank PGK Bremerhav	DEUTDEDB292
1058	29070024	Deutsche Bank PGK Cloppenbg	DEUTDEDB293
1059	29070024	Deutsche Bank PGK Delmenh	DEUTDEDB294
1060	29070024	Deutsche Bank PGK Achim	DEUTDEDB295
1061	29070024	Deutsche Bank PGK Lohne	DEUTDEDB296
1062	29070024	Deutsche Bank PGK Osterholz	DEUTDEDB297
1063	28470024	Deutsche Bank PGK Norderney	DEUTDEDB298
1064	30070024	Deutsche Bank PGK Neuss	DEUTDEDB300
1065	30070024	Deutsche Bank PGK Langenfel	DEUTDEDB301
1066	30070024	Deutsche Bank PGK Monheim	DEUTDEDB302
1067	30070024	Deutsche Bank PGK Meerbusch	DEUTDEDB303
1068	30070024	Deutsche Bank PGK Ratingen	DEUTDEDB304
1069	30070024	Deutsche Bank PGK Hilden	DEUTDEDB305
1070	30070024	Deutsche Bank PGK Erkrath	DEUTDEDB306
1071	30070024	Deutsche Bank PGK Kaarst	DEUTDEDB307
1072	31070024	Deutsche Bank PGK Mönchengl	DEUTDEDB310
1073	31470024	Deutsche Bank PGK Viersen	DEUTDEDB314
1074	31470024	Deutsche Bank PGK Nettetal	DEUTDEDB315
1075	31470024	Deutsche Bank PGK Grefrath	DEUTDEDB316
1076	31070024	Deutsche Bank PGK Korschenb	DEUTDEDB317
1077	31070024	Deutsche Bank PGK Wegberg	DEUTDEDB318
1078	31070024	Deutsche Bank PGK Erkelenz	DEUTDEDB319
1079	32070024	Deutsche Bank PGK Krefeld	DEUTDEDB320
1080	32070024	Deutsche Bank PGK Xanten	DEUTDEDB321
1081	32070024	Deutsche Bank PGK Willich	DEUTDEDB322
1082	32070024	Deutsche Bank PGK Geldern	DEUTDEDB323
1083	32470024	Deutsche Bank PGK Kleve	DEUTDEDB324
1084	32470024	Deutsche Bank PGK Goch	DEUTDEDB325
1085	32470024	Deutsche Bank PGK Emmerich	DEUTDEDB326
1086	32070024	Deutsche Bank PGK Kempen	DEUTDEDB327
1087	32070024	Deutsche Bank PGK Kevelaer	DEUTDEDB328
1088	32070024	Deutsche Bank PGK Rheinberg	DEUTDEDB329
1089	33070024	Deutsche Bank PGK Velbert	DEUTDEDB330
1090	33070024	Deutsche Bank PGK Ennepetal	DEUTDEDB331
1091	33070024	Deutsche Bank PGK Heiligenh	DEUTDEDB332
1092	33070024	Deutsche Bank PGK Mettmann	DEUTDEDB333
1093	33070024	Deutsche Bank PGK Schwelm	DEUTDEDB334
1094	33070024	Deutsche Bank PGK Wülfrath	DEUTDEDB335
1095	34070024	Deutsche Bank PGK Remscheid	DEUTDEDB340
1096	34070024	Deutsche Bank PGK Wipperfür	DEUTDEDB341
1097	34270024	Deutsche Bank PGK Solingen	DEUTDEDB342
1098	34270024	Deutsche Bank PGK Haan	DEUTDEDB343
1099	34070024	Deutsche Bank PGK Hückeswag	DEUTDEDB344
1100	34070024	Deutsche Bank PGK Radevormw	DEUTDEDB345
1101	34070024	Deutsche Bank PGK Wermelski	DEUTDEDB346
1102	35070024	Deutsche Bank PGK Duisburg	DEUTDEDB350
1103	35070024	Deutsche Bank PGK Dinslaken	DEUTDEDB351
1104	35070024	Deutsche Bank PGK Kamp-Lint	DEUTDEDB352
1105	37070024	Deutsche Bank PGK Eitorf	DEUTDEDB353
1106	35070024	Deutsche Bank PGK Moers	DEUTDEDB354
1107	37070024	Deutsche Bank PGK Frechen	DEUTDEDB355
1108	35070024	Deutsche Bank PGK Wesel	DEUTDEDB356
1109	37070024	Deutsche Bank PGK Hürth	DEUTDEDB357
1110	37070024	Deutsche Bank PGK Kerpen	DEUTDEDB358
1111	37070024	Deutsche Bank PGK Troisdorf	DEUTDEDB360
1112	36270024	Deutsche Bank PGK Mülheim	DEUTDEDB362
1113	36570024	Deutsche Bank PGK Oberhause	DEUTDEDB365
1114	42070024	Deutsche Bank PGK Gladbeck	DEUTDEDB366
1115	37070024	Deutsche Bank PGK Brühl	DEUTDEDB370
1116	37070024	Deutsche Bank PGK Wesseling	DEUTDEDB371
1117	37070024	Deutsche Bank PGK Grevenbro	DEUTDEDB372
1118	37070024	Deutsche Bank PGK Bergisch-	DEUTDEDB373
1119	37570024	Deutsche Bank PGK Leverkuse	DEUTDEDB375
1120	37570024	Deutsche Bank PGK Leichling	DEUTDEDB377
1121	37570024	Deutsche Bank PGK Burscheid	DEUTDEDB378
1122	37070024	Deutsche Bank PGK Euskirche	DEUTDEDB379
1123	38070024	Deutsche Bank PGK Bonn	DEUTDEDB380
1124	38077724	Deutsche Bank PGK DirektBk	DEUTDEDB383
1125	38470024	Deutsche Bank PGK Gummersb	DEUTDEDB384
1126	38470024	Deutsche Bank PGK Bergneust	DEUTDEDB385
1127	37070024	Deutsche Bank PGK Siegburg	DEUTDEDB386
1128	38470024	Deutsche Bank PGK Waldbröl	DEUTDEDB387
1129	38470024	Deutsche Bank PGK Engelskir	DEUTDEDB388
1130	38470024	Deutsche Bank PGK Meinerzha	DEUTDEDB389
1131	39070024	Deutsche Bank PGK Aachen	DEUTDEDB390
1132	39070024	Deutsche Bank PGK Eschweile	DEUTDEDB391
1133	39070024	Deutsche Bank PGK Jülich	DEUTDEDB392
1134	39070024	Deutsche Bank PGK Stolberg	DEUTDEDB393
1135	39070024	Deutsche Bank PGK Hückelhov	DEUTDEDB394
1136	39570024	Deutsche Bank PGK Düren	DEUTDEDB395
1137	39570024	Deutsche Bank PGK Kreuzau	DEUTDEDB396
1138	39070024	Deutsche Bank PGK Herzogenr	DEUTDEDB397
1139	39070024	Deutsche Bank PGK Alsdorf	DEUTDEDB398
1140	39070024	Deutsche Bank PGK Übach-P	DEUTDEDB399
1141	40070024	Deutsche Bank PGK Münster	DEUTDEDB400
1142	40370024	Deutsche Bank PGK Gronau	DEUTDEDB401
1143	40370024	Deutsche Bank PGK Rheine	DEUTDEDB403
1144	40070024	Deutsche Bank PGK Warendorf	DEUTDEDB404
1145	40370024	Deutsche Bank PGK Ahaus	DEUTDEDB405
1146	40370024	Deutsche Bank PGK Emsdetten	DEUTDEDB406
1147	40370024	Deutsche Bank PGK Ibbenbüre	DEUTDEDB407
1148	40370024	Deutsche Bank PGK Stadtlohn	DEUTDEDB408
1149	40370024	Deutsche Bank PGK Vreden	DEUTDEDB409
1150	41070024	Deutsche Bank PGK Hamm	DEUTDEDB410
1151	41070024	Deutsche Bank PGK Ahlen	DEUTDEDB412
1152	48070024	Deutsche Bank PGK Beckum	DEUTDEDB413
1153	41670024	Deutsche Bank PGK Soest	DEUTDEDB414
1154	41670024	Deutsche Bank PGK Lippstadt	DEUTDEDB416
1155	41670024	Deutsche Bank PGK Brilon	DEUTDEDB417
1156	41670024	Deutsche Bank PGK Werl	DEUTDEDB418
1157	42070024	Deutsche Bank PGK Gelsenkir	DEUTDEDB420
1158	42070024	Deutsche Bank PGK Recklingh	DEUTDEDB421
1159	42070024	Deutsche Bank PGK Bottrop	DEUTDEDB422
1160	42070024	Deutsche Bank PGK Datteln	DEUTDEDB423
1161	42070024	Deutsche Bank PGK Dorsten	DEUTDEDB424
1162	42070024	Deutsche Bank PGK Marl	DEUTDEDB425
1163	42070024	Deutsche Bank PGK Herten	DEUTDEDB426
1164	42870024	Deutsche Bank PGK Bocholt	DEUTDEDB428
1165	42870024	Deutsche Bank PGK Borken	DEUTDEDB429
1166	43070024	Deutsche Bank PGK Bochum	DEUTDEDB430
1167	43070024	Deutsche Bank PGK Witten	DEUTDEDB431
1168	43070024	Deutsche Bank PGK Herne	DEUTDEDB432
1169	43070024	Deutsche Bank PGK Hattingen	DEUTDEDB433
1170	43070024	Deutsche Bank PGK Sprockhöv	DEUTDEDB434
1171	44070024	Deutsche Bank PGK Dortmund	DEUTDEDB440
1172	44070024	Deutsche Bank PGK Castrop-R	DEUTDEDB441
1173	44070024	Deutsche Bank PGK Lünen	DEUTDEDB442
1174	44070024	Deutsche Bank PGK Unna	DEUTDEDB443
1175	44070024	Deutsche Bank PGK Schwerte	DEUTDEDB444
1176	44570024	Deutsche Bank PGK Iserlohn	DEUTDEDB445
1177	44570024	Deutsche Bank PGK Altena	DEUTDEDB446
1178	44070024	Deutsche Bank PGK Waltrop	DEUTDEDB447
1179	44070024	Deutsche Bank PGK Werne	DEUTDEDB448
1180	44570024	Deutsche Bank PGK Plettenbe	DEUTDEDB449
1181	45070024	Deutsche Bank PGK Hagen	DEUTDEDB450
1182	45070024	Deutsche Bank PGK Lüdensche	DEUTDEDB451
1183	45070024	Deutsche Bank PGK Herdecke	DEUTDEDB453
1184	45070024	Deutsche Bank PGK Gevelsber	DEUTDEDB454
1185	45070024	Deutsche Bank PGK Kierspe	DEUTDEDB456
1186	46070024	Deutsche Bank PGK Siegen	DEUTDEDB460
1187	46070024	Deutsche Bank PGK Biedenkop	DEUTDEDB461
1188	46070024	Deutsche Bank PGK Olpe	DEUTDEDB462
1189	46070024	Deutsche Bank PGK Bad Berle	DEUTDEDB463
1190	46070024	Deutsche Bank PGK Wissen	DEUTDEDB464
1191	46070024	Deutsche Bank PGK Neunkirch	DEUTDEDB465
1192	46070024	Deutsche Bank PGK Betzdorf	DEUTDEDB466
1193	46670024	Deutsche Bank PGK Sundern	DEUTDEDB467
1194	46670024	Deutsche Bank PGK Meschede	DEUTDEDB468
1195	46070024	Deutsche Bank PGK Laasphe	DEUTDEDB469
1196	46070024	Deutsche Bank PGK Freudenb	DEUTDEDB470
1197	46070024	Deutsche Bank PGK Herborn	DEUTDEDB471
1198	47270024	Deutsche Bank PGK Paderborn	DEUTDEDB472
1199	47270024	Deutsche Bank PGK Bad Dribu	DEUTDEDB473
1200	47270024	Deutsche Bank PGK Bad Lipps	DEUTDEDB474
1201	47270024	Deutsche Bank PGK Geseke	DEUTDEDB475
1202	47670024	Deutsche Bank PGK Detmold	DEUTDEDB476
1203	47670024	Deutsche Bank PGK Bad Salzu	DEUTDEDB477
1204	47670024	Deutsche Bank PGK Lemgo	DEUTDEDB478
1205	48070024	Deutsche Bank PGK Gütersloh	DEUTDEDB480
1206	48070024	Deutsche Bank PGK Herford	DEUTDEDB481
1207	48070024	Deutsche Bank PGK Halle Wes	DEUTDEDB483
1208	48070024	Deutsche Bank PGK Harsewink	DEUTDEDB484
1209	48070024	Deutsche Bank PGK Oelde	DEUTDEDB485
1210	48070024	Deutsche Bank PGK Oerlingha	DEUTDEDB486
1211	48070024	Deutsche Bank PGK Rheda-Wie	DEUTDEDB487
1212	48070024	Deutsche Bank PGK Spenge	DEUTDEDB488
1213	48070024	Deutsche Bank PGK Verl	DEUTDEDB489
1214	49070024	Deutsche Bank PGK Minden	DEUTDEDB490
1215	49070024	Deutsche Bank PGK Bad Oeynh	DEUTDEDB491
1216	48070024	Deutsche Bank PGK Bünde Wes	DEUTDEDB492
1217	49070024	Deutsche Bank PGK Espelkamp	DEUTDEDB493
1218	49070024	Deutsche Bank PGK Löhne	DEUTDEDB494
1219	49070024	Deutsche Bank PGK Lübbecke	DEUTDEDB495
1220	50070024	Deutsche Bank PGK Bad Hombu	DEUTDEDB500
1221	50073024	Deutsche Bank PGK Rüsselshe	DEUTDEDB502
1222	50070024	Deutsche Bank PGK Friedbg	DEUTDEDB503
1223	50070024	Deutsche Bank PGK Oberursel	DEUTDEDB504
1224	50570024	Deutsche Bank PGK Offenbach	DEUTDEDB505
1225	50670024	Deutsche Bank PGK Hanau	DEUTDEDB506
1226	50570024	Deutsche Bank PGK Neu-Isenb	DEUTDEDB507
1227	50870024	Deutsche Bank PGK Darmstadt	DEUTDEDB508
1228	50970024	Deutsche Bank PGK Bensheim	DEUTDEDB509
1229	51070024	Deutsche Bank PGK Wiesbaden	DEUTDEDB510
1230	51170024	Deutsche Bank PGK Limburg	DEUTDEDB511
1231	51070024	Deutsche Bank PGK Eltville	DEUTDEDB512
1232	51370024	Deutsche Bank PGK Gießen	DEUTDEDB513
1233	51070024	Deutsche Bank PGK Taunusste	DEUTDEDB514
1234	51570024	Deutsche Bank PGK Wetzlar	DEUTDEDB515
1235	46070024	Deutsche Bank PGK Dillenbur	DEUTDEDB516
1236	53270024	Deutsche Bank PGK Bad Hersf	DEUTDEDB518
1237	50970024	Deutsche Bank PGK Heppenhei	DEUTDEDB519
1238	52070024	Deutsche Bank PGK Kassel	DEUTDEDB520
1239	52071224	Deutsche Bank PGK Bad Wildu	DEUTDEDB521
1240	52270024	Deutsche Bank PGK Eschwege	DEUTDEDB522
1241	52070024	Deutsche Bank PGK Baunatal	DEUTDEDB523
1242	52070024	Deutsche Bank PGK Hann Münd	DEUTDEDB524
1243	50570024	Deutsche Bank PGK Rodgau	DEUTDEDB525
1244	50570024	Deutsche Bank PGK Obertshau	DEUTDEDB526
1245	50570024	Deutsche Bank PGK Mühlheim	DEUTDEDB527
1246	50570024	Deutsche Bank PGK Langen	DEUTDEDB528
1247	50570024	Deutsche Bank PGK Heusensta	DEUTDEDB529
1248	53070024	Deutsche Bank PGK Fulda	DEUTDEDB530
1249	53070024	Deutsche Bank PGK Alsfeld	DEUTDEDB531
1250	53370024	Deutsche Bank PGK Marburg	DEUTDEDB533
1251	53070024	Deutsche Bank PGK Lauterba	DEUTDEDB534
1252	50070024	Deutsche Bank PGK Königstei	DEUTDEDB535
1253	50070024	Deutsche Bank PGK Kronberg	DEUTDEDB536
1254	50073024	Deutsche Bank PGK Raunheim	DEUTDEDB537
1255	50570024	Deutsche Bank PGK Dietzenb	DEUTDEDB538
1256	50570024	Deutsche Bank PGK Dreieich	DEUTDEDB539
1257	54070024	Deutsche Bank PGK Kaisersla	DEUTDEDB540
1258	54070024	Deutsche Bank PGK Landstuhl	DEUTDEDB541
1259	54270024	Deutsche Bank PGK Pirmasens	DEUTDEDB542
1260	54270024	Deutsche Bank PGK Zweibrück	DEUTDEDB543
1261	54570024	Deutsche Bank PGK Frankenth	DEUTDEDB544
1262	54570024	Deutsche Bank PGK Ludwigsha	DEUTDEDB545
1263	54670024	Deutsche Bank PGK Neustadt	DEUTDEDB546
1264	54570024	Deutsche Bank PGK Speyer	DEUTDEDB547
1265	54670024	Deutsche Bank PGK Landau	DEUTDEDB548
1266	54570024	Deutsche Bank PGK Alzey	DEUTDEDB549
1267	54570024	Deutsche Bank PGK Limburger	DEUTDEDB550
1268	55070024	Deutsche Bank PGK Ingelheim	DEUTDEDB551
1269	54670024	Deutsche Bank PGK Bad Dürkh	DEUTDEDB552
1270	54570024	Deutsche Bank PGK Worms	DEUTDEDB553
1271	50870024	Deutsche Bank PGK Griesheim	DEUTDEDB554
1272	50870024	Deutsche Bank PGK Groß-Gera	DEUTDEDB555
1273	56070024	Deutsche Bank PGK Bad Kreuz	DEUTDEDB560
1274	55070024	Deutsche Bank PGK Ginsheim-	DEUTDEDB561
1275	56270024	Deutsche Bank PGK I-Oberst	DEUTDEDB562
1276	55070024	Deutsche Bank PGK Bingen, R	DEUTDEDB563
1277	57070024	Deutsche Bank PGK Koblenz	DEUTDEDB570
1278	57070024	Deutsche Bank PGK Boppard	DEUTDEDB571
1279	57070024	Deutsche Bank PGK Bendorf	DEUTDEDB572
1280	57070024	Deutsche Bank PGK Lahnstein	DEUTDEDB573
1281	57470024	Deutsche Bank PGK Neuwied	DEUTDEDB574
1282	57470024	Deutsche Bank PGK Andernach	DEUTDEDB575
1283	57470024	Deutsche Bank PGK Mayen	DEUTDEDB576
1284	57070024	Deutsche Bank PGK Höhr-Gren	DEUTDEDB577
1285	57070024	Deutsche Bank PGK Montabaur	DEUTDEDB578
1286	57470024	Deutsche Bank PGK Weißenthu	DEUTDEDB579
1287	58570024	Deutsche Bank PGK Konz	DEUTDEDB580
1288	58570024	Deutsche Bank PGK Trier	DEUTDEDB585
1289	58570024	Deutsche Bank PGK Wittlich	DEUTDEDB586
1290	58771224	Deutsche Bank PGK Bernkast-	DEUTDEDB587
1291	58771224	Deutsche Bank PGK Zell Mose	DEUTDEDB588
1292	58771224	Deutsche Bank PGK Traben-Tr	DEUTDEDB589
1293	59070070	Deutsche Bank PGK Saar	DEUTDEDB590
1294	59070070	Deutsche Bank PGK Saar	DEUTDEDB595
1295	60070024	Deutsche Bank PGK Böblingen	DEUTDEDB602
1296	65370024	Deutsche Bank PGK Tuttlinge	DEUTDEDB603
1297	60470024	Deutsche Bank PGK Ludwigsbu	DEUTDEDB604
1298	60070024	Deutsche Bank PGK Sindelfi	DEUTDEDB605
1299	60270024	Deutsche Bank PGK Waiblinge	DEUTDEDB606
1300	60470024	Deutsche Bank PGK Asperg	DEUTDEDB608
1301	60070024	Deutsche Bank PGK Leinfelde	DEUTDEDB609
1302	61070024	Deutsche Bank PGK Göppingen	DEUTDEDB610
1303	61170024	Deutsche Bank PGK Esslingen	DEUTDEDB611
1304	61170024	Deutsche Bank PGK Nürtingen	DEUTDEDB612
1305	61370024	Deutsche Bank PGK Schwäb Gm	DEUTDEDB613
1306	61370024	Deutsche Bank PGK Aalen	DEUTDEDB614
1307	61370024	Deutsche Bank PGK Heidenhei	DEUTDEDB615
1308	61370024	Deutsche Bank PGK Schorndor	DEUTDEDB616
1309	60470024	Deutsche Bank PGK Kornwesth	DEUTDEDB617
1310	61070024	Deutsche Bank PGK Geislinge	DEUTDEDB618
1311	61170024	Deutsche Bank PGK Kirchheim	DEUTDEDB619
1312	62070024	Deutsche Bank PGK Heilbronn	DEUTDEDB620
1313	62070024	Deutsche Bank PGK Neckarsul	DEUTDEDB621
1314	62070024	Deutsche Bank PGK Schwäb Ha	DEUTDEDB622
1315	60470024	Deutsche Bank PGK Marbach	DEUTDEDB623
1316	60070024	Deutsche Bank PGK Leonberg	DEUTDEDB624
1317	61170024	Deutsche Bank PGK Plochinge	DEUTDEDB626
1318	61070024	Deutsche Bank PGK Eislingen	DEUTDEDB627
1319	62070024	Deutsche Bank PGK Künzelsau	DEUTDEDB628
1320	62070024	Deutsche Bank PGK Öhringen	DEUTDEDB629
1321	63070024	Deutsche Bank PGK Ulm Donau	DEUTDEDB630
1322	63070024	Deutsche Bank PGK Biberach	DEUTDEDB631
1323	63070024	Deutsche Bank PGK Neu-Ulm	DEUTDEDB632
1324	61370024	Deutsche Bank PGK Nördlinge	DEUTDEDB633
1325	64070024	Deutsche Bank PGK Metzingen	DEUTDEDB634
1326	60470024	Deutsche Bank PGK Bietighei	DEUTDEDB635
1327	64070024	Deutsche Bank PGK Pfullinge	DEUTDEDB636
1328	61370024	Deutsche Bank PGK Crailshei	DEUTDEDB637
1329	61370024	Deutsche Bank PGK Ellwangen	DEUTDEDB638
1330	61370024	Deutsche Bank PGK Giengen	DEUTDEDB639
1331	64070024	Deutsche Bank PGK Reutlinge	DEUTDEDB640
1332	64070024	Deutsche Bank PGK Tübingen	DEUTDEDB641
1333	69470024	Deutsche Bank PGK Rottweil	DEUTDEDB642
1334	64070024	Deutsche Bank PGK Nagold	DEUTDEDB643
1335	69470024	Deutsche Bank PGK Spaiching	DEUTDEDB644
1336	64070024	Deutsche Bank PGK Rottenbur	DEUTDEDB645
1337	64070024	Deutsche Bank PGK Freudenst	DEUTDEDB646
1338	60070024	Deutsche Bank PGK Gerlingen	DEUTDEDB647
1339	60470024	Deutsche Bank PGK Markgröni	DEUTDEDB648
1340	65070024	Deutsche Bank PGK Tettnang	DEUTDEDB649
1341	65070024	Deutsche Bank PGK Ravensbur	DEUTDEDB650
1342	65070024	Deutsche Bank PGK Friedrich	DEUTDEDB651
1343	65070024	Deutsche Bank PGK Leutkirch	DEUTDEDB652
1344	65370024	Deutsche Bank PGK Albstadt	DEUTDEDB653
1345	65070024	Deutsche Bank PGK Lindau	DEUTDEDB654
1346	65370024	Deutsche Bank PGK Balingen	DEUTDEDB655
1347	65070024	Deutsche Bank PGK Wangen	DEUTDEDB657
1348	65070024	Deutsche Bank PGK Weingarte	DEUTDEDB658
1349	60670024	Deutsche Bank PGK Untertürk	DEUTDEDB659
1350	66070024	Deutsche Bank PGK Karlsruhe	DEUTDEDB660
1351	66070024	Deutsche Bank PGK Bruchsal	DEUTDEDB661
1352	66270024	Deutsche Bank PGK Baden-Bad	DEUTDEDB662
1353	66070024	Deutsche Bank PGK Bretten	DEUTDEDB663
1354	66070024	Deutsche Bank PGK Ettlingen	DEUTDEDB664
1355	66270024	Deutsche Bank PGK Rastatt	DEUTDEDB665
1356	66670024	Deutsche Bank PGK Pforzheim	DEUTDEDB666
1357	66270024	Deutsche Bank PGK Gernsbach	DEUTDEDB667
1358	66270024	Deutsche Bank PGK Bühl	DEUTDEDB669
1359	67070024	Deutsche Bank PGK Weinheim	DEUTDEDB670
1360	66270024	Deutsche Bank PGK Gaggenau	DEUTDEDB671
1361	67270024	Deutsche Bank PGK Heidelber	DEUTDEDB672
1362	67070024	Deutsche Bank PGK Schwetzin	DEUTDEDB673
1363	67270024	Deutsche Bank PGK Mosbach	DEUTDEDB674
1364	67070024	Deutsche Bank PGK Viernheim	DEUTDEDB675
1365	67070024	Deutsche Bank PGK Hockenhei	DEUTDEDB676
1366	66670024	Deutsche Bank PGK Mühlacker	DEUTDEDB677
1367	67270024	Deutsche Bank PGK Wiesloch	DEUTDEDB678
1368	68370024	Deutsche Bank PGK Weil Rhei	DEUTDEDB679
1369	68370024	Deutsche Bank PGK Wehr Bade	DEUTDEDB680
1370	68070024	Deutsche Bank PGK Emmending	DEUTDEDB681
1371	68270024	Deutsche Bank PGK Lahr	DEUTDEDB682
1372	68370024	Deutsche Bank PGK Lörrach	DEUTDEDB683
1373	68370024	Deutsche Bank PGK Bad Säcki	DEUTDEDB684
1374	68070024	Deutsche Bank PGK Müllheim	DEUTDEDB685
1375	68370024	Deutsche Bank PGK Rheinfeld	DEUTDEDB686
1376	68070024	Deutsche Bank PGK Waldkirch	DEUTDEDB687
1377	68370024	Deutsche Bank PGK Grenzach-	DEUTDEDB688
1378	68070024	Deutsche Bank PGK Titisee-N	DEUTDEDB689
1379	69070024	Deutsche Bank PGK Konstanz	DEUTDEDB690
1380	69070024	Deutsche Bank PGK Überlinge	DEUTDEDB691
4824	67230000	MLP FDL	MLPBDE61XXX
1381	69270024	Deutsche Bank PGK Singen	DEUTDEDB692
1382	68370024	Deutsche Bank PGK Schopfhei	DEUTDEDB693
1383	69470024	Deutsche Bank PGK Villingen	DEUTDEDB694
1384	69270024	Deutsche Bank PGK Radolfzel	DEUTDEDB696
1385	69470024	Deutsche Bank PGK Triberg	DEUTDEDB697
1386	69470024	Deutsche Bank PGK Donauesch	DEUTDEDB698
1387	69470024	Deutsche Bank PGK Sankt Geo	DEUTDEDB699
1388	70070024	Deutsche Bank PGK Bad Tölz	DEUTDEDB700
1389	70070024	Deutsche Bank PGK Garmisch-	DEUTDEDB701
1390	70070024	Deutsche Bank PGK Landsberg	DEUTDEDB702
1391	70070024	Deutsche Bank PGK Landshut	DEUTDEDB703
1392	70070024	Deutsche Bank PGK Mühldorf	DEUTDEDB704
1393	70070024	Deutsche Bank PGK Rosenheim	DEUTDEDB705
1394	70070024	Deutsche Bank PGK Dachau	DEUTDEDB706
1395	70070024	Deutsche Bank PGK Freising	DEUTDEDB707
1396	70070024	Deutsche Bank PGK Fürstenfe	DEUTDEDB708
1397	70070024	Deutsche Bank PGK Starnberg	DEUTDEDB709
1398	70070024	Deutsche Bank PGK Bad Reich	DEUTDEDB710
1399	70070024	Deutsche Bank PGK Weilheim	DEUTDEDB711
1400	70070024	Deutsche Bank PGK Erding	DEUTDEDB712
1401	70070024	Deutsche Bank PGK Germering	DEUTDEDB713
1402	70070024	Deutsche Bank PGK Grünwald	DEUTDEDB714
1403	70070024	Deutsche Bank PGK Ottobrunn	DEUTDEDB715
1404	70070024	Deutsche Bank PGK Planegg	DEUTDEDB716
1405	70070024	Deutsche Bank PGK Rottach-E	DEUTDEDB717
1406	72070024	Deutsche Bank PGK Augsburg	DEUTDEDB720
1407	72170024	Deutsche Bank PGK Ingolstad	DEUTDEDB721
1408	72170024	Deutsche Bank PGK Neuburg	DEUTDEDB722
1409	72070024	Deutsche Bank PGK Bad Wöris	DEUTDEDB723
1410	72070024	Deutsche Bank PGK Dillingen	DEUTDEDB724
1411	72070024	Deutsche Bank PGK Gersthofe	DEUTDEDB725
1412	72070024	Deutsche Bank PGK Günzburg	DEUTDEDB726
1413	72070024	Deutsche Bank PGK Königsbru	DEUTDEDB727
1414	72170024	Deutsche Bank PGK Pfaffenho	DEUTDEDB728
1415	72170024	Deutsche Bank PGK Vohburg	DEUTDEDB729
1416	73370024	Deutsche Bank PGK Kempten	DEUTDEDB733
1417	73370024	Deutsche Bank PGK Memmingen	DEUTDEDB734
1418	73370024	Deutsche Bank PGK Sonthofen	DEUTDEDB735
1419	73370024	Deutsche Bank PGK Marktober	DEUTDEDB736
1420	73370024	Deutsche Bank PGK Kaufbeure	DEUTDEDB737
1421	75070024	Deutsche Bank PGK Deggendor	DEUTDEDB741
1422	75070024	Deutsche Bank PGK Regensbur	DEUTDEDB750
1423	75070024	Deutsche Bank PGK Straubing	DEUTDEDB751
1424	75070024	Deutsche Bank PGK Passau	DEUTDEDB752
1425	76070024	Deutsche Bank PGK Nürnberg	DEUTDEDB760
1426	76070024	Deutsche Bank PGK Ansbach	DEUTDEDB761
1427	76070024	Deutsche Bank PGK Bamberg	DEUTDEDB762
1428	76070024	Deutsche Bank PGK Erlangen	DEUTDEDB763
1429	76070024	Deutsche Bank PGK Fürth Bay	DEUTDEDB764
1430	76070024	Deutsche Bank PGK Amberg	DEUTDEDB765
1431	76070024	Deutsche Bank PGK Weiden	DEUTDEDB766
1432	76070024	Deutsche Bank PGK Neumarkt	DEUTDEDB767
1433	76070024	Deutsche Bank PGK Forchheim	DEUTDEDB768
1434	76070024	Deutsche Bank PGK Zirndorf	DEUTDEDB769
1435	76070024	Deutsche Bank PGK Schwabach	DEUTDEDB771
1436	76070024	Deutsche Bank PGK Lauf	DEUTDEDB772
1437	76070024	Deutsche Bank PGK Bayreuth	DEUTDEDB773
1438	76070024	Deutsche Bank PGK Kulmbach	DEUTDEDB774
1439	76070024	Deutsche Bank PGK Coburg	DEUTDEDB783
1440	79070024	Deutsche Bank PGK Würzburg	DEUTDEDB790
1441	79070024	Deutsche Bank PGK Schweinfu	DEUTDEDB791
1442	79070024	Deutsche Bank PGK Bad Merge	DEUTDEDB792
1443	79570024	Deutsche Bank PGK Aschaffen	DEUTDEDB795
1444	79570024	Deutsche Bank PGK Miltenber	DEUTDEDB796
1445	81070024	Deutsche Bank PGK Schöneb	DEUTDEDB801
1446	81070024	Deutsche Bank PGK Staßfurt	DEUTDEDB802
1447	81070024	Deutsche Bank PGK Stendal	DEUTDEDB803
1448	81070024	Deutsche Bank PGK Wernigero	DEUTDEDB804
1449	81070024	Deutsche Bank PGK Zerbst	DEUTDEDB806
1450	81070024	Deutsche Bank PGK Gardelege	DEUTDEDB811
1451	81070024	Deutsche Bank PGK Genthin	DEUTDEDB812
1452	81070024	Deutsche Bank PGK Burg Magd	DEUTDEDB814
1453	81070024	Deutsche Bank PGK Blankenbu	DEUTDEDB815
1454	81070024	Deutsche Bank PGK Halbersta	DEUTDEDB816
1455	81070024	Deutsche Bank PGK Haldensle	DEUTDEDB817
1456	81070024	Deutsche Bank PGK Oschersle	DEUTDEDB818
1457	81070024	Deutsche Bank PGK Salzwedel	DEUTDEDB819
1458	82070024	Deutsche Bank PGK Weimar	DEUTDEDB820
1459	82070024	Deutsche Bank PGK Worbis	DEUTDEDB821
1460	82070024	Deutsche Bank PGK Sondersha	DEUTDEDB822
1461	82070024	Deutsche Bank PGK Sömmerda	DEUTDEDB823
1462	82070024	Deutsche Bank PGK Nordhause	DEUTDEDB824
1463	82070024	Deutsche Bank PGK Mühlhause	DEUTDEDB825
1464	82070024	Deutsche Bank PGK Leinefeld	DEUTDEDB826
1465	82070024	Deutsche Bank PGK Gotha	DEUTDEDB827
1466	82070024	Deutsche Bank PGK Apolda	DEUTDEDB828
1467	82070024	Deutsche Bank PGK Bad Lange	DEUTDEDB829
1468	82070024	Deutsche Bank PGK Gera	DEUTDEDB830
1469	82070024	Deutsche Bank PGK Jena	DEUTDEDB831
1470	82070024	Deutsche Bank PGK Eisenberg	DEUTDEDB832
1471	82070024	Deutsche Bank PGK Greiz	DEUTDEDB833
1472	82070024	Deutsche Bank PGK Pößneck	DEUTDEDB835
1473	82070024	Deutsche Bank PGK Zeulenrod	DEUTDEDB836
1474	82070024	Deutsche Bank PGK Suhl	DEUTDEDB840
1475	82070024	Deutsche Bank PGK Arnstadt	DEUTDEDB841
1476	82070024	Deutsche Bank PGK Bad Salzu	DEUTDEDB842
1477	82070024	Deutsche Bank PGK Eisenach	DEUTDEDB843
5137	66251434	Sparkasse Bühl	SOLADES1BHL
1478	82070024	Deutsche Bank PGK Ilmenau	DEUTDEDB844
1479	82070024	Deutsche Bank PGK Meiningen	DEUTDEDB845
1480	82070024	Deutsche Bank PGK Ohrdruf	DEUTDEDB846
1481	82070024	Deutsche Bank PGK Rudolstad	DEUTDEDB847
1482	82070024	Deutsche Bank PGK Saalfeld	DEUTDEDB848
1483	82070024	Deutsche Bank PGK Schmalkal	DEUTDEDB849
1484	82070024	Deutsche Bank PGK Sonneberg	DEUTDEDB850
1485	82070024	Deutsche Bank PGK Waltersha	DEUTDEDB851
1486	86070024	Deutsche Bank PGK Halle	DEUTDEDB860
1487	86070024	Deutsche Bank PGK Altenburg	DEUTDEDB861
1488	86070024	Deutsche Bank PGK Aschersle	DEUTDEDB862
1489	86070024	Deutsche Bank PGK Bernburg	DEUTDEDB863
1490	86070024	Deutsche Bank PGK Bitterfel	DEUTDEDB864
1491	86070024	Deutsche Bank PGK Borna	DEUTDEDB865
1492	86070024	Deutsche Bank PGK Delitzsch	DEUTDEDB866
1493	86070024	Deutsche Bank PGK Dessau	DEUTDEDB867
1494	86070024	Deutsche Bank PGK Döbeln	DEUTDEDB868
1495	86070024	Deutsche Bank PGK Eilenburg	DEUTDEDB869
1496	87070024	Deutsche Bank PGK Dresden	DEUTDEDB870
1497	87070024	Deutsche Bank PGK Annaberg	DEUTDEDB871
1498	87070024	Deutsche Bank PGK Aue	DEUTDEDB872
1499	87070024	Deutsche Bank PGK Auerbach	DEUTDEDB873
1500	87070024	Deutsche Bank PGK Bautzen	DEUTDEDB874
1501	87070024	Deutsche Bank PGK Burgstädt	DEUTDEDB875
1502	87070024	Deutsche Bank PGK Coswig	DEUTDEDB876
1503	87070024	Deutsche Bank PGK Crimmitsc	DEUTDEDB877
1504	87070024	Deutsche Bank PGK Frankenb	DEUTDEDB878
1505	87070024	Deutsche Bank PGK Freiberg	DEUTDEDB879
1506	87070024	Deutsche Bank PGK Freital	DEUTDEDB880
1507	87070024	Deutsche Bank PGK Glauchau	DEUTDEDB881
1508	87070024	Deutsche Bank PGK Görlitz	DEUTDEDB882
1509	87070024	Deutsche Bank PGK Großenhai	DEUTDEDB883
1510	87070024	Deutsche Bank PGK Heidenau	DEUTDEDB884
1511	87070024	Deutsche Bank PGK Hohenst-E	DEUTDEDB885
1512	87070024	Deutsche Bank PGK Hoyerswer	DEUTDEDB886
1513	87070024	Deutsche Bank PGK Kamenz	DEUTDEDB887
1514	87070024	Deutsche Bank PGK Klingenth	DEUTDEDB888
1515	87070024	Deutsche Bank PGK Lichtenst	DEUTDEDB889
1516	87070024	Deutsche Bank PGK Limbach-O	DEUTDEDB890
1517	87070024	Deutsche Bank PGK Löbau	DEUTDEDB891
1518	87070024	Deutsche Bank PGK Marienber	DEUTDEDB892
1519	87070024	Deutsche Bank PGK Meerane	DEUTDEDB893
1520	87070024	Deutsche Bank PGK Meißen	DEUTDEDB894
1521	87070024	Deutsche Bank PGK Mittweida	DEUTDEDB895
1522	87070024	Deutsche Bank PGK Niesky	DEUTDEDB896
1523	87070024	Deutsche Bank PGK Oberwiese	DEUTDEDB897
1524	87070024	Deutsche Bank PGK Pirna	DEUTDEDB898
1525	87070024	Deutsche Bank PGK Plauen	DEUTDEDB899
1526	87070024	Deutsche Bank PGK Radeberg	DEUTDEDB900
1527	87070024	Deutsche Bank PGK Radebeul	DEUTDEDB901
1528	87070024	Deutsche Bank PGK Reichenba	DEUTDEDB902
1529	87070024	Deutsche Bank PGK Riesa	DEUTDEDB903
1530	87070024	Deutsche Bank PGK Schneeber	DEUTDEDB905
1531	87070024	Deutsche Bank PGK Schwarzen	DEUTDEDB906
1532	87070024	Deutsche Bank PGK Stollbg	DEUTDEDB907
1533	87070024	Deutsche Bank PGK Werdau	DEUTDEDB908
1534	87070024	Deutsche Bank PGK Zittau	DEUTDEDB909
1535	87070024	Deutsche Bank PGK Zwickau	DEUTDEDB910
1536	26570024	Deutsche Bank PGK Bad Iburg	DEUTDEDB921
1537	26570024	Deutsche Bank PGK Bramsche	DEUTDEDB922
1538	26570024	Deutsche Bank PGK Georgsmar	DEUTDEDB923
1539	26570024	Deutsche Bank PGK Lengerich	DEUTDEDB924
1540	26570024	Deutsche Bank PGK Quakenbrü	DEUTDEDB925
1541	26770024	Deutsche Bank PGK Lingen	DEUTDEDB926
1542	26770024	Deutsche Bank PGK Meppen	DEUTDEDB927
1543	26770024	Deutsche Bank PGK Schüttorf	DEUTDEDB928
1544	26870024	Deutsche Bank PGK Clausthal	DEUTDEDB929
1545	27070024	Deutsche Bank PGK Herzberg	DEUTDEDB930
1546	25070024	Deutsche Bank PGK Laatzen	DEUTDEDB931
1547	25070024	Deutsche Bank PGK Langenhag	DEUTDEDB932
1548	25070024	Deutsche Bank PGK Munster	DEUTDEDB933
1549	26870024	Deutsche Bank PGK Seesen	DEUTDEDB934
1550	32070024	Deutsche Bank PGK Tönisvors	DEUTDEDB936
1551	37070024	Deutsche Bank PGK Bergheim	DEUTDEDB938
1552	37070024	Deutsche Bank PGK Dormagen	DEUTDEDB939
1553	37070024	Deutsche Bank PGK Euskirche	DEUTDEDB940
1554	37070024	Deutsche Bank PGK Hennef	DEUTDEDB941
1555	38070024	Deutsche Bank PGK Remagen	DEUTDEDB942
1556	38070024	Deutsche Bank PGK Bad Neuen	DEUTDEDB943
1557	38070024	Deutsche Bank PGK Bad Honne	DEUTDEDB944
1558	38070024	Deutsche Bank PGK Rheinbach	DEUTDEDB945
1559	38070024	Deutsche Bank PGK Meckenhei	DEUTDEDB946
1560	39070024	Deutsche Bank PGK Würselen	DEUTDEDB947
1561	39070024	Deutsche Bank PGK Heinsberg	DEUTDEDB948
1562	40070024	Deutsche Bank PGK Coesfeld	DEUTDEDB949
1563	40070024	Deutsche Bank PGK Dülmen	DEUTDEDB950
1564	40070024	Deutsche Bank PGK Greven	DEUTDEDB951
1565	40070024	Deutsche Bank PGK Steinfurt	DEUTDEDB952
1566	44570024	Deutsche Bank PGK Werdohl	DEUTDEDB953
1567	44570024	Deutsche Bank PGK Hemer	DEUTDEDB954
1568	44570024	Deutsche Bank PGK Menden	DEUTDEDB955
1569	44570024	Deutsche Bank PGK Neuenrade	DEUTDEDB956
1570	47670024	Deutsche Bank PGK Blomberg	DEUTDEDB957
1571	47270024	Deutsche Bank PGK Höxter	DEUTDEDB958
1572	47670024	Deutsche Bank PGK Horn-Bad	DEUTDEDB959
1573	47670024	Deutsche Bank PGK Lage Lipp	DEUTDEDB960
1574	46670024	Deutsche Bank PGK Arnsberg	DEUTDEDB961
5244	80020130	ZV LBBW Halle	SOLADEST802
1575	46070024	Deutsche Bank PGK Altenkirc	DEUTDEDB962
1576	46070024	Deutsche Bank PGK Attendorn	DEUTDEDB963
1577	46070024	Deutsche Bank PGK Lennestad	DEUTDEDB964
1578	46070024	Deutsche Bank PGK Schmallen	DEUTDEDB965
1579	46070024	Deutsche Bank PGK Kreuztal	DEUTDEDB966
1580	46070024	Deutsche Bank PGK Haiger	DEUTDEDB967
1581	66470024	Deutsche Bank PGK Offenburg	DEUTDEDB968
1582	66470024	Deutsche Bank PGK Kehl	DEUTDEDB969
1583	66470024	Deutsche Bank PGK Haslach	DEUTDEDB970
1584	66470024	Deutsche Bank PGK Oberkirch	DEUTDEDB971
1585	86070024	Deutsche Bank PGK Eisleben	DEUTDEDB973
1586	86070024	Deutsche Bank PGK Grimma	DEUTDEDB974
1587	86070024	Deutsche Bank PGK Hettstedt	DEUTDEDB975
1588	86070024	Deutsche Bank PGK Köthen	DEUTDEDB976
1589	86070024	Deutsche Bank PGK Markkleeb	DEUTDEDB977
1590	86070024	Deutsche Bank PGK Merseburg	DEUTDEDB978
1591	86070024	Deutsche Bank PGK Naumburg	DEUTDEDB980
1592	86070024	Deutsche Bank PGK Oschatz	DEUTDEDB981
1593	86070024	Deutsche Bank PGK Quedlinbu	DEUTDEDB982
1594	86070024	Deutsche Bank PGK Sangerhau	DEUTDEDB983
1595	86070024	Deutsche Bank PGK Schkeudit	DEUTDEDB984
1596	86070024	Deutsche Bank PGK Taucha	DEUTDEDB985
1597	86070024	Deutsche Bank PGK Torgau	DEUTDEDB986
1598	86070024	Deutsche Bank PGK Weißenfel	DEUTDEDB987
1599	86070024	Deutsche Bank PGK Wittenbg	DEUTDEDB988
1600	86070024	Deutsche Bank PGK Wurzen	DEUTDEDB990
1601	86070024	Deutsche Bank PGK Zeitz	DEUTDEDB991
1602	10070024	Deutsche Bank PGK Berlin	DEUTDEDBBER
1603	48070024	Deutsche Bank PGK Bielefeld	DEUTDEDBBIE
1604	29070024	Deutsche Bank PGK Bremen	DEUTDEDBBRE
1605	87070024	Deutsche Bank PGK Chemnitz	DEUTDEDBCHE
1606	30070024	Deutsche Bank PGK Düsseldor	DEUTDEDBDUE
1607	82070024	Deutsche Bank PGK Erfurt	DEUTDEDBERF
1608	36070024	Deutsche Bank PGK Essen	DEUTDEDBESS
1609	50070024	Deutsche Bank PGK Frankfurt	DEUTDEDBFRA
1610	68070024	Deutsche Bank PGK Freiburg	DEUTDEDBFRE
1611	20070024	Deutsche Bank PGK Hamburg	DEUTDEDBHAM
1612	25070024	Deutsche Bank PGK Hannover	DEUTDEDBHAN
1613	37070024	Deutsche Bank PGK Köln	DEUTDEDBKOE
1614	86070024	Deutsche Bank PGK Leipzig	DEUTDEDBLEG
1615	81070024	Deutsche Bank PGK Magdeburg	DEUTDEDBMAG
1616	55070024	Deutsche Bank PGK Mainz	DEUTDEDBMAI
1617	67070024	Deutsche Bank PGK Mannheim	DEUTDEDBMAN
1618	70070024	Deutsche Bank PGK München	DEUTDEDBMUC
1619	12070088	Deutsche Bank (Gf intern)	DEUTDEDBPAL
1620	13070024	Deutsche Bank PGK Rostock	DEUTDEDBROS
1621	60070024	Deutsche Bank PGK Stuttgart	DEUTDEDBSTG
1622	33070024	Deutsche Bank PGK Wuppertal	DEUTDEDBWUP
1623	38070724	Deutsche Bank PGK DirektBk	DEUTDEDBXXX
1624	30070010	Deutsche Bank Neuss	DEUTDEDD300
1625	30070010	Deutsche Bank Langenfeld Rh	DEUTDEDD301
1626	30070010	Deutsche Bank Monheim Rhein	DEUTDEDD302
1627	30070010	Deutsche Bank Meerbusch	DEUTDEDD303
1628	30070010	Deutsche Bank Ratingen	DEUTDEDD304
1629	30070010	Deutsche Bank Hilden	DEUTDEDD305
1630	30070010	Deutsche Bank Erkrath	DEUTDEDD306
1631	30070010	Deutsche Bank Kaarst	DEUTDEDD307
1632	31070001	Deutsche Bank Mönchengladb	DEUTDEDD310
1633	31470004	Deutsche Bank Viersen	DEUTDEDD314
1634	31470004	Deutsche Bank Nettetal	DEUTDEDD315
1635	31470004	Deutsche Bank Grefrath Kref	DEUTDEDD316
1636	31070001	Deutsche Bank Korschenbroic	DEUTDEDD317
1637	31070001	Deutsche Bank Wegberg	DEUTDEDD318
1638	31070001	Deutsche Bank Erkelenz	DEUTDEDD319
1639	32070080	Deutsche Bank Krefeld	DEUTDEDD320
1640	32070080	Deutsche Bank Xanten	DEUTDEDD321
1641	32070080	Deutsche Bank Willich	DEUTDEDD322
1642	32070080	Deutsche Bank Geldern	DEUTDEDD323
1643	32470077	Deutsche Bank Kleve	DEUTDEDD324
1644	32470077	Deutsche Bank Goch	DEUTDEDD325
1645	32470077	Deutsche Bank Emmerich	DEUTDEDD326
1646	32070080	Deutsche Bank Kempen	DEUTDEDD327
1647	32070080	Deutsche Bank Kevelaer	DEUTDEDD328
1648	32070080	Deutsche Bank Rheinberg	DEUTDEDD329
1649	32070080	Deutsche Bank Tönisvorst	DEUTDEDD331
1650	30070010	Deutsche Bank Düsseldorf	DEUTDEDDXXX
1651	35070030	Deutsche Bank Duisburg	DEUTDEDE350
1652	35070030	Deutsche Bank Dinslaken	DEUTDEDE351
1653	35070030	Deutsche Bank Kamp-Lintfort	DEUTDEDE352
1654	35070030	Deutsche Bank Moers	DEUTDEDE354
1655	35070030	Deutsche Bank Wesel	DEUTDEDE356
1656	36270048	Deutsche Bank Mülheim, Ruhr	DEUTDEDE362
1657	36570049	Deutsche Bank Oberhausen	DEUTDEDE365
1658	42070062	Deutsche Bank Gladbeck	DEUTDEDE384
1659	41070049	Deutsche Bank Hamm	DEUTDEDE410
1660	41070049	Deutsche Bank Ahlen Westf	DEUTDEDE412
1661	42070062	Deutsche Bank Gelsenkirchen	DEUTDEDE420
1662	42070062	Deutsche Bank Recklinghause	DEUTDEDE421
1663	42070062	Deutsche Bank Bottrop	DEUTDEDE422
1664	42070062	Deutsche Bank Datteln	DEUTDEDE423
1665	42070062	Deutsche Bank Dorsten	DEUTDEDE424
1666	42070062	Deutsche Bank Marl Westf	DEUTDEDE425
1667	42070062	Deutsche Bank Herten Westf	DEUTDEDE426
1668	43070061	Deutsche Bank Bochum	DEUTDEDE430
1669	43070061	Deutsche Bank Witten	DEUTDEDE431
1670	43070061	Deutsche Bank Herne	DEUTDEDE432
1671	43070061	Deutsche Bank Hattingen	DEUTDEDE433
1672	43070061	Deutsche Bank Sprockhövel	DEUTDEDE434
1673	44070050	Deutsche Bank Dortmund	DEUTDEDE440
1674	44070050	Deutsche Bank CastropRauxel	DEUTDEDE441
1675	44070050	Deutsche Bank Lünen	DEUTDEDE442
1676	44070050	Deutsche Bank Unna	DEUTDEDE443
1677	44070050	Deutsche Bank Schwerte	DEUTDEDE444
1678	44070050	Deutsche Bank Waltrop	DEUTDEDE447
1679	44070050	Deutsche Bank Werne Lippe	DEUTDEDE448
1680	36070050	Deutsche Bank Essen	DEUTDEDEXXX
1681	37070060	Deutsche Bank Bergheim Erft	DEUTDEDK351
1682	37070060	Deutsche Bank Dormagen	DEUTDEDK352
1683	37070060	Deutsche Bank Eitorf	DEUTDEDK353
1684	37070060	Deutsche Bank Euskirchen	DEUTDEDK354
1685	37070060	Deutsche Bank Frechen	DEUTDEDK355
1686	37070060	Deutsche Bank Hennef	DEUTDEDK356
1687	37070060	Deutsche Bank Hürth Rheinl	DEUTDEDK357
1688	37070060	Deutsche Bank Kerpen Rheinl	DEUTDEDK358
1689	37070060	Deutsche Bank Troisdorf	DEUTDEDK360
1690	37070060	Deutsche Bank Brühl Rheinl	DEUTDEDK370
1691	37070060	Deutsche Bank Wesseling	DEUTDEDK371
1692	37070060	Deutsche Bank Grevenbroich	DEUTDEDK372
1693	37070060	Deutsche Bank Bergisch-Glad	DEUTDEDK373
1694	37570064	Deutsche Bank Leverkusen	DEUTDEDK375
1695	37570064	Deutsche Bank Leichlingen	DEUTDEDK377
1696	37570064	Deutsche Bank Burscheid	DEUTDEDK378
1697	37070060	Deutsche Bank Euskirchen	DEUTDEDK379
1698	38070059	Deutsche Bank Bonn	DEUTDEDK380
1699	38070059	Deutsche Bank Remagen	DEUTDEDK384
1700	38070059	Deutsche Bank Bad Neuenahr	DEUTDEDK385
1701	37070060	Deutsche Bank Siegburg	DEUTDEDK386
1702	38070059	Deutsche Bank Bad Honnef	DEUTDEDK387
1703	38070059	Deutsche Bank Rheinbach	DEUTDEDK388
1704	38070059	Deutsche Bank Meckenheim Rh	DEUTDEDK389
1705	39070020	Deutsche Bank Aachen	DEUTDEDK390
1706	39070020	Deutsche Bank Eschweiler Rh	DEUTDEDK391
1707	39070020	Deutsche Bank Jülich	DEUTDEDK392
1708	39070020	Deutsche Bank Stolberg	DEUTDEDK393
1709	39070020	Deutsche Bank Hückelhoven	DEUTDEDK394
1710	39570061	Deutsche Bank Düren	DEUTDEDK395
1711	39570061	Deutsche Bank Kreuzau	DEUTDEDK396
1712	39070020	Deutsche Bank Herzogenrath	DEUTDEDK397
1713	39070020	Deutsche Bank Alsdorf Rhein	DEUTDEDK398
1714	39070020	Deutsche Bank Übach-Palenbg	DEUTDEDK399
1715	39070020	Deutsche Bank Würselen	DEUTDEDK400
1716	39070020	Deutsche Bank Heinsberg	DEUTDEDK401
1717	37070000	Deutsche Bk f Kunden Sal.Op	DEUTDEDK402
1718	46070090	Deutsche Bank Siegen	DEUTDEDK460
1719	46070090	Deutsche Bank Biedenkopf	DEUTDEDK461
1720	46070090	Deutsche Bank Olpe Biggesee	DEUTDEDK462
1721	46070090	Deutsche Bank Bad Berleburg	DEUTDEDK463
1722	46070090	Deutsche Bank Wissen Sieg	DEUTDEDK464
1723	46070090	Deutsche Bank Neunkirc Sieg	DEUTDEDK465
1724	46070090	Deutsche Bank Betzdorf Sieg	DEUTDEDK466
1725	46070090	Deutsche Bank Altenkirchen	DEUTDEDK467
1726	46070090	Deutsche Bank Attendorn	DEUTDEDK468
1727	46070090	Deutsche Bank Laasphe	DEUTDEDK469
1728	46070090	Deutsche Bank Freudenberg W	DEUTDEDK470
1729	46070090	Deutsche Bank Herborn Hess	DEUTDEDK471
1730	46070090	Deutsche Bank Lennestadt	DEUTDEDK472
1731	46070090	Deutsche Bank Schmallenberg	DEUTDEDK473
1732	46070090	Deutsche Bank Kreuztal	DEUTDEDK474
1733	46070090	Deutsche Bank Haiger	DEUTDEDK475
1734	46070090	Deutsche Bank Dillenburg	DEUTDEDK516
1735	37070060	Deutsche Bank Köln	DEUTDEDKXXX
1736	33070090	Deutsche Bank Velbert	DEUTDEDW330
1737	33070090	Deutsche Bank Ennepetal	DEUTDEDW331
1738	33070090	Deutsche Bank Heiligenhaus	DEUTDEDW332
1739	33070090	Deutsche Bank Mettmann	DEUTDEDW333
1740	33070090	Deutsche Bank Schwelm	DEUTDEDW334
1741	33070090	Deutsche Bank Wülfrath	DEUTDEDW335
1742	34070093	Deutsche Bank Remscheid	DEUTDEDW340
1743	34070093	Deutsche Bank Wipperfürth	DEUTDEDW341
1744	34270094	Deutsche Bank Solingen	DEUTDEDW342
1745	34270094	Deutsche Bank Haan Rheinl	DEUTDEDW343
1746	34070093	Deutsche Bank Hückeswagen	DEUTDEDW344
1747	34070093	Deutsche Bank Radevormwald	DEUTDEDW345
1748	34070093	Deutsche Bank Wermelskirche	DEUTDEDW346
1749	38470091	Deutsche Bank Gummersbach	DEUTDEDW384
1750	38470091	Deutsche Bank Bergneustadt	DEUTDEDW385
1751	38470091	Deutsche Bank Waldbröl	DEUTDEDW387
1752	38470091	Deutsche Bank Engelskirchen	DEUTDEDW388
1753	38470091	Deutsche Bank Meinerzhagen	DEUTDEDW389
1754	44570004	Deutsche Bank Werdohl	DEUTDEDW443
1755	44570004	Deutsche Bank Hemer	DEUTDEDW444
1756	44570004	Deutsche Bank Iserlohn	DEUTDEDW445
1757	44570004	Deutsche Bank Altena Westf	DEUTDEDW446
1758	44570004	Deutsche Bank Menden Sauerl	DEUTDEDW447
1759	44570004	Deutsche Bank Neuenrade	DEUTDEDW448
1760	44570004	Deutsche Bank Plettenberg	DEUTDEDW449
1761	45070002	Deutsche Bank Hagen	DEUTDEDW450
1762	45070002	Deutsche Bank Lüdenscheid	DEUTDEDW451
1763	45070002	Deutsche Bank Herdecke Ruhr	DEUTDEDW453
1764	45070002	Deutsche Bank Gevelsberg	DEUTDEDW454
1765	45070002	Deutsche Bank Kierspe	DEUTDEDW456
1766	46670007	Deutsche Bank Arnsberg	DEUTDEDW466
1767	46670007	Deutsche Bank Sundern Sauer	DEUTDEDW467
1768	46670007	Deutsche Bank Meschede	DEUTDEDW468
1769	33070090	Deutsche Bank Wuppertal	DEUTDEDWXXX
1770	50070010	Deutsche Bank Bad Homburg	DEUTDEFF500
1771	50073019	Deutsche Bank Rüsselsheim	DEUTDEFF502
1772	50070010	Deutsche Bank Friedbg Hess	DEUTDEFF503
1773	50070010	Deutsche Bank Oberursel	DEUTDEFF504
1774	50570018	Deutsche Bank Offenbach	DEUTDEFF505
1775	50670009	Deutsche Bank Hanau Main	DEUTDEFF506
1776	50570018	Deutsche Bank Neu-Isenburg	DEUTDEFF507
1777	50870005	Deutsche Bank Darmstadt	DEUTDEFF508
1778	50970004	Deutsche Bank Bensheim	DEUTDEFF509
1779	51070021	Deutsche Bank Wiesbaden	DEUTDEFF510
1780	51170010	Deutsche Bank Limburg Lahn	DEUTDEFF511
1781	51070021	Deutsche Bank Eltville	DEUTDEFF512
1782	51370008	Deutsche Bank Gießen	DEUTDEFF513
1783	51070021	Deutsche Bank Taunusstein	DEUTDEFF514
1784	51570008	Deutsche Bank Wetzlar	DEUTDEFF515
1785	50970004	Deutsche Bank Heppenheim	DEUTDEFF519
1786	52070012	Deutsche Bank Kassel	DEUTDEFF520
1787	52071212	Deutsche Bank Bad Wildungen	DEUTDEFF521
1788	52270012	Deutsche Bank Eschwege	DEUTDEFF522
1789	52070012	Deutsche Bank Baunatal	DEUTDEFF523
1790	52070012	Deutsche Bank Hann Münden	DEUTDEFF524
1791	53070007	Deutsche Bank Fulda	DEUTDEFF530
1792	53070007	Deutsche Bank Alsfeld	DEUTDEFF531
1793	53270012	Deutsche Bank Bad Hersfeld	DEUTDEFF532
1794	53370008	Deutsche Bank Marburg Lahn	DEUTDEFF533
1795	53070007	Deutsche Bank Lauterbach He	DEUTDEFF534
1796	50070010	Deutsche Bank Hofheim	DEUTDEFF540
1797	50070010	Deutsche Bank Königstein	DEUTDEFF541
1798	50070010	Deutsche Bank Kronberg	DEUTDEFF542
1799	50073019	Deutsche Bank Raunheim	DEUTDEFF543
1800	50570018	Deutsche Bank Dietzenbach	DEUTDEFF544
1801	50570018	Deutsche Bank Dreieich	DEUTDEFF545
1802	50570018	Deutsche Bank Heusenstamm	DEUTDEFF546
1803	50570018	Deutsche Bank Langen Hess	DEUTDEFF547
1804	50570018	Deutsche Bank Mühlheim Main	DEUTDEFF548
1805	50570018	Deutsche Bank Obertshausen	DEUTDEFF549
1806	50570018	Deutsche Bank Rodgau	DEUTDEFF550
1807	50870005	Deutsche Bank Griesheim Hes	DEUTDEFF551
1808	50870005	Deutsche Bank Groß-Gerau	DEUTDEFF552
1809	79570051	Deutsche Bank Aschaffenburg	DEUTDEFF795
1810	79570051	Deutsche Bank Miltenberg	DEUTDEFF796
1811	12070070	Deutsche Bank (Gf intern)	DEUTDEFFVAC
1812	50070010	Deutsche Bank Frankfurt F	DEUTDEFFXXX
1813	28070057	Deutsche Bank Oldenburg	DEUTDEHB280
1814	28070057	Deutsche Bank Bad Zwischena	DEUTDEHB281
1815	28270056	Deutsche Bank Wilhelmshaven	DEUTDEHB282
1816	28270056	Deutsche Bank Jever	DEUTDEHB283
1817	28470091	Deutsche Bank Emden	DEUTDEHB284
1818	28570092	Deutsche Bank Leer	DEUTDEHB285
1819	28470091	Deutsche Bank Norden	DEUTDEHB286
1820	28570092	Deutsche Bank Papenburg	DEUTDEHB287
1821	28570092	Deutsche Bank Weener	DEUTDEHB288
1822	28470091	Deutsche Bank Aurich	DEUTDEHB289
1823	29070059	Deutsche Bank Vechta	DEUTDEHB290
1824	29172655	Deutsche Bank Verden	DEUTDEHB291
1825	29070051	Deutsche Bank Bremerhaven	DEUTDEHB292
1826	29070058	Deutsche Bank Cloppenburg	DEUTDEHB293
1827	29070052	Deutsche Bank Delmenhorst	DEUTDEHB294
1828	29070050	Deutsche Bank Achim Bremen	DEUTDEHB295
1829	29070059	Deutsche Bank Lohne Oldenbg	DEUTDEHB296
1830	29070050	Deutsche Bank Osterholz-Sch	DEUTDEHB297
1831	28470091	Deutsche Bank Norderney	DEUTDEHB298
1832	29070050	Deutsche Bank Bremen	DEUTDEHBXXX
1833	20070000	Deutsche Bank Itzehoe	DEUTDEHH200
1834	20070000	Deutsche Bank Ahrensburg	DEUTDEHH201
1835	20070000	Deutsche Bank Norderstedt	DEUTDEHH202
1836	20070000	Deutsche Bank Lauenburg	DEUTDEHH203
1837	20070000	Deutsche Bank Wedel Holst	DEUTDEHH204
1838	20070000	Deutsche Bank Geesthacht	DEUTDEHH205
1839	20070000	Deutsche Bank Pinneberg	DEUTDEHH206
1840	20070000	Deutsche Bank Buchholz	DEUTDEHH207
1841	20070000	Deutsche Bank Stade	DEUTDEHH209
1842	21070020	Deutsche Bank Kiel	DEUTDEHH210
1843	20070000	Deutsche Bank Buxtehude	DEUTDEHH211
1844	21270020	Deutsche Bank Neumünster	DEUTDEHH212
1845	20070000	Deutsche Bank Reinbek	DEUTDEHH213
1846	21070020	Deutsche Bank Rendsburg	DEUTDEHH214
1847	21570011	Deutsche Bank Flensburg	DEUTDEHH215
1848	21570011	Deutsche Bank Westerland	DEUTDEHH216
1849	21770011	Deutsche Bank Husum Nordsee	DEUTDEHH217
1850	20070000	Deutsche Bank Brunsbüttel	DEUTDEHH219
1851	20070000	Deutsche Bank Elmshorn	DEUTDEHH221
1852	23070710	Deutsche Bank	DEUTDEHH222
1853	20070000	Deutsche Bank Cuxhaven	DEUTDEHH241
1854	20070000	Deutsche Bank Hamburg	DEUTDEHHXXX
1855	70070010	Deutsche Bank Bad Tölz	DEUTDEMM700
1856	70070010	Deutsche Bank Garmisch-Part	DEUTDEMM701
1857	70070010	Deutsche Bank Landsberg Lec	DEUTDEMM702
1858	70070010	Deutsche Bank Landshut	DEUTDEMM703
1859	70070010	Deutsche Bank Mühldorf Inn	DEUTDEMM704
1860	70070010	Deutsche Bank Rosenheim	DEUTDEMM705
1861	70070010	Deutsche Bank Dachau	DEUTDEMM706
1862	70070010	Deutsche Bank Freising	DEUTDEMM707
1863	70070010	Deutsche Bank Fürstenfeldb	DEUTDEMM708
1864	70070010	Deutsche Bank Starnberg	DEUTDEMM709
1865	70070010	Deutsche Bank Bad Reichenha	DEUTDEMM710
1866	70070010	Deutsche Bank Weilheim Obb	DEUTDEMM711
1867	70070010	Deutsche Bank Erding	DEUTDEMM712
1868	70070010	Deutsche Bank Germering	DEUTDEMM713
1869	70070010	Deutsche Bank Grünwald	DEUTDEMM714
1870	70070010	Deutsche Bank Ottobrunn	DEUTDEMM715
1871	70070010	Deutsche Bank Planegg	DEUTDEMM716
1872	70070010	Deutsche Bank Rottach-Egern	DEUTDEMM717
1873	72070001	Deutsche Bank Augsburg	DEUTDEMM720
1874	72170007	Deutsche Bank Ingolstadt	DEUTDEMM721
1875	72170007	Deutsche Bank Neuburg Donau	DEUTDEMM722
1876	72070001	Deutsche Bank Bad Wörishof	DEUTDEMM723
1877	72070001	Deutsche Bank Dillingen	DEUTDEMM724
1878	72070001	Deutsche Bank Gersthofen	DEUTDEMM725
1879	72070001	Deutsche Bank Günzburg	DEUTDEMM726
1880	72070001	Deutsche Bank Königsbrunn	DEUTDEMM727
1881	72170007	Deutsche Bank Pfaffenh Ilm	DEUTDEMM728
1882	72170007	Deutsche Bank Vohburg Donau	DEUTDEMM729
1883	73370008	Deutsche Bank Kempten Allga	DEUTDEMM733
1884	73370008	Deutsche Bank Memmingen	DEUTDEMM734
1885	73370008	Deutsche Bank Sonthofen	DEUTDEMM735
1886	73370008	Deutsche Bank Marktoberdorf	DEUTDEMM736
1887	73370008	Deutsche Bank Kaufbeuren	DEUTDEMM737
1888	75070013	Deutsche Bank Deggendorf	DEUTDEMM741
1889	75070013	Deutsche Bank Regensburg	DEUTDEMM750
1890	75070013	Deutsche Bank Straubing	DEUTDEMM751
1891	75070013	Deutsche Bank Passau	DEUTDEMM752
1892	76070012	Deutsche Bank Nürnberg	DEUTDEMM760
1893	76070012	Deutsche Bank Ansbach	DEUTDEMM761
1894	76070012	Deutsche Bank Bamberg	DEUTDEMM762
1895	76070012	Deutsche Bank Erlangen	DEUTDEMM763
1896	76070012	Deutsche Bank Fürth Bay	DEUTDEMM764
1897	76070012	Deutsche Bank Amberg Oberpf	DEUTDEMM765
1898	76070012	Deutsche Bank Weiden Oberpf	DEUTDEMM766
1899	76070012	Deutsche Bank Neumarkt Opf	DEUTDEMM767
1900	76070012	Deutsche Bank Forchheim Ofr	DEUTDEMM768
1901	76070012	Deutsche Bank Zirndorf	DEUTDEMM769
1902	76070012	Deutsche Bank Schwabach Mfr	DEUTDEMM771
1903	76070012	Deutsche Bank Lauf Pegnitz	DEUTDEMM772
1904	76070012	Deutsche Bank Bayreuth	DEUTDEMM773
1905	76070012	Deutsche Bank Kulmbach	DEUTDEMM774
1906	76070012	Deutsche Bank Coburg	DEUTDEMM783
1907	79070016	Deutsche Bank Würzburg	DEUTDEMM790
1908	79070016	Deutsche Bank Schweinfurt	DEUTDEMM791
1909	79070016	Deutsche Bank Bad Mergenthe	DEUTDEMM792
1910	70070010	Deutsche Bank München	DEUTDEMMXXX
1911	54070092	Deutsche Bank Kaiserslauter	DEUTDESM540
1912	54070092	Deutsche Bank Landstuhl	DEUTDESM541
1913	54270096	Deutsche Bank Pirmasens	DEUTDESM542
1914	54270096	Deutsche Bank Zweibrücken	DEUTDESM543
1915	54570094	Deutsche Bank Frankenthal	DEUTDESM544
1916	54570094	Deutsche Bank Ludwigshafen	DEUTDESM545
1917	54670095	Deutsche Bank Neustadt Wstr	DEUTDESM546
1918	54570094	Deutsche Bank Speyer	DEUTDESM547
1919	54670095	Deutsche Bank Landau Pfalz	DEUTDESM548
1920	54570094	Deutsche Bank Alzey	DEUTDESM549
1921	54570094	Deutsche Bank Limburgerhof	DEUTDESM550
1922	54670095	Deutsche Bank Bad Dürkheim	DEUTDESM552
1923	54570094	Deutsche Bank Worms	DEUTDESM553
1924	66070004	Deutsche Bank Karlsruhe	DEUTDESM660
1925	66070004	Deutsche Bank Bruchsal	DEUTDESM661
1926	66270001	Deutsche Bank Baden-Baden	DEUTDESM662
1927	66070004	Deutsche Bank Bretten Baden	DEUTDESM663
1928	66070004	Deutsche Bank Ettlingen	DEUTDESM664
1929	66270001	Deutsche Bank Rastatt	DEUTDESM665
1930	66670006	Deutsche Bank Pforzheim	DEUTDESM666
1931	66270001	Deutsche Bank Gernsbach	DEUTDESM667
1932	66270001	Deutsche Bank Bühl Baden	DEUTDESM669
1933	67070010	Deutsche Bank Weinheim Berg	DEUTDESM670
1934	66270001	Deutsche Bank Gaggenau	DEUTDESM671
1935	67270003	Deutsche Bank Heidelberg	DEUTDESM672
1936	67070010	Deutsche Bank Schwetzingen	DEUTDESM673
1937	67270003	Deutsche Bank Mosbach Baden	DEUTDESM674
1938	67070010	Deutsche Bank Viernheim	DEUTDESM675
1939	67070010	Deutsche Bank Hockenheim	DEUTDESM676
1940	66670006	Deutsche Bank Mühlacker	DEUTDESM677
1941	67270003	Deutsche Bank Wiesloch	DEUTDESM678
1942	67070010	Deutsche Bank Mannheim	DEUTDESMXXX
1943	60070070	Deutsche Bank Böblingen	DEUTDESS602
1944	65370075	Deutsche Bank Tuttlingen	DEUTDESS603
1945	60470082	Deutsche Bank Ludwigsburg	DEUTDESS604
1946	60070070	Deutsche Bank Sindelfingen	DEUTDESS605
1947	60270073	Deutsche Bank Waiblingen	DEUTDESS606
1948	60470082	Deutsche Bank Asperg	DEUTDESS608
1949	60070070	Deutsche Bank Leinfelden-Ec	DEUTDESS609
1950	61070078	Deutsche Bank Göppingen	DEUTDESS610
1951	61170076	Deutsche Bank Esslingen	DEUTDESS611
1952	61170076	Deutsche Bank Nürtingen	DEUTDESS612
1953	61370086	Deutsche Bank Schwäb Gmünd	DEUTDESS613
1954	61370086	Deutsche Bank Aalen Württ	DEUTDESS614
1955	61370086	Deutsche Bank Heidenheim Br	DEUTDESS615
1956	61370086	Deutsche Bank Schorndorf Wu	DEUTDESS616
1957	60470082	Deutsche Bank Kornwestheim	DEUTDESS617
1958	61070078	Deutsche Bank Geislingen St	DEUTDESS618
1959	61170076	Deutsche Bank Kirchheim Tec	DEUTDESS619
1960	62070081	Deutsche Bank Heilbronn	DEUTDESS620
1961	62070081	Deutsche Bank Neckarsulm	DEUTDESS621
1962	62070081	Deutsche Bank Schwäbisch H	DEUTDESS622
1963	60470082	Deutsche Bank Marbach Necka	DEUTDESS623
1964	60070070	Deutsche Bank Leonberg Wür	DEUTDESS624
1965	61170076	Deutsche Bank Plochingen	DEUTDESS626
1966	61070078	Deutsche Bank Eislingen Fil	DEUTDESS627
1967	62070081	Deutsche Bank Künzelsau	DEUTDESS628
1968	62070081	Deutsche Bank Öhringen	DEUTDESS629
1969	63070088	Deutsche Bank Ulm Donau	DEUTDESS630
1970	63070088	Deutsche Bank Biberach Riß	DEUTDESS631
1971	63070088	Deutsche Bank Neu-Ulm	DEUTDESS632
1972	61370086	Deutsche Bank Nördlingen	DEUTDESS633
1973	60470082	Deutsche Bank Bietigheim-Bi	DEUTDESS635
1974	61370086	Deutsche Bank Crailsheim	DEUTDESS637
1975	61370086	Deutsche Bank Ellwangen Jag	DEUTDESS638
1976	61370086	Deutsche Bank Giengen Brenz	DEUTDESS639
1977	64070085	Deutsche Bank Reutlingen	DEUTDESS640
1978	64070085	Deutsche Bank Tübingen	DEUTDESS641
1979	64070085	Deutsche Bank Metzingen Wü	DEUTDESS642
1980	64070085	Deutsche Bank Nagold	DEUTDESS643
1981	64070085	Deutsche Bank Pfullingen	DEUTDESS644
1982	64070085	Deutsche Bank Rottenburg Ne	DEUTDESS645
1983	64070085	Deutsche Bank Freudenstadt	DEUTDESS646
1984	60070070	Deutsche Bank Gerlingen Wü	DEUTDESS647
1985	60470082	Deutsche Bank Markgrönigen	DEUTDESS648
1986	65070084	Deutsche Bank Tettnang	DEUTDESS649
1987	65070084	Deutsche Bank Ravensburg	DEUTDESS650
1988	65070084	Deutsche Bank Friedrichshaf	DEUTDESS651
1989	65070084	Deutsche Bank Leutkirch	DEUTDESS652
1990	65370075	Deutsche Bank Albstadt	DEUTDESS653
1991	65070084	Deutsche Bank Lindau Bodens	DEUTDESS654
1992	65370075	Deutsche Bank Balingen	DEUTDESS655
1993	65070084	Deutsche Bank Wangen Allgäu	DEUTDESS657
1994	65070084	Deutsche Bank Weingarten Wu	DEUTDESS658
1995	60670070	Deutsche Bank Untertürkheim	DEUTDESS659
1996	60070070	Deutsche Bank Stuttgart	DEUTDESSXXX
1997	37013030	DPZ Bonn	DEZMDE31XXX
1998	29020400	Factoring Bank Bremen	DFABDE21XXX
1999	20090400	DG HYP Hamburg	DGHYDEH1XXX
2000	47260121	VB Paderborn-Höxter-Detmold	DGPBDE3MALT
2001	47260121	VB Paderborn-Höxter-Detmold	DGPBDE3MBRA
2002	47260121	VB Paderborn-Höxter-Detmold	DGPBDE3MBUR
2003	48021900	Bankv.Werther ZwNdl VB PHD	DGPBDE3MBVW
2004	47260121	VB Paderborn-Höxter-Detmold	DGPBDE3MDEL
2005	47260121	VB Paderborn-Höxter-Detmold	DGPBDE3MDRI
2006	47260121	VB Paderborn-Höxter-Detmold	DGPBDE3MDTM
2007	47260121	VB Paderborn-Höxter-Detmold	DGPBDE3MHBM
2008	47260121	VB Paderborn-Höxter-Detmold	DGPBDE3MHOV
2009	47260121	VB Paderborn-Höxter-Detmold	DGPBDE3MHOX
2010	47260121	VB Paderborn-Höxter-Detmold	DGPBDE3MLAG
2011	47260121	VB Paderborn-Höxter-Detmold	DGPBDE3MLEM
2012	47260121	VB Paderborn-Höxter-Detmold	DGPBDE3MLIP
2013	47260121	VB Paderborn-Höxter-Detmold	DGPBDE3MOER
2014	47260121	VB Paderborn-Höxter-Detmold	DGPBDE3MSAL
2015	47260121	VB Paderborn-Höxter-Detmold	DGPBDE3MSTE
2016	47260121	VB Paderborn-Höxter-Detmold	DGPBDE3MWAR
2017	47260121	VB Paderborn-Höxter-Detmold	DGPBDE3MXXX
2018	10050999	DekaBank Berlin	DGZFDEFFBER
2019	50050999	DekaBank Frankfurt	DGZFDEFFXXX
2020	30130100	Demir-Halk Bank Düsseldorf	DHBNDEDDXXX
2021	30130800	Düsseldorfer Hypothekenbank	DHYPDEDDXXX
2022	50250200	DL Finance Bad Homburg	DLFGDE51XXX
2023	10030700	Eurocity Bank	DLGHDEB1XXX
2024	20220100	DNB Bank	DNBADEHXXXX
2025	50123400	VTB Direktbank	DOBADEF1XXX
2026	44050199	Sparkasse Dortmund	DORTDE33XXX
2027	20120400	Deutscher Ring Bspk Hamburg	DRBKDEH1XXX
2028	10080000	Commerzbank Fil I Berlin	DRESDEFF100
2029	10080055	Commerzbank Zw 55 Berlin	DRESDEFF112
2030	10080057	Commerzbk ZW 57 Berlin	DRESDEFF114
2031	12080000	Commerzbank Fil II Berlin	DRESDEFF120
2032	13080000	Commerzbank Rostock	DRESDEFF130
2033	14080000	Commerzbank Schwerin	DRESDEFF140
2034	15080000	Commerzbank Neubrandenbg	DRESDEFF150
2035	16080000	Commerzbank Potsdam	DRESDEFF160
2036	17080000	Commerzbank Frankfurt, O	DRESDEFF170
2037	18080000	Commerzbank Cottbus	DRESDEFF180
2038	10080900	Commerzbk Fil III Berlin	DRESDEFF199
2039	20080000	Commerzbank Hamburg	DRESDEFF200
2040	22280000	Commerzbank Itzehoe	DRESDEFF201
2041	22181400	Commerzbank Pinneberg	DRESDEFF206
2042	20080055	Commerzbank Zw 55 Hamburg	DRESDEFF207
2043	20080057	Commerzbk ZW 57 Hamburg	DRESDEFF208
2044	21080050	Commerzbank Kiel	DRESDEFF210
2045	21280002	Commerzbank Neumünster	DRESDEFF212
2046	21480003	Commerzbank Rendsburg	DRESDEFF214
2047	21580000	Commerzbank Flensburg	DRESDEFF215
2048	22180000	Commerzbank Elmshorn	DRESDEFF221
2049	23080040	Commerzbank Lübeck	DRESDEFF230
2050	24080000	Commerzbank Lüneburg	DRESDEFF240
2051	24180001	Commerzbank Cuxhaven	DRESDEFF241
2052	24180000	Commerzbank Otterndorf	DRESDEFF242
2053	25080020	Commerzbank Hannover	DRESDEFF250
2054	25480021	Commerzbank Hameln	DRESDEFF254
2055	25780022	Commerzbank Celle	DRESDEFF257
2056	25980027	Commerzbank Hildesheim	DRESDEFF259
2057	26080024	Commerzbank Göttingen	DRESDEFF260
2058	26280020	Commerzbank Northeim Han	DRESDEFF261
2059	26281420	Commerzbank Einbeck	DRESDEFF262
2060	26580070	Commerzbank Osnabrück	DRESDEFF265
2061	26880063	Commerzbank Goslar	DRESDEFF268
2062	26981062	Commerzbank Wolfsburg	DRESDEFF269
2063	27080060	Commerzbank Braunschweig	DRESDEFF270
2064	28280012	Commerzbank Wilhelmshaven	DRESDEFF282
2065	29080010	Commerzbank Bremen	DRESDEFF290
2066	29280011	Commerzbank Bremerhaven	DRESDEFF292
2067	30080000	Commerzbank Düsseldorf	DRESDEFF300
2068	30080055	Commerzbk Zw55 Düsseldorf	DRESDEFF309
2069	31080015	Commerzbank Mönchengladb	DRESDEFF310
2070	30080057	Commerzbk ZW57 Düsseldorf	DRESDEFF316
2071	32080010	Commerzbank Krefeld	DRESDEFF320
2072	33080030	Commerzbank Wuppertal	DRESDEFF332
2073	34080031	Commerzbank Remscheid	DRESDEFF340
2074	34280032	Commerzbank Solingen	DRESDEFF342
2075	35080070	Commerzbank Duisburg	DRESDEFF350
2076	36080080	Commerzbank Essen	DRESDEFF360
2077	36280071	Commerzbank Mülheim Ruhr	DRESDEFF362
2078	36580072	Commerzbank Oberhausen	DRESDEFF365
2079	37080040	Commerzbank Köln	DRESDEFF370
2080	38080055	Commerzbank Bonn	DRESDEFF380
2081	39080005	Commerzbank Aachen	DRESDEFF390
2082	39580041	Commerzbank Düren	DRESDEFF395
2083	40080040	Commerzbank Münster	DRESDEFF400
2084	41280043	Commerzbank Beckum Westf	DRESDEFF413
2085	42080082	Commerzbank Gelsenkirchen	DRESDEFF420
2086	42680081	Commerzbank Recklinghsn	DRESDEFF426
2087	43080083	Commerzbank Bochum	DRESDEFF430
2088	44080050	Commerzbank Dortmund	DRESDEFF440
2089	44580070	Commerzbank Iserlohn	DRESDEFF445
2090	44080055	Commerzbk Zw55 Dortmund	DRESDEFF446
2091	44080057	Commerzbk ZW 57 Dortmund	DRESDEFF447
2092	45080060	Commerzbank Hagen	DRESDEFF450
2093	46080010	Commerzbank Siegen	DRESDEFF460
2094	47880031	Commerzbank Gütersloh	DRESDEFF478
2095	48080020	Commerzbank Bielefeld	DRESDEFF480
2096	49080025	Commerzbank Minden Westf	DRESDEFF491
2097	50080300	Commerzbank Priv Banking	DRESDEFF500
2098	50083007	Commerzbank Rüsselsheim	DRESDEFF502
2099	50580005	Commerzbank Offenbach	DRESDEFF505
2100	50680002	Commerzbank Hanau Main	DRESDEFF506
2101	50880050	Commerzbank Darmstadt	DRESDEFF508
2102	51080060	Commerzbank Wiesbaden	DRESDEFF510
2103	51180041	Commerzbank Limburg Lahn	DRESDEFF511
2104	51380040	Commerzbank Gießen	DRESDEFF513
2105	51580044	Commerzbank Wetzlar	DRESDEFF515
2106	50080055	Commerzbk Zw 55 Frankfurt	DRESDEFF516
2107	52080080	Commerzbank Kassel	DRESDEFF520
2108	50080057	Commerzbk ZW 57 Frankfurt	DRESDEFF522
2109	50780006	Commerzbank Gelnhausen	DRESDEFF524
2110	53080030	Commerzbank Fulda	DRESDEFF530
2111	53280081	Commerzbank Bad Hersfeld	DRESDEFF532
2112	53380042	Commerzbank Marburg Lahn	DRESDEFF533
2113	54080021	Commerzbk Kaiserslautern	DRESDEFF540
2114	54280023	Commerzbank Pirmasens	DRESDEFF542
2115	54580020	Commerzbank Ludwigshafen	DRESDEFF545
2116	54680022	Commerzbank Neustadt	DRESDEFF546
2117	55080065	Commerzbank Mainz	DRESDEFF550
2118	55080088	CommerzBk TF MZ 2, Mainz	DRESDEFF555
2119	53381843	Commerzbank Stadtallendf	DRESDEFF568
2120	57080070	Commerzbank Koblenz	DRESDEFF570
2121	58580074	Commerzbank Trier	DRESDEFF585
2122	59080090	Commerzbank Saarbrücken	DRESDEFF590
2123	60080000	Commerzbank Stuttgart	DRESDEFF600
2124	60380002	Commerzbank Böblingen	DRESDEFF601
2125	60480008	Commerzbank Ludwigsburg	DRESDEFF604
2126	60080055	Commerzbk Zw 55 Stuttgart	DRESDEFF608
2127	60080057	Commerzbk Zw 57 Stuttgart	DRESDEFF609
2128	61080006	Commerzbank Göppingen	DRESDEFF610
2129	61180004	Commerzbank Esslingen	DRESDEFF611
2130	61281007	Commerzbank Kirchheim	DRESDEFF612
2131	61480001	Commerzbank Aalen Württ	DRESDEFF614
2132	62080012	Commerzbank Heilbronn	DRESDEFF620
2133	62280012	Commerzbank Schwäb Hall	DRESDEFF622
2134	63080015	Commerzbank Ulm Donau	DRESDEFF630
2135	64080014	Commerzbank Reutlingen	DRESDEFF640
2136	64180014	Commerzbank Tübingen	DRESDEFF641
2137	64380011	Commerzbank Tuttlingen	DRESDEFF643
2138	65080009	Commerzbank Ravensburg	DRESDEFF650
2139	65180005	Commerzbank Friedrichshfn	DRESDEFF651
2140	65380003	Commerzbank Albstadt	DRESDEFF653
2141	66080052	Commerzbank Karlsruhe	DRESDEFF660
2142	66280053	Commerzbank Baden-Baden	DRESDEFF662
2143	66680013	Commerzbank Pforzheim	DRESDEFF666
2144	67080050	Commerzbank Mannheim	DRESDEFF670
2145	67280051	Commerzbank Heidelberg	DRESDEFF672
2146	68080030	Commerzbank Freiburg	DRESDEFF680
2147	69280035	Commerzbank Singen	DRESDEFF692
2148	70080000	Commerzbank München	DRESDEFF700
2149	70380006	Commerzbank Garmisch-Par	DRESDEFF703
2150	71180005	Commerzbank Rosenheim	DRESDEFF711
2151	70080056	Commerzbank Zw 56	DRESDEFF714
2152	72080001	Commerzbank Augsburg	DRESDEFF720
2153	72180002	Commerzbank Ingolstadt	DRESDEFF721
2154	70080057	Commerzbk ZW 57 München	DRESDEFF724
2155	73180011	Commerzbank Memmingen	DRESDEFF731
2156	73380004	Commerzbank Kempten	DRESDEFF733
2157	73480013	Commerzbank Kaufbeuren	DRESDEFF734
2158	74180009	Commerzbank Deggendorf	DRESDEFF741
2159	74380007	Commerzbank Landshut	DRESDEFF743
2160	75080003	Commerzbank Regensburg	DRESDEFF750
2161	76080040	Commerzbank Nürnberg	DRESDEFF760
2162	79080052	Commerzbank Würzburg	DRESDEFF790
2163	79380051	Commerzbank Schweinfurt	DRESDEFF793
2164	79580099	Commerzbank Aschaffenburg	DRESDEFF795
2165	80080000	Commerzbank Halle	DRESDEFF800
2166	81080000	Commerzbank Magdeburg	DRESDEFF810
2167	82080000	Commerzbank Weimar	DRESDEFF827
2168	83080000	Commerzbank Gera	DRESDEFF830
2169	84080000	Commerzbank Meiningen	DRESDEFF843
2170	85080000	Commerzbank Dresden	DRESDEFF850
2171	85080200	Commerzbank Hoyerswerda	DRESDEFF857
2172	86080000	Commerzbank Leipzig	DRESDEFF860
2173	86080055	Commerzbank Zw 55 Leipzig	DRESDEFF862
2174	86080057	Commerzbank ZW 57 Leipzig	DRESDEFF867
2175	87080000	Commerzbank Chemnitz	DRESDEFF870
2176	76080053	Commerzbank Zw 53	DRESDEFFAGI
2177	50080082	Commerzbk Gf AVB Ffm	DRESDEFFAVB
2178	70220900	Wüstenrot Bausparkasse	DRESDEFFBFC
2179	50080077	Commerzbk WBSPK, Frankfurt	DRESDEFFBSP
2180	50080092	Commerzbk FCO Frankfurt	DRESDEFFFCO
2181	50089400	Commerzbank Ffm ITGK	DRESDEFFI01
2182	30089300	Commerzbk ITGK I Düsseldf	DRESDEFFI02
2183	30089302	Commerzbk ITGK II Düsseld	DRESDEFFI03
2184	37089340	Commerzbank ITGK I Köln	DRESDEFFI04
2185	37089342	Commerzbank ITGK II Köln	DRESDEFFI05
2186	20089200	Commerzbank ITGK Hamburg	DRESDEFFI06
2187	21089201	Commerzbank ITGK Kiel	DRESDEFFI07
2188	23089201	Commerzbank ITGK Lübeck	DRESDEFFI08
2189	25089220	Commerzbank ITGK Hannover	DRESDEFFI09
2190	26589210	Commerzbk ITGK Osnabrück	DRESDEFFI10
2191	26989221	Commerzbk ITGK Wolfsburg	DRESDEFFI11
2192	27089221	Commerzbk ITGK Braunschwg	DRESDEFFI12
2193	29089210	Commerzbank ITGK Bremen	DRESDEFFI13
2194	10089260	Commerzbank ITGK Berlin	DRESDEFFI14
2195	85089270	Commerzbank ITGK Dresden	DRESDEFFI15
2196	86089280	Commerzbank ITGK Leipzig	DRESDEFFI16
2197	36089321	Commerzbank ITGK Essen	DRESDEFFI17
2198	44089320	Commerzbank ITGK Dortmund	DRESDEFFI18
2199	48089350	Commerzbk ITGK Bielefeld	DRESDEFFI19
2200	51089410	Commerzbank Wiesbad. ITGK	DRESDEFFI20
2201	60089450	Commerzbank ITGK Stgt	DRESDEFFI21
2202	67089440	Commerzbank ITGK Mannheim	DRESDEFFI22
2203	70089470	Commerzbank ITGK München	DRESDEFFI23
2204	76089480	Commerzbank ITGK Nürnberg	DRESDEFFI24
2205	76080055	Commerzbank Zw 55	DRESDEFFI25
2206	10080005	Commerzbank Berlin Zw A	DRESDEFFI26
2207	14080011	Commerzbank Schwerin Zw W	DRESDEFFI27
2208	30080022	Commerzbank Düsseldorf 22	DRESDEFFI28
2209	30080041	Commerzbank Düsseldorf 41	DRESDEFFI29
2210	30080053	Commerzbank Düsseldorf 53	DRESDEFFI30
2211	30080061	Commerzbank Düsseldorf 61	DRESDEFFI31
2212	30080074	Commerzbank Düsseldorf 74	DRESDEFFI32
2213	30080095	Commerzbank Düsseldorf 95	DRESDEFFI33
2214	31080061	Commerzbank Mgladbach 61	DRESDEFFI34
2215	37080099	Commerzbank Zw 99 Köln	DRESDEFFI36
2216	39080098	Commerzbank Zw 98 Aachen	DRESDEFFI37
2217	39080099	Commerzbank Zw 99 Aachen	DRESDEFFI38
2218	50080015	Commerzbank Zw 15 Ffm	DRESDEFFI39
2219	50080035	Commerzbank Zw 35 Ffm	DRESDEFFI40
2220	50080080	Commerzbank Bs 80 Ffm	DRESDEFFI41
2221	50080099	Commerzbk Zw 99 Frankfurt	DRESDEFFI42
2222	68080031	Commerzbank Zw Ms Freibg	DRESDEFFI44
2223	70089472	Commerzbank ITGK München2	DRESDEFFI45
2224	76089482	Commerzbank ITGK Nürnb. 2	DRESDEFFI46
2225	79589402	Commerzbank ITGK Aschaff.	DRESDEFFI47
2226	50080086	Commerzbk ITGK Frankfurt	DRESDEFFI49
2227	60080085	Commerzbk ITGK Stuttgart	DRESDEFFI50
2228	37080085	Commerzbank ITKG1 Köln	DRESDEFFI51
2229	10080085	Commerzbank ITKG3 Berlin	DRESDEFFI53
2230	60080086	Commerzbank ITKG3 Stutt.	DRESDEFFI54
2231	70080085	Commerzbank ITKG3 München	DRESDEFFI55
2232	20080085	Commerzbank ITKG2 Hamburg	DRESDEFFI56
2233	60080087	Commerzbank ITGK4 Sttgrt	DRESDEFFI57
2234	60080088	Commerzbank ITGK5 Sttgrt	DRESDEFFI58
2235	63080085	Commerzbank ITGK1 Ulm	DRESDEFFI59
2236	67080085	Commerzbank ITGK2 Mannh	DRESDEFFI60
2237	67080086	Commerzbank ITGK3 Mannh	DRESDEFFI61
2238	68080085	Commerzbank ITGK1 Freibrg	DRESDEFFI62
2239	20080086	Commerzbank ITGK 3	DRESDEFFI63
2240	20080087	Commerzbank ITGK4 Hamburg	DRESDEFFI64
2241	25080085	Commerzbank ITGK2 Hannov	DRESDEFFI65
2242	36080085	Commerzbank ITGK2 Essen	DRESDEFFI66
2243	37080086	Commerzbank ITGK4 Köln	DRESDEFFI67
2244	40080085	Commerzbank ITGK1 Münster	DRESDEFFI68
2245	44080085	Commerzbank ITGK2 Dortmnd	DRESDEFFI69
2246	44580085	Commerzbank ITGK1 Iserlhn	DRESDEFFI70
2247	10080086	Commerzbank ITGK4 Berlin	DRESDEFFI71
2248	10080087	Commerzbank ITGK5 Berlin	DRESDEFFI72
2249	10080089	Commerzbank ITGK6 Berlin	DRESDEFFI73
2250	20080088	Commerzbank ITGK5 Hamburg	DRESDEFFI74
2251	20080089	Commerzbank ITGK6 Hamburg	DRESDEFFI75
2252	30080080	Commerzbank ITGK3 Ddrf.	DRESDEFFI76
2253	30080081	Commerzbank ITGK4 Ddrf.	DRESDEFFI77
2254	30080082	Commerzbank ITGK5 Ddrf.	DRESDEFFI78
2255	30080083	Commerzbank ITGK6 Ddrf.	DRESDEFFI79
2256	30080084	Commerzbank ITGK7 Ddrf.	DRESDEFFI80
2257	30080085	Commerzbank ITGK8 Ddrf.	DRESDEFFI81
2258	30080086	Commerzbank ITGK9 Ddrf.	DRESDEFFI82
2259	30080087	Commerzbank ITGK10 Ddrf.	DRESDEFFI83
2260	30080088	Commerzbank ITGK11 Ddrf.	DRESDEFFI84
2261	30080089	Commerzbank ITGK12 Ddrf.	DRESDEFFI85
2262	33080001	Commerzbank ITGK1 Wupptl.	DRESDEFFI86
2263	33080085	Commerzbank ITGK2 Wupptl.	DRESDEFFI87
2264	33080086	Commerzbank ITGK3 Wupptl.	DRESDEFFI88
2265	33080087	Commerzbank ITGK4 Wupptl.	DRESDEFFI89
2266	33080088	Commerzbank ITGK5 Wupptl.	DRESDEFFI90
2267	35080085	Commerzbank ITGK1 Duisb.	DRESDEFFI91
2268	35080086	Commerzbank ITGK2 Duisb.	DRESDEFFI92
2269	35080087	Commerzbank ITGK3 Duisb.	DRESDEFFI93
2270	35080088	Commerzbank ITGK4 Duisb.	DRESDEFFI94
2271	35080089	Commerzbank ITGK5 Duisb.	DRESDEFFI95
2272	37080087	Commerzbank ITGK5 Köln	DRESDEFFI96
2273	37080088	Commerzbank ITGK6 Köln	DRESDEFFI97
2274	37080089	Commerzbank ITGK7 Köln	DRESDEFFI98
2275	10089999	Commerzbank ITGK 2 Berlin	DRESDEFFI99
2276	37080090	Commerzbank ITGK8 Köln	DRESDEFFJ01
2277	37080091	Commerzbank ITGK9 Köln	DRESDEFFJ02
2278	37080092	Commerzbank ITGK10 Köln	DRESDEFFJ03
2279	37080093	Commerzbank ITGK11 Köln	DRESDEFFJ04
2280	37080094	Commerzbank ITGK12 Köln	DRESDEFFJ05
2281	37080095	Commerzbank ITGK13 Köln	DRESDEFFJ06
2282	37080098	Commerzbank ITGK14 Köln	DRESDEFFJ07
2283	50080087	Commerzbank ITGK4 FFM	DRESDEFFJ08
2284	50080088	Commerzbank ITGK5 FFM	DRESDEFFJ09
2285	50080089	Commerzbank ITGK6 FFM	DRESDEFFJ10
2286	50080091	Commerzbank ITGK7 FFM	DRESDEFFJ11
2287	50580085	Commerzbank ITGK1 Offenbc	DRESDEFFJ12
2288	50680085	Commerzbank ITGK1 Hanau	DRESDEFFJ13
2289	50880085	Commerzbank ITGK1 Darmstd	DRESDEFFJ14
2290	50880086	Commerzbank ITGK2 Darmstd	DRESDEFFJ15
2291	51080085	Commerzbank ITGK1 Wiesbdn	DRESDEFFJ16
2292	51080086	Commerzbank ITGK2 Wiesbdn	DRESDEFFJ17
2293	51380085	Commerzbank ITGK1 Gießen	DRESDEFFJ18
2294	52080085	Commerzbank ITGK1 Kassel	DRESDEFFJ19
2295	55080085	Commerzbank ITGK1 Mainz	DRESDEFFJ20
2296	55080086	Commerzbank ITGK2 Mainz	DRESDEFFJ21
2297	68080086	Commerzbank ITGK2 Freibrg	DRESDEFFJ22
2298	70080086	Commerzbank ITGK4 München	DRESDEFFJ23
2299	70080087	Commerzbank ITGK5 München	DRESDEFFJ24
2300	70080088	Commerzbank ITGK6 München	DRESDEFFJ25
2301	76080085	Commerzbank ITGK1 Nürnbrg	DRESDEFFJ26
2302	76080086	Commerzbank ITGK2 Nürnbrg	DRESDEFFJ27
2303	79080085	Commerzbank ITGK1 Würzbrg	DRESDEFFJ28
2304	85080085	Commerzbank ITGK1 Dresden	DRESDEFFJ29
2305	85080086	Commerzbank ITGK2 Dresden	DRESDEFFJ30
2306	86080085	Commerzbank ITGK1 Leipzig	DRESDEFFJ31
2307	86080086	Commerzbank ITGK2 Leipzig	DRESDEFFJ32
2308	20080091	Commerzbank ITGK 7	DRESDEFFJ33
2309	20080092	Commerzbank ITGK 8	DRESDEFFJ34
2310	20080093	Commerzbank ITGK 9	DRESDEFFJ35
2311	20080094	Commerzbank ITGK 10	DRESDEFFJ36
2312	20080095	Commerzbank ITGK 11	DRESDEFFJ37
2313	50080061	Commerzbank Gf DrKWSL Ffm	DRESDEFFLDG
2314	50083838	Commerzbank Ffm MBP	DRESDEFFMBP
2315	10080006	Commerzbank Berlin Zw B	DRESDEFFXXX
2316	10080088	Commerzbank IBLZ Berlin	DRESDEFFXXX
2317	30080005	Commerzbank Düsseldorf 05	DRESDEFFXXX
2318	30080038	Commerzbank Düsseldorf 38	DRESDEFFXXX
2319	37080096	Commerzbank Zw 96 Köln	DRESDEFFXXX
2320	37080097	Commerzbank Zw 97 Köln	DRESDEFFXXX
2321	50080000	Commerzbank Frankfurt	DRESDEFFXXX
2322	50080025	Commerzbank Zw 25 Ffm	DRESDEFFXXX
2323	50080060	Commerzbank Gf DrKW Ffm	DRESDEFFXXX
2324	50080079	Commerzbank ESOP, Frankfurt	DRESDEFFXXX
2325	38010999	KfW Ausbildungsförderung	DTABDED1AUS
2326	38010900	KfW Bonn	DTABDED1XXX
2327	35050000	Spk Duisburg	DUISDE33XXX
2328	30050110	St Spk Düsseldorf	DUSSDEDDXXX
2329	50110300	DVB Frankfurt Main	DVKBDEFFXXX
2330	50030600	dwpbank	DWPBDEFFXXX
2331	10019610	Dexia Berlin	DXIADEBBXXX
2332	50691300	DZB BANK Mainhausen	DZBMDEF1XXX
2333	27020004	AutoEuropa Bank	ECBKDE21XXX
2334	20090745	EBANK Gf Cash Hamburg	EDECDEH1XXX
2335	20090700	Edekabank Hamburg	EDEKDEHHXXX
2336	70013010	Ebase Aschheim	EFSGDEM1XXX
2337	50210300	Hypothekenbank Frankfurt	EHYPDEFFXXX
2338	52060400	Ev Kreditgenossen Gf Kassel	EKKBDE52XXX
2339	60030200	Ellwabank Stuttgart	ELGEDES1XXX
2340	50210600	equinet Bank, Frankfurt	EQUNDEFFXXX
2341	82064228	Erfurter Bank	ERFBDE8EXXX
2342	50030700	DenizBank Frankfurt	ESBKDEFFXXX
2343	50210111	SEB TZN Clearing Ffm	ESSEDE51SCH
2344	50210112	SEB TZN MB Frankfurt	ESSEDE51TZN
2345	10010111	SEB Berlin	ESSEDE5F100
2346	13010111	SEB Rostock	ESSEDE5F130
2347	13010111	SEB Schwerin	ESSEDE5F131
2348	13010111	SEB Wismar	ESSEDE5F132
2349	16010111	SEB Potsdam	ESSEDE5F160
2350	16010111	SEB Cottbus	ESSEDE5F161
2351	20010111	SEB Hamburg	ESSEDE5F200
2352	20010111	SEB Norderstedt	ESSEDE5F201
2353	21010111	SEB Kiel	ESSEDE5F210
2354	21210111	SEB Neumünster	ESSEDE5F212
2355	23010111	SEB Lübeck	ESSEDE5F230
2356	23010111	SEB Bad Schwartau	ESSEDE5F231
2357	25010111	SEB Hannover	ESSEDE5F250
2358	25010111	SEB Laatzen	ESSEDE5F251
2359	25410111	SEB Hameln	ESSEDE5F254
2360	25910111	SEB Hildesheim	ESSEDE5F259
2361	26010111	SEB Göttingen	ESSEDE5F260
2362	26510111	SEB Osnabrück	ESSEDE5F265
2363	27010111	SEB Braunschweig	ESSEDE5F270
2364	27010111	SEB Salzgitter	ESSEDE5F271
2365	27010111	SEB Wolfsburg	ESSEDE5F272
2366	28010111	SEB Oldenburg	ESSEDE5F280
2367	28010111	SEB Emden	ESSEDE5F281
2368	28010111	SEB Wilhelmshaven	ESSEDE5F282
2369	29010111	SEB Bremen	ESSEDE5F290
2370	29210111	SEB Bremerhaven	ESSEDE5F292
2371	30010111	SEB Düsseldorf	ESSEDE5F300
2372	30010111	SEB Krefeld	ESSEDE5F301
2373	30010111	SEB Langenfeld Rhld	ESSEDE5F302
2374	30010111	SEB Neuss	ESSEDE5F303
2375	30010111	SEB Ratingen	ESSEDE5F304
2376	31010111	SEB Mönchengladbach	ESSEDE5F310
2377	33010111	SEB Wuppertal	ESSEDE5F330
2378	33010111	SEB Remscheid	ESSEDE5F331
2379	33010111	SEB Solingen	ESSEDE5F332
2380	35010111	SEB Duisburg	ESSEDE5F350
2381	35010111	SEB Bocholt	ESSEDE5F351
2382	35211012	SEB Dinslaken	ESSEDE5F352
2383	35010111	SEB Moers	ESSEDE5F353
2384	36010111	SEB Essen	ESSEDE5F360
2385	36010111	SEB Oberhausen	ESSEDE5F361
2386	36210111	SEB Mülheim Ruhr	ESSEDE5F362
2387	37010111	SEB Köln	ESSEDE5F370
2388	37010111	SEB Brühl Rheinl	ESSEDE5F371
2389	37010111	SEB Leverkusen	ESSEDE5F372
2390	38010111	SEB Bonn	ESSEDE5F380
2391	39010111	SEB Aachen	ESSEDE5F390
2392	39010111	SEB Düren	ESSEDE5F391
2393	40010111	SEB Münster Westf	ESSEDE5F400
2394	41010111	SEB Hamm Westf	ESSEDE5F410
2395	41010111	SEB Bergkamen	ESSEDE5F411
2396	42010111	SEB Gelsenkirchen	ESSEDE5F420
2397	42610112	SEB Recklinghausen	ESSEDE5F426
2398	42610112	SEB Marl Westf	ESSEDE5F427
2399	43010111	SEB Bochum	ESSEDE5F430
2400	43010111	SEB Castrop-Rauxel	ESSEDE5F431
2401	43010111	SEB Hagen	ESSEDE5F433
2402	43010111	SEB Herne	ESSEDE5F434
2403	67010111	SEB Ludwigshafen Rhein	ESSEDE5F435
2404	43010111	SEB Witten	ESSEDE5F436
2405	43010111	SEB Lüdenscheid	ESSEDE5F437
2406	44010111	SEB Dortmund	ESSEDE5F440
2407	44010111	SEB Lünen	ESSEDE5F441
2408	46010111	SEB Siegen	ESSEDE5F460
2409	48010111	SEB Bielefeld	ESSEDE5F480
2410	48010111	SEB Gütersloh	ESSEDE5F481
2411	48010111	SEB Herford	ESSEDE5F482
2412	48010111	SEB Minden Westf	ESSEDE5F483
2413	50010111	SEB Bad Homburg	ESSEDE5F501
2414	50010111	SEB Neu Isenburg	ESSEDE5F502
2415	50010111	SEB Rüsselsheim	ESSEDE5F503
2416	50010111	SEB Sulzbach Taunus	ESSEDE5F504
2417	50510111	SEB Offenbach Main	ESSEDE5F505
2418	50510111	SEB Darmstadt	ESSEDE5F506
2419	50510111	SEB Heusenstamm	ESSEDE5F507
2420	50510111	SEB Hanau	ESSEDE5F508
2421	51010111	SEB Wiesbaden	ESSEDE5F510
2422	51220211	SEB Ffm SAP	ESSEDE5F512
2423	51310111	SEB Gießen	ESSEDE5F513
2424	51410111	SEB Frankfurt am Main	ESSEDE5F514
2425	51310111	SEB Wetzlar	ESSEDE5F515
2426	52010111	SEB Kassel	ESSEDE5F520
2427	54210111	SEB Pirmasens	ESSEDE5F542
2428	55010111	SEB Mainz	ESSEDE5F550
2429	55010111	SEB Kaiserslautern	ESSEDE5F551
2430	57010111	SEB Koblenz	ESSEDE5F570
2431	57010111	SEB Neuwied	ESSEDE5F572
2432	58510111	SEB Trier	ESSEDE5F585
2433	59010111	SEB Saarbrücken	ESSEDE5F590
2434	60010111	SEB Stuttgart	ESSEDE5F600
2435	60010111	SEB Esslingen Neckar	ESSEDE5F601
2436	60010111	SEB Sindelfingen	ESSEDE5F602
2437	63010111	SEB Ulm Donau	ESSEDE5F630
2438	63010111	SEB Friedrichshafen	ESSEDE5F631
2439	63010111	SEB Göppingen	ESSEDE5F632
2440	65310111	SEB Albstadt	ESSEDE5F653
2441	65310111	SEB Reutlingen	ESSEDE5F654
2442	65310111	SEB Villing-Schwenningen	ESSEDE5F655
2443	66010111	SEB Karlsruhe	ESSEDE5F660
2444	66010111	SEB Offenburg	ESSEDE5F661
2445	66610111	SEB Pforzheim	ESSEDE5F666
2446	67010111	SEB Mannheim	ESSEDE5F670
2447	67210111	SEB Heidelberg	ESSEDE5F672
2448	67210111	SEB Heilbronn Neckar	ESSEDE5F673
2449	67010111	SEB Worms	ESSEDE5F675
2450	68010111	SEB Freiburg Breisgau	ESSEDE5F680
2451	68310111	SEB Lörrach	ESSEDE5F683
2452	69010111	SEB Konstanz	ESSEDE5F690
2453	70010111	SEB München	ESSEDE5F700
2454	70010111	SEB Geretsried	ESSEDE5F701
2455	70010111	SEB Ingolstadt Donau	ESSEDE5F702
2456	72010111	SEB Augsburg	ESSEDE5F720
2457	72010111	SEB Kempten	ESSEDE5F721
2458	75010111	SEB Regensburg	ESSEDE5F750
2459	76010111	SEB Nürnberg	ESSEDE5F760
2460	79010111	SEB Würzburg	ESSEDE5F790
2461	79010111	SEB Schweinfurt	ESSEDE5F791
2462	79510111	SEB Aschaffenburg	ESSEDE5F795
2463	81010111	SEB Magdeburg	ESSEDE5F810
2464	82010111	SEB Erfurt	ESSEDE5F820
2465	86010111	SEB Leipzig	ESSEDE5F860
2466	86010111	SEB Chemnitz	ESSEDE5F861
2467	86010111	SEB Dresden	ESSEDE5F862
2468	86010111	SEB Zwickau	ESSEDE5F863
2469	81010111	SEB Halle	ESSEDE5F864
2470	50010111	SEB Frankfurt Main	ESSEDE5FXXX
2471	50210130	SEB TZN MB	ESSEDE5FXXX
2472	50210131	SEB TZN MB	ESSEDE5FXXX
2473	50210132	SEB TZN MB	ESSEDE5FXXX
2474	50210133	SEB TZN MB	ESSEDE5FXXX
2475	50210134	SEB TZN MB	ESSEDE5FXXX
2476	50210135	SEB TZN MB	ESSEDE5FXXX
2477	50210136	SEB TZN MB	ESSEDE5FXXX
2478	50210137	SEB TZN MB	ESSEDE5FXXX
2479	50210138	SEB TZN MB	ESSEDE5FXXX
2480	50210139	SEB TZN MB	ESSEDE5FXXX
2481	50210140	SEB TZN MB	ESSEDE5FXXX
2482	50210141	SEB TZN MB	ESSEDE5FXXX
2483	50210142	SEB TZN MB	ESSEDE5FXXX
2484	50210143	SEB TZN MB	ESSEDE5FXXX
2485	50210144	SEB TZN MB	ESSEDE5FXXX
2486	50210145	SEB TZN MB	ESSEDE5FXXX
2487	50210146	SEB TZN MB	ESSEDE5FXXX
2488	50210147	SEB TZN MB	ESSEDE5FXXX
2489	50210148	SEB TZN MB	ESSEDE5FXXX
2490	50210149	SEB TZN MB	ESSEDE5FXXX
2491	50210150	SEB TZN MB	ESSEDE5FXXX
2492	50210151	SEB TZN MB	ESSEDE5FXXX
2493	50210152	SEB TZN MB	ESSEDE5FXXX
2494	50210153	SEB TZN MB.	ESSEDE5FXXX
2495	50210154	SEB TZN MB	ESSEDE5FXXX
2496	50210155	SEB TZN MB	ESSEDE5FXXX
2497	50210156	SEB TZN MB	ESSEDE5FXXX
2498	50210157	SEB TZN MB	ESSEDE5FXXX
2499	50210158	SEB TZN MB	ESSEDE5FXXX
2500	50210159	SEB TZN MB	ESSEDE5FXXX
2501	50210160	SEB TZN MB Frankfurt	ESSEDE5FXXX
2502	50210161	SEB TZN MB Frankfurt	ESSEDE5FXXX
2503	50210162	SEB TZN MB Frankfurt	ESSEDE5FXXX
2504	50210163	SEB TZN MB Frankfurt	ESSEDE5FXXX
2505	50210164	SEB TZN MB Frankfurt	ESSEDE5FXXX
2506	50210165	SEB TZN MB Frankfurt	ESSEDE5FXXX
2507	50210166	SEB TZN MB Frankfurt	ESSEDE5FXXX
2508	50210167	SEB TZN MB Frankfurt	ESSEDE5FXXX
2509	50210168	SEB TZN MB Frankfurt	ESSEDE5FXXX
2510	50210169	SEB TZN MB Frankfurt	ESSEDE5FXXX
2511	50210170	SEB TZN MB Frankfurt	ESSEDE5FXXX
2512	50210171	SEB TZN MB Frankfurt	ESSEDE5FXXX
2513	50210172	SEB TZN MB Frankfurt	ESSEDE5FXXX
2514	50210173	SEB TZN MB Frankfurt	ESSEDE5FXXX
2515	50210174	SEB TZN MB Frankfurt	ESSEDE5FXXX
2516	50210175	SEB TZN MB Frankfurt	ESSEDE5FXXX
2517	50210176	SEB TZN MB Frankfurt	ESSEDE5FXXX
2518	50210177	SEB TZN MB Frankfurt	ESSEDE5FXXX
2519	50210178	SEB TZN MB Frankfurt	ESSEDE5FXXX
2520	50210179	SEB TZN MB Frankfurt	ESSEDE5FXXX
2521	50210180	SEB TZN MB Frankfurt	ESSEDE5FXXX
2522	50210181	SEB TZN MB Frankfurt	ESSEDE5FXXX
2523	50210182	SEB TZN MB Frankfurt	ESSEDE5FXXX
2524	50210183	SEB TZN MB Frankfurt	ESSEDE5FXXX
2525	50210184	SEB TZN MB Frankfurt	ESSEDE5FXXX
2526	50210185	SEB TZN MB Frankfurt	ESSEDE5FXXX
2527	50210186	SEB TZN MB Frankfurt	ESSEDE5FXXX
2528	50210187	SEB TZN MB Frankfurt	ESSEDE5FXXX
2529	50210188	SEB TZN MB Frankfurt	ESSEDE5FXXX
2530	50210189	SEB TZN MB Frankfurt	ESSEDE5FXXX
2531	50510120	SEB TZN MB	ESSEDE5FXXX
2532	50510121	SEB TZN MB	ESSEDE5FXXX
2533	50510122	SEB TZN MB	ESSEDE5FXXX
2534	50510123	SEB TZN MB	ESSEDE5FXXX
2535	50510124	SEB TZN MB	ESSEDE5FXXX
2536	50510125	SEB TZN MB	ESSEDE5FXXX
2537	50510126	SEB TZN MB	ESSEDE5FXXX
2538	50510127	SEB TZN MB	ESSEDE5FXXX
2539	50510128	SEB TZN MB	ESSEDE5FXXX
2540	50510129	SEB TZN MB	ESSEDE5FXXX
2541	50510130	SEB TZN MB	ESSEDE5FXXX
2542	50510131	SEB TZN MB	ESSEDE5FXXX
2543	50510132	SEB TZN MB	ESSEDE5FXXX
2544	50510133	SEB TZN MB	ESSEDE5FXXX
2545	50510134	SEB TZN MB	ESSEDE5FXXX
2546	50510135	SEB TZN MB	ESSEDE5FXXX
2547	50510136	SEB TZN MB	ESSEDE5FXXX
2548	50510137	SEB TZN MB	ESSEDE5FXXX
2549	50510138	SEB TZN MB	ESSEDE5FXXX
2550	50510139	SEB TZN MB	ESSEDE5FXXX
2551	50510140	SEB TZN MB	ESSEDE5FXXX
2552	50510141	SEB TZN MB	ESSEDE5FXXX
2553	50510142	SEB TZN MB	ESSEDE5FXXX
2554	50510143	SEB TZN MB	ESSEDE5FXXX
2555	50510144	SEB TZN MB	ESSEDE5FXXX
2556	50510145	SEB TZN MB	ESSEDE5FXXX
2557	50510146	SEB TZN MB	ESSEDE5FXXX
2558	50510147	SEB TZN MB	ESSEDE5FXXX
2559	50510148	SEB TZN MB	ESSEDE5FXXX
2560	50510149	SEB TZN MB	ESSEDE5FXXX
2561	50510150	SEB TZN MB	ESSEDE5FXXX
2562	50510151	SEB TZN MB	ESSEDE5FXXX
2563	50510152	SEB TZN MB	ESSEDE5FXXX
2564	50510153	SEB TZN MB	ESSEDE5FXXX
2565	50510154	SEB TZN MB	ESSEDE5FXXX
2566	50510155	SEB TZN MB	ESSEDE5FXXX
2567	50510156	SEB TZN MB	ESSEDE5FXXX
2568	50510157	SEB TZN MB	ESSEDE5FXXX
2569	50510158	SEB TZN MB	ESSEDE5FXXX
2570	50510159	SEB TZN MB	ESSEDE5FXXX
2571	50510160	SEB TZN MB	ESSEDE5FXXX
2572	50510161	SEB TZN MB	ESSEDE5FXXX
2573	50510162	SEB TZN MB	ESSEDE5FXXX
2574	50510163	SEB TZN MB	ESSEDE5FXXX
2575	50510164	SEB TZN MB	ESSEDE5FXXX
2576	50510165	SEB TZN MB	ESSEDE5FXXX
2577	50510166	SEB TZN MB	ESSEDE5FXXX
2578	50510167	SEB TZN MB	ESSEDE5FXXX
2579	50510168	SEB TZN MB	ESSEDE5FXXX
2580	50510169	SEB TZN MB	ESSEDE5FXXX
2581	50510170	SEB TZN MB	ESSEDE5FXXX
2582	50510171	SEB TZN MB	ESSEDE5FXXX
2583	50510172	SEB TZN MB	ESSEDE5FXXX
2584	50510173	SEB TZN MB	ESSEDE5FXXX
2585	50510174	SEB TZN MB	ESSEDE5FXXX
2586	50510175	SEB TZN MB	ESSEDE5FXXX
2587	50510176	SEB TZN MB	ESSEDE5FXXX
2588	50510177	SEB TZN MB	ESSEDE5FXXX
2589	50510178	SEB TZN MB	ESSEDE5FXXX
2590	50510179	SEB TZN MB	ESSEDE5FXXX
2591	50510180	SEB TZN MB	ESSEDE5FXXX
2592	20020200	SEB Merchant Bank Hamburg	ESSEDEFFHAM
2593	51220200	SEB Merchant Banking Ffm	ESSEDEFFXXX
2594	61150020	Kr Spk Esslingen-Nürtingen	ESSLDE66XXX
2595	30030600	ETRIS Bank Wuppertal	ETRIDE31XXX
2596	66432700	Faißtbank Wolfach	FAITDE66XXX
2597	50110700	FBG (D)	FBGADEF1XXX
2598	50020700	Credit Europe Bank Ffm	FBHLDEFFXXX
2599	62020100	FGA Bank Heilbronn Neckar	FBHNDE61XXX
2600	50230300	FCB Firmen-Credit Bank Ffm	FCFBDEFFXXX
2601	37020900	Ford Bank Köln	FDBADE3KXXX
2602	70022200	Fidor Bank München	FDDODEMMXXX
2603	50522222	FIDOR Bank Frankfurt	FDORDEF1XXX
2604	50021120	FIL Fondsbank Kronberg	FFBKDEFFTHK
2605	50021100	FIL Fondsbank Frankfurt	FFBKDEFFXXX
2606	50190000	Frankfurter Volksbank	FFVBDEFFXXX
2607	70030111	Flessabank München	FLESDEMMXXX
2608	76330111	Flessabank Erlangen	FLESDEMMXXX
2609	77030111	Flessabank Bamberg	FLESDEMMXXX
2610	78330111	Flessabank Coburg	FLESDEMMXXX
2611	79330111	FLESSABANK Schweinfurt	FLESDEMMXXX
2612	84030111	Flessabank Meiningen	FLESDEMMXXX
2613	70012400	Die AKTIONÄRSBANK Kulmbach	FLGMDE77XXX
2614	70120500	CACEIS Bank Deutschland	FMBKDEMMXXX
2615	77322200	Fondsdepot Bank	FODBDE77XXX
2616	28030300	Bankhaus Fortmann Oldenburg	FORTDEH4XXX
2617	68050101	Spk Freiburg-Nördl Breisgau	FRSPDE66XXX
2618	50324040	ABN AMRO Bank MoneYou, Ffm	FTSBDEFAMYO
2619	50324000	ABN AMRO Bank	FTSBDEFAXXX
2620	70030014	Fuggerbank Augsburg	FUBKDE71MUC
2621	72030014	Fürst Fugger Privatbk Augsb	FUBKDE71XXX
2622	79030001	Fürstl. Castellsche Bank	FUCEDE77XXX
2623	36010699	Gallinat - Bank Essen	GABKDE31699
2624	36010600	GALLINAT-BANK Essen	GABKDE31XXX
2625	73331700	Saliterbank Obergünzburg	GABLDE71XXX
2626	70032500	SGKB Deutschland, München	GAKDDEM1XXX
2627	37010600	BNPP Fortis Deutschland	GEBADE33XXX
2628	37010699	BNPP Fortis Frankfurt, Main	GEBADE33XXX
2629	50861501	Raiffbk Nördliche Bergstr	GENODE51ABH
2630	50069126	Raiffeisenbank Alzey-Land	GENODE51ABO
2631	50961685	Volksbank Überwald-Gorxheim	GENODE51ABT
2632	53093255	AgrarBank Alsfeld	GENODE51AGR
2633	55361202	VR Bank	GENODE51AHM
2634	53093200	VR Bank HessenLand	GENODE51ALS
2635	57263015	Raiffeisenbank Arzbach	GENODE51ARZ
2636	55362071	Volksbank Bechtheim -alt-	GENODE51BEC
2637	59291200	Volksbank Saarpfalz	GENODE51BEX
2638	50069693	Raiffeisenbank Bad Homburg	GENODE51BH1
2639	50092100	Spar- u Kreditbk Bad Hombg	GENODE51BH2
2640	53290000	VR-Bank Bad Hersfeld-Rotenb	GENODE51BHE
2641	51762434	VR Bank Biedenk-Gladenb	GENODE51BIK
2642	50793300	Birsteiner Volksbank	GENODE51BIV
2643	50861393	SpDK Zell -alt-	GENODE51BKZ
2644	55061303	Budenheimer Volksbank	GENODE51BUD
2645	50761333	Volksbank Büdingen -alt-	GENODE51BUE
2646	51861403	Volksbank Butzbach	GENODE51BUT
2647	51191200	Volksbank Goldner Grund	GENODE51CAM
2648	50530000	Cronbank	GENODE51CRO
2649	57391200	Volksbank Daaden	GENODE51DAA
2650	57092800	Volksbank Rhein-Lahn	GENODE51DIE
2651	51690000	Volksbank Dill VB u Raiffbk	GENODE51DIL
2652	50592200	VB Dreieich	GENODE51DRE
2653	59392000	Volksbank Dillingen -alt-	GENODE51DSA
2654	50069187	Volksbank Egelsbach -alt-	GENODE51EGE
2655	51091400	Volksbank Eltville -alt-	GENODE51ELV
2656	59292400	Eppelborner Volksbank -alt-	GENODE51EPP
2657	50865503	VB Eppertshausen	GENODE51EPT
2658	50069241	Raiffeisenkasse	GENODE51ERB
2659	59099530	RB Wiesbach -alt-	GENODE51EWI
2660	51961801	Volksbank Feldatal	GENODE51FEL
2661	50190400	Volksbank Griesheim Ffm	GENODE51FGH
2662	50190300	Volksbank Höchst	GENODE51FHC
2663	50961592	Volksbank Weschnitztal	GENODE51FHO
2664	53060180	VR Genossenschaftsbk Fulda	GENODE51FUL
2665	50093010	VB Rüsselsheim GAA	GENODE51GAA
2666	50790000	VR Bank Bad Orb-Gelnhausen	GENODE51GEL
2667	50892500	Groß-Gerauer Volksbank -alt	GENODE51GG1
2668	50862903	Volksbank Mainspitze	GENODE51GIN
2669	50069146	Volksbank Grebenhain	GENODE51GRC
2670	50862408	Ver VB Griesh-Weiterst -alt	GENODE51GRI
2671	50961312	Raiffbk Groß-Rohrheim	GENODE51GRM
2672	50069345	Raiffbk Grävenwiesbach	GENODE51GWB
2673	57391500	VB Hamm, Sieg Hamm, Sieg	GENODE51HAM
2674	55061507	VR-Bank Mainz	GENODE51HDS
2675	51691500	Volksbank Herborn-Eschenbg	GENODE51HER
2676	57091100	VB Höhr-Grenzhausen -alt-	GENODE51HGR
2677	51361021	Volksbank Heuchelheim	GENODE51HHE
2678	59491114	VR Bank Saarpfalz	GENODE51HOM
2679	51961515	Spar-u Darlehnskasse	GENODE51HSH
2680	50069464	VB Inheiden-Villingen -alt-	GENODE51HUI
2681	50069455	Hüttenberger Bk Hüttenberg	GENODE51HUT
2682	56290000	VB-Raiffbk Naheland -alt-	GENODE51IDO
2683	50093400	Volksbank Kelsterbach	GENODE51KBH
2684	50092200	Volksbank Main-Taunus -alt-	GENODE51KEL
2685	50069477	Raiffeisenbank Kirtorf	GENODE51KIF
2686	57090000	VB Koblenz Mittelrhein	GENODE51KOB
2687	56090000	VB Rhein-Nahe-Hunsrück	GENODE51KRE
2688	52090000	Kasseler Bank	GENODE51KS1
2689	51990000	Volksbank Lauterbach-Schl	GENODE51LB1
2690	51161606	Volksbank Langendernbach	GENODE51LDD
2691	59393000	levoBank	GENODE51LEB
2692	51190000	Ver Volksbank Limburg	GENODE51LIM
2693	59392200	Volksbank Untere Saar	GENODE51LOS
2694	59491300	VR Bank Saarpfalz	GENODE51MBT
2695	50863513	Volksbank Odenwald	GENODE51MIC
2696	51362514	VR Bank Mücke -alt-	GENODE51MNO
2697	57091000	Volksbank Montabaur	GENODE51MON
2698	50069828	Raiffeisenbank Mücke -alt-	GENODE51MRU
2699	50865224	Volksbank Mörfelden-Walldf	GENODE51MWA
2700	55060417	VR-Bank Mainz	GENODE51MZ2
2701	55060321	VR-Bank Mainz	GENODE51MZ4
2702	55060611	Genobank Mainz	GENODE51MZ6
2703	50761613	VB Büdingen -alt-	GENODE51NID
2704	50661816	Volksbank Heldenbergen	GENODE51NIH
2705	55061907	Volksbank Rhein-Selz -alt-	GENODE51NIS
2706	59099550	Volksbank Nahe-Schaumberg	GENODE51NOH
2707	57062675	Raiffbk Niederwallmenach	GENODE51NWA
2708	50561315	Ver VB Maingau	GENODE51OBH
2709	51861806	Volksbank Ober-Mörlen	GENODE51OBM
2710	50061741	Raiffeisenbank Oberursel	GENODE51OBU
2711	50590000	Offenbacher Volksbank -alt-	GENODE51OF1
2712	50560102	Raiffbk Offenbach	GENODE51OF2
2713	50864322	Volksbank Modau	GENODE51ORA
2714	50863906	Volksbank Modautal Modau	GENODE51ORM
2715	51361704	Volksbank Holzheim -alt-	GENODE51PLH
2716	51363407	Volksbank Garbenteich -alt-	GENODE51PMG
2717	59091800	VB Quierschied -alt-	GENODE51QUI
2718	50961206	Raiffeisenbank Bürstadt	GENODE51RBU
2719	50862703	VB Gersprenztal-Otzberg	GENODE51REI
2720	51861616	LdBk Horlofftal Reichelshei	GENODE51REW
2721	51091500	Rheingauer Volksbank	GENODE51RGG
2722	50093000	Rüsselsheimer Volksbank	GENODE51RUS
2723	59092000	Vereinigte Volksbank	GENODE51SB2
2724	51191800	Volksbank Schupbach	GENODE51SBH
2725	50692100	Volksbank Seligenstadt	GENODE51SEL
2726	50862835	Raiffeisenbank Schaafheim	GENODE51SHM
2727	50864808	VB Seeheim-Jugenheim -alt-	GENODE51SJ2
2728	59390100	Volksbank Saarlouis	GENODE51SLF
2729	59190200	Volksbank Saar-West	GENODE51SLS
2730	53061313	VR Bk Schlüchtern-Birstein	GENODE51SLU
2731	59091500	Volksbank Sulzbachtal-alt-	GENODE51SUZ
2732	50069842	Raiffeisen-VB Schwabenheim	GENODE51SWB
2733	59391200	Volksbank Überherrn	GENODE51UBH
2734	51961023	Volksbank Ulrichstein	GENODE51ULR
2735	50092900	Volksbank Usinger Land	GENODE51USI
2736	50794300	VR Bank Wächtersbach -alt-	GENODE51WBH
2737	51591300	Volksbank Brandoberndorf	GENODE51WBO
2738	51192200	VuR-Bank Weilmünster -alt-	GENODE51WEM
2739	59291000	Sankt Wendeler Volksbank	GENODE51WEN
2740	50862311	VB Gräfenhausen -alt-	GENODE51WGH
2741	57391800	Westerwald Bank	GENODE51WW1
2742	50069976	Volksbank Wißmar	GENODE51WWI
2743	51560231	VB Wetzlar-Weilburg -alt-	GENODE51WZ1
2744	50060000	DZ Bank	GENODE55XXX
2745	66291300	Volksbank Achern	GENODE61ACH
2746	54062027	Raiffbk Albisheim -alt-	GENODE61ALB
2747	66261416	Raiffeisenbank Altschweier	GENODE61ALR
2748	66492600	VB Appenweier -alt-	GENODE61APP
2749	55091200	Volksbank Alzey-Worms	GENODE61AZY
2750	66090800	BBBank Karlsruhe	GENODE61BBB
2751	66291400	Volksbank Bühl	GENODE61BHL
2752	66261092	Spar-u Kreditbank Bühlertal	GENODE61BHT
2753	66390000	VB Bruchsal-Bretten -alt-	GENODE61BRU
2754	68490000	Volksbank Rhein-Wehra	GENODE61BSK
2755	66391200	VB Bruchsal-Bretten	GENODE61BTT
2756	67461424	Volksbank Franken Buchen	GENODE61BUC
2757	54891300	VR Bank Südl Weinstr	GENODE61BZA
2758	66069104	Spar- u Kreditbk Dauchingen	GENODE61DAC
2759	54291200	Raiffeisen u Volksbank Dahn	GENODE61DAH
2760	68062105	Raiffbk Denzlingen-Sexau	GENODE61DEN
2761	66062366	Raiffbk Hardt-Bruhrain	GENODE61DET
2762	66562053	Rb Südhardt Durmersheim	GENODE61DUR
2763	54691200	VR Bank Mittelhaardt	GENODE61DUW
2764	54861190	Raiffbk Oberhaardt-Gäu-alt-	GENODE61EDH
2765	66062138	Spar- u Kreditbank Hardt	GENODE61EGG
2766	66069103	Raiffeisenbank Elztal	GENODE61ELZ
2767	68092000	VB Breisgau Nord	GENODE61EMM
2768	66662155	Raiffeisenbank Ersingen	GENODE61ERS
2769	66091200	Volksbank Ettlingen	GENODE61ETT
2770	54663270	Raiffbk Friedelsheim	GENODE61FHR
2771	68090000	Volksbank Freiburg	GENODE61FR1
2772	54661800	Raiffeisenbank Freinsheim	GENODE61FSH
2773	54092400	Volksbank Glan-Münchweiler	GENODE61GLM
2774	68064222	Raiffeisenbank Gundelfingen	GENODE61GUN
2775	69091200	Hagnauer Volksbank	GENODE61HAG
2776	67290000	Heidelberger Volksbank	GENODE61HD1
2777	67290100	Volksbank Kurpfalz H+G Bank	GENODE61HD3
2778	54862390	Raiffeisenbank Herxheim	GENODE61HXH
2779	66562300	VR-Bank Mittelb Iffezheim	GENODE61IFF
2780	68061505	Volksbank Breisgau-Süd	GENODE61IHR
2781	68491500	Volksbank Jestetten -alt-	GENODE61JES
2782	66190000	Volksbank Karlsruhe	GENODE61KA1
2783	66060300	Spar- und Kreditbank	GENODE61KA3
2784	66661329	Raiffeisenbank Kieselbronn	GENODE61KBR
2785	66662220	Volksbank Stein Eisingen	GENODE61KBS
2786	66762332	Raiffbk Kraichgau	GENODE61KIR
2787	54090000	VB Kaisersl.-Nordwestpf.	GENODE61KL1
2788	66069342	Volksbank Krautheim	GENODE61KTH
2789	66492700	VB Kinzigtal Wolfach	GENODE61KZT
2790	68290000	Volksbank Lahr	GENODE61LAH
2791	54061650	VR-Bank Westpfalz	GENODE61LAN
2792	54561310	RV Bank Rhein-Haardt	GENODE61LBS
2793	54091700	Volksbank Lauterecken	GENODE61LEK
2794	67462368	Volksbank Limbach	GENODE61LMB
2795	67262550	Volksbank Rot St Leon-Rot	GENODE61LRO
2796	67090000	VR Bank Rhein-Neckar	GENODE61MA2
2797	67060031	Volksbank Ma-Sandhofen	GENODE61MA3
2798	68361394	Raiffbk Maulburg -alt-	GENODE61MAU
2799	69362032	Volksbank Meßkirch Raiffbk	GENODE61MES
2800	68091900	Volksbank Müllheim	GENODE61MHL
2801	67460041	Volksbank Mosbach	GENODE61MOS
2802	66661244	Raiffeisenbank Bauschlott	GENODE61NBT
2803	66762433	Raiffeisenbank Neudenau	GENODE61NEU
2804	66661454	VR Bank im Enzkreis	GENODE61NFO
2805	67291700	Volksbank Neckartal	GENODE61NGD
2806	54091800	VR Bank Nordwestpfalz -alt-	GENODE61OB1
2807	66490000	Volksbank Offenburg	GENODE61OG1
2808	66391600	VB Bruhrain-Kraich-Hardt	GENODE61ORH
2809	69091600	Volksbank Pfullendorf	GENODE61PFD
2810	54290000	VR-Bank Pirmasens	GENODE61PS1
2811	69291000	Volksbank Konstanz	GENODE61RAD
2812	66061407	Spar- u Kreditbk Rheinstett	GENODE61RH2
2813	67461733	Volksbank Kirnau	GENODE61RNG
2814	54261700	VR-Bank Südwestpfalz	GENODE61ROA
2815	66061059	VB Stutensee Hardt -alt-	GENODE61SBA
2816	54761411	Raiffbk Schifferstadt -alt-	GENODE61SFS
2817	69290000	Volksbank Hegau -alt-	GENODE61SIN
2818	67462480	Raiffbk Schefflenz -alt-	GENODE61SOB
2819	54790000	VB Kur- und Rheinpfalz	GENODE61SPE
2820	68391500	VR Bank	GENODE61SPF
2821	67291900	Volksbank Kraichgau -alt-	GENODE61SSH
2822	68092300	Volksbank Staufen	GENODE61STF
2823	54862500	VR Bank Südpfalz	GENODE61SUW
2824	67362560	Volksbank Tauber -alt-	GENODE61TBB
2825	69491700	Volksbank Triberg	GENODE61TRI
2826	69061800	Volksbank Überlingen	GENODE61UBE
2827	68063479	Raiffeisenbank Kaiserstuhl	GENODE61VOK
2828	69490000	VB Schwarzwald Baar Hegau	GENODE61VS1
2829	66061724	VB Stutensee-Weingarten	GENODE61WGA
2830	67262243	Raiff Privatbk Wiesloch	GENODE61WIB
2831	67292200	Volksbank Kraichgau	GENODE61WIE
2832	66692300	VB Wilferdingen-Keltern	GENODE61WIR
2833	67092300	Volksbank Weinheim	GENODE61WNM
2834	55390000	VB Worms-Wonnegau -alt-	GENODE61WO1
2835	68492200	Volksbank Hochrhein	GENODE61WT1
2836	67390000	VB Main-Tauber	GENODE61WTH
2837	68462427	VB Klettgau-Wutöschingen	GENODE61WUT
2838	68062730	Raiffbk Wyhl Kaiserstuhl	GENODE61WYH
2839	66060000	DZ BANK	GENODE6KXXX
2840	39060180	Aachener Bank	GENODED1AAC
2841	39161490	Volksbank Aachen Süd	GENODED1AAS
2842	37069101	Spar-u Darlehnskasse	GENODED1AEG
2843	25491273	Volksbank Aerzen -alt-	GENODED1AEZ
2844	37069355	Spar-u Darlehnskasse	GENODED1AHO
2845	37069103	Raiffeisenbank Aldenhoven	GENODED1ALD
2846	57069238	Raiffbk Neustadt	GENODED1ASN
2847	36060295	Bank im Bistum Essen	GENODED1BBE
2848	37062124	Bensberger Bank	GENODED1BGL
2849	58660101	Volksbank Bitburg	GENODED1BIT
2850	25491744	Volksbank Bad Münder	GENODED1BMU
2851	57761591	VB RheinAhrEifel	GENODED1BNA
2852	58761343	Raiffbk Zeller Land	GENODED1BPU
2853	37161289	VR-Bank Rhein-Erft	GENODED1BRH
2854	37069991	Brühler Bank, Brühl	GENODED1BRL
2855	38060186	Volksbank Bonn Rhein-Sieg	GENODED1BRS
2856	37160087	Kölner Bank	GENODED1CGN
2857	33060098	Credit- u VB Wuppertal	GENODED1CVW
2858	37069427	Volksbank Dünnwald-Holweide	GENODED1DHK
2859	35060190	Bank für Kirche u Diakonie	GENODED1DKD
2860	35261248	Volksbank Dinslaken	GENODED1DLK
2861	30160213	VB Düsseldorf Neuss	GENODED1DNE
2862	39560201	Volksbank Düren	GENODED1DUE
2863	37069322	Raiffeisenbank Gymnich	GENODED1EGY
2864	31261282	Volksbank Erkelenz	GENODED1EHE
2865	35860245	Volksbank Emmerich-Rees	GENODED1EMR
2866	37069252	Volksbank Erft Elsdorf	GENODED1ERE
2867	37069472	Raiffeisenbk Erftstadt-alt-	GENODED1ERF
2868	38260082	Volksbank Euskirchen	GENODED1EVB
2869	60130100	FFS Bank Stuttgart	GENODED1FFS
2870	37062365	Raiffbk Frechen-Hürth	GENODED1FHH
2871	56261735	Raiffeisenbank Nahe	GENODED1FIN
2872	37063367	Raiffbk Fischenich-Kende	GENODED1FKH
2873	31060181	Gladbacher Bank von 1922	GENODED1GBM
2874	57361476	Volksbank Gebhardshain	GENODED1GBS
2875	32061384	Volksbank an der Niers	GENODED1GDL
2876	37069303	Volksbank Gemünd-Kall -alt-	GENODED1GKK
2877	37069302	Raiffbk Geilenkirchen	GENODED1GLK
2878	37069306	Raiffeisenbank Grevenbroich	GENODED1GRB
2879	57762265	Raiffbk Grafschaft-Wachtbg	GENODED1GRO
2880	37069330	Volksbank Haaren	GENODED1HAW
2881	38160220	VR-Bank Bonn	GENODED1HBO
2882	37069153	Spar-u Darlehnskasse -alt-	GENODED1HCK
2883	58561250	Volksbank Hermeskeil -alt-	GENODED1HER
2884	37069342	Volksbank Heimbach	GENODED1HMB
2885	39061981	Heinsberger Volksbank	GENODED1HNB
2886	37069412	Raiffeisenbank Heinsberg	GENODED1HRB
2887	32060362	Volksbank Krefeld	GENODED1HTK
2888	58564788	VB Hochwald-Saarburg	GENODED1HWM
2889	57069526	Raiffbk Idarwald -alt-	GENODED1IDW
2890	37069381	VR-Bank Rur-Wurm	GENODED1IMM
2891	57069727	Raiffeisenbank Irrel	GENODED1IRR
2892	37069401	Raiffeisenbank Junkersdorf	GENODED1JUK
2893	37069405	Raiffeisenbank Kaarst	GENODED1KAA
2894	57069144	Raiffbk Eifeltor	GENODED1KAI
2895	31062154	Volksbank Brüggen-Nettetal	GENODED1KBN
2896	10061006	KD-Bank Berlin	GENODED1KDB
2897	44064406	KD-Bank Dortmund	GENODED1KDD
2898	81068106	KD-Bank Magdeburg	GENODED1KDM
2899	57661253	Raiffeisenbank Kehrig	GENODED1KEH
2900	56061472	VB Hunsrück-Nahe	GENODED1KHK
2901	37069331	Raiffeisenbank von 1895	GENODED1KHO
2902	32460422	Volksbank Kleverland	GENODED1KLL
2903	32061414	Volksbank Kempen-Grefrath	GENODED1KMP
2904	37069429	Volksbank Köln-Nord	GENODED1KNL
2905	56061151	Raiffeisenbank Kastellaun	GENODED1KSL
2906	31263359	Raiffbk Erkelenz	GENODED1LOE
2907	57069067	Raiffbk Lutzerather-Höhe	GENODED1LUH
2908	57069806	VR-Bank Hunsrück-Mosel	GENODED1MBA
2909	37069164	Volksbank Meerbusch	GENODED1MBU
2910	57064221	Volksbank Mülheim-Kärlich	GENODED1MKA
2911	58561771	Raiffbk Mehring-Leiwen	GENODED1MLW
2912	37069521	Raiffeisenbank Rhein-Berg	GENODED1MNH
2913	57069081	Raiffeisenbank Moselkrampen	GENODED1MOK
2914	57662263	VR Bank Rhein-Mosel	GENODED1MPO
2915	31060517	VB Mönchengladbach	GENODED1MRB
2916	57461759	Raiffbk Mittelrhein	GENODED1MRW
2917	37069524	Raiffbk Much-Ruppichteroth	GENODED1MUC
2918	58668818	Raiffbk Neuerburg-Land -alt	GENODED1NBL
2919	57363243	Raiffbk Niederfischb. -alt-	GENODED1NFB
2920	31062553	Volksbank Schwalmtal	GENODED1NKR
2921	30560548	VR Bank Dormagen	GENODED1NLD
2922	35461106	Volksbank Niederrhein	GENODED1NRH
2923	30560090	Volksbank Neuss -alt-	GENODED1NSS
2924	57460117	VR-Bank Neuwied-Linz	GENODED1NWD
2925	37069577	Raiffbk Odenthal -alt-	GENODED1ODT
2926	58662653	Raiffbk östl Südeifel	GENODED1OSE
2927	39160191	Pax-Bank Aachen	GENODED1PA1
2928	36060192	Pax-Bank Essen	GENODED1PA2
2929	58560294	Pax-Bank Trier	GENODED1PA3
2930	55160195	Pax-Bank Mainz	GENODED1PA4
2931	82060197	Pax-Bank Erfurt	GENODED1PA5
2932	10060198	Pax-Bank Berlin	GENODED1PA6
2933	37060120	Pax-Bank Gf MHD	GENODED1PA7
2934	37062600	VR Bank Bergisch Gladbach	GENODED1PAF
2935	37060193	Pax-Bank Köln	GENODED1PAX
2936	58691500	Volksbank Eifel Mitte	GENODED1PRU
2937	37069627	Raiffbk Rheinbach Voreifel	GENODED1RBC
2938	56062227	Volksbank Rheinböllen	GENODED1RBO
2939	24121000	Ritter Kredit Stade	GENODED1RKI
2940	37069125	Raiffbk Kürten-Odenthal	GENODED1RKO
2941	35660599	Volksbank Rhein-Lippe	GENODED1RLW
2942	39362254	Raiffeisen-Bank Eschweiler	GENODED1RSC
2943	37069520	VR-Bank Rhein-Sieg Siegburg	GENODED1RST
2944	37560092	Volksbank Rhein-Wupper	GENODED1RWL
2945	37069707	Raiffbk Sankt Augustin	GENODED1SAM
2946	37069354	Raiffbk Selfkant -alt-	GENODED1SEG
2947	37069720	VR-Bank Nordeifel Schleiden	GENODED1SLE
2948	37069642	Raiffbk Simmerath	GENODED1SMR
2949	36060591	Sparda-Bank West	GENODED1SPE
2950	37060590	Sparda-Bank West	GENODED1SPK
2951	33060592	Sparda-Bank West	GENODED1SPW
2952	58561626	Volksbank Saarburg -alt-	GENODED1SRB
2953	57069315	Raiffbk Straßenhaus -alt-	GENODED1SRH
2954	38621500	Steyler Bank	GENODED1STB
2955	58560103	Volksbank Trier	GENODED1TVB
2956	57069257	Raiffbk Untermosel	GENODED1UMO
2957	57063478	Volksbank Vallendar-Niederw	GENODED1VAN
2958	56062577	Vereinigte Raiffeisenkassen	GENODED1VRK
2959	35060386	VB Rhein-Ruhr Duisburg	GENODED1VRR
2960	31460290	Volksbank Viersen	GENODED1VSN
2961	38462135	Volksbank Oberberg	GENODED1WIL
2962	57069361	Raiffeisenbank Welling	GENODED1WLG
2963	37069639	Rosbacher Raiffeisenbank	GENODED1WND
2964	37069840	VB Wipperfürth-Lindlar	GENODED1WPF
2965	58661901	Raiffeisenbank Westeifel	GENODED1WSC
2966	37069833	Raiffeisenbk Wesseling-alt-	GENODED1WSL
2967	58760954	VVR-Bank Wittlich	GENODED1WTL
2968	39162980	VR-Bank Würselen	GENODED1WUR
2969	37069805	Volksbank Wachtberg	GENODED1WVI
2970	57060000	WGZ Bank Koblenz	GENODEDD570
2971	30060010	WGZ Bank Düsseldorf	GENODEDDXXX
2972	20069815	Volksbank Oldendorf	GENODEF1815
2973	79562514	Raiffbk Aschaffenburg	GENODEF1AB1
2974	79590000	Volksbank Aschaffenburg	GENODEF1AB2
2975	75069014	Raiffbk Bad Abbach-Saal	GENODEF1ABS
2976	26061556	Volksbank Adelebsen	GENODEF1ADE
2977	72069002	Raiffbk Adelzhausen-Sielenb	GENODEF1ADZ
2978	71062802	Raiffeisenbank Anger	GENODEF1AGE
2979	79066082	Raiffeisenbank Altertheim	GENODEF1AHE
2980	71165150	Raiffeisenbank Mangfal-alt-	GENODEF1AIB
2981	70169653	Raiffeisenbank Aiglsbach	GENODEF1AIG
2982	72069005	Raiffeisenbank Aindling	GENODEF1AIL
2983	73369851	Raiffbk Aitrang-Ruderatshfn	GENODEF1AIT
2984	77061004	Raiffbk Obermain Nord	GENODEF1ALK
2985	83065410	Dt Skatbank Zndl VR Bank	GENODEF1ALT
2986	70169310	Raiffeisenbank Alxing-Bruck	GENODEF1ALX
2987	79567531	VR-Bank	GENODEF1ALZ
2988	75290000	VB-Raiffbk Amberg	GENODEF1AMV
2989	87096034	VB Erzgebirge -alt-	GENODEF1ANA
2990	15061638	Volksbank Raiffeisenbank	GENODEF1ANK
2991	76560060	RaiffVB Ansbach	GENODEF1ANS
2992	71061009	VR meine Raiffeisenbank	GENODEF1AOE
2993	20069782	Volksbank Geest	GENODEF1APE
2994	74361211	Raiffeisenbank Arnstorf	GENODEF1ARF
2995	72169013	Raiffbk Aresing-Hörz-Schilt	GENODEF1ARH
2996	70169450	Raiff-VB Ebersberg	GENODEF1ASG
2997	20069780	Volksbank Ahlerstedt	GENODEF1AST
2998	71162804	Raiffbk Aschau-Samerberg	GENODEF1ASU
2999	79069010	VR-Bank Schweinfurt	GENODEF1ATE
3000	72090000	Augusta-Bank RVB Augsburg	GENODEF1AUB
3001	87065893	VB Erzgebirge -alt-	GENODEF1AUE
3002	76069369	Raiffbk Auerbach-Freihung	GENODEF1AUO
3003	74165013	Raiffeisenbank Sonnenwald	GENODEF1AUS
3004	76069549	Raiffbk Münchaurach -alt-	GENODEF1AUT
3005	77060100	VR Bank Bamberg	GENODEF1BA2
3006	79561348	Raiffbk Bachgau -alt-	GENODEF1BAG
3007	28063607	Volksbank Bakum	GENODEF1BAM
3008	23062124	Raiffeisenbank Bargteheide	GENODEF1BAR
3009	28069293	VB Obergrafschaft -alt-	GENODEF1BBH
3010	20069130	Raiffbk	GENODEF1BBR
3011	72069126	RB Bibertal-Kötz	GENODEF1BBT
3012	23064107	Raiffeisenbank Büchen	GENODEF1BCH
3013	25591413	Volksbank in Schaumburg	GENODEF1BCK
3014	21763542	VR Bank Niebüll	GENODEF1BDS
3015	53261202	Bankverein Bebra	GENODEF1BEB
3016	76069378	Raiffeisenbank Bechhofen	GENODEF1BEH
3017	29265747	VB Bremerhaven-Cuxland	GENODEF1BEV
3018	25090300	Bk f Schiffahrt Hannover	GENODEF1BFS
3019	77062014	RB Burgebrach-Stegaurach	GENODEF1BGB
3020	79364406	VR-Bk Schweinfurt Ld -alt-	GENODEF1BGF
3021	71090000	VB RB Oberbayern Südost	GENODEF1BGL
3022	77069836	Raiffbk Berg-Bad Steben	GENODEF1BGO
3023	27893215	Vereinigte Volksbank	GENODEF1BHA
3024	79069031	Raiffbk Bütthard-Gaukönigsh	GENODEF1BHD
3025	52069013	Raiffeisenbank Burghaun	GENODEF1BHN
3026	73369859	Raiffeisenbank Bidingen	GENODEF1BIN
3027	50763319	Raiffbk Vogelsberg Birstein	GENODEF1BIR
3028	50662299	Raiffbk Bruchköbel -alt-	GENODEF1BKO
3029	17062428	Raiff-VB Oder-Spree Beeskow	GENODEF1BKW
3030	75091400	VR Bank Burglengenfeld	GENODEF1BLF
3031	27893359	Volksbank Braunlage	GENODEF1BLG
3032	72169380	Raiffeisenbank Beilngries	GENODEF1BLN
3033	72069736	Raiffbk Iller-Roth-Günz	GENODEF1BLT
3034	25069503	VB Diepholz-Barnstorf	GENODEF1BNT
3035	86065448	VR Bank Leipziger Land	GENODEF1BOA
3036	28069706	Volksbank Nordhümmling	GENODEF1BOG
3037	27062290	Volksbank Börßum-Hornburg	GENODEF1BOH
3038	72069036	Raiffeisenbank Bobingen	GENODEF1BOI
3039	21261227	Raiffbk Kl-Kummerfeld -alt-	GENODEF1BOO
3040	52061303	Raiffbk Borken	GENODEF1BOR
3041	76069576	Raiffeisenbank Plankstetten	GENODEF1BPL
3042	16062073	Brandenburger Bank	GENODEF1BRB
3043	81063238	VB Jerichower Land	GENODEF1BRG
3044	79065028	VR-Bank Bad Kissingen	GENODEF1BRK
3045	28061410	Raiffbk Wesermarsch-Süd	GENODEF1BRN
3046	29262722	Volksbank Geeste-Nord	GENODEF1BRV
3047	10090300	Bk f Schiffahrt BFS Berlin	GENODEF1BSB
3048	35090300	Bk f Schiffahrt Duisburg	GENODEF1BSD
3049	27090077	Volksbank Braunschweig -alt	GENODEF1BSG
3050	72069034	Raiffeisenbank Bissingen	GENODEF1BSI
3051	28062913	Volksbank Bösel	GENODEF1BSL
3052	87069077	Ver Raiffbk Burgstädt	GENODEF1BST
3053	77390000	VB-Raiffbk Bayreuth	GENODEF1BT1
3054	52064156	Raiffeisenbank Baunatal	GENODEF1BTA
3055	76069564	Raiffbk Oberferrieden-Burgt	GENODEF1BTO
3056	75069020	Raiffeisenbank Bruck	GENODEF1BUK
3057	52069065	Raiffbk Langenschw. Burghau	GENODEF1BUR
3058	28068218	Raiffbk Butjadingen-Abbehsn	GENODEF1BUT
3059	51861325	BVB Volksbank	GENODEF1BVB
3060	72069179	Raiffbk Unteres Zusamtal	GENODEF1BWI
3061	85590000	Volksbank Bautzen	GENODEF1BZV
3062	52065220	Raiffeisenbank Calden	GENODEF1CAL
3063	87096214	Volksbank Chemnitz	GENODEF1CH1
3064	74261024	Raiffeisenbank Chamer Land	GENODEF1CHA
3065	28061501	Volksbank Cloppenburg	GENODEF1CLP
3066	25861990	Volksbank Clenze-Hitzacker	GENODEF1CLZ
3067	25462680	VB im Wesertal Coppenbrügge	GENODEF1COP
3068	78360000	VR-Bank Coburg	GENODEF1COS
3069	24061392	VB Bleckede-Dahlenbg -alt-	GENODEF1DAB
3070	28061679	Volksbank Dammer Berge	GENODEF1DAM
3071	25861395	Volksbank Dannenberg -alt-	GENODEF1DAN
3072	13061128	Raiffeisenbank Bad Doberan	GENODEF1DBR
3073	70091500	VB Raiffbk Dachau	GENODEF1DCA
3074	74160025	Raiffbk Deggendorf-Plattlg	GENODEF1DEG
3075	25069168	VB u RB Leinebgld Delligsen	GENODEF1DES
3076	74391300	VB-Raiffbk Dingolfing	GENODEF1DGF
3077	74190000	GenoBk DonauWald Viechtach	GENODEF1DGV
3078	76069409	Raiffeisenbank Dietenhofen	GENODEF1DIH
3079	28065108	VR-Bank Dinklage-Steinfeld	GENODEF1DIK
3080	76069410	Raiffeisenbank Dietersheim	GENODEF1DIM
3081	76591000	VR Bank Dinkelsbühl	GENODEF1DKV
3082	86065468	VR-Bank Mittelsachsen	GENODEF1DL1
3083	72262401	Raiff-VB Dillingen -alt-	GENODEF1DLG
3084	15091674	Volksbank Demmin	GENODEF1DM1
3085	72290100	Raiff-VB Donauwörth	GENODEF1DON
3086	26062433	VR-Bank in Südniedersachsen	GENODEF1DRA
3087	20069786	VB Kehdingen	GENODEF1DRO
3088	85090000	Dresdner VB Raiffbk	GENODEF1DRS
3089	80093574	Volksbank Dessau-Anhalt	GENODEF1DS1
3090	76069404	Raiffbk Uehlfeld-Dachsbach	GENODEF1DSB
3091	70091600	VR-Bank Landsberg-Ammersee	GENODEF1DSS
3092	75062026	Raiffbk Oberpfalz Süd	GENODEF1DST
3093	73369264	Raiffbk im Allg Land	GENODEF1DTA
3094	70169571	Raiffbk Tölzer Land	GENODEF1DTZ
3095	26061291	Volksbank Mitte	GENODEF1DUD
3096	21890022	Dithmarscher VB Heide	GENODEF1DVR
3097	86095554	Volksbank Delitzsch	GENODEF1DZ1
3098	79665540	Raiffbk Elsavatal	GENODEF1EAU
3099	53361724	Raiffbk Ebsdorfergrund	GENODEF1EBG
3100	77061425	Raiffeisen-Volksbank Ebern	GENODEF1EBR
3101	74369662	Raiffbk Buch-Eching	GENODEF1EBV
3102	28061822	Volksbank Oldenburg	GENODEF1EDE
3103	10060237	Ev Darlehnsgenossensch Bln	GENODEF1EDG
3104	21060237	Ev. Darlehnsgen. Kiel	GENODEF1EDG
3105	70169356	Raiffeisenbank Erding	GENODEF1EDR
3106	70091900	VR-Bank Erding	GENODEF1EDV
3107	79063060	Raiffbk Estenfeld-Bergtheim	GENODEF1EFD
3108	21092023	Eckernförder Bank VRB	GENODEF1EFO
3109	73369871	Raiffbk Baisweil-Eggent-Fr	GENODEF1EGB
3110	74391400	Rottaler VB-Raiffbk Eggenf	GENODEF1EGR
3111	72191300	Volksbank Eichstätt	GENODEF1EIH
3112	80063718	V- u Raiffbk Eisleben	GENODEF1EIL
3113	26261492	Volksbank Einbeck	GENODEF1EIN
3114	52060410	Ev Kreditgenossensch Kassel	GENODEF1EK1
3115	25060701	EKK Hannover	GENODEF1EK3
3116	50060500	EKK Frankfurt	GENODEF1EK4
3117	66060800	EKK Karlsruhe	GENODEF1EK5
3118	54760900	EKK Speyer	GENODEF1EK6
3119	82060800	EKK Eisenach	GENODEF1EK7
3120	70169351	Raiffbk Nordkreis Landsberg	GENODEF1ELB
3121	22190030	Volksbank Elmshorn	GENODEF1ELM
3122	28069109	Volksbank Emstek	GENODEF1EMK
3123	74369656	Raiffeisenbank Essenbach	GENODEF1ENA
3124	79668509	Raiffbk Eichenbühl u U	GENODEF1ENB
3125	76360033	VR-Bank EHH	GENODEF1ER1
3126	74362663	Raiffbk Altdorf-Ergolding	GENODEF1ERG
3127	79161058	Raiffbk Fränkisches Weinla	GENODEF1ERN
3128	82064088	VB u Raiffbk Eisenach	GENODEF1ESA
3129	28291551	VB Esens	GENODEF1ESE
3130	83094494	Volksbank Eisenberg	GENODEF1ESN
3131	28063526	VB Essen-Cappeln	GENODEF1ESO
3132	52260385	VR-Bank Werra-Meißner	GENODEF1ESW
3133	77069746	Raiffbk Emtmannsberg	GENODEF1ETB
3134	83094495	EthikBank Zndl Vb Eisenberg	GENODEF1ETK
3135	25862292	Volksbank Uelzen-Salzwedel	GENODEF1EUB
3136	70169333	Raiffbk Beuerberg-Eurasburg	GENODEF1EUR
3137	21392218	Volksbank Eutin	GENODEF1EUT
3138	87095899	VB Vogtland GAA	GENODEF1EXT
3139	52069519	Frankenberger Bank	GENODEF1FBK
3140	87096074	Freiberger Bank -alt-	GENODEF1FBV
3141	73369854	Raiffbk Fuchstal-Denklingen	GENODEF1FCH
3142	50060411	First Cash DZ BANK Ffm	GENODEF1FCS
3143	76069440	Raiffbk Altdorf-Feucht	GENODEF1FEC
3144	76069441	VR-Bank Feuchtwangen-Limes	GENODEF1FEW
3145	70163370	VR-Bank Fürstenfeldbruck	GENODEF1FFB
3146	75069038	Raiffbk Falkenstein-Wörth	GENODEF1FKS
3147	53064023	Raiffeisenbank Flieden	GENODEF1FLN
3148	75362039	Raiffeisenbank Floß	GENODEF1FLS
3149	70169505	Raiffbk Anzing-Forstern alt	GENODEF1FOA
3150	76391000	Volksbank Forchheim	GENODEF1FOH
3151	18062758	VR Bank Forst	GENODEF1FOR
3152	28066620	Spar-u Darlehnskasse	GENODEF1FOY
3153	73369878	Raiffbk Füssen-Pfronten-Nes	GENODEF1FPN
3154	20069812	VB Fredenbeck-Oldendorf	GENODEF1FRB
3155	76069448	Raiffbk Freudenberg -alt-	GENODEF1FRD
3156	70169614	Freisinger Bank VB-Raiffbk	GENODEF1FSR
3157	70169570	Raiffbk Thalheim -alt-	GENODEF1FTH
3158	76260451	Raiffeisen-Volksbank Fürth	GENODEF1FUE
3159	75069043	Raiffbk Furth -alt-	GENODEF1FUW
3160	17092404	VR Bank Fürstenwalde	GENODEF1FW1
3161	18062678	VR Bank Lausitz	GENODEF1FWA
3162	79364069	Raiffbk Frankenwinheim uU	GENODEF1FWH
3163	76069449	Raiffbk Berch-Freyst-Mühlh	GENODEF1FYS
3164	81093034	Volksbank Gardelegen	GENODEF1GA1
3165	70169470	Raiffeisenbank München-Süd	GENODEF1GAA
3166	72169812	Raiffbk Gaimersheim-Buxheim	GENODEF1GAH
3167	70390000	VR-Bank Werdenfels	GENODEF1GAP
3168	77069461	Vereinigte Raiffeisenbanken	GENODEF1GBF
3169	28062740	VB Bookholzberg-Lemwerder	GENODEF1GBH
3170	87095974	VB-RB Glauchau	GENODEF1GC1
3171	14061438	Raiffeisen-VB Gadebusch-alt	GENODEF1GDB
3172	76069462	Raiffbk Greding-Thalmässing	GENODEF1GDG
3173	79069150	Raiffbk Main-Spessart	GENODEF1GEM
3174	83064568	Geraer Bank	GENODEF1GEV
3175	77363749	Raiffeisenbank Gefrees	GENODEF1GFS
3176	70169382	Raiffeisenbank Gilching	GENODEF1GIL
3177	70169190	Raiffbk Tattenh Großkarol	GENODEF1GKT
3178	53062035	Raiffbk Großenlüder	GENODEF1GLU
3179	52069029	Spar-u Kredit-Bank Gemünden	GENODEF1GMD
3180	73369915	Raiffbk Obergermaringen alt	GENODEF1GMG
3181	86065483	Raiffeisenbank Grimma	GENODEF1GMR
3182	70169383	Raiffeisenbank Gmund am Teg	GENODEF1GMU
3183	86095484	VR-Bank Muldental Grimma	GENODEF1GMV
3184	81069048	VB Jerichower Land	GENODEF1GNT
3185	26090050	Volksbank Göttingen	GENODEF1GOE
3186	26361299	Volksbank Oberharz -alt-	GENODEF1GOH
3187	79069090	Raiffbk Ulsenheim-Gollh-alt	GENODEF1GOU
3188	74369088	Raiffbk Geiselhöring-Pfabg	GENODEF1GPF
3189	85591000	VB Raiffbk Niederschlesien	GENODEF1GR1
3190	28069128	Raiffeisenbank Garrel	GENODEF1GRR
3191	20069177	Raiffbk Südstormarn Mölln	GENODEF1GRS
3192	74069744	Raiffeisenbank Grainet	GENODEF1GRT
3193	75069050	Raiffbk Grafenwöhr-Kirchent	GENODEF1GRW
3194	72169080	Raiffbk Aresing-Gerolsbach	GENODEF1GSB
3195	28067170	VB Delmenhorst Schierbrok	GENODEF1GSC
3196	74366666	Raiffeisenbank Geisenhausen	GENODEF1GSH
3197	82064168	Raiffeisenbank Gotha	GENODEF1GTH
3198	76069468	Raiffbk Weißenburg-Gunzenh	GENODEF1GU1
3199	52062200	VR-Bank Chattengau	GENODEF1GUB
3200	14061308	VB u Raiffbk Güstrow	GENODEF1GUE
3201	13061028	Volksbank Raiffeisenbank	GENODEF1GW1
3202	77069042	Raiffbk Gößweinstein -alt-	GENODEF1GWE
3203	72091800	Volksbank Günzburg	GENODEF1GZ1
3204	72069043	Raiff-VB Dillingen-Burgau	GENODEF1GZ2
3205	79362081	VR-Bank Gerolzhofen	GENODEF1GZH
3206	20069800	Spar- und Kreditbank Hammah	GENODEF1HAA
3207	79062106	Raiffbk Hammelburg	GENODEF1HAB
3208	79568518	Raiffbk Haibach-Obernau	GENODEF1HAC
3209	80093784	VB Halle, Saale	GENODEF1HAL
3210	26691213	Volksbank Haren	GENODEF1HAR
3211	79363151	Raiff-VB Haßberge	GENODEF1HAS
3212	28069092	VR Bank Oldenburg Land West	GENODEF1HAT
3213	29190024	Bremische Volksbank	GENODEF1HB1
3214	29190330	Volksbank Bremen-Nord	GENODEF1HB2
3215	79063122	Raiffeisenbank Höchberg	GENODEF1HBG
3216	29290034	VB Bremerh-Wesermünde -alt-	GENODEF1HBV
3217	74161608	Raiffbk Hengersb-Schöllnach	GENODEF1HBW
3218	26261693	Volksbank Solling Hardegsen	GENODEF1HDG
3219	21565316	Raiffbk Handewitt	GENODEF1HDW
3220	75069061	Raiffbk Hemau-Kallmünz	GENODEF1HEM
3221	53260145	Raiffeisenbank Asbach-Sorga	GENODEF1HFA
3222	70169132	Raiffbk Griesstätt-Halfing	GENODEF1HFG
3223	75069055	Raiffbk Alteglofshm-Hagelst	GENODEF1HGA
3224	26565928	VB GMHütte-Hagen-Bissendorf	GENODEF1HGM
3225	20190206	VB Hamburg Ost-West -alt-	GENODEF1HH1
3226	20190003	Hamburger Volksbank	GENODEF1HH2
3227	20190301	Vierländer VB Hamburg	GENODEF1HH3
3228	20190109	VB Stormarn	GENODEF1HH4
3229	70169402	Raiffbk Höhenkirchen u U	GENODEF1HHK
3230	70169543	Raiffbk Isar-Loisachtal	GENODEF1HHS
3231	74069752	Raiffbk Hohenau-Mauth	GENODEF1HHU
3232	72169111	Raiffbk Hohenwart -alt-	GENODEF1HHW
3233	82094004	Volksbank Heiligenstadt	GENODEF1HIG
3234	25990011	Volksbank Hildesheim	GENODEF1HIH
3235	77069051	Raiffbk Heiligenstadt	GENODEF1HIS
3236	25791516	Volksbank Hankensbüttel	GENODEF1HKB
3237	26661380	Volksbank Haselünne	GENODEF1HLN
3238	23090142	Volksbank Lübeck	GENODEF1HLU
3239	70169388	Raiffbk Haag-Gars-Maitenb	GENODEF1HMA
3240	83064488	Raiffbk-VB Hermsdorf	GENODEF1HMF
3241	25791635	Volksbank Südheide	GENODEF1HMN
3242	25462160	VB Hameln-Stadthagen	GENODEF1HMP
3243	27190082	Volksbank Helmstedt	GENODEF1HMS
3244	27290087	VB Weserbergland Holzminden	GENODEF1HMV
3245	53262073	Raiffeisenbank Haunetal	GENODEF1HNT
3246	78060896	VR Bank Hof	GENODEF1HO1
3247	77069052	Raiffeisenbank Heroldsbach	GENODEF1HOB
3248	28069926	VB Niedergrafschaft	GENODEF1HOO
3249	25663584	Volksbank Aller-Weser	GENODEF1HOY
3250	76461485	Raiffbk am Rothsee	GENODEF1HPN
3251	13090000	Rostocker VR Bank	GENODEF1HR1
3252	52062601	VR-Bank Schwalm-Eder	GENODEF1HRV
3253	76061482	Raiffeisenbank Hersbruck	GENODEF1HSB
3254	76069486	Raiffbk Hirschau	GENODEF1HSC
3255	76069602	Raiffbk Seebachgrund-Heßdf	GENODEF1HSE
3256	13091054	Pommersche Volksbank	GENODEF1HST
3257	75069062	Raiffbk Herrnwahlthann-alt-	GENODEF1HTD
3258	22163114	Raiffbk Elbmarsch Heist	GENODEF1HTE
3259	72069105	Raiffeisenbank Hiltenfingen	GENODEF1HTF
3260	79566545	Raiffbk Heimbuchenthal-alt-	GENODEF1HTH
3261	28562863	Raiffeisenbank Moormerland	GENODEF1HTL
3262	26562490	VB Laer-Borgl-Hilter-Melle	GENODEF1HTR
3263	70169413	Raiffbk Singoldtal	GENODEF1HUA
3264	28062249	Volksbank Ganderkesee-Hude	GENODEF1HUD
3265	53061230	VR-Bank NordRhön Hünfeld	GENODEF1HUE
3266	21762550	Husumer Volksbank	GENODEF1HUM
3267	50690000	Frankfurter Volksbank	GENODEF1HUV
3268	77365792	Raiffbk Hollfeld-Waischenfd	GENODEF1HWA
3269	73369881	Raiffeisenbank Haldenwang	GENODEF1HWG
3270	13061078	VB u Raiffbk	GENODEF1HWI
3271	13061088	VB u Raiffbk -alt-	GENODEF1HWR
3272	13091084	VB u Raiffbk -alt-	GENODEF1HWV
3273	76069483	Raiffbk Herzogenaurach -alt	GENODEF1HZA
3274	72069113	Raiffeisenbank Aschberg	GENODEF1HZH
3275	74066749	Raiffbk i Südl Bay Wald	GENODEF1HZN
3276	70169410	Raiffbk Holzkirchen-Otterf	GENODEF1HZO
3277	72069114	Raiffeisenbank Holzheim	GENODEF1HZR
3278	72069119	Raiffeisenbank Ichenhausen	GENODEF1ICH
3279	73392000	Volksbank Immenstadt	GENODEF1IMV
3280	72160818	VR Bank Bayern Mitte	GENODEF1INP
3281	70169605	RVB Isen-Sempt	GENODEF1ISE
3282	70093400	Vb Raiffbk Ismaning	GENODEF1ISV
3283	80062608	Volksbank Elsterland	GENODEF1JE1
3284	72069123	Raiffbk Jettingen-Schep	GENODEF1JET
3285	28262254	Volksbank Jever	GENODEF1JEV
3286	81063028	Raiffbk Kalbe-Bismark	GENODEF1KAB
3287	28069878	Raiffbk Emsland-Mitte	GENODEF1KBL
3288	52360059	Waldecker Bank Korbach	GENODEF1KBW
3289	77361600	Raiff-VB Kronach-Ludwigssta	GENODEF1KC1
3290	77069044	Raiffbk Küps-Mitwitz-Stockh	GENODEF1KC2
3291	77069764	Raiffbk Kemnather Land	GENODEF1KEM
3292	73390000	Allgäuer Volksbank	GENODEF1KEV
3293	72069090	RB Bibertal-Kötz	GENODEF1KEZ
3294	73460046	VR Bk Kaufbeuren-Ostallgäu	GENODEF1KFB
3295	21090007	Kieler Volksbank	GENODEF1KIL
3296	21567360	Raiffbk Kleinjörl -alt-	GENODEF1KJO
3297	20069125	Kaltenkirchener Bank	GENODEF1KLK
3298	75069076	Raiffbk Kallmünz -alt-	GENODEF1KLM
3299	73369902	Raiffeisenbank Kempten-alt-	GENODEF1KM1
3300	80063628	Volksbank Köthen	GENODEF1KOE
3301	72069132	Raiffbk Krumbach/Schwaben	GENODEF1KRR
3302	79069145	Raiffbk Kreuzw-Hasl -alt-	GENODEF1KRW
3303	52060208	Kurhessische Landbk Kassel	GENODEF1KS2
3304	79190000	VR Bank Kitzingen	GENODEF1KT1
3305	75069081	Raiffeisenbank Bad Kötzting	GENODEF1KTZ
3306	77190000	Kulmbacher Bank	GENODEF1KU1
3307	28069930	VB Langen-Gersten	GENODEF1LAG
3308	28067257	Volksbank Lastrup	GENODEF1LAP
3309	24162898	Spar- u Darlehnskasse Börde	GENODEF1LAS
3310	76061025	Raiffbk Spar+Kreditbk Lauf	GENODEF1LAU
3311	73369821	BodenseeBank	GENODEF1LBB
3312	72169733	Rbk Berg im Gau-L -alt-	GENODEF1LBE
3313	25891483	VB Osterbg-Lüchow-Dannenbg	GENODEF1LCH
3314	26662932	Volksbank Lengerich	GENODEF1LEN
3315	28590075	Ostfriesische VB Leer	GENODEF1LER
3316	87065918	Raiffbk Werdau-Zwickau -alt	GENODEF1LGH
3317	74390000	VR-Bank Landshut	GENODEF1LH1
3318	73369826	Volksbank Lindenberg	GENODEF1LIA
3319	77091800	Raiff-VB Lichtenfels-Itzgrd	GENODEF1LIF
3320	26660060	Volksbank Lingen Ems	GENODEF1LIG
3321	85095164	LKG Dresden -alt-	GENODEF1LKG
3322	18092684	Spreewaldbank Lübben	GENODEF1LN1
3323	74191000	VR-Bank Landau	GENODEF1LND
3324	28065061	Volksbank Löningen	GENODEF1LOG
3325	79061153	Raiffeisenbank Lohr -alt-	GENODEF1LOH
3326	28062560	Volksbank Lohne-Mühlen	GENODEF1LON
3327	28069935	Raiffeisenbank Lorup	GENODEF1LRU
3328	50661639	VR Bk Main-Kinzig-Büdingen	GENODEF1LSR
3329	72069135	Raiffbk Stauden Langenneufn	GENODEF1LST
3330	28069991	Volksbank Emstal	GENODEF1LTH
3331	24090041	VB Lüneburg -alt-	GENODEF1LUE
3332	16062008	VR-Bank Fläming	GENODEF1LUK
3333	86095604	Leipziger Volksbank	GENODEF1LVB
3334	74369068	Raiffbk Hofkirchen-Bayerbch	GENODEF1LWE
3335	23061220	Raiffeisenbank Leezen	GENODEF1LZN
3336	70190000	Münchner Bank	GENODEF1M01
3337	70160300	Raiffbk München -alt-	GENODEF1M02
3338	70169466	Raiffeisenbank München-Süd	GENODEF1M03
3339	70090100	Hausbank München	GENODEF1M04
3340	75090300	LIGA Bank Regensburg	GENODEF1M05
3341	70130800	Merkur Bank München	GENODEF1M06
3342	70169464	Genossenschaftsbank	GENODEF1M07
3343	70169465	Raiffbk München-Nord	GENODEF1M08
3344	78160069	VR-Bank Fichtelgebirge	GENODEF1MAK
3345	15061698	Raiffeisenbank Malchin	GENODEF1MAL
3346	28361592	Raiff-VB Fresena	GENODEF1MAR
3347	87069075	VB Mittl Erzgebirge	GENODEF1MBG
3348	81093274	VB Magdeburg	GENODEF1MD1
3349	85095004	VB Raiffbk Meißen Großenh	GENODEF1MEI
3350	26661494	Emsländische VB Meppen	GENODEF1MEP
3351	77069868	Raiffeisenbank Oberland	GENODEF1MGA
3352	79065160	RB Marktheidenfeld -alt-	GENODEF1MHF
3353	70169598	Raiffbk im Oberland	GENODEF1MIB
3354	79690000	Raiff-VB Miltenberg	GENODEF1MIL
3355	73160000	Genobank Unterallgäu	GENODEF1MIR
3356	87096124	Volksbank Mittweida	GENODEF1MIW
3357	20190800	MKB Hamburg	GENODEF1MKB
3358	74369704	Raiffbk Mengkofen-Loiching	GENODEF1MKO
3359	84064798	Genobank Rhön-Grabfeld	GENODEF1MLF
3360	28069755	Raiffeisenbank Oldersum	GENODEF1MLO
3361	79069165	Genobank Rhön-Grabfeld	GENODEF1MLV
3362	73190000	VR-Bank Memmingen	GENODEF1MM1
3363	28563749	Raiffeisenbank Moormerland	GENODEF1MML
3364	23062807	Volks- u Raiffbk Mölln -alt	GENODEF1MOE
3365	70169460	Raiffbk Westkreis	GENODEF1MOO
3366	72069155	Raiffbk Kissing-Mering	GENODEF1MRI
3367	26566939	VB Osnabrücker Nd	GENODEF1MRZ
3368	72062152	VR-Bank HG-Bank	GENODEF1MTG
3369	70169459	Raiffeisenbank Mittenwald	GENODEF1MTW
3370	82064038	VR Bank Westthüringen	GENODEF1MU2
3371	70090124	Hausbank München Gf Wohnung	GENODEF1MU4
3372	25069270	Volksbank Aller-Oker	GENODEF1MUA
3373	71191000	VR-Bank Burghausen-Mühldorf	GENODEF1MUL
3374	76060618	VR Bank Nürnberg	GENODEF1N02
3375	76090400	Evenord-Bank Nürnberg	GENODEF1N03
3376	76060561	EKK Nürnberg	GENODEF1N05
3377	76069512	Raiffbk Knoblauchsland	GENODEF1N08
3378	70169476	Raiffbk -alt-	GENODEF1NBK
3379	24060300	VB Lüneburger Heide	GENODEF1NBU
3380	72169756	RV Neuburg/Donau	GENODEF1ND2
3381	26760005	Raiff- u VB Nordhorn -alt-	GENODEF1NDH
3382	79069181	Raiffeisenbank Nüdlingen	GENODEF1NDL
3383	20069111	Norderstedter Bank	GENODEF1NDR
3384	82094054	Nordthüringer Volksbank	GENODEF1NDS
3385	79363016	VR-Bank Rhön-Grabfeld	GENODEF1NDT
3386	76069559	VR-Bank Uffenheim-Neustadt	GENODEF1NEA
3387	28067068	VB Neuenkirchen-Vörden	GENODEF1NEO
3388	28069956	Grafschafter Volksbank	GENODEF1NEV
3389	75363189	Raiffbk Neustadt-Vohenstr	GENODEF1NEW
3390	70169472	Raiffbk Hallbergmoos-Neuf	GENODEF1NFA
3391	75069015	Raiffbk Bad Gögging	GENODEF1NGG
3392	85590100	VB Löbau-Zittau	GENODEF1NGS
3393	74069768	Raiffbk am Dreisessel	GENODEF1NHD
3394	28064241	Raiff-VB Varel-Nordenham	GENODEF1NHE
3395	76069552	Raiffeisenbank Neuhof -alt-	GENODEF1NHF
3396	25690009	Volksbank Nienburg	GENODEF1NIN
3397	75069110	RB Eschlk-Lam-Lohb-Neukirch	GENODEF1NKN
3398	76069553	Raiffeisenbank Neumarkt	GENODEF1NM1
3399	80063648	Volks-Raiffbk Saale-Unstrut	GENODEF1NMB
3400	21290016	VR Bank Neumünster	GENODEF1NMS
3401	77069556	Raiffbk Neunkirchen Brand	GENODEF1NNK
3402	72069329	Raiffeisen-Volksbank Ries	GENODEF1NOE
3403	26567943	VR-Bank i.Altkr.Bersenbrück	GENODEF1NOP
3404	16061938	Raiffeisenbank Ostpr-Ruppin	GENODEF1NPP
3405	21390008	VR Bk Ostholstein Nord-Plön	GENODEF1NSH
3406	25069262	Raiff-VB Neustadt	GENODEF1NST
3407	70169474	Raiffbk NSV-NBK -alt-	GENODEF1NSV
3408	21463603	VB-Raiffbk i Kr Rendsburg	GENODEF1NTO
3409	73061191	VR-Bank Neu-Ulm/Weißenhorn	GENODEF1NU1
3410	74061564	Raiffbk Unteres Inntal	GENODEF1NUI
3411	73090000	Volksbank Neu-Ulm	GENODEF1NUV
3412	53261700	Raiffbk Aulatal Kirchheim	GENODEF1OAU
3413	71162355	Raiffeisenbank Oberaudorf	GENODEF1OBD
3414	79666548	Raiffbk Großostheim-Obernbg	GENODEF1OBE
3415	81093044	VB Osterbg-Lüchow-Dannenbg	GENODEF1OBG
3416	79161499	Raiffbk Kitzinger Land	GENODEF1OBR
3417	70169493	Raiffbk Oberschleißheim alt	GENODEF1OBS
3418	79061000	Raiffbk Ochsenfurt -alt-	GENODEF1OCH
3419	70169186	Raiffbk Pfaffenhofen Glonn	GENODEF1ODZ
3420	72069181	Raiffeisenbank Offingen	GENODEF1OFF
3421	10030600	North Channel Bank Mainz	GENODEF1OGK
3422	26891484	Volksbank im Harz	GENODEF1OHA
3423	70166486	VR Bank München Land	GENODEF1OHC
3424	29162394	Volksbank	GENODEF1OHZ
3425	73369918	Raiffeisenbank Kirchweihtal	GENODEF1OKI
3426	28060228	Raiffbk Oldenburg	GENODEF1OL2
3427	28069052	Raiffbk Strückl.-Idafehn	GENODEF1ORF
3428	74061670	Raiffbk Ortenburg-Kirchberg	GENODEF1ORT
3429	26590025	Volksbank Osnabrück	GENODEF1OSV
3430	20069641	Raiffeisenbank Owschlag	GENODEF1OWS
3431	29165545	Volksbank Oyten	GENODEF1OYT
3432	10090900	PSD Bank Berlin	GENODEF1P01
3433	27090900	PSD Bank Braunschweig	GENODEF1P02
3434	29090900	PSD Bank Nord Bremen	GENODEF1P03
3435	44090920	PSD Bank Dortmund -alt-	GENODEF1P04
3436	30060992	PSD Bank Rhein-Ruhr	GENODEF1P05
3437	50090900	PSD Bank Hessen-Thüringen	GENODEF1P06
3438	68090900	PSD Bank RheinNeckarSaar	GENODEF1P07
3439	20090900	PSD Bank Nord Hamburg	GENODEF1P08
3440	25090900	PSD Bank Hannover	GENODEF1P09
3441	66090900	PSD Bank Karlsruhe-Neustadt	GENODEF1P10
3442	21090900	PSD Bank Kiel	GENODEF1P11
3443	57090900	PSD Bank Koblenz	GENODEF1P12
3444	37060993	PSD Bank Köln	GENODEF1P13
3445	72090900	PSD Bank München Augsburg	GENODEF1P14
3446	40090900	PSD Bank Westfalen-Lippe	GENODEF1P15
3447	76090900	PSD Bank Nürnberg	GENODEF1P17
3448	75090900	PSD Bank Niederbay.-Oberpf.	GENODEF1P18
3449	59090900	PSD Bank RheinNeckarSaar	GENODEF1P19
3450	60090900	PSD Bank RheinNeckarSaar	GENODEF1P20
3451	58590900	PSD Bank Trier	GENODEF1P21
3452	74090000	VR-Bank Passau	GENODEF1PA1
3453	28591579	Volksbank Papenburg	GENODEF1PAP
3454	75069094	Raiffbk Parsberg-Velburg	GENODEF1PAR
3455	25193331	Volksbank	GENODEF1PAT
3456	53062350	Raiffbk Biebergrd-Petersbg	GENODEF1PBG
3457	70169509	Raiffbk Pfaffenwinkel	GENODEF1PEI
3458	16060122	Volks- u Raiffbk Prignitz	GENODEF1PER
3459	25260010	Volksbank Peine	GENODEF1PEV
3460	72069789	Raiffbk Pfaffenhausen	GENODEF1PFA
3461	74364689	Raiffbk Pfeffenhausen	GENODEF1PFF
3462	72191600	Hallertauer Volksbank	GENODEF1PFI
3463	74061813	VR-Bank Rottal-Inn	GENODEF1PFK
3464	22191405	VR Bank Pinneberg	GENODEF1PIN
3465	87095824	Volksbank Vogtland	GENODEF1PL1
3466	83094444	Raiff-VB Saale-Orla	GENODEF1PN1
3467	74067000	Rottaler Raiffbk	GENODEF1POC
3468	85060000	VB Pirna	GENODEF1PR2
3469	77069110	Raiffbk Pretzfeld -alt-	GENODEF1PRE
3470	71161964	VB-Raiffbk Chiemsee -alt-	GENODEF1PRV
3471	74369130	Raiffeisenbank Parkstetten	GENODEF1PST
3472	15091704	VR-Bank Uckermark-Randow	GENODEF1PZ1
3473	70391800	VB-Raiffbk Penzberg -alt-	GENODEF1PZB
3474	80063508	Ostharzer Volksbank	GENODEF1QLB
3475	75090000	Volksbank Regensburg	GENODEF1R01
3476	75060150	Raiffbk Regensburg-Wenzenb	GENODEF1R02
3477	53261342	Raiffbk Werratal-Landeck	GENODEF1RAW
3478	72169831	Raiffbk Riedenburg-Lobs	GENODEF1RBL
3479	50663699	Raiffbk Rodenbach Hanau	GENODEF1RDB
3480	75061851	Raiffeisenbank Regenstauf	GENODEF1REF
3481	72069209	Raiffeisenbank Roggenburg	GENODEF1RGB
3482	74164149	VR-Bank	GENODEF1RGE
3483	74061101	Raiffbk Am Goldenen Steig	GENODEF1RGS
3484	21860418	Raiffeisenbank Heide	GENODEF1RHE
3485	73369933	Raiffbk Südliches Ostallgäu	GENODEF1RHP
3486	70169693	Raiffeisenbank Hallertau	GENODEF1RHT
3487	85094984	Volksbank Riesa	GENODEF1RIE
3488	70169521	Raiffeisenbank Raisting	GENODEF1RIG
3489	22260136	Raiffbk Itzehoe -alt-	GENODEF1RIT
3490	70169168	VR-Bank Chiemgau-Süd -alt-	GENODEF1RIW
3491	23063129	Raiffeisenbank Lauenburg	GENODEF1RLB
3492	72261754	Raiffeisenbank Rain am Lech	GENODEF1RLH
3493	72069193	Raiffeisenbank Rehling	GENODEF1RLI
3494	20069882	Raiffbk Travemünde -alt-	GENODEF1RLT
3495	70169524	Raiffeisenbank RSA	GENODEF1RME
3496	16091994	Volksbank Rathenow	GENODEF1RN1
3497	79069213	Raiffeisenbank Maßbach	GENODEF1RNM
3498	53262455	Raiffeisenbank Ronshausen	GENODEF1ROH
3499	71160161	VR Bank Rosenheim-Chiemsee	GENODEF1ROR
3500	79069192	Raiffeisenbank Obernbreit	GENODEF1ROU
3501	71190000	Volksbank Rosenheim -alt-	GENODEF1ROV
3502	20069861	Raiffeisenbank Ratzeburg	GENODEF1RRZ
3503	28062165	Raiffeisenbank Rastede	GENODEF1RSE
3504	21661719	VR Bank Flensburg-Schleswig	GENODEF1RSL
3505	76069598	Raiffeisenbank Roßtal	GENODEF1RSS
3506	76069601	VR-Bank Rothenburg	GENODEF1RT2
3507	27131300	Rautenschlein Schöningen	GENODEF1RTS
3508	83094454	Volksbank Saaletal	GENODEF1RUJ
3509	70169530	Raiffbk Neumarkt-Reischach	GENODEF1RWZ
3510	74369146	Raiffbk Rattiszell-Konzell	GENODEF1RZK
3511	55090500	Sparda-Bank Südwest	GENODEF1S01
3512	60090800	Sparda-Bank Baden-Württemb	GENODEF1S02
3513	72090500	Sparda-Bank Augsburg	GENODEF1S03
3514	70090500	Sparda-Bank München	GENODEF1S04
3515	75090500	Sparda-Bank Ostbayern	GENODEF1S05
3516	76090500	Sparda-Bank Nürnberg	GENODEF1S06
3517	40060560	Sparda-Bank Münster	GENODEF1S08
3518	25090500	Sparda-Bank Hannover	GENODEF1S09
3519	12096597	Sparda-Bank Berlin	GENODEF1S10
3520	20690500	Sparda-Bank Hamburg	GENODEF1S11
3521	50090500	Sparda-Bank Hessen	GENODEF1S12
3522	77390500	Sparda-Bank Nürnberg	GENODEF1S13
3523	76091000	Sparda-Bk Nürnbg Sonnenstr	GENODEF1S14
3524	20090500	netbank	GENODEF1S15
3525	84094754	VR-Bank Bad Salzungen	GENODEF1SAL
3526	28065286	Raiffeisenbank Scharrel	GENODEF1SAN
3527	70169165	Raiffbk Chiemgau-Nord-Obing	GENODEF1SBC
3528	72169218	Schrobenhausener Bank	GENODEF1SBN
3529	24191015	Volksbank Stade-Cuxhaven	GENODEF1SDE
3530	81093054	Volksbank Stendal	GENODEF1SDL
3531	76069611	Raiffbk Unteres Vilstal	GENODEF1SDM
3532	85065028	Raiffbk Neustadt Sachs -alt	GENODEF1SEB
3533	73369936	Raiffeisenbank Seeg -alt-	GENODEF1SER
3534	27893760	Volksbank Seesen	GENODEF1SES
3535	77069091	Raiffeisenbank Ebrachgrund	GENODEF1SFD
3536	77062139	Raiff-VB Bad Staffelstein	GENODEF1SFF
3537	73369920	Raiffbk Kempten-Oberallgäu	GENODEF1SFO
3538	70169558	Raiffeisenbank Steingaden	GENODEF1SGA
3539	80063558	Volksbank Sangerhausen	GENODEF1SGH
3540	70169495	Raiffbk Buchbach-Schwi-alt-	GENODEF1SGO
3541	84094814	VR Bank Südthüringen	GENODEF1SHL
3542	29167624	Volksbank Syke	GENODEF1SHR
3543	72191800	VB Schrobenhausen -alt-	GENODEF1SHV
3544	24161594	Zevener Volksbank	GENODEF1SIT
3545	79662558	Raiffbk Schöllkrippen -alt-	GENODEF1SKP
3546	25991528	VB Hildesheimer Börde	GENODEF1SLD
3547	83065408	VR-Bank ABG-Land / Skatbank	GENODEF1SLR
3548	21690020	Schleswiger Volksbank	GENODEF1SLW
3549	79069188	Raiffeisenbank im Grabfeld	GENODEF1SLZ
3550	72069220	Raiffbk Schwabmünchen	GENODEF1SMU
3551	14091464	VR-Bank Schwerin	GENODEF1SN1
3552	25891636	VB Lüneburger Heide -alt-	GENODEF1SOL
3553	52063369	VR-Bank Spangenbg-Morschen	GENODEF1SPB
3554	77069782	Raiffeisenbank am Kulm	GENODEF1SPK
3555	28069994	Volksbank Süd-Emsland	GENODEF1SPL
3556	18092744	Volksbank Spree-Neiße	GENODEF1SPM
3557	74290000	Volksbank Straubing	GENODEF1SR1
3558	74260110	Raiffeisenbank Straubing	GENODEF1SR2
3559	70169331	Raiffbk sö Starnberger See	GENODEF1SSB
3560	84069065	Raiffeisenbank Schleusingen	GENODEF1SSG
3561	20069144	Raiffeisenbank Seestermühe	GENODEF1SST
3562	77065141	Raiffbk Stegaurach -alt-	GENODEF1STC
3563	70093200	VR-Bank Starnberg-Hg-Lbg	GENODEF1STH
3564	52069503	Raiffbk Ulmbach -alt-	GENODEF1STU
3565	20069232	Raiffbk Struvenhütten	GENODEF1STV
3566	25662540	Volksbank Steyerberg	GENODEF1STY
3567	25691633	Volksbank Sulingen	GENODEF1SUL
3568	29165681	Volksbank Sottrum	GENODEF1SUM
3569	75069171	Raiffbk im Naabtal	GENODEF1SWD
3570	75061168	Raiffbk Schwandorf-Nittenau	GENODEF1SWN
3571	70169538	Raiffbk St Wolfgang-Schwind	GENODEF1SWO
3572	76460015	Raiffbk Roth-Schwabach	GENODEF1SWR
3573	29162453	Volksbank Schwanewede	GENODEF1SWW
3574	21791805	Sylter Bank	GENODEF1SYL
3575	77069870	Raiffbk Hochfranken West	GENODEF1SZF
3576	75261700	Raiffbk Sulzbach-Rosenberg	GENODEF1SZH
3577	74065782	Raiffbk Salzweg-Thyrnau	GENODEF1SZT
3578	75069078	Raiffeisenbank Sinzing	GENODEF1SZV
3579	70169568	Raiffbk Taufk-Oberneukirch	GENODEF1TAE
3580	70169566	VR-Bank Taufkirchen-Dorfen	GENODEF1TAV
3581	52069103	Raiffeisenbank Trendelburg	GENODEF1TBG
3582	70169191	Raiffbk Rupertiwinkel	GENODEF1TEI
3583	86069070	Raiffeisenbank Torgau	GENODEF1TGB
3584	77069739	Raiffbk Thurnauer Land	GENODEF1THA
3585	70169541	Raiffbk Lech-Ammersee	GENODEF1THG
3586	79069271	Raiffbk Thüngersheim	GENODEF1THH
3587	72069235	Raiffeisenbank Thannhausen	GENODEF1THS
3588	74062786	Raiffbk i Lkr Passau-Nord	GENODEF1TIE
3589	74069758	Raiffbk Kirchberg	GENODEF1TKI
3590	21464671	Raiffbk Todenbüttel	GENODEF1TOB
3591	70169575	Raiffeisenbank Türkheim	GENODEF1TRH
3592	70169195	Raiffbk Trostberg-Traunreut	GENODEF1TRU
3593	70169576	Raiff-Volksbank Tüßling	GENODEF1TUS
3594	28069955	Volksbank Uelsen	GENODEF1UEL
3595	76561979	Raiffbk Uffenheim -alt-	GENODEF1UFF
3596	70169585	Raiffbk Unterschleißh-H-alt	GENODEF1UNS
3597	28562297	RVB Aurich	GENODEF1UPL
3598	76069635	RB Ursens-Ammerth-Hohen alt	GENODEF1URS
3599	28069138	VR Bank Oldenburg Land West	GENODEF1VAG
3600	28262673	Raiff-VB Varel-Nordenham	GENODEF1VAR
3601	50890000	VB Darmstadt - Südhessen	GENODEF1VBD
3602	74392300	VR-Bank Vilsbiburg	GENODEF1VBV
3603	26261396	Volksbank Dassel -alt-	GENODEF1VDA
3604	28064179	Volksbank Vechta	GENODEF1VEC
3605	29162697	Volksbank Aller-Weser	GENODEF1VER
3606	74062490	Raiffbk Vilshofener Land	GENODEF1VIR
3607	28066103	Volksbank Visbek	GENODEF1VIS
3608	22290031	VB Raiffbk Itzehoe	GENODEF1VIT
3609	74092400	Volksbank Vilshofen	GENODEF1VIV
3610	50060412	DZ BANK Gf vK	GENODEF1VK1
3611	50060413	DZ BANK Gf VK 2	GENODEF1VK2
3612	50060414	DZ BANK Gf VK 3	GENODEF1VK3
3613	52069149	Raiffbk Volkmarsen	GENODEF1VLM
3614	26890019	Volksbank Nordharz	GENODEF1VNH
3615	71160000	VB RB Rosenheim-Chiemsee	GENODEF1VRR
3616	79565568	Raiffeisenbank Waldaschaff	GENODEF1WAA
3617	70362595	Raiffbk Wallgau-Krün	GENODEF1WAK
3618	21261089	Raiffeisenbank Wasbek -alt-	GENODEF1WAS
3619	80063598	Volksbank Wittenberg	GENODEF1WB1
3620	76069663	Raiffbk Heilsbr-Windsbach	GENODEF1WBA
3621	25069370	VB Vechelde-Wendeburg	GENODEF1WBU
3622	72169745	Raiffbk Ehekirchen-Oberhsn	GENODEF1WDF
3623	28066214	VB Wildeshauser Geest	GENODEF1WDH
3624	72069308	RVB Wemding	GENODEF1WDN
3625	76069372	Raiffbk Bad Windsheim	GENODEF1WDS
3626	82064188	VR Bank Weimar	GENODEF1WE1
3627	79069001	Raiffbk Volkach-Wiesentheid	GENODEF1WED
3628	28562716	Raiffbk Flachsmeer Westover	GENODEF1WEF
3629	70169599	Raiffeisenbank Weil u Umgeb	GENODEF1WEI
3630	75360011	Raiffeisenbank Weiden	GENODEF1WEO
3631	75390000	Volksbank Nordoberpfalz	GENODEF1WEV
3632	72169246	Raiffbk Schrobenhausener Ld	GENODEF1WFN
3633	27092555	VB Wolfenbüttel-Salzgitter	GENODEF1WFV
3634	73369954	Raiffbk Wald-Görisried	GENODEF1WGO
3635	76211900	CVW - Privatbank	GENODEF1WHD
3636	26563960	VB Bramgau-Wittlage	GENODEF1WHO
3637	28290063	Volksbank Wilhelmshaven	GENODEF1WHV
3638	74369709	Raiffeisenbank Wildenberg	GENODEF1WIG
3639	25761894	Volksbank Wittingen-Klötze	GENODEF1WIK
3640	20069965	VB Winsener Marsch	GENODEF1WIM
3641	28069381	Hümmlinger Volksbank	GENODEF1WLT
3642	70169602	Raiffeisenbank Weilheim alt	GENODEF1WM1
3643	26991066	Volksbank Brawo	GENODEF1WOB
3644	13061008	Volksbank Wolgast	GENODEF1WOG
3645	52063550	Raiffbk	GENODEF1WOH
3646	29166568	Volksbank Worpswede	GENODEF1WOP
3647	25863489	VB Osterbg-Lüchow-Dannenbg	GENODEF1WOT
3648	28063253	Volksbank Westerstede	GENODEF1WRE
3649	28591654	Volksbank Westrhauderfehn	GENODEF1WRH
3650	72169764	Raiffbk Donaumooser Land	GENODEF1WRI
3651	15061618	Raiffbk Mecklenb Seenplatte	GENODEF1WRN
3652	74064593	Raiffeisenbank Wegscheid	GENODEF1WSD
3653	78161575	Raiffbk im Stiftland Walds	GENODEF1WSS
3654	77069906	Raiffbk Wüstenselbitz	GENODEF1WSZ
3655	26562694	VB Wittlage Bohmte -alt-	GENODEF1WTB
3656	72069263	Raiffeisenbank Wittislingen	GENODEF1WTS
3657	79090000	VR-Bank Würzburg	GENODEF1WU1
3658	20069989	Volksbank Wulfsen	GENODEF1WUL
3659	73369823	Raiffeisenbank Westallgäu	GENODEF1WWA
3660	28069773	Raiffbk Wiesederm-Wiesede-M	GENODEF1WWM
3661	70169596	Raiffbk Walpertskirchen alt	GENODEF1WWO
3662	21791906	Föhr-Amrumer Bank	GENODEF1WYK
3663	81069052	Volksbank Börde-Bernburg	GENODEF1WZL
3664	87095934	Volksbank Zwickau	GENODEF1Z01
3665	76069669	Raiffeisenbank Zirndorf	GENODEF1ZIR
3666	70169619	Raiffeisenbank Zorneding	GENODEF1ZOR
3667	77069908	Raiffbk Sparn-Stammb-Zell	GENODEF1ZSP
3668	80063678	VR-Bank Zeitz	GENODEF1ZTZ
3669	72069274	Raiffbk Augsburger Ld West	GENODEF1ZUS
3670	12060000	DZ BANK	GENODEFF120
3671	20060000	DZ BANK	GENODEFF200
3672	25060000	DZ BANK	GENODEFF250
3673	25060000	DZ BANK Hannover	GENODEFF280
3674	52060000	DZ BANK	GENODEFF520
3675	70160000	DZ BANK München	GENODEFF701
3676	76060000	DZ BANK	GENODEFF760
3677	50060400	DZ BANK	GENODEFFXXX
3678	41262501	VB Ahlen-Sassenberg-Warendf	GENODEM1AHL
3679	45660029	Volksbank Altena -alt-	GENODEM1ALA
3680	46462271	SpDK Oeventrop	GENODEM1ANO
3681	41661206	Volksbank Anröchte	GENODEM1ANR
3682	41061903	BAG Bankaktienges Hamm	GENODEM1BAG
3683	40069408	Volksbank Baumberge	GENODEM1BAU
3684	46063405	Volksbank Wittgenstein	GENODEM1BB1
3685	41260006	Volksbank Beckum -alt-	GENODEM1BEK
3686	45260475	Spar- und Kreditbank	GENODEM1BFG
3687	48060036	Bielefelder Volksbank	GENODEM1BIE
3688	47260307	Bank für Kirche und Caritas	GENODEM1BKC
3689	41062215	Volksbank Bönen	GENODEM1BO1
3690	42861387	VR-Bank Westmünsterland	GENODEM1BOB
3691	43060129	Volksbank Bochum Witten	GENODEM1BOC
3692	42861515	Volksbank Gemen	GENODEM1BOG
3693	42860003	Volksbank Bocholt	GENODEM1BOH
3694	47267216	Volksbank Borgentreich-alt-	GENODEM1BOT
3695	41661719	Volksbank Brilon -alt-	GENODEM1BRI
3696	48291490	Volksbank Bad Salzuflen	GENODEM1BSU
3697	40069371	Volksbank Thülen	GENODEM1BTH
3698	40166800	Volksbank Buldern -alt-	GENODEM1BUL
3699	47261603	VB Brilon-Büren-Salzkotten	GENODEM1BUS
3700	40069601	Volksbank Ascheberg-Herbern	GENODEM1CAN
3701	40069636	Volksbank Lette -alt-	GENODEM1CLE
3702	47861317	VB im Ostmünsterland	GENODEM1CLL
3703	40069226	Volksbank Lette-Darup-Rorup	GENODEM1CND
3704	40164352	Volksbank Nottuln	GENODEM1CNO
3705	40060265	DKM Darlehnskasse Münster	GENODEM1DKM
3706	47262703	VB Delbrück-Hövelhof	GENODEM1DLB
3707	40069709	Volksbank Lembeck-Rhade	GENODEM1DLR
3708	44060122	Volksbank Dortmund-Nordwest	GENODEM1DNW
3709	44160014	Dortmunder Volksbank	GENODEM1DOR
3710	42662320	Volksbank Dorsten	GENODEM1DST
3711	40069477	Volksbank Wulfen -alt-	GENODEM1DWU
3712	41261324	VB Enniger-Ostenfelde-Westk	GENODEM1EOW
3713	49061510	Volksbank Eisbergen -alt-	GENODEM1EPW
3714	40069606	Volksbank Erle	GENODEM1ERR
3715	49461323	Volksbank Enger-Spenge -alt	GENODEM1ESP
3716	47260234	VB Elsen-Wewer-Borchen	GENODEM1EWB
3717	46061724	VR-Bank Freudenb.-Niederfi.	GENODEM1FRF
3718	36060488	GENO BANK ESSEN	GENODEM1GBE
3719	42260001	VB Ruhr Mitte Gelsenkirchen	GENODEM1GBU
3720	40164901	Volksbank Gescher	GENODEM1GE1
3721	46261607	Volksbank Grevenbrück	GENODEM1GLG
3722	43060967	GLS Gemeinschaftsbk Bochum	GENODEM1GLS
3723	40164024	Volksbank Gronau-Ahaus	GENODEM1GRN
3724	40061238	Volksbank Greven	GENODEM1GRV
3725	47860125	VB Bielefeld-Gütersloh	GENODEM1GTL
3726	41061011	Spar-u Darlehnskasse	GENODEM1HBH
3727	42861608	Volksbank Heiden	GENODEM1HEI
3728	49490070	VB Bad Oeynhausen-Herford	GENODEM1HFV
3729	45060009	Märkische Bank Hagen	GENODEM1HGN
3730	45061524	Volksbank Hohenlimburg	GENODEM1HLH
3731	42661330	Volksbank Haltern	GENODEM1HLT
3732	48062051	Volksbank Halle/Westf	GENODEM1HLW
3733	41060120	Volksbank Hamm -alt-	GENODEM1HMM
3734	41663335	Volksbank Hörste	GENODEM1HOE
3735	40363433	Volksbank Hörstel -alt-	GENODEM1HRL
3736	46262456	Volksbank Bigge-Lenne -alt-	GENODEM1HUL
3737	42661522	VB Herten-Westerholt -alt-	GENODEM1HWE
3738	47861518	Volksbank Harsewinkel -alt-	GENODEM1HWI
3739	40361906	VR-Bank Kreis Steinfurt	GENODEM1IBB
3740	45861434	Volksbank Kierspe	GENODEM1KIE
3741	42461435	Volksbank Kirchhellen	GENODEM1KIH
3742	44361342	VB Kamen-Werne	GENODEM1KWK
3743	40164256	VB Laer-Horstmar-Leer	GENODEM1LAE
3744	41661504	VB Benninghausen -alt-	GENODEM1LBH
3745	45860033	Volksbank Lüdenscheid -alt-	GENODEM1LHA
3746	40164528	VB Lüdinghausen-Olfen	GENODEM1LHN
3747	40166439	VB Lengerich/Lotte -alt-	GENODEM1LLE
3748	47861907	Volksbank Langenberg -alt-	GENODEM1LNB
3749	41660124	Volksbank Beckum-Lippstadt	GENODEM1LPS
3750	40069622	Volksbank Seppenrade	GENODEM1LSP
3751	49092650	Volksbank Lübbecker Land	GENODEM1LUB
3752	40069600	Volksbank Amelsbüren	GENODEM1MAB
3753	40069266	Volksbank Marsberg	GENODEM1MAS
3754	40069348	Volksbank Medebach -alt-	GENODEM1MDB
3755	44761312	Mendener Bank	GENODEM1MEN
3756	47862261	Volksbank Marienfeld -alt-	GENODEM1MFD
3757	49060392	Volksbank Minden	GENODEM1MND
3758	45861617	Volksbank Meinerzhagen -alt	GENODEM1MOM
3759	49060127	Volksbank Mindener Land	GENODEM1MPW
3760	42661008	VB Marl-Recklinghausen	GENODEM1MRL
3761	40160050	Volksbank Münster	GENODEM1MSC
3762	40069462	Volksbank Sprakel	GENODEM1MSS
3763	46660022	Volksbank Sauerland	GENODEM1NEH
3764	48262248	Volksbank Nordlippe -alt-	GENODEM1NLE
3765	44761534	VB im Märkischen Kreis	GENODEM1NRD
3766	41261419	VB Oelde-Ennigerloh-Neubeck	GENODEM1OEN
3767	47691200	Volksbank Ostlippe	GENODEM1OLB
3768	46260023	Volksbank Olpe -alt-	GENODEM1OLP
3769	40164618	Volksbank Ochtrup	GENODEM1OTR
3770	42862451	Volksbank Raesfeld	GENODEM1RAE
3771	46464453	Volksbank Reiste-Eslohe	GENODEM1RET
3772	42861814	Volksbank Rhede	GENODEM1RHD
3773	42861239	Spar-u Darlehnskasse Reken	GENODEM1RKN
3774	47862447	Volksbank Rietberg	GENODEM1RNE
3775	40069362	Volksbank Saerbeck	GENODEM1SAE
3776	40069716	Volksbank Nordkirchen	GENODEM1SCN
3777	41262621	Ver VB Telgte	GENODEM1SDH
3778	40069546	Volksbank Senden	GENODEM1SDN
3779	40163720	VB Nordmünsterland Rheine	GENODEM1SEE
3780	40165366	Volksbank Selm-Bork	GENODEM1SEM
3781	41662465	Volksbank Störmede	GENODEM1SGE
3782	48062466	Spar-u Darlehnskasse	GENODEM1SHS
3783	40069283	Volksbank Schlangen	GENODEM1SLN
3784	46062817	Volksbank Bigge-Lenne	GENODEM1SMA
3785	40069363	Volksbank Schermbeck	GENODEM1SMB
3786	49262364	Volksbank Schnathorst	GENODEM1SNA
3787	46060040	Volksbank Siegerland Siegen	GENODEM1SNS
3788	41460116	Volksbank Hellweg	GENODEM1SOE
3789	45261547	Volksbank Sprockhövel	GENODEM1SPO
3790	46461126	Volksbank Sauerland -alt-	GENODEM1SRL
3791	47264367	Vereinigte Volksbank	GENODEM1STM
3792	49061470	VB Stemweder Berg -alt-	GENODEM1STR
3793	49061298	VB Bad Oeynhausen -alt-	GENODEM1UBO
3794	44360002	Volksbank Unna Schwerte-alt	GENODEM1UNA
3795	47861806	Volksbank Kaunitz	GENODEM1VKA
3796	47863373	Volksbank Versmold	GENODEM1VMD
3797	47265383	VB Wewelsburg-Ahden	GENODEM1WAH
3798	47460028	VB Warburger Land -alt-	GENODEM1WBG
3799	46261822	VB Olpe-Wenden-Drolshagen	GENODEM1WDD
3800	47262626	Volksbank Westenholz	GENODEM1WDE
3801	40361627	VB Westerkappeln-Wersen	GENODEM1WKP
3802	40060300	WL BANK Münster	GENODEM1WLM
3803	42661717	Volksbank Waltrop	GENODEM1WLW
3804	47261429	Volksbank Haaren -alt-	GENODEM1WNH
3805	41462295	Volksbank Wickede (Ruhr)	GENODEM1WRU
3806	41662557	VB Warstein-Belecke -alt-	GENODEM1WST
3807	45260041	Volksbank Witten -alt-	GENODEM1WTN
3808	47263472	VB Westerloh-Westerwiehe	GENODEM1WWW
3809	40060000	WGZ Bank Münster	GENODEMSXXX
3810	61490150	VR-Bank Aalen	GENODES1AAV
3811	60069673	Abtsgmünder Bank	GENODES1ABR
3812	60069206	Raiffeisenbank Aidlingen	GENODES1AID
3813	64161397	Volksbank Ammerbuch	GENODES1AMM
3814	60462808	VR-Bank Asperg-Markgröning	GENODES1AMT
3815	65062793	Raiffbk Vorallgäu -alt-	GENODES1AMZ
3816	65061219	Raiffbk Aulendorf	GENODES1AUL
3817	64261363	VB Baiersbronn Murgtal	GENODES1BAI
3818	65391210	Volksbank Balingen	GENODES1BAL
3819	61262345	Bernhauser Bank	GENODES1BBF
3820	60069766	Volks- u Raiffbk Boll -alt-	GENODES1BBO
3821	60390000	Vereinigte Volksbank	GENODES1BBV
3822	60069931	Raiffbk Berghülen	GENODES1BGH
3823	60069927	Berkheimer Bank	GENODES1BHB
3824	62062215	VB Beilstein-Ilsfeld-Abstat	GENODES1BIA
3825	60661369	Raiffbk Birkenfeld -alt-	GENODES1BIF
3826	63091200	Volksbank Blaubeuren	GENODES1BLA
3827	60069976	Raiffbk Böllingertal	GENODES1BOE
3828	60069239	Bopfinger Bank Sechta-Ries	GENODES1BPF
3829	60069680	Raiffbk Bretzfeld-Neuenst.	GENODES1BRZ
3830	65091300	Bad Waldseer Bank -alt-	GENODES1BWB
3831	62291020	Crailsheimer VB -alt-	GENODES1CRV
3832	60069387	Dettinger Bank	GENODES1DBE
3833	60069476	Raiffbk Heidenheimer Alb	GENODES1DEA
3834	60069378	VB Dettenhausen	GENODES1DEH
3835	61091200	VB-Raiffbk Deggingen	GENODES1DGG
3836	60069842	Darmsheimer Bank	GENODES1DHB
3837	60069017	Raiffbk Dellmensingen	GENODES1DMS
3838	65390120	Volksbank Ebingen	GENODES1EBI
3839	60062775	Echterdinger Bank	GENODES1ECH
3840	60460142	VB Freiberg und Umgebung	GENODES1EGL
3841	60069669	Erligheimer Bank -alt-	GENODES1EHB
3842	63091010	Ehinger Volksbank	GENODES1EHI
3843	60069355	Ehninger Bank	GENODES1EHN
3844	60069648	Raiffeisenbank	GENODES1EHZ
3845	60060606	EKK Stuttgart	GENODES1EK2
3846	61491010	VR-Bank Ellwangen	GENODES1ELL
3847	60069911	Raiffbk Erlenbach	GENODES1ERL
3848	60069302	Raiffeisenbank Erlenmoos	GENODES1ERM
3849	65462231	Raiffbk Illertal -alt-	GENODES1ERO
3850	61190110	Volksbank Esslingen	GENODES1ESS
3851	60069738	VB Freiberg und Umgebung	GENODES1FAN
3852	60261329	Fellbacher Bank	GENODES1FBB
3853	64291010	VB Horb-Freudenstadt	GENODES1FDS
3854	60069860	Federseebank	GENODES1FED
3855	60060893	VR-Bank Stuttgart -alt-	GENODES1FIL
3856	60069780	Genossenschaftsbank	GENODES1GBG
3857	65362499	Raiffbk Geislingen-Rosenf	GENODES1GEI
3858	60491430	VR-Bank Neckar-Enz	GENODES1GHB
3859	65161497	Genossenschaftsbank	GENODES1GMB
3860	63291210	Giengener Volksbank -alt-	GENODES1GVB
3861	60069224	Genossenschaftsbank Weil	GENODES1GWS
3862	60069553	Raiffbk Aichh-Hardt-Sulgen	GENODES1HAR
3863	65361469	Volksbank Heuberg	GENODES1HBM
3864	63290110	Heidenheimer Volksbank	GENODES1HDH
3865	60069325	Hegnacher Bank -alt-	GENODES1HEG
3866	61361722	Raiffeisenbank Rosenstein	GENODES1HEU
3867	60069795	VB Freiberg und Umgebung	GENODES1HHB
3868	61261339	Volksbank Hohenneuffen	GENODES1HON
3869	64191700	Volksbank Horb -alt-	GENODES1HOR
3870	60069714	Raiffeisenbank Kocher-Jagst	GENODES1IBR
3871	60069417	Raiffbk Kirchheim-Walheim	GENODES1KIB
3872	60262063	Korber Bank	GENODES1KOR
3873	60262693	Kerner Volksbank	GENODES1KRN
3874	63091300	Volksbank Laichinger Alb	GENODES1LAI
3875	60490150	Volksbank Ludwigsburg	GENODES1LBG
3876	63061486	VR-Bank Langenau-Ulmer Alb	GENODES1LBK
3877	60390300	Volksbank Region Leonberg	GENODES1LEO
3878	65091040	Leutkircher Bank	GENODES1LEU
3879	60069538	Löchgauer Bank	GENODES1LOC
3880	60391420	Volksbank Magstadt	GENODES1MAG
3881	60069420	Raiffbk Mittelbiberach -alt	GENODES1MBI
3882	60062909	Volksbank Strohgäu	GENODES1MCH
3883	60069315	VB Freiberg und Umgebung	GENODES1MDH
3884	60069706	Raiffbk Mehrstetten	GENODES1MEH
3885	64261626	Murgtalbank -alt-	GENODES1MMO
3886	64091200	VB Metzingen-Bad Urach	GENODES1MTZ
3887	64091300	Volksbank Münsingen	GENODES1MUN
3888	64191030	Volksbank Nagoldtal	GENODES1NAG
3889	61161696	VB Filder	GENODES1NHB
3890	61290120	VB Kirchheim-Nürtingen	GENODES1NUE
3891	60069545	Nufringer Bank	GENODES1NUF
3892	60069431	Raiffbk Oberessendorf	GENODES1OED
3893	65361989	Onstmettinger Bank	GENODES1ONS
3894	65162832	Raiffbk Oberteuringen	GENODES1OTE
3895	60069457	Raiffeisenbank Ottenbach	GENODES1OTT
3896	64261853	Volksbank Nordschwarzwald	GENODES1PGW
3897	60069896	VB Freiberg und Umgebung	GENODES1PLE
3898	60069066	Raiffeisenbank Niedere Alb	GENODES1RBA
3899	60069303	Raiffbk Bad Schussenried	GENODES1RBS
3900	60663084	Raiffbk Calw	GENODES1RCW
3901	64361359	Raiffbk Donau-Heuberg	GENODES1RDH
3902	60069251	Raiffbk Donau-Iller	GENODES1RDI
3903	60069346	Raiffbk Ehingen-Hochsträß	GENODES1REH
3904	60069905	Volksbank Remseck	GENODES1REM
3905	60069442	Raiffbk Frankenh-Stimpfach	GENODES1RFS
3906	60069710	Raiffbk Gammesfeld	GENODES1RGF
3907	60069242	Raiffbk Gruibingen	GENODES1RGR
3908	60069798	Raiffeisenbank Horb	GENODES1RHB
3909	64161608	Raiffbk Härten -alt-	GENODES1RHK
3910	60069724	Raiffbk Heroldstatt -alt-	GENODES1RHS
3911	60069639	Raiffbk Ingersheim	GENODES1RIH
3912	60069308	Raiffbk Ingoldingen	GENODES1RIN
3913	60069463	Raiffbk Geislingen-Rosenf	GENODES1RKH
3914	60069336	Raiffbk Maitis	GENODES1RMA
3915	60069980	Raiffbk Maselheim-Äpfingen	GENODES1RMH
3916	61361975	Raiffeisenbank Mutlangen	GENODES1RML
3917	60069817	Raiffbk Mötzingen	GENODES1RMO
3918	60069371	Volksbank Tettnang	GENODES1RNK
3919	60069527	Volksbank Brenztal	GENODES1RNS
3920	60069727	Raiffbk Oberstenfeld	GENODES1ROF
3921	60069876	Raiffeisenbank Oberes Gäu	GENODES1ROG
3922	60069593	Raiffbk Oberes Schlichemtal	GENODES1ROS
3923	60069485	Raiffbk ob Wald Simmersfeld	GENODES1ROW
3924	60069461	Raiffbk Rottumtal	GENODES1RRE
3925	60069350	Raiffbk Reute-Gaisbeuren	GENODES1RRG
3926	60069343	Raiffeisenbank Rißtal	GENODES1RRI
3927	65062577	Raiffeisenbank Ravensburg	GENODES1RRV
3928	60069147	Raiffbk Sondelfingen	GENODES1RSF
3929	60069904	VR-Bank Alb	GENODES1RUW
3930	60069564	Raiffbk Vordere Alb	GENODES1RVA
3931	60069075	Raiffbk Bühlertal	GENODES1RVG
3932	60069245	Raiffbk Bühlertal	GENODES1RVG
3933	60069455	Raiffbk Vordersteinenberg	GENODES1RVS
3934	60069685	Raiffeisenbank Wangen	GENODES1RWA
3935	60069544	Raiffeisenbank Westhausen	GENODES1RWN
3936	60261818	Raiffbk Weissacher Tal	GENODES1RWT
3937	60069158	Raiffbk Steinheim	GENODES1SAA
3938	65063086	Raiffeisenbank Bad Saulgau	GENODES1SAG
3939	60069595	Raiffbk Schrozberg-Rot	GENODES1SBB
3940	64292020	VB Schwarzwald-Neckar	GENODES1SBG
3941	60069517	Scharnhauser Bank	GENODES1SCA
3942	62290110	VR Bk Schwäb. Hall-Crailsh.	GENODES1SHA
3943	60069705	Raiffeisenbank Schlat -alt-	GENODES1SLA
3944	65093020	VB Bad Saulgau	GENODES1SLG
3945	64061854	VR Steinlach-Wiesaz-Härten	GENODES1STW
3946	65392030	Volksbank Tailfingen	GENODES1TAI
3947	61261213	Raiffeisenbank Teck	GENODES1TEC
3948	65191500	Volksbank Tettnang	GENODES1TET
3949	64292310	Volksbank Trossingen	GENODES1TRO
3950	64190110	Volksbank Tübingen	GENODES1TUE
3951	60069950	Raiffbk Tüngental	GENODES1TUN
3952	64390130	Volksbank Donau-Neckar	GENODES1TUT
3953	60069419	Uhlbacher Bank -alt-	GENODES1UHL
3954	60069832	Raiffbk Urbach	GENODES1URB
3955	60060396	Untertürkheimer Volksbank	GENODES1UTV
3956	65092200	Volksbank Altshausen	GENODES1VAH
3957	60069858	Enztalbank -alt-	GENODES1VAI
3958	60491430	VR-Bank Neckar-Enz	GENODES1VBB
3959	60069926	VB Glatten-Wittendorf -alt-	GENODES1VBG
3960	60391310	VB Herrenberg-Rottenburg	GENODES1VBH
3961	60291120	Volksbank Backnang	GENODES1VBK
3962	65491320	VR Laupheim-Illertal	GENODES1VBL
3963	62391010	VB Bad Mergentheim -alt-	GENODES1VBM
3964	61191310	Volksbank Plochingen	GENODES1VBP
3965	62091400	VB Brackenheim-Güglingen	GENODES1VBR
3966	64291420	Volksbank Deißlingen	GENODES1VDL
3967	64262408	Volksbank Dornstetten	GENODES1VDS
3968	65190110	Volksbank Friedrichshafen	GENODES1VFN
3969	62062643	Volksbank Flein-Talheim	GENODES1VFT
3970	61390140	Volksbank Schwäbisch Gmünd	GENODES1VGD
3971	61060500	Volksbank Göppingen	GENODES1VGP
3972	62091800	Volksbank Hohenlohe	GENODES1VHL
3973	62090100	Volksbank Heilbronn	GENODES1VHN
3974	64163225	Volksbank Hohenzollern	GENODES1VHZ
3975	62063263	VBU Volksbank im Unterland	GENODES1VLS
3976	60691440	VB Maulbronn-Oberderd.-alt-	GENODES1VMB
3977	62091600	VB Möckmühl-Neuenstadt	GENODES1VMN
3978	64161956	Volksbank Mössingen -alt-	GENODES1VMO
3979	60069505	Volksbank Murgtal -alt-	GENODES1VMT
3980	62061991	Volksbank Sulmtal	GENODES1VOS
3981	65491510	VB-Raiffbk Riedlingen	GENODES1VRR
3982	64290120	Volksbank Rottweil	GENODES1VRW
3983	62391420	Volksbank Vorbach-Tauber	GENODES1VVT
3984	65091600	Volksbank Weingarten	GENODES1VWG
3985	60290110	Volksbank Rems -alt-	GENODES1VWN
3986	65092010	VB Allgäu-West	GENODES1WAN
3987	65461878	Raiffbk Risstal	GENODES1WAR
3988	60069462	Winterbacher Bank	GENODES1WBB
3989	61391410	Volksbank Welzheim	GENODES1WEL
3990	60361923	Raiffeisenbank Weissach	GENODES1WES
3991	60661906	Raiffbk Wimsheim-Mönsheim	GENODES1WIM
3992	60291510	Volksbank Winnenden -alt-	GENODES1WIN
3993	65361898	Winterlinger Bank	GENODES1WLB
3994	61262258	Genossenschaftsbank	GENODES1WLF
3995	60261622	VR-Bank Weinstadt	GENODES1WNS
3996	60090300	VB Zuffenhausen	GENODES1ZUF
3997	60060000	DZ BANK	GENODESGXXX
3998	60060202	DZ PRIVATBANK Ndl Stuttgart	GENODESTXXX
3999	33030000	GEFA Wuppertal	GGABDE31XXX
4000	20120600	Goyer & Göppel Hamburg	GOGODEH1XXX
4001	51430400	Goldman Sachs Frankfurt	GOLDDEFFXXX
4002	61050000	Kr Spk Göppingen	GOPSDE6G612
4003	61050000	Kr Spk Göppingen	GOPSDE6GXXX
4004	20130400	GRENKE BANK	GREBDEH1XXX
4005	25060180	Bankhaus Hallbaum	HALLDE2HXXX
4006	51420600	Svenska Handelsbanken	HANDDEFFXXX
4007	20050550	Haspa Ahrensburg	HASPDEHH200
4008	20050550	Haspa Norderstedt	HASPDEHH201
4009	20050550	Haspa Hamburg	HASPDEHHXXX
4010	50220900	Hauck & Aufhäuser	HAUKDEFFXXX
4011	62050000	Kr Spk Heilbronn	HEISDE66XXX
4012	50050201	Frankfurter Spk Frankfurt	HELADEF1822
4013	50050222	Frankfurter Spk 1822direkt	HELADEF1822
4014	83050200	Spk Altenburger Land	HELADEF1ALT
4015	51752267	Sparkasse Battenberg	HELADEF1BAT
4016	50950068	Sparkasse Bensheim	HELADEF1BEN
4017	52051373	St Spk Borken	HELADEF1BOR
4018	50850150	St u Kr Spk Darmstadt	HELADEF1DAS
4019	50852651	Sparkasse Dieburg	HELADEF1DIE
4020	51650045	Spk Dillenburg	HELADEF1DIL
4021	82057070	Kr Spk Eichsfeld	HELADEF1EIC
4022	50851952	Spk Odenwaldkreis Erbach	HELADEF1ERB
4023	52250030	Sparkasse Werra-Meißner	HELADEF1ESW
4024	53050180	Sparkasse Fulda	HELADEF1FDS
4025	52051555	St Spk Felsberg	HELADEF1FEL
4026	51850079	Spk Oberhessen	HELADEF1FRI
4027	50750094	Kreissparkasse Gelnhausen	HELADEF1GEL
4028	83050000	Spk Gera-Greiz	HELADEF1GER
4029	52051877	St Spk Grebenstein	HELADEF1GRE
4030	50852553	Kr Spk Groß-Gerau	HELADEF1GRG
4031	51351526	Sparkasse Grünberg	HELADEF1GRU
4032	82052020	Kr Spk Gotha	HELADEF1GTH
4033	50650023	SPARKASSE HANAU	HELADEF1HAN
4034	50951469	Sparkasse Starkenburg	HELADEF1HEP
4035	53250000	Spk Bad Hersfeld-Rotenburg	HELADEF1HER
4036	84054040	Kr Spk Hildburghausen	HELADEF1HIL
4037	84051010	Sparkasse Arnstadt-Ilmenau	HELADEF1ILK
4038	83053030	Spk Jena-Saale-Holzland	HELADEF1JEN
4039	52050353	Kasseler Sparkasse	HELADEF1KAS
4040	52350005	Spk Waldeck-Frankenberg	HELADEF1KOR
4041	82055000	Kyffhäuser Spk Sondershsn	HELADEF1KYF
4042	51352227	Sparkasse Laubach-Hungen	HELADEF1LAU
4043	51150018	Kr Spk Limburg	HELADEF1LIM
4044	53350000	Spk Marburg-Biedenkopf	HELADEF1MAR
4045	52052154	Kreissparkasse Schwalm-Eder	HELADEF1MEG
4046	82056060	Sparkasse Unstrut-Hainich	HELADEF1MUE
4047	82054052	Kr Spk Nordhausen	HELADEF1NOR
4048	50550020	Städtische Spk Offenbach	HELADEF1OFF
4049	84050000	Rhön-Rennsteig-Sparkasse	HELADEF1RRS
4050	83050303	Kr Spk Saalfeld-Rudolstadt	HELADEF1SAR
4051	50652124	Spk Langen-Seligenstadt	HELADEF1SLS
4052	53051396	Kreissparkasse Schlüchtern	HELADEF1SLU
4053	83050505	Kr Spk Saale-Orla	HELADEF1SOK
4054	84054722	Sparkasse Sonneberg	HELADEF1SON
4055	52053458	St Spk Schwalmstadt	HELADEF1SWA
4056	51250000	Taunus-Sparkasse Bad Hombg	HELADEF1TSK
4057	84055050	Wartburg-Sparkasse	HELADEF1WAK
4058	51151919	Kr Spk Weilburg	HELADEF1WEI
4059	82051000	Spk Mittelthüringen	HELADEF1WEM
4060	51550035	Sparkasse Wetzlar	HELADEF1WET
4061	50850049	LdBk Hess-Thür Gz Darmstadt	HELADEFF508
4062	52050000	Landeskreditkasse Kassel	HELADEFF520
4063	82050000	Ld Bk Hess-Thür Gz Erfurt	HELADEFF820
4064	50050000	Ld Bk Hess-Thür Gz Ffm	HELADEFFXXX
4065	70013500	Bankhaus Herzogpark München	HERZDEM1XXX
4066	50030100	HKB Bank Frankfurt am Main	HKBBDEF1FRA
4067	62020000	Hoerner-Bank Heilbronn	HOEBDE61XXX
4068	20050000	HSH Nordbank Hamburg	HSHNDEHH200
4069	23050000	HSH Nordbank Hamburg	HSHNDEHH230
4070	21050000	HSH Nordbank HH, Kiel	HSHNDEHHXXX
4071	20120700	Hanseatic Bank Hamburg	HSTBDEHHXXX
4072	76420080	UniCredit Bank-HypoVereinbk	HYVEDEMM065
4074	82020087	UniCredit Bank-HypoVereinbk	HYVEDEMM098
4075	25030000	UniCredit Bk ex VereinWest	HYVEDEMM210
4076	25730000	UniCredit Bk ex VereinWest	HYVEDEMM211
4077	27030000	UniCredit Bk ex VereinWest	HYVEDEMM212
4078	26030000	UniCredit Bk ex VereinWest	HYVEDEMM213
4079	25930000	UniCredit Bk ex VereinWest	HYVEDEMM214
4080	25430000	UniCredit Bk ex VereinWest	HYVEDEMM217
4081	72021271	UniCredit Bank-HypoVereinbk	HYVEDEMM236
4082	23030000	UniCredit Bk ex VereinWest	HYVEDEMM237
4083	72220074	UniCredit Bank-HypoVereinbk	HYVEDEMM255
4084	72021876	UniCredit Bank-HypoVereinbk	HYVEDEMM259
4085	72223182	UniCredit Bank-HypoVereinbk	HYVEDEMM263
4086	63220090	UniCredit Bank-HypoVereinbk	HYVEDEMM271
4087	61420086	UniCredit Bank-HypoVereinbk	HYVEDEMM272
4088	77120073	UniCredit Bank-HypoVereinbk	HYVEDEMM289
4090	20030000	UniCredit Bank-HypoVereinbk	HYVEDEMM300
4181	20730000	UniCredit Bk ex VereinWest	HYVEDEMM314
4182	20730051	UniCredit Bk ex VereinWest	HYVEDEMM316
4183	24030000	UniCredit Bk ex VereinWest	HYVEDEMM318
4184	20730054	UniCredit Bk ex VereinWest	HYVEDEMM324
4185	24130000	UniCredit Bk ex VereinWest	HYVEDEMM327
4186	20730053	UniCredit Bk ex VereinWest	HYVEDEMM330
4187	22130075	UniCredit Bk ex VereinWest	HYVEDEMM331
4188	21530080	UniCredit Bk ex VereinWest	HYVEDEMM334
4189	21830030	UniCredit Bk ex VereinWest	HYVEDEMM340
4190	21830032	UniCredit Bk ex VereinWest	HYVEDEMM341
4191	21830033	UniCredit Bk ex VereinWest	HYVEDEMM342
4192	21830034	UniCredit Bk ex VereinWest	HYVEDEMM343
4193	48020086	UniCredit Bank-HypoVereinbk	HYVEDEMM344
4196	21830035	UniCredit Bk ex VereinWest	HYVEDEMM346
4197	21730040	UniCredit Bk ex VereinWest	HYVEDEMM348
4198	21730042	UniCredit Bk ex VereinWest	HYVEDEMM353
4199	21730043	UniCredit Bk ex VereinWest	HYVEDEMM355
4200	68020186	UniCredit Bank-HypoVereinbk	HYVEDEMM357
4203	21730044	UniCredit Bk ex VereinWest	HYVEDEMM358
4204	21730045	UniCredit Bk ex VereinWest	HYVEDEMM359
4205	36020186	UniCredit Bank-HypoVereinbk	HYVEDEMM360
4207	21730046	UniCredit Bk ex VereinWest	HYVEDEMM361
4208	22230022	UniCredit Bk ex VereinWest	HYVEDEMM363
4209	22230023	UniCredit Bk ex VereinWest	HYVEDEMM367
4210	22230025	UniCredit Bk ex VereinWest	HYVEDEMM369
4211	22230020	UniCredit Bk ex VereinWest	HYVEDEMM370
4212	21030000	UniCredit Bk ex VereinWest	HYVEDEMM372
4213	21030092	UniCredit Bk ex VereinWest	HYVEDEMM373
4214	64020186	UniCredit Bank-HypoVereinbk	HYVEDEMM374
4215	21030095	UniCredit Bk ex VereinWest	HYVEDEMM375
4216	21030093	UniCredit Bk ex VereinWest	HYVEDEMM379
4217	21230085	UniCredit Bk ex VereinWest	HYVEDEMM380
4218	21030094	UniCredit Bk ex VereinWest	HYVEDEMM382
4219	21230086	UniCredit Bk ex VereinWest	HYVEDEMM384
4220	21430070	UniCredit Bk ex VereinWest	HYVEDEMM387
4221	21630060	UniCredit Bk ex VereinWest	HYVEDEMM393
4222	21630061	UniCredit Bk ex VereinWest	HYVEDEMM394
4223	21630062	UniCredit Bk ex VereinWest	HYVEDEMM395
4224	21630063	UniCredit Bk ex VereinWest	HYVEDEMM397
4225	57020086	UniCredit Bank-HypoVereinbk	HYVEDEMM401
4226	38020090	UniCredit Bank-HypoVereinbk	HYVEDEMM402
4227	75220070	UniCredit Bank-HypoVereinbk	HYVEDEMM405
4229	76520071	UniCredit Bank-HypoVereinbk	HYVEDEMM406
4235	79520070	UniCredit Bank-HypoVereinbk	HYVEDEMM407
4242	72020070	UniCredit Bank-HypoVereinbk	HYVEDEMM408
4256	71020072	UniCredit Bank-HypoVereinbk	HYVEDEMM410
4261	77020070	UniCredit Bank-HypoVereinbk	HYVEDEMM411
4264	77320072	UniCredit Bank-HypoVereinbk	HYVEDEMM412
4267	30220190	UniCredit Bank-HypoVereinbk	HYVEDEMM414
4274	74120071	UniCredit Bank-HypoVereinbk	HYVEDEMM415
4275	76320072	UniCredit Bank-HypoVereinbk	HYVEDEMM417
4282	70021180	UniCredit Bank-HypoVereinbk	HYVEDEMM418
4283	76220073	UniCredit Bank-HypoVereinbk	HYVEDEMM419
4287	78020070	UniCredit Bank-HypoVereinbk	HYVEDEMM424
4294	72120078	UniCredit Bank-HypoVereinbk	HYVEDEMM426
4304	73420071	UniCredit Bank-HypoVereinbk	HYVEDEMM427
4308	73320073	UniCredit Bank-HypoVereinbk	HYVEDEMM428
4310	37020090	UniCredit Bank-HypoVereinbk	HYVEDEMM429
4312	50320191	UniCredit Bank-HypoVereinbk	HYVEDEMM430
4315	59020090	UniCredit Bank-HypoVereinbk	HYVEDEMM432
4323	74320073	UniCredit Bank-HypoVereinbk	HYVEDEMM433
4333	73120075	UniCredit Bank-HypoVereinbk	HYVEDEMM436
4339	58520086	UniCredit Bank-HypoVereinbk	HYVEDEMM437
4340	71121176	UniCredit Bank-HypoVereinbk	HYVEDEMM438
4343	80020086	UniCredit Bank-HypoVereinbk	HYVEDEMM440
4348	87020088	UniCredit Bank-HypoVereinbk	HYVEDEMM441
4349	74020074	UniCredit Bank-HypoVereinbk	HYVEDEMM445
4357	75020073	UniCredit Bank-HypoVereinbk	HYVEDEMM447
4366	71120077	UniCredit Bank-HypoVereinbk	HYVEDEMM448
4373	79320075	UniCredit Bank-HypoVereinbk	HYVEDEMM451
4383	74220075	UniCredit Bank-HypoVereinbk	HYVEDEMM452
4384	71022182	UniCredit Bank-HypoVereinbk	HYVEDEMM453
4389	75320075	UniCredit Bank-HypoVereinbk	HYVEDEMM454
4392	79020076	UniCredit Bank-HypoVereinbk	HYVEDEMM455
4399	71122183	UniCredit Bank-HypoVereinbk	HYVEDEMM457
4400	84020087	UniCredit Bank-HypoVereinbk	HYVEDEMM458
4401	76020070	UniCredit Bank-HypoVereinbk	HYVEDEMM460
4408	63020086	UniCredit Bank-HypoVereinbk	HYVEDEMM461
4413	80020087	UniCredit Bank-HypoVereinbk	HYVEDEMM462
4415	83020087	UniCredit Bank-HypoVereinbk	HYVEDEMM463
4416	70321194	UniCredit Bank-HypoVereinbk	HYVEDEMM466
4417	50520190	UniCredit Bank-HypoVereinbk	HYVEDEMM467
4419	83020086	UniCredit Bank-HypoVereinbk	HYVEDEMM468
4422	16020086	UniCredit Bank-HypoVereinbk	HYVEDEMM470
4423	17020086	UniCredit Bank-HypoVereinbk	HYVEDEMM471
4424	18020086	UniCredit Bank-HypoVereinbk	HYVEDEMM472
4425	60020290	UniCredit Bank-HypoVereinbk	HYVEDEMM473
4432	66020286	UniCredit Bank-HypoVereinbk	HYVEDEMM475
4435	84020086	UniCredit Bank-HypoVereinbk	HYVEDEMM477
4436	51020186	UniCredit Bank-HypoVereinbk	HYVEDEMM478
4437	67220286	UniCredit Bank-HypoVereinbk	HYVEDEMM479
4438	78320076	UniCredit Bank-HypoVereinbk	HYVEDEMM480
4442	87020087	UniCredit Bank-HypoVereinbk	HYVEDEMM481
4443	54020090	UniCredit Bank-HypoVereinbk	HYVEDEMM482
4444	54520194	UniCredit Bank-HypoVereinbk	HYVEDEMM483
4456	83020088	UniCredit Bank-HypoVereinbk	HYVEDEMM484
4457	54220091	UniCredit Bank-HypoVereinbk	HYVEDEMM485
4458	55020486	UniCredit Bank-HypoVereinbk	HYVEDEMM486
4459	50820292	UniCredit Bank-HypoVereinbk	HYVEDEMM487
4460	10020890	UniCredit Bank-HypoVereinbk	HYVEDEMM488
4466	67020190	UniCredit Bank-HypoVereinbk	HYVEDEMM489
4469	86020086	UniCredit Bank-HypoVereinbk	HYVEDEMM495
4470	85020086	UniCredit Bank-HypoVereinbk	HYVEDEMM496
4473	87020086	UniCredit Bank-HypoVereinbk	HYVEDEMM497
4475	82020086	UniCredit Bank-HypoVereinbk	HYVEDEMM498
4476	56020086	UniCredit Bank-HypoVereinbk	HYVEDEMM515
4477	73321177	UniCredit Bank-HypoVereinbk	HYVEDEMM567
4478	73322380	UniCredit Bank-HypoVereinbk	HYVEDEMM570
4482	65120091	UniCredit Bank-HypoVereinbk	HYVEDEMM586
4483	65020186	UniCredit Bank-HypoVereinbk	HYVEDEMM588
4484	69220186	UniCredit Bank-HypoVereinbk	HYVEDEMM590
4485	69020190	UniCredit Bank-HypoVereinbk	HYVEDEMM591
4486	54620093	UniCredit Bank-HypoVereinbk	HYVEDEMM620
4487	71021270	UniCredit Bank-HypoVereinbk	HYVEDEMM629
4492	71023173	UniCredit Bank-HypoVereinbk	HYVEDEMM632
4493	70025175	UniCredit Bank-HypoVereinbk	HYVEDEMM643
4497	71120078	UniCredit Bank-HypoVereinbk	HYVEDEMM644
4502	70320090	UniCredit Bank-HypoVereinbk	HYVEDEMM654
4505	70322192	UniCredit Bank-HypoVereinbk	HYVEDEMM664
4506	72122181	UniCredit Bank-HypoVereinbk	HYVEDEMM665
4507	73421478	UniCredit Bank-HypoVereinbk	HYVEDEMM666
4509	74221170	UniCredit Bank-HypoVereinbk	HYVEDEMM675
4511	75021174	UniCredit Bank-HypoVereinbk	HYVEDEMM804
4512	44020090	UniCredit Bank-HypoVereinbk	HYVEDEMM808
4514	33020190	UniCredit Bank-HypoVereinbk	HYVEDEMM809
4515	82020088	UniCredit Bank-HypoVereinbk	HYVEDEMM824
4516	59320087	UniCredit Bank-HypoVereinbk	HYVEDEMM838
4517	60320291	UniCredit Bank-HypoVereinbk	HYVEDEMM858
4518	61120286	UniCredit Bank-HypoVereinbk	HYVEDEMM859
4519	60420186	UniCredit Bank-HypoVereinbk	HYVEDEMM860
4520	76020099	UniCredit Bank-HypoVereinbk	HYVEDEMMCAR
4521	20730001	UniCredit Bk Settlemt EAC01	HYVEDEMME01
4522	20730002	UniCredit Bk Settlemt EAC02	HYVEDEMME02
4523	20730003	UniCredit Bk Settlemt EAC03	HYVEDEMME03
4524	20730004	UniCredit Bk Settlemt EAC04	HYVEDEMME04
4525	20730005	UniCredit Bk Settlemt EAC05	HYVEDEMME05
4526	20730006	UniCredit Bk Settlemt EAC06	HYVEDEMME06
4527	20730007	UniCredit Bk Settlemt EAC07	HYVEDEMME07
4528	20730008	UniCredit Bk Settlemt EAC08	HYVEDEMME08
4529	20730009	UniCredit Bk Settlemt EAC09	HYVEDEMME09
4530	20730010	UniCredit Bk Settlemt EAC10	HYVEDEMME10
4531	20730011	UniCredit Bk Settlemt EAC11	HYVEDEMME11
4532	20730012	UniCredit Bk Settlemt EAC12	HYVEDEMME12
4533	20730013	UniCredit Bk Settlemt EAC13	HYVEDEMME13
4534	20730014	UniCredit Bk Settlemt EAC14	HYVEDEMME14
4535	20730015	UniCredit Bk Settlemt EAC15	HYVEDEMME15
4536	20730016	UniCredit Bk Settlemt EAC16	HYVEDEMME16
4537	20730017	UniCredit Bk Settlemt EAC17	HYVEDEMME17
4538	20730018	UniCredit Bk Settlemt EAC18	HYVEDEMME18
4539	20730019	UniCredit Bk Settlemt EAC19	HYVEDEMME19
4540	20730020	UniCredit Bk Settlemt EAC20	HYVEDEMME20
4541	20730021	UniCredit Bk Settlemt EAC21	HYVEDEMME21
4542	20730022	UniCredit Bk Settlemt EAC22	HYVEDEMME22
4543	20730023	UniCredit Bk Settlemt EAC23	HYVEDEMME23
4544	20730024	UniCredit Bk Settlemt EAC24	HYVEDEMME24
4545	20730025	UniCredit Bk Settlemt EAC25	HYVEDEMME25
4546	20730026	UniCredit Bk Settlemt EAC26	HYVEDEMME26
4547	20730027	UniCredit Bk Settlemt EAC27	HYVEDEMME27
4548	20730028	UniCredit Bk Settlemt EAC28	HYVEDEMME28
4549	20730029	UniCredit Bk Settlemt EAC29	HYVEDEMME29
4550	20730030	UniCredit Bk Settlemt EAC30	HYVEDEMME30
4551	20730031	UniCredit Bk Settlemt EAC31	HYVEDEMME31
4552	20730032	UniCredit Bk Settlemt EAC32	HYVEDEMME32
4553	20730033	UniCredit Bk Settlemt EAC33	HYVEDEMME33
4554	20730034	UniCredit Bk Settlemt EAC34	HYVEDEMME34
4555	20730035	UniCredit Bk Settlemt EAC35	HYVEDEMME35
4556	20730036	UniCredit Bk Settlemt EAC36	HYVEDEMME36
4557	20730037	UniCredit Bk Settlemt EAC37	HYVEDEMME37
4558	20730038	UniCredit Bk Settlemt EAC38	HYVEDEMME38
4559	20730039	UniCredit Bk Settlemt EAC39	HYVEDEMME39
4560	20730040	UniCredit Bk Settlemt EAC40	HYVEDEMME40
4561	70020270	UniCredit Bank-HypoVereinbk	HYVEDEMMXXX
4596	10110400	Investitionsbank Berlin	IBBBDEBBXXX
4597	65110200	Int Bkhaus Bodensee	IBBFDE81XXX
4598	60035810	IBM Kreditbank Herrenberg	IBKBDES1XXX
4599	50110200	ICBC Frankfurt, Main	ICBKDEFFXXX
4600	50131000	Vietinbank	ICBVDEFFXXX
4601	50120100	ICICI Bank Frankfurt	ICICDEFFXXX
4602	70011910	InterCard Taufkirchen CS 10	ICRDDE71010
4603	70011920	InterCard Taufkirchen CS 20	ICRDDE71020
4604	70011900	InterCard Taufkirchen	ICRDDE71XXX
4605	30010444	IKB Privatkunden Düsseldorf	IKBDDEDDDIR
4606	30010400	IKB Düsseldorf	IKBDDEDDXXX
4607	16010300	Investitionsbk Potsdam	ILBXDE8XXXX
4608	55020600	Westdeutsche Immobilien Bk	IMMODE5MXXX
4609	50021000	ING Bank, Frankfurt	INGBDEFFXXX
4610	50010517	ING-DiBa Frankfurt am Main	INGDDEFFXXX
4611	50330300	The Bank of New York Mellon	IRVTDEFXXXX
4612	10130600	Isbank Berlin	ISBKDEFXBER
4613	30130600	Isbank Düsseldorf	ISBKDEFXDUS
4614	42030600	Isbank Gelsenkirchen	ISBKDEFXGEL
4615	20230600	Isbank Hamburg	ISBKDEFXHAM
4616	37030800	Isbank Köln	ISBKDEFXKOL
4617	66030600	Isbank Karlsruhe	ISBKDEFXKRL
4618	70230600	Isbank München	ISBKDEFXMUN
4619	76030600	Isbank Nürnberg	ISBKDEFXNUR
4620	60030900	Isbank Stuttgart	ISBKDEFXSTU
4621	50230600	Isbank Frankfurt Main	ISBKDEFXXXX
4622	55010800	ISB RP	ISBRDE55XXX
4623	37021300	Jaguar Fin Serv Köln	JAGUDE31XXX
4624	50110855	J.P. Morgan Intl. Ffm.	JPMGDEFFXXX
4625	20020500	Jyske Bank Hamburg	JYBADEHHXXX
4626	66050101	Spk Karlsruhe Ettlingen	KARSDE66XXX
4627	12016836	KfW Berlin	KFWIDEFF100
4628	50020400	KfW Frankfurt	KFWIDEFFXXX
4629	52410400	KEB -Deutschland- Ffm	KOEXDEFAXXX
4630	30524400	KBC Bank Düsseldorf	KREDDEDDXXX
4631	59350110	Kreissparkasse Saarlouis	KRSADE55XXX
4632	48020151	Bankhaus Lampe Bielefeld	LAMPDEDDXXX
4633	50020500	Landwirtschaftl Rentenbank	LAREDEFFXXX
4634	10050500	LBS Ost Berlin	LBSODEB1BLN
4635	16050500	LBS Ost Potsdam	LBSODEB1XXX
4636	40055555	LBS West Münster	LBSWDE31XXX
4637	70130700	Lenz Bank München	LENZDEM1XXX
4638	70130799	Lenz Bank München Gf GAA	LENZDEM1XXX
4639	70220000	LfA Förderbank München	LFFBDEMMXXX
4640	60010700	L-Bank Stuttgart -alt-	LKBWDE6K600
4641	66010700	L-Bank	LKBWDE6KXXX
4642	10030500	Bankhaus Löbbecke Berlin	LOEBDEBBXXX
4643	37021400	Land Rover Fin Serv Köln	LRFSDE31XXX
4644	54550010	Sparkasse Vorderpfalz	LUHSDE6AXXX
4645	10110300	Privatbank Berlin von 1929	MACODEB1XXX
4646	50120000	MainFirst Bank Frankfurt	MAIFDEFFXXX
4647	57751310	Kr Spk Ahrweiler	MALADE51AHR
4648	57351030	Kreissparkasse Altenkirchen	MALADE51AKI
4649	58650030	Kr Spk Bitburg-Prüm	MALADE51BIT
4650	58751230	Spk Mittelmosel EMH	MALADE51BKS
4651	57051001	Kr Spk Westerwald Montabaur	MALADE51BMB
4652	57051870	Kr Spk Cochem-Zell -alt-	MALADE51COC
4653	58651240	Kreissparkasse Vulkaneifel	MALADE51DAU
4654	54651240	Spk Rhein-Haardt	MALADE51DKH
4655	55150098	Clearingkonto LRP-SI	MALADE51EMZ
4656	54851440	Spk Kandel Pfalz	MALADE51KAD
4657	54050220	Kr Spk Kaiserslautern	MALADE51KLK
4658	54050110	St Spk Kaiserslautern	MALADE51KLS
4659	57050120	Sparkasse Koblenz	MALADE51KOB
4660	56050180	Sparkasse Rhein-Nahe	MALADE51KRE
4661	54051550	Kr Spk Kusel	MALADE51KUS
4662	54051660	St Spk Landstuhl -alt-	MALADE51LAS
4663	54550120	Kreissparkasse Rhein-Pfalz	MALADE51LUH
4664	55050120	Sparkasse Mainz	MALADE51MNZ
4665	57650010	Kr Spk Mayen	MALADE51MYN
4666	57450120	Sparkasse Neuwied	MALADE51NWD
4667	54051990	Sparkasse Donnersberg	MALADE51ROK
4668	56051790	Kr Spk Rhein-Hunsrück	MALADE51SIM
4669	54750010	Kr u St Spk Speyer	MALADE51SPY
4670	54250010	Spk Südwestpfalz Pirmasens	MALADE51SWP
4671	55350010	Sparkasse Worms-Alzey-Ried	MALADE51WOR
4672	67050505	Spk Rhein Neckar Nord	MANSDE66XXX
4673	61030000	Martinbank Göppingen	MARBDE6GXXX
4674	10000000	BBk Berlin	MARKDEF1100
4675	13000000	BBk Rostock	MARKDEF1130
4676	14000000	BBk Rostock eh Schwerin	MARKDEF1140
4677	15000000	BBk Neubrandenburg	MARKDEF1150
4678	16000000	BBk Berlin eh Potsdam	MARKDEF1160
4679	17000000	BBk Berlin eh Frankfurt, Od	MARKDEF1170
4680	18000000	BBk Berlin eh Cottbus	MARKDEF1180
4681	20000000	BBk Hamburg	MARKDEF1200
4682	21000000	BBk Kiel	MARKDEF1210
4683	21500000	BBk Hamburg eh Flensburg	MARKDEF1215
4684	21700000	BBk Hamburg eh Husum	MARKDEF1217
4685	22200000	BBk Kiel eh Itzehoe	MARKDEF1222
4686	23000000	BBk Lübeck	MARKDEF1230
4687	24000000	BBk Hannover eh Lüneburg	MARKDEF1240
4688	25000000	BBk Hannover	MARKDEF1250
4689	25400000	BBk Hannover eh Hameln	MARKDEF1254
4690	25700000	BBk Hannover eh Celle	MARKDEF1257
4691	25800000	BBk Hannover eh Uelzen	MARKDEF1258
4692	25900000	BBk Hannover eh Hildesheim	MARKDEF1259
4693	26000000	BBk Göttingen	MARKDEF1260
4694	26500000	BBk Osnabrück	MARKDEF1265
4695	26600000	BBk Osnabrück eh Lingen	MARKDEF1266
4696	26800000	BBk Magdeburg eh Halberst	MARKDEF1268
4697	27000000	BBk Hannover eh Braunschwei	MARKDEF1270
4698	28000000	BBk Oldenburg	MARKDEF1280
4699	28200000	BBk Oldenburg eh Wilhelmshv	MARKDEF1282
4700	28500000	BBk Oldenburg eh Leer	MARKDEF1285
4701	29000000	BBk Bremen	MARKDEF1290
4702	29200000	BBk Bremen eh Bremerhaven	MARKDEF1292
4703	30000000	BBk Düsseldorf	MARKDEF1300
4704	31000000	BBk Düsseldorf eh Mönchengl	MARKDEF1310
4705	32000000	BBk Düsseldorf eh Krefeld	MARKDEF1320
4706	32400000	BBk Düsseldorf eh Kleve	MARKDEF1324
4707	33000000	BBk Düsseldorf eh Wuppertal	MARKDEF1330
4708	35000000	BBk Düsseldorf eh Duisburg	MARKDEF1350
4709	35600000	BBk Düsseldorf eh Wesel	MARKDEF1356
4710	36000000	BBk Essen	MARKDEF1360
4711	36200000	BBk Essen eh Mülheim/Ruhr	MARKDEF1362
4712	36500000	BBk Essen eh Oberhausen	MARKDEF1365
4713	37000000	BBk Köln	MARKDEF1370
4714	38000000	BBk Köln eh Bonn	MARKDEF1380
4715	38600000	BBk Köln eh Siegburg	MARKDEF1386
4716	39000000	BBk Düsseldorf eh Aachen	MARKDEF1390
4717	39500000	BBk Düsseldorf eh Düren	MARKDEF1395
4718	40000000	BBk Dortmund eh Münster	MARKDEF1400
4719	40300000	BBk Dortmund eh Rheine	MARKDEF1403
4720	41000000	BBk Dortmund eh Hamm, Westf	MARKDEF1410
4721	42000000	BBk Bochum eh Gelsenkirchen	MARKDEF1420
4722	42600000	BBk Bochum eh Recklinghsn	MARKDEF1426
4723	43000000	BBk Bochum	MARKDEF1430
4724	44000000	BBk Dortmund	MARKDEF1440
4725	45000000	BBk Hagen	MARKDEF1450
4726	46000000	BBk Hagen eh Siegen	MARKDEF1460
4727	46400000	BBk Dortmund eh Arnsberg	MARKDEF1464
4728	47200000	BBk Bielefeld eh Paderborn	MARKDEF1472
4729	47800000	BBk Bielefeld eh Gütersloh	MARKDEF1478
4730	48000000	BBk Bielefeld	MARKDEF1480
4731	49000000	BBk Bielefeld eh Minden	MARKDEF1490
4732	50000000	BBk Filiale Frankfurt Main	MARKDEF1500
4733	50600000	BBk Frankfurt eh Hanau	MARKDEF1506
4734	50800000	BBk Frankfurt eh Darmstadt	MARKDEF1508
4735	51000000	BBk Frankfurt eh Wiesbaden	MARKDEF1510
4736	51300000	BBk Gießen	MARKDEF1513
4737	52000000	BBk Frankfurt eh Kassel	MARKDEF1520
4738	53000000	BBk Frankfurt eh Fulda	MARKDEF1530
4739	53200000	BBk Frankfurt eh Bad Hersfd	MARKDEF1532
4740	54000000	BBk Ludwigshfn eh Kaisersl.	MARKDEF1540
4741	54500000	BBk Ludwigshafen am Rhein	MARKDEF1545
4742	55000000	BBk Mainz	MARKDEF1550
4743	56000000	BBk Mainz eh Bad Kreuznach	MARKDEF1560
4744	57000000	BBk Koblenz	MARKDEF1570
4745	57400000	BBk Koblenz eh Neuwied	MARKDEF1574
4746	58500000	BBk Saarbrücken eh Trier	MARKDEF1585
4747	59000000	BBk Saarbrücken	MARKDEF1590
4748	59300000	BBk Saarbr eh Saarlouis	MARKDEF1593
4749	60000000	BBk Stuttgart	MARKDEF1600
4750	60200000	BBk Stuttgart eh Waiblingen	MARKDEF1602
4751	60300000	BBk Stuttgart eh Sindelfing	MARKDEF1603
4752	60400000	BBk Stuttgart eh Ludwigsbur	MARKDEF1604
4753	61100000	BBk Stuttgart eh Esslingen	MARKDEF1611
4754	61400000	BBk Ulm eh Aalen	MARKDEF1614
4755	62000000	BBk Stuttgart eh Heilbronn	MARKDEF1620
4756	62200000	BBk Ulm eh Schwäbisch Hall	MARKDEF1622
4757	63000000	BBk Ulm, Donau	MARKDEF1630
4758	64000000	BBk Reutlingen	MARKDEF1640
4759	65000000	BBk Ulm eh Ravensburg	MARKDEF1650
4760	65300000	BBk Reutlingen eh Albstadt	MARKDEF1653
4761	66000000	BBk Karlsruhe	MARKDEF1660
4762	66200000	BBk Karlsruhe eh Baden-Bade	MARKDEF1662
4763	66400000	BBk Freiburg eh Offenburg	MARKDEF1664
4764	66600000	BBk Karlsruhe eh Pforzheim	MARKDEF1666
4765	67000000	BBk Karlsruhe eh Mannheim	MARKDEF1670
4766	68000000	BBk Freiburg im Breisgau	MARKDEF1680
4767	68300000	BBk Freiburg eh Lörrach	MARKDEF1683
4768	69000000	BBk Vill-Schwen eh Konstanz	MARKDEF1690
4769	69400000	BBk Villingen-Schwenningen	MARKDEF1694
4770	70000000	BBk München	MARKDEF1700
4771	70300000	BBk München eh Garmisch-Par	MARKDEF1703
4772	71000000	BBk München eh B Reichenhal	MARKDEF1710
4773	71100000	BBk München eh Rosenheim	MARKDEF1711
4774	72000000	BBk Augsburg	MARKDEF1720
4775	72100000	BBk München eh Ingolstadt	MARKDEF1721
4776	73100000	BBk Augsburg eh Memmingen	MARKDEF1731
4777	73300000	BBk Augsburg eh Kempten	MARKDEF1733
4778	74000000	BBk Regensburg eh Passau	MARKDEF1740
4779	74100000	BBk Regensbg eh Deggendorf	MARKDEF1741
4780	74300000	BBk Regensburg eh Landshut	MARKDEF1743
4781	75000000	BBk Regensburg	MARKDEF1750
4782	75300000	BBk Regensburg eh Weiden	MARKDEF1753
4783	76000000	BBk Nürnberg	MARKDEF1760
4784	76300000	BBk Nürnberg eh Erlangen	MARKDEF1763
4785	76500000	BBk Nürnberg eh Ansbach	MARKDEF1765
4786	77000000	BBk Nürnberg eh Bamberg	MARKDEF1770
4787	77300000	BBk Bayreuth	MARKDEF1773
4788	78000000	BBk Bayreuth eh Hof	MARKDEF1780
4789	79000000	BBk Würzburg	MARKDEF1790
4790	79300000	BBk Würzburg eh Schweinfurt	MARKDEF1793
4791	79500000	BBk Würzburg eh Aschaffenbg	MARKDEF1795
4792	80000000	BBk Magdeburg eh Halle	MARKDEF1800
4793	80500000	BBk Halle eh Dessau	MARKDEF1805
4794	81000000	BBk Magdeburg	MARKDEF1810
4795	82000000	BBk Erfurt	MARKDEF1820
4796	83000000	BBk Erfurt eh Gera	MARKDEF1830
4797	84000000	BBk Erfurt eh Meiningen	MARKDEF1840
4798	85000000	BBk Dresden	MARKDEF1850
4799	86000000	BBk Leipzig	MARKDEF1860
4800	87000000	BBk Chemnitz	MARKDEF1870
4801	50400000	BBk Zentrale Frankfurt Main	MARKDEFFXXX
4802	50130300	FIRST BANK Frankfurt	MASFDEF1XXX
4803	37021100	Mazda Bank Köln	MAZDDED1XXX
4804	20030400	Marcardbank Hamburg	MCRDDEHHXXX
4805	60030000	Mercedes-Benz Bank	MEBEDE6SDCB
4806	12030900	Merck Finck & Co Berlin	MEFIDEMM100
4807	20030700	Merck Finck & Co Hamburg	MEFIDEMM200
4808	30030900	Merck Finck & Co Düsseldorf	MEFIDEMM300
4809	50130400	Merck Finck & Co Frankfurt	MEFIDEMM501
4810	70030400	Merck Finck & Co München	MEFIDEMMXXX
4811	51410600	Merrill Lynch Intl Bank FFM	MELBDEF1XXX
4812	59351040	Spk Merzig-Wadern	MERZDE55XXX
4813	50230700	Bankhaus Metzler Frankfurt	METZDEFFXXX
4814	31050000	St Spk Mönchengladbach	MGLSDE33XXX
4815	50330200	MHB-Bank Frankfurt	MHBFDEFFXXX
4816	30020700	Mizuho Bank Düsseldorf	MHCBDEDDXXX
4817	20230800	Sutor Bank Hamburg	MHSBDEHBXXX
4818	70110500	Münch Hypoth Bank München	MHYPDEMMXXX
4819	51420200	Misr Bank-Europe Ffm	MIBEDEFFXXX
4820	57020301	MKB Koblenz	MKBKDE51XXX
4821	50835800	MCE Bank Flörsheim	MKGMDE51XXX
4822	40030000	Münsterländische Bk Münster	MLBKDE3MXXX
4823	67230001	MLP FDL Zw CS	MLPBDE61001
4825	20220400	M.M. Warburg Hyp Hamburg	MMWHDEH1XXX
4826	50110900	Bank of America N.A. Mil Bk	MNBIDEF1XXX
4827	52410900	Maple Bank Frankfurt	MPBKDEFFXXX
4828	51220900	Morgan Stanley Bank	MSFFDEFPXXX
4829	51220910	Morgan Stanley Bank	MSFFDEFXCND
4830	50230100	Morgan Stanley Bank Int	MSPCDEF1XXX
4831	55190028	Mainzer Volksbank -alt-	MVBMDE51028
4832	55190050	Mainzer Volksbank -alt-	MVBMDE51050
4833	55190064	Mainzer Volksbank -alt-	MVBMDE51064
4834	55190065	Mainzer Volksbank -alt-	MVBMDE51065
4835	55190068	Mainzer Volksbank -alt-	MVBMDE51068
4836	55190088	Mainzer Volksbank -alt-	MVBMDE51088
4837	55190094	Mainzer Volksbank -alt-	MVBMDE51094
4838	55190000	Mainzer Volksbank Mainz	MVBMDE55XXX
4839	51050015	Nass Spk Wiesbaden	NASSDE55XXX
4840	50110500	NATIXIS Frankfurt am Main	NATXDEFFXXX
4841	51211000	NATIXIS Pfandbriefbank Ffm	NATXDEFPXXX
4842	35020030	National-Bank Duisburg -alt	NBAGDE3EXXX
4843	36020030	National-Bank Essen	NBAGDE3EXXX
4844	36220030	National-Bank Mülheim-alt-	NBAGDE3EXXX
4845	36520030	National-Bank Oberhsn -alt-	NBAGDE3EXXX
4846	50130000	Naba Frankfurt Main	NBPADEFFXXX
4847	51430321	Nordea Bank Frankfurt	NDEADEFF321
4848	51430300	Nordea Bank Finland	NDEADEFFXXX
4849	29020000	Bankhaus Neelmeyer Bremen	NEELDE22XXX
4850	29020200	NF Bank Bremen	NFHBDE21XXX
4851	25151270	St Spk Barsinghausen	NOLADE21BAH
4852	21451205	Sparkasse Büdelsdorf -alt-	NOLADE21BDF
4853	26551540	Kr Spk Bersenbrück	NOLADE21BEB
4854	80053000	Spk Burgenlandkreis	NOLADE21BLK
4855	21051275	Bordesholmer Sparkasse	NOLADE21BOR
4856	25451450	Spk Weserbergland Bodenwerd	NOLADE21BOW
4857	21751230	Spk Bredstedt -alt-	NOLADE21BRD
4858	80053722	Kr Spk Anhalt-Bitterfeld	NOLADE21BTF
4859	25151371	Stadtsparkasse Burgdorf	NOLADE21BUF
4860	25750001	Sparkasse Celle	NOLADE21CEL
4861	26851410	Kr Spk Clausthal-Zellerfeld	NOLADE21CLZ
4862	25050055	ZVA Nord LB SH	NOLADE21CSH
4863	25851335	Spk Uelzen Lüchow-Dbg.-alt-	NOLADE21DAN
4864	80053572	St Spk Dessau	NOLADE21DES
4865	26051260	Sparkasse Duderstadt	NOLADE21DUD
4866	12050555	NLB FinanzIT	NOLADE21DVS
4867	21052090	Sparkasse Eckernförde -alt-	NOLADE21ECK
4868	80055008	Sparkasse Mansfeld-Südharz	NOLADE21EIL
4869	26251425	Sparkasse Einbeck	NOLADE21EIN
4870	22150000	Spk Elmshorn	NOLADE21ELH
4871	26650001	Spk Emsland	NOLADE21EMS
4872	26951311	Spk Gifhorn-Wolfsburg	NOLADE21GFW
4873	26050001	Sparkasse Göttingen	NOLADE21GOE
4874	15050500	Spk Vorpommern	NOLADE21GRW
4875	26850001	Sparkasse Goslar/Harz	NOLADE21GSL
4876	80053762	Saalesparkasse Halle	NOLADE21HAL
4877	20750000	Spk Harburg-Buxtehude	NOLADE21HAM
4878	81055000	Kreissparkasse Börde	NOLADE21HDL
4879	25451655	Spk Weserbergland Hess Old	NOLADE21HEO
4880	25950130	Sparkasse Hildesheim	NOLADE21HIK
4881	25950001	St Spk Hildesheim -alt-	NOLADE21HIS
4882	25450001	St Spk Hameln	NOLADE21HMS
4883	26051450	Kr u St Spk Münden	NOLADE21HMU
4884	21352240	Spk Holstein Eutin	NOLADE21HOL
4885	81052000	Harzsparkasse	NOLADE21HRZ
4886	21452030	Spk Hohenwestedt	NOLADE21HWS
4887	26351015	Sparkasse Osterode am Harz	NOLADE21HZB
4888	81054000	Sparkasse Jerichower Land	NOLADE21JEL
4889	21050170	Förde Sparkasse	NOLADE21KIE
4890	80053622	Kr Spk Köthen -alt-	NOLADE21KOT
4891	24050110	Spk Lüneburg	NOLADE21LBG
4892	25055500	LBS-Norddt Hannover	NOLADE21LBS
4893	14052000	Spk Mecklenburg-Schwerin	NOLADE21LWL
4894	81053272	St Spk Magdeburg	NOLADE21MDG
4895	26552286	Kreissparkasse Melle	NOLADE21MEL
4896	21851830	Verb Spk Meldorf -alt-	NOLADE21MLD
4897	80050500	Kr Spk Mersebg-Querfurt alt	NOLADE21MQU
4898	21851720	Alte Marner Spk -alt-	NOLADE21MRN
4899	15051732	Spk Mecklenburg-Strelitz	NOLADE21MST
4900	15050200	Spk Neubrandenburg-Demmin	NOLADE21NBS
4901	25650106	Sparkasse Nienburg	NOLADE21NIB
4902	26750001	Kr Spk Nordhorn	NOLADE21NOH
4903	26250001	Kr Spk Northeim	NOLADE21NOM
4904	21750000	Nord-Ostsee Spk Schleswig	NOLADE21NOS
4905	26350001	St Spk Osterode	NOLADE21OHA
4906	14051362	Sparkasse Parchim-Lübz	NOLADE21PCH
4907	25250001	Kr Spk Peine	NOLADE21PEI
4908	21051580	Spk Kreis Plön -alt-	NOLADE21PLN
4909	25451345	St Spk Bad Pyrmont	NOLADE21PMT
4910	15050400	Sparkasse Uecker-Randow	NOLADE21PSW
4911	21450000	Spk Mittelholstein Rendsbg	NOLADE21RDB
4912	13050000	Ostseesparkasse Rostock	NOLADE21ROS
4913	13051042	Spk Vorpommern auf Rügen	NOLADE21RUE
4914	23052750	Kr Spk Herzogtum Lauenburg	NOLADE21RZB
4915	26351445	St Spk Bad Sachsa	NOLADE21SAC
4916	81055555	Spk Altmark West Salzwedel	NOLADE21SAW
4917	81050555	Kreissparkasse Stendal	NOLADE21SDL
4918	80055500	Salzlandsparkasse Staßfurt	NOLADE21SES
4919	80053552	Kr Spk Sangerhausen -alt-	NOLADE21SGH
4920	22251580	Ldspk Schenefeld -alt-	NOLADE21SHF
4921	25551480	Sparkasse Schaumburg	NOLADE21SHG
4922	23051030	Spk Südholstein Neumünster	NOLADE21SHO
4923	14051462	Sparkasse Schwerin -alt-	NOLADE21SNS
4924	25851660	Kr Spk Soltau	NOLADE21SOL
4925	23050101	Sparkasse zu Lübeck	NOLADE21SPL
4926	24151116	Kreissparkasse Stade	NOLADE21STK
4927	23051610	Spk Stormarn -alt-	NOLADE21STO
4928	24151005	Spk Stade-Altes Land	NOLADE21STS
4929	25450110	Spk Weserbergland Hameln	NOLADE21SWB
4930	26851620	Sparkasse Salzgitter	NOLADE21SZG
4931	25850110	Sparkasse Uelzen Lüchow-Dbg	NOLADE21UEL
4932	25152375	Kr Spk Fallingbostel	NOLADE21WAL
4933	80550101	Sparkasse Wittenberg	NOLADE21WBL
4934	21852310	Spk Hennstedt-Wesselburen	NOLADE21WEB
4935	22151730	St Spk Wedel	NOLADE21WED
4936	22250020	Spk Westholstein	NOLADE21WHO
4937	14051000	Spk Mecklenburg-Nordwest	NOLADE21WIS
4938	15050100	Müritz-Sparkasse Waren	NOLADE21WRN
4939	80054000	Kr Spk Weißenfels	NOLADE21WSF
4940	25152490	St Spk Wunstorf	NOLADE21WST
4941	80550200	Kr Spk Anhalt-Zerbst -alt-	NOLADE21ZER
4942	26550105	Sparkasse Osnabrück	NOLADE22XXX
4943	25050000	Nord LB Hannover	NOLADE2HXXX
4944	10077777	norisbank Berlin	NORSDE51XXX
4945	76026000	norisbank Berlin	NORSDE71XXX
4946	40022000	NRW.BANK Münster	NRWBDEDMMST
4947	30022000	NRW.BANK Düsseldorf	NRWBDEDMXXX
4948	51210700	NIBC Bank Frankfurt am Main	NZFMDEF1XXX
4949	61450050	Kreissparkasse Ostalb	OASPDE6AXXX
4950	70120700	Oberbank München	OBKLDEMXXXX
4951	70035000	OLB (vormals Allianz Bank)	OLBODEH2700
4952	25621327	Oldb Landesbank Diepholz	OLBODEH2XXX
4953	26520017	Oldb Landesbank Osnabrück	OLBODEH2XXX
4954	26521703	Oldb Landesbank Bramsche	OLBODEH2XXX
4955	26522319	Oldb Landesbank Quakenbrück	OLBODEH2XXX
4956	26620010	Oldb Landesbank Lingen	OLBODEH2XXX
4957	26621413	Oldb Landesbank Meppen	OLBODEH2XXX
4958	26720028	Oldb Landesbank Nordhorn	OLBODEH2XXX
4959	28020050	Oldb Landesbank Oldenburg	OLBODEH2XXX
4960	28021002	Oldb Landesbank Brake	OLBODEH2XXX
4961	28021301	Oldb Ldbank Bad Zwischenahn	OLBODEH2XXX
4962	28021504	Oldb Landesbank Cloppenburg	OLBODEH2XXX
4963	28021623	Oldb Landesbank Damme	OLBODEH2XXX
4964	28021705	Oldb Landesbank Delmenhorst	OLBODEH2XXX
4965	28021906	Oldb Landesbank Elsfleth	OLBODEH2XXX
4966	28022015	Oldb Landesbank Nordenham	OLBODEH2XXX
4967	28022412	Oldb Landesbank Löningen	OLBODEH2XXX
4968	28022511	Oldb Landesbank Lohne	OLBODEH2XXX
4969	28022620	Oldb Landesbank Rastede	OLBODEH2XXX
4970	28022822	Oldb Landesbank Vechta	OLBODEH2XXX
4971	28023224	Oldb Landesbank Westerstede	OLBODEH2XXX
4972	28023325	Oldb Ldbank Wildeshausen	OLBODEH2XXX
4973	28220026	Oldb Ldbank Wilhelmshaven	OLBODEH2XXX
4974	28222208	Oldb Landesbank Jever	OLBODEH2XXX
4975	28222621	Oldb Landesbank Varel	OLBODEH2XXX
4976	28320014	Oldb Landesbank Norden	OLBODEH2XXX
4977	28321816	Oldb Landesbank Norderney	OLBODEH2XXX
4978	28420007	Oldb Landesbank Emden	OLBODEH2XXX
4979	28421030	Oldb Landesbank Aurich	OLBODEH2XXX
4980	28520009	Oldb Landesbank Leer	OLBODEH2XXX
4981	28521518	Oldb Landesbank Papenburg	OLBODEH2XXX
4982	29121731	Oldb Landesbank Syke	OLBODEH2XXX
4983	20230300	Schröderbank Hamburg	OSCBDEH1XXX
4984	85050300	Ostsächsische Spk Dresden	OSDDDE81FTL
4985	85050300	Ostsächsische Spk Dresden	OSDDDE81HDN
4986	85050300	Ostsächsische Spk Dresden	OSDDDE81HOY
4987	85050300	Ostsächsische Spk Dresden	OSDDDE81KMZ
4988	85050350	Ostsächsische Spk OSD.Net	OSDDDE81NET
4989	85050300	Ostsächsische Spk Dresden	OSDDDE81PIR
4990	85050300	Ostsächsische Spk Dresden	OSDDDE81RBG
4991	85050300	Ostsächsische Spk Dresden	OSDDDE81SEB
4992	85050300	Ostsächsische Spk Dresden	OSDDDE81XXX
4993	50320000	VTB Bank Deutschland Ffm	OWHBDEFFXXX
4994	57020500	Oyak Anker Bank	OYAKDE5KXXX
4995	70017000	PayCenter Freising	PAGMDEM1XXX
4996	50030500	BNP PARIBAS Sec Serv	PARBDEFFXXX
4997	38010053	Postbank Zentrale Bonn	PBNKDEFF380
4998	38010700	DSL Bank Bonn	PBNKDEFFDSL
4999	10010010	Postbank Berlin	PBNKDEFFXXX
5000	20010020	Postbank -Giro- Hamburg	PBNKDEFFXXX
5001	20110022	Postbank -Spar- Hamburg	PBNKDEFFXXX
5002	25010030	Postbank Hannover	PBNKDEFFXXX
5003	36010043	Postbank Essen	PBNKDEFFXXX
5004	37010050	Postbank Köln	PBNKDEFFXXX
5005	37011000	Deutsche Postbank Easytrade	PBNKDEFFXXX
5006	44010046	Postbank Dortmund	PBNKDEFFXXX
5007	50010060	Postbank Frankfurt Main	PBNKDEFFXXX
5008	54510067	Postbank Ludwigshafen	PBNKDEFFXXX
5009	59010011	Postbk St. Ingbert Gf FK 11	PBNKDEFFXXX
5010	59010012	Postbk St. Ingbert Gf FK 12	PBNKDEFFXXX
5011	59010013	Postbk St. Ingbert Gf FK 13	PBNKDEFFXXX
5012	59010014	Postbk Völklingen Gf FK 14	PBNKDEFFXXX
5013	59010015	Postbank Horb Gf FK 15	PBNKDEFFXXX
5014	59010016	Postbank Bruchsal Gf FK 16	PBNKDEFFXXX
5015	59010017	Postbk Stahnsdorf Gf FK 17	PBNKDEFFXXX
5016	59010018	Postbank Wedel Gf FK 18	PBNKDEFFXXX
5017	59010019	Postbank Ipsheim Gf FK 19	PBNKDEFFXXX
5018	59010020	Postbank Rellingen GF FK 20	PBNKDEFFXXX
5019	59010021	Postbank Nauen GF FK 21	PBNKDEFFXXX
5020	59010022	Postbank Rahden GF FK 22	PBNKDEFFXXX
5021	59010023	Postbank Dorsten GF FK 23	PBNKDEFFXXX
5022	59010024	Postbank Brühl GF FK 2	PBNKDEFFXXX
5023	59010025	Postbank Mengen GF FK 25	PBNKDEFFXXX
5024	59010026	Postbank Mengen GF FK 26	PBNKDEFFXXX
5025	59010027	Postbk Pinneberg Gf FK 27	PBNKDEFFXXX
5026	59010028	Postbk Alzey Gf FK 28	PBNKDEFFXXX
5027	59010029	Postbk Bad Vilbel Gf FK 29	PBNKDEFFXXX
5028	59010031	Postbk Bretten Gf FK 31	PBNKDEFFXXX
5029	59010032	Postbk Wilster Gf FK 32	PBNKDEFFXXX
5030	59010033	Postbk Garding Gf FK 33	PBNKDEFFXXX
5031	59010034	Postbk Soltau Gf FK 34	PBNKDEFFXXX
5032	59010035	Postbk Delmenhorst Gf FK 35	PBNKDEFFXXX
5033	59010036	Postbk Cham Gf FK 36	PBNKDEFFXXX
5034	59010037	Postbk Geretsried Gf FK 37	PBNKDEFFXXX
5035	59010038	Postbk Aichach Gf FK 38	PBNKDEFFXXX
5036	59010039	Postbk Ditzingen Gf FK 39	PBNKDEFFXXX
5037	59010040	Postbk Leonberg Gf FK 40	PBNKDEFFXXX
5038	59010041	Postbk Germersheim Gf FK 41	PBNKDEFFXXX
5039	59010042	Postbk Rhens Gf FK 42	PBNKDEFFXXX
5040	59010044	Postbk Obertshausen GfFK 44	PBNKDEFFXXX
5041	59010045	Postbk Maintal Gf FK 45	PBNKDEFFXXX
5042	59010047	Postbk Pulheim Gf FK 47	PBNKDEFFXXX
5043	59010048	Postbk Frechen Gf FK 48	PBNKDEFFXXX
5044	59010049	Postbk Brakel Gf FK 49	PBNKDEFFXXX
5045	59010066	Postbank Saarbrücken	PBNKDEFFXXX
5046	60010070	Postbank Stuttgart	PBNKDEFFXXX
5047	66010075	Postbank Karlsruhe	PBNKDEFFXXX
5048	70010080	Postbank -Giro- München	PBNKDEFFXXX
5049	70110088	Postbank -Spar- München	PBNKDEFFXXX
5050	76010085	Postbank Nürnberg	PBNKDEFFXXX
5051	86010090	Postbank Leipzig	PBNKDEFFXXX
5052	50310900	CCB Frankfurt	PCBCDEFFXXX
5053	50320900	Pictet & Cie Europe Ffm	PICTDEFFXXX
5054	50230800	Ikano Bank	PLFGDE5AXXX
5055	29030400	Plumpbank Bremen	PLUMDE29XXX
5056	30025500	Portigon Düsseldorf	PORTDEDDXXX
5057	50210800	ProCredit Bank, Frankfurt	PRCBDEFFXXX
5058	50030000	Banque PSA Finance	PSADDEF1XXX
5059	51051000	S Broker Wiesbaden	PULSDE5WXXX
5060	30030100	S Broker Wiesbaden	PULSDEDDXXX
5061	60651070	Kreissparkasse Calw -alt-	PZHSDE66XXX
5062	66650085	Sparkasse Pforzheim Calw	PZHSDE66XXX
5063	76230000	BSQ Bauspar Nürnberg	QUBADE71XXX
5064	10110600	quirin bank	QUBKDEBBXXX
5065	50210212	RaboDirect Frankfurt Main	RABODEFFDIR
5066	50210200	Rabobank Frankfurt Main	RABODEFFTAR
5067	50210295	Rabobank International CMS	RABODEFFXXX
5068	52410310	ReiseBank Gf2 Frankfurt	RBAGDEF1CMI
5069	52410300	ReiseBank Frankfurt am Main	RBAGDEF1XXX
5070	50662669	Frankfurter Volksbank	RBMFDEF1XXX
5071	30520037	RCI Banque Direkt	RCIDDE3NPAY
5072	30520000	RCI Banque Ndl Deutschland	RCIDDE3NXXX
5073	70010570	Deutsche Pfandbriefbank	REBMDE7CXXX
5074	70010555	Deutsche Pfandbriefbank	REBMDEMM555
5075	70010500	Deutsche Pfandbriefbank	REBMDEMMXXX
5076	70120600	Salzburg München Bank	RVSADEMXXXX
5077	74020150	RLB OÖ Zndl Süddeutschland	RZOODE77050
5078	74020100	RLB OÖ Zndl Süddeutschland	RZOODE77XXX
5079	73362500	RLB Tirol Jungholz	RZTIDE71XXX
5080	59190000	Bank 1 Saar	SABADE5SXXX
5081	85010500	Sächsische Aufbaubank	SABDDE81XXX
5082	60422000	RSB-Bank Kornwestheim	SABUDE6SXXX
5083	59050101	Sparkasse Saarbrücken	SAKSDE55XXX
5084	59450010	Kreissparkasse Saarpfalz	SALADE51HOM
5085	59252046	Sparkasse Neunkirchen	SALADE51NKS
5086	59052020	SKG BANK Saarbrücken	SALADE51SKG
5087	59051090	St Spk Völklingen	SALADE51VKS
5088	59251020	Kr Spk St. Wendel	SALADE51WND
5089	59050000	Landesbank Saar Saarbrücken	SALADE55XXX
5090	65450070	Kr Spk Biberach	SBCRDE66XXX
5091	50330000	State Bk of India Frankfurt	SBINDEFFXXX
5092	70120100	State Street Bank München	SBOSDEMXXXX
5093	29050101	Spk Bremen	SBREDE22XXX
5094	51230555	Standard Chartered Bank Ffm	SCBLDEF1CBG
5095	50110636	DTC SCB Germany Branch	SCBLDEF1DTC
5096	51230502	ETC SCB Germany Branch	SCBLDEF1ETC
5097	51230500	Standard Chartered Bank Ffm	SCBLDEFXXXX
5098	10033300	Santander Bank Berlin	SCFBDE33XXX
5099	10120600	Santander Consumer Bank	SCFBDE33XXX
5100	20133300	Santander Bank Hamburg	SCFBDE33XXX
5101	25020600	Santander Consumer Bank	SCFBDE33XXX
5102	36033300	Santander Bank Essen	SCFBDE33XXX
5103	50033300	Santander Bank Frankfurt	SCFBDE33XXX
5104	55033300	Santander Bank Mainz	SCFBDE33XXX
5105	60133300	Santander Bank Stuttgart	SCFBDE33XXX
5106	70133300	Santander Bank München	SCFBDE33XXX
5107	86033300	Santander Bank Leipzig	SCFBDE33XXX
5108	60020100	Schwabenbank Stuttgart	SCHWDESSXXX
5109	54030011	Service Credit Union	SCRUDE51XXX
5110	39550110	Sparkasse Düren	SDUEDE33XXX
5111	27020800	Seat Bank Braunschweig	SEATDE21XXX
5112	52420700	SECB Frankfurt Main	SECGDEFFXXX
5113	50020000	Sberbank Direct Frankfurt	SEZDDEF1XXX
5114	52420300	SHINHAN BANK EUROPE Ffm	SHBKDEFFXXX
5115	70011500	SIEMENS BANK	SIBADEMMXXX
5116	20020900	Signal Iduna Bauspar	SIBSDEHHXXX
5117	59010400	SIKB Saarbrücken	SIKBDE55XXX
5118	51350025	Sparkasse Gießen	SKGIDE5FXXX
5119	68452290	Sparkasse Hochrhein	SKHRDE6WXXX
5120	68350048	Sparkasse Lörrach-Rheinfeld	SKLODE66XXX
5121	27020003	Skoda Bank	SKODDE21XXX
5122	10050020	LBB S-Kreditpartner, Berlin	SKPADEB1XXX
5123	30110300	SMBC Düsseldorf	SMBCDEDDXXX
5124	50220085	UBS Deutschland Berlin	SMHBDEFFBER
5125	50220085	UBS Deutschland Bielefeld	SMHBDEFFBIE
5126	50220085	UBS Deutschland Düsseldorf	SMHBDEFFDUS
5127	50220085	UBS Deutschland Hamburg	SMHBDEFFHAM
5128	50220085	UBS Deutschland Köln	SMHBDEFFKOE
5129	50220085	UBS Deutschland München	SMHBDEFFMUN
5130	50220085	UBS Deutschland Offenbach/M	SMHBDEFFOFF
5131	50220085	UBS Deutschland Stuttgart	SMHBDEFFSTG
5132	50220085	UBS Deutschland Frankfurt/M	SMHBDEFFXXX
5133	51210800	SOGEBANK Frankfurt Main	SOGEDEFFXXX
5134	66250030	Spk Baden-Baden Gaggenau	SOLADES1BAD
5135	65351260	Spk Zollernalb	SOLADES1BAL
5136	85550000	Kreissparkasse Bautzen	SOLADES1BAT
5138	68051207	Spk Bonndorf-Stühlingen	SOLADES1BND
5139	68051310	Spk Breisach -alt-	SOLADES1BRS
5140	86055002	Spk Delitzsch-Eilenburg-alt	SOLADES1DES
5141	86055462	Kr Spk Döbeln	SOLADES1DLN
5142	69451070	Spk Donaueschingen -alt-	SOLADES1DOE
5143	69251445	Spk Engen-Gottmadingen	SOLADES1ENG
5144	66051220	Sparkasse Ettlingen -alt-	SOLADES1ETT
5145	64251060	Kr Spk Freudenstadt	SOLADES1FDS
5146	66551290	Spk Gaggenau-Kuppenheim-alt	SOLADES1GAG
5147	66451346	Spk Gengenbach	SOLADES1GEB
5148	86050200	Spk Muldental	SOLADES1GRM
5149	66451548	Spk Haslach-Zell	SOLADES1HAL
5150	67250020	Spk Heidelberg	SOLADES1HDB
5151	63250030	Kr Spk Heidenheim	SOLADES1HDH
5152	67051203	Spk Hockenheim	SOLADES1HOC
5153	68051004	Spk Hochschwarzwald T-Neust	SOLADES1HSW
5154	66451862	Spk Hanauerland Kehl	SOLADES1KEL
5155	69050001	Sparkasse Bodensee	SOLADES1KNZ
5156	62251550	Sparkasse Hohenlohekreis	SOLADES1KUN
5157	60450050	Kreissparkasse Ludwigsburg	SOLADES1LBG
5158	85055000	Spk Meißen	SOLADES1MEI
5159	68351865	Sparkasse Markgräflerland	SOLADES1MGL
5160	67450048	Spk Neckartal-Odenwald	SOLADES1MOS
5161	66450050	Sparkasse Offenburg/Ortenau	SOLADES1OFG
5162	69051620	Spk Pfullendorf-Meßkirch	SOLADES1PFD
5163	66550070	Sparkasse Rastatt-Gernsbach	SOLADES1RAS
5164	69051410	Bez Spk Reichenau	SOLADES1REN
5165	64050000	Kr Spk Reutlingen	SOLADES1REU
5166	85050200	Kr Spk Riesa-Großenhain alt	SOLADES1RGA
5167	65050110	Kr Spk Ravensburg	SOLADES1RVB
5168	64250040	Kr Spk Rottweil	SOLADES1RWL
5169	69051725	Spk Salem-Heiligenberg	SOLADES1SAL
5170	68052863	Spk Schönau-Todtnau	SOLADES1SCH
5171	68351557	Sparkasse Schopfheim-Zell	SOLADES1SFH
5172	62250030	Sparkasse Schwäbisch Hall	SOLADES1SHA
5173	65351050	Ld Bk Kr Spk Sigmaringen	SOLADES1SIG
5174	87053000	Spk Mittleres Erzgebg -alt-	SOLADES1SME
5175	69250035	Spk Singen-Radolfzell	SOLADES1SNG
5176	68052230	Spk St. Blasien	SOLADES1STB
5177	68052328	Spk Staufen-Breisach	SOLADES1STF
5178	69251755	Sparkasse Stockach	SOLADES1STO
5179	54850010	Spk Südl Weinstr in Landau	SOLADES1SUW
5180	67352565	Spk Tauberfranken	SOLADES1TBB
5181	64150020	Kr Spk Tübingen	SOLADES1TUB
5182	64350070	Kr Spk Tuttlingen	SOLADES1TUT
5183	63050000	Sparkasse Ulm	SOLADES1ULM
5184	69450065	Spk Schwarzwald-Baar	SOLADES1VSS
5185	60250010	Kr Spk Waiblingen	SOLADES1WBN
5186	66452776	Spk Wolfach	SOLADES1WOF
5187	68351976	Spk Zell Wiesental -alt-	SOLADES1ZLW
5188	62050181	BW-Bank/LBBW Heilbronn	SOLADEST400
5189	62250182	BW-Bank/LBBW Schwäb. Hall	SOLADEST416
5190	61450191	BW-Bank/LBBW Aalen	SOLADEST420
5191	60050101	BW-Bank/LBBW Stuttgart	SOLADEST428
5192	60050101	BW-Bank/LBBW Stuttgart	SOLADEST437
5193	63050181	BW-Bank/LBBW Ulm	SOLADEST440
5194	60050101	BW-Bank/LBBW Stuttgart	SOLADEST447
5195	65050281	BW-Bank/LBBW Ravensburg	SOLADEST450
5196	60050101	BW-Bank/LBBW Stuttgart	SOLADEST454
5197	60050101	BW-Bank/LBBW Stuttgart	SOLADEST457
5198	64050181	BW-Bank/LBBW Reutlingen	SOLADEST460
5199	64150182	BW-Bank/LBBW Tübingen	SOLADEST470
5200	65350186	BW-Bank/LBBW Albstadt	SOLADEST476
5201	64450288	BW-Bank/LBBW Vill.-Schwen.	SOLADEST480
5202	60050101	BW-Bank/LBBW Stuttgart	SOLADEST484
5203	60050101	BW-Bank/LBBW Stuttgart	SOLADEST487
5204	60050101	BW-Bank/LBBW Stuttgart	SOLADEST490
5205	60050101	BW-Bank/LBBW Stuttgart	SOLADEST493
5206	55050000	ZV LBBW Mainz	SOLADEST550
5207	60050101	LBBW/BW-Bank Stuttgart	SOLADEST600
5208	60020030	BW Bank Stuttgart	SOLADEST601
5209	60220030	BW Bank Waiblingen	SOLADEST602
5210	60430060	BW Bank Ludwigsburg	SOLADEST604
5211	60431061	BW Bank Bietigheim-Bissing	SOLADEST605
5212	60320030	BW Bank Sindelfingen	SOLADEST607
5213	61020030	BW Bank Göppingen	SOLADEST610
5214	61120030	BW Bank Esslingen	SOLADEST611
5215	61220030	BW Bank Nürtingen	SOLADEST612
5216	61430000	BW Bank Aalen	SOLADEST614
5217	62030050	BW Bank Heilbronn	SOLADEST620
5218	62230050	BW Bank Schwäbisch Hall	SOLADEST622
5219	67320020	BW Bank Wertheim	SOLADEST623
5220	62030058	BW Bank Lauffen Neckar	SOLADEST624
5221	62030059	BW Bank Neckarsulm	SOLADEST625
5222	62030060	BW Bank Bad Wimpfen	SOLADEST626
5223	63020130	BW Bank Ulm Donau	SOLADEST630
5224	64020030	BW Bank Reutlingen	SOLADEST640
5225	64120030	BW Bank Tübingen	SOLADEST641
5226	64420030	BW Bank VS-Schwenningen	SOLADEST644
5227	65020030	BW Bank Ravensburg	SOLADEST650
5228	66050000	Landesbank Baden-Württ	SOLADEST660
5229	66220020	BW Bank Baden-Baden	SOLADEST662
5230	66020020	BW Bank Karlsruhe	SOLADEST663
5231	66420020	BW Bank Offenburg	SOLADEST664
5232	66620020	BW Bank Pforzheim	SOLADEST666
5233	67050000	Landesbank Baden-Württ	SOLADEST670
5234	67020020	BW Bank Mannheim	SOLADEST671
5235	67220020	BW Bank Heidelberg	SOLADEST672
5236	67332551	BW Bank Tauberbischofsheim	SOLADEST675
5237	68050000	Landesbank Baden-Württ	SOLADEST680
5238	68020020	BW Bank Freiburg Breisgau	SOLADEST682
5239	68320020	BW Bank Lörrach	SOLADEST683
5240	69020020	BW Bank Konstanz	SOLADEST690
5241	69220020	BW Bank Singen	SOLADEST692
5242	69421020	BW Bank Donaueschingen	SOLADEST694
5243	60450193	BW-Bank/LBBW Ludwigsburg	SOLADEST800
5245	60250184	BW-Bank/LBBW Waiblingen	SOLADEST820
5246	60050101	BW-Bank/LBBW Stuttgart	SOLADEST829
5247	60050101	BW-Bank/LBBW Stuttgart	SOLADEST836
5248	61150185	BW-Bank/LBBW Esslingen	SOLADEST840
5249	85020030	ZV LBBW Dresden	SOLADEST850
5250	86020030	ZV LBBW Leipzig	SOLADEST860
5251	86050000	ZV LBBW Leipzig	SOLADEST861
5252	60050101	BW-Bank/LBBW Stuttgart	SOLADEST864
5253	61050181	BW-Bank/LBBW Göppingen	SOLADEST870
5254	60050101	BW-Bank/LBBW Stuttgart	SOLADEST880
5255	60050101	BW-Bank/LBBW Stuttgart	SOLADEST896
5256	60050000	Landesbank Baden-Württ	SOLADESTXXX
5257	34250000	St Spk Solingen	SOLSDE33XXX
5258	37030200	Oppenheim, Sal - jr & Cie	SOPPDE3KXXX
5259	50130200	Oppenheim, Sal - jr & Cie	SOPPDEFFXXX
5260	48050161	Spk Bielefeld	SPBIDE3BXXX
5261	36050105	Sparkasse Essen	SPESDE3EXXX
5262	25050180	Sparkasse Hannover	SPKHDE2HXXX
5263	32050000	Sparkasse Krefeld	SPKRDE33XXX
5264	36250000	Spk Mülheim an der Ruhr	SPMHDE3EXXX
5265	45251515	St Spk Sprockhövel	SPSHDE31XXX
5266	70012200	Bank J. Safra Sarasin, Ffm	SRRADEM1BBK
5267	70150000	Stadtsparkasse München	SSKMDEMMXXX
5268	76050101	Sparkasse Nürnberg	SSKNDE77XXX
5269	55020700	SWK-Bank Bingen	SUFGDE51XXX
5270	70012600	Südt. Sparkasse München	SUSKDEM1XXX
5271	60090700	Südwestbank Stuttgart	SWBSDESSXXX
5272	10220600	Sydbank Berlin	SYBKDE22BER
5273	20030600	Sydbank Hamburg	SYBKDE22HAM
5274	21020600	Sydbank Fil. Kiel	SYBKDE22KIE
5275	21510600	Sydbank Fil. Flensburg	SYBKDE22XXX
5276	51220700	ZIRAAT BANK	TCZBDEFFXXX
5277	76032001	TeamBank Nürnberg GF -AT-	TEAMDE71TAT
5278	76032000	TeamBank Nürnberg	TEAMDE71XXX
5279	74131000	TEBA Kreditbank	TEKRDE71XXX
5280	70015015	transact Berlin 001	TEZGDEB1001
5281	70015025	transact Berlin 002	TEZGDEB1002
5282	70015035	transact Berlin 003	TEZGDEB1003
5283	70015000	Transact Berlin	TEZGDEB1XXX
5284	37020400	TOYOTA Kreditbank Köln	TOBADE33XXX
5285	10310600	Tradegate Berlin	TRDADEB1XXX
5286	58550130	Sparkasse Trier	TRISDE55XXX
5287	50031000	Triodos Bank Deutschland	TRODDEF1XXX
5288	60031000	TRUMPF Financial Ditzingen	TRUFDE66XXX
5289	30030880	HSBC Trinkaus Düsseldorf	TUBDDEDDXXX
5290	30030889	HSBC Trinkaus VAC	TUBDDEDDXXX
5291	50120900	VakifBank Frankfurt	TVBADEFFXXX
5292	50130600	UBS Deutschland Frankfurt/M	UBSWDEFFXXX
5293	30130200	GarantiBank Int Düsseldorf	UGBIDEDDXXX
5294	63090100	Volksbank Ulm-Biberach	ULMVDE66XXX
5295	65090100	Volksbank Ravensburg -alt-	ULMVDE66XXX
5296	65490130	Volksbank Biberach	ULMVDE66XXX
5297	73191500	Illertisser Bank -alt-	ULMVDE66XXX
5298	76035000	UmweltBank Nürnberg	UMWEDE7NXXX
5299	21520100	Union-Bank Flensburg	UNBNDE21XXX
5300	36036000	VALBA	VABKDE3EXXX
5301	70012300	V-Bank München	VBANDEMMXXX
5302	51390000	VB Mittelhessen	VBMHDE5FXXX
5303	73392400	Volksbank Tirol Jungholz	VBOEDE71XXX
5304	66690000	Volksbank Pforzheim	VBPFDE66XXX
5305	66290000	Volksbank Baden-Bdn Rastatt	VBRADE6KXXX
5306	34060094	Volksbank Remscheid-Solingn	VBRSDE33305
5307	34060094	Volksbank Remscheid-Solingn	VBRSDE33330
5308	34060094	Volksbank Remscheid-Solingn	VBRSDE33341
5309	34060094	Volksbank Remscheid-Solingn	VBRSDE33342
5310	34060094	Volksbank Remscheid-Solingn	VBRSDE33343
5311	34060094	Volksbank Remscheid-Solingn	VBRSDE33344
5312	34060094	Volksbank Remscheid-Solingn	VBRSDE33345
5313	34060094	Volksbank Remscheid-Solingn	VBRSDE33346
5314	34060094	Volksbank Remscheid-Solingn	VBRSDE33347
5315	34060094	Volksbank Remscheid-Solingn	VBRSDE33XXX
5316	64090100	Volksbank Reutlingen	VBRTDE6RXXX
5317	50330700	TARGOBANK	VCBADEAFXXX
5318	70012100	VEM Aktienbank München	VEAKDEMMXXX
5319	20030133	Varengold Bank	VGAGDEHHXXX
5320	60090100	Volksbank Stuttgart	VOBADESSXXX
5321	25190001	Hannoversche Volksbank	VOHADE2HXXX
5322	68390000	VB Dreiländereck Lörrach	VOLODE66XXX
5323	10120800	VON ESSEN Bank	VONEDE33BLN
5324	27010200	VON ESSEN Bank Braunschweig	VONEDE33BRA
5325	60020300	VON ESSEN Bank Stuttgart	VONEDE33STG
5326	36010200	VON ESSEN Bankges Essen	VONEDE33XXX
5327	70011200	Bank Vontobel Europe	VONTDEM1XXX
5328	27020000	Volkswagen Bank Braunschwg	VOWADE2BXXX
5329	51091700	vr bank Untertaunus	VRBUDE51XXX
5330	50090200	VR DISKONTBANK	VRDIDEFFXXX
5331	70220800	VVB München	VVAGDEM1XXX
5332	38011001	VÖB-ZVD Frankfurt	VZVDDED1001
5333	38011002	VÖB-ZVD Frankfurt	VZVDDED1002
5334	38011003	VÖB-ZVD Frankfurt	VZVDDED1003
5335	38011004	VÖB-ZVD Frankfurt	VZVDDED1004
5336	38011005	VÖB-ZVD Frankfurt	VZVDDED1005
5337	38011006	VÖB-ZVD Frankfurt	VZVDDED1006
5338	38011007	VÖB-ZVD Frankfurt	VZVDDED1007
5339	38011008	VÖB-ZVD Frankfurt	VZVDDED1008
5340	38011000	VÖB-ZVD Frankfurt	VZVDDED1XXX
5341	60420000	Wüstenrot Bank	WBAGDE61XXX
5342	20120100	M.M. Warburg Bank	WBWCDEHHXXX
5343	30530500	Bank11 Neuss	WEFZDED1XXX
5344	48050000	Ld Bk Hess-Thür, Gz, Dus	WELADE3BXXX
5345	44050000	Ld Bk Hess-Thür, Gz, Dus	WELADE3DXXX
5346	36050000	Ld Bk Hess-Thür, Gz, Dus	WELADE3EXXX
5347	45050001	Sparkasse Hagen	WELADE3HXXX
5348	47650130	Spk Paderborn-Detmold	WELADE3LXXX
5349	40050000	Ld Bk Hess-Thür, Gz, Dus	WELADE3MXXX
5350	40154530	Sparkasse Westmünsterland	WELADE3WXXX
5351	86055592	St u Kr Spk Leipzig	WELADE8LXXX
5352	10050600	Ld Bk Hess-Thür, Gz, Dus	WELADEBBXXX
5353	46251630	Spk Attend-Lennest-Kirchhdm	WELADED1ALK
5354	46650005	Spk Arnsberg-Sundern	WELADED1ARN
5355	87056000	Kr Spk Aue-Schwarzenbg -alt	WELADED1AUS
5356	46053480	Sparkasse Wittgenstein	WELADED1BEB
5357	41250035	Spk Beckum-Wadersloh	WELADED1BEK
5358	41051845	Spk Bergkamen-Bönen	WELADED1BGK
5359	47651225	St Spk Blomberg	WELADED1BLO
5360	43050001	Sparkasse Bochum	WELADED1BOC
5361	42850035	Stadtsparkasse Bocholt	WELADED1BOH
5362	42451220	Spk Bottrop	WELADED1BOT
5363	46451250	Spk Bestwig -alt-	WELADED1BST
5364	46051240	Spk Burbach-Neunkirchen	WELADED1BUB
5365	18050000	Sparkasse Spree-Neiße	WELADED1CBN
5366	47251740	St Spk Delbrück	WELADED1DEL
5367	35251000	Spk Dinslaken-Voerde-Hünxe	WELADED1DIN
5368	18051000	Sparkasse Elbe-Elster	WELADED1EES
5369	35850000	St Spk Emmerich-Rees	WELADED1EMR
5370	40153768	Sparkasse Emsdetten Ochtrup	WELADED1EMS
5371	45451060	Spk Ennepetal-Breckerfeld	WELADED1ENE
5372	31251220	Kr Spk Heinsberg Erkelenz	WELADED1ERK
5373	41651815	Spk Erwitte-Anröchte	WELADED1ERW
5374	38250110	Kreissparkasse Euskirchen	WELADED1EUS
5375	87052000	Spk Mittelsachsen	WELADED1FGX
5376	46051733	St Spk Freudenberg Westf	WELADED1FRE
5377	44351740	Sparkasse Fröndenberg	WELADED1FRN
5378	46251590	Spk Finnentrop	WELADED1FTR
5379	42050001	Sparkasse Gelsenkirchen	WELADED1GEK
5380	41651965	Sparkasse Geseke	WELADED1GES
5381	45450050	St Spk Gevelsberg	WELADED1GEV
5382	42450040	St Spk Gladbeck	WELADED1GLA
5383	38450000	Spk Gummersbach-Bergneust	WELADED1GMB
5384	32250050	Verb Spk Goch	WELADED1GOC
5385	85050100	Spk Oberlausitz-Niederschl.	WELADED1GRL
5386	40154006	Spk Gronau	WELADED1GRO
5387	47850065	Spk Gütersloh	WELADED1GTL
5388	17052000	Sparkasse Barnim Eberswalde	WELADED1GZE
5389	30351220	St Spk Haan	WELADED1HAA
5390	41050095	Sparkasse Hamm	WELADED1HAM
5391	42651315	St Spk Haltern	WELADED1HAT
5392	48051580	Kreissparkasse Halle	WELADED1HAW
5393	44551210	Spk Märkisches Sauerland	WELADED1HEM
5394	38651390	Sparkasse Hennef	WELADED1HEN
5395	45051485	St Spk Herdecke	WELADED1HER
5396	33451220	Spk Heiligenhaus -alt-	WELADED1HGH
5397	46051875	St Spk Hilchenbach	WELADED1HIL
5398	38051290	St Spk Bad Honnef	WELADED1HON
5399	43250030	Herner Sparkasse	WELADED1HRN
5400	41651770	Spk Hochsauerland Brilon	WELADED1HSL
5401	43051040	Sparkasse Hattingen	WELADED1HTG
5402	47251550	Spk Höxter Brakel	WELADED1HXB
5403	40351220	Sparkasse Steinfurt -alt-	WELADED1IBB
5404	44550045	Spk der Stadt Iserlohn	WELADED1ISL
5405	44351380	Sparkasse Kamen -alt-	WELADED1KAM
5406	32450000	Sparkasse Kleve	WELADED1KLE
5407	45851665	Spk Kierspe-Meinerzhagen	WELADED1KMZ
5408	30150200	Kr Spk Düsseldorf	WELADED1KSD
5409	30551240	St Spk Kaarst Büttgen -alt-	WELADED1KST
5410	37551780	St Spk Langenfeld	WELADED1LAF
5411	37551020	St Spk Leichlingen Rheinl	WELADED1LEI
5412	48250110	Sparkasse Lemgo	WELADED1LEM
5413	40154476	St Spk Lengerich	WELADED1LEN
5414	41650001	Spk Lippstadt	WELADED1LIP
5415	17055050	Sparkasse Oder-Spree	WELADED1LOS
5416	45850005	Spk Lüdenscheid	WELADED1LSD
5417	44152370	Sparkasse Lünen	WELADED1LUN
5418	44750065	Sparkasse Menden -alt-	WELADED1MEN
5419	46451012	Sparkasse Meschede	WELADED1MES
5420	49050101	Sparkasse Minden-Lübbecke	WELADED1MIN
5421	17054040	Spk Märkisch-Oderland	WELADED1MOL
5422	35450000	Sparkasse am Niederrhein	WELADED1MOR
5423	40050150	Spk Münsterland Ost	WELADED1MST
5424	87051000	Spk Mittelsachsen	WELADED1MTW
5425	35451460	Spk Neukirchen-Vluyn -alt-	WELADED1NVL
5426	36550000	St Spk Oberhausen	WELADED1OBH
5427	49051285	St Spk Bad Oeynhausen	WELADED1OEH
5428	46250049	Spk Olpe-Drolshagen-Wenden	WELADED1OPE
5429	16050202	Spk Ostprignitz-Ruppin	WELADED1OPR
5430	18055000	Sparkasse Niederlausitz	WELADED1OSL
5431	47250101	Sparkasse Paderborn -alt-	WELADED1PBN
5432	45851020	Ver Spk Plettenberg	WELADED1PLB
5433	87058000	Sparkasse Vogtland	WELADED1PLX
5434	16050000	Mittelbrandenbg Sparkasse	WELADED1PMB
5435	16050101	Sparkasse Prignitz	WELADED1PRP
5436	49051990	St Spk Porta Westfalica	WELADED1PWF
5437	42650150	Spk Recklinghausen	WELADED1REK
5438	35451775	Spk Rheinberg -alt-	WELADED1RHB
5439	49051065	Stadtsparkasse Rahden	WELADED1RHD
5440	40350005	St Spk Rheine	WELADED1RHN
5441	47852760	Spk Rietberg	WELADED1RTG
5442	34051350	Spk Radevormwald-Hückeswgn	WELADED1RVW
5443	38650000	Kr Spk Siegburg	WELADED1SGB
5444	46050001	Spk Siegen	WELADED1SIE
5445	45451555	St Spk Schwelm	WELADED1SLM
5446	46052855	St Spk Schmallenberg Sauerl	WELADED1SMB
5447	41450075	Sparkasse Soest	WELADED1SOS
5448	87054000	Erzgebirgssparkasse	WELADED1STB
5449	40351060	Kr Spk Steinfurt	WELADED1STF
5450	40154702	St Spk Stadtlohn	WELADED1STL
5451	32051996	Sparkasse Straelen	WELADED1STR
5452	44152490	Sparkasse Schwerte	WELADED1SWT
5453	86050600	Kr Spk Torgau-Oschatz -alt-	WELADED1TGU
5454	17056060	Spk Uckermark Prenzlau	WELADED1UMP
5455	17052302	St Spk Schwedt	WELADED1UMX
5456	44350060	Sparkasse UnnaKamen	WELADED1UNN
5457	33450000	Sparkasse HRV	WELADED1VEL
5458	47853355	St Spk Versmold	WELADED1VSM
5459	41652560	Spk Warstein-Rüthen -alt-	WELADED1WAR
5460	10120100	Weberbank	WELADED1WBB
5461	47853520	Kreissparkasse Wiedenbrück	WELADED1WDB
5462	35650000	Verb Spk Wesel	WELADED1WES
5463	45251480	St Spk Wetter Ruhr	WELADED1WET
5464	38452490	Sparkasse Wiehl	WELADED1WIE
5465	34051570	St Spk Wermelskirchen	WELADED1WMK
5466	41451750	Sparkasse Werl	WELADED1WRL
5467	41051605	St Spk Werne	WELADED1WRN
5468	45250035	Sparkasse Witten	WELADED1WTN
5469	87055000	Sparkasse Zwickau	WELADED1ZWI
5470	30050000	Ld Bk Hess-Thür, Gz, Dus	WELADEDDXXX
5471	37551440	Sparkasse Leverkusen	WELADEDLLEV
5472	30550000	Sparkasse Neuss	WELADEDNXXX
5473	34050000	St Spk Remscheid	WELADEDRXXX
5474	50150000	Ld Bk Hess-Thür, Gz, Dus	WELADEFFXXX
5475	20350000	Ld Bk Hess-Thür, Gz, Dus	WELADEHHXXX
5476	30530000	Bankhaus Werhahn Neuss	WERHDED1XXX
5477	51090000	Wiesbadener Volksbank	WIBADE5WXXX
5478	51230800	Wirecard Bank	WIREDEMMXXX
5479	70020300	Commerz Finanz München	WKVBDEM1XXX
5480	49450120	Sparkasse Herford	WLAHDE44XXX
5481	20030900	Wölbernbank Hamburg	WOELDEHHXXX
5482	60410600	Wüstenrot Bank Pfandbriefbk	WUEHDE61XXX
5483	33050000	St Spk Wuppertal	WUPSDE33XXX
5484	37030700	abcbank Köln	WWBADE3AXXX
5485	10070000	Deutsche Bank Fil Berlin	
5487	10070024	Deutsche Bank PGK Berlin	
5489	10090000	Berliner VB Falkensee	
5490	10090000	Berliner VB Königs Wusterhs	
5491	10090000	Berliner VB Großbeeren	
5492	10090000	Berliner VB Neuruppin	
5493	10090000	Berliner VB Oranienburg	
5494	10090000	Berliner VB Strausberg	
5495	10090000	Berliner VB Zehdenick	
5496	10090000	Berliner Volksbank Beelitz	
5497	10090000	Berliner VB Treuenbrietzen	
5498	10090000	Berliner VB Halbe	
5499	10090000	Berliner VB Bernau	
5500	10090000	Berliner VB Nauen	
5501	10090000	Berliner VB Kremmen	
5502	10090000	Berliner VB Hohen Neuendorf	
5503	10090000	Berliner VB Werder	
5504	10090000	Berliner VB Kyritz	
5505	10090000	Berliner VB Wittstock	
5506	10090000	Berliner VB Gransee	
5507	10090000	Berliner Volksbank Saarmund	
5508	10090000	Berliner Volksbank	
5511	10090000	Berliner VB Hennigsdorf	
5512	10090000	Berliner VB Löwenberg	
5513	10090000	Berliner VB Fürstenberg	
5514	10090000	Berliner VB Joachimsthal	
5515	10090000	Berliner VB Oberkrämer	
5516	10090000	Berliner VB Eberswalde	
5517	10090000	Berliner VB Neuenhagen	
5518	10090000	Berliner VB Glienicke	
5519	10090000	Berliner VB Michendorf	
5520	10090000	Berliner VB Teltow	
5521	10090000	Berliner VB Berlin	
5522	10090000	Berliner VB Rheinsberg	
5523	10090000	Berliner VB Velten	
5524	10090000	Volksbank Potsdam	
5525	10090603	apoBank Rostock	
5526	10120760	UniCredit exHypo Ndl260 Bln	
5527	12030000	Deutsche Kreditbk Chemnitz	
5528	12030000	Deutsche Kreditbank Leipzig	
5529	12030000	Deutsche Kreditbank Dresden	
5530	12030000	Deutsche Kreditbank Suhl	
5531	12030000	Deutsche Kreditbank Gera	
5532	12030000	Deutsche Kreditbank Erfurt	
5533	12030000	Deutsche Kreditbank Halle	
5534	12030000	Deutsche Kreditbk Magdeburg	
5535	12030000	Deutsche Kreditbank Cottbus	
5536	12030000	Deutsche Kreditbank Ff/Oder	
5537	12030000	Deutsche Kreditbank Potsdam	
5538	12030000	Deutsche Kreditbk Neubrandb	
5539	12030000	Deutsche Kreditbk Schwerin	
5540	12030000	Deutsche Kreditbank Rostock	
5541	12030000	Deutsche Kreditbank (Gf P2)	
5542	12070000	Deutsche Bank Ld Brandenbg	
5543	12070024	Deutsche Bank PGK Brandenbg	
5544	12096597	Sparda-Bank Berlin	
5584	13040000	Commerzbank Wismar	
5585	13040000	Commerzbank Roggentin	
5586	13050000	Ostseesparkasse Rostock	
5590	13061008	Volksbank Wolgast	
5591	13061078	VB u Raiffbk	
5604	13061128	Raiffeisenbank Bad Doberan	
5605	13070000	Deutsche Bank Grevesmühlen	
5606	13070000	Deutsche Bk Reuterst Stvnhg	
5607	13070024	Deutsche Bank PGK Barth	
5608	13070024	Deutsche Bank PGK Grevesmüh	
5609	13070024	Deutsche Bank PGK Reutersta	
5610	13090000	Rostocker VR Bank	
5611	13091054	Pommersche Volksbank	
5612	14040000	Commerzbank Parchim	
5613	14051000	Spk Mecklenburg-Nordwest	
5627	14051362	Sparkasse Parchim-Lübz	
5628	14052000	Spk Mecklenburg-Schwerin	
5643	14061308	VB u Raiffbk Lübz	
5644	14061308	VB u Raiffbk Bützow	
5645	14061308	VB u Raiffbk Dobbertin	
5646	14061308	VB u Raiffbk Goldberg	
5647	14061308	VB u Raiffbk Krakow am See	
5648	14061308	VB u Raiffbk Laage	
5649	14061308	VB u Raiffbk Lalendorf	
5650	14061308	VB u Raiffbk Schwaan	
5651	14061308	VB u Raiffbk Plau	
5652	14061308	VB u Raiffbk Brüel	
5653	14061308	VB u Raiffbk Dabel	
5654	14061308	VB u Raiffbk Sternberg	
5655	14061308	VB u Raiffbk Warin	
5656	14061308	VB u Raiffbk Güstrow	
5657	14080000	Commerzbank Wismar	
5658	14080000	Commerzbank Parchim	
5659	14091464	VR-Bank Schwerin	
5662	15040068	Commerzbank Greifswald	
5663	15040068	Commerzbank Stralsund	
5664	15040068	Commerzbank Bergen Rügen	
5665	15040068	Commerzbank Waren	
5666	15040068	Commerzbank Pasewalk	
5667	15050100	Müritz-Sparkasse Röbel	
5668	15050200	Spk Neubrandenburg-Demmin	
5677	15050400	Spk Uecker-Randow Strasburg	
5678	15050400	Spk Uecker-Randow Torgelow	
5679	15050400	Spk Uecker-Randow Eggesin	
5680	15050400	Spk Uecker-Rand Ferdinandsh	
5681	15050400	Spk Uecker-Randow Jatznick	
5682	15050400	Spk Uecker-Randow Löcknitz	
5683	15050400	Spk Uecker-Randow Penkun	
5684	15050400	Spk Uecker-Randow Ueckermde	
5685	15050500	Spk Vorpommern	
5721	15051732	Spk Meckl-Strelitz Friedl	
5722	15051732	Spk Meckl-Strelitz Burg Sta	
5723	15051732	Spk Meckl-Strelitz Woldegk	
5724	15051732	Spk Meckl-Strelitz Wesenbg	
5725	15051732	Spk Meckl-Strelitz Mirow	
5726	15051732	Spk Meckl-Strelitz Feldberg	
5727	15061618	Raiffbk Mecklenb Seenplatte	
5741	15061638	Volksbank Raiffeisenbank	
5753	15061698	Raiffeisenbank Malchin	
5754	15061698	Raiffbk Malchin Dargun	
5755	15061698	Raiffbk Malchin Neukalen	
5756	15061698	Raiffbk Malchin Gielow	
5757	15061698	Raiffbk Malchin Stavenhagen	
5759	15080000	Commerzbank Greifswald	
5760	15080000	Commerzbank Stralsund	
5761	15080000	Commerzbank Waren	
5762	15080000	Commerzbank Pasewalk	
5763	15091674	Volksbank Demmin	
5764	15091704	VR-Bank Uckermark-Randow	
5777	16040000	Commerzbank Brandenburg	
5778	16040000	Commerzbank Erkner	
5779	16040000	Commerzbank Neuruppin	
5780	16040000	Commerzbank Wittenberge	
5781	16040000	Commerzbank Ludwigsfelde	
5782	16040000	Commerzbank Luckenwalde	
5783	16040000	Commerzbank Neustrelitz	
5784	16040000	Commerzbank Oranienburg	
5785	16040000	Commerzbank Teltow	
5786	16040000	Commerzbank Hennigsdorf	
5787	16040000	Commerzbank Falkensee	
5788	16040000	Commerzbank Rathenow	
5789	16040000	Commerzbank Belzig	
5790	16040000	Commerzbank Zehdenick	
5791	16040000	Commerzbank Nauen	
5792	16040000	Commerzbank Strausberg	
5793	16040000	Commerzbank Kön Wusterhsn	
5794	16040000	Commerzbank Angermünde	
5795	16050101	Spk Prignitz Bad Wilsnack	
5796	16050101	Spk Prignitz Breese	
5797	16050101	Spk Prignitz Glöwen	
5798	16050101	Spk Prignitz Karstädt	
5799	16050101	Spk Prignitz Lindenberg	
5800	16050101	Spk Prignitz Meyenburg	
5801	16050101	Spk Prignitz Perleberg	
5802	16050101	Spk Prignitz Wittenberge	
5803	16050101	Spk Prignitz Lenzen Elbe	
5804	16050101	Spk Prignitz Putlitz	
5805	16050202	Spk Ostprignitz-Ruppin	
5815	16060122	Volks- u Raiffbk Prignitz	
5822	16061938	Raiffeisenbank Ostpr-Ruppin	
5830	16062008	VR-Bank Fläming	
5835	16062073	Brandenburger Bank	
5840	16080000	Commerzbank Brandenburg	
5841	16080000	Commerzbank Eberswalde	
5842	16080000	Commerzbank Oranienburg	
5843	16080000	Commerzbank Wittenberge	
5844	16080000	Commerzbank Angermünde	
5845	16080000	Commerzbank Luckenwalde	
5846	16080000	Commerzbank Belzig	
5847	16080000	Commerzbank Zehdenick	
5848	16080000	Commerzbank Nauen	
5849	16080000	Commerzbank Strausberg	
5850	16080000	Commerzbank Eisenhüttenst	
5851	16080000	Commerzbank Salzwedel	
5852	16080000	Commerzbank Falkensee	
5853	16080000	Commerzbank Hennigsdorf	
5854	16080000	Commerzbank Kön Wusterhsn	
5855	16080000	Commerzbank Ludwigsfelde	
5856	16080000	Commerzbank Rathenow	
5857	16080000	Commerzbank Stendal	
5858	16091994	Volksbank Rathenow	
5859	17040000	Commerzbank Eberswalde	
5860	17040000	Commerzbank Eisenhüttenst	
5861	17040000	Commerzbank Schwedt	
5862	17040000	Commerzbank Fürstenwalde	
5863	17040000	Commerzbank Wildau	
5864	17052000	Sparkasse Barnim Bernau	
5865	17055050	Sparkasse Oder-Spree	
5868	17056060	Spk Uckermark Templin	
5869	17056060	Spk Uckermark Angermünde	
5870	17056060	Spk Uckermark Gerswalde	
5871	17056060	Spk Uckermark Boitzenburg	
5872	17056060	Spk Uckermark Lychen	
5873	17056060	Spk Uckermark Fürstenwerder	
5874	17056060	Spk Uckermark Gramzow	
5875	17056060	Spk Uckermark Brüssow	
5876	17056060	Spk Uckermark Gartz	
5877	17062428	Raiff-VB Oder-Spree Beeskow	
5878	17080000	Commerzbank Fürstenwalde	
5879	17092404	VR Bank Fürstenwalde	
5891	18040000	Commerzbank Guben	
5892	18040000	Commerzbank Senftenberg	
5893	18040000	Commerzbank Spremberg	
5894	18040000	Commerzbank Lübben	
5895	18040000	Commerzbank Herzberg	
5896	18040000	Commerzbank Bad Liebenwerda	
5897	18040000	Commerzbank Forst	
5898	18040000	Commerzbank Luckau	
5899	18050000	Sparkasse Spree-Neiße	
5902	18055000	Sparkasse Niederlausitz	
5914	18062678	VR Bank Lausitz	
5917	18080000	Commerzbank Lübben	
5918	18080000	Commerzbank Herzberg	
5919	18080000	Commerzbk Bad Liebenwerda	
5920	18080000	Commerzbank Forst	
5921	18080000	Commerzbank Luckau	
5922	18092684	Spreewaldbank Lübben	
5924	18092744	Volksbank Spree-Neiße	
5927	20040000	Commerzbank Bad Oldesloe	
5928	20040000	Commerzbank Ahrensburg	
5929	20040000	Commerzbank Wedel Holst	
5930	20040000	Commerzbank Reinbek	
5931	20040000	Commerzbank Norderstedt	
5932	20040000	Commerzbank Winsen Luhe	
5933	20040000	Commerzbank Glinde Stormarn	
5934	20040000	Commerzbank Buxtehude	
5935	20040000	Commerzbank Geesthacht	
5936	20040000	Commerzbank Quickborn Holst	
5937	20050550	Haspa Wentorf Hamburg	
5938	20050550	Haspa Wedel Holstein	
5939	20050550	Haspa Neu-Wulmstorf	
5940	20050550	Haspa Buchholz	
5941	20050550	Haspa Bargteheide	
5942	20050550	Haspa Geesthacht	
5943	20050550	Haspa Glinde	
5944	20050550	Haspa Reinbek	
5945	20050550	Haspa Rellingen	
5946	20050550	Haspa Schenefeld	
5947	20050550	Haspa Seevetal	
5948	20050550	Haspa Uetersen	
5949	20050550	Haspa Winsen Luhe	
5950	20050550	Haspa Buxtehude	
5951	20069111	Norderstedter Bank	
5952	20069125	Kaltenkirchener Bank	
5955	20069130	Raiffbk	
5966	20069144	Raiffeisenbank Seestermühe	
5967	20069177	Raiffbk Südstormarn	
5973	20069177	Raiffbk Südstormarn Mölln	
5981	20069232	Raiffbk Struvenhütten	
5982	20069641	Raiffeisenbank Owschlag	
5984	20069780	Volksbank Ahlerstedt	
5985	20069782	Volksbank Geest	
5995	20069786	VB Kehdingen	
6001	20069800	Spar- und Kreditbank Hammah	
6003	20069812	VB Fredenbeck-Oldendorf	
6005	20069815	Volksbank Oldendorf	
6007	20069861	Raiffeisenbank Ratzeburg	
6010	20069882	Raiffeisenbank Travemünde	
6011	20069965	VB Winsener Marsch	
6013	20069989	Volksbank Wulfsen	
6015	20080000	Commerzbank Buxtehude	
6016	20080000	Commerzbank Stade	
6017	20080000	Commerzbank Quickborn	
6018	20080000	Commerzbank Norderstedt	
6019	20080000	Commerzbank Ahrensburg	
6020	20080000	Commerzbank Wedel Holst	
6021	20090700	Edekabank Hamburg	
6022	20130412	GRENKE BANK Hamburg	
6023	20130600	Barclaycard (Gf P2)	
6024	20190003	Hamburger Volksbank	
6030	20190109	VB Stormarn	
6031	20190109	Volksbank Stormarn	
6041	20190206	VB Hamburg Ost-West -alt-	
6042	20190301	Vierländer VB Hamburg	
6043	20210200	Bank Melli Iran Hamburg	
6044	20210300	Bank Saderat Iran Hamburg	
6045	20310300	Europ-Iran Handelsbk Hambg	
6046	20690500	Sparda-Bank Hamburg	
6048	20750000	Spk Harburg-Buxtehude	
6062	21040010	Commerzbank Schleswig	
6063	21050170	Förde Sparkasse	
6094	21051275	Bordesholmer Sparkasse	
6100	21060237	Ev. Darlehnsgen. Kiel	
6101	21090007	Kieler Volksbank	
6111	21092023	Eckernförder Bank VRB	
6116	21240040	Commerzbank Wahlstedt	
6117	21290016	VR Bank Neumünster	
6131	21352240	Spk Holstein Bad Schwartau	
6132	21352240	Spk Holstein Ahrensbök	
6133	21352240	Spk Holstein Lensahn	
6134	21352240	Spk Holstein Bad Malente	
6135	21352240	Spk Holstein Neustadt	
6136	21352240	Spk Holstein Grömitz	
6137	21352240	Spk Holstein Kellenhusen	
6138	21352240	Spk Holstein Burg	
6139	21352240	Spk Holstein Oldenburg	
6140	21352240	Spk Holstein Pansdorf	
6141	21352240	Spk Holstein Scharbeutz	
6142	21352240	Spk Holstein Schönwalde	
6143	21352240	Spk Holstein Stockelsdf	
6144	21352240	Spk Holstein Timmend Strand	
6145	21352240	Spk Holstein Heiligenhafen	
6146	21352240	Spk Holstein Ahrensburg	
6147	21352240	Spk Holstein Ammersbek	
6148	21352240	Spk Holstein Bargteheide	
6149	21352240	Spk Holstein Barsbüttel	
6150	21352240	Spk Holstein Glinde	
6151	21352240	Spk Holstein Großhansdorf	
6152	21352240	Spk Holstein Hamburg	
6153	21352240	Spk Holstein Lütjensee	
6154	21352240	Spk Holstein Norderstedt	
6155	21352240	Spk Holstein Oststeinbek	
6156	21352240	Spk Holstein Reinbek	
6157	21352240	Spk Holstein Reinfeld	
6158	21352240	Spk Holstein Stapelfeldt	
6159	21352240	Spk Holstein Tangstedt	
6160	21352240	Spk Holstein Trittau	
6161	21352240	Spk Holstein Bad Oldesloe	
6162	21390008	VR Bk Ostholstein Nord-Plön	
6181	21392218	Volksbank Eutin	
6187	21450000	Spk Mittelholst Schacht-Aud	
6188	21450000	Spk Mittelholstein Rendsbg	
6189	21450000	Spk Mittelholstein Felde	
6190	21450000	Spk Mittelholst Hanerau-Hdm	
6191	21450000	Spk Mittelholstein Nortorf	
6192	21450000	Spk Mittelholst Osterrönfd	
6193	21450000	Spk Mittelholst Westerrönfd	
6194	21452030	Spk Aukrug	
6195	21452030	Spk Todenbüttel	
6196	21452030	Spk Wasbek	
6197	21463603	VB-Raiffbk i Kr Rendsburg	
6212	21464671	Raiffbk Todenbüttel	
6213	21464671	Raiffeisenbank Todenbüttel	
6214	21520100	Union-Bank Harrislee	
6215	21565316	Raiffbk Handewitt	
6216	21565316	Raiffeisenbank Handewitt	
6219	21661719	VR Bank Flensburg-Schleswig	
6234	21690020	Schleswiger Volksbank	
6245	21750000	Nord-Ostsee Spk Schleswig	
6295	21751230	Spk Langenhorn	
6296	21762550	Husumer Volksbank	
6312	21763542	VR Bank Niebüll	
6326	21791805	Sylter Bank	
6327	21791906	Föhr-Amrumer Bank	
6331	21852310	Spk Hennstedt-Wesselburen	
6338	21860418	Raiffeisenbank Heide	
6348	21890022	Dithmarscher VB Heide	
6359	22140028	Commerzbank Stade	
6360	22141028	Commerzbank Henstedt-Ulzbg	
6361	22163114	Raiffbk Elbmarsch Heist	
6365	22190030	Volksbank Elmshorn	
6367	22190030	VB Elmshorn Glückstadt	
6373	22191405	VR Bank Pinneberg	
6385	22250020	Spk Westholstein	
6406	22250020	SpK Westholstein	
6411	22250020	SPK Westholstein	
6413	22260136	Raiffeisenbank Itzehoe	
6426	22290031	VB Raiffbk Itzehoe	
6434	22290031	VB Raiffeisenbk Itzehoe	
6449	23040022	Commerzbank Mölln	
6450	23040022	Commerzbank Bad Schwartau	
6451	23051030	Spk Südholstein Neumünster	
6476	23061220	Raiffeisenbank Leezen	
6484	23062124	Raiffeisenbank Bargteheide	
6487	23062807	Volks- u Raiffbk Mölln	
6495	23063129	Raiffeisenbank Lauenburg	
6499	23064107	Raiffeisenbank Büchen	
6510	23070700	Deutsche Bank PGK Lübeck	
6523	23080040	Commerzbank Bad Schwartau	
6524	23090142	Volksbank Lübeck	
6527	24050110	Spk Lüneburg	
6541	24060300	VB Lüneburger Heide	
6585	24090041	VB Lüneburg	
6586	24151005	Spk Stade-Altes Land	
6591	24151116	Kreissparkasse Stade	
6601	24151235	Spk Rotenburg-Bremervörde	
6614	24161594	Zevener Volksbank	
6622	24162898	Spar- u Darlehnskasse Börde	
6625	24191015	Volksbank Stade-Cuxhaven	
6639	25020600	Santander Consumer Bank	
6668	25040066	Commerzbank Garbsen	
6669	25040066	Commerzbank Alfeld Leine	
6670	25040066	Commerzbank Hemmingen Han	
6671	25040066	Commerzbank Lehrte	
6672	25040066	Commerzbank Langenhagen	
6673	25040066	Commerzbank Laatzen	
6674	25040066	Commerzbank Sarstedt	
6675	25040066	Commerzbank Walsrode	
6676	25040066	Commerzbank Wunstorf	
6677	25040066	Commerzbank Burgdorf Hannov	
6678	25040066	Commerzbank Gehrden Han	
6679	25040066	Commerzbank Neustadt Rübe	
6680	25040066	Commerzbank Stadthagen	
6681	25040066	Commerzbank Springe	
6682	25040066	Commerzbank Barsinghausen	
6683	25040066	Commerzbank Burgwedel	
6684	25050000	NORD/LB Landessparkasse	
6728	25050000	Nord LB Halle	
6729	25050000	Nord LB Leipzig	
6730	25050000	Nord LB Magdeburg	
6731	25050000	Nord LB Schwerin	
6732	25050000	Nord LB Hamburg	
6734	25050180	Sparkasse Hannover	
6754	25050299	Kr Spk Hannover -alt-	
6755	25069168	VB u RB Leinebgld Delligsen	
6759	25069262	Raiff-VB Neustadt	
6760	25069270	Volksbank Aller-Oker	
6761	25069370	VB Vechelde-Wendeburg	
6765	25069503	VB Diepholz-Barnstorf	
6769	25080020	Commerzbank Gehrden Han	
6770	25080020	Commerzbank Neustadt Rübe	
6771	25080020	Commerzbank Stadthagen	
6772	25080020	Commerzbank Springe	
6773	25080020	Commerzbank Barsinghausen	
6774	25080020	Commerzbank Langenhagen	
6775	25080020	Commerzbank Burgwedel	
6776	25090500	Sparda-Bank Bremen	
6777	25090500	Sparda-Bank Braunschweig	
6778	25090500	Sparda-Bank Bielefeld	
6779	25090500	Sparda-Bank Göttingen	
6780	25090500	Sparda-Bank Minden	
6781	25090500	Sparda-Bank Hameln	
6782	25090500	Sparda-Bank Celle	
6783	25090500	Sparda-Bank Bremerhaven	
6784	25090500	Sparda-Bank Hildesheim	
6785	25090500	Sparda-Bank Detmold	
6786	25090500	Sparda-Bank Delmenhorst	
6787	25090500	Sparda-Bank Gütersloh	
6788	25090500	Sparda-Bank Herford	
6789	25120510	Bank für Sozialwirtschaft	
6790	25152375	Kr Spk Fallingbostel	
6795	25190001	Hannoversche Volksbank	
6812	25190001	Hannoversche VB	
6815	25190001	Volksbank Celle	
6816	25193331	Volksbank Gehrden, Han	
6817	25193331	Volksbank Laatzen	
6818	25193331	Volksbank Ronnenberg	
6819	25193331	Volksbank Wennigsen Deister	
6820	25193331	Volksbank Springe, Deister	
6821	25193331	Volksbank Hemmingen, Han	
6822	25193331	Volksbank Sehnde	
6823	25193331	Volksbank Lehrte	
6824	25193331	Volksbank	
6825	25250001	Kr Spk Peine	
6831	25260010	Volksbank Peine	
6837	25450110	Spk Weserbergland Polle	
6838	25450110	Spk Weserbergland Aerzen	
6839	25450110	Spk Weserbergland Emmerthal	
6840	25450110	Spk Weserbergland Coppenbr	
6841	25450110	Spk Weserbergland Salzhemm	
6842	25450110	Spk Weserbergland B Münder	
6843	25462160	VB Hameln-Stadthagen	
6863	25462680	VB im Wesertal Coppenbrügge	
6866	25491273	Volksbank Aerzen	
6869	25491744	Volksbank Bad Münder	
6870	25551480	Sparkasse Schaumburg	
6891	25591413	Volksbank in Schaumburg	
6903	25621327	Oldb Landesbank Barnstorf	
6904	25621327	Oldb Landesbank Wagenfeld	
6905	25650106	Sparkasse Nienburg	
6918	25650106	Spk Nienburg	
6928	25651325	Kr Spk Diepholz	
6945	25662540	Volksbank Steyerberg	
6956	25663584	Volksbank Aller-Weser	
6967	25690009	Volksbank Nienburg	
6976	25691633	Volksbank Sulingen	
6989	25750001	Sparkasse Winsen Aller	
6990	25750001	Sparkasse Wietze	
6991	25750001	Sparkasse Wienhausen	
6992	25750001	Sparkasse Wathlingen	
6993	25750001	Sparkasse Unterlüß	
6994	25750001	Sparkasse Eschede	
6995	25750001	Sparkasse Hermannsburg	
6996	25750001	Sparkasse Faßberg	
6997	25750001	Sparkasse Nienhagen Celle	
6998	25750001	Sparkasse Hambühren	
6999	25750001	Sparkasse Lachendorf	
7000	25750001	Sparkasse Bergen Celle	
7001	25761894	Volksbank Wittingen-Klötze	
7005	25791516	Volksbank Hankensbüttel	
7011	25791635	Volksbank Südheide	
7032	25841403	Commerzbank Salzwedel	
7033	25850110	Sparkasse Uelzen Lüchow-Dbg	
7052	25851660	Kr Spk Soltau	
7057	25861990	Volksbank Clenze-Hitzacker	
7063	25862292	Volksbank Uelzen-Salzwedel	
7076	25863489	VB Osterbg-Lüchow-Dannenbg	
7094	25891636	VB Lüneburger Heide	
7095	25950130	Sparkasse Hildesheim	
7114	25990011	Volksbank Hildesheim	
7122	25991528	VB Hildesheimer Börde	
7123	26050001	Sparkasse Göttingen	
7129	26051260	Sparkasse Duderstadt	
7132	26051450	Kr u St Spk Münden	
7135	26061291	Volksbank Mitte	
7147	26061556	Volksbank Adelebsen	
7149	26062433	VR-Bank in Südniedersachsen	
7156	26090050	Volksbank Göttingen	
7157	26240039	Commerzbank Einbeck	
7158	26250001	Kr Spk Northeim	
7166	26251425	Sparkasse Einbeck	
7167	26261396	Volksbank Dassel	
7168	26261492	Volksbank Einbeck	
7173	26261693	Volksbank Solling Hardegsen	
7178	26351015	Sparkasse Osterode am Harz	
7183	26361299	VB Oberharz Bad Grund	
7186	26520017	Oldb Landesbank Bissendorf	
7187	26520017	Oldb Landesbank Bad Essen	
7188	26520017	Oldb Landesbank Bohmte	
7189	26520017	Oldb Landesbank Wallenhorst	
7190	26520017	Oldb Landesbank Melle	
7191	26520017	Oldb Landesbank Hagen	
7192	26521703	Oldb Ldbank Neuenkirchen	
7193	26521703	Oldb Landesbank Merzen	
7194	26522319	Oldb Landesbank Essen Oldb	
7195	26522319	Oldb Landesbank Nortrup	
7196	26522319	Oldb Landesbank Fürstenau	
7197	26522319	Oldb Landesbank Badbergen	
7198	26522319	Oldb Landesbank Bersenbrück	
7199	26522319	Oldb Landesbank Ankum	
7200	26540070	Commerzbank Dissen Teutobg	
7201	26540070	Commerzbank Melle	
7202	26550105	Sparkasse Osnabrück	
7217	26551540	Kr Spk Bersenbrück	
7234	26562490	VB Laer-Borgl-Hilter-Melle	
7238	26563960	VB Bramgau-Wittlage	
7245	26565928	VB GMHütte-Hagen-Bissendorf	
7251	26566939	VB Osnabrücker Nd	
7256	26567943	VR-Bank i.Altkr.Bersenbrück	
7263	26580070	Commerzbank Dissen	
7264	26580070	Commerzbank Lingen Ems	
7265	26580070	Commerzbank Diepholz	
7266	26580070	Commerzbank Nordhorn	
7267	26580070	Commerzbank Melle	
7268	26590025	Volksbank Osnabrück	
7276	26620010	Oldb Landesbank Haselünne	
7277	26620010	Oldb Landesbank Emsbüren	
7278	26620010	Oldb Landesbank Freren	
7279	26620010	Oldb Landesbank Spelle	
7280	26621413	Oldb Landesbank Haren Ems	
7281	26640049	Commerzbank Meppen	
7282	26650001	Spk Emsland	
7304	26660060	Volksbank Lingen	
7307	26660060	Volksbank Lingen Ems	
7308	26661380	Volksbank Haselünne	
7311	26661494	Emsländische VB Meppen	
7320	26661912	Volksbank Süd-Emsland -alt-	
7321	26662932	Volksbank Lengerich	
7322	26720028	Oldb Landesbank Emlichheim	
7323	26720028	Oldb Landesbank Neuenhaus	
7324	26720028	Oldb Landesbank Schüttorf	
7325	26720028	Oldb Ldbank Bad Bentheim	
7326	26720028	Oldb Ldbank Wietmarschen	
7327	26750001	Kr Spk Nordhorn	
7337	26840032	Commerzbank Bad Harzburg	
7338	26850001	Sparkasse Goslar/Harz	
7346	26890019	Volksbank Nordharz	
7351	26891484	Volksbank im Harz	
7362	26951311	Spk Gifhorn-Wolfsburg	
7381	26991066	Volksbank Brawo	
7391	27040080	Commerzbank Gifhorn	
7392	27040080	Commerzbank Helmstedt	
7393	27040080	Commerzbank Peine	
7394	27040080	Commerzbank Schöningen	
7395	27040080	Commerzbank Salzgitter	
7396	27040080	Commerzbank Wolfenbüttel	
7397	27062290	Volksbank Börßum-Hornburg	
7402	27080060	Commerzbank Salzgitter	
7403	27080060	Commerzbank Wolfenbüttel	
7404	27090900	PSD Bank Braunschweig	
7407	27092555	VB Wolfenbüttel-Salzgitter	
7416	27190082	Volksbank Helmstedt	
7429	27290087	VB Weserbergland Holzminden	
7438	27893215	Vereinigte Volksbank	
7440	27893359	Volksbank Braunlage	
7444	27893760	Volksbank	
7455	27893760	Volksbank Seesen	
7456	28020050	Oldb Landesbank Hatten	
7457	28020050	Oldb Landesbank Wardenburg	
7458	28021002	Oldb Landesbank Ovelgönne	
7459	28021002	Oldb Landesbank Stadland	
7460	28021301	Oldb Landesbank Edewecht	
7461	28021504	Oldb Landesbank Emstek	
7462	28021504	Oldb Landesbank Garrel	
7463	28021504	Oldb Landesbank Werlte	
7464	28021504	Oldb Landesbank Lastrup	
7465	28021504	Oldb Landesbank Lindern	
7466	28021504	Oldb Landesbank Lorup	
7467	28021504	Oldb Landesbank Molbergen	
7468	28021504	Oldb Landesbank Friesoythe	
7469	28021504	Oldb Landesbank Saterland	
7470	28021623	Oldb Ldbank Neuenkirchen	
7471	28021705	Oldb Landesbank Ganderkesee	
7472	28021705	Oldb Landesbank Hude	
7473	28021705	Oldb Landesbank Lemwerder	
7474	28021705	Oldb Ldbank Delmenh Stuhr	
7475	28021906	Oldb Landesbank Berne	
7476	28022412	Oldb Landesbank Herzlake	
7477	28022412	Oldb Landesbank Sögel	
7478	28022412	Oldb Landesbank Börger	
7479	28022412	Oldb Landesbank Lähden	
7480	28022511	Oldb Landesbank Dinklage	
7481	28022511	Oldb Landesbank Holdorf	
7482	28022511	Oldb Landesbank Steinfeld	
7483	28022620	Oldb Landesbank Wiefelstede	
7484	28022822	Oldb Landesbank Goldenstedt	
7485	28022822	Oldb Landesbank Visbek	
7486	28022822	Oldb Landesbank Bakum	
7487	28023224	Oldb Landesbank Barßel	
7488	28023224	Oldb Landesbank Apen	
7489	28023325	Oldb Ldbank Großenkneten	
7490	28060228	Raiffbk Oldenburg	
7493	28061410	Raiffbk Wesermarsch-Süd	
7497	28061501	Volksbank Cloppenburg	
7498	28061679	VB Dammer Berge	
7499	28061679	Volksbank Dammer Berge	
7500	28061822	Volksbank Oldenburg	
7507	28062165	Raiffeisenbank Rastede	
7508	28062249	Volksbank Ganderkesee-Hude	
7512	28062560	Volksbank Lohne-Mühlen	
7513	28062740	VB Bookholzberg-Lemwerder	
7515	28062913	Volksbank Bösel	
7516	28063253	Volksbank Westerstede	
7517	28063526	VB Essen-Cappeln	
7520	28063607	Volksbank Bakum	
7521	28064179	Volksbank Vechta	
7526	28065061	Volksbank Loeningen	
7527	28065061	Volksbank Löningen	
7528	28065108	VR-Bank Dinklage-Steinfeld	
7530	28065286	Raiffeisenbank Scharrel	
7532	28066103	Volksbank Visbek	
7533	28066214	VB Wildeshauser Geest	
7534	28066620	Spar-u Darlehnskasse	
7536	28067068	VB Neuenkirchen-Vörden	
7537	28067170	VB Delmenhorst Schierbrok	
7538	28067257	Volksbank Lastrup	
7539	28068218	Raiffbk Butjadingen-Abbehsn	
7541	28069052	Raiffbk Strückl.-Idafehn	
7542	28069052	Raiffbk Strückl-Idafehn	
7544	28069092	VR Bank Oldenburg Land West	
7547	28069109	Volksbank Emstek	
7548	28069128	Raiffeisenbank Garrel	
7549	28069138	VR Bank Oldenburg Land West	
7550	28069293	VB Obergrafschaft -alt-	
7551	28069381	Hümmlinger Volksbank	
7554	28069706	Volksbank Nordhümmling	
7559	28069773	Raiffbk Wiesederm-Wiesede-M	
7560	28069878	Raiffbk Emsland-Mitte	
7566	28069926	VB Niedergrafschaft	
7572	28069930	VB Langen-Gersten	
7574	28069935	Raiffeisenbank Lorup	
7575	28069956	Grafschafter Volksbank	
7580	28069991	Volksbank Emstal	
7586	28069994	Volksbank Süd-Emsland	
7594	28069994	Volkbank Süd-Emsland	
7597	28220026	Oldb Landesbank Sande	
7598	28222208	Oldb Landesbank Wangerland	
7599	28222208	Oldb Landesbank Schortens	
7600	28222208	Oldb Landesbank Langeoog	
7601	28222208	Oldb Landesbank Wittmund	
7602	28222621	Oldb Landesbank Zetel	
7603	28222621	Oldb Landesbank Bockhorn	
7604	28222621	Oldb Landesbank Jade	
7605	28262254	Volksbank Jever	
7611	28262673	Raiff-VB Varel-Nordenham	
7617	28290063	Volksbank Wilhelmshaven	
7618	28291551	VB Esens	
7626	28320014	Oldb Landesbank Esens	
7627	28320014	Oldb Landesbank Dornum	
7628	28320014	Oldb Landesbank Hage	
7629	28320014	Oldb Landesbank Juist	
7630	28320014	Oldb Landesbank Westerholt	
7631	28320014	Oldb Landesbank Marienhafe	
7632	28350000	Spk Aurich-Norden	
7647	28361592	Raiff-VB Fresena	
7658	28420007	Oldb Landesbank Krummhörn	
7659	28420007	Oldb Landesbank Borkum	
7660	28421030	Oldb Landesbank Ihlow	
7661	28421030	Oldb Landesbank Wiesmoor	
7662	28421030	Oldb Ldbank Südbrookmerland	
7663	28520009	Oldb Ldbank Ostrhauderfehn	
7664	28520009	Oldb Landesbank Jemgum	
7665	28520009	Oldb Landesbank Uplengen	
7666	28520009	Oldb Landesbank Moormerland	
7667	28520009	Oldb Landesbank Weener	
7668	28520009	Oldb Landesbank Rhauderfehn	
7669	28520009	Oldb Landesbank Bunde	
7670	28521518	Oldb Landesbank Lathen	
7671	28521518	Oldb Landesbank Dörpen	
7672	28550000	Sparkasse LeerWittmund	
7673	28562297	RVB	
7683	28562297	RVB Aurich	
7684	28562716	Raiffbk Flachsmeer Westover	
7685	28563749	Raiffeisenbank Moormerland	
7691	28590075	Ostfriesische VB Leer	
7697	28591654	Volksbank Westrhauderfehn	
7701	29040090	Commerzbank Bremervörde	
7702	29040090	Commerzbank Delmenhorst	
7703	29040090	Commerzbank Cloppenburg	
7704	29040090	Commerzbank Nordenham	
7705	29040090	Commerzbank Norden	
7706	29040090	Commerzbank Nienburg Weser	
7707	29040090	Commerzbank Weyhe	
7708	29040090	Commerzbank Hoya	
7709	29040090	Commerzbank Osterholz-Schar	
7710	29040090	Commerzbank Varel Friesl	
7711	29040090	Commerzbank Papenburg	
7712	29040090	Commerzbank Verden	
7713	29040090	Commerzbank Wildeshausen	
7714	29040090	Commerzbank Rotenburg Wümme	
7715	29040090	Commerzbank Brake Unterwes	
7716	29040090	Commerzbank Achim Bremen	
7717	29050101	Sparkasse Bremen Gf P2	
7718	29080010	Commerzbank Delmenhorst	
7719	29080010	Commerzbank Achim Bremen	
7720	29080010	Commerzbank Verden	
7721	29080010	Commerzbank Papenburg	
7722	29121731	Oldb Landesbank Harpstedt	
7723	29121731	Oldb Landesbank Twistringen	
7724	29121731	Oldb Landesbank Bassum	
7725	29121731	Oldb Landesbank Weyhe	
7726	29121731	Oldb Landesbank Syke Stuhr	
7727	29151700	Kreissparkasse Syke	
7736	29152550	Spk Scheeßel	
7743	29152670	Kr Spk Verden	
7751	29162394	Volksbank	
7758	29162453	Volksbank Schwanewede	
7759	29162697	Volksbank Aller-Weser	
7764	29165545	Volksbank Oyten	
7765	29165681	Volksbank Sottrum	
7773	29166568	Volksbank Worpswede	
7774	29167624	Volksbank Syke	
7781	29190024	Bremische Volksbank	
7782	29190024	Volksbank Achim	
7783	29190024	Volksbank Rotenburg Wümme	
7784	29190330	Volksbank Bremen-Nord	
7788	29250150	Kr Spk Wesermünde-Hadeln	
7813	29262722	Volksbank Geeste-Nord	
7815	29265747	VB Bremerhaven-Cuxland	
7839	29290034	VB Bremerh-Wesermünde -alt-	
7840	30030500	Bank11direkt Neuss	
7841	30040000	Commerzbank Grevenbroich	
7842	30040000	Commerzbank Erkrath	
7843	30040000	Commerzbank Neuss	
7844	30040000	Commerzbank Mettmann	
7845	30040000	Commerzbank Haan Rheinl	
7846	30040000	Commerzbank Ratingen	
7847	30040000	Commerzbank Hilden	
7848	30040000	Commerzbank Kaarst	
7849	30040000	Commerzbank Meerbusch Büder	
7850	30060010	WGZ Bank Düsseldorf	
7851	30060601	apoBank Düsseldorf	
7852	30060992	PSD Bank Rhein-Ruhr	
7853	30080000	Commerzbank Erkrath	
7854	30080000	Commerzbank Neuss	
7855	30080000	Commerzbank Mettmann	
7856	30080000	Commerzbank Langenfeld	
7857	30080000	Commerzbank Ratingen	
7858	30080000	Commerzbank Hilden	
7859	30080000	Commerzbank Dormagen	
7860	30080000	Commerzbank Kaarst	
7861	30080000	Commerzbank Meerbusch	
7862	30120764	UniCredit exHypo Ndl450 Düs	
7863	30150001	Helaba Dus, Gf Ver. FI-Dus	
7864	30150200	Kr Spk Düsseldorf Wülfrath	
7865	30150200	Kr Spk Düsseldorf Mettmann	
7866	30150200	Kr Spk Düsseldorf Erkrath	
7867	30150200	Kr Spk Düsseldorf Heiligenh	
7868	30160213	VB Düsseldorf Neuss	
7870	30550000	Sparkasse Neuss	
7875	30560548	VR Bank Dormagen	
7879	31010833	Santander Consumer Bank MG	
7933	31040015	Commerzbank Erkelenz	
7934	31040015	Commerzbank Viersen	
7935	31040015	Commerzbank Wegberg	
7936	31040015	Commerzbank Niederkrücht	
7937	31040015	Commerzbank Nettetal-Lobbe	
7938	31060181	Gladbacher Bank von 1922	
7939	31060517	VB Mönchengladbach	
7941	31062154	Volksbank Brüggen-Nettetal	
7943	31062553	Volksbank Schwalmtal	
7944	31080015	Commerzbank Erkelenz	
7945	31080015	Commerzbank Nettetal	
7946	31080015	Commerzbank Viersen	
7947	31080015	Commerzbank Niederkrücht	
7948	31080015	Commerzbank Grevenbroich	
7949	31251220	Kr Spk Heinsberg Erkelenz	
7958	31261282	Volksbank Erkelenz	
7964	31263359	Raiffbk Erkelenz	
7971	31460290	Volksbank Viersen Schwalmt	
7972	31460290	Volksbank Viersen	
7973	32040024	Commerzbank Kempen Niederrh	
7974	32040024	Commerzbank Kamp-Lintfort	
7975	32040024	Commerzbank Geldern	
7976	32040024	Commerzbank Meerbusch-Oster	
7977	32050000	Sparkasse Krefeld	
7991	32060362	Volksbank Krefeld	
7995	32061384	Volksbank an der Niers	
8005	32061414	Volksbank Kempen-Grefrath	
8007	32080010	Commerzbank Kamp-Lintfort	
8008	32080010	Commerzbank Kleve	
8009	32080010	Commerzbank Geldern	
8010	32080010	Commerzbank Emmerich	
8011	32250050	Verb Spk Goch	
8013	32440023	Commerzbank Goch	
8014	32440023	Commerzbank Emmerich	
8015	32440023	Commerzbank Rees	
8016	32450000	Sparkasse Kleve	
8020	32460422	Volksbank Kleverland	
8025	33040001	Commerzbank Gevelsberg	
8026	33040001	Commerzbank Ennepetal	
8027	33040001	Commerzbank Sprockhövel	
8028	33040001	Commerzbank Schwelm	
8029	33040001	Commerzbank Langenberg	
8030	33040310	Commerzbank Zw 117	
8031	33060098	Credit u Volksbk Wuppertal	
8034	33060098	Credit- u VB Wuppertal	
8036	33060592	Sparda-Bank West	
8048	33080030	Commerzbank Heiligenhaus	
8049	33080030	Commerzbank Velbert	
8050	33080030	Commerzbank Schwelm	
8051	33440035	Commerzbank Heiligenhaus	
8052	33450000	Sparkasse HRV	
8054	34040049	Commerzbank Wermelskirchen	
8055	34040049	Commerzbank Radevormwald	
8056	34040049	Commerzbank Wipperfürth	
8057	34060094	Volksbank Remscheid-Solingn	
8058	34240050	Commerzbank Langenfeld Rhld	
8059	34280032	Commerzbank Haan Rheinl	
8060	35040038	Commerzbank Moers	
8061	35060190	Bank für Kirche u Diakonie	
8065	35060190	LKG Zndl d. KD-Bank Dresden	
8066	35060386	VB Rhein-Ruhr Duisburg	
8070	35070024	Deutsche Bank PGK Voerde	
8071	35070030	Deutsche Bank Voerde	
8072	35080070	Commerzbank Dinslaken	
8073	35080070	Commerzbank Moers	
8074	35080070	Commerzbank Wesel	
8075	35251000	Spk Dinslaken-Voerde-Hünxe	
8077	35261248	Volksbank Dinslaken	
8079	35450000	Sparkasse am Niederrhein	
8082	35461106	Volksbank Niederrhein	
8092	35640064	Commerzbank Dinslaken	
8093	35640064	Commerzbank Voerde	
8094	35640064	Commerzbank Xanten	
8095	35640064	Commerzbank Duisburg-Walsum	
8096	35650000	Verb Spk Wesel	
8098	35660599	Volksbank Rhein-Lippe	
8101	35850000	St Spk Emmerich-Rees	
8102	35860245	Volksbank Emmerich-Rees	
8104	36020030	National-Bank Bochum	
8105	36020030	National-Bank Dortmund	
8106	36020030	National-Bank Düsseldorf	
8107	36020030	National-Bank Gladbeck	
8108	36020030	National-Bank Hattingen	
8109	36020030	National-Bank Mülheim	
8110	36020030	National-Bank Oberhausen	
8111	36020030	National-Bank Recklinghsn	
8112	36020030	National-Bank Velbert	
8113	36040039	Commerzbank Gladbeck Westf	
8114	36040039	Commerzbank Bottrop	
8115	36040039	Commerzbank Dorsten	
8116	36040039	Commerzbank Herten Westf	
8117	36040039	Commerzbank Haltern Westf	
8118	36040039	Commerzbank Marl-Hüls	
8119	36060295	Bank im Bistum Essen	
8120	36060488	GENO BANK ESSEN	
8122	36060591	Sparda-Bank West	
8137	36080080	Commerzbank Gladbeck	
8138	36080080	Commerzbank Herne	
8139	36080080	Commerzbank Bottrop	
8140	37020500	Bank für Sozialwirtschaft	
8141	37040044	Commerzbank Bergisch-Gladb	
8142	37040044	Commerzbank Dormagen	
8143	37040044	Commerzbank Frechen	
8144	37040044	Commerzbank Troisdorf	
8145	37040044	Commerzbank Wesseling Rhein	
8146	37040044	Commerzbank Leichlingen Rhl	
8147	37040044	Commerzbank Brühl Rheinl	
8148	37040044	Commerzbank Bergheim Erft	
8149	37040044	Commerzbank Pulheim	
8150	37040044	Commerzbank Rheinbach	
8151	37040044	Commerzbank Sankt Augustin	
8152	37040044	Commerzbank Overath	
8153	37040044	Commerzbank Kerpen Rheinl	
8154	37040044	Commerzbank Zülpich	
8155	37040044	Commerzbank Erftstadt	
8156	37040044	Commerzbank Leverk-Opladen	
8157	37040048	Commerzbank Hürth Rheinl	
8158	37050299	Kreissparkasse Köln	
8200	37060193	Pax-Bank Köln	
8201	37060590	Sparda-Bank West	
8216	37062124	Bensberger Bank	
8217	37062365	Raiffbk Frechen-Hürth	
8223	37062600	VR Bank Bergisch Gladbach	
8226	37063367	Raiffbk Fischenich-Kende	
8227	37069101	Spar-u Darlehnskasse	
8228	37069103	Raiffeisenbank Aldenhoven	
8229	37069103	Raiffbk Aldenhoven Linnich	
8230	37069125	Raiffbk Kürten-Odenthal	
8233	37069153	Spar-u Darlehnskasse	
8234	37069164	Volksbank Meerbusch	
8235	37069252	Volksbank Erft Bergheim	
8236	37069252	Volksbank Erft Bedburg	
8237	37069252	Volksbank Erft Pulheim	
8238	37069252	Volksbank Erft Elsdorf	
8239	37069302	Raiffbk Geilenkirchen	
8242	37069303	Volksbank Gemünd-Kall	
8244	37069306	Raiffbk Korschenbroich	
8245	37069306	Raiffeisenbank Grevenbroich	
8249	37069322	Raiffeisenbank Gymnich	
8250	37069330	Volksbank Haaren	
8251	37069331	Raiffeisenbank von 1895	
8252	37069342	Volksbank Heimbach	
8253	37069354	Raiffeisenbank Selfkant	
8254	37069355	Spar-u Darlehnskasse	
8255	37069381	VR-Bank Rur-Wurm	
8257	37069401	Raiffeisenbank Junkersdorf	
8258	37069405	Raiffeisenbank Kaarst	
8259	37069412	Raiffeisenbank Heinsberg	
8263	37069427	Volksbank Dünnwald-Holweide	
8264	37069429	Volksbank Köln-Nord	
8266	37069520	VR-Bank Rhein-Sieg Siegburg	
8272	37069521	Raiffeisenbank Rhein-Berg	
8279	37069524	Raiffbk Much-Ruppichteroth	
8281	37069627	Raiffbk Rheinbach Voreifel	
8286	37069639	Rosbacher Raiffeisenbank	
8287	37069642	Raiffbk Simmerath	
8291	37069707	Raiffbk Sankt Augustin	
8292	37069720	VR-Bank Nordeifel Schleiden	
8298	37069805	Volksbank Wachtberg	
8299	37069840	VB Wipperfürth-Lindlar	
8301	37069991	Brühler Bank, Brühl	
8302	37080040	Commerzbank Brühl Rheinl	
8303	37080040	Commerzbank Berg-Gladbach	
8304	37080040	Commerzbank Frechen	
8305	37080040	Commerzbank Gummersbach	
8306	37080040	Commerzbank Leverkusen	
8307	37080040	Commerzbank Troisdorf	
8308	37080040	Commerzbank Siegburg	
8309	37080040	Commerzbank Hürth Rheinl	
8310	37080040	Commerzbank Rheinbach	
8311	37080040	Commerzbank St	
8312	37080040	Commerzbank Pulheim	
8313	37080040	Commerzbank Overath	
8314	37080040	Commerzbank Kerpen Rheinl	
8315	37080040	Commerzbank Bad Honnef	
8316	37080040	Commerzbank Bonn	
8317	37160087	Kölner Bank	
8318	37161289	VR-Bank Rhein-Erft	
8324	37560092	Volksbank Rhein-Wupper	
8327	38040007	Commerzbank Bad Neuenahr-Aw	
8328	38040007	Commerzbank Bad Honnef Rhld	
8329	38040007	Commerzbank Euskirchen	
8330	38040007	Commerzbank Hennef Sieg	
8331	38040007	Commerzbank Siegburg	
8332	38060186	Volksbank Bonn Rhein-Sieg	
8342	38160220	VR-Bank Bonn	
8344	38250110	Kreissparkasse Euskirchen	
8349	38260082	Volksbank Euskirchen	
8356	38440016	Commerzbank Bergneustadt	
8357	38440016	Commerzbank Waldbröl	
8358	38440016	Commerzbank Wiehl	
8359	38450000	Spk Gummersbach-Bergneust	
8360	38452490	Sparkasse Nümbrecht	
8361	38462135	Volksbank Oberberg	
8372	39040013	Commerzbank Eschweiler Rhld	
8373	39040013	Commerzbank Stolberg Rheinl	
8374	39040013	Commerzbank Würselen	
8375	39040013	Commerzbank Jülich	
8376	39040013	Commerzbank Herzogenrath	
8377	39040013	Commerzbank Simmerath	
8378	39040013	Commerzbank Geilenkirchen	
8379	39040013	Commerzbank Alsdorf	
8380	39040013	Commerzbank Heinsberg	
8381	39050000	Sparkasse Aachen	
8390	39060180	Aachener Bank	
8396	39061981	Heinsberger Volksbank	
8397	39070020	Deutsche Bank Aldenhoven	
8398	39070024	Deutsche Bank PGK Aldenhove	
8399	39080005	Commerzbank Geilenkirchen	
8400	39080005	Commerzbank Alsdorf	
8401	39080005	Commerzbank Stolberg	
8402	39080005	Commerzbank Heinsberg	
8403	39080005	Commerzbank Herzogenrath	
8404	39162980	VR-Bank Würselen	
8409	39162980	VR-Bank	
8413	39362254	Raiffeisen-Bank Eschweiler	
8414	39550110	Sparkasse Düren	
8428	39560201	Volksbank Düren	
8431	39560201	Volksbank Düren ZW Kelz	
8433	39580041	Commerzbank Zülpich	
8434	39580041	Commerzbank Jülich	
8435	39580041	Commerzbank Euskirchen	
8436	39580041	Commerzbank Eschweiler	
8437	39580041	Commerzbank Erftstadt	
8438	40040028	Commerzbank Greven Westf	
8439	40040028	Commerzbank Dülmen	
8440	40040028	Commerzbank Coesfeld Westf	
8441	40040028	Commerzbank Lüdinghausen	
8442	40040028	Commerzbank Emsdetten	
8443	40040028	Commerzbank Gronau Westf	
8444	40040028	Commerzbank Warendorf	
8445	40050150	Spk Münsterland Ost	
8455	40060000	WGZ Bank Münster	
8456	40060265	DKM Darlehnskasse Münster	
8457	40060300	WL BANK Münster	
8458	40060560	Sparda-Bank Münster	
8465	40061238	Volksbank Greven	
8468	40069226	Volksbank Lette-Darup-Rorup	
8471	40069266	Volksbank Marsberg	
8472	40069283	Spar-u Darlehnskasse	
8473	40069283	Volksbank Schlangen	
8474	40069348	Volksbank Medebach	
8475	40069362	Volksbank Saerbeck	
8476	40069363	Volksbank Schermbeck	
8477	40069371	Volksbank Thülen	
8478	40069408	Volksbank Baumberge	
8482	40069462	Volksbank Sprakel	
8483	40069546	Volksbank Senden	
8484	40069600	Volksbank Amelsbüren	
8485	40069601	Volksbank Ascheberg-Herbern	
8486	40069606	Volksbank Erle	
8487	40069622	Volksbank Seppenrade	
8488	40069709	Volksbank Lembeck-Rhade	
8489	40069716	Volksbank Nordkirchen	
8490	40080040	Commerzbank Bocholt	
8491	40080040	Commerzbank Emsdetten	
8492	40080040	Commerzbank Gronau Westf	
8493	40080040	Commerzbank Warendorf	
8494	40080040	Commerzbank Rheine Westf	
8495	40150001	Helaba Dus, Gf Ver. FI-Mün	
8496	40153768	Sparkasse Emsdetten Ochtrup	
8497	40154530	Sparkasse Westmünsterland	
8522	40160050	Volksbank Münster	
8525	40160050	VB Münster	
8526	40163720	VB Nordmünsterland Rheine	
8530	40164024	Volksbank Gronau-Ahaus	
8537	40164256	VB Laer-Horstmar-Leer	
8539	40164352	Volksbank Nottuln	
8540	40164528	VB Lüdinghausen-Olfen	
8542	40164618	Volksbank Ochtrup	
8543	40164618	Volksbank Wettringen	
8544	40164901	Volksbank Gescher	
8545	40165366	Volksbank Selm-Bork	
8547	40340030	Commerzbank Ibbenbüren	
8548	40351060	Kr Spk Steinfurt	
8567	40361627	VB Westerkappeln-Wersen	
8569	40361906	VR-Bank Kreis Steinfurt	
8584	41040018	Commerzbank Ahlen Westf	
8585	41051845	Spk Bönen-Bergkamen	
8586	41060120	Volksbank Hamm	
8587	41061011	Spar-u Darlehnskasse	
8588	41062215	Volksbank Bönen	
8589	41250035	Spk Beckum-Wadersloh	
8590	41260006	Volksbank Beckum	
8595	41261324	VB Enniger-Ostenfelde-Westk	
8596	41261419	VB Oelde-Ennigerloh-Neubeck	
8599	41262501	VB Ahlen-Sassenberg-Warendf	
8600	41262501	VB Ahlen-Sassenberg Warendf	
8603	41262621	Ver VB Telgte	
8610	41280043	Commerzbank Ahlen Westf	
8611	41280043	Commerzbank Lippstadt	
8612	41450075	Sparkasse Soest	
8616	41451750	Sparkasse Werl	
8618	41460116	Volksbank Hellweg	
8624	41462295	Volksbank Wickede (Ruhr)	
8625	41651815	Spk Erwitte-Anröchte	
8626	41660124	Volksbank Beckum-Lippstadt	
8633	41661206	Volksbank Anröchte	
8634	41661206	Volksbank Horn	
8636	41661504	Volksbank Benninghausen	
8637	41661719	Volksbank Brilon	
8638	41662465	Volksbank Störmede	
8639	41663335	Volksbank Hörste	
8640	42040040	Commerzbank Herten-Westerh	
8641	42260001	Volksbank Ruhr Mitte	
8647	42260001	VB Ruhr Mitte Gelsenkirchen	
8648	42461435	Volksbank Kirchhellen	
8649	42650150	Spk Recklinghausen	
8656	42661008	VB Marl-Recklinghausen	
8658	42661330	Volksbank Haltern	
8659	42661522	Volksbank Herten-Westerholt	
8660	42661717	Volksbank Datteln	
8661	42661717	Volksbank Henrichenburg	
8662	42661717	Volksbank Lünen u Brambauer	
8663	42661717	Volksbank Oer-Erkenschwick	
8664	42661717	Volksbank Waltrop	
8665	42662320	Volksbank Dorsten	
8666	42680081	Commerzbank Dorsten	
8667	42840005	Commerzbank Borken Westf	
8668	42840005	Commerzbank Rhede Westf	
8669	42860003	Volksbank Bocholt	
8671	42861239	Spar-u Darlehnskasse Reken	
8672	42861387	VR-Bank Westmünsterland	
8681	42861515	Volksbank Gemen	
8682	42861608	Volksbank Heiden	
8683	42861814	Volksbank Rhede	
8684	42861814	VB Rhede Rhedebrügge	
8685	42862451	Volksbank Raesfeld	
8686	43040036	Commerzbank Herne	
8687	43040036	Commerzbank Hattingen	
8688	43060129	Volksbank Bochum Witten	
8693	43060967	GLS Gemeinschaftsbank	
8696	43080083	Commerzbank Hattingen	
8697	44040037	Commerzbank Kamen Westf	
8698	44040037	Commerzbank Lünen Westf	
8699	44040037	Commerzbank Schwerte	
8700	44040037	Commerzbank CastropRauxel	
8701	44040037	Commerzbank Sundern	
8702	44040037	Commerzbank Wetter Ruhr	
8703	44060122	Volksbank Dortmund-Nordwest	
8704	44080050	Commerzbank CastropRauxel	
8705	44080050	Commerzbank Arnsberg	
8706	44080050	Commerzbank Kamen Westf	
8707	44080050	Commerzbank Meschede	
8708	44080050	Commerzbank Hamm Westf	
8709	44080050	Commerzbank Lünen	
8710	44080050	Commerzbank Unna	
8711	44080050	Commerzbank Sundern	
8712	44080050	Commerzbank Witten	
8713	44080050	Commerzbank Wetter Ruhr	
8714	44080050	Commerzbank Soest Westf	
8715	44080050	Commerzbank Schwerte	
8716	44152370	Sparkasse Lünen	
8717	44160014	Dortmunder Volksbank	
8728	44350060	Sparkasse UnnaKamen	
8729	44361342	VB Kamen-Werne	
8732	44540022	Commerzbank Hemer	
8733	44540022	Commerzbank Menden Sauerl	
8734	44580070	Commerzbank Hemer	
8735	44580070	Commerzbank Plettenberg	
8736	44580070	Commerzbank Menden Sauerl	
8737	44761312	Mendener Bank	
8738	44761534	VB im Märkischen Kreis	
8749	44761534	VB Marienheide	
8750	45040042	Commerzbank Herdecke Ruhr	
8751	45060009	Märkische Bank Hagen	
8752	45060009	Spar-u Darlehnskasse	
8753	45060009	Volksbank Gevelsberg	
8754	45060009	Volksbank Hemer	
8755	45060009	Volksbank Herdecke	
8756	45060009	Volksbank Iserlohn	
8757	45060009	Volksbank Menden	
8758	45061524	Volksbank Hohenlimburg	
8760	45080060	Commerzbank Gevelsberg	
8761	45080060	Commerzbank Ennepetal	
8762	45080060	Commerzbank Herdecke Ruhr	
8763	45080060	Commerzbank Lüdenscheid	
8764	45260475	Spar- und Kreditbank	
8765	45261547	Volksbank Hattingen Ruhr	
8766	45261547	Volksbank Langenberg	
8767	45261547	Volksbank Linden	
8768	45261547	VB Sprockhövel Herbede	
8769	45261547	Volksbank Sprockhövel	
8770	45451060	Spk Ennepetal-Breckerfeld	
8771	45840026	Commerzbank Olsberg	
8772	45840026	Commerzbank Altena	
8773	45840026	Commerzbank Neuenrade	
8774	45840026	Commerzbank Halver	
8775	45840026	Commerzbank Werdohl	
8776	45850005	Spk Lüdenscheid	
8779	45851020	Ver Spk Balve Sauerl	
8780	45851020	Ver Spk Werdohl	
8781	45851020	Ver Spk Neuenrade	
8782	45851020	Ver Spk Altena Westf	
8783	45851020	Ver Spk Nachrodt	
8784	45851665	Spk Kierspe-Meinerzhagen	
8785	45860033	Volksbank Lüdenscheid -alt-	
8786	45861434	Volksbank Kierspe	
8787	45861617	VB Meinerzhagen -alt-	
8788	46040033	Commerzbank Lennestadt	
8789	46040033	Commerzbank Kreuztal	
8790	46040033	Commerzbank Wissen Sieg	
8791	46040033	Commerzbank Attendorn Westf	
8792	46040033	Commerzbank Betzdorf Sieg	
8793	46040033	Commerzbank Bad Marienbg	
8794	46051240	Spk Burbach-Neunkirchen	
8795	46053480	Sparkasse Wittgenstein	
8797	46060040	Volksbank Siegerland Siegen	
8806	46061724	VR-Bank Freudenb.-Niederfi.	
8808	46062817	Volksbank Bigge-Lenne	
8815	46063405	Volksbank Wittgenstein	
8818	46080010	Commerzbank Betzdorf Sieg	
8819	46080010	Commerzbank Olpe Biggesee	
8820	46080010	Commerzbank Bad Marienbg	
8821	46250049	Spk Olpe-Drolshagen-Wenden	
8823	46251630	Spk Attend-Lennest-Kirchhdm	
8825	46260023	Volksbank Olpe	
8826	46261607	Volksbank Finnentrop	
8827	46261607	Volksbank Grevenbrück	
8828	46261822	VB Olpe-Wenden-Drolshagen	
8830	46261822	Volksbank Wenden-Drolshagen	
8831	46262456	Volksbank Bigge-Lenne	
8832	46451012	Sparkasse Meschede	
8833	46461126	Volksbank Sauerland	
8834	46462271	SpDK Oeventrop	
8835	46464453	Volksbank Reiste-Eslohe	
8838	46650005	Spk Arnsberg-Sundern	
8839	46660022	Volksbank Sauerland	
8845	47240047	Commerzbank Lippstadt	
8846	47240047	Commerzbank Bad Driburg Wes	
8847	47251550	Spk Höxter Steinheim	
8848	47251550	Spk Höxter Bad Driburg	
8849	47251550	Spk Höxter Beverungen	
8850	47251550	Spk Höxter Marienmünster	
8851	47251550	Spk Höxter Nieheim	
8852	47251550	Spk Höxter	
8853	47251550	Spk Höxter Borgentreich	
8854	47251550	Spk Höxter Warburg	
8855	47251550	Spk Höxter Willebadessen	
8856	47260121	VB Paderborn-Höxter-Detmold	
8862	47260234	VB Elsen-Wewer-Borchen	
8864	47260307	Bank für Kirche und Caritas	
8865	47261603	VB Brilon-Büren-Salzkotten	
8874	47262626	Volksbank Westenholz	
8875	47262703	VB Delbrück-Hövelhof	
8876	47263472	VB Westerloh-Westerwiehe	
8878	47264367	Vereinigte Volksbank	
8886	47265383	VB Wewelsburg-Ahden	
8887	47460028	Volksbank Warburger Land	
8890	47640051	Commerzbank Lemgo	
8891	47640051	Commerzbank Bad Salzuflen	
8892	47640051	Commerzbank Bad Pyrmont	
8893	47650130	Spk Paderborn-Detmold	
8910	47691200	Volksbank Lügde-Rischenau	
8911	47691200	Volksbank Ostlippe	
8912	47691200	VB Schieder-Schwalenberg	
8913	47840065	Commerzbank Versmold	
8914	47840065	Commerzbank Rietberg	
8915	47840065	Commerzbank Rheda-Wiedenbr	
8916	47840065	Commerzbank Oelde	
8917	47850065	Spk Harsewinkel Gütersloh	
8918	47853520	Kreissparkasse Wiedenbrück	
8922	47860125	VB Bielefeld-Gütersloh	
8928	47861317	VB im Ostmünsterland	
8931	47861518	Volksbank Harsewinkel	
8932	47861806	Volksbank Kaunitz	
8933	47862447	VB Langenberg Zndl	
8934	47862447	Volksbank Rietberg	
8935	47863373	Volksbank Versmold	
8936	47880031	Commerzbank Rietberg	
8937	47880031	Commerzbank Rheda-Wiedenb	
8938	48020151	Bankhaus Lampe Münster	
8939	48020151	Bankhaus Lampe Düsseldorf	
8940	48020151	Bankhaus Lampe Hamburg	
8941	48020151	Bankhaus Lampe Frankfurt	
8942	48020151	Bankhaus Lampe Berlin	
8943	48020151	Bankhaus Lampe München	
8944	48020151	Bankhaus Lampe Stuttgart	
8945	48020151	Bankhaus Lampe Dresden	
8946	48020151	Bankhaus Lampe Osnabrück	
8947	48020151	Bankhaus Lampe Bonn	
8948	48020151	Bankhaus Lampe Bremen	
8949	48040035	Commerzbank Steinhagen West	
8950	48040035	Commerzbank Marsberg	
8951	48051580	Kreissparkasse Halle	
8954	48060036	Bielefelder Volksbank	
8956	48062051	Volksbank Halle/Westf	
8960	48062466	Spar-u Darlehnskasse	
8962	48080020	Commerzbank Bünde Westf	
8963	48080020	Commerzbank Detmold	
8964	48080020	Commerzbank Marsberg	
8965	48080020	Commerzbank Herford	
8966	48080020	Commerzbank Paderborn	
8967	48080020	Commerzbank Lemgo	
8968	48080020	Commerzbank Bad Salzufeln	
8969	48250110	Sparkasse Lemgo	
8975	48262248	Volksbank Nordlippe	
8976	48291490	Volksbank Bad Salzuflen	
8979	48291490	Volksbank Barntrup	
8980	48291490	Volksbank Exertal	
8981	48291490	Volksbank Kalletal	
8982	49050101	Sparkasse Minden-Lübbecke	
8989	49060127	Volksbank Mindener Land	
8993	49060392	Volksbank Minden	
8994	49061510	Volksbank Eisbergen	
8995	49080025	Commerzbank Bad Oeynhaus	
8996	49080025	Commerzbank Lübbecke	
8997	49092650	Volksbank Lübbecker Land	
9003	49240096	Commerzbank Lübbecke Westf	
9004	49262364	Volksbank Schnathorst	
9006	49440043	Commerzbank Bad Oeynhausen	
9007	49450120	Sparkasse Herford	
9015	49490070	VB Bad Oeynhausen-Herford	
9026	50010700	Degussa Bank Alzenau	
9027	50010700	Degussa Bank Arnsberg	
9028	50010700	Degussa Bank Berlin	
9029	50010700	Degussa Bank Bielefeld	
9030	50010700	Degussa Bank Bonn	
9031	50010700	Degussa Bank Colditz	
9032	50010700	Degussa Bank Dresden	
9033	50010700	Degussa Bank Düsseldorf	
9034	50010700	Degussa Bank Erlensee	
9035	50010700	Degussa Bank Halle Westf	
9036	50010700	Degussa Bank Hamburg	
9037	50010700	Degussa Bank Hanau	
9038	50010700	Degussa Bank Hürth	
9039	50010700	Degussa Bank Köln	
9040	50010700	Degussa Bank Mainz	
9041	50010700	Degussa Bank München	
9042	50010700	Degussa Bank Pforzheim	
9043	50010700	Degussa Bank Radebeul	
9044	50010700	Degussa Bank Rheinfelden	
9045	50010700	Degussa Bank Schwäb Gmünd	
9046	50010700	Degussa Bank Wesseling	
9047	50010700	Degussa Bank Grenzach	
9048	50010700	Degussa Bank Bad Homburg	
9049	50010700	Degussa Bank Darmstadt	
9050	50010700	Degussa Bank Krefeld	
9051	50010700	Degussa Bank Niederkassel	
9052	50010700	Degussa Bank Marl	
9053	50010700	Degussa Bank Mülheim Ruhr	
9054	50010700	Degussa Bank Östringen	
9055	50010700	Degussa Bank Offenbach	
9056	50010700	Degussa Bank Weiterstadt	
9057	50010700	Degussa Bank Worms	
9058	50010700	Degussa Bank Konstanz	
9059	50010700	Degussa Bank Troisdorf	
9060	50010700	Degussa Bank Merseburg	
9061	50020160	UniCredit exHypo Ndl427 Ffm	
9062	50030900	Lehman Brothers Frankfurt	
9063	50040000	Commerzbank Bad Vilbel	
9064	50040000	Commerzbank Bad Soden Taunu	
9065	50040000	Commerzbank Bad Homburg vdH	
9066	50040000	Commerzbank Neu-Isenburg	
9067	50040000	Commerzbank Kelkheim Taunus	
9068	50040000	Commerzbank Hofheim Taunus	
9069	50040000	Commerzbank Oberursel Ts	
9070	50040000	Commerzbank Dreieich	
9071	50040000	Commerzbank Rüsselsheim	
9072	50040000	Commerzbank Königstein Ts	
9073	50040000	Commerzbank Maintal	
9074	50040000	Commerzbank Eschborn Taunus	
9075	50040000	Commerzbank Idstein Taunus	
9076	50040048	Commerzbank Hattersheim	
9077	50040048	Commerzbank Friedrichsdf	
9078	50040048	Commerzbank Schwalbach	
9079	50050201	Frankfurter Spk Steinbach	
9080	50050201	Frankfurter Spk Schwalbach	
9081	50050201	Frankfurter Spk Eschborn	
9082	50050201	Frankfurter Spk Hanau	
9083	50050201	Frankfurter Spk Offenbach	
9084	50050201	Frankfurter Spk Maintal	
9085	50050201	Frankfurter Spk Bad Vilbel	
9086	50050201	Frankfurter Spk Bad Soden	
9087	50050201	Frankfurter Spk Oberursel	
9088	50050201	Frankfurter Spk Neu-Isenbg	
9089	50050201	Frankfurter Spk Friedrichsd	
9090	50050201	Frankfurter Spk Dreieich	
9091	50061741	Raiffeisenbank Oberursel	
9095	50069126	Raiffeisenbank Alzey-Land	
9098	50069146	Volksbank Grebenhain	
9099	50069241	Raiffeisenkasse	
9102	50069345	Raiffbk Grävenwiesbach	
9103	50069455	Hüttenberger Bk Hüttenberg	
9104	50069464	VB Inheiden-Villingen -alt-	
9105	50069477	Raiffeisenbank Kirtorf	
9108	50069828	Raiffeisenbank Mücke	
9109	50069842	Raiffeisen-VB Schwabenheim	
9110	50069976	Volksbank Wißmar	
9111	50070010	Deutsche Bank Eschborn	
9112	50070010	Deutsche Bank Sulzbach-MTZ	
9113	50070024	Deutsche Bank PGK Sulzbach	
9114	50070024	Deutsche Bank PGK Eschborn	
9115	50070024	Deutsche Bank PGK Hofheim	
9116	50080000	Commerzbank Bad Vilbel	
9117	50080000	Commerzbank Bad Homburg	
9118	50080000	Commerzbank Neu-Isenburg	
9119	50080000	Commerzbank Kelkheim	
9120	50080000	Commerzbank Hofheim	
9121	50080000	Commerzbank Langen Hess	
9122	50080000	Commerzbank Oberursel	
9123	50080000	Commerzbank Dreieich	
9124	50080000	Commerzbank Eschborn	
9125	50080000	Commerzbank Hattersheim	
9126	50080000	Commerzbank Bad Soden	
9127	50080000	Commerzbank Friedrichsdf	
9128	50080000	Commerzbank Friedberg	
9129	50080000	Commerzbank Schwalbach	
9130	50090500	Sparda-Bank Hessen	
9159	50090900	PSD Bank HT BC Darmstadt	
9160	50090900	PSD Bank HT BC Erfurt	
9161	50090900	PSD Bank HT BC Kassel	
9162	50090900	PSD Bank HT BC Wiesbaden	
9163	50092100	Spar- u Kreditbk Bad Hombg	
9164	50092200	Volksbank Main-Taunus	
9167	50092200	Volksbank Main-Taunus Kelkh	
9175	50093000	Rüsselsheimer Volksbank	
9178	50120383	Bethmann Bank	
9184	50190000	Frankfurter Volksbank	
9213	50190300	Volksbank Höchst	
9216	50190400	Volksbank Griesheim Ffm	
9217	50220900	Hauck + Aufhäuser München	
9218	50330600	Sepahbank Frankfurt, Main	
9219	50540028	Commerzbank Obertshausen	
9220	50540028	Commerzbank Mühlheim Main	
9221	50540028	Commerzbank Seligenstadt	
9222	50540028	Commerzbank Heusenstamm	
9223	50540028	Commerzbank Dietzenbach	
9224	50560102	Raiffbk Offenbach	
9225	50561315	Ver VB Maingau	
9237	50580005	Commerzbank Obertshausen	
9238	50580005	Commerzbank Seligenstadt	
9239	50580005	Commerzbank Heusenstamm	
9240	50580005	Commerzbank Dietzenbach	
9241	50592200	VB Dreieich Langen Hess	
9242	50592200	VB Dreieich Dietzenbach	
9243	50592200	VB Dreieich	
9244	50592200	VB Dreieich Egelsbach	
9245	50650023	SPARKASSE HANAU	
9257	50652124	Spk Langen-Seligenstadt	
9269	50661639	VR Bk Main-Kinzig-Büdingen	
9297	50662299	Raiffeisenbank Bruchköbel	
9299	50663699	Raiffbk Rodenbach Hanau	
9302	50670009	Deutsche Bank Wächtersbach	
9303	50670024	Deutsche Bank PGK Wächtersb	
9304	50692100	Volksbank Seligenstadt	
9307	50750094	Kreissparkasse Gelnhausen	
9318	50761333	Volksbank Büdingen	
9319	50763319	Raiffbk Vogelsbg Brachttal	
9320	50763319	Raiffbk Vogelsbg Kefenrod	
9321	50790000	VR Bank Bad Orb-Gelnhausen	
9324	50793300	Birsteiner Volksbank	
9326	50840005	Commerzbank Groß-Gerau	
9327	50840005	Commerzbank Langen Hess	
9328	50840005	Commerzbank Pfungstadt	
9329	50840005	Commerzbank Bensheim	
9330	50840005	Commerzbank Michelstadt	
9331	50850150	St u Kr Spk Darmstadt	
9343	50851952	Spk Odenw Reichelsheim	
9344	50851952	Spk Odenw Rothenberg	
9345	50851952	Spk Odenw Brensbach	
9346	50851952	Spk Odenw Breuberg	
9347	50851952	Spk Fränkisch-Crumbach	
9348	50851952	Spk Odenw Beerfelden	
9349	50851952	Spk Odenw Bad König	
9350	50851952	Spk Odenw Lützelbach	
9351	50851952	Spk Odenw Michelstadt	
9352	50851952	Spk Odenw Höchst	
9353	50851952	Spk Odenw Brombachtal	
9354	50852553	Kr Spk Groß-Gerau	
9367	50852651	Sparkasse Dieburg	
9380	50861501	Raiffbk Nördliche Bergstr	
9382	50862311	Volksbank Gräfenhausen	
9383	50862408	Ver Volksbank Griesh-Weiter	
9385	50862835	Raiffeisenbank Schaafheim	
9386	50862903	Volksbank Mainspitze	
9390	50863513	Volksbank Odenwald	
9410	50863906	Volksbank Modautal Modau	
9411	50864322	Volksbank Modau	
9414	50864808	Volksbank Seeheim-Jugenheim	
9415	50865503	VB Eppertshausen	
9416	50870005	Deutsche Bank Michelstadt	
9417	50870024	Deutsche Bank PGK Michelsta	
9418	50880050	Commerzbank Bensheim	
9419	50880050	Commerzbank Michelstadt	
9420	50880050	Commerzbank Pfungstadt	
9421	50890000	VB Darmstadt Südhessen	
9446	50890000	VB Darmstadt - Südhessen	
9447	50892500	Groß-Gerauer Volksbank	
9448	50950068	Sparkasse Bensheim	
9453	50951469	Sparkasse Starkenburg	
9465	50961206	Raiffeisenbank Bürstadt	
9469	50961312	Raiffbk Groß-Rohrheim	
9470	50961592	Volksbank Weschnitztal	
9475	50961685	Volksbank Überwald-Gorxheim	
9479	51040038	Commerzbank Rüdesheim Rh	
9480	51040038	Commerzbank Bingen Rhein	
9481	51040038	Commerzbank Eltville	
9482	51040038	Commerzbank Taunusstein	
9483	51050015	Nass Spk Rüdesheim Rhein	
9484	51050015	Nass Spk Steinbach Taunus	
9485	51050015	Nass Spk Schmitten Taunus	
9486	51050015	Nass Spk Schlangenbad	
9487	51050015	Nass Spk Sulzbach Taunus	
9488	51050015	Nass Spk Wehrheim	
9489	51050015	Nass Spk Taunusstein	
9490	51050015	Nass Spk Usingen Taunus	
9491	51050015	Nass Spk Geisenheim Rh	
9492	51050015	Nass Spk Eschborn Taunus	
9493	51050015	Nass Spk Eppstein Taunus	
9494	51050015	Nass Spk Elz	
9495	51050015	Nass Spk Eltville Rhein	
9496	51050015	Nass Spk Hadamar Westerw	
9497	51050015	Nass Spk Friedrichsdorf	
9498	51050015	Nass Spk Flörsheim Main	
9499	51050015	Nass Spk Neu-Anspach	
9500	51050015	Nass Spk Bad Soden Taunus	
9501	51050015	Nass Spk Bad Schwalbach	
9502	51050015	Nass Spk Bad Homburg	
9503	51050015	Nass Spk Runkel Lahn	
9504	51050015	Nass Spk Bad Camberg	
9505	51050015	Nass Spk Oestrich-Winkel	
9506	51050015	Nass Spk Oberursel Taunus	
9507	51050015	Nass Spk Walluf	
9508	51050015	Nass Spk Selters Taunus	
9509	51050015	Nass Spk Lorch Rheingau	
9510	51050015	Nass Spk Limburg Lahn	
9511	51050015	Nass Spk Waldbrunn Limburg	
9512	51050015	Nass Spk Niedernhausen	
9513	51050015	Nass Spk Brechen	
9514	51050015	Nass Spk Idstein Taunus	
9515	51050015	Nass Spk Kelkheim Taunus	
9516	51050015	Nass Spk Kronberg Taunus	
9517	51050015	Nass Spk Kriftel Taunus	
9518	51050015	Nass Spk Königstein Taunus	
9519	51050015	Nass Spk Kiedrich Rheingau	
9520	51050015	Nass Spk Hofheim Taunus	
9521	51050015	Nass Spk Hochheim Main	
9522	51050015	Nass Spk Hattersheim Main	
9523	51050015	Nass Spk Holzappel	
9524	51050015	Nass Spk Höhr-Grenzhausen	
9525	51050015	Nass Spk Herschbach Selters	
9526	51050015	Nass Spk Hahnstätten	
9527	51050015	Nass Spk Hachenburg Westerw	
9528	51050015	Nass Spk Diez	
9529	51050015	Nass Spk Braubach	
9530	51050015	Nass Spk Bad Marienberg	
9531	51050015	Nass Spk Bad Ems	
9532	51050015	Nass Spk Lahnstein	
9533	51050015	Nass Spk Neuhäusel Westerw	
9534	51050015	Nass Spk Nentershausen	
9535	51050015	Nass Spk Nauort	
9536	51050015	Nass Spk Nastätten	
9537	51050015	Nass Spk Nassau Lahn	
9538	51050015	Nass Spk Montabaur	
9539	51050015	Nass Spk Miehlen Taunus	
9540	51050015	Nass Spk Kaub	
9541	51050015	Nass Spk Katzenelnbogen	
9542	51050015	Nass Spk Wirges	
9543	51050015	Nass Spk Westerburg Westerw	
9544	51050015	Nass Spk Wallmerod Westerw	
9545	51050015	Nass Spk Siershahn	
9546	51050015	Nass Spk Selters Westerwald	
9547	51050015	Nass Spk Sankt Goarshausen	
9548	51050015	Nass Spk Rennerod Westerw	
9549	51050015	Nass Spk Ransbach-Baumbach	
9550	51050015	Nass Spk Schwalbach Taunus	
9551	51050015	Nass Spk Aarbergen	
9552	51050015	Nass Spk Hohenstein Taunus	
9553	51050015	Nass Spk Kamp-Bornhofen	
9554	51050015	Nass Spk Dornburg	
9555	51050015	Nass Spk Waldems	
9556	51050015	Nass Spk Niedererbach	
9557	51050015	Nass Spk Rothenbach Westerw	
9558	51050015	Nass Spk Untershausen	
9559	51050015	Nass Spk Hünstetten	
9560	51050015	Nass Spk Bornich Taunus	
9561	51050015	Nass Spk Singhofen	
9562	51050015	Nass Spk Frankfurt	
9563	51080060	Commerzbank Bingen Rhein	
9564	51080060	Commerzbank Bad Kreuznach	
9565	51080060	Commerzbank Eltville	
9566	51080060	Commerzbank IdarOberstein	
9567	51080060	Commerzbank Taunusstein	
9568	51090000	Volksbank Eltville	
9571	51090000	Wiesbadener Volksbank	
9576	51091500	Rheingauer Volksbank	
9585	51091700	vr bank Untertaunus	
9593	51091711	Bk f Orden u Mission Idstn	
9594	51140029	Commerzbank Diez Lahn	
9595	51150018	Kr Spk Limburg	
9605	51151919	Kr Spk Weilburg	
9613	51161606	VB Langendernbach Waldbrunn	
9614	51161606	Volksbank Langendernbach	
9615	51190000	Ver Volksbank Limburg	
9623	51191800	Volksbank Schupbach	
9624	51220400	Bank Saderat Iran Frankfurt	
9625	51230801	Wirecard Bank	
9626	51230802	Wirecard Bank	
9627	51230805	Wirecard Bank	
9628	51250000	Taunus-Sparkasse Steinbach	
9629	51250000	Taunus-Sparkasse Schwalbach	
9630	51250000	Taunus-Sparkasse Sulzbach	
9631	51250000	Taunus-Sparkasse Eschborn	
9632	51250000	Taunus-Sparkasse Eppstein	
9633	51250000	Taunus-Sparkasse Hattershm	
9634	51250000	Taunus-Sparkasse Friedrdf	
9635	51250000	Taunus-Sparkasse Flörsheim	
9636	51250000	Taunus-Sparkasse Bad Soden	
9637	51250000	Taunus-Sparkasse Niedernhsn	
9638	51250000	Taunus-Sparkasse Hofheim	
9639	51250000	Taunus-Sparkasse Hochheim	
9640	51250000	Taunus-Sparkasse Kelkheim	
9641	51250000	Taunus-Sparkasse Kronberg	
9642	51250000	Taunus-Sparkasse Kriftel	
9643	51250000	Taunus-Sparkasse Königstein	
9644	51250000	Taunus-Sparkasse Oberursel	
9645	51250000	Taunus-Sparkasse Schmitten	
9646	51250000	Taunus-Sparkasse N-Anspach	
9647	51250000	Taunus-Sparkasse Usingen	
9648	51250000	Taunus-Sparkasse Wehrheim	
9649	51250000	Taunus-Sparkasse Liederbach	
9650	51250000	Taunus-Sparkasse Weilrod	
9651	51250000	Taunus-Sparkasse Grävenwbch	
9652	51250000	Taunus Sparkasse Frankfurt	
9653	51340013	Commerzbank Friedberg Hess	
9654	51340013	Commerzbank Bad Nauheim	
9655	51350025	Sparkasse Gießen	
9666	51351526	Sparkasse Grünberg Rabenau	
9667	51352227	Sparkasse Laubach-Hungen	
9668	51361021	Volksbank Heuchelheim	
9672	51361704	Volksbank Holzheim	
9673	51362514	VR Bank Mücke	
9674	51363407	Volksbank Garbenteich -alt-	
9675	51380040	Commerzbank Bad Nauheim	
9676	51390000	VB Mittelhessen	
9708	51390000	Volksbank Mittelhessen	
9730	51540037	Commerzbank Butzbach	
9731	51550035	Sparkasse Wetzlar	
9745	51591300	Volksbank Brandoberndorf	
9746	51650045	Spk Dillenburg	
9756	51690000	Volksbank Dill VB u Raiffbk	
9767	51691500	Volksbank Herborn-Eschenbg	
9770	51752267	Sparkasse Battenberg	
9773	51762434	VR Bank Biedenk-Gladenb	
9781	51850079	Spk Oberhessen	
9823	51861403	Volksbank Butzbach	
9825	51861403	VB Butzbach Zw Langenhain	
9826	51861616	LdBk Horlofftal Reichelshei	
9827	51861616	Ldbk Horlofftal Echzell	
9828	51861616	Ldbk Horlofftal Florstadt	
9829	51861806	Volksbank Ober-Mörlen	
9830	51961023	Volksbank Ulrichstein	
9833	51961515	Spar-u Darlehnskasse	
9834	51961801	Volksbank Feldatal	
9836	51990000	Volksbank Lauterbach-Schl	
9840	52040021	Commerzbank Korbach	
9841	52040021	Commerzbank Warburg Westf	
9842	52040021	Commerzbank Hann Münden	
9843	52050353	Kasseler Sparkasse	
9870	52051877	St Spk Grebenstein	
9873	52052154	Kreissparkasse Schwalm-Eder	
9899	52060208	Kurhessische Landbk Kassel	
9900	52060410	Ev Kreditgenossensch Kassel	
9901	52061303	Raiffbk Borken	
9905	52062200	VR-Bank Chattengau	
9911	52062601	VR-Bank Schwalm-Eder	
9919	52063369	VR-Bank Spangenbg-Morschen	
9921	52063550	Raiffbk	
9928	52064156	Raiffeisenbank Baunatal	
9936	52065220	Raiffeisenbank	
9937	52065220	Raiffeisenbank Calden	
9938	52065220	Raiffeisenbank Grebenstein	
9939	52065220	Raiffeisenbank Ahnatal	
9940	52069013	Raiffeisenbank Burghaun	
9941	52069029	Spar-u Kredit-Bank Haina	
9942	52069029	Spar-u Kredit-Bank Wohratal	
9943	52069029	Spar-u Kredit-Bk Rosenthal	
9944	52069029	Spar-u Kredit-Bank Gemünden	
9945	52069065	Raiffbk Langenschw. Burghau	
9946	52069103	Raiffeisenbank Trendelburg	
9947	52069149	Raiffbk Volkmarsen	
9949	52069149	Raiffbk Volkmarsen Arolsen	
9950	52069519	Frankenberger Bank	
9954	52080080	Commerzbank Hann Münden	
9955	52090000	Kasseler Bank	
9973	52260385	VR-Bank Werra-Meißner	
9987	52350005	Spk Waldeck-Frankenberg	
10004	52360059	Waldecker Bk Volkmarsen	
10005	52360059	Waldecker Bk Willingen	
10006	52360059	Waldecker Bk Bad Wildungen	
10007	52360059	Waldecker Bank Korbach	
10008	52360059	Waldecker Bank Arolsen	
10009	52360059	Waldecker Bank Vöhl	
10010	52360059	Waldecker Bk Lichtenfels	
10011	52360059	Waldecker Bk Waldeck, Hess	
10012	52360059	Waldecker Bank Twistetal	
10013	52360059	Waldecker Bk Diemelsee	
10014	52360059	Waldecker Bk Diemelstadt	
10015	53040012	Commerzbank Lauterbach	
10016	53040012	Commerzbank Schlüchtern	
10017	53050180	Sparkasse Fulda	
10039	53051396	Kreissparkasse Schlüchtern	
10042	53060180	VR Genossenschaftsbk Fulda	
10054	53061230	VR-Bank Nordrhön Hünfeld	
10055	53061230	VR-Bank NordRhön Hünfeld	
10064	53061313	VR Bk Schlüchtern-Birstein	
10070	53062035	Raiffbk Großenlüder	
10071	53062035	Raiffbk Großenl B Salzschl	
10072	53062035	Raiffeisenbank Haimbach	
10073	53062035	Raiffeisenbank Hosenfeld	
10074	53062350	Raiffbk Biebergrd-Petersbg	
10077	53064023	Raiffeisenbank Flieden	
10078	53080030	Commerzbank Lauterbach	
10079	53080030	Commerzbank Schlüchtern	
10080	53093200	VR Bank HessenLand	
10101	53250000	Spk Bad Hersfeld-Rotenburg	
10120	53260145	Raiffeisenbank Asbach-Sorga	
10121	53261202	Bankverein Bebra	
10127	53261342	Raiffbk Werratal-Landeck	
10134	53262073	Raiffeisenbank Haunetal	
10136	53262073	Raiffbk Haunetal Hauneck	
10138	53262455	Raiffeisenbank Ronshausen	
10139	53262455	Raiffeisenbank Marksuhl	
10146	53290000	VR-Bank Bad Hersfeld-Rotenb	
10158	53340024	Commerzbank Stadtallendorf	
10159	53350000	Spk Marburg-Biedenkopf	
10180	53361724	Raiffbk Ebsdorfergrund	
10183	54020474	UniCredit exHypo Ndl697Kais	
10184	54050220	Kr Spk Kaiserslautern	
10223	54051550	Kr Spk Kusel	
10231	54051990	Sparkasse Donnersberg	
10244	54061650	VR-Bank Westpfalz	
10265	54062027	Raiffeisenbank Albisheim	
10266	54090000	VB Kaisersl.-Nordwestpf.	
10289	54091700	Volksbank Lauterecken	
10301	54092400	Volksbank Glan-Münchweiler	
10311	54220576	UniCredit exHypo Ndl358Pirm	
10312	54250010	Spk Südwestpfalz Contwig	
10313	54250010	Spk Südwestpfalz Hornbach	
10314	54250010	Spk Südwestpfalz Hinterweid	
10315	54250010	Spk Südwestpfalz Herschberg	
10316	54250010	Spk Südwestpfalz Hermersbg	
10317	54250010	Spk Südwestpfalz Heltersbg	
10318	54250010	Spk Südwestpfalz Hauenstein	
10319	54250010	Spk Südwestpfalz Fischbach	
10320	54250010	Spk Südwestpfalz Dahn	
10321	54250010	Spk Südwestpfalz Bechhofen	
10322	54250010	Spk Südwestpfalz Bruchm-Mie	
10323	54250010	Spk Südwestpfalz Münchweil	
10324	54250010	Spk Südwestpfalz Lemberg	
10325	54250010	Spk Südwestpfalz Zweibrück	
10326	54250010	Spk Südwestpfalz Wilgartsw	
10327	54250010	Spk Südwestpfalz Waldf-Burg	
10328	54250010	Spk Südwestpfalz Trulben	
10329	54250010	Spk Südwestpfalz Thaleischw	
10330	54250010	Spk Südwestpfalz Rodalben	
10331	54250010	Spk Südwestpfalz Vinningen	
10332	54250010	Spk Südwestpfalz Rieschweil	
10333	54250010	Spk Südwestpfalz Wallhalben	
10334	54261700	VR-Bank Südwestpfalz	
10342	54290000	VR-Bank Pirmasens	
10348	54291200	Raiffeisen u Volksbank Dahn	
10354	54520071	UniCredit exHypo Ndl650 Lu	
10355	54540033	Commerzbank Frankenthal Pfa	
10356	54540033	Commerzbank Speyer	
10357	54540033	Commerzbank Bad Dürkheim	
10358	54550120	Kreissparkasse Rhein-Pfalz	
10373	54561310	RV Bank Rhein-Haardt	
10393	54620574	UniCredit exHypo Ndl660Ne/W	
10394	54651240	Spk Rhein-Haardt	
10420	54661800	Raiffeisenbank Freinsheim	
10422	54663270	Raiffbk Rödersheim-Gronau	
10423	54663270	Raiffbk Friedelsheim	
10424	54691200	VR Bank Mittelhaardt	
10432	54750010	Kr u St Spk Dudenhofen Pf	
10433	54750010	Kr u St Spk Römerberg	
10434	54750010	Kr u St Spk Otterstadt	
10435	54750010	Kr u St Spk Waldsee Pfalz	
10436	54750010	Kr u St Spk Harthausen Pf	
10437	54750010	Kr u St Spk Hanhofen	
10438	54761411	Raiffbk Schifferstadt	
10439	54790000	VB Kur- und Rheinpfalz	
10465	54820674	UniCredit exHypo Ndl659LanP	
10466	54850010	Spk Südl Weinstr in Landau	
10491	54851440	Spk Jockgrim	
10492	54851440	Spk Hördt Pfalz	
10493	54851440	Spk Hatzenbühl	
10494	54851440	Spk Hagenbach Pfalz	
10495	54851440	Spk Germersheim	
10496	54851440	Spk Berg Pfalz	
10497	54851440	Spk Bellheim	
10498	54851440	Spk Neupotz	
10499	54851440	Spk Neuburg Rhein	
10500	54851440	Spk Lustadt	
10501	54851440	Spk Lingenfeld	
10502	54851440	Spk Leimersheim	
10503	54851440	Spk Zeiskam	
10504	54851440	Spk Wörth Rhein	
10505	54851440	Spk Steinweiler Pfalz	
10506	54851440	Spk Schwegenheim	
10507	54851440	Spk Rülzheim	
10508	54851440	Spk Rheinzabern	
10509	54851440	Spk Minfeld	
10510	54851440	Spk Freckenfeld	
10511	54851440	Spk Kuhardt	
10512	54861190	Raiffbk Oberhaardt-Gäu	
10513	54862390	Raiffeisenbank Herxheim	
10516	54862500	VR Bank Südpfalz	
10545	54862500	VR Bank Südpfalz Edesheim	
10548	54891300	VR Bank Südl Weinstr	
10560	55040022	Commerzbank Bad Kreuznach	
10561	55040022	Commerzbank Mainz-Kastel	
10562	55040022	Commerzbank Ingelheim Rhein	
10563	55050120	Sparkasse Mainz	
10574	55060417	VR-Bank Mainz	
10576	55060611	Genobank Mainz	
10577	55061303	Budenheimer Volksbank	
10578	55061507	VR-Bank Mainz	
10579	55061907	Volksbank Rhein-Selz	
10580	55090500	Sparda-Bank Südwest	
10617	55091200	Volksbank Alzey-Worms	
10659	55190000	Mainzer Volksbank Mainz	
10660	55190000	Mainzer Volksbank	
10670	55350010	Sparkasse Worms-Alzey-Ried	
10674	55350010	Sparkasse Worms	
10689	55361202	VR Bank	
10693	55362071	Volksbank Bechtheim	
10694	55390000	Volksbank Worms-Wonnegau	
10695	56050180	Sparkasse Rhein-Nahe	
10719	56051790	Kr Spk Rhein-Hunsrück	
10732	56061151	Raiffeisenbank Kastellaun	
10739	56061472	VB Hunsrück-Nahe	
10750	56061472	Vb Hunsrück-Nahe	
10759	56062227	Volksbank Rheinböllen	
10763	56062577	Vereinigte Raiffeisenkassen	
10764	56090000	VB Rhein-Nahe-Hunsrück	
10787	56240050	Commerzbank Kirn Nahe	
10788	56250030	Kr Spk Birkenfeld	
10811	56261735	Raiffeisenbank Nahe	
10819	57020500	Oyak Anker Bank	
10821	57040044	Commerzbank Neuwied	
10822	57040044	Commerzbank Mayen	
10823	57040044	Commerzbank Andernach	
10824	57040044	Commerzbank Bad Ems	
10825	57050120	Sparkasse Koblenz	
10847	57051001	Kr Spk Westerwald	
10931	57062675	Raiffbk Niederwallmenach	
10935	57063478	Volksbank Vallendar-Niederw	
10936	57063478	VB Vallendar-Niederwerth	
10938	57064221	Volksbank Mülheim-Kärlich	
10939	57069067	Raiffbk Lutzerather-Höhe	
10941	57069067	Raiffbk Lutzerather Höhe	
10944	57069081	Raiffeisenbank Moselkrampen	
10947	57069144	Raiffbk Eifeltor	
10961	57069144	Raiffbk Kaisersesch	
10962	57069238	Raiffbk Neustadt	
10968	57069361	Raiffeisenbank Welling	
10969	57069727	Raiffeisenbank Irrel	
10972	57069806	VR-Bank Hunsrück-Mosel	
10984	57080070	Commerzbank Bad Ems	
10985	57080070	Commerzbank Neuwied	
10986	57080070	Commerzbank Andernach	
10987	57090000	VB Koblenz Mittelrhein	
10991	57090900	PSD Bank Koblenz	
10992	57091000	Volksbank Montabaur	
10998	57092800	Volksbank Rhein-Lahn	
11015	57263015	Raiffeisenbank Arzbach	
11019	57351030	Kreissparkasse Altenkirchen	
11034	57361476	Volksbank Gebhardshain	
11039	57363243	Raiffbk Niederfischbach	
11040	57391200	Volksbank Daaden	
11041	57391200	VB Daaden Friedewald, Weste	
11042	57391200	VB Daaden Herdorf, Sieg	
11043	57391200	VB Daaden Weitefeld	
11044	57391500	VB Hamm, Sieg Hamm, Sieg	
11045	57391500	VB Eichelhardt	
11046	57391500	VB Rosbach Windeck, Sieg	
11047	57391800	Westerwald Bank	
11072	57450120	Sparkasse Neuwied	
11091	57460117	VR-Bank Neuwied-Linz	
11102	57461759	Raiffbk Mittelrhein	
11107	57461759	Raiffeisenbk Mittelrhein	
11109	57650010	Kr Spk Mayen	
11136	57661253	Raiffeisenbank Kehrig	
11138	57662263	VR Bank Rhein-Mosel	
11156	57751310	Kr Spk Ahrweiler	
11176	57761591	VB RheinAhrEifel	
11203	57762265	Raiffbk Grafschaft-Wachtbg	
11206	58540035	Commerzbank Saarburg Saar	
11207	58540035	Commerzbank Wittlich	
11208	58550130	Sparkasse Trier	
11252	58560103	Volksbank Trier	
11266	58561626	Volksbank Saarburg	
11267	58561771	Raiffbk Mehring-Leiwen	
11271	58564788	VB Hochwald-Saarburg	
11288	58580074	Commerzbank Wittlich	
11289	58650030	Kr Spk Bitburg-Prüm	
11314	58651240	Kreissparkasse Vulkaneifel	
11326	58660101	Volksbank Bitburg	
11337	58661901	Raiffeisenbank Westeifel	
11346	58662653	Raiffbk östl Südeifel	
11357	58691500	Volksbank Eifel Mitte	
11370	58760954	VVR-Bank Wittlich	
11387	58761343	Raiffbk Zeller Land	
11394	59040000	Commerzbank Neunkrchn Saar	
11395	59040000	Commerzbank Homburg Saar	
11396	59040000	Commerzbank Sankt Wendel	
11397	59040000	Commerzbank Saarlouis	
11398	59040000	Commerzbank Dillingen Saar	
11399	59040000	Commerzbank Sankt Ingbert	
11400	59050101	Sparkasse Saarbrücken	
11408	59070070	Deutsche Bank PGK Saar	
11414	59080090	Commerzbank Saarlouis	
11415	59080090	Commerzbank Sankt Ingbert	
11416	59080090	Commerzbank	
11417	59092000	Vereinigte Volksbank	
11422	59099530	Raiffeisenkasse Wiesbach	
11423	59099550	Volksbank Nahe-Schaumberg	
11424	59099550	VB Nahe-Schaumberg Tholey	
11426	59190000	Bank 1 Saar	
11454	59190200	Volksbank Saar-West	
11460	59251020	Kr Spk St. Wendel	
11467	59252046	Sparkasse Neunkirchen	
11473	59291000	Sankt Wendeler Volksbank	
11478	59291000	St. Wendeler Volksbank	
11480	59291200	Volksbank Saarpfalz	
11487	59350110	Kreissparkasse Saarlouis	
11499	59351040	Spk Merzig-Wadern	
11505	59390100	Volksbank Saarlouis	
11512	59391200	Volksbank Überherrn	
11513	59392000	Volksbank Dillingen	
11517	59392200	Volksbank Untere Saar	
11520	59393000	levoBank	
11525	59450010	Kreissparkasse Saarpfalz	
11531	59491300	VR Bank Saarpfalz	
11536	60030600	CreditPlus Bank	
11545	60040071	Commerzbank Fellbach Württ	
11546	60040071	Commerzbank Leonberg Württ	
11547	60040071	Commerzbank Böblingen	
11548	60040071	Commerzbank Schorndorf Wür	
11549	60040071	Commerzbank Filderstadt	
11550	60040071	Commerzbank Waiblingen	
11551	60040071	Commerzbank Leinf-Echterd	
11552	60050009	ZV LBBW ISE Stuttgart	
11553	60050101	BW-Bank/LBBW Stuttgart	
11606	60050101	BW-Bank/LBBW Achern	
11607	60050101	BW-Bank/LBBW Bad Wimpfen	
11608	60050101	BW-Bank/LBBW Baden-Baden	
11609	60050101	BW-Bank/LBBW Bopfingen	
11610	60050101	BW-Bank/LBBW Crailsheim	
11611	60050101	BW-Bank/LBBW Donaueschingen	
11612	60050101	BW-Bank/LBBW Dresden	
11613	60050101	BW-Bank/LBBW Eberbach	
11614	60050101	BW-Bank/LBBW Ellwangen	
11615	60050101	BW-Bank/LBBW Freiburg	
11616	60050101	BW-Bank/LBBW Halle	
11617	60050101	BW-Bank/LBBW Hechingen	
11618	60050101	BW-Bank/LBBW Heidelberg	
11619	60050101	BW-Bank/LBBW Karlsruhe	
11620	60050101	BW-Bank/LBBW Konstanz	
11621	60050101	BW-Bank/LBBW Lauffen Neckar	
11622	60050101	BW-Bank/LBBW Leipzig	
11623	60050101	BW-Bank/LBBW Lörrach	
11624	60050101	BW-Bank/LBBW Mannheim	
11625	60050101	BW-Bank/LBBW Mosbach Baden	
11626	60050101	BW-Bank/LBBW Offenburg	
11627	60050101	BW-Bank/LBBW Öhringen	
11628	60050101	BW-Bank/LBBW Pforzheim	
11629	60050101	BW-Bank/LBBW Rastatt	
11630	60050101	BW-Bank/LBBW Singen	
11631	60050101	BW-Bank/LBBW Tauberbischofs	
11632	60050101	BW-Bank/LBBW Wertheim	
11633	60050101	LBBW/RLP Bank Mainz	
11634	60050101	LBBW/RLP Bk Kaiserslautern	
11635	60050101	LBBW/RLP Bank Koblenz	
11636	60060396	Untertürkheimer Volksbank	
11637	60062775	Echterdinger Bank	
11638	60062909	Volksbank Strohgäu	
11642	60069017	Raiffbk Dellmensingen	
11644	60069066	Raiffeisenbank Niedere Alb	
11648	60069075	Raiffbk Bühlertal	
11649	60069147	Raiffbk Sondelfingen	
11650	60069158	Raiffeisenbank Steinheim	
11651	60069158	Raiffbk Steinheim	
11652	60069206	Raiffeisenbank Aidlingen	
11653	60069224	Genossenschaftsbank Weil	
11654	60069235	Raiffbk Waldachtal -alt-	
11655	60069239	Bopfinger Bank Sechta-Ries	
11659	60069242	Raiffbk Gruibingen	
11660	60069245	Raiffbk Bühlertal	
11662	60069251	Raiffbk Donau-Iller	
11671	60069302	Raiffeisenbank Erlenmoos	
11672	60069303	Raiffbk Bad Schussenried	
11673	60069308	Raiffbk Ingoldingen	
11674	60069325	Hegnacher Bank	
11675	60069336	Raiffbk Maitis	
11676	60069346	Raiffbk Ehingen-Hochsträß	
11677	60069350	Raiffbk Reute-Gaisbeuren	
11678	60069355	Ehninger Bank	
11679	60069378	VB Dettenhausen	
11680	60069387	Dettinger Bank	
11681	60069417	Raiffbk Kirchheim-Walheim	
11682	60069419	Uhlbacher Bank	
11683	60069431	Raiffbk Oberessendorf	
11684	60069442	Raiffbk Frankenh-Stimpfach	
11686	60069455	Raiffbk Vordersteinenberg	
11687	60069457	Raiffeisenbank Ottenbach	
11688	60069461	Raiffbk Rottumtal	
11692	60069462	Winterbacher Bank	
11693	60069476	Raiffbk Heidenheimer Alb	
11695	60069485	Raiffbk ob Wald Simmersfeld	
11697	60069505	Volksbank Murgtal	
11698	60069517	Scharnhauser Bank	
11699	60069527	Volksbank Brenztal	
11704	60069538	Löchgauer Bank	
11706	60069544	Raiffeisenbank Westhausen	
11707	60069545	Nufringer Bank	
11708	60069553	Raiffbk Aichh-Hardt-Sulgen	
11711	60069564	Raiffeisenbank Vordere Alb	
11712	60069564	Raiffbk Vordere Alb	
11713	60069593	Raiffbk Oberes Schlichemtal	
11719	60069595	Raiffbk Schrozberg-Rot	
11722	60069639	Raiffbk Ingersheim	
11723	60069648	Raiffeisenbank	
11724	60069648	Raiffeisenbank Biberach	
11725	60069648	Raiffeisenbank Eberhardzell	
11726	60069648	Raiffeisenbank Hochdorf	
11727	60069673	Abtsgmünder Bank	
11728	60069673	Fachsenfelder Bank	
11729	60069680	Raiffbk Bretzfeld	
11730	60069680	Raiffeisenbank Bretzfeld	
11731	60069685	Raiffeisenbank Wangen	
11735	60069706	Raiffbk Mehrstetten	
11737	60069710	Raiffbk Gammesfeld	
11738	60069714	Raiffeisenbank Kocher-Jagst	
11744	60069724	Raiffbk Heroldstatt	
11745	60069727	Raiffbk Oberstenfeld	
11746	60069738	VB Freiberg und Umgebung	
11747	60069798	Raiffeisenbank Horb	
11749	60069817	Raiffbk Mötzingen	
11750	60069832	Raiffbk Urbach	
11751	60069842	Darmsheimer Bank	
11752	60069858	Enztalbank	
11755	60069860	Federseebank	
11760	60069876	Raiffeisenbank Oberes Gäu	
11763	60069904	VR-Bank Alb	
11768	60069905	Volksbank Remseck	
11769	60069911	Raiffbk Erlenbach	
11770	60069926	VB Glatten-Wittendorf	
11772	60069927	Berkheimer Bank	
11773	60069931	Raiffbk Berghülen	
11774	60069950	Raiffbk Tüngental	
11775	60069976	Raiffbk Böllingertal	
11777	60080000	Commerzbank Leinf-Echterd	
11778	60080000	Commerzbank Fellbach	
11779	60080000	Commerzbank Kornwestheim	
11780	60080000	Commerzbank Freudenstadt	
11781	60080000	Commerzbank Waiblingen	
11782	60080000	Commerzbank Leonberg	
11783	60080000	Commerzbank Schwäbisch Gm	
11784	60080000	Commerzbank Backnang	
11785	60090100	Volksbank Stuttgart	
11805	60090300	VB Zuffenhausen	
11806	60090700	Südwestbank	
11826	60090700	Südwestbank Stuttgart	
11827	60090700	Südwestbk Bietigh-Bissingen	
11828	60120050	UniCredit exHypo Ndl434Stgt	
11829	60250010	Kr Spk Waiblingen	
11859	60261329	Fellbacher Bank	
11860	60261622	VR-Bank Weinstadt	
11861	60261818	Raiffbk Weissacher Tal	
11863	60262063	Korber Bank	
11864	60262693	Kerner Volksbank	
11865	60290110	Volksbank Rems	
11880	60291120	Volksbank Backnang	
11894	60340071	Commerzbank Herrenberg	
11895	60350130	Kr Spk Böblingen	
11920	60361923	Raiffeisenbank Weissach	
11922	60380002	Commerzbank Sindelfingen	
11923	60380002	Commerzbank Herrenberg	
11924	60390000	Vereinigte Volksbank	
11945	60390300	Volksbank Region Leonberg	
11951	60391310	VB Herrenberg-Rottenburg	
11957	60391420	Volksbank Magstadt	
11958	60420000	Wüstenrot Bank	
11982	60440073	Commerzbank Bietigheim-Biss	
11983	60450050	Kreissparkasse Ludwigsburg	
12021	60462808	VR-Bank Asperg-Markgröning	
12028	60470024	Deutsche Bank PGK Vaihingen	
12029	60470082	Deutsche Bank Vaihingen	
12030	60480008	Commerzbank Bietigheim-Bi	
12031	60490150	Volksbank Ludwigsburg	
12046	60491430	VR-Bank Neckar-Enz	
12063	60651070	Kreissparkasse Calw -alt-	
12064	60661369	Raiffeisenbank Birkenfeld	
12065	60661906	Raiffbk Wimsheim-Mönsheim	
12067	60663084	Raiffbk Calw	
12075	60691440	VB Maulbronn-Oberderdingen	
12076	61040014	Commerzbank Geislingen Stei	
12077	61050000	Kr Spk Göppingen	
12113	61060500	Volksbank Göppingen	
12135	61091200	VB Raiffbk Deggingen	
12138	61091200	VB-Raiffbk Deggingen	
12139	61140071	Commerzbank Kirchheim Teck	
12140	61140071	Commerzbank Plochingen	
12141	61150020	Kr Spk Esslingen-Nürtingen	
12184	61161696	VB Filder	
12186	61180004	Commerzbank Plochingen	
12187	61190110	Volksbank Esslingen Neckar	
12190	61190110	Volksbank Esslingen	
12191	61191310	Altbacher Bank	
12192	61191310	Deizisauer Bank	
12193	61191310	Denkendorfer Bank	
12194	61191310	Hochdorfer Bank	
12195	61191310	Volksbank Plochingen	
12196	61191310	Volksbank Reichenbach	
12197	61191310	Wernauer Bank	
12198	61191310	VB Plochingen	
12199	61261213	Raiffeisenbank Teck	
12205	61261339	Volksbank Hohenneuffen	
12209	61262258	Genossenschaftsbank	
12210	61262345	Bernhauser Bank	
12211	61281007	Commerzbank Nürtingen	
12212	61290120	VB Kirchheim-Nürtingen	
12228	61361722	Raiffeisenbank Rosenstein	
12233	61361975	Raiffeisenbank Mutlangen	
12241	61390140	Volksbank Schwäbisch Gmünd	
12247	61391410	Volksbank Welzheim	
12249	61450050	Kreissparkasse Ostalb	
12286	61490150	VR-Bank Aalen	
12294	61491010	VR-Bank Ellwangen	
12302	62040060	Commerzbank Neckarsulm	
12303	62050000	Kr Spk Heilbronn	
12349	62061991	Volksbank Sulmtal	
12355	62062215	VB Beilstein-Ilsfeld-Abstat	
12360	62062643	Volksbank Flein-Talheim	
12363	62063263	VBU Volksbank im Unterland	
12369	62080012	Commerzbank Neckarsulm	
12370	62090100	Volksbank Heilbronn	
12380	62091400	VB Brackenheim-Güglingen	
12385	62091600	VB Möckmühl-Neuenstadt	
12394	62091800	Volksbank Hohenlohe	
12418	62250030	Sparkasse Schwäbisch Hall	
12441	62251550	Sparkasse Hohenlohekreis	
12456	62290110	VR Bk Schwäb. Hall-Crailsh.	
12478	62291020	Crailsheimer Volksbank	
12485	62391010	Volksbank Bad Mergentheim	
12486	62391420	Volksbank Vorbach-Tauber	
12489	63020450	UniCredit exHypo Ndl274 Ulm	
12490	63040053	Commerzbank Neu-Ulm	
12491	63040053	Commerzbank Ehingen Donau	
12492	63050000	Sparkasse Ulm	
12528	63061486	VR-Bank Langenau-Ulmer Alb	
12541	63080015	Commerzbank Biberach Riß	
12542	63090100	Volksbank Ulm-Biberach	
12558	63091010	Ehinger Volksbank	
12566	63091200	Volksbank Blaubeuren	
12567	63091300	Volksbank Laichinger Alb	
12574	63250030	Kr Spk Heidenheim	
12584	63290110	Heidenheimer Volksbank	
12591	63291210	Giengener Volksbank	
12592	64050000	Kr Spk Reutlingen	
12617	64061854	VR Steinlach-Wiesaz-Härten	
12625	64090100	Volksbank Reutlingen	
12634	64091200	VB Metzingen-Bad Urach	
12640	64091300	Volksbank Münsingen	
12645	64150020	Kr Spk Tübingen	
12659	64161397	Volksbank Ammerbuch	
12662	64161608	Raiffbk Härten	
12663	64161956	Volksbank Mössingen	
12665	64163225	Volksbank Hohenzollern	
12677	64190110	Volksbank Tübingen	
12679	64191030	Volksbank Nagoldtal	
12686	64191210	Volksbank Altensteig -alt-	
12687	64191700	Volksbank Horb	
12688	64232000	Faißtbank Schramberg	
12689	64250040	Kr Spk Rottweil	
12707	64261363	VB Baiersbronn Murgtal	
12709	64261853	Volksbank Nordschwarzwald	
12714	64262408	Loßburger Bank	
12715	64262408	Volksbank Dornstetten	
12717	64290120	Volksbank Rottweil	
12729	64291010	VB Horb-Freudenstadt	
12737	64291420	Volksbank Deißlingen	
12738	64292020	VB Schwarzwald-Neckar	
12746	64292310	Raiffeisenbank Talheim	
12747	64292310	Volksbank Trossingen	
12749	64292310	Gbk Gunningen	
12751	64350070	Kr Spk Tuttlingen	
12782	64361359	Raiffbk Donau-Heuberg	
12791	64380011	Commerzbank Trossingen	
12792	64390130	Volksbank Donau-Neckar	
12814	65040073	Commerzbank Saulgau	
12815	65040073	Commerzbank Isny	
12816	65050110	Kr Spk Ravensburg	
12843	65061219	Raiffbk Aulendorf	
12844	65062577	Raiffeisenbank Ravensburg	
12853	65062793	Raiffbk Vorallgäu	
12854	65063086	Raiffeisenbank Bad Saulgau	
12855	65080009	Commerzbank Saulgau	
12856	65080009	Commerzbank Isny	
12857	65091040	Leutkircher Bank	
12861	65091040	Raiffeisenbank Bad Wurzach	
12862	65091300	Bad Waldseer Bank	
12863	65091600	Volksbank Weingarten	
12867	65092010	VB Allgäu-West	
12875	65092200	Volksbank Altshausen	
12879	65092200	VB Altshausen	
12881	65093020	VB Bad Saulgau	
12897	65140072	Commerzbank Lindau	
12898	65161497	Genossenschaftsbank	
12899	65162832	Raiffbk Oberteuringen	
12900	65180005	Commerzbank Lindau	
12901	65190110	Raiffeisenbank Eriskirch	
12902	65190110	Volksbank Friedrichshafen	
12904	65191500	Volksbank Tettnang	
12909	65340004	Commerzbank Sigmaringen	
12910	65351050	Ld Bk Kr Spk Sigmaringen	
12928	65351260	Spk Zollernalb	
12946	65361469	Volksbank Heuberg	
12949	65361898	Winterlinger Bank	
12950	65361989	Onstmettinger Bank	
12951	65362499	Raiffbk Geislingen-Rosenf	
12953	65390120	Volksbank Ebingen	
12955	65390120	Raiffbk Tieringen-Hausen	
12959	65390120	Volksbank Stetten a. k. M.	
12960	65391210	Volksbank Balingen	
12963	65392030	Volksbank Tailfingen	
12964	65450070	Kr Spk Biberach	
12993	65461878	Raiffbk Risstal	
12994	65462231	Raiffeisenbank Illertal	
12995	65491320	VR Laupheim-Illertal	
13009	65491510	VB-Raiffbk Riedlingen	
13016	66010700	L-Bank	
13017	66020150	UniCredit exHypo Ndl145Kruh	
13018	66040018	Commerzbank Ettlingen	
13019	66040018	Commerzbank Rastatt	
13020	66060300	Spar- und Kreditbank	
13021	66061059	VB Stutensee Hardt	
13022	66061407	Spar- u Kreditbk Rheinstett	
13023	66061724	VB Stutensee-Weingarten	
13025	66062138	Spar- u Kreditbank Hardt	
13027	66062366	Raiffbk Hardt-Bruhrain	
13031	66069103	Raiffeisenbank Elztal	
13032	66069104	Spar- u Kreditbk Dauchingen	
13033	66069342	Volksbank Krautheim	
13036	66080052	Commerzbank Ettlingen	
13037	66080052	Commerzbank Bruchsal	
13038	66090800	BBBank Karlsruhe	
13087	66091200	Volksbank Ettlingen	
13093	66190000	Volksbank Karlsruhe	
13094	66240002	Commerzbank Bühl Baden	
13095	66250030	Spk Baden-Baden Gaggenau	
13098	66251434	Sparkasse Bühl	
13103	66261092	Spar-u Kreditbank Bühlertal	
13104	66261416	Raiffeisenbank Altschweier	
13105	66280053	Commerzbank Rastatt	
13106	66280053	Commerzbank Bühl Baden	
13107	66290000	Volksbank Baden-Bdn Rastatt	
13118	66291300	Volksbank Achern	
13119	66291400	Volksbank Bühl	
13127	66350036	Spk Kraichgau	
13142	66350036	Sparkasse Kraichgau	
13154	66391200	VB Bruchsal-Bretten	
13171	66391600	VB Bruhrain-Kraich-Hardt	
13175	66450050	Sparkasse Offenburg/Ortenau	
13203	66451346	Spk Gengenbach	
13205	66451548	Spk Haslach-Zell	
13215	66451862	Spk Hanauerland	
13218	66452776	Spk Wolfach	
13222	66490000	Volksbank Offenburg	
13232	66491800	Volksbank Bühl	
13233	66491800	Volksbank Bühl Fil Kehl	
13234	66492700	VB Kinzigtal Gutach	
13235	66492700	VB Kinzigtal Hausach	
13236	66492700	VB Kinzigtal Oberwolfach	
13237	66492700	VB Kinzigtal Rötenberg	
13238	66492700	VB Kinzigtal Alpirsbach	
13239	66492700	VB Kinzigtal Haslach	
13240	66492700	VB Kinzigtal Schenkenzell	
13241	66492700	VB Kinzigtal Schiltach	
13242	66492700	VB Kinzigtal Steinach	
13243	66492700	VB Kinzigtal Wolfach	
13244	66550070	Sparkasse Rastatt-Gernsbach	
13257	66562053	Rb Südhardt Durmersheim	
13258	66562053	Raiffbk Südhardt Durmersh	
13261	66562300	VR-Bank Mittelb Iffezheim	
13271	66640035	Commerzbank Mühlacker	
13272	66661244	Raiffeisenbank Bauschlott	
13273	66661329	Raiffeisenbank Kieselbronn	
13274	66661454	VR Bank im Enzkreis	
13280	66662155	Raiffeisenbank Ersingen	
13281	66662220	Volksbank Stein Eisingen	
13285	66680013	Commerzbank Mühlacker	
13286	66690000	Volksbank Pforzheim	
13305	66692300	VB Wilferdingen-Keltern	
13311	66762332	Raiffbk Kraichgau	
13315	66762433	Raiffeisenbank Neudenau	
13317	67020259	UniCredit exHypo Ndl681Mnh	
13318	67040031	Commerzbank Weinheim Bergst	
13319	67040031	Commerzbank Sinsheim Elsenz	
13320	67040031	Commerzbank Schwetzingen	
13321	67040031	Commerzbank Hockenheim	
13322	67040031	Commerzbank Viernheim	
13323	67040031	Commerzbank Wiesloch	
13324	67040031	Commerzbank Mosbach	
13325	67040031	Commerzbank Landau Pfalz	
13326	67040031	Commerzbank Lampertheim	
13327	67040031	Commerzbank Ladenburg	
13328	67040031	Commerzbank Walldorf	
13329	67040031	Commerzbank Grünstadt	
13330	67050505	Spk Rhein Neckar Nord	
13339	67051203	Spk Hockenheim	
13342	67060031	Volksbank Ma-Sandhofen	
13343	67080050	Commerzbank Landau Pfalz	
13344	67080050	Commerzbank Lampertheim	
13345	67080050	Commerzbank Speyer	
13346	67080050	Commerzbank Worms	
13347	67080050	Commerzbank Viernheim	
13348	67080050	Commerzbank Frankenthal	
13349	67080050	Commerzbank Ladenburg	
13350	67080050	Commerzbank Walldorf	
13351	67080050	Commerzbank Weinheim	
13352	67080050	Commerzbank Grünstadt	
13353	67080050	Commerzbank Mosbach Baden	
13354	67090000	VR Bank Rhein-Neckar	
13366	67092300	Volksbank Weinheim	
13372	67220464	UniCredit exHypo Ndl488 Hd	
13373	67240039	Commerzbank Eppelheim	
13374	67250020	Spk Heidelberg	
13401	67262243	Raiff Privatbk Wiesloch	
13403	67262550	Volksbank Rot St Leon-Rot	
13404	67280051	Commerzbank Eppelheim	
13405	67290000	Heidelberger Volksbank	
13408	67290100	Volksbank Kurpfalz H+G Bank	
13410	67291700	Volksbank Neckartal	
13438	67291900	Volksbank Kraichgau	
13446	67292200	Volksbank Kraichgau	
13457	67292200	Volksbank Kraichgau (Gf P2)	
13458	67352565	Spk Tauberfranken	
13471	67352565	Sparkasse Tauberfranken	
13476	67390000	VB Main-Tauber	
13492	67450048	Spk Neckartal-Odenwald	
13520	67460041	Volksbank Mosbach	
13529	67461424	Volksbank Franken Buchen	
13536	67461733	Volksbank Kirnau	
13540	67462368	Volksbank Limbach	
13541	68020460	UniCredit exHypo Ndl405Frb	
13542	68040007	Commerzbank Lahr Schwarzw	
13543	68040007	Commerzbank Emmendingen	
13544	68040007	Commerzbank Kehl	
13545	68040007	Commerzbank Bad Krozingen	
13546	68040007	Commerzbank Bad Säckingen	
13547	68050101	Spk Freiburg-Nördl.Breisgau	
13551	68051004	Spk Hochschwarzwald Eisenb	
13552	68051004	Spk Hochschwarzwald Feldbg	
13553	68051004	Spk Hochschwarzwald Frieden	
13554	68051004	Spk Hochschwarzwald Hinterz	
13555	68051004	Spk Hochschwarzwald Lenzkir	
13556	68051004	Spk Hochschwarzwald Löffing	
13557	68051004	Spk Hochschwarzwald Kirchza	
13558	68051004	Spk Hochschwarzwald Breitn	
13559	68051004	Spk Hochschwarzwald Buchenb	
13560	68051004	Spk Hochschwarzwald Oberrie	
13561	68051004	Spk Hochschwarzwald Stegen	
13562	68051004	Spk Hochschwarzwald St Märg	
13563	68051004	Spk Hochschwarzwald St Pete	
13564	68051207	Spk Bonndorf-Stühlingen	
13569	68052230	Spk St. Blasien	
13574	68052328	Spk Staufen-Breisach	
13591	68052863	Spk Schönau-Todtnau	
13592	68061505	Volksbank Breisgau-Süd	
13605	68062105	Raiffbk Denzlingen-Sexau	
13607	68062730	Raiffbk Wyhl Kaiserstuhl	
13608	68063479	Raiffeisenbank Kaiserstuhl	
13610	68064222	Raiffeisenbank Gundelfingen	
13616	68080030	Commerzbank Rheinfelden	
13617	68080030	Commerzbank Kehl	
13618	68080030	Commerzbank Lörrach	
13619	68080030	Commerzbank Offenburg	
13620	68080030	Commerzbank Weil Rhein	
13621	68080030	Commerzbank Bad Krozingen	
13622	68080030	Commerzbank Bad Säckingen	
13623	68090000	Volksbank Freiburg	
13648	68090000	Volksbank Kirchzarten	
13649	68090000	Volksbank Schönau	
13650	68090000	Volksbank Todtnau	
13651	68091900	Volksbank Müllheim	
13658	68092000	VB Breisgau Nord	
13677	68092300	Volksbank Staufen	
13684	68290000	Volksbank Lahr	
13685	68340058	Commerzbank Weil Rhein	
13686	68340058	Commerzbank Rheinfelden Bad	
13687	68340058	Commerzbank Waldshut	
13688	68350048	Sparkasse Lörrach-Rheinfeld	
13693	68351557	Sparkasse Schopfheim-Zell	
13696	68351976	Spk Zell Wiesental	
13698	68370024	Deutsche Bank PGK Waldshut	
13699	68370034	Deutsche Bank Waldshut-Tien	
13700	68390000	VB Dreiländereck Lörrach	
13712	68391500	VR Bank	
13713	68391500	VR-Bank Schopfheim	
13719	68452290	Sparkasse Hochrhein	
13736	68462427	VB Klettgau-Wutöschingen	
13740	68490000	Volksbank Rhein-Wehra	
13752	68491500	Volksbank Jestetten	
13754	68492200	Volksbank Hochrhein	
13759	68492200	VB Hochrhein Waldshut-Tieng	
13767	68492200	Volksbank St Blasien	
13768	69050001	Sparkasse Bodensee	
13784	69051410	Bez Spk Reichenau	
13785	69051620	Spk Pfullendorf-Meßkirch	
13790	69051725	Spk Salem-Heiligenberg	
13796	69061800	Volksbank Überlingen	
13812	69091200	Hagnauer Volksbank	
13813	69091200	Hagnauer Volksbank Immenstd	
13814	69091600	Volksbank Pfullendorf	
13816	69240075	Commerzbank Schramberg	
13817	69240075	Commerzbank Überlingen	
13818	69240075	Commerzbank Donaueschingen	
13819	69250035	Bez Spk Rielasingen-Worblng	
13820	69250035	Bez Spk Volkertshausen	
13821	69250035	Spk Singen-Radolfzell	
13826	69251445	Spk Engen-Gottmadingen	
13835	69251755	Sparkasse Stockach	
13839	69280035	Commerzbank Vil-Schwenn	
13840	69280035	Commerzbank Konstanz	
13841	69280035	Commerzbank Schramberg	
13842	69280035	Commerzbank Überlingen	
13843	69280035	Commerzbank Donauesching	
13844	69290000	Volksbank Hegau	
13853	69291000	Volksbank Konstanz	
13863	69362032	Volksbank Meßkirch Raiffbk	
13872	69440007	Commerzbank Tuttlingen	
13873	69440007	Commerzbank Freudenstadt	
13874	69440007	Commerzbank Bad Dürrheim	
13875	69450065	Spk Schwarzwald-Baar	
13894	69490000	Volksbank Villingen	
13909	69490000	VB Schwarzwald Baar Hegau	
13919	69491700	Volksbank Triberg	
13920	69491700	Volksbank Furtwangen	
13921	69491700	Volksbank Hornberg	
13922	69491700	Volksbank Schonach	
13923	69491700	Volksbank Schönwald	
13924	70020001	UniCredit exHypo Ndl645 M	
13925	70020300	Commerz Finanz München	
13927	70020500	Bank für Sozialwirtschaft	
13928	70040041	Commerzbank Pullach	
13929	70040041	Commerzbank Dachau	
13930	70040041	Commerzbank Unterföhring	
13931	70040041	Commerzbank GarmischPartenk	
13932	70040041	Commerzbank Ottobrunn	
13933	70040041	Commerzbank Freising	
13934	70040041	Commerzbank Fürstenfeldbruc	
13935	70040048	Commerzbank Bad Tölz	
13936	70040048	Commerzbank Rottach-Egern	
13937	70040048	Commerzbank Landau Isar	
13938	70040048	Commerzbank Donauwörth	
13939	70040048	Commerzbank Eggenfelden	
13940	70040048	Commerzbank Starnberg	
13941	70040048	Commerzbank Oberschleißhm	
13942	70040048	Commerzbank Geretsried	
13943	70040048	Commerzbank Reichenhall	
13944	70040048	Commerzbank Traunstein	
13945	70040048	Commerzbank Gräfelfing	
13946	70040048	Commerzbank Günzburg	
13947	70040048	Commerzbank Unterhaching	
13948	70040048	Commerzbank Landsberg	
13949	70040048	Commerzbank Grünwald	
13950	70040048	Commerzbank Füssen	
13951	70040048	Commerzbank Freilassing	
13952	70040048	Commerzbank Miesbach	
13953	70040048	Commerzbank Altötting	
13954	70040048	Commerzbank Erding	
13955	70040048	Commerzbank Weilheim Obb	
13956	70040048	Commerzbank Germering	
13957	70051003	Sparkasse Freising	
13969	70051540	Sparkasse Dachau	
13982	70051805	Kreissparkasse	
13993	70051995	Spk Erding-Dorfen	
14009	70052060	Spk Landsberg-Dießen	
14026	70052060	SpkLandsberg-Dießen	
14030	70053070	Spk Fürstenfeldbruck	
14048	70054306	Spk Bad Tölz-Wolfratshausen	
14068	70070010	Deutsche Bank Waldkraiburg	
14069	70070010	Deutsche Bank Gilching	
14070	70070024	Deutsche Bank PGK Waldkraib	
14071	70070024	Deutsche Bank PGK Gilching	
14072	70080000	Commerzbank Bad Tölz	
14073	70080000	Commerzbank Rottach-Egern	
14074	70080000	Commerzbank Landau Isar	
14075	70080000	Commerzbank Straubing	
14076	70080000	Commerzbank Donauwörth	
14077	70080000	Commerzbank Eggenfelden	
14078	70080000	Commerzbank Ottobrunn	
14079	70080000	Commerzbank Starnberg	
14080	70080000	Commerzbank Oberschleißhm	
14081	70080000	Commerzbank Geretsried	
14082	70080000	Commerzbank Passau	
14083	70080000	Commerzbank Fürstenfeldbr	
14084	70080000	Commerzbank Reichenhall	
14085	70080000	Commerzbank Traunstein	
14086	70080000	Commerzbank Gräfelfing	
14087	70080000	Commerzbank Freising	
14088	70080000	Commerzbank Dachau	
14089	70080000	Commerzbank Waldkraiburg	
14090	70080000	Commerzbank Günzburg	
14091	70080000	Commerzbank Unterhaching	
14092	70080000	Commerzbank Landsberg	
14093	70080000	Commerzbank Cham Oberpf	
14094	70080000	Commerzbank Grünwald	
14095	70080000	Commerzbank Füssen	
14096	70080000	Commerzbank Freilassing	
14097	70080000	Commerzbank	
14098	70080000	Commerzbank Altötting	
14099	70080000	Commerzbank Erding	
14100	70080000	Commerzbank Weilheim Obb	
14101	70080000	Commerzbank Germering	
14102	70090100	Hausbank München	
14103	70090500	Sparda-Bank München	
14121	70091500	VB Raiffbk Dachau	
14137	70091500	VR Raiffbk Dachau	
14139	70091600	VR-Bank Landsberg-Ammersee	
14152	70091900	VR-Bank Erding	
14158	70093200	VR-Bank Starnberg-Hg-Lbg	
14174	70093400	Vb Raiffbk Ismaning	
14177	70120700	Oberbank Rosenheim	
14178	70120700	Oberbank Landshut	
14179	70120700	Oberbank Passau	
14180	70120700	Oberbank Regensburg	
14181	70120700	Oberbank Nürnberg	
14182	70120700	Oberbank Ingolstadt	
14183	70120700	Oberbank Bayreuth	
14184	70120700	Oberbank Bamberg	
14185	70120700	Oberbank Aschaffenb.	
14186	70120700	Oberbank Würzburg	
14187	70120700	Oberbank Ottobrunn	
14188	70120700	Oberbank Unterschleißheim	
14189	70120700	Oberbank Germering	
14190	70120700	Oberbank Weiden	
14191	70120700	Oberbank Erlangen	
14192	70120700	Oberbank Augsburg	
14193	70120700	Oberbank Straubing	
14194	70120700	Oberbank Neumarkt	
14195	70120700	Oberbank Wolfratshausen	
14196	70120700	Oberbank Mühldorf/Inn	
14197	70120700	Oberbank Schweinfurt	
14198	70120700	Oberbank Freising	
14199	70120700	Oberbank Eggenfelden	
14200	70120900	UniCredit exHypo Ndl BACA	
14201	70163370	VR-Bank Fürstenfeldbruck	
14219	70166486	VR Bank München Land	
14236	70169132	Raiffbk Griesstätt-Halfing	
14240	70169165	Raiffbk Chiemgau-Nord-Obing	
14245	70169186	Raiffbk Pfaffenhofen Glonn	
14249	70169190	Raiffbk Tattenh Großkarol	
14250	70169191	Raiffbk Rupertiwinkel	
14254	70169195	Raiffbk Trostberg-Traunreut	
14263	70169310	Raiffeisenbank Alxing-Bruck	
14264	70169331	Raiffbk sö Starnberger See	
14271	70169333	Raiffbk Beuerberg-Eurasburg	
14272	70169351	Raiffbk Nordkreis Landsberg	
14277	70169356	Raiffeisenbank Erding	
14283	70169382	Raiffeisenbank Gilching	
14284	70169383	Raiffeisenbank Gmund am Teg	
14288	70169388	Raiffbk Haag-Gars-Maitenb	
14294	70169402	Raiffbk Höhenkirchen u U	
14299	70169410	Raiffbk Holzkirchen-Otterf	
14301	70169413	Raiffbk Singoldtal	
14304	70169450	Raiff-VB Ebersberg	
14314	70169459	Raiffeisenbank Mittenwald	
14315	70169460	Raiffbk Westkreis	
14320	70169464	Genossenschaftsbank	
14321	70169465	Raiffbk München-Nord	
14326	70169466	Raiffeisenbank München-Süd	
14330	70169472	Raiffbk Hallbergmoos-Neuf	
14332	70169474	Raiffbk NSV-NBK	
14333	70169493	Raiffbk Oberschleißheim	
14334	70169509	Raiffbk Pfaffenwinkel	
14346	70169521	Raiffeisenbank Raisting	
14347	70169524	Raiffeisenbank RSA	
14351	70169530	Raiffbk Neumarkt-Reischach	
14362	70169538	Raiffbk St. Wolfgang-Schwin	
14363	70169538	Raiffbk St Wolfgang-Schwind	
14364	70169541	Raiffbk Lech-Ammersee	
14371	70169543	Raiffbk Isar-Loisachtal	
14376	70169558	Raiffeisenbank Steingaden	
14383	70169566	VR-Bank Taufkirchen-Dorfen	
14393	70169568	Raiffbk Taufk-Oberneukirch	
14395	70169568	Raiffbk-Taufk-Oberneukirch	
14397	70169570	Raiffeisenbank Thalheim	
14398	70169571	Raiffbk Tölzer Land	
14404	70169575	Raiffeisenbank Türkheim	
14406	70169575	Raiffbk Tussenhausen-Zaiser	
14408	70169576	Raiff-Volksbank Tüßling	
14413	70169598	Raiffbk im Oberland	
14424	70169599	Raiffeisenbank Weil u Umgeb	
14425	70169602	Raiffeisenbank	
14426	70169602	Raiffeisenbank Weilheim	
14436	70169602	Raiffbk Weilhm u VB Bavaria	
14437	70169605	RVB Isen-Sempt	
14447	70169614	Freisinger Bank VB-Raiffbk	
14462	70169619	Raiffeisenbank Zorneding	
14465	70169653	Raiffeisenbank Aiglsbach	
14467	70169693	Raiffeisenbank Hallertau	
14474	70190000	Münchner Bank	
14488	70250150	Kr Spk München Starnbg Ebbg	
14514	70250150	Kreissparkasse	
14533	70320305	UniCredit exHypo Ndl635 Gar	
14534	70350000	Kr Spk Garmisch-Partenkirch	
14547	70362595	Raiffbk Wallgau-Krün	
14549	70390000	VR-Bank Werdenfels	
14579	70391800	VB-Raiffbk Penzberg	
14585	71050000	Spk Berchtesgadener Land	
14598	71052050	Kr Spk Traunstein-Trostberg	
14624	71061009	VR meine Raiffeisenbank	
14647	71062802	Raiffeisenbank Anger	
14648	71090000	VB RB Oberbayern Südost	
14669	71090000	VB RB  Oberbayern Südost	
14672	71090000	VR RB Oberbayern Südost	
14675	71150000	Spk Rosenheim-Bad Aibling	
14705	71151020	Spk Altötting-Mühldorf	
14731	71152570	Kr Spk Miesbach-Tegernsee	
14744	71152680	Kr u St Spk Wasserburg	
14760	71160000	VB RB Rosenheim-Chiemsee	
14805	71160161	VR Bank Rosenheim-Chiemsee	
14806	71161964	VB-Raiffbk Chiemsee -alt-	
14807	71162355	Raiffeisenbank Oberaudorf	
14810	71162804	Raiffbk Aschau-Samerberg	
14814	71191000	VR-Bank Burghausen-Mühldorf	
14821	72020240	UniCredit exHypo Ndl677Agsb	
14822	72030227	Bankhaus Anton Hafner	
14824	72040046	Commerzbank Königsbrunn	
14825	72040046	Commerzbank Gersthofen	
14826	72050101	Kr Spk Augsburg	
14854	72051210	Spk Aichach-Schrobenhausen	
14863	72051840	Spk Günzburg-Krumbach	
14879	72062152	VR-Bank HG-Bank	
14903	72069002	Raiffbk Adelzhausen-Sielenb	
14907	72069005	Raiffeisenbank Aindling	
14911	72069034	Raiffeisenbank Bissingen	
14912	72069036	Raiffeisenbank Bobingen	
14913	72069036	Raiffbk Bobingen	
14917	72069043	Raiff-VB Dillingen-Burgau	
14932	72069090	RB Bibertal-Kötz	
14933	72069105	Raiffeisenbank Hiltenfingen	
14935	72069113	Raiffeisenbank Aschberg	
14939	72069114	Raiffeisenbank Holzheim	
14941	72069119	Raiffeisenbank Ichenhausen	
14945	72069123	Raiffbk Jettingen-Schep	
14946	72069126	RB Bibertal-Kötz	
14948	72069132	Raiffbk Krumbach/Schwaben	
14957	72069135	Raiffbk Stauden Langenneufn	
14964	72069155	Raiffbk Kissing-Mering	
14972	72069179	Raiffbk Unteres Zusamtal	
14973	72069181	Raiffeisenbank Offingen	
14976	72069193	Raiffeisenbank Rehling	
14978	72069209	Raiffeisenbank Roggenburg	
14979	72069220	Raiffbk Schwabmünchen	
14984	72069235	Raiffeisenbank Thannhausen	
14987	72069263	Raiffeisenbank Wittislingen	
14990	72069274	Raiffbk Augsburger Ld West	
15001	72069308	RVB Wemding	
15008	72069329	Raiffeisen-Volksbank Ries	
15027	72069736	Raiffbk Iller-Roth-Günz	
15046	72069789	Raiffbk Pfaffenhausen	
15047	72070001	Deutsche Bank Donauwörth	
15048	72070024	Deutsche Bank PGK Donauwö	
15049	72080001	Commerzbank Gersthofen	
15050	72090000	Augusta-Bank RVB Augsburg	
15061	72091800	Volksbank Burgau	
15062	72091800	Volksbank Günzburg	
15066	72091800	Volksbank Ichenhausen	
15067	72091800	Volksbank Krumbach	
15068	72091800	VB Raiffbk Leipheim	
15069	72120079	UniCredit Bank-HypoVereinbk	
15070	72120207	UniCredit exHypo Ndl648 Ing	
15071	72150000	Sparkasse Ingolstadt	
15083	72151340	Sparkasse Eichstätt	
15093	72151650	Spk Pfaffenhofen	
15106	72151880	Spk Aichach-Schrobenhausen	
15113	72152070	Spk Neuburg-Rain	
15125	72160818	VR Bank Bayern Mitte	
15153	72169013	Raiffbk Aresing-Hörz-Schilt	
15154	72169080	Raiffbk Aresing-Gerolsbach	
15157	72169111	Raiffeisenbank Hohenwart	
15158	72169218	Schrobenhausener Bank	
15162	72169246	Raiffbk Schrobenhausener Ld	
15166	72169380	Raiffeisenbank Beilngries	
15168	72169745	Raiffbk Ehekirchen-Oberhsn	
15169	72169745	Raiffbk Ehekirchen-Weidorf	
15170	72169756	RV Neuburg/Donau	
15176	72169764	Raiffbk Donaumooser Land	
15182	72169812	Raiffbk Gaimersheim-Buxheim	
15189	72169831	Raiffbk Riedenburg-Lobs	
15194	72191300	Volksbank Eichstätt	
15207	72191600	Hallertauer Volksbank	
15224	72191800	Volksbank Schrobenhausen	
15225	72250000	Sparkasse Nördlingen	
15230	72250160	Spk Donauwörth	
15248	72251520	Kr u St Spk Dillingen	
15269	72261754	Raiffeisenbank Rain am Lech	
15275	72262401	Raiff-VB Dillingen	
15276	72290100	Raiff-VB Donauwörth	
15283	72290100	Raiff VB Donauwörth	
15297	73050000	Spk Illertissen	
15298	73050000	Spk Kellmünz Iller	
15299	73050000	Spk Nersingen	
15300	73050000	Spk Senden Iller	
15301	73050000	Spk Roggenburg Schwab	
15302	73050000	Spk Pfaffenhofen Roth	
15303	73050000	Spk Weißenhorn	
15304	73050000	Spk Altenstadt Iller	
15305	73050000	Spk Buch Illertissen	
15306	73050000	Spk Bellenberg	
15307	73050000	Spk Elchingen	
15308	73050000	Spk Vöhringen	
15309	73061191	VR-Bank Neu-Ulm/Weißenhorn	
15313	73090000	Raiffeisenbank Senden	
15314	73090000	VB Neu-Ulm Nersingen	
15315	73090000	Volksbank Neu-Ulm	
15316	73150000	Spk Memmingen-Lindau-Mindel	
15361	73160000	Genobank Unterallgäu	
15373	73190000	VR-Bank Memmingen	
15387	73311600	Hypo-Landesbk	
15388	73320442	UniCredit exHypo Ndl669 Kpt	
15389	73331700	Saliterbank Dietmannsried	
15390	73331700	Saliterbank Kempten Allgäu	
15391	73331700	Saliterbank Babenhausen Sch	
15392	73350000	Sparkasse Allgäu	
15430	73351840	Spk Dornbirn Riezlern	
15431	73361592	Walser Privatbank	
15434	73362421	Bankhaus Jungholz	
15435	73369264	Raiffbk im Allg Land	
15449	73369821	BodenseeBank	
15452	73369823	Raiffeisenbank Westallgäu	
15460	73369823	Raiffbk Westallgäu	
15462	73369826	Volksbank Lindenberg	
15468	73369851	Raiffbk Aitrang-Ruderatshfn	
15470	73369854	Raiffbk Fuchstal-Denklingen	
15473	73369859	Raiffeisenbank Bidingen	
15474	73369871	Raiffbk Baisweil-Eggent-Fr	
15477	73369878	Raiffbk Füssen-Pfronten-Nes	
15478	73369881	Raiffeisenbank Haldenwang	
15480	73369902	Raiffeisenbank Kempten	
15481	73369902	Raiffbk Kempten Betzigau	
15482	73369902	Raiffbk Kempten Buchenberg	
15483	73369902	Raiffbk Kempten Weitnau	
15484	73369902	Raiffbk Kempten Wiggensbach	
15485	73369902	Raiffbk Kempten Wildpoldsr	
15486	73369915	Raiffbk Obergermaringen	
15487	73369918	Raiffeisenbank Kirchweihtal	
15496	73369920	Raiffbk Kempten-Oberallgäu	
15514	73369933	Raiffbk Südliches Ostallgäu	
15521	73369954	Raiffbk Wald-Görisried	
15523	73370008	Deutsche Bank Geretsried	
15524	73370024	Deutsche Bank PGK Geretsrie	
15525	73390000	Allgäuer Volksbank	
15530	73391600	Volksbank Riezlern	
15531	73392000	Volksbank Waltenhofen	
15532	73392000	Volksbank Immenstadt	
15533	73420546	UniCredit exHypo Ndl693Kauf	
15534	73450000	Kr u St Spk Kaufbeuren	
15543	73451450	Kr Spk Schongau	
15556	73460046	VR Bk Kaufbeuren-Ostallgäu	
15578	74020414	UniCredit exHypo Ndl672Pass	
15579	74050000	Spk Passau	
15607	74051230	Spk Freyung-Grafenau	
15625	74061101	Raiffbk Am Goldenen Steig	
15632	74061564	Raiffbk Unteres Inntal	
15635	74061670	Raiffbk Ortenburg	
15637	74061813	VR-Bank Rottal-Inn	
15657	74062490	Raiffbk Vilshofener Land	
15664	74062786	Raiffbk i Lkr Passau-Nord	
15674	74064593	Raiffeisenbank Wegscheid	
15676	74065782	Raiffbk Salzweg-Thyrnau	
15680	74066749	Raiffbk i Südl Bay Wald	
15684	74067000	Rottaler Raiffbk	
15692	74069744	Raiffeisenbank Grainet	
15693	74069752	Raiffeisenbank Hohenau	
15694	74069758	Raiffbk Kirchberg	
15698	74069768	Raiffbk am Dreisessel	
15701	74090000	VR-Bank Passau	
15710	74092400	Volksbank Vilshofen	
15711	74092400	Volksbank Aidenbach	
15712	74092400	Volksbank Eging	
15713	74092400	Volksbank Griesbach	
15714	74092400	Volksbank Ortenburg	
15715	74092400	Volksbank Osterhofen	
15716	74092400	Volksbank Schöllnach	
15717	74120514	UniCredit exHypo Ndl674Dgdf	
15718	74150000	Spk Deggendorf	
15736	74151450	Sparkasse Regen-Viechtach	
15756	74160025	Raiffbk Deggendorf-Plattlg	
15770	74161608	Raiffbk Hengersb-Schöllnach	
15776	74164149	VR-Bank	
15790	74165013	Raiffeisenbank Sonnenwald	
15792	74165013	Raiffbk Sonnenwald	
15797	74190000	GenoBank DonauWald	
15814	74190000	GenoBk DonauWald Viechtach	
15815	74191000	VR-Bank Landau	
15825	74250000	Spk Niederbayern-Mitte	
15863	74251020	Spk im Landkreis Cham	
15893	74260110	Raiffeisenbank Straubing	
15895	74260110	Raiffbk Straubing	
15907	74261024	Raiffeisenbank Chamer Land	
15924	74290000	Volksbank Straubing	
15944	74320307	UniCredit exHypo Ndl601Ldsh	
15945	74350000	Spk Landshut	
15972	74351430	Spk Rottal-Inn Eggenfelden	
16000	74351740	St u Kr Spk Moosburg	
16007	74361211	Raiffeisenbank Arnstorf	
16012	74362663	Raiffbk Altdorf-Ergolding	
16018	74364689	Raiffbk Pfeffenhausen	
16024	74366666	Raiffeisenbank Geisenhausen	
16027	74369068	Raiffbk Hofkirchen-Bayerbch	
16029	74369088	Raiffbk Geiselhöring-Pfabg	
16033	74369130	Raiffeisenbank Parkstetten	
16037	74369146	Raiffbk Rattiszell-Konzell	
16044	74369656	Raiffeisenbank Essenbach	
16048	74369662	Raiffbk Buch-Eching	
16052	74369704	Raiffbk Mengkofen-Loiching	
16056	74369709	Raiffeisenbank Wildenberg	
16057	74390000	VR-Bank Landshut	
16062	74391300	VB-Raiffbk Dingolfing	
16067	74391400	Rottaler VB-Raiffbk Eggenf	
16077	74392300	VR-Bank Vilsbiburg	
16084	75020314	UniCredit exHypo Ndl670Rgsb	
16085	75050000	Spk Regensburg	
16119	75051040	Spk im Landkreis Schwandorf	
16137	75051565	Kreissparkasse Kelheim	
16158	75060150	Raiffbk Regensburg-Wenzenb	
16164	75061168	Raiffbk Schwandorf-Nittenau	
16173	75061851	Raiffeisenbank Regenstauf	
16174	75062026	Raiffbk Oberpfalz Süd	
16190	75062026	Raiffeisenbank Oberpfalz Sü	
16193	75069014	Raiffbk Bad Abbach-Saal	
16201	75069015	Raiffbk Bad Gögging	
16207	75069020	Raiffeisenbank Bruck	
16208	75069038	Raiffbk Falkenstein-Wörth	
16214	75069043	Raiffbk Furth -alt-	
16215	75069043	Raiffeisenbank Furth	
16218	75069050	Raiffbk Grafenwöhr-Kirchent	
16220	75069055	Raiffbk Alteglofshm-Hagelst	
16222	75069061	Raiffbk Hemau-Kallmünz	
16229	75069062	Raiffbk Herrnwahlth-Teu-Dün	
16231	75069062	Raiffbk Herrnwahlthann-alt-	
16232	75069076	Raiffeisenbank Kallmünz	
16233	75069078	Raiffeisenbank Sinzing	
16235	75069081	Raiffeisenbank Bad Kötzting	
16241	75069094	Raiffbk Parsberg-Velburg	
16246	75069110	Raiffbk Eschlkam-Neukirchen	
16247	75069110	RB Eschlk-Lam-Lohb-Neukirch	
16252	75069171	Raiffbk im Naabtal	
16265	75090000	Volksbank Regensburg	
16267	75090300	LIGA Bank	
16276	75090300	LIGA Bank Regensburg	
16277	75090500	Sparda-Bank Ostbayern	
16281	75091400	VR Bank Burglengenfeld	
16285	75240000	Commerzbank Sulzbach-Rosenb	
16286	75250000	Sparkasse Amberg-Sulzbach	
16303	75261700	Raiffbk Sulzbach-Rosenberg	
16307	75290000	VB-Raiffbk Amberg	
16316	75340090	Commerzbank Grafenwöhr	
16317	75350000	Spk Oberpfalz Nord	
16336	75351960	Ver Spk Eschenbach	
16361	75360011	Raiffeisenbank Weiden	
16376	75360011	Raiffeinsenbank Weiden	
16377	75362039	Raiffeisenbank Floß	
16379	75363189	Raiffbk Neustadt-Vohenstr	
16389	75390000	Volksbank Nordoberpfalz	
16399	76020214	UniCredit exHypo Ndl156 Nbg	
16400	76026000	norisbank	
16456	76026000	norisbank Berlin	
16457	76040061	Commerzbank	
16458	76040061	Commerzbank Lauf Pegnitz	
16459	76040061	Commerzbank Ansbach	
16460	76040061	Commerzbank Nördlingen	
16461	76040061	Commerzbank Forchheim	
16462	76040061	Commerzbank Rothenburg	
16463	76040061	Commerzbank Neumarkt	
16464	76040061	Commerzbank Roth	
16465	76052080	Spk Neumarkt i d OPf-Parsbg	
16483	76060561	ACREDOBANK Schwerin	
16484	76060561	ACREDOBANK München	
16485	76060561	ACREDOBANK Nürnberg	
16486	76060618	VR Bank Nürnberg	
16491	76061025	Raiffbk Spar+Kreditbk Lauf	
16499	76061482	Raiffeisenbank Hersbruck	
16511	76069369	Raiffbk Auerbach-Freihung	
16518	76069372	Raiffbk Bad Windsheim	
16525	76069378	Raiffeisenbank Bechhofen	
16526	76069404	Raiffbk Uehlfeld-Dachsbach	
16530	76069409	Raiffeisenbank Dietenhofen	
16531	76069410	Raiffeisenbank Dietersheim	
16533	76069440	Raiffbk Altdorf-Feucht	
16539	76069441	VR-Bank Feuchtwangen-Limes	
16547	76069449	Raiffbk Berch-Freyst-Mühlh	
16550	76069462	Raiffbk Greding-Thalmässing	
16551	76069468	Raiffbk Weißenburg-Gunzenh	
16575	76069483	Raiffbk Herzogenaurach	
16576	76069486	Raiffbk Hirschau	
16579	76069512	Raiffbk Knoblauchsland	
16580	76069553	Raiffeisenbank Neumarkt	
16587	76069559	Raiffeisenbk Münchaurach	
16589	76069559	VR-Bank Uffenheim-Neustadt	
16610	76069564	Raiffbk Oberferrieden-Burgt	
16612	76069576	Raiffeisenbank Plankstetten	
16614	76069598	Raiffeisenbank Roßtal	
16617	76069601	VR-Bank Rothenburg	
16629	76069602	Raiffbk Seebachgrund-Heßdf	
16634	76069611	Raiffbk Unteres Vilstal	
16639	76069663	Raiffbk Heilsbr-Windsbach	
16646	76069669	Raiffeisenbank Zirndorf	
16649	76070012	Deutsche Bank Neustadt Cobu	
16650	76070024	Deutsche Bank PGK Neustadt	
16651	76080040	Commerzbank Nördlingen	
16652	76080040	Commerzbank Forchheim	
16653	76080040	Commerzbank Bayreuth	
16654	76080040	Commerzbank Bamberg	
16655	76080040	Commerzbank Erlangen	
16656	76080040	Commerzbank Fürth Bay	
16657	76080040	Commerzbank Kulmbach	
16658	76080040	Commerzbank Hof Saale	
16659	76080040	Commerzbank Schwabach	
16660	76080040	Commerzbank Selb	
16661	76080040	Commerzbank Rothenburg	
16662	76080040	Commerzbank Weiden Oberpf	
16663	76080040	Commerzbank Neumarkt	
16664	76080040	Commerzbank Coburg	
16665	76080040	Commerzbank Amberg Oberpf	
16666	76080040	Commerzbank Lauf Pegnitz	
16667	76080040	Commerzbank Marktredwitz	
16668	76080040	Commerzbank Roth	
16669	76080040	Commerzbank Ansbach	
16670	76090400	Evenord-Bank Nürnberg	
16671	76090400	Evenord-Bank Fürth, Bay	
16672	76090500	Sparda-Bank Nürnberg	
16679	76240011	Commerzbank Zirndorf	
16680	76251020	Spk i Landkreis Neustadt	
16703	76260451	Raiffeisen-Volksbank Fürth	
16710	76350000	St u Kr Spk Erlangen	
16721	76351040	Sparkasse Forchheim	
16746	76351560	Kr Spk Höchstadt	
16759	76360033	VR-Bank EHH	
16766	76391000	Raiffeisenbank Eggolsheim	
16767	76391000	VB Forchheim	
16769	76391000	Volksbank Forchheim	
16773	76450000	Spk Mittelfranken-Süd	
16797	76460015	Raiffbk Roth-Schwabach	
16806	76461485	Raiffbk am Rothsee	
16809	76550000	Ver Spk Ansbach	
16839	76551020	Kr u St Spk Dinkelsbühl	
16844	76551540	Ver Spk Gunzenhausen	
16858	76551860	St u Kr Spk Rothenburg	
16864	76560060	RaiffVB Ansbach	
16887	76591000	VR Bank Dinkelsbühl	
16900	77050000	Spk Bamberg	
16929	77060100	VR Bank Bamberg	
16954	77061004	Raiffbk Obermain Nord	
16964	77061425	Raiffeisen-Volksbank Ebern	
16973	77062014	RB Burgebrach-Stegaurach	
16981	77062139	Raiff-VB Bad Staffelstein	
16984	77065141	Raiffeisenbank Stegaurach	
16987	77069044	Raiffbk Küps-Mitwitz-Stockh	
16991	77069051	Raiffbk Heiligenstadt	
16992	77069052	Raiffeisenbank Heroldsbach	
16993	77069091	Raiffeisenbank Ebrachgrund	
16998	77069461	Vereinigte Raiffeisenbanken	
17011	77069556	Raiffbk Neunkirchen Brand	
17015	77069739	Raiffbk Thurnauer Land	
17018	77069746	Raiffbk Emtmannsberg	
17019	77069764	Raiffbk Kemnather Land	
17029	77069782	Raiffeisenbank am Kulm	
17031	77069836	Raiffbk Berg-Bad Steben	
17037	77069868	Raiffeisenbank Oberland	
17041	77069870	Raiffbk Hochfranken West	
17050	77069906	Raiffbk Wüstenselbitz	
17051	77069908	Raiffbk Sparn-Stammb-Zell	
17052	77091800	Raiff-VB Lichtenfels-Itzgrd	
17059	77150000	Spk Kulmbach-Kronach	
17091	77190000	Kulmbacher Bank	
17105	77340076	Commerzbank Pegnitz	
17106	77340076	Commerzbank Auerbach	
17107	77340076	Commerzbank Bad Berneck	
17108	77340076	Commerzbank Weidenberg	
17109	77350110	Sparkasse Bayreuth	
17130	77361600	Raiff-VB Kronach-Ludwigssta	
17142	77363749	Raiffeisenbank Gefrees	
17146	77365792	Raiffbk Hollfeld-Waischenfd	
17150	77390000	VB-Raiffbk Bayreuth	
17157	77390000	VB Raiffbk Bayreuth	
17168	78020429	UniCredit exHypo Ndl128 Hof	
17169	78040081	Commerzbank Rehau	
17170	78040081	Commerzbank Schwarzenbach	
17171	78040081	Commerzbank Naila	
17172	78040081	Commerzbank Selb	
17173	78040081	Commerzbank Münchberg	
17174	78040081	Commerzbank Helmbrechts	
17175	78040081	Commerzbank Schwarzenb/Wald	
17176	78040081	Commerzbank Bad Steben	
17177	78040081	Commerzbank Selbitz	
17178	78050000	Spk Hochfranken	
17217	78060896	VR Bank Hof	
17241	78140000	Commerzbank Roding	
17242	78140000	Commerzbank Viechtach	
17243	78140000	Commerzbank Rötz	
17244	78140000	Commerzbank Cham	
17245	78140000	Commerzbank Furth im Wald	
17246	78140000	Commerzbank Kötzting	
17247	78140000	Commerzbank Waldmünchen	
17248	78140000	Commerzbank Lam	
17249	78140000	Commerzbank Oberviechtach	
17250	78140000	Commerzbank Neunburg	
17251	78140000	Commerzbank Nabburg	
17252	78140000	Commerzbank Burglengenfeld	
17253	78140000	Commerzbank Nittenau	
17254	78140000	Commerzbank Schwandorf	
17255	78140000	Commerzbank Marktredwitz	
17256	78140000	Commerzbank Wunsiedel	
17257	78140000	Commerzbank Waldsassen	
17258	78140000	Commerzbank Arzberg	
17259	78140000	Commerzbank Mitterteich	
17260	78160069	VR-Bank Fichtelgebirge	
17272	78161575	Raiffbk im Stiftland Walds	
17283	78340091	Commerzbank Sonneberg Thür	
17284	78350000	Spk Coburg-Lichtenfels	
17308	78360000	VR-Bank Coburg	
17327	79020325	UniCredit exHypo Ndl149 Wzb	
17328	79030001	Fürstl. Castellsche Bank	
17343	79032038	Bank Schilling Bad Neustadt	
17344	79032038	Bk Schilling Bad Brückenau	
17345	79032038	Bk Schilling Bad Kissingen	
17346	79032038	Bank Schilling Würzburg	
17347	79032038	Bank Schilling Fulda	
17348	79032038	Bank Schilling Schweinfurt	
17349	79032038	Bank Schilling Aschaffenbg	
17350	79032038	Bank Schilling Meiningen	
17351	79032038	Bk Schilling Bad Salzungen	
17352	79032038	Bank Schilling Darmstadt	
17353	79032038	Bank Schilling Frankfurt	
17354	79032038	Bank Schilling Bamberg	
17355	79032038	Bank Schilling Wiesbaden	
17356	79032038	Bank Schilling Gelnhausen	
17357	79040047	Commerzbank Wertheim	
17358	79040047	Commerzbank Kitzingen	
17359	79050000	Spk Mainfranken	
17453	79061000	Raiffeisenbank Ochsenfurt	
17463	79061153	Raiffeisenbank Lohr -alt-	
17464	79062106	Raiffbk Hammelburg	
17470	79063060	Raiffbk Estenfeld-Bergtheim	
17476	79063122	Raiffeisenbank Höchberg	
17487	79065028	VR-Bank Bad Kissingen	
17506	79065160	Raiffbk Marktheidenfeld alt	
17507	79066082	Raiffeisenbank Altertheim	
17508	79069001	Raiffbk Volkach-Wiesentheid	
17518	79069010	VR-Bank Schweinfurt	
17543	79069031	Raiffbk Bütthard-Gaukönigsh	
17548	79069150	Raiffbk Main-Spessart	
17582	79069165	Genobank Rhön-Grabfeld	
17593	79069181	Raiffeisenbank Nüdlingen	
17594	79069188	Raiffeisenbank im Grabfeld	
17595	79069213	Raiffeisenbank Maßbach	
17600	79069271	Raiffbk Thüngersheim	
17601	79080052	Commerzbank Kitzingen	
17602	79080052	Commerzbank Wertheim	
17603	79090000	VR-Bank Würzburg	
17613	79090000	VB Raiffbk Würzburg	
17628	79161058	Raiffbk Fränkisches Weinla	
17632	79161499	Raiffbk Kitzinger Land	
17639	79190000	VR Bank Kitzingen	
17650	79320432	UniCredit exHypo Ndl137Schf	
17651	79330111	Flessabank Ebern	
17652	79330111	Flessabank Gerolzhofen	
17653	79330111	Flessabank Elfershausen	
17654	79330111	Flessabank Eltmann	
17655	79330111	Flessabank Bad Neustadt	
17656	79330111	Flessabank Haßfurt	
17657	79330111	Flessabank Schonungen	
17658	79330111	Flessabank Ebelsbach	
17659	79330111	Flessabank Hammelburg	
17660	79330111	Flessabank Gochsheim	
17661	79330111	Flessabank Niederwerrn	
17662	79330111	Flessabank Bad Kissingen	
17663	79330111	Flessabank Bergrheinfeld	
17664	79330111	Bankhaus Max Flessa	
17676	79340054	Commerzbank Bad Kissingen	
17677	79350101	Sparkasse Schweinfurt	
17702	79351010	Spk Bad Kissingen	
17714	79351730	Spk Ostunterfranken	
17731	79353090	Spk Bad Neustadt a d Saale	
17749	79362081	VR-Bank Gerolzhofen	
17755	79363016	VR-Bank Rhön-Grabfeld	
17770	79363151	Raiff-VB Haßberge	
17784	79364069	Raiffbk Frankenwinheim uU	
17785	79364069	Raiffbank Frankenwinheim UU	
17787	79364406	VR-Bank Schweinfurt Land	
17804	79380051	Commerzbank Bad Kissingen	
17805	79520533	UniCredit exHypo Ndl125Asch	
17806	79550000	Spk Aschaffenburg Alzenau	
17838	79561348	Raiffeisenbank Bachgau	
17839	79562514	Raiffbk Aschaffenburg	
17848	79565568	Raiffeisenbank Waldaschaff	
17854	79567531	VR-Bank	
17860	79568518	Raiffbk Haibach-Obernau	
17863	79590000	VB Aschaffenbg Stockstadt	
17864	79590000	VB Aschaffenbg Hösbach	
17865	79590000	Volksbank Aschaffenburg	
17866	79590000	VB Aschaffenbg Großostheim	
17867	79650000	Spk Miltenberg-Obernburg	
17896	79662558	Raiffbk Schöllkrippen	
17897	79665540	Raiffbk Elsavatal	
17900	79666548	Raiffbk Großostheim-Obernbg	
17913	79668509	Raiffbk Eichenbühl u U	
17915	79690000	Raiff-VB Miltenberg	
17917	79690000	Raiff-Volksbank Miltenberg	
17934	79690000	Raiff-VB	
17938	80040000	Commerzbank Merseburg	
17939	80040000	Commerzbank Zeitz	
17940	80040000	Commerzbank Bernburg	
17941	80040000	Commerzbank Naumburg	
17942	80040000	Commerzbank Köthen	
17943	80040000	Commerzbank Hettstedt	
17944	80040000	Commerzbank Weißenfels	
17945	80040000	Commerzbank Eisleben	
17946	80040000	Commerzbank Zerbst	
17947	80040000	Commerzbank Sangerhausen	
17948	80062608	Volksbank Elsterland	
17949	80063508	Ostharzer Volksbank	
17950	80063558	Volksbank Sangerhausen	
17951	80063598	Volksbank Wittenberg	
17952	80063628	Volksbank Bitterfeld	
17953	80063628	Volksbank Quellendorf	
17954	80063628	Volksbank Zörbig	
17955	80063628	Volksbank Raguhn	
17956	80063628	Volksbank Sandersdorf	
17957	80063628	Volksbank Aken	
17958	80063628	Volksbank Köthen	
17959	80063648	Volks-Raiffbk Saale-Unstrut	
17962	80063678	VR-Bank Zeitz	
17963	80063718	V- u Raiffbk Eisleben	
17964	80080000	Commerzbank Bernburg	
17965	80080000	Commerzbank Halberstadt	
17966	80080000	Commerzbank Quedlinburg	
17967	80080000	Commerzbank Wernigerode	
17968	80080000	Commerzbank Aschersleben	
17969	80080000	Commerzbank Dessau	
17970	80080000	Commerzbank Hettstedt	
17971	80080000	Commerzbank Weißenfels	
17972	80080000	Commerzbank Eisleben	
17973	80080000	Commerzbank Zerbst	
17974	80080000	Commerzbank Köthen	
17975	80080000	Commerzbank Merseburg	
17976	80080000	Commerzbank Naumburg	
17977	80080000	Commerzbank Sangerhausen	
17978	80080000	Commerzbank Wittenberg	
17979	80093574	VB Dessau-Anhalt Zerbst	
17980	80093574	VB Dessau-Anhalt Aken	
17981	80093574	VB Dessau-Anhalt Coswig	
17982	80093574	VB Dessau-Anhalt Gossa	
17983	80093574	VB De-Anh Gräfenhainichen	
17984	80093574	VB Dessau-Anh Oranienbaum	
17985	80093574	VB Dessau-Anhalt Gommern	
17986	80093574	VB Dessau-Anhalt Möckern	
17987	80093574	VB Dessau-Anhalt Güterglück	
17988	80093574	VB Dessau-Anhalt Deetz	
17989	80093574	Volksbank Dessau-Anhalt	
17990	80093784	VB Halle, Saale	
17991	80550101	Spk Wittenberg Gräfenh	
17992	81040000	Commerzbank Aschersleben	
17993	81040000	Commerzbank Dessau	
17994	81040000	Commerzbank Halberstadt	
17995	81040000	Commerzbank Quedlinburg	
17996	81040000	Commerzbank Stendal	
17997	81040000	Commerzbank Wernigerode	
17998	81040000	Commerzbank Wittenberg Luth	
17999	81040000	Commerzbank Burg Magdeburg	
18000	81040000	Commerzbank Schönebeck Elbe	
18001	81040000	Commerzbank Haldensleben	
18002	81050000	KSK ASL-SFT Staßfurt -alt-	
18003	81050555	Kreissparkasse Stendal	
18014	81054000	Sparkasse Jerichower Land	
18015	81063028	Raiffbk Kalbe-Bismark	
18017	81063238	VB Jerichower Land	
18018	81069048	Volksbank Genthin	
18019	81069052	Volksbank Börde-Bernburg	
18020	81080000	Commerzbank Haldensleben	
18021	81093034	Volksbank Gardelegen	
18022	81093054	Volksbank Stendal	
18023	81093274	VB Magdeburg	
18028	82040000	Commerzbank Eisenach	
18029	82040000	Commerzbank Gotha	
18030	82040000	Commerzbank Ilmenau	
18031	82040000	Commerzbank Jena	
18032	82040000	Commerzbank Mühlhausen	
18033	82040000	Commerzbank Nordhausen	
18034	82040000	Commerzbank Saalfeld	
18035	82040000	Commerzbank	
18036	82040000	Commerzbank Weimar	
18037	82040000	Commerzbank Arnstadt	
18038	82040000	Commerzbank Rudolstadt	
18039	82040000	Commerzbank Heiligenstadt	
18040	82040000	Commerzbank Apolda	
18041	82040000	Commerzbank Hildburghausen	
18042	82040000	Commerzbank Sömmerda	
18043	82051000	Spk Mittelthüringen	
18061	82052020	Kr Spk Gotha	
18073	82054052	Kr Spk Nordhausen	
18076	82055000	Kyffhäuser Spk Sondershsn	
18082	82056060	Spk Unstrut-Hainich	
18083	82064038	VR Bank Westthüringen	
18098	82064088	VB u Raiffbk Eisenach	
18099	82064168	Raiffeisenbank Gotha	
18105	82064188	VR Bank Weimar	
18115	82064228	Erfurter Bank	
18121	82080000	Commerzbank Eisenach	
18122	82080000	Commerzbank Erfurt	
18123	82080000	Commerzbank Gotha	
18124	82080000	Commerzbank Mühlhausen	
18125	82080000	Commerzbank Nordhausen	
18126	82080000	Commerzbank Schleiz	
18127	82080000	Commerzbank Jena	
18128	82080000	Commerzbank Arnstadt	
18129	82080000	Commerzbank Heiligenstadt	
18130	82080000	Commerzbank Hildburghsn	
18131	82080000	Commerzbank Neuhaus Rennw	
18132	82080000	Commerzbank Ilmenau	
18133	82080000	Commerzbank Rudolstadt	
18134	82080000	Commerzbank Sömmerda	
18135	82094004	Volksbank Heiligenstadt	
18139	82094054	Nordthüringer Volksbank	
18162	83040000	Commerzbank Greiz	
18163	83040000	Commerzbank Hermsdorf Thür	
18164	83040000	Commerzbank Lobenstein	
18165	83040000	Commerzbank Schleiz	
18166	83040000	Commerzbank Zeulenroda	
18167	83050000	Spk Gera-Greiz	
18179	83050200	Spk Altenburger Land	
18186	83050303	Kr Spk Saalfeld-Rudolstadt	
18201	83050505	Kr Spk Saale-Orla	
18218	83053030	Spk Jena-Saale-Holzland	
18231	83064488	RVB Hermsdorfer Kreuz	
18232	83064488	Raiffbk-VB Hermsdorf	
18235	83064568	Geraer Bank	
18242	83065408	VR-Bank ABG-Land / Skatbank	
18253	83094444	Raiff-VB Saale-Orla	
18265	83094454	Volksbank Saaletal	
18281	83094494	Volksbank Eisenberg	
18286	84050000	Rhön-Rennsteig-Sparkasse	
18305	84051010	Sparkasse Arnstadt-Ilmenau	
18324	84054040	Kr Spk Hildburghausen	
18335	84054722	Sparkasse Sonneberg	
18342	84055050	Wartburg-Sparkasse	
18366	84069065	Raiffeisenbank Schleusingen	
18367	84080000	Commerzbank Sonneberg	
18368	84080000	Commerzbank Suhl	
18369	84094754	VR-Bank Salzungen Schmal	
18370	84094754	VR-Bank Bad Salzungen	
18386	84094814	VR Bank Südthüringen	
18395	84094814	vr bank Südthüringen	
18400	85020890	UniCredit exHypo Ndl536 Dre	
18401	85040000	Commerzbank Bautzen	
18402	85040000	Commerzbank Görlitz	
18403	85040000	Commerzbank Hoyerswerda	
18404	85040000	Commerzbank Meißen	
18405	85040000	Commerzbank Radebeul	
18406	85040000	Commerzbank Riesa	
18407	85040000	Commerzbank Pirna	
18408	85040000	Commerzbank Löbau	
18409	85040000	Commerzbank Bischofswerda	
18410	85040000	Commerzbank Eilenburg	
18411	85040000	Commerzbank Oschatz	
18412	85040000	Commerzbank Zittau	
18413	85040000	Commerzbank Neustadt Sachs	
18414	85050100	Spk Oberlausitz-Niederschl.	
18442	85050300	Ostsächsische Spk Dresden	
18481	85055000	Spk Meißen	
18490	85060000	VB Pirna	
18499	85065028	Raiffbk Neustadt Sachs	
18500	85080000	Commerzbank Meißen	
18501	85080000	Commerzbank Löbau	
18502	85080000	Commerzbank Bischofswerda	
18503	85080000	Commerzbank Eilenburg	
18504	85080000	Commerzbank Oschatz	
18505	85080000	Commerzbank Döbeln	
18506	85080000	Commerzbank Bautzen	
18507	85080000	Commerzbank Freiberg	
18508	85080000	Commerzbank Görlitz	
18509	85080000	Commerzbank Pirna	
18510	85080000	Commerzbank Riesa	
18511	85080000	Commerzbank Zittau	
18512	85080000	Commerzbank Radebeul	
18513	85080000	Commerzbk Neustadt Sachs	
18514	85090000	Dresdner VB Raiffbk	
18515	85094984	Volksbank Riesa	
18525	85095004	VB Raiffbk Meißen Großenh	
18527	85095164	LKG Dresden -alt-	
18528	85550000	Kreissparkasse Bautzen	
18545	85590000	Volksbank Bautzen	
18562	85590100	VB Löbau-Zittau	
18575	85591000	VB Raiffbk Niederschlesien	
18590	86020500	Bank für Sozialwirtschaft	
18591	86020880	UniCredit exHypo Ndl508 Lei	
18592	86040000	Commerzbank Altenburg	
18593	86040000	Commerzbank Borna	
18594	86040000	Commerzbank Delitzsch	
18595	86040000	Commerzbank Bitterfeld	
18596	86040000	Commerzbank Döbeln	
18597	86040000	Commerzbank Torgau	
18598	86050200	Spk Muldental	
18607	86050600	Kr Spk Torgau-Oschatz -alt-	
18608	86055002	Spk Delitzsch-Eilenburg	
18609	86055462	Kr Spk Döbeln	
18614	86065448	VR Bank Leipziger Land	
18615	86065468	VR-Bank Mittelsachsen	
18616	86065483	Raiffeisenbank Grimma	
18617	86069070	Raiffeisenbank Torgau	
18622	86080000	Commerzbank Delitzsch	
18623	86080000	Commerzbank Altenburg	
18624	86080000	Commerzbank Borna	
18625	86080000	Commerzbank Zeitz	
18626	86095484	VR-Bank Muldental Grimma	
18633	86095554	Volksbank Delitzsch Eilenbg	
18634	86095554	Volksbank Delitzsch	
18635	86095604	Leipziger Volksbank	
18636	87040000	Commerzbank Freiberg, Sachs	
18637	87040000	Commerzbank Plauen	
18638	87040000	Commerzbank Zwickau	
18639	87040000	Commerzbank Annabg-Buchholz	
18640	87040000	Commerzbank Glauchau	
18641	87040000	Commerzbank Mittweida	
18642	87040000	Commerzbank Weischlitz	
18643	87040000	Commerzbank Limbach-Oberf	
18644	87040000	Commerzbank Kirchberg	
18645	87040000	Commerzbank Falkenstein	
18646	87040000	Commerzbank Aue, Sachs	
18647	87040000	Commerzbank Schwarzenberg	
18648	87040000	Commerzbank Reichenbach	
18649	87040000	Commerzbank Oelsnitz	
18650	87040000	Commerzbank Meerane	
18651	87040000	Commerzbank Crimmitschau	
18652	87040000	Commerzbank Stollberg	
18653	87040000	Commerzbank Marienberg	
18654	87040000	Commerzbank Werdau	
18655	87040000	Commerzbank Zschopau	
18656	87040000	Commerzbank Rochlitz	
18657	87040000	Commerzbank Flöha	
18658	87040000	Commerzbank Auerbach Vogtl	
18659	87040000	Commerzbank Hohenst-Ernstth	
18660	87050000	Sparkasse Chemnitz	
18667	87051000	Spk Mittelsachsen	
18680	87052000	Spk Mittelsachsen	
18698	87054000	Erzgebirgssparkasse	
18759	87055000	Sparkasse Zwickau	
18772	87056000	Kr Spk Aue-Schwarzenberg	
18778	87058000	Sparkasse Vogtland	
18813	87069075	VB Mittl Erzgebirge	
18828	87069077	Ver Raiffbk Burgstädt	
18834	87070000	Deutsche Bank Bahratal	
18835	87070000	Deutsche Bank Seifhennersdf	
18836	87070024	Deutsche Bank PGK Bahratal	
18837	87070024	Deutsche Bank PGK Seifhenne	
18838	87080000	Commerzbank Plauen	
18839	87080000	Commerzbank Zschopau	
18840	87080000	Commerzbank Rochlitz	
18841	87080000	Commerzbank Zwickau	
18842	87080000	Commerzbank Flöha	
18843	87080000	Commerzbank Aue Sachs	
18844	87080000	Commerzbk Auerbach Vogtl	
18845	87080000	Commerzbk Hohenst-Ernstth	
18846	87095824	Volksbank Vogtland	
18859	87095824	VB Vogtland	
18863	87095934	Volksbank Zwickau	
18867	87095974	VB-RB Glauchau	
18874	87096034	VB Erzgebirge	
18875	87096074	Freiberger Bank	
18876	87096124	Volksbank Mittweida	
18885	87096214	Volksbank Chemnitz	
\.


--
-- Data for Name: billings; Type: TABLE DATA; Schema: public; Owner: root
--

COPY billings (id, idtrial, creation_date, start_date, end_date, comment, visit_ids, amount, visit_ids_travel_costs) FROM stdin;
208	25	2014-11-03 00:00:00	2015-02-04 00:00:00	2014-11-05 00:00:00	699.72 EUR	3782, 	699.720000000000027	\N
\.


--
-- Name: billings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('billings_id_seq', 208, true);


--
-- Data for Name: group_assignments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY group_assignments (id, idgroup, idpersonnel) FROM stdin;
1	1	1
100	19	36
101	1	37
\.


--
-- Name: group_assignments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('group_assignments_id_seq', 101, true);


--
-- Data for Name: groups_catalogue; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY groups_catalogue (id, name, sprechstunde, websitename, telephone) FROM stdin;
19	Other group	\N	\N	\N
1	Team1	HH-Studien	<a href="http://"</a>	xxx
\.


--
-- Name: groups_catalogue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('groups_catalogue_id_seq', 19, true);


--
-- Data for Name: patient_visits; Type: TABLE DATA; Schema: public; Owner: root
--

COPY patient_visits (id, idpatient, idvisit, visit_date, state, travel_costs, date_reimbursed, travel_comment, travel_additional_costs, actual_costs) FROM stdin;
3784	608	6	\N	\N	\N	\N	\N	\N	\N
3785	608	9	\N	\N	\N	\N	\N	\N	\N
3786	608	10	\N	\N	\N	\N	\N	\N	\N
3787	609	\N	2014-11-05 00:00:00	\N	\N	\N	\N	\N	\N
3788	610	7	2014-11-17 00:00:00	\N	\N	\N	\N	\N	\N
3789	610	5	\N	\N	\N	\N	\N	\N	\N
3790	610	6	\N	\N	\N	\N	\N	\N	\N
3791	610	9	\N	\N	\N	\N	\N	\N	\N
3792	610	10	\N	\N	\N	\N	\N	\N	\N
3793	611	7	2014-11-17 00:00:00	\N	\N	\N	\N	\N	\N
3794	611	5	\N	\N	\N	\N	\N	\N	\N
3795	611	6	\N	\N	\N	\N	\N	\N	\N
3796	611	9	\N	\N	\N	\N	\N	\N	\N
3797	611	10	\N	\N	\N	\N	\N	\N	\N
3798	612	7	2014-11-17 00:00:00	\N	\N	\N	\N	\N	\N
3800	612	6	\N	\N	\N	\N	\N	\N	\N
3801	612	9	\N	\N	\N	\N	\N	\N	\N
3802	612	10	\N	\N	\N	\N	\N	\N	\N
3803	613	7	2014-11-17 00:00:00	\N	\N	\N	\N	\N	\N
3804	613	5	\N	\N	\N	\N	\N	\N	\N
3805	613	6	\N	\N	\N	\N	\N	\N	\N
3806	613	9	\N	\N	\N	\N	\N	\N	\N
3807	613	10	\N	\N	\N	\N	\N	\N	\N
3808	614	7	2014-11-17 00:00:00	\N	\N	\N	\N	\N	\N
3809	614	5	\N	\N	\N	\N	\N	\N	\N
3810	614	6	\N	\N	\N	\N	\N	\N	\N
3811	614	9	\N	\N	\N	\N	\N	\N	\N
3812	614	10	\N	\N	\N	\N	\N	\N	\N
3799	612	5	2014-11-18 00:00:00	\N	\N	\N	\N	\N	\N
3782	608	7	2014-11-13 00:00:00	\N	\N	\N	\N	\N	0
3783	608	5	2014-11-28 00:00:00	\N	\N	\N	\N	\N	0
\.


--
-- Name: patient_visits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('patient_visits_id_seq', 3812, true);


--
-- Data for Name: patients; Type: TABLE DATA; Schema: public; Owner: root
--

COPY patients (id, idtrial, piz, code1, code2, comment, state, name, givenname, birthdate, street, zip, town, telephone, insertion_date, female, iban, bic, bank, travel_distance) FROM stdin;
609	197	\N	\N	\N	\N	\N	xxx	\N	\N	\N	\N	\N	\N	2014-11-17	\N	\N	\N	\N	\N
610	25	2	\N	\N	\N	\N	test2	\N	\N	\N	\N	\N	\N	2014-11-17	\N	\N	\N	\N	\N
611	25	3	\N	\N	\N	\N	test3	\N	\N	\N	\N	\N	\N	2014-11-17	\N	\N	\N	\N	\N
612	25	4	\N	\N	\N	\N	test43	\N	\N	\N	\N	\N	\N	2014-11-17	\N	\N	\N	\N	\N
613	25	5	\N	\N	\N	\N	test5	\N	\N	\N	\N	\N	\N	2014-11-17	\N	\N	\N	\N	\N
614	25	6	\N	\N	\N	\N	test6	\N	\N	\N	\N	\N	\N	2014-11-17	\N	\N	\N	\N	\N
608	25	1	\N	\N	\N	\N	Test	\N	\N	\N	\N	\N	\N	2014-11-13	\N	\N	\N	\N	10
\.


--
-- Name: patients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('patients_id_seq', 614, true);


--
-- Data for Name: personnel_catalogue; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY personnel_catalogue (id, name, ldap, email, function, tel, level, abrechnungsname) FROM stdin;
36	Mickey Mouse	mm	\N	\N	\N	\N	\N
37	Icaljoe	ics	\N	\N	\N	\N	\N
1	I am the PI	pi	my.email@xx.com	Pruefarzt	\N	3	\N
\.


--
-- Name: personnel_catalogue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('personnel_catalogue_id_seq', 37, true);


--
-- Data for Name: personnel_costs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY personnel_costs (id, date_active, idpersonnel, idaccount, amount, comment) FROM stdin;
\.


--
-- Name: personnel_costs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('personnel_costs_id_seq', 20, true);


--
-- Data for Name: personnel_event; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY personnel_event (id, idpersonnel, type, start_time, end_time, comment) FROM stdin;
2	37	1	2014-11-18 16:22:23.27589	2014-11-19 00:00:00	test
1	1	1	2014-11-17 00:00:00	2014-11-18 00:00:00	coimbra
\.


--
-- Data for Name: personnel_event_catalogue; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY personnel_event_catalogue (id, description) FROM stdin;
2	Schulung
1	Urlaub
\.


--
-- Name: personnel_event_catalogue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('personnel_event_catalogue_id_seq', 2, true);


--
-- Name: personnel_event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('personnel_event_id_seq', 2, true);


--
-- Data for Name: personnel_properties; Type: TABLE DATA; Schema: public; Owner: root
--

COPY personnel_properties (id, propertydate, idpersonnel, idproperty, value) FROM stdin;
121	\N	36	1	\N
122	\N	36	4	\N
123	\N	36	2	\N
124	\N	36	5	\N
125	\N	37	1	\N
126	\N	37	4	\N
127	\N	37	5	\N
128	\N	37	2	\N
\.


--
-- Data for Name: personnel_properties_catalogue; Type: TABLE DATA; Schema: public; Owner: root
--

COPY personnel_properties_catalogue (id, type, name, expires, ordering) FROM stdin;
1	1	GCP Training	2 years	1
2	1	MPG Training	2 years	2
4	1	Vertragslaufzeit	\N	3
5	1	Ausbildung	\N	\N
8	\N	ICAL_Abwesend	\N	\N
9	\N	ICAL_Info	\N	\N
\.


--
-- Name: personnel_properties_catalogue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('personnel_properties_catalogue_id_seq', 9, true);


--
-- Name: personnel_properties_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('personnel_properties_id_seq', 128, true);


--
-- Data for Name: procedures_catalogue; Type: TABLE DATA; Schema: public; Owner: root
--

COPY procedures_catalogue (id, name, type, base_cost) FROM stdin;
11	Subjektive Refraktionsbestimmung mit sphärischen Gläsern	1	7.91000000000000014
1	BCVA ETDRS 4M 2 eyes	\N	25
12	Subjektive Refraktionsbestimmung mit sphärisch-zylindrischen Gläsern	1	11.9399999999999995
163	IOLMaster biomerty	\N	50
13	Objektive Refraktionsbestimmung mittels Skiaskopie oder Anwendung eines Refraktometers	1	9.91000000000000014
14	Messung der Maximal- oder Gebrauchsakkommodation mittels Akkommodometer oder Optometer	1	8.05000000000000071
15	Messung der Hornhautkrümmungsradien	1	6.03000000000000025
16	Prüfung von Mehrstärken- oder Prismenbrillen mit Bestimmung der Fern- und Nahpunkte bei subjektiver Brillenunverträglichkeit	1	9.38000000000000078
150	BCVA standard near binocular	\N	15
148	BCVA standard near 2 eyes	\N	18
17	Nachweis der Tränensekretionsmenge (z. B. Schirmer-Test)	1	2.68999999999999995
146	BCVA standard 4M 2 eyes	\N	18
2	BCVA ETDRS 4M binocular	\N	25
143	BCVA standard 1M 2 eyes	\N	18
164	eCRF-Pauschale 30min	\N	50
147	BCVA standard 4M binocular	\N	15
151	BCVA  1M binocular	\N	15
153	UCVA standard 1M 2 eyes	\N	18
23	Untersuchung auf Heterophorie bzw. Strabismus gegebenenfalls einschließlich qualitativer Untersuchung des binokularen Sehaktes	1	12.1899999999999995
24	Qualitative und quantitative Untersuchung des binokularen Sehaktes	1	32.4500000000000028
25	Differenzierende Analyse und graphische Darstellung des Bewegungsablaufs beider Augen bei Augenmuskelstörungen, mindestens 36 Blickrichtungen pro Auge	1	93.8400000000000034
26	Kampimetrie (z. B. Bjerrum) auch Perimetrie nach Förster	1	16.2199999999999989
27	Projektionsperimetrie mit Marken verschiedener Reizwerte	1	24.3999999999999986
28	Quantitativ abgestufte (statische) Profilperimetrie	1	33.259999999999998
29	Farbsinnprüfung mit Pigmentproben (z. B. Farbtafeln)	1	8.1899999999999995
30	Farbsinnprüfung mit Anomaloskop	1	24.3999999999999986
31	Vollständige Untersuchung des zeitlichen Ablaufs der Adaptation	1	64.8799999999999955
32	Untersuchung des Dämmerungssehens ohne Blendung	1	12.1899999999999995
33	Untersuchung des Dämmerungssehens während der Blendung	1	12.1899999999999995
34	Untersuchung des Dämmerungssehens nach der Blendung (Readaptation)	1	12.1899999999999995
35	Elektroretinographische Untersuchung (ERG) und/oder elektrookulographische Untersuchung (EOG)	1	80.4300000000000068
36	Spaltlampenmikroskopie der vorderen und mittleren Augenabschnitte gegebenenfalls einschließlich der binokularen Untersuchung des hinteren Poles (z. B. Hruby-Linse)	1	9.91000000000000014
37	Gonioskopie	1	20.379999999999999
38	Binokulare Untersuchung des Augenhintergrundes einschließlich der äußeren Peripherie (z. B. Dreispiegelkontaktglas, Schaepens) gegebenenfalls einschließlich der Spaltlampenmikroskopie der vorderen und mittleren Augenabschnitte und/oder diasklerale Durchleuchtung	1	20.379999999999999
39	Diasklerale Durchleuchtung	1	8.1899999999999995
40	Exophthalmometrie	1	6.69000000000000039
41	Fluoreszenzuntersuchung der terminalen Strombahn am Augenhintergrund einschließlich Applikation des Teststoffes	1	32.4500000000000028
42	Fluoreszenzangiographische Untersuchung der terminalen Strombahn am Augenhintergrund einschließlich Aufnahmen und Applikation des Teststoffes	1	64.8799999999999955
155	UCVA standard 1M binocular	\N	15
152	UCVA standard 4M binocular	\N	15
45	Fotographische Verlaufskontrolle intraokularer Veränderungen mittels Spaltlampenfotographie	1	13.4100000000000001
46	Fotographische Verlaufskontrolle von Veränderungen des Augenhintergrunds mittels Fundusfotographie	1	20.1000000000000014
47	Tonometrische Untersuchung mit Anwendung des Impressionstonometers	1	7.33999999999999986
48	Tonometrische Untersuchung mit Anwendung des Applanationstonometers	1	10.4900000000000002
49	Tonometrische Untersuchung (mehrfach in zeitlichem Zusammenhang zur Anfertigung tonometrischer Kurven, mindestens vier Messungen) auch fortlaufende Tonometrie zur Ermittlung des Abflußwiderstandes	1	25.3999999999999986
50	Pupillographie	1	25.3999999999999986
51	Elektromyographie der äußeren Augenmuskeln	1	58.75
52	Ophthalmodynamometrie gegebenenfalls einschließlich Tonometrie, erste Messung	1	25.3999999999999986
154	UCVA standard near binocular	\N	15
145	UCVA ETDRS 4M binocular	\N	20
158	Contrast vision 2 eyes	\N	25
3	UCVA ETDRS 4M 2 eyes	\N	25
161	Specular microscopy 2 eyes	\N	40
162	AE Interview	\N	20
156	UCVA standard 4M 2 eyes	\N	18
157	UCVA standard near 2 eyes	\N	18
165	eCRF-Pauschale 10min	\N	10
144	UCVA ETDRS near 2 eyes	\N	25
159	Questionnaire interview 5-10 items	\N	50
160	Defocus refraction	\N	120
166	Reticam	\N	15
167	Blutentnahme	\N	15
\.


--
-- Name: procedures_catalogue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('procedures_catalogue_id_seq', 167, true);


--
-- Data for Name: procedures_personnel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY procedures_personnel (id, idpersonnel, idprocedure) FROM stdin;
3	36	136
5	37	139
7	37	140
4	37	133
9	1	139
\.


--
-- Name: procedures_personnel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('procedures_personnel_id_seq', 10, true);


--
-- Data for Name: process_steps_catalogue; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY process_steps_catalogue (id, type, name) FROM stdin;
3	0	Siteselection
2	0	Vertragsverhandlung
10	0	Ethikvotum
1	0	Feasibility
7	0	Rekrutierung
11	1	Gesamtlaufzeit
14	0	Initiierung
12	0	Monitorvisit
6	0	Training
13	0	Audit
16	0	Equipment
5	0	Vertragsumlauf
17	0	Archivierung
15	0	Zertifizierung
18	0	Medikamentenlieferung
\.


--
-- Name: process_steps_catalogue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('process_steps_catalogue_id_seq', 18, true);


--
-- Data for Name: roles_catalogue; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY roles_catalogue (id, name) FROM stdin;
1	PI
2	Sub-I
3	Study-Nurse
4	LKP
\.


--
-- Name: roles_catalogue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('roles_catalogue_id_seq', 4, true);


--
-- Data for Name: shadow_accounts; Type: TABLE DATA; Schema: public; Owner: root
--

COPY shadow_accounts (id, account_number, idgroup, name) FROM stdin;
\.


--
-- Name: shadow_accounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('shadow_accounts_id_seq', 91, true);


--
-- Data for Name: status_catalogue; Type: TABLE DATA; Schema: public; Owner: root
--

COPY status_catalogue (id, idtrial, name, alerting) FROM stdin;
495	194	Screen fail	1
496	194	Screen	1
497	194	Randomized	1
498	195	Screen fail	1
499	195	Screen	1
500	195	Randomized	1
501	196	Screen fail	1
502	196	Screen	1
503	196	Randomized	1
504	197	Screen fail	1
505	197	Screen	1
506	197	Randomized	1
5	25	Rando	1
4	25	Screen	1
6	25	Fail	1
\.


--
-- Name: status_catalogue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('status_catalogue_id_seq', 506, true);


--
-- Data for Name: trial_personnel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY trial_personnel (id, idtrial, idpersonnel, role) FROM stdin;
\.


--
-- Name: trial_personnel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('trial_personnel_id_seq', 14, true);


--
-- Data for Name: trial_process_step; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY trial_process_step (id, idtrial, type, start_date, end_date, deadline, idpersonnel, title) FROM stdin;
417	25	7	2013-09-01	2014-02-28	\N	\N	
823	25	\N	2014-11-13	\N	\N	\N	\N
824	25	\N	2014-11-13	\N	\N	\N	\N
825	25	\N	2014-11-13	\N	\N	\N	\N
826	25	\N	2014-11-13	\N	\N	\N	\N
827	25	\N	2014-11-13	\N	\N	\N	\N
828	25	\N	2014-11-13	\N	\N	\N	\N
829	25	\N	2014-11-13	\N	\N	\N	\N
830	25	\N	2014-11-13	\N	\N	\N	\N
831	25	\N	2014-11-13	\N	\N	\N	\N
832	25	\N	2014-11-13	\N	\N	\N	\N
833	25	\N	2014-11-13	\N	\N	\N	\N
834	25	\N	2014-11-13	\N	\N	\N	\N
835	25	\N	2014-11-13	\N	\N	\N	\N
836	25	\N	2014-11-13	\N	\N	\N	\N
837	25	\N	2014-11-13	\N	\N	\N	\N
838	25	\N	2014-11-13	\N	\N	\N	\N
839	25	\N	2014-11-13	\N	\N	\N	\N
840	25	\N	2014-11-13	\N	\N	\N	\N
841	25	\N	2014-11-13	\N	\N	\N	\N
842	25	\N	2014-11-13	\N	\N	\N	\N
843	25	\N	2014-11-13	\N	\N	\N	\N
844	25	\N	2014-11-13	\N	\N	\N	\N
845	25	\N	2014-11-13	\N	\N	\N	\N
846	25	\N	2014-11-13	\N	\N	\N	\N
847	25	\N	2014-11-13	\N	\N	\N	\N
848	25	\N	2014-11-13	\N	\N	\N	\N
749	25	11	2014-09-01	2014-07-31	\N	\N	\N
465	25	12	2014-02-25	\N	\N	2	\N
849	194	11	2014-11-16	\N	\N	\N	\N
850	195	11	2014-11-16	\N	\N	\N	\N
851	196	11	2014-11-16	\N	\N	\N	\N
852	197	11	2014-11-17	\N	\N	\N	\N
627	25	12	2014-05-06	2014-05-07	\N	\N	\N
750	25	17	2014-07-31	2029-07-31	\N	\N	\N
\.


--
-- Name: trial_process_step_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('trial_process_step_id_seq', 852, true);


--
-- Data for Name: trial_properties; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY trial_properties (id, idtrial, idproperty, value) FROM stdin;
227	25	12	Prof. XX
228	25	1	2012-XXX
219	25	3	ZVSXX
233	25	18	12501d s ds dfdfff fffdsfdsfds ds dsdf sf ds dfs dsffs dfsfs d dfsds fdsf dsf 
232	25	16	https://www.xxx.com
778	25	27	NCT0XXX
230	25	14	2408,00 (overhead included!)
5394	194	8	
5398	195	25	\N
5399	195	26	\N
5400	195	27	\N
5401	195	11	\N
5402	195	17	\N
5403	195	33	\N
5404	195	31	\N
5405	195	34	\N
231	25	15	10
5406	195	12	\N
5407	195	18	\N
5408	195	2	\N
5409	195	15	\N
5410	195	13	\N
5411	195	21	\N
5412	195	37	\N
5413	195	32	\N
5415	195	38	\N
5416	195	8	\N
5417	195	28	\N
5418	195	30	\N
5419	195	29	\N
5385	194	16	
5420	195	16	\N
5421	195	4	\N
5422	195	23	\N
5423	195	1	\N
5424	195	22	\N
5425	195	3	\N
5426	195	14	\N
5427	195	63	\N
5428	195	7	\N
5414	195	24	
5377	194	11	
5470	194	4	
5471	194	65	
5472	194	61	
5389	194	1	
5372	194	32	dsdffsd
5379	194	33	dsffdssdffdsfsd
5376	194	27	dsssss
5380	194	17	lll
5382	194	34	
5368	194	13	
5369	194	21	
5392	194	63	
5388	194	22	
5373	194	38	
5370	194	37	dssd
5476	197	18	\N
5477	197	34	\N
5478	197	12	\N
234	25	17	http://www.ccc.com
1440	25	33	J
5430	196	17	\N
5431	196	33	\N
5432	196	11	\N
5437	196	27	\N
5439	196	26	\N
5440	196	37	\N
5441	196	38	\N
5443	196	32	\N
5446	196	13	\N
5447	196	29	\N
5448	196	28	\N
5449	196	30	\N
5455	196	23	\N
5457	196	16	\N
5479	197	31	\N
5442	196	24	fdffddf
5456	196	4	
5480	197	33	\N
5458	196	22	
5445	196	21	
5436	196	18	
5454	196	63	mm
5452	196	3	
5450	196	8	
5459	196	1	
5435	196	34	
5433	196	2	
5453	196	7	
5434	196	12	
5438	196	25	
5429	196	31	
5444	196	15	mmm
5451	196	14	
5482	197	11	
5486	197	38	\N
5490	197	21	\N
5491	197	13	\N
5492	197	15	\N
5496	197	8	\N
5498	197	63	\N
5500	197	3	\N
5501	197	22	\N
5502	197	1	\N
5503	197	23	\N
5487	197	24	
5494	197	30	
5475	197	2	
5489	197	37	
5505	197	16	
5488	197	32	
5483	197	27	dsssss
5499	197	14	
5504	197	4	
5485	197	25	dfdfdf
5495	197	28	
5481	197	17	fdfdsfsgd
781	25	30	1235
782	25	31	12345
5466	194	62	
5467	194	24	
783	25	32	J
1899	25	37	XXX
\.


--
-- Data for Name: trial_properties_catalogue; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY trial_properties_catalogue (id, type, name, ordering, default_value) FROM stdin;
18	1	Site Nummer	29	\N
2	1	MPG/AMG/Sonst	10	\N
1	1	EudraCT	11	\N
3	1	ZVS-Nummer	12	\N
11	1	Setup fee (EUR)	20	\N
13	1	Zuweiserpauschale (EUR)	22	\N
15	1	Zugesagte Patientenzahl	25	\N
16	1	eCRF_URL	30	\N
28	1	Monitor Fax	2	\N
33	1	Overhead inclusive J/N	1001	\N
21	1	Reisekosten (EUR)	23	\N
22	1	Sonstige Kosten (EUR)	24	\N
14	1	Casepayment (EUR)	26	\N
29	1	Monitor Mail	3	\N
8	1	Drittmittelnummer	13	\N
30	1	Monitor Mobil	4	\N
34	1	Phase	15	\N
37	1	USt-ID	30	\N
38	1	Labor Setup J/N	2001	\N
12	1	LKP (Ort)	7	\N
26	1	PI	8	\N
25	1	Monitor	1	\N
31	1	Monitor Tel	5	\N
7	1	Sponsor	9	\N
24	1	Voller Titel	-2	\N
4	1	CRO	0	\N
17	1	IVRS Info	31	\N
23	1	Indikation	-1	\N
27	1	NCT Nummer	1000	\N
42	0	Aufbewahrung bis	3003	\N
41	0	Anzahl Boxen	3002	\N
44	0	Medical Monitor	6	\N
45	0	Koordinatorin	9	\N
46	0	LKP ZVS	14	\N
48	0	Medical Monitor Email	6	\N
32	1	Umsatzsteuer J/N	2000	J
47	0	LKP Drittm	14	\N
40	0	Verfilmung erlaubt J/N	3001	N
43	0	Serienbrief	9999	\\documentclass{scrreprt}\r\\usepackage[ngerman]{babel}\r\\usepackage[utf8]{inputenc}\r\\usepackage[T1]{fontenc}\r\\usepackage{graphicx}\r\\usepackage{wallpaper}\r\\usepackage{tabularx}\r\r\r\\renewcommand{\\familydefault}{\\sfdefault}\r\\usepackage{helvet}\r\r\\pagenumbering{none}\r\r\r\\begin{document}\r\\baselineskip15pt\r\\setlength{\\headheight}{7\\baselineskip}\r\\setlength{\\oddsidemargin}{-3mm}\r\\addtolength{\\textwidth}{2cm}\r\r<foreach:patients>\r\r\\ThisCenterWallPaper{1}{<copytex:briefkopfAdresszeile3.pdf>}\r\r\\noindent <anrede1>\\\\\r\\noindent <givenname> <name>\\\\\r\\noindent <street> \\\\\r\\noindent <zip> <town> \\\\\r\\\\ \\\\\r\\hspace*{11.0cm}  Freiburg, <today>\\\\\r\r\\noindent Datenschutzerkl"arung in der klinischen Studie {\\it <Voller Titel>}\\\\\r\r\\noindent  Sehr geehrte<anrede2>, <name>,\\\\\r\r\\noindent hiermit m"ochten wir Sie dar"uber informieren, dass ....\\\\\\\\\r\r\\noindent Mit freundlichen Gr"u"sen, \\\\ \\\\\r\r\\hspace*{-7mm}  \\begin{tabularx}{20cm}{XX}\r<_Loginname_>\\\\\r<_Loginrole_> \\\\\r\\end{tabularx}\r\r\\newpage\r\r</foreach:patients>\r\r\r\\end{document}\r
56	0	IVRS Zugänge	31	\N
50	0	Medical Monitor Tel	6	\N
49	0	Medical Monitor Mobil	6	\N
57	0	Team	9	\N
58	0	Reisekosten Notiz	23	\N
51	0	Labor	2001	\N
61	0	Wichtig	0	\N
52	0	BCVA	2001	\N
59	0	Readingcenter note	2001	\N
53	0	Readingcenter	2001	\N
54	0	eCRF	30	\N
39	0	Injekteuren	9	\N
63	1	Kilometerpauschale Reisekosten	23	0.25
60	0	Unmasked Monitor	6	\N
55	0	eCRF Support	30	\N
64	0	Fahrkostenpauschale	23	25
62	0	Protokollnummer	-3	\N
65	0	Prüfpräparat	0	\N
\.


--
-- Name: trial_properties_catalogue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('trial_properties_catalogue_id_seq', 65, true);


--
-- Name: trial_properties_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('trial_properties_id_seq', 5505, true);


--
-- Data for Name: trial_property_annotations; Type: TABLE DATA; Schema: public; Owner: root
--

COPY trial_property_annotations (id, ldap, idfield, key, value) FROM stdin;
\.


--
-- Name: trial_property_annotations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('trial_property_annotations_id_seq', 48, true);


--
-- Data for Name: trial_visits; Type: TABLE DATA; Schema: public; Owner: root
--

COPY trial_visits (id, name, idtrial, idreference_visit, visit_interval, lower_margin, upper_margin, reimbursement, additional_docscal_booking_name, ordering, comment) FROM stdin;
299	\N	196	\N	\N	\N	\N	\N	\N	\N	\N
5	Visit 1	25	7	7 days	3 days	3 days	448	\N	\N	\N
7	Baseline	25	\N	00:00:00	00:00:00	00:00:00	588	\N	\N	\N
8	Unschelduled	25	\N	00:00:00	-2 years	2 years	154	\N	\N	\N
6	Visit 2	25	7	30 days	7 days	7 days	448	\N	\N	\N
9	Vis 3	25	7	60 days	7 days	7 days	448	\N	\N	\N
10	Vis 4/ Early Exit	25	7	90 days	7 days	7 days	476	\N	\N	\N
\.


--
-- Name: trial_visits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('trial_visits_id_seq', 299, true);


--
-- Data for Name: visit_procedures; Type: TABLE DATA; Schema: public; Owner: root
--

COPY visit_procedures (id, idvisit, idprocedure, actual_cost) FROM stdin;
120	\N	\N	\N
136	299	162	\N
139	5	15	\N
140	5	162	\N
133	7	151	\N
141	7	51	\N
\.


--
-- Name: visit_procedures_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('visit_procedures_id_seq', 141, true);


--
-- Name: account_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY account_transaction
    ADD CONSTRAINT account_transaction_pkey PRIMARY KEY (id);


--
-- Name: all_trials_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY all_trials
    ADD CONSTRAINT all_trials_pkey PRIMARY KEY (id);


--
-- Name: billings_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY billings
    ADD CONSTRAINT billings_pkey PRIMARY KEY (id);


--
-- Name: group_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY group_assignments
    ADD CONSTRAINT group_assignments_pkey PRIMARY KEY (id);


--
-- Name: groups_catalogue_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY groups_catalogue
    ADD CONSTRAINT groups_catalogue_name_key UNIQUE (name);


--
-- Name: groups_catalogue_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY groups_catalogue
    ADD CONSTRAINT groups_catalogue_pkey PRIMARY KEY (id);


--
-- Name: onetransaction; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY account_transaction
    ADD CONSTRAINT onetransaction UNIQUE (idaccount, date_transaction, amount_change, description, type);


--
-- Name: patient_visits_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY patient_visits
    ADD CONSTRAINT patient_visits_pkey PRIMARY KEY (id);


--
-- Name: patients_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY patients
    ADD CONSTRAINT patients_pkey PRIMARY KEY (id);


--
-- Name: personnel_catalogue_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY personnel_catalogue
    ADD CONSTRAINT personnel_catalogue_pkey PRIMARY KEY (id);


--
-- Name: personnel_costs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY personnel_costs
    ADD CONSTRAINT personnel_costs_pkey PRIMARY KEY (id);


--
-- Name: personnel_event_catalogue_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY personnel_event_catalogue
    ADD CONSTRAINT personnel_event_catalogue_pkey PRIMARY KEY (id);


--
-- Name: personnel_event_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY personnel_event
    ADD CONSTRAINT personnel_event_pkey PRIMARY KEY (id);


--
-- Name: personnel_properties_catalogue_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY personnel_properties_catalogue
    ADD CONSTRAINT personnel_properties_catalogue_pkey PRIMARY KEY (id);


--
-- Name: personnel_properties_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY personnel_properties
    ADD CONSTRAINT personnel_properties_pkey PRIMARY KEY (id);


--
-- Name: procedures_catalogue_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY procedures_catalogue
    ADD CONSTRAINT procedures_catalogue_pkey PRIMARY KEY (id);


--
-- Name: procedures_personnel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY procedures_personnel
    ADD CONSTRAINT procedures_personnel_pkey PRIMARY KEY (id);


--
-- Name: process_steps_catalogue_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY process_steps_catalogue
    ADD CONSTRAINT process_steps_catalogue_pkey PRIMARY KEY (id);


--
-- Name: roles_catalogue_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY roles_catalogue
    ADD CONSTRAINT roles_catalogue_name_key UNIQUE (name);


--
-- Name: roles_catalogue_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY roles_catalogue
    ADD CONSTRAINT roles_catalogue_pkey PRIMARY KEY (id);


--
-- Name: shadow_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY shadow_accounts
    ADD CONSTRAINT shadow_accounts_pkey PRIMARY KEY (id);


--
-- Name: status_catalogue_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY status_catalogue
    ADD CONSTRAINT status_catalogue_pkey PRIMARY KEY (id);


--
-- Name: trial_personnel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY trial_personnel
    ADD CONSTRAINT trial_personnel_pkey PRIMARY KEY (id);


--
-- Name: trial_process_step_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY trial_process_step
    ADD CONSTRAINT trial_process_step_pkey PRIMARY KEY (id);


--
-- Name: trial_properties_catalogue_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY trial_properties_catalogue
    ADD CONSTRAINT trial_properties_catalogue_pkey PRIMARY KEY (id);


--
-- Name: trial_properties_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY trial_properties
    ADD CONSTRAINT trial_properties_pkey PRIMARY KEY (id);


--
-- Name: trial_property_annotations_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY trial_property_annotations
    ADD CONSTRAINT trial_property_annotations_pkey PRIMARY KEY (id);


--
-- Name: trial_visits_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY trial_visits
    ADD CONSTRAINT trial_visits_pkey PRIMARY KEY (id);


--
-- Name: visit_procedures_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY visit_procedures
    ADD CONSTRAINT visit_procedures_pkey PRIMARY KEY (id);


--
-- Name: reference_visit_idx; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX reference_visit_idx ON trial_visits USING btree (idreference_visit);


--
-- Name: enrich_newperson; Type: RULE; Schema: public; Owner: root
--

CREATE RULE enrich_newperson AS
    ON INSERT TO personnel DO INSTEAD ( INSERT INTO personnel_catalogue (name)
  VALUES (new.name);
 INSERT INTO personnel_properties (idpersonnel, idproperty)  SELECT personnel_catalogue.id AS idpersonnel,
            personnel_properties_catalogue.id AS idproperty
           FROM ((personnel_catalogue
             JOIN personnel_properties_catalogue ON (true))
             LEFT JOIN personnel_properties ON (((personnel_properties.idpersonnel = personnel_catalogue.id) AND (personnel_properties.idproperty = personnel_properties_catalogue.id))))
          WHERE (((personnel_properties.id IS NULL) AND (personnel_properties_catalogue.type = 1)) AND (personnel_catalogue.id = currval('personnel_catalogue_id_seq'::regclass)));
);


--
-- Name: enrich_newtrial; Type: RULE; Schema: public; Owner: postgres
--

CREATE RULE enrich_newtrial AS
    ON INSERT TO trials DO INSTEAD ( INSERT INTO all_trials (name, idgroup)
  VALUES (new.name, new.idgroup);
 INSERT INTO trial_properties (idtrial, idproperty)  SELECT all_trials.id AS idtrial,
            trial_properties_catalogue.id AS idproperty
           FROM ((all_trials
             JOIN trial_properties_catalogue ON (true))
             LEFT JOIN trial_properties ON (((trial_properties.idtrial = all_trials.id) AND (trial_properties.idproperty = trial_properties_catalogue.id))))
          WHERE (((trial_properties.id IS NULL) AND (trial_properties_catalogue.type = 1)) AND (all_trials.id = currval('all_trials_id_seq'::regclass)));
 INSERT INTO trial_process_step (idtrial, type)  SELECT all_trials.id AS idtrial,
            process_steps_catalogue.id AS idproperty
           FROM ((all_trials
             JOIN process_steps_catalogue ON (true))
             LEFT JOIN trial_process_step ON (((trial_process_step.idtrial = all_trials.id) AND (trial_process_step.type = process_steps_catalogue.id))))
          WHERE (((trial_process_step.id IS NULL) AND (process_steps_catalogue.type = 1)) AND (all_trials.id = currval('all_trials_id_seq'::regclass)));
 INSERT INTO status_catalogue (idtrial, name)
  VALUES (currval('all_trials_id_seq'::regclass), 'Screen fail'::text);
 INSERT INTO status_catalogue (idtrial, name)
  VALUES (currval('all_trials_id_seq'::regclass), 'Screen'::text);
 INSERT INTO status_catalogue (idtrial, name)
  VALUES (currval('all_trials_id_seq'::regclass), 'Randomized'::text);
);


--
-- Name: procedure_statistics_writable; Type: RULE; Schema: public; Owner: root
--

CREATE RULE procedure_statistics_writable AS
    ON UPDATE TO procedure_statistics DO INSTEAD  UPDATE visit_procedures SET idprocedure = ( SELECT min(a.id) AS min
           FROM procedures_catalogue a
          WHERE (a.name = new.name))
  WHERE (visit_procedures.id = old.id);


--
-- Name: visit_procedures_name_writable; Type: RULE; Schema: public; Owner: postgres
--

CREATE RULE visit_procedures_name_writable AS
    ON UPDATE TO visit_procedures_name DO INSTEAD  UPDATE visit_procedures SET idprocedure = ( SELECT min(a.id) AS min
           FROM procedures_catalogue a
          WHERE (a.name = new.procedure_name))
  WHERE (visit_procedures.id = new.id);


--
-- Name: account_transaction_account_number_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY account_transaction
    ADD CONSTRAINT account_transaction_account_number_fkey FOREIGN KEY (idaccount) REFERENCES shadow_accounts(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: billings_idtrial_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY billings
    ADD CONSTRAINT billings_idtrial_fkey FOREIGN KEY (idtrial) REFERENCES all_trials(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: group_assignments_idgroup_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY group_assignments
    ADD CONSTRAINT group_assignments_idgroup_fkey FOREIGN KEY (idgroup) REFERENCES groups_catalogue(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: group_assignments_idpersonnel_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY group_assignments
    ADD CONSTRAINT group_assignments_idpersonnel_fkey FOREIGN KEY (idpersonnel) REFERENCES personnel_catalogue(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: patient_visits_idpatient_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY patient_visits
    ADD CONSTRAINT patient_visits_idpatient_fkey FOREIGN KEY (idpatient) REFERENCES patients(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: patient_visits_idvisit_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY patient_visits
    ADD CONSTRAINT patient_visits_idvisit_fkey FOREIGN KEY (idvisit) REFERENCES trial_visits(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: patients_idtrial_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY patients
    ADD CONSTRAINT patients_idtrial_fkey FOREIGN KEY (idtrial) REFERENCES all_trials(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: personnel_costs_idaccount_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY personnel_costs
    ADD CONSTRAINT personnel_costs_idaccount_fkey FOREIGN KEY (idaccount) REFERENCES shadow_accounts(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: personnel_costs_idpersonnel_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY personnel_costs
    ADD CONSTRAINT personnel_costs_idpersonnel_fkey FOREIGN KEY (idpersonnel) REFERENCES personnel_catalogue(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: personnel_event_idpersonnel_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY personnel_event
    ADD CONSTRAINT personnel_event_idpersonnel_fkey FOREIGN KEY (idpersonnel) REFERENCES personnel_catalogue(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: personnel_properties_idpersonnel_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY personnel_properties
    ADD CONSTRAINT personnel_properties_idpersonnel_fkey FOREIGN KEY (idpersonnel) REFERENCES personnel_catalogue(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: personnel_properties_idproperty_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY personnel_properties
    ADD CONSTRAINT personnel_properties_idproperty_fkey FOREIGN KEY (idproperty) REFERENCES personnel_properties_catalogue(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: procedures_personnel_idpersonnel_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY procedures_personnel
    ADD CONSTRAINT procedures_personnel_idpersonnel_fkey FOREIGN KEY (idpersonnel) REFERENCES personnel_catalogue(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: procedures_personnel_idprocedure_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY procedures_personnel
    ADD CONSTRAINT procedures_personnel_idprocedure_fkey FOREIGN KEY (idprocedure) REFERENCES visit_procedures(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: shadow_accounts_idgroup_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY shadow_accounts
    ADD CONSTRAINT shadow_accounts_idgroup_fkey FOREIGN KEY (idgroup) REFERENCES groups_catalogue(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: status_catalogue_idtrial_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY status_catalogue
    ADD CONSTRAINT status_catalogue_idtrial_fkey FOREIGN KEY (idtrial) REFERENCES all_trials(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tp_annot_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY trial_property_annotations
    ADD CONSTRAINT tp_annot_fkey FOREIGN KEY (idfield) REFERENCES trial_properties(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: trial_personnel_idpersonnel_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trial_personnel
    ADD CONSTRAINT trial_personnel_idpersonnel_fkey FOREIGN KEY (idpersonnel) REFERENCES personnel_catalogue(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: trial_personnel_idtrial_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trial_personnel
    ADD CONSTRAINT trial_personnel_idtrial_fkey FOREIGN KEY (idtrial) REFERENCES all_trials(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: trial_process_step_idtrial_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trial_process_step
    ADD CONSTRAINT trial_process_step_idtrial_fkey FOREIGN KEY (idtrial) REFERENCES all_trials(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: trial_properties_idproperty_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trial_properties
    ADD CONSTRAINT trial_properties_idproperty_fkey FOREIGN KEY (idproperty) REFERENCES trial_properties_catalogue(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: trial_properties_idtrial_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trial_properties
    ADD CONSTRAINT trial_properties_idtrial_fkey FOREIGN KEY (idtrial) REFERENCES all_trials(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: trial_visits_idtrial_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY trial_visits
    ADD CONSTRAINT trial_visits_idtrial_fkey FOREIGN KEY (idtrial) REFERENCES all_trials(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: visit_procedures_idprocedure_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY visit_procedures
    ADD CONSTRAINT visit_procedures_idprocedure_fkey FOREIGN KEY (idprocedure) REFERENCES procedures_catalogue(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: visit_procedures_idvisit_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY visit_procedures
    ADD CONSTRAINT visit_procedures_idvisit_fkey FOREIGN KEY (idvisit) REFERENCES trial_visits(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: daboe01
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM daboe01;
GRANT ALL ON SCHEMA public TO daboe01;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: dblink_connect_u(text); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION dblink_connect_u(text) FROM PUBLIC;
REVOKE ALL ON FUNCTION dblink_connect_u(text) FROM postgres;
GRANT ALL ON FUNCTION dblink_connect_u(text) TO postgres;


--
-- Name: dblink_connect_u(text, text); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION dblink_connect_u(text, text) FROM PUBLIC;
REVOKE ALL ON FUNCTION dblink_connect_u(text, text) FROM postgres;
GRANT ALL ON FUNCTION dblink_connect_u(text, text) TO postgres;


--
-- Name: calendar; Type: ACL; Schema: public; Owner: root
--

REVOKE ALL ON TABLE calendar FROM PUBLIC;
REVOKE ALL ON TABLE calendar FROM root;
GRANT ALL ON TABLE calendar TO root;


--
-- Name: patient_visits_rich; Type: ACL; Schema: public; Owner: root
--

REVOKE ALL ON TABLE patient_visits_rich FROM PUBLIC;
REVOKE ALL ON TABLE patient_visits_rich FROM root;
GRANT ALL ON TABLE patient_visits_rich TO root;


--
-- PostgreSQL database dump complete
--

