# Lab 1 – CDB / PDB Architecture

## 🔍 Objective
Understand how Oracle 23ai Free uses a **Container Database (CDB)** and **Pluggable Databases (PDBs)** and how to navigate, verify open modes, and switch between containers.

---

## 🧩 What You Learned

### ✔ What a CDB is
A Container Database that holds:
- The **root container (CDB$ROOT)**  
- The **seed container (PDB$SEED)**  
- One or more **Pluggable Databases (PDBs)** like **FREEPDB1**

### ✔ Why Oracle Uses PDBs
PDBs isolate workloads — just like real enterprise Multi-Tenant architecture:
- Better security boundaries  
- Easier patching  
- Each application gets its own “mini-database”  

---

## 🖥 Commands Used

### 🔹 Check the instance name and status
```sql
select instance_name, status from v$instance;
select con_id, name, open_mode from v$pdbs;
show con_name;
alter session set container=FREEPDB1;
sqlplus sys/oracle@localhost:1521/freepdb1 as sysdba;
