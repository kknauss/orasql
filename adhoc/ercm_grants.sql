SELECT *
FROM DBA_SYNONYMS
WHERE TABLE_OWNER IN ('FIS_RCM_CLASSIC_DB','ERCM')
ORDER BY TABLE_OWNER, TABLE_NAME;

SELECT 'CREATE PUBLIC SYNONYM '||OBJECT_NAME||' FOR '||owner||'.'||OBJECT_NAME||';'
FROM DBA_OBJECTS
WHERE (OBJECT_TYPE IN ('TABLE','VIEW','PROCEDURE','FUNCTION','PACKAGE','SEQUENCE'))
AND OWNER IN ('FIS_RCM_CLASSIC_DB','ERCM')
AND (OBJECT_NAME NOT LIKE 'TMP%')
AND (OBJECT_NAME NOT IN (SELECT SYNONYM_NAME FROM ALL_SYNONYMS WHERE OWNER = 'PUBLIC'));

--==============================================================================
-- FIS_RCM_CLASSIC_DB_USER
--==============================================================================
--TABLES
select 'grant select on '||table_name    ||' to FIS_RCM_CLASSIC_DB_USER;' from dba_tables    where owner = 'FIS_RCM_CLASSIC_DB'
MINUS
select 'grant select on '||table_name    ||' to FIS_RCM_CLASSIC_DB_USER;' from dba_tab_privs where owner = 'FIS_RCM_CLASSIC_DB' and privilege = 'SELECT' and grantee = 'FIS_RCM_CLASSIC_DB_USER';

select 'grant insert on '||table_name    ||' to FIS_RCM_CLASSIC_DB_USER;' from dba_tables    where owner = 'FIS_RCM_CLASSIC_DB'
MINUS
select 'grant insert on '||table_name    ||' to FIS_RCM_CLASSIC_DB_USER;' from dba_tab_privs where owner = 'FIS_RCM_CLASSIC_DB' and privilege = 'INSERT' and grantee = 'FIS_RCM_CLASSIC_DB_USER';

SELECT 'grant update on '||TABLE_NAME    ||' to FIS_RCM_CLASSIC_DB_USER;' FROM DBA_TABLES    WHERE OWNER = 'FIS_RCM_CLASSIC_DB'
MINUS
select 'grant update on '||table_name    ||' to FIS_RCM_CLASSIC_DB_USER;' from dba_tab_privs where owner = 'FIS_RCM_CLASSIC_DB' and privilege = 'UPDATE' and grantee = 'FIS_RCM_CLASSIC_DB_USER';

select 'grant delete on '||table_name    ||' to FIS_RCM_CLASSIC_DB_USER;' from dba_tables    where owner = 'FIS_RCM_CLASSIC_DB'
MINUS
select 'grant delete on '||table_name    ||' to FIS_RCM_CLASSIC_DB_USER;' from dba_tab_privs where owner = 'FIS_RCM_CLASSIC_DB' and privilege = 'DELETE' and grantee = 'FIS_RCM_CLASSIC_DB_USER';


--SEQUENCES
SELECT 'grant select on '||SEQUENCE_NAME ||' to FIS_RCM_CLASSIC_DB_USER;' FROM DBA_SEQUENCES WHERE SEQUENCE_OWNER = 'FIS_RCM_CLASSIC_DB'
MINUS
SELECT 'grant select on '||TABLE_NAME    ||' to FIS_RCM_CLASSIC_DB_USER;' from dba_tab_privs where          owner = 'FIS_RCM_CLASSIC_DB' and PRIVILEGE = 'SELECT' AND GRANTEE = 'FIS_RCM_CLASSIC_DB_USER';


--VIEWS
SELECT 'grant select on '||VIEW_NAME     ||' to FIS_RCM_CLASSIC_DB_USER;' FROM DBA_VIEWS     WHERE OWNER = 'FIS_RCM_CLASSIC_DB'
MINUS
select 'grant select on '||table_name    ||' to FIS_RCM_CLASSIC_DB_USER;' from dba_tab_privs where owner = 'FIS_RCM_CLASSIC_DB' and privilege = 'SELECT' and grantee = 'FIS_RCM_CLASSIC_DB_USER';


--PACKAGES, PROCEDURES and FUNCTIONS
select 'grant EXECUTE on '||OBJECT_name  ||' to FIS_RCM_CLASSIC_DB_USER;' from dba_objects where OWNER = 'FIS_RCM_CLASSIC_DB' and OBJECT_TYPE IN ('PROCEDURE','FUNCTION','PACKAGE')
MINUS
select 'grant EXECUTE on '||table_name   ||' to FIS_RCM_CLASSIC_DB_USER;' from dba_tab_privs where owner = 'FIS_RCM_CLASSIC_DB' and privilege = 'EXECUTE' and grantee = 'FIS_RCM_CLASSIC_DB_USER';



--==============================================================================
-- FIS_RCM_CLASSIC_DB_USER
--==============================================================================
--TABLES
select 'grant select on '||table_name    ||' to ERCM_USER;' from dba_tables    where owner = 'ERCM'
MINUS
select 'grant select on '||table_name    ||' to ERCM_USER;' from dba_tab_privs where owner = 'ERCM' and privilege = 'SELECT' and grantee = 'ERCM_USER';

select 'grant insert on '||table_name    ||' to ERCM_USER;' from dba_tables    where owner = 'ERCM'
MINUS
select 'grant insert on '||table_name    ||' to ERCM_USER;' from dba_tab_privs where owner = 'ERCM' and privilege = 'INSERT' and grantee = 'ERCM_USER';

SELECT 'grant update on '||TABLE_NAME    ||' to ERCM_USER;' FROM DBA_TABLES    WHERE OWNER = 'ERCM'
MINUS
select 'grant update on '||table_name    ||' to ERCM_USER;' from dba_tab_privs where owner = 'ERCM' and privilege = 'UPDATE' and grantee = 'ERCM_USER';

select 'grant delete on '||table_name    ||' to ERCM_USER;' from dba_tables    where owner = 'ERCM'
MINUS
select 'grant delete on '||table_name    ||' to ERCM_USER;' from dba_tab_privs where owner = 'ERCM' and privilege = 'DELETE' and grantee = 'ERCM_USER';


--SEQUENCES
SELECT 'grant select on '||SEQUENCE_NAME ||' to ERCM_USER;' FROM DBA_SEQUENCES WHERE SEQUENCE_OWNER = 'ERCM'
MINUS
SELECT 'grant select on '||TABLE_NAME    ||' to ERCM_USER;' from dba_tab_privs where          owner = 'ERCM' and PRIVILEGE = 'SELECT' AND GRANTEE = 'ERCM_USER';


--VIEWS
SELECT 'grant select on '||VIEW_NAME     ||' to ERCM_USER;' FROM DBA_VIEWS     WHERE OWNER = 'ERCM'
MINUS
select 'grant select on '||table_name    ||' to ERCM_USER;' from dba_tab_privs where owner = 'ERCM' and privilege = 'SELECT' and grantee = 'ERCM_USER';


--PACKAGES, PROCEDURES and FUNCTIONS
select 'grant EXECUTE on '||OBJECT_name  ||' to ERCM_USER;' from dba_objects where OWNER = 'ERCM' and OBJECT_TYPE IN ('PROCEDURE','FUNCTION','PACKAGE')
MINUS
select 'grant EXECUTE on '||table_name   ||' to ERCM_USER;' from dba_tab_privs where owner = 'ERCM' and privilege = 'EXECUTE' and grantee = 'ERCM_USER';