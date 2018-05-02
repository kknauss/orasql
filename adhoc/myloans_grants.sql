SELECT *
FROM DBA_SYNONYMS
WHERE TABLE_OWNER IN ('MYLOANS')
ORDER BY TABLE_OWNER, TABLE_NAME;

SELECT 'CREATE PUBLIC SYNONYM '||OBJECT_NAME||' FOR '||owner||'.'||OBJECT_NAME||';'
FROM DBA_OBJECTS
WHERE (OBJECT_TYPE IN ('TABLE','VIEW','PROCEDURE','FUNCTION','PACKAGE','SEQUENCE'))
AND OWNER IN ('MYLOANS')
AND (OBJECT_NAME NOT LIKE 'TMP%')
AND (OBJECT_NAME NOT IN (SELECT SYNONYM_NAME FROM ALL_SYNONYMS WHERE OWNER = 'PUBLIC'));

--==============================================================================
-- MYLOANS
--==============================================================================
--TABLES
SELECT 'grant select on '||OWNER||'.'||TABLE_NAME    ||' to MYLOANS_USER;' FROM DBA_TABLES    WHERE OWNER = 'MYLOANS'
MINUS
select 'grant select on '||owner||'.'||table_name    ||' to MYLOANS_USER;' from dba_tab_privs where owner = 'MYLOANS' and privilege = 'SELECT' and grantee = 'MYLOANS_USER';

select 'grant insert on '||owner||'.'||table_name    ||' to MYLOANS_USER;' from dba_tables    where owner = 'MYLOANS'
MINUS
select 'grant insert on '||owner||'.'||table_name    ||' to MYLOANS_USER;' from dba_tab_privs where owner = 'MYLOANS' and privilege = 'INSERT' and grantee = 'MYLOANS_USER';

SELECT 'grant update on '||owner||'.'||TABLE_NAME    ||' to MYLOANS_USER;' FROM DBA_TABLES    WHERE OWNER = 'MYLOANS'
MINUS
SELECT 'grant update on '||OWNER||'.'||TABLE_NAME    ||' to MYLOANS_USER;' FROM DBA_TAB_PRIVS WHERE OWNER = 'MYLOANS' AND PRIVILEGE = 'UPDATE' AND GRANTEE = 'MYLOANS_USER';

select 'grant delete on '||owner||'.'||table_name    ||' to MYLOANS_USER;' from dba_tables    where owner = 'MYLOANS'
MINUS
select 'grant delete on '||owner||'.'||table_name    ||' to MYLOANS_USER;' from dba_tab_privs where owner = 'MYLOANS' and privilege = 'DELETE' and grantee = 'MYLOANS_USER';


--SEQUENCES
SELECT 'grant select on '||SEQUENCE_OWNER||'.'||SEQUENCE_NAME ||' to MYLOANS_USER;' FROM DBA_SEQUENCES WHERE SEQUENCE_OWNER = 'MYLOANS'
MINUS
SELECT 'grant select on '||owner||'.'||TABLE_NAME    ||' to MYLOANS_USER;' from dba_tab_privs where          owner = 'MYLOANS' and PRIVILEGE = 'SELECT' AND GRANTEE = 'MYLOANS_USER';


--VIEWS
SELECT 'grant select on '||owner||'.'||VIEW_NAME     ||' to MYLOANS_USER;' FROM DBA_VIEWS     WHERE OWNER = 'MYLOANS'
MINUS
select 'grant select on '||owner||'.'||table_name    ||' to MYLOANS_USER;' from dba_tab_privs where owner = 'MYLOANS' and privilege = 'SELECT' and grantee = 'MYLOANS_USER';


--PACKAGES, PROCEDURES and FUNCTIONS
select 'grant EXECUTE on '||owner||'.'||OBJECT_name  ||' to MYLOANS_USER;' from dba_objects where OWNER = 'MYLOANS' and OBJECT_TYPE IN ('PROCEDURE','FUNCTION','PACKAGE')
MINUS
select 'grant EXECUTE on '||owner||'.'||table_name   ||' to MYLOANS_USER;' from dba_tab_privs where owner = 'MYLOANS' and privilege = 'EXECUTE' and grantee = 'MYLOANS_USER';