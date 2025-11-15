🧩 Oracle MDM & SQL Learning Labs

Hands-on Oracle 23ai Free environment for practicing real MDM (Master Data Management) and SQL DBA fundamentals.

🔹 What this repo contains

This repository documents my journey learning:

Oracle CDB/PDB architecture

SQL schema design

Primary & Foreign Keys

Constraints

Joins

GROUP BY + HAVING

Window functions (ROW_NUMBER)

De-duplication logic

Real MDM data-quality workflows

Everything is built inside Oracle 23ai Free using a PDB (FREEPDB1)—just like real enterprise systems.

🧱 Lab 1 — CDB / PDB Architecture

How to check the instance

How to view pluggable databases

Understanding OPEN READ WRITE vs READ ONLY

Why MDM apps run in a PDB

Connected using:

sql sys/oracle@localhost:1521/freepdb1 as sysdba

🧱 Lab 2 — Schema Design

Created a full employee table with constraints:

create table employees (
  id number primary key,
  name varchar2(50) not null,
  salary number check (salary > 0),
  department varchar2(20)
);


Created a sequence for auto-increment IDs:

create sequence emp_seq start with 1 increment by 1;

🧱 Lab 3 — Referential Integrity

Built a departments table:

create table departments (
  dept_id number primary key,
  dept_name varchar2(50) not null
);


Inserted data and created a foreign key linking employees → departments.

🧱 Lab 4 — Joins, Aggregations, Window Functions

Examples performed:

Inner Join
select e.id, e.name, d.dept_id, d.dept_name
from employees e
join departments d
on e.department = d.dept_name;

GROUP BY + HAVING
select name, count(*)
from employees
group by name
having count(*) > 1;

FIND + DELETE duplicate rows
row_number() over (partition by name order by id)


Then deleted duplicates using ROWID.

🔥 Why this matters (MDM context)

In real Master Data Management, your job is to:

Remove duplicates

Apply data quality rules

Maintain referential integrity

Clean inconsistent data

Ensure master records (customers, employees, assets) are correct

These labs directly map to real MDM job responsibilities.

📌 Next Steps

Add more SQL practice

Add PL/SQL procedures

Build a full MDM workflow

Add scripts for automation

📫 Contact

Rafael Nina
Cybersecurity & Linux Engineer | Data & MDM Enthusiast
LinkedIn: https://www.linkedin.com/in/rafaelnina/
