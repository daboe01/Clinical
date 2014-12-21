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
    abrechnungsname text,
    password text
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
-- Name: meeting_attendees; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE meeting_attendees (
    id integer NOT NULL,
    start_time_proposal timestamp without time zone,
    stop_time_proposal timestamp without time zone,
    comment text,
    idattendee integer,
    idmeeting integer
);


ALTER TABLE public.meeting_attendees OWNER TO postgres;

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
-- Name: team_meetings; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE team_meetings (
    id integer NOT NULL,
    starttime timestamp without time zone,
    stoptime timestamp without time zone,
    title text,
    idgroup integer
);


ALTER TABLE public.team_meetings OWNER TO postgres;

--
-- Name: visit_procedures; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE visit_procedures (
    id integer NOT NULL,
    idvisit integer,
    idprocedure integer,
    actual_cost double precision,
    ordering integer,
    parameter text
);


ALTER TABLE public.visit_procedures OWNER TO root;

--
-- Name: event_overview; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW event_overview AS
 WITH collector1 AS (
         SELECT DISTINCT a.name,
            a.event_date,
            COALESCE(a.ldap, personnel_catalogue.ldap) AS ldap,
            a.type,
            a.piz,
            a.tooltip,
            personnel_catalogue.ldap AS ldap_unfiltered
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
                    ((((COALESCE(process_steps_catalogue.name, ''::text) || ' '::text) || COALESCE(trial_process_step.title, ''::text)) || ' '::text) || all_trials_1.name),
                    trial_process_step.start_date AS event_date,
                    2 AS type,
                    NULL::integer AS piz,
                    NULL::text AS tooltip,
                    personnel_catalogue_1.ldap
                   FROM (((trial_process_step
                     JOIN process_steps_catalogue ON ((trial_process_step.type = process_steps_catalogue.id)))
                     JOIN all_trials all_trials_1 ON ((all_trials_1.id = trial_process_step.idtrial)))
                     LEFT JOIN personnel_catalogue personnel_catalogue_1 ON ((personnel_catalogue_1.id = trial_process_step.idpersonnel)))
                UNION
                 SELECT ( SELECT min(all_trials_1.id) AS min
                           FROM (all_trials all_trials_1
                             JOIN group_assignments group_assignments_1 ON ((group_assignments_1.idgroup = all_trials_1.idgroup)))
                          WHERE (group_assignments_1.idpersonnel = personnel_catalogue_1.id)) AS idtrial,
                    ('Abwesend: '::text || personnel_catalogue_1.ldap),
                    a_1.day AS event_date,
                    3 AS type,
                    NULL::integer AS piz,
                    personnel_event.comment AS tooltip,
                    NULL::text AS ldap
                   FROM ((personnel_event
                     JOIN ( SELECT day.day
                           FROM generate_series(((now())::date - '1 year'::interval), ((now())::date + '1 year'::interval), '1 day'::interval) day(day)) a_1 ON (((a_1.day >= (personnel_event.start_time)::date) AND (a_1.day <= (personnel_event.end_time)::date))))
                     JOIN personnel_catalogue personnel_catalogue_1 ON ((personnel_catalogue_1.id = personnel_event.idpersonnel)))
                  WHERE (personnel_event.type <> 4)
                UNION
                 SELECT ( SELECT min(all_trials_1.id) AS min
                           FROM (all_trials all_trials_1
                             JOIN group_assignments group_assignments_1 ON ((group_assignments_1.idgroup = all_trials_1.idgroup)))
                          WHERE (group_assignments_1.idpersonnel = personnel_catalogue_1.id)) AS idtrial,
                    ('Frei: '::text || personnel_catalogue_1.ldap),
                    a_1.day AS event_date,
                    3 AS type,
                    NULL::integer AS piz,
                    personnel_event.comment AS tooltip,
                    NULL::text AS ldap
                   FROM ((personnel_event
                     JOIN ( SELECT day.day
                           FROM generate_series(((now())::date - '1 year'::interval), ((now())::date + '1 year'::interval), '1 day'::interval) day(day)) a_1 ON ((((a_1.day >= (personnel_event.start_time)::date) AND (a_1.day <= (personnel_event.end_time)::date)) AND (date_part('dow'::text, a_1.day) = ((personnel_event.comment)::integer)::double precision))))
                     JOIN personnel_catalogue personnel_catalogue_1 ON ((personnel_catalogue_1.id = personnel_event.idpersonnel)))
                  WHERE (personnel_event.type = 4)
                UNION
                 SELECT trial_process_step.idtrial,
                    (((('Ende: '::text || (COALESCE(process_steps_catalogue.name, ''::text) || ' '::text)) || COALESCE(trial_process_step.title, ''::text)) || ' '::text) || all_trials_1.name),
                    trial_process_step.end_date AS event_date,
                    2 AS type,
                    NULL::integer AS piz,
                    NULL::text AS tooltip,
                    personnel_catalogue_1.ldap
                   FROM (((trial_process_step
                     JOIN process_steps_catalogue ON ((trial_process_step.type = process_steps_catalogue.id)))
                     LEFT JOIN personnel_catalogue personnel_catalogue_1 ON ((personnel_catalogue_1.id = trial_process_step.idpersonnel)))
                     JOIN all_trials all_trials_1 ON ((all_trials_1.id = trial_process_step.idtrial)))) a
             LEFT JOIN all_trials ON ((a.idtrial = all_trials.id)))
             LEFT JOIN group_assignments ON ((group_assignments.idgroup = all_trials.idgroup)))
             LEFT JOIN personnel_catalogue ON ((personnel_catalogue.id = group_assignments.idpersonnel)))
          WHERE ((a.name IS NOT NULL) AND (a.event_date IS NOT NULL))
          ORDER BY a.type DESC
        )
 SELECT collector1.name,
    collector1.event_date,
    collector1.ldap,
    collector1.type,
    collector1.piz,
    collector1.tooltip,
    collector1.ldap_unfiltered
   FROM collector1
