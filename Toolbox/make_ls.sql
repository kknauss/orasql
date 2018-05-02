set pagesize 0;
set feedback off;

spool ls.bash;

select 'ls -l '||name from v$controlfile
union
select 'ls -l '||name from v$datafile
union
select 'ls -l '||name from v$tempfile
union
select 'ls -l '||member from v$logfile;

spool off;
