col owner format a18;
col directory_name format a32;
col directory_path format a80;

BREAK ON owner ;

select *
from dba_directories
order by owner, directory_name;


CLEAR BREAKS;