UNION
 SELECT ('Meeting: '::text || a.title) AS name,
    COALESCE(a.starttime, (now())::timestamp without time zone) AS event_date,
    personnel_catalogue.ldap,
    3 AS type,
    NULL::integer AS piz,
    NULL::text AS tooltip,
    personnel_catalogue.ldap AS ldap_unfiltered
   FROM (( SELECT DISTINCT team_meetings.title,
            COALESCE(meeting_attendees.idattendee, group_assignments.idpersonnel) AS idpersonnel,
            team_meetings.starttime,
            team_meetings.stoptime
           FROM ((team_meetings
             JOIN group_assignments ON ((group_assignments.idgroup = team_meetings.idgroup)))
             LEFT JOIN meeting_attendees ON ((meeting_attendees.idmeeting = team_meetings.id)))) a
     JOIN personnel_catalogue ON ((personnel_catalogue.id = a.idpersonnel)))
  ORDER BY 2;


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
  WHERE ((NOT ((full_billing_list.id)::text IN ( SELECT unnest(regexp_split_to_array(( SELECT textcat_all(COALESCE(billings.visit_ids, ''::text)) AS ids
                   FROM billings
                  WHERE (billings.idtrial = full_billing_list.idtrial)), '[, ]+'::text)) AS unnest))) AND (full_billing_list.visit_date < now()));


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
-- Name: meeting_attendees_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE meeting_attendees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.meeting_attendees_id_seq OWNER TO postgres;

--
-- Name: meeting_attendees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE meeting_attendees_id_seq OWNED BY meeting_attendees.id;


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
    base_cost double precision,
    widgetclassname text,
    widgetparameters text
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
-- Name: team_meetings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE team_meetings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.team_meetings_id_seq OWNER TO postgres;

--
-- Name: team_meetings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE team_meetings_id_seq OWNED BY team_meetings.id;


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
-- Name: unbilled_visits; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW unbilled_visits AS
 SELECT DISTINCT all_trials.idgroup,
    all_trials.name,
    a.idtrial,
    a.first_visit,
    a.last_visit,
    a.number_visits,
    a.amount,
    personnel_catalogue.ldap
   FROM (((( SELECT list_for_billing.idtrial,
            min(list_for_billing.visit_date) AS first_visit,
            max(list_for_billing.visit_date) AS last_visit,
            count(*) AS number_visits,
            sum(list_for_billing.reimbursement) AS amount
           FROM list_for_billing
          WHERE (list_for_billing.visit_date < now())
          GROUP BY list_for_billing.idtrial) a
     JOIN all_trials ON ((all_trials.id = a.idtrial)))
     JOIN group_assignments ON ((group_assignments.idgroup = all_trials.idgroup)))
     JOIN personnel_catalogue ON ((personnel_catalogue.id = group_assignments.idpersonnel)))
  WHERE ((COALESCE(a.first_visit, a.last_visit) IS NOT NULL) AND (a.amount > (0)::numeric))
  ORDER BY all_trials.idgroup, a.first_visit;


