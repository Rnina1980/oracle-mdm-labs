------------------------------------------------------------------------
-- Lab 2 - Schema Design: Employees & Departments
-- Author: Rafael Nina
-- Purpose: Practice relational design, constraints, and sequences
------------------------------------------------------------------------

-- OPTIONAL: Clean up if you need to rerun this script
-- drop table employees cascade constraints;
-- drop table departments cascade constraints;
-- drop sequence emp_seq;

------------------------------------------------------------------------
-- 1. Create parent table: DEPARTMENTS
------------------------------------------------------------------------

create table departments (
    dept_id   number       primary key,
    dept_name varchar2(50) not null
);

alter table departments
  add constraint dept_name_uk unique (dept_name);

------------------------------------------------------------------------
-- 2. Create child table: EMPLOYEES
------------------------------------------------------------------------

create table employees (
    id         number        primary key,
    name       varchar2(50)  not null,
    salary     number        check (salary > 0),
    department varchar2(50)
);

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
-- 4. Insert sample data
------------------------------------------------------------------------

insert into departments (dept_id, dept_name) values (10, 'IT');
insert into departments (dept_id, dept_name) values (20, 'HR');
insert into departments (dept_id, dept_name) values (30, 'Finance');

insert into employees (id, name, salary, department)
values (emp_seq.nextval, 'Rafael',  90000,  'IT');

insert into employees (id, name, salary, department)
values (emp_seq.nextval, 'Nina',   110000,  'HR');

insert into employees (id, name, salary, department)
values (emp_seq.nextval, 'Jordan',  85000,  'Finance');

commit;

------------------------------------------------------------------------
-- 5. Verification
------------------------------------------------------------------------

select * from departments order by dept_id;
select * from employees order by id;

select
    e.id,
    e.name,
    e.salary,
    e.department,
    d.dept_id,
    d.dept_name
from employees e
join departments d
  on e.department = d.dept_name
order by e.id;
