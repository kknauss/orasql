col name format a80
SET VERIFY off;
UNDEF fname
SET TERMOUT on;
	prompt
	prompt  Press ENTER for default (NULL) ...
	prompt
	accept fname  prompt 'File name........ '
SET TERMOUT off;
	COLUMN fname  NEW_VALUE _fname ;
	select case when '&&fname'  IS NULL then 'ALL' else     upper('&&fname')  end as fname  from dual;
SET TERMOUT on;

select type, name
from (
	SELECT 'CONTROLFILE' type, name
	from v$controlfile
	UNION ALL
	SELECT 'REDOLOG', member
	from v$logfile
	UNION ALL
	SELECT  'DATAFILE', file_name
	FROM dba_data_files
	UNION ALL
	SELECT 'TEMPFILE', file_name
	FROM dba_temp_files
)
WHERE( upper(name) like '%&&_fname%'   OR  'ALL' = '&&_fname' )
ORDER BY name;

UNDEF fname