ALTER TABLE public.unbilled_visits OWNER TO root;

--
-- Name: visit_conflicts_overview; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW visit_conflicts_overview AS
 WITH absent_dates AS (
         SELECT ( SELECT min(all_trials_1.id) AS min
                   FROM (all_trials all_trials_1
                     JOIN group_assignments group_assignments_1 ON ((group_assignments_1.idgroup = all_trials_1.idgroup)))
                  WHERE (group_assignments_1.idpersonnel = personnel_catalogue_1_1.id)) AS idtrial,
            personnel_catalogue_1_1.ldap,
            a_1.day AS absent_date,
            personnel_event.comment AS tooltip
           FROM ((personnel_event
             JOIN ( SELECT day.day
                   FROM generate_series(((now())::date - '1 year'::interval), ((now())::date + '1 year'::interval), '1 day'::interval) day(day)) a_1 ON (((a_1.day >= (personnel_event.start_time)::date) AND (a_1.day <= (personnel_event.end_time)::date))))
             JOIN personnel_catalogue personnel_catalogue_1_1 ON ((personnel_catalogue_1_1.id = personnel_event.idpersonnel)))
        )
 SELECT DISTINCT all_trials.idgroup,
    patient_visits_rich.visit_date,
    personnel_catalogue_1.ldap,
    trial_visits.name,
    patients.piz,
    personnel_catalogue_2.ldap AS ldap_filtering
   FROM (((((((((patient_visits_rich
     JOIN absent_dates ON (((patient_visits_rich.visit_date)::date = (absent_dates.absent_date)::date)))
     JOIN visit_procedures ON ((visit_procedures.idvisit = patient_visits_rich.idvisit)))
     JOIN procedures_personnel_responsible procedures_personnel ON ((procedures_personnel.idprocedure = visit_procedures.id)))
     JOIN personnel_catalogue personnel_catalogue_1 ON ((personnel_catalogue_1.id = procedures_personnel.idpersonnel)))
     JOIN all_trials ON ((all_trials.id = absent_dates.idtrial)))
     JOIN trial_visits ON ((patient_visits_rich.idvisit = trial_visits.id)))
     JOIN patients ON ((patients.id = patient_visits_rich.idpatient)))
     JOIN group_assignments ON ((group_assignments.idgroup = all_trials.idgroup)))
     JOIN personnel_catalogue personnel_catalogue_2 ON ((personnel_catalogue_2.id = group_assignments.idpersonnel)))
  WHERE ((patient_visits_rich.visit_date > now()) AND (personnel_catalogue_1.ldap = absent_dates.ldap))
  ORDER BY personnel_catalogue_1.ldap;


ALTER TABLE public.visit_conflicts_overview OWNER TO root;

