set pagesize 132;
set linesize 132;


select r.owner, r.type, count(*), sum( ((r.space*p.value)/(1024*1024)) ) as space_mb
from dba_recyclebin r, v$parameter p
where p.name = 'db_block_size'
group by r.owner, r.type
order by r.owner, r.type;


prompt Press CTRL-C to exit ...

accept sch prompt 'Enter schema of recycle bin to inspect further: '

select r.object_name, r.original_name, r.type, ((r.space*p.value)/(1024*1024)) as space_mb, r.droptime
from dba_recyclebin r, v$parameter p
where r.owner = upper('&&sch')
and p.name = 'db_block_size'
order by r.droptime desc;


prompt Press CTRL-C to exit ...

set pagesize 0;
set verify off;
set feedback off;


accept sch prompt 'Enter schema of recycle bin to purge: '
accept mth prompt 'Enter number of months to keep:       '

set termout off;
column mydte new_value mydate;
select to_char(sysdate,'yyyymmdd_hh24miss') as mydte from dual;
alter session set nls_date_format = 'mm/dd/yyyy hh24:mi:ss';
set termout on;


spool recyclebin.&&sch..&&mydate..sql ;


select 'spool recyclebin.&&sch..&&mydate..log;' from dual ;

select 'PURGE TABLE '|| OWNER ||'."'|| object_name || '";'
from dba_recyclebin 
where owner = upper('&&sch')
and to_timestamp(droptime,'YYYY-MM-DD:HH24:MI:SS') < (select to_timestamp(add_months(sysdate,(&&mth*-1)),'mm/dd/yyyy hh24:mi:ss') from dual)
and type = 'TABLE'
order by droptime desc;

select 'spool off;' from dual;


spool off;
set verify on;
set feedback on;

pause Press ENTER to purge the recycle bin for schema &&sch ...

@recyclebin.&&sch..&&mydate..sql
