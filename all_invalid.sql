column owner format a18;
column object_name format a48;
column object_type format a24;
column instance_name new_value iname;
column run_timestamp new_value run_tmsp;


set termout off;
select instance_name||'.'||to_char(trunc(sysdate,'MI'),'yyyymmdd_HH24MISS') ||'.sql' from v$instance;
select instance_name, to_char(sysdate,'yyyymmdd_HH24MISS') as run_timestamp from v$instance;
set termout on;

spool all_invalid.&iname..&run_tmsp..log;


select owner, object_name, object_type, status
from dba_objects
where status <> 'VALID'
order by  owner, object_name, object_type, status;

spool off;