--
-- Name: visit_dates; Type: VIEW; Schema: public; Owner: root
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
                          WHERE (personnel_event.type = ANY (ARRAY[1, 3]))) a_2 ON ((personnel_catalogue_1.id = a_2.idpersonnel)))
                  WHERE (((a_2.start_time >= visit_calculator.lower_margin) AND (a_2.start_time <= visit_calculator.upper_margin)) OR ((a_2.end_time >= visit_calculator.lower_margin) AND (a_2.end_time <= visit_calculator.upper_margin)))) a_1
        UNION
         SELECT visit_calculator.idvisit,
            a_1.day AS start_time,
            a_1.day AS end_time
           FROM ((((personnel_event
             JOIN ( SELECT day.day
                   FROM generate_series(((now())::date - '1 year'::interval), ((now())::date + '1 year'::interval), '1 day'::interval) day(day)) a_1 ON ((((a_1.day >= (personnel_event.start_time)::date) AND (a_1.day <= (personnel_event.end_time)::date)) AND (date_part('dow'::text, a_1.day) = ((personnel_event.comment)::integer)::double precision))))
             JOIN procedures_personnel_responsible ON ((procedures_personnel_responsible.idpersonnel = personnel_event.idpersonnel)))
             JOIN visit_procedures ON ((visit_procedures.id = procedures_personnel_responsible.idprocedure)))
             JOIN visit_calculator ON ((visit_calculator._idvisit = visit_procedures.idvisit)))
          WHERE (personnel_event.type = 4)
        )
 SELECT a.idvisit,
    min(a.caldate) AS caldate,
    min(a.startdate) AS startdate,
    a.dcid,
    max(a.missing_service) AS missing_service
   FROM ( SELECT a_1.idvisit,
            a_1.caldate,
            a_1.startdate,
            a_1.dcid,
                CASE
                    WHEN (b.idvisit IS NOT NULL) THEN 'alert'::text
                    ELSE ''::text
                END AS missing_service
           FROM (( SELECT visit_intervals.idvisit,
                    calendar.caldate,
                    calendar.startdate,
                    calendar.dcid
                   FROM (( SELECT visit_calculator.idvisit,
                            visit_calculator.upper_margin,
                            visit_calculator.lower_margin,
                            groups_catalogue.sprechstunde
                           FROM (((visit_calculator
                             JOIN patients ON ((visit_calculator.idpatient = patients.id)))
                             JOIN all_trials ON ((all_trials.id = patients.idtrial)))
                             JOIN groups_catalogue ON ((groups_catalogue.id = all_trials.idgroup)))) visit_intervals
                     JOIN calendar ON ((((calendar.caldate >= visit_intervals.lower_margin) AND (calendar.caldate <= visit_intervals.upper_margin)) AND (calendar.source = visit_intervals.sprechstunde))))) a_1
             LEFT JOIN ( SELECT DISTINCT absent_intervals.idvisit,
                    absent_intervals.start_time,
                    absent_intervals.end_time
                   FROM absent_intervals) b ON ((((a_1.idvisit = b.idvisit) AND (a_1.caldate >= b.start_time)) AND (a_1.caldate <= b.end_time))))) a
  GROUP BY a.idvisit, a.dcid;


ALTER TABLE public.visit_dates OWNER TO root;

--
-- Name: visit_procedure_values; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE visit_procedure_values (
    id integer NOT NULL,
    idvisit_procedure integer,
    idpatient_visit integer,
    value_scalar text,
    value_full text
);


ALTER TABLE public.visit_procedure_values OWNER TO postgres;

--
-- Name: visit_procedure_values_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE visit_procedure_values_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.visit_procedure_values_id_seq OWNER TO postgres;

--
-- Name: visit_procedure_values_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE visit_procedure_values_id_seq OWNED BY visit_procedure_values.id;


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
    procedures_catalogue.name AS procedure_name,
    visit_procedures.ordering,
    visit_procedures.parameter
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
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY meeting_attendees ALTER COLUMN id SET DEFAULT nextval('meeting_attendees_id_seq'::regclass);


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

ALTER TABLE ONLY team_meetings ALTER COLUMN id SET DEFAULT nextval('team_meetings_id_seq'::regclass);


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
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY visit_procedure_values ALTER COLUMN id SET DEFAULT nextval('visit_procedure_values_id_seq'::regclass);


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
197	1	Demo 11002Xa	\N	\N
25	1	Demo 11001Xxx	\N	\N
\.


--
-- Name: all_trials_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('all_trials_id_seq', 200, true);


--
-- Data for Name: bic_catalogue; Type: TABLE DATA; Schema: public; Owner: root
--

COPY bic_catalogue ("row.names", blz, name, bic) FROM stdin;
\.


--
-- Data for Name: billings; Type: TABLE DATA; Schema: public; Owner: root
--

COPY billings (id, idtrial, creation_date, start_date, end_date, comment, visit_ids, amount, visit_ids_travel_costs) FROM stdin;
220	25	2014-11-29 19:12:06.60125	2015-02-28 19:12:06.60125	\N	\N	\N	\N	\N
\.


