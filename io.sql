set pagesize 500;
set linesize 132;

clear col bre buffer

break on REPORT;

comp sum lab Total min lab Minimum max lab Maximum of reads on REPORT;
comp sum lab Total min lab Minimum max lab Maximum of writes on REPORT;
comp sum lab Total min lab Minimum max lab Maximum of total on REPORT;

spool io.log;

select to_char(sysdate,'mm/dd/yyyy hh24:mi:ss') from dual;

col datafile format a80

select name datafile, phyrds reads, phywrts writes, phyrds+phywrts total
from v$datafile a, v$filestat b where a.file# = b.file# order by total desc;

col tempfile format a80

select name tempfile, phyrds reads, phywrts writes, phyrds+phywrts total
from v$tempfile a, v$filestat b where a.file# = b.file# order by total desc;


spool off;
