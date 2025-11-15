-- Lab 3 - Joins, Aggregation, Window Functions, and De-duplication
-- Author : Rafael Nina
-- DB     : Oracle 23ai Free, PDB FREEPDB1, schema RNINA

--------------------------------------------------------------------
-- 0. Sanity checks: where am I?
--------------------------------------------------------------------
show con_name;
show user;

--------------------------------------------------------------------
-- 1. Standard JOIN: employees + departments
--------------------------------------------------------------------
select e.id,
       e.name,
       e.salary,
       e.department,
       d.dept_id,
       d.dept_name
from   employees e
       join departments d
         on e.department = d.dept_name
order  by e.id;

--------------------------------------------------------------------
-- 2. Aggregation: headcount and average salary per department
--------------------------------------------------------------------
select department,
       count(*)        as emp_count,
       avg(salary)     as avg_salary
from   employees
group  by department
order  by department;

--------------------------------------------------------------------
-- 3. Find duplicate names (same name appears more than once)
--------------------------------------------------------------------
select name,
       count(*) as cnt
from   employees
group  by name
having count(*) > 1
order  by name;

--------------------------------------------------------------------
-- 4. Use ROW_NUMBER to tag duplicates
--    rn = 1  -> "keeper" row for that name
--    rn > 1  -> duplicate rows
--------------------------------------------------------------------
select id,
       name,
       salary,
       department,
       rowid,
       row_number() over (
         partition by name
         order by id
       ) as rn
from   employees
order  by name, id;

--------------------------------------------------------------------
-- 5. Show only the duplicate rows (rn > 1)
--------------------------------------------------------------------
select id,
       name,
       rowid
from (
  select id,
         name,
         rowid,
         row_number() over (
           partition by name
           order by id
         ) as rn
  from   employees
)
where rn > 1
order by name, id;

--------------------------------------------------------------------
-- 6. DELETE the duplicate rows, keep the first row per name
--    WARNING: This actually deletes data.
--    Logic: For each name, keep rn = 1, delete rn > 1.
--------------------------------------------------------------------
delete from employees
where rowid in (
  select rowid
  from (
    select rowid,
           row_number() over (
             partition by name
             order by id
           ) as rn
    from employees
  )
  where rn > 1
);

commit;

--------------------------------------------------------------------
-- 7. Final check: clean table, no duplicate names
--------------------------------------------------------------------
select *
from   employees
order  by id;