--
-- Name: billings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('billings_id_seq', 220, true);


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
-- Data for Name: meeting_attendees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY meeting_attendees (id, start_time_proposal, stop_time_proposal, comment, idattendee, idmeeting) FROM stdin;
\.


--
-- Name: meeting_attendees_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('meeting_attendees_id_seq', 1, false);


--
-- Data for Name: patient_visits; Type: TABLE DATA; Schema: public; Owner: root
--

COPY patient_visits (id, idpatient, idvisit, visit_date, state, travel_costs, date_reimbursed, travel_comment, travel_additional_costs, actual_costs) FROM stdin;
3787	609	\N	2014-11-05 00:00:00	\N	\N	\N	\N	\N	\N
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
3813	608	7	\N	\N	\N	\N	\N	\N	\N
\.


--
-- Name: patient_visits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('patient_visits_id_seq', 3813, true);


--
-- Data for Name: patients; Type: TABLE DATA; Schema: public; Owner: root
--

COPY patients (id, idtrial, piz, code1, code2, comment, state, name, givenname, birthdate, street, zip, town, telephone, insertion_date, female, iban, bic, bank, travel_distance) FROM stdin;
609	197	\N	\N	\N	\N	\N	xxx	\N	\N	\N	\N	\N	\N	2014-11-17	\N	\N	\N	\N	\N
612	25	4	\N	\N	\N	\N	test43	\N	\N	\N	\N	\N	\N	2014-11-17	\N	\N	\N	\N	\N
613	25	5	\N	\N	\N	\N	test5	\N	\N	\N	\N	\N	\N	2014-11-17	\N	\N	\N	\N	\N
614	25	6	\N	\N	\N	\N	test6	\N	\N	\N	\N	\N	\N	2014-11-17	\N	\N	\N	\N	\N
610	25	2	\N	\N	\N	\N	test2	\N	\N	\N	\N	\N	\N	2014-11-17	\N	\N	\N	\N	\N
611	25	3	\N	\N	\N	\N	test3	\N	\N	\N	\N	\N	\N	2014-11-17	\N	\N	\N	\N	\N
608	25	1	\N	\N	\N	4	Test	\N	\N	\N	\N	\N	\N	2014-11-13	\N	\N	\N	\N	10
\.


--
-- Name: patients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('patients_id_seq', 614, true);


--
-- Data for Name: personnel_catalogue; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY personnel_catalogue (id, name, ldap, email, function, tel, level, abrechnungsname, password) FROM stdin;
36	Mickey Mouse	mm	\N	\N	\N	\N	\N	\N
37	Icaljoe	ics	\N	\N	\N	\N	\N	\N
1	I am the PI	pi	my.email@xx.com	Pruefarzt	\N	3	\N	\N
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
1	Urlaub genehmigt
2	Urlaub geplant
3	Audit/Monitoring
4	Abwesenheitstage (1=Mo)
\.


--
-- Name: personnel_event_catalogue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('personnel_event_catalogue_id_seq', 4, true);


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

