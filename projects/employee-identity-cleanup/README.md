# Project 1 – Employee Identity Cleanup (Beginner MDM/Data Quality Project)

## 🎯 Goal (In My Own Words)

This small project simulates a simple **employee data feed** that has:

- Duplicate employees
- Inconsistent capitalization
- Extra spaces
- Conflicting department values

The goal is to practice:

- Detecting duplicates
- Standardizing data
- Selecting a “best” record per identity
- Producing a cleaner, de-duplicated table

This is a beginner project. I am still learning Oracle, SQL, and MDM concepts. The purpose is to show my **hands-on learning progress**, not to pretend I’m a senior DBA.

---

## 🧱 Tables Used

### 1. `employee_raw`

Represents messy incoming HR data.

Example columns:

- `id` – technical ID of the row (surrogate key)
- `full_name` – employee name (may be inconsistent)
- `email` – used as a simple identity key in this project
- `department` – may conflict across rows
- `source_system` – where the record came from (`HR_APP`, `MANUAL_ENTRY`, etc.)

This table simulates what you might get from **multiple source systems** before MDM cleans it.

### 2. `employee_clean`

Represents a **cleaner version** of the data where:

- Each email appears once
- One record is chosen as the “keeper”
- Duplicates are removed using `ROW_NUMBER`

This is a simplified version of a **“golden record”** concept that MDM systems aim for.

---

## 🧪 What I Practice in This Project

- Creating a raw “staging” table
- Inserting messy data on purpose
- Finding duplicates using:
  - `GROUP BY` + `HAVING`
  - `ROW_NUMBER() OVER (PARTITION BY ...)`
- Creating a clean table from raw data
- Keeping only `rn = 1` (first record per identity)
- Checking results with simple queries

---

## 🔧 How to Run This Project (High Level)

1. Connect to my Oracle PDB (FREEPDB1) as my lab user.
2. Run the SQL script:
   - `project1_employee_identity_cleanup.sql`
3. Review the outputs of:
   - Duplicate detection queries
   - The final `employee_clean` table

This project lives under:

```text
projects/employee-identity-cleanup/
  ├── README.md
  └── project1_employee_identity_cleanup.sql
