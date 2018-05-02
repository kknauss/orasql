SET TERMOUT on;
	prompt
	prompt  Press ENTER for default (NULL) ...
	prompt
	accept own prompt 'Table owner...... '
	accept tbl prompt 'Table name....... '
SET TERMOUT off;
	COLUMN own NEW_VALUE _own ;
	COLUMN tbl NEW_VALUE _tbl ;
	select case when '&&own' IS NULL then 'ALL'    else upper('&&own') end as own from dual;
	select case when '&&tbl' IS NULL then 'ALL'    else upper('&&tbl') end as tbl from dual;
SET TERMOUT on;

select OWNER, trigger_name, trigger_type, STATUS
from dba_triggers
where (table_owner = '&&_own' OR '&&_own' = 'ALL')
and   (table_name  = '&&_tbl' OR '&&_tbl' = 'ALL') ;