COPY procedures_catalogue (id, name, type, base_cost, widgetclassname, widgetparameters) FROM stdin;
11	Subjektive Refraktionsbestimmung mit sphärischen Gläsern	1	7.91000000000000014	\N	\N
12	Subjektive Refraktionsbestimmung mit sphärisch-zylindrischen Gläsern	1	11.9399999999999995	\N	\N
163	IOLMaster biomerty	\N	50	\N	\N
13	Objektive Refraktionsbestimmung mittels Skiaskopie oder Anwendung eines Refraktometers	1	9.91000000000000014	\N	\N
14	Messung der Maximal- oder Gebrauchsakkommodation mittels Akkommodometer oder Optometer	1	8.05000000000000071	\N	\N
15	Messung der Hornhautkrümmungsradien	1	6.03000000000000025	\N	\N
16	Prüfung von Mehrstärken- oder Prismenbrillen mit Bestimmung der Fern- und Nahpunkte bei subjektiver Brillenunverträglichkeit	1	9.38000000000000078	\N	\N
17	Nachweis der Tränensekretionsmenge (z. B. Schirmer-Test)	1	2.68999999999999995	\N	\N
164	eCRF-Pauschale 30min	\N	50	\N	\N
153	UCVA standard 1M 2 eyes	\N	18	\N	\N
23	Untersuchung auf Heterophorie bzw. Strabismus gegebenenfalls einschließlich qualitativer Untersuchung des binokularen Sehaktes	1	12.1899999999999995	\N	\N
24	Qualitative und quantitative Untersuchung des binokularen Sehaktes	1	32.4500000000000028	\N	\N
25	Differenzierende Analyse und graphische Darstellung des Bewegungsablaufs beider Augen bei Augenmuskelstörungen, mindestens 36 Blickrichtungen pro Auge	1	93.8400000000000034	\N	\N
26	Kampimetrie (z. B. Bjerrum) auch Perimetrie nach Förster	1	16.2199999999999989	\N	\N
27	Projektionsperimetrie mit Marken verschiedener Reizwerte	1	24.3999999999999986	\N	\N
28	Quantitativ abgestufte (statische) Profilperimetrie	1	33.259999999999998	\N	\N
29	Farbsinnprüfung mit Pigmentproben (z. B. Farbtafeln)	1	8.1899999999999995	\N	\N
30	Farbsinnprüfung mit Anomaloskop	1	24.3999999999999986	\N	\N
31	Vollständige Untersuchung des zeitlichen Ablaufs der Adaptation	1	64.8799999999999955	\N	\N
32	Untersuchung des Dämmerungssehens ohne Blendung	1	12.1899999999999995	\N	\N
33	Untersuchung des Dämmerungssehens während der Blendung	1	12.1899999999999995	\N	\N
34	Untersuchung des Dämmerungssehens nach der Blendung (Readaptation)	1	12.1899999999999995	\N	\N
35	Elektroretinographische Untersuchung (ERG) und/oder elektrookulographische Untersuchung (EOG)	1	80.4300000000000068	\N	\N
36	Spaltlampenmikroskopie der vorderen und mittleren Augenabschnitte gegebenenfalls einschließlich der binokularen Untersuchung des hinteren Poles (z. B. Hruby-Linse)	1	9.91000000000000014	\N	\N
37	Gonioskopie	1	20.379999999999999	\N	\N
38	Binokulare Untersuchung des Augenhintergrundes einschließlich der äußeren Peripherie (z. B. Dreispiegelkontaktglas, Schaepens) gegebenenfalls einschließlich der Spaltlampenmikroskopie der vorderen und mittleren Augenabschnitte und/oder diasklerale Durchleuchtung	1	20.379999999999999	\N	\N
39	Diasklerale Durchleuchtung	1	8.1899999999999995	\N	\N
40	Exophthalmometrie	1	6.69000000000000039	\N	\N
41	Fluoreszenzuntersuchung der terminalen Strombahn am Augenhintergrund einschließlich Applikation des Teststoffes	1	32.4500000000000028	\N	\N
42	Fluoreszenzangiographische Untersuchung der terminalen Strombahn am Augenhintergrund einschließlich Aufnahmen und Applikation des Teststoffes	1	64.8799999999999955	\N	\N
155	UCVA standard 1M binocular	\N	15	\N	\N
152	UCVA standard 4M binocular	\N	15	\N	\N
45	Fotographische Verlaufskontrolle intraokularer Veränderungen mittels Spaltlampenfotographie	1	13.4100000000000001	\N	\N
46	Fotographische Verlaufskontrolle von Veränderungen des Augenhintergrunds mittels Fundusfotographie	1	20.1000000000000014	\N	\N
47	Tonometrische Untersuchung mit Anwendung des Impressionstonometers	1	7.33999999999999986	\N	\N
48	Tonometrische Untersuchung mit Anwendung des Applanationstonometers	1	10.4900000000000002	\N	\N
49	Tonometrische Untersuchung (mehrfach in zeitlichem Zusammenhang zur Anfertigung tonometrischer Kurven, mindestens vier Messungen) auch fortlaufende Tonometrie zur Ermittlung des Abflußwiderstandes	1	25.3999999999999986	\N	\N
50	Pupillographie	1	25.3999999999999986	\N	\N
51	Elektromyographie der äußeren Augenmuskeln	1	58.75	\N	\N
52	Ophthalmodynamometrie gegebenenfalls einschließlich Tonometrie, erste Messung	1	25.3999999999999986	\N	\N
154	UCVA standard near binocular	\N	15	\N	\N
158	Contrast vision 2 eyes	\N	25	\N	\N
161	Specular microscopy 2 eyes	\N	40	\N	\N
162	AE Interview	\N	20	\N	\N
156	UCVA standard 4M 2 eyes	\N	18	\N	\N
157	UCVA standard near 2 eyes	\N	18	\N	\N
165	eCRF-Pauschale 10min	\N	10	\N	\N
159	Questionnaire interview 5-10 items	\N	50	\N	\N
160	Defocus refraction	\N	120	\N	\N
166	Reticam	\N	15	\N	\N
167	Blutentnahme	\N	15	\N	\N
1	BCVA ETDRS 4M 2 eyes	\N	25	WidgetSimpleString	\N
2	BCVA ETDRS 4M binocular	\N	25	WidgetSimpleString	\N
3	UCVA ETDRS 4M 2 eyes	\N	25	WidgetSimpleString	\N
151	BCVA  1M binocular	\N	15	WidgetSimpleString	\N
150	BCVA standard near binocular	\N	15	WidgetSimpleString	\N
148	BCVA standard near 2 eyes	\N	18	WidgetSimpleString	\N
147	BCVA standard 4M binocular	\N	15	WidgetSimpleString	\N
146	BCVA standard 4M 2 eyes	\N	18	WidgetSimpleString	\N
145	UCVA ETDRS 4M binocular	\N	20	WidgetSimpleString	\N
144	UCVA ETDRS near 2 eyes	\N	25	WidgetSimpleString	\N
143	BCVA standard 1M 2 eyes	\N	18	WidgetSimpleString	\N
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

