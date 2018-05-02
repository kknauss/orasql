set pagesize 1024;
set linesize 132;
set verify off;
column object_name format a32;
column status format a10;
column host_name format a18;
column instance_name new_value iname;
column run_timestamp new_value run_tmsp;

set termout off;
select instance_name||'.'||to_char(trunc(sysdate,'MI'),'yyyymmdd_HH24MISS') ||'.sql' from v$instance;
select instance_name, to_char(sysdate,'yyyymmdd_HH24MISS') as run_timestamp from v$instance;
set termout on;

--ool &&tgtSchema..object.profile.&iname..&run_tmsp..log;


prompt Object Count by Status ...
prompt

select owner, status, count(*)
from dba_objects
where owner = upper('&&tgtSchema')
group by  owner, status
order by  owner, status ;


prompt Object Count by Status and Type ...
prompt

select owner, object_type, status, count(*)
from dba_objects
where owner = upper('&&tgtSchema')
group by  owner, object_type, status
order by  owner, object_type, status ;


prompt Invalid Object List ...
prompt

select owner, object_name, object_type
from dba_objects
where owner = upper('&&tgtSchema')
and status <> 'VALID'
order by owner, object_name, object_type;



prompt Trigger Count by Status ...
prompt

select status, count(*)
from dba_triggers
where owner = upper('&&tgtSchema')
group by status;

prompt Disabled Trigger List ...
prompt

select owner, trigger_name, trigger_type, table_owner, table_name
from dba_triggers
where owner = upper('&&tgtSchema')
and status <> 'ENABLED';


prompt Constraint Count by Status ...
prompt

select status, count(*)
from dba_constraints
where owner = upper('&&tgtSchema')
and constraint_type <> '?'
and table_name not liKE 'BIN$%'
group by status;


prompt Disabled Constraint List ...
prompt

select owner, constraint_name, constraint_type, table_name, to_char(LAST_CHANGE,'mm/dd/yyyy hh24:mi:ss') LAST_CHANGE
from dba_constraints
where owner = upper('&&tgtSchema')
and status <> 'ENABLED'
and table_name not liKE 'BIN$%'
and constraint_type <> '?';


--ool off;
