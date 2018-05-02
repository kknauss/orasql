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

spool set_newname_&iname..&run_tmsp..rmn




select 'run {'                                     from dual;

select 1 myorder, 'set newname for datafile '||file#||' to '''||replace(name,'/&that_fs_qual/','/&this_fs_qual/')||''';' command
from v$datafile
union
select 2 myorder, 'SQL "alter database rename file '''''||name||''''' to '''''||replace(name,'/&that_fs_qual/','/&this_fs_qual/')||'''''";' command
from v$tempfile
union
select 3 myorder, 'SQL "alter database rename file '''''||member||''''' to '''''||replace(member,'/&that_fs_qual/','/&this_fs_qual/')||'''''";' command
from v$logfile
order by myorder;

select 'restore database;'                         from dual;
select 'switch datafile all;'                      from dual;
select 'alter database open resetlogs;'            from dual;
select '# nid target=SYS/SYS dbname=&this_fs_qual' from dual;
select '}'                                         from dual;



spool off;
set pagesize 55;
set feedback on;
