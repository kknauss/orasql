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
SELECT 'grant select on '||OWNER||'.'||TABLE_NAME    ||' to &&rol;' FROM DBA_TABLES    WHERE OWNER = '&&sch'
MINUS
SELECT 'grant select on '||OWNER||'.'||TABLE_NAME    ||' to &&rol;' FROM DBA_TAB_PRIVS WHERE OWNER = '&&sch' AND PRIVILEGE = 'SELECT' AND GRANTEE = '&&rol'
ORDER BY 1;

--VIEWS
SELECT 'grant select on '||OWNER||'.'||VIEW_NAME     ||' to &&rol;' FROM DBA_VIEWS     WHERE OWNER = '&&sch'
MINUS
SELECT 'grant select on '||OWNER||'.'||TABLE_NAME    ||' to &&rol;' FROM DBA_TAB_PRIVS WHERE OWNER = '&&sch' AND PRIVILEGE = 'SELECT' AND GRANTEE = '&&rol'
ORDER BY 1;



spool off;
set heading on;
set verify on;
set feedback on;
set escape on;
