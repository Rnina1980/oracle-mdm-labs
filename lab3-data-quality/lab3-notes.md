Lab 3 – Joins, Aggregation, Window Functions, and Data De-duplication
🎯 Objective

Learn how to:

Join related tables

Use GROUP BY and HAVING

Perform aggregation analysis

Identify and remove duplicate records

Use analytic window functions (ROW_NUMBER)

Produce clean, master-quality datasets

These skills are directly used in:

MDM (Master Data Management)

Identity resolution

Data quality pipelines

Cybersecurity auditing (duplicate user accounts, ghost accounts, conflicting access)

📘 What You Learned
1. Standard JOINs

You combined employees with departments:

select e.id, e.name, e.salary, e.department, d.dept_id, d.dept_name
from employees e
join departments d
  on e.department = d.dept_name;


This validated referential integrity — checking that each employee truly belongs to a valid department.

2. Aggregation: COUNT + GROUP BY

You found which names appeared more than once:

select name, count(*)
from employees
group by name
having count(*) > 1;


This revealed duplicates:

Jordan

Nina

Rafael

3. Window Functions for De-duplication

You used ROW_NUMBER() to rank duplicates while keeping the earliest row:

select id, name, rowid
from (
  select id, name, rowid,
         row_number() over (partition by name order by id) as rn
  from employees
)
where rn > 1;


This identified the “extra copies” to delete.

4. Delete Duplicates Safely

Using the rowids from above:

delete from employees
where rowid in (
  select rowid
  from (
    select rowid,
           row_number() over (partition by name order by id) as rn
    from employees
  )
  where rn > 1
);


Then you verified:

select * from employees order by id;


Result:
Only one unique record per employee remains.
