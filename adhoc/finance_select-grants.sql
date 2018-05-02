SELECT *
FROM DBA_SYNONYMS
WHERE TABLE_OWNER IN ('FINANCE')
ORDER BY TABLE_OWNER, TABLE_NAME;

SELECT 'CREATE PUBLIC SYNONYM '||OBJECT_NAME||' FOR '||owner||'.'||OBJECT_NAME||';'
FROM DBA_OBJECTS
WHERE (OBJECT_TYPE IN ('TABLE','VIEW','PROCEDURE','FUNCTION','PACKAGE','SEQUENCE'))
AND OWNER IN ('FINANCE')
AND (OBJECT_NAME NOT LIKE 'TMP%')
AND (OBJECT_NAME NOT IN (SELECT SYNONYM_NAME FROM ALL_SYNONYMS WHERE OWNER = 'PUBLIC'));

--==============================================================================
-- FINANCE
--==============================================================================
--TABLES
SELECT 'grant select on '||OWNER||'.'||TABLE_NAME    ||' to FINANCE_SELECT;' FROM DBA_TABLES    WHERE OWNER = 'FINANCE'
MINUS
select 'grant select on '||owner||'.'||table_name    ||' to FINANCE_SELECT;' from dba_tab_privs where owner = 'FINANCE' and privilege = 'SELECT' and grantee = 'FINANCE_SELECT';

select 'grant insert on '||owner||'.'||table_name    ||' to FINANCE_SELECT;' from dba_tables    where owner = 'FINANCE'
MINUS
select 'grant insert on '||owner||'.'||table_name    ||' to FINANCE_SELECT;' from dba_tab_privs where owner = 'FINANCE' and privilege = 'INSERT' and grantee = 'FINANCE_SELECT';

SELECT 'grant update on '||owner||'.'||TABLE_NAME    ||' to FINANCE_SELECT;' FROM DBA_TABLES    WHERE OWNER = 'FINANCE'
MINUS
SELECT 'grant update on '||OWNER||'.'||TABLE_NAME    ||' to FINANCE_SELECT;' FROM DBA_TAB_PRIVS WHERE OWNER = 'FINANCE' AND PRIVILEGE = 'UPDATE' AND GRANTEE = 'FINANCE_SELECT';

select 'grant delete on '||owner||'.'||table_name    ||' to FINANCE_SELECT;' from dba_tables    where owner = 'FINANCE'
MINUS
select 'grant delete on '||owner||'.'||table_name    ||' to FINANCE_SELECT;' from dba_tab_privs where owner = 'FINANCE' and privilege = 'DELETE' and grantee = 'FINANCE_SELECT';


--SEQUENCES
SELECT 'grant select on '||SEQUENCE_OWNER||'.'||SEQUENCE_NAME ||' to FINANCE_SELECT;' FROM DBA_SEQUENCES WHERE SEQUENCE_OWNER = 'FINANCE'
MINUS
SELECT 'grant select on '||owner||'.'||TABLE_NAME    ||' to FINANCE_SELECT;' from dba_tab_privs where          owner = 'FINANCE' and PRIVILEGE = 'SELECT' AND GRANTEE = 'FINANCE_SELECT';


--VIEWS
SELECT 'grant select on '||owner||'.'||VIEW_NAME     ||' to FINANCE_SELECT;' FROM DBA_VIEWS     WHERE OWNER = 'FINANCE'
MINUS
select 'grant select on '||owner||'.'||table_name    ||' to FINANCE_SELECT;' from dba_tab_privs where owner = 'FINANCE' and privilege = 'SELECT' and grantee = 'FINANCE_SELECT';


--PACKAGES, PROCEDURES and FUNCTIONS
select 'grant EXECUTE on '||owner||'.'||OBJECT_name  ||' to FINANCE_SELECT;' from dba_objects where OWNER = 'FINANCE' and OBJECT_TYPE IN ('PROCEDURE','FUNCTION','PACKAGE')
MINUS
select 'grant EXECUTE on '||owner||'.'||table_name   ||' to FINANCE_SELECT;' from dba_tab_privs where owner = 'FINANCE' and privilege = 'EXECUTE' and grantee = 'FINANCE_SELECT';