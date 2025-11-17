------------------------------------------------------------------------
-- Project 1 – Employee Identity Cleanup (Beginner MDM/Data Quality)
-- Author : Rafael Nina
-- DB     : Oracle 23ai Free, PDB FREEPDB1
-- Note   : This is practice, not production code.
------------------------------------------------------------------------

-- OPTIONAL: cleanup if you rerun the script
-- drop table employee_clean;
-- drop table employee_raw;

------------------------------------------------------------------------
-- 1. Create the RAW table with messy employee data
------------------------------------------------------------------------

create table employee_raw (
    id           number primary key,
    full_name    varchar2(100),
    email        varchar2(100),
    department   varchar2(50),
    source_system varchar2(50)
);

------------------------------------------------------------------------
-- 2. Insert messy data (duplicates, inconsistent formatting)
------------------------------------------------------------------------

insert into employee_raw values (1, 'Rafael Nina',      'rafael.nina@example.com',   'IT',       'HR_APP');
insert into employee_raw values (2, 'RAFAEL  NINA',    'RAFAEL.NINA@example.com',   'IT',       'MANUAL_ENTRY');
insert into employee_raw values (3, 'R. Nina',         'rafael.nina@example.com ',  'IT-OPS',   'LEGACY_FEED');

insert into employee_raw values (4, 'Nina Lopez',      'nina.lopez@example.com',    'HR',       'HR_APP');
insert into employee_raw values (5, 'NINA LOPEZ',      ' NINA.LOPEZ@example.com',   'HumanRes', 'LEGACY_FEED');

insert into employee_raw values (6, 'Jordan Smith',    'j.smith@example.com',       'Finance',  'HR_APP');
insert into employee_raw values (7, 'JORDAN SMITH',    'J.SMITH@example.com',       'FIN',      'MANUAL_ENTRY');

commit;

------------------------------------------------------------------------
-- 3. Basic view of RAW data
------------------------------------------------------------------------

prompt === All rows from employee_raw ===

select *
from   employee_raw
order  by id;

------------------------------------------------------------------------
-- 4. Standardize email for comparison
--    We'll lower-case and trim spaces when checking duplicates.
------------------------------------------------------------------------

prompt === Email counts by normalized email (lower + trim) ===

select lower(trim(email)) as norm_email,
       count(*)           as cnt
from   employee_raw
group  by lower(trim(email))
having count(*) > 1
order  by cnt desc;

------------------------------------------------------------------------
-- 5. Use ROW_NUMBER to mark the "keeper" and the duplicates
------------------------------------------------------------------------

prompt === Row numbers per identity (normalized email) ===

select id,
       full_name,
       email,
       department,
       source_system,
       row_number() over (
         partition by lower(trim(email))
         order by id
       ) as rn
from   employee_raw
order  by lower(trim(email)), id;

------------------------------------------------------------------------
-- 6. Create the CLEAN table keeping only rn = 1 per identity
------------------------------------------------------------------------

create table employee_clean as
select id,
       full_name,
       email,
       department,
       source_system
from (
  select id,
         full_name,
         email,
         department,
         source_system,
         row_number() over (
           partition by lower(trim(email))
           order by id
         ) as rn
  from   employee_raw
)
where rn = 1;

------------------------------------------------------------------------
-- 7. View the CLEAN result
------------------------------------------------------------------------

prompt === Final clean employee table (one row per identity) ===

select *
from   employee_clean
order  by id;

------------------------------------------------------------------------
-- 8. Compare counts: raw vs clean
------------------------------------------------------------------------

prompt === Row counts: RAW vs CLEAN ===

select 'EMPLOYEE_RAW'   as table_name, count(*) as row_count from employee_raw
union all
select 'EMPLOYEE_CLEAN' as table_name, count(*) as row_count from employee_clean;