SELECT pg_catalog.setval('status_catalogue_id_seq', 515, true);


--
-- Data for Name: team_meetings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY team_meetings (id, starttime, stoptime, title, idgroup) FROM stdin;
\.


--
-- Name: team_meetings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('team_meetings_id_seq', 1, false);


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
749	25	11	2014-09-01	2014-07-31	\N	\N	\N
465	25	12	2014-02-25	\N	\N	2	\N
850	195	11	2014-11-16	\N	\N	\N	\N
851	196	11	2014-11-16	\N	\N	\N	\N
852	197	11	2014-11-17	\N	\N	\N	\N
627	25	12	2014-05-06	2014-05-07	\N	\N	\N
750	25	17	2014-07-31	2029-07-31	\N	\N	\N
\.


--
-- Name: trial_process_step_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('trial_process_step_id_seq', 855, true);


--
-- Data for Name: trial_properties; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY trial_properties (id, idtrial, idproperty, value) FROM stdin;
5509	25	23	indoka
5398	195	25	\N
5399	195	26	\N
5400	195	27	\N
5401	195	11	\N
5402	195	17	\N
5403	195	33	\N
5404	195	31	\N
5405	195	34	\N
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
5476	197	18	\N
5477	197	34	\N
5478	197	12	\N
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
5507	25	62	
5487	197	24	2134aaa
5503	197	23	
5508	25	24	
5513	25	25	
5562	25	42	
5563	25	43	\\documentclass{scrreprt}\r\\usepackage[ngerman]{babel}\r\\usepackage[utf8]{inputenc}\r\\usepackage[T1]{fontenc}\r\\usepackage{graphicx}\r\\usepackage{wallpaper}\r\\usepackage{tabularx}\r\r\r\\renewcommand{\\familydefault}{\\sfdefault}\r\\usepackage{helvet}\r\r\\pagenumbering{none}\r\r\r\\begin{document}\r\\baselineskip15pt\r\\setlength{\\headheight}{7\\baselineskip}\r\\setlength{\\oddsidemargin}{-3mm}\r\\addtolength{\\textwidth}{2cm}\r\r<foreach:patients>\r\r\\ThisCenterWallPaper{1}{<copytex:briefkopfAdresszeile3.pdf>}\r\r\\noindent <anrede1>\\\\\r\\noindent <givenname> <name>\\\\\r\\noindent <street> \\\\\r\\noindent <zip> <town> \\\\\r\\\\ \\\\\r\\hspace*{11.0cm}  Freiburg, <today>\\\\\r\r\\noindent Datenschutzerkl"arung in der klinischen Studie {\\it <Voller Titel>}\\\\\r\r\\noindent  Sehr geehrte<anrede2>, <name>,\\\\\r\r\\noindent hiermit m"ochten wir Sie dar"uber informieren, dass ....\\\\\\\\\r\r\\noindent Mit freundlichen Gr"u"sen, \\\\ \\\\\r\r\\hspace*{-7mm}  \\begin{tabularx}{20cm}{XX}\r<_Loginname_>\\\\\r<_Loginrole_> \\\\\r\\end{tabularx}\r\r\\newpage\r\r</foreach:patients>\r\r\r\\end{document}\r
5479	197	31	
5515	25	29	sdjfklnsdf xx yy
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

