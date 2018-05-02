set pagesize 1024;
set linesize 132;
set verify off;
column object_name format a32;
column status format a10;
column host_name format a18;
column instance_name new_value iname;
column run_timestamp new_value run_tmsp;

select owner, object_type, count(*)
from dba_objects
where owner = upper('&&tgtSchema')
group by  owner, object_type
order by  owner, object_type ;
