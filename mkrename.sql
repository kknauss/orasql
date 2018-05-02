set pagesize 0;
set linesize 132;
set feedback off;

column myorder noprint;

spool rename_files.sql;

select 1 myorder, 'alter database rename file '''||name||''' to '''||replace(name,'/sercm/','/tercm/')||''';' command
from v$datafile
union
select 2 myorder, 'alter database rename file '''||name||''' to '''||replace(name,'/sercm/','/tercm/')||''';' command
from v$tempfile
union
select 3 myorder, 'alter database rename file '''||member||''' to '''||replace(member,'/sercm/','/tercm/')||''';' command
from v$logfile
order by myorder;

spool off;
set pagesize 55;
set feedback on;
