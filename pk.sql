set verify off;
column indexname  format a30;
column tablename  format a30;
column column_name format a16;



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


SELECT owner, CONSTRAINT_NAME, CONSTRAINT_TYPE, STATUS
FROM dba_constraints
where (owner = '&&_own'       OR '&&_own' = 'ALL')
and   (table_name  = '&&_tbl' OR '&&_tbl' = 'ALL')
and constraint_type in ('P','U');


select table_owner||'.'||table_name tablename, index_owner||'.'||index_name indexname, column_name
from dba_ind_columns c
where exists
		(
			select 1 --owner, index_name, uniqueness
			from dba_indexes i
			where (table_owner = '&&_own' OR '&&_own' = 'ALL')
			and   (table_name  = '&&_tbl' OR '&&_tbl' = 'ALL')
			and   index_owner = c.index_owner
			and   index_name  = c.index_name
			and   uniqueness  = 'UNIQUE'
		)
order by index_owner, index_name, column_position;


undef own
undef tbl
set verify on;
