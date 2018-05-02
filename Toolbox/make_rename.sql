set pagesize  55;
set linesize 132;
set feedback  on;
column host_name format a18;
column host_name format a18;
column instance_name new_value iname;
column run_timestamp new_value run_tmsp;

set termout off;
select instance_name, to_char(sysdate,'yyyymmdd_HH24MISS') as run_timestamp from v$instance;
set termout on;

set verify off;
set pagesize 0;
set linesize 132;
set feedback off;

accept that_fs_qual prompt 'Source database file system qualifier....'
accept this_fs_qual prompt 'Target database file system qualifier....'

column myorder noprint;

spool rename_files_&iname..&run_tmsp..sql


select 'spool rename_files.'||trim(lower(instance_name))||'.'||to_char(sysdate,'yyyymmdd_hh24miss')||'.lst;' from v$instance;

select 1 myorder, 'alter database rename file '''||name||''' to '''||replace(name,'/&that_fs_qual/','/&this_fs_qual/')||''';' command
from v$datafile
union
select 2 myorder, 'alter database rename file '''||name||''' to '''||replace(name,'/&that_fs_qual/','/&this_fs_qual/')||''';' command
from v$tempfile
union
select 3 myorder, 'alter database rename file '''||member||''' to '''||replace(member,'/&that_fs_qual/','/&this_fs_qual/')||''';' command
from v$logfile
order by myorder;

--lect 'spool off;' from dual;

select '--nid target=SYS/SYS dbname=&this_fs_qual' from dual;



spool off;
set pagesize 55;
set feedback on;
