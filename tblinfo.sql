UNDEF usernm

SET TERMOUT on;
	prompt
	prompt  Press ENTER for default (NULL) ...
	prompt
	accept ownr prompt 'Table owner...... '
	accept tbln prompt 'Table name...... '
SET TERMOUT off;
	COLUMN ownr NEW_VALUE _ownr ;
	COLUMN tbln NEW_VALUE _tbln ;

	select case when '&&ownr' IS NULL then 'ALL' else     upper('&&ownr') end as ownr from dual;
	select case when '&&tbln' IS NULL then 'ALL' else     upper('&&tbln') end as tbln from dual;
SET TERMOUT on;




col triggering_event format a32

set verify off;

select owner, table_name, status, last_analyzed, num_rows, blocks, tablespace_name
from dba_tables
where ( owner = '&&_ownr'  OR  'ALL' = '&&_ownr' )
and ( table_name = '&&_tbln'  OR  'ALL' = '&&_tbln' );

select owner, index_name, tablespace_name, VISIBILITY, last_analyzed, status
from dba_indexes
where ( table_owner = '&&_ownr'  OR  'ALL' = '&&_ownr' )
and ( table_name = '&&_tbln'  OR  'ALL' = '&&_tbln' );

col column_name format a28

select c.index_name, c.column_name, c.column_position 
from dba_ind_columns c
where exists (
			select 1
			from dba_indexes i
			where ( i.table_owner = '&&_ownr'  OR  'ALL' = '&&_ownr' )
			and ( i.table_name = '&&_tbln'  OR  'ALL' = '&&_tbln' )
			and i.owner = c.index_owner
			and i.index_name = c.index_name
	);

select owner, trigger_name, TRIGGERING_EVENT, ACTION_TYPE, STATUS --, trigger_body
from dba_triggers
where ( table_owner = '&&_ownr'  OR  'ALL' = '&&_ownr' )
and ( table_name = '&&_tbln'  OR  'ALL' = '&&_tbln' );


set verify on;
