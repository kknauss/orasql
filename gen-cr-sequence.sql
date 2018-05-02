set heading off;
set feedback off;
set verify off;
set escape off;

accept sch prompt 'Enter schema:   '
accept seq prompt 'Enter sequence: '


column host_name format a18;
column instance_name new_value iname;
column run_timestamp new_value run_tmsp;

set termout off;
select instance_name||'.'||to_char(trunc(sysdate,'MI'),'yyyymmdd_HH24MISS') ||'.sql' from v$instance;
select instance_name, to_char(sysdate,'yyyymmdd_HH24MISS') as run_timestamp from v$instance;
set termout on;


prompt Spooling to:  grant-to-role.&&sch..&&seq..&iname..&run_tmsp..sql

spool create-synonym.&&sch..&&seq..&iname..&run_tmsp..sql;



SELECT 
'DROP SEQUENCE '    || SEQUENCE_OWNER||'.' || SEQUENCE_NAME || ';'
FROM DBA_SEQUENCES
WHERE SEQUENCE_OWNER = '&sch'
AND SEQUENCE_NAME = '&seq';

SELECT 
	'CREATE SEQUENCE '    || SEQUENCE_OWNER||'.' || SEQUENCE_NAME ||
	' INCREMENT BY '      || INCREMENT_BY  ||
	' START WITH '        || (LAST_NUMBER+1) ||
	CASE MAX_VALUE  WHEN 999999999999999999999999999  THEN ' NOMAXVALUE' ELSE ' MAXVALUE '|| MAX_VALUE   END ||
	CASE MIN_VALUE  WHEN                           1  THEN ' NOMINVALUE' ELSE ' MINVALUE '|| MIN_VALUE   END ||
	CASE CYCLE_FLAG WHEN                          'Y' THEN ' CYCLE'      ELSE ' NOCYCLE'                 END ||
	CASE CACHE_SIZE WHEN                           0  THEN ' NOCACHE'    ELSE ' CACHE '   || CACHE_SIZE  END ||
	CASE ORDER_FLAG WHEN                          'Y' THEN ' ORDER'      ELSE ' NOORDER'                 END ||
	';'
FROM DBA_SEQUENCES
WHERE SEQUENCE_OWNER = '&sch'
AND SEQUENCE_NAME = '&seq';


SELECT
	'CREATE OR REPLACE '||
	CASE OWNER WHEN 'PUBLIC' THEN OWNER ELSE '' END ||
	' SYNONYNM '||
	CASE WHEN OWNER <> 'PUBLIC' THEN OWNER||'.' ELSE '' END ||
	SYNONYM_NAME || ' FOR '||TABLE_OWNER||'.'||TABLE_NAME||';'
FROM DBA_SYNONYMS
WHERE TABLE_OWNER = '&sch'
AND TABLE_NAME = '&seq';

SELECT
	'GRANT '||PRIVILEGE||' ON '||OWNER||'.' ||  TABLE_NAME ||' TO '||GRANTEE||
	CASE GRANTABLE WHEN 'YES' THEN ' WITH GRANT OPTION ' ELSE '' END|| ';'
FROM DBA_TAB_PRIVS
WHERE OWNER = '&sch'
AND TABLE_NAME = '&seq';



spool off;
set heading on;
set verify on;
set feedback on;
set escape on;
