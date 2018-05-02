select sum(bytes) / (1024*1024*1024) DB_SIZE_GB
from (

SELECT 
	name,
	(block_size*file_size_blks) bytes
from v$controlfile
UNION ALL
SELECT 
	member as name,
        bytes
from v$logfile lf, v$log l
where lf.group# = l.group#
UNION ALL
SELECT  
	file_name as name,
        bytes
FROM
        dba_data_files
UNION ALL
SELECT 
	file_name as name,
        bytes
FROM
        dba_temp_files

);
