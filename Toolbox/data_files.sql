spool data_files.out ;

set pagesize 66;
set linesize 120;
column file_name format a52;
column tablespace_name format a22;
Accept TSNAME prompt 'Enter the tablespace name: ';

select a.file_id, a.file_name, a.bytes/1024, a.tablespace_name, to_char(b.creation_time, 'yyyy-mm-dd hh24:mi') as ctime
from dba_data_files a, v$datafile b
where a.file_id = b.file#
  and tablespace_name = '&TSNAME'
order by ctime;
--order by file_id;
--order by lower(file_name) ;

spool off ;