SELECT pg_catalog.setval('trial_properties_id_seq', 5656, true);


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
300	\N	197	\N	4 days	\N	\N	12	\N	\N	\N
7	Baseline	25	\N	00:00:00	00:00:00	00:00:00	588	\N	\N	\N
8	Unschelduled	25	\N	00:00:00	-2 years	2 years	154	\N	\N	\N
6	Visit 2	25	7	30 days	7 days	7 days	448	\N	\N	\N
9	Vis 3	25	7	60 days	7 days	7 days	448	\N	\N	\N
10	Vis 4/ Early Exit	25	7	90 days	7 days	7 days	476	\N	\N	\N
\.


--
-- Name: trial_visits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('trial_visits_id_seq', 300, true);


--
-- Data for Name: visit_procedure_values; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY visit_procedure_values (id, idvisit_procedure, idpatient_visit, value_scalar, value_full) FROM stdin;
2	133	3813	\N	\N
\.


--
-- Name: visit_procedure_values_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('visit_procedure_values_id_seq', 2, true);


--
-- Data for Name: visit_procedures; Type: TABLE DATA; Schema: public; Owner: root
--

COPY visit_procedures (id, idvisit, idprocedure, actual_cost, ordering, parameter) FROM stdin;
141	7	51	\N	2	\N
133	7	151	\N	1	\N
120	\N	\N	\N	\N	\N
136	299	162	\N	\N	\N
139	5	15	\N	\N	\N
140	5	162	\N	\N	\N
\.


--
-- Name: visit_procedures_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('visit_procedures_id_seq', 142, true);


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
-- Name: meeting_attendees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY meeting_attendees
    ADD CONSTRAINT meeting_attendees_pkey PRIMARY KEY (id);


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
-- Name: team_meetings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY team_meetings
    ADD CONSTRAINT team_meetings_pkey PRIMARY KEY (id);


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
-- Name: visit_procedure_values_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY visit_procedure_values
    ADD CONSTRAINT visit_procedure_values_pkey PRIMARY KEY (id);


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
-- Name: meeting_attendees_idattendee_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY meeting_attendees
    ADD CONSTRAINT meeting_attendees_idattendee_fkey FOREIGN KEY (idattendee) REFERENCES personnel_catalogue(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: meeting_attendees_idmeeting_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY meeting_attendees
    ADD CONSTRAINT meeting_attendees_idmeeting_fkey FOREIGN KEY (idmeeting) REFERENCES team_meetings(id) ON UPDATE CASCADE ON DELETE CASCADE;


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
-- Name: team_meetings_idgroup_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY team_meetings
    ADD CONSTRAINT team_meetings_idgroup_fkey FOREIGN KEY (idgroup) REFERENCES groups_catalogue(id) ON UPDATE CASCADE ON DELETE CASCADE;


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
-- Name: visit_procedure_values_idpatient_visit_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY visit_procedure_values
    ADD CONSTRAINT visit_procedure_values_idpatient_visit_fkey FOREIGN KEY (idpatient_visit) REFERENCES patient_visits(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: visit_procedure_values_idvisit_procedure_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY visit_procedure_values
    ADD CONSTRAINT visit_procedure_values_idvisit_procedure_fkey FOREIGN KEY (idvisit_procedure) REFERENCES visit_procedures(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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

