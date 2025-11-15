🧪 Lab 2 – Schema Design & Primary Keys / Foreign Keys
🎯 Objective

Build a real enterprise-style schema for MDM-style data:

Create an employees table

Create a departments table

Add constraints (PK, CHECK)

Add a sequence for auto-increment IDs

Add a Foreign Key to link employees → departments

📝 What You Learned
✔️ How to design tables with constraints

PRIMARY KEY

NOT NULL

CHECK (salary > 0)

✔️ How to create a sequence

Used for auto-incrementing IDs:

create sequence emp_seq start with 1 increment by 1;

✔️ How to insert rows using the sequence
insert into employees values (emp_seq.nextval, 'Nina', 110000, 'HR');

✔️ How to design a parent table and build a relationship

departments is the parent

employees.department references it

🔧 Commands Used
1. Create employees table
create table employees (
  id number primary key,
  name varchar2(50) not null,
  salary number check (salary > 0),
  department varchar2(20)
);

2. Create sequence
create sequence emp_seq start with 1 increment by 1;

3. Insert sample rows
insert into employees values (emp_seq.nextval, 'Rafael', 90000, 'IT');
insert into employees values (emp_seq.nextval, 'Nina', 110000, 'HR');
insert into employees values (emp_seq.nextval, 'Jordan', 85000, 'Finance');

4. Create parent table
create table departments (
  dept_id number primary key,
  dept_name varchar2(50) not null
);

5. Insert departments
insert into departments values (10, 'IT');
insert into departments values (20, 'HR');
insert into departments values (30, 'Finance');

6. Add the Foreign Key
alter table departments
  add constraint dept_name_uk unique (dept_name);

alter table employees
  add constraint emp_dept_fk
    foreign key (department)
    references departments(dept_name);

🧹 Data Quality Fixes

You fixed:

Duplicate department spellings (finance vs Finance)

Enforced unique department names

Cleaned up incorrect values

🧾 Final Joined Output

You ran:

select e.id, e.name, e.salary, e.department,
       d.dept_id, d.dept_name
from employees e
join departments d
  on e.department = d.dept_name;


Showing:

Employee + correct department → proper relational integrity.

------------------------------------------------------------------------
-- Lab 2 - Schema Design: Employees & Departments
-- Author: Rafael Nina
-- Purpose: Practice relational design, constraints, and sequences
------------------------------------------------------------------------

-- OPTIONAL: Clean up if you need to rerun this script
-- (Uncomment these if the objects already exist)
-- drop table employees cascade constraints;
-- drop table departments cascade constraints;
-- drop sequence emp_seq;

------------------------------------------------------------------------
-- 1. Create parent table: DEPARTMENTS
--    - One row per department
--    - dept_id = primary key
--    - dept_name = business key (unique)
------------------------------------------------------------------------

create table departments (
    dept_id   number       primary key,
    dept_name varchar2(50) not null
);

-- Make sure department names are unique (no duplicates like 'finance' vs 'Finance')
alter table departments
  add constraint dept_name_uk unique (dept_name);

------------------------------------------------------------------------
-- 2. Create child table: EMPLOYEES
--    - id = primary key
--    - name = required
--    - salary = must be > 0
--    - department = references DEPARTMENTS.dept_name
------------------------------------------------------------------------

create table employees (
    id         number        primary key,
    name       varchar2(50)  not null,
    salary     number        check (salary > 0),
    department varchar2(50)
);

-- Foreign key: every employee.department must exist in departments.dept_name
alter table employees
  add constraint emp_dept_fk
    foreign key (department)
    references departments(dept_name);

------------------------------------------------------------------------
-- 3. Sequence for auto-increment employee IDs
------------------------------------------------------------------------

create sequence emp_seq
  start with 1
  increment by 1
  nocache;

------------------------------------------------------------------------
-- 4. Seed data
------------------------------------------------------------------------

-- Departments
insert into departments (dept_id, dept_name) values (10, 'IT');
insert into departments (dept_id, dept_name) values (20, 'HR');
insert into departments (dept_id, dept_name) values (30, 'Finance');

-- Employees (using sequence for IDs)
insert into employees (id, name, salary, department)
values (emp_seq.nextval, 'Rafael',  90000,  'IT');

insert into employees (id, name, salary, department)
values (emp_seq.nextval, 'Nina',   110000,  'HR');

insert into employees (id, name, salary, department)
values (emp_seq.nextval, 'Jordan',  85000,  'Finance');

commit;

------------------------------------------------------------------------
-- 5. Verification Queries
------------------------------------------------------------------------

-- See all departments
select * from departments order by dept_id;

-- See all employees
select * from employees order by id;

-- Join employees to departments (classic parent/child relationship)
select
    e.id,
    e.name,
    e.salary,
    e.department,
    d.dept_id,
    d.dept_name
from employees   e
join departments d
  on e.department = d.dept_name
order by e.id;
