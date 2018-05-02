column host_name format a18;
column instance_name new_value iname;
column run_timestamp new_value run_tmsp;

set termout off;
select instance_name||'.'||to_char(trunc(sysdate,'MI'),'yyyymmdd_HH24MISS') ||'.sql' from v$instance;
select instance_name, to_char(sysdate,'yyyymmdd_HH24MISS') as run_timestamp from v$instance;
set termout on;


prompt Spooling to:  &iname..&run_tmsp..lst

spool &iname..&run_tmsp..lst;
