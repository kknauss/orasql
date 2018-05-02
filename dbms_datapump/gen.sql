select * from dba_directories;

select * from dba_objects where owner = 'LOS' and object_type = 'PROCEDURE';

select * from dba_datapump_jobs;

select * from gv$instance;


select '@impdp.sqlfile.parms.sql 12345 '||owner||' data_pump_dir '||object_type||' '||object_name
from dba_objects
where owner = 'LOS'
and object_type = 'PROCEDURE';