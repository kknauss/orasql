set heading off;
set feedback off;
set verify off;
set escape off;

accept sch prompt 'Enter schema: '
accept rol prompt 'Enter role:   '


column host_name format a18;
column instance_name new_value iname;
column run_timestamp new_value run_tmsp;

set termout off;
select instance_name||'.'||to_char(trunc(sysdate,'MI'),'yyyymmdd_HH24MISS') ||'.sql' from v$instance;
select instance_name, to_char(sysdate,'yyyymmdd_HH24MISS') as run_timestamp from v$instance;
set termout on;


prompt Spooling to:  grant-to-role.&&sch..&&rol..&iname..&run_tmsp..sql

spool grant-to-role.&&sch..&&rol..&iname..&run_tmsp..sql;




--TABLES
select 'grant select on '||owner||'.'||table_name    ||' to &&rol;' from dba_tables    where owner = '&&sch'
MINUS
select 'grant select on '||owner||'.'||table_name    ||' to &&rol;' from dba_tab_privs where owner = '&&sch' and privilege = 'SELECT' and grantee = '&&rol'
ORDER BY 1;

select 'grant insert on '||owner||'.'||table_name    ||' to &&rol;' from dba_tables    where owner = '&&sch'
MINUS
select 'grant insert on '||owner||'.'||table_name    ||' to &&rol;' from dba_tab_privs where owner = '&&sch' and privilege = 'INSERT' and grantee = '&&rol'
ORDER BY 1;

SELECT 'grant update on '||owner||'.'||TABLE_NAME    ||' to &&rol;' FROM DBA_TABLES    WHERE OWNER = '&&sch'
MINUS
select 'grant update on '||owner||'.'||table_name    ||' to &&rol;' from dba_tab_privs where owner = '&&sch' and privilege = 'UPDATE' and grantee = '&&rol'
ORDER BY 1;

select 'grant delete on '||owner||'.'||table_name    ||' to &&rol;' from dba_tables    where owner = '&&sch'
MINUS
select 'grant delete on '||owner||'.'||table_name    ||' to &&rol;' from dba_tab_privs where owner = '&&sch' and privilege = 'DELETE' and grantee = '&&rol'
ORDER BY 1;


--SEQUENCES
SELECT 'grant select on '||SEQUENCE_OWNER||'.'||SEQUENCE_NAME ||' to &&rol;' FROM DBA_SEQUENCES WHERE SEQUENCE_OWNER = '&&sch'
MINUS
SELECT 'grant select on '||owner||'.'||TABLE_NAME    ||' to &&rol;' from dba_tab_privs where          owner = '&&sch' and PRIVILEGE = 'SELECT' AND GRANTEE = '&&rol'
ORDER BY 1;


--VIEWS
SELECT 'grant select on '||owner||'.'||VIEW_NAME     ||' to &&rol;' FROM DBA_VIEWS     WHERE OWNER = '&&sch'
MINUS
select 'grant select on '||owner||'.'||table_name    ||' to &&rol;' from dba_tab_privs where owner = '&&sch' and privilege = 'SELECT' and grantee = '&&rol'
ORDER BY 1;


--PACKAGES, PROCEDURES and FUNCTIONS
select 'grant EXECUTE on '||owner||'.'||OBJECT_name  ||' to &&rol;' from dba_objects where OWNER = '&&sch' and OBJECT_TYPE IN ('PROCEDURE','FUNCTION','PACKAGE')
MINUS
select 'grant EXECUTE on '||owner||'.'||table_name   ||' to &&rol;' from dba_tab_privs where owner = '&&sch' and privilege = 'EXECUTE' and grantee = '&&rol'
ORDER BY 1;








spool off;
set heading on;
set verify on;
set feedback on;
set escape on;